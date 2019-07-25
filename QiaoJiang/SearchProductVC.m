//
//  SearchProductVC.m
//  QiaoJiang
//
//  Created by Gray on 2019/7/24.
//  Copyright © 2019年 GL. All rights reserved.
//

#import "SearchProductVC.h"
#import "PYSearchView.h"
#import "ProductDisplayCell.h"
#import "GLEmptyDataView.h"
#import "UICollectionView+NoData.h"

#import "GoodsDetailVC.h"

static NSString *SearchedCellID = @"SearchedCellID";

@interface SearchProductVC () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic, strong) GLEmptyDataView *noDataView;

@end

@implementation SearchProductVC
{
    int _offset;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //searchBar放到view再放到titleView上
    PYSearchView *titleView = [[PYSearchView alloc] initWithFrame:CGRectMake(0, 0, WID-110, 30)];
    titleView.layer.cornerRadius = 15;
    titleView.clipsToBounds = YES;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(titleView.frame), 30)];
    UIColor *color = self.navigationController.navigationBar.barTintColor;
    self.searchBar.barTintColor = color;
    self.searchBar.tintColor=[UIColor grayColor];
    self.searchBar.placeholder = @"搜你想要的";
    self.searchBar.delegate = self;
    
    [titleView addSubview:self.searchBar];
    self.navigationItem.titleView = titleView;
    
    //右边搜索放大镜
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(beginSearch:)];
    
    _offset = 0;
    [self.view addSubview:self.collectionView];
}

//点击放大镜
-(void)beginSearch:(UIBarButtonItem *)bbi
{
    [self.dataSource removeAllObjects];
    [self loadNetworkData];
    [self.searchBar resignFirstResponder];
}

#pragma mark- UISearchBarDelegate
//searchBar text改变时偏移量归0
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _offset = 0;
}
//点击键盘搜索按钮时回调
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.dataSource removeAllObjects];
    [self loadNetworkData];
    [searchBar resignFirstResponder];
}

#pragma mark - 请求网络数据
-(void)loadNetworkData {
    NSString *paraStr = [NSString stringWithFormat:@"?keyword=%@&limit=20&offset=%d&sortField=SYNTHESIS&sortOrder=DESC", self.searchBar.text, _offset];
    NSString *url = [NSString stringWithFormat:@"%@%@", SEARCH_PRODUCT_PATH, paraStr];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
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
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }];
}

#pragma mark - collectionView代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    [collectionView displayView:self.noDataView ifNecessaryForItemCount:self.dataSource.count];
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductDisplayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SearchedCellID forIndexPath:indexPath];
    [cell refreshUI:self.dataSource[indexPath.item]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    ProductDisplayModel *model = self.dataSource[indexPath.item];
    
    GoodsDetailVC *dvc = [[GoodsDetailVC alloc] init];
    dvc.productId = model.productId;
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark - lazy
-(UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(WID/2-2, 283);
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
        flowLayout.minimumInteritemSpacing = 2;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WID, HEI-kTopHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"ProductDisplayCell" bundle:nil] forCellWithReuseIdentifier:SearchedCellID];
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
        _collectionView.mj_footer.automaticallyHidden = YES;
    }
    return _collectionView;
}

-(NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

-(GLEmptyDataView *)noDataView {
    if (_noDataView == nil) {
        _noDataView = [[GLEmptyDataView alloc] initWithFrame:self.collectionView.bounds];
    }
    return _noDataView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
