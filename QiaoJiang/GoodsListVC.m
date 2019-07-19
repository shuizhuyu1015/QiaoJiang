//
//  GoodsListVC.m
//  QiaoJiang
//
//  Created by GL on 2019/7/12.
//  Copyright © 2019年 GL. All rights reserved.
//

#import "GoodsListVC.h"
#import "ProductDisplayCell.h"

static NSString *ProductDisplayCellID = @"ProductDisplayCellID";

@interface GoodsListVC () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation GoodsListVC
{
    int _offset;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.collectionView];
    adjustsScrollViewInsets_NO(self.collectionView, self);
    
    _offset = 0;
    [self loadNetworkData];
    
}

-(void)loadNetworkData {
    switch (self.sourceType) {
        case GoodsSourceTypeProductSimple:
            [self getGoodsByIds];
            break;
        case GoodsSourceTypeSearchList:
            [self getGoodsBySearchId];
            break;
        case GoodsSourceTypeSearchDiscount:
            [self getGoodsDiscounted];
            break;
        default:
            break;
    }
}

#pragma mark - 通过商品ids查找
-(void)getGoodsByIds {
    [[HDNetworking sharedHDNetworking] POST:GET_PRODUCTS_BY_IDS parameters:self.ids success:^(id  _Nonnull responseObject) {
        if ([self.collectionView.mj_header isRefreshing]) {
            [self.dataSource removeAllObjects];
        }
        if ([responseObject[@"code"] intValue] == 200) {
            NSArray *dataArr = responseObject[@"data"];
            for (NSDictionary *productDic in dataArr) {
                ProductDisplayModel *model = [[ProductDisplayModel alloc] initWithDictionary:productDic error:nil];
                [self.dataSource addObject:model];
            }
        }
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 通过listId查找
-(void)getGoodsBySearchId {
    NSString *url = [NSString stringWithFormat:GET_PRODUCT_LIST, self.searchId, _offset];
    [[HDNetworking sharedHDNetworking] GET:url parameters:nil success:^(id  _Nonnull responseObject) {
        if ([self.collectionView.mj_header isRefreshing]) {
            [self.dataSource removeAllObjects];
        }
        if ([responseObject[@"code"] intValue] == 200) {
            NSArray *dataArr = responseObject[@"data"][@"list"][@"items"];
            if (dataArr && dataArr.count) {
                for (NSDictionary *goodsDic in dataArr) {
                    ProductDisplayModel *model = [[ProductDisplayModel alloc] initWithDictionary:goodsDic error:nil];
                    [self.dataSource addObject:model];
                }
                [self.collectionView.mj_footer endRefreshing];
            }else{
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 折扣商品
-(void)getGoodsDiscounted {
    NSString *url = [NSString stringWithFormat:GET_DISCOUNT_PRODUCT, _offset];
    
    [[HDNetworking sharedHDNetworking] GET:url parameters:nil success:^(id  _Nonnull responseObject) {
        if ([self.collectionView.mj_header isRefreshing]) {
            [self.dataSource removeAllObjects];
        }
        if ([responseObject[@"code"] intValue] == 200) {
//            NSArray *dataArr = responseObject[@"data"][@"list"][@"items"];
//            for (NSDictionary *goodsDic in dataArr) {
//                ProductDisplayModel *model = [[ProductDisplayModel alloc] initWithDictionary:goodsDic error:nil];
//                [self.dataSource addObject:model];
//            }
//            [self.collectionView.mj_footer endRefreshing];
        }else{
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - collectionView代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductDisplayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ProductDisplayCellID forIndexPath:indexPath];
    [cell refreshUI:self.dataSource[indexPath.item]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    ProductDisplayModel *model = self.dataSource[indexPath.item];
    NSLog(@"%@", model.name);
    
}

#pragma mark - 懒加载
-(NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

-(UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(WID/2-1, 283);
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
        flowLayout.minimumInteritemSpacing = 2;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WID, HEI-kTopHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"ProductDisplayCell" bundle:nil] forCellWithReuseIdentifier:ProductDisplayCellID];
        @WeakObj(self)
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @StrongObj(self)
            self->_offset = 0;
            [self loadNetworkData];
        }];
        
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @StrongObj(self)
            self->_offset ++;
            [self loadNetworkData];
        }];
    }
    return _collectionView;
}


@end
