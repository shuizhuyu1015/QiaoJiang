//
//  UserViewController.m
//  QiaoJiang
//
//  Created by mac on 16/4/6.
//  Copyright © 2016年 GL. All rights reserved.
//

#import "UserViewController.h"
#import "CreativeCell.h"
#import "interface.h"
#import "IdeaModel.h"
#import "RecommendModel.h"
#import "UserHeaderView.h"
#import "IdeaDetailViewController.h"
#import "RecDetailViewController.h"

@interface UserViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) UserHeaderView *hv;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"小匠";
    
    [self loadHeaderViewData];
    self.page = 1;
    [self loadNetworkData];
}

//请求头图数据
-(void)loadHeaderViewData
{
    NSString *url = [NSString stringWithFormat:kUserInfo,self.user_id];
    [[HDNetworking sharedHDNetworking] GET:url parameters:nil success:^(id  _Nonnull responseObject) {
        _hv.name.text = responseObject[@"data"][@"user"][@"user_name"];
        [_hv.userImage sd_setImageWithURL:[NSURL URLWithString:responseObject[@"data"][@"user"][@"pic"]] placeholderImage:[UIImage imageNamed:@"default_item"]];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

//请求正文数据
-(void)loadNetworkData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"好货多多..";
    
    NSString *url = [NSString stringWithFormat:self.url,self.page,self.user_id];
    [[HDNetworking sharedHDNetworking] GET:url parameters:nil success:^(id  _Nonnull responseObject) {
        if ([_collectionView.mj_header isRefreshing]) {
            [self.dataSource removeAllObjects];
        }
        
        if ([self.url isEqualToString:kIdeaUser]) {
            NSArray *tmpArr = responseObject[@"data"][@"cases"];
            if (tmpArr.count == 0) {
                [_collectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                for (NSDictionary *dic in tmpArr) {
                    IdeaModel *im = [[IdeaModel alloc] initWithDictionary:dic error:nil];
                    [self.dataSource addObject:im];
                }
                [_collectionView.mj_footer endRefreshing];
            }
            
        }else if ([self.url isEqualToString:kRecomUser]){
            NSArray *tmpArr = responseObject[@"data"][@"guides"];
            if (tmpArr.count == 0) {
                [_collectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                for (NSDictionary *dic in tmpArr) {
                    RecommendModel *rm = [[RecommendModel alloc] initWithDictionary:dic error:nil];
                    [self.dataSource addObject:rm];
                }
                [_collectionView.mj_footer endRefreshing];
            }
        }
        if (!_collectionView) {
            [self createCollectionView];
        }else{
            [_collectionView reloadData];
        }
        
        [_collectionView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError * _Nonnull error) {
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//创建tableView
-(void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
    flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.view.bounds)-16, 266);
    flowLayout.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 180);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"CreativeCell" bundle:nil] forCellWithReuseIdentifier:@"CreativeCellID"];;
    [_collectionView registerNib:[UINib nibWithNibName:@"UserHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UserHeaderViewID"];
    
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self loadNetworkData];
    }];
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [self loadNetworkData];
    }];

    _collectionView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - tableView代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CreativeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CreativeCellID" forIndexPath:indexPath];
    [cell refreshModel:self.dataSource[indexPath.item]];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        _hv = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UserHeaderViewID" forIndexPath:indexPath];
        [self loadHeaderViewData];
        return _hv;
    }else{
        return nil;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.url isEqualToString:kIdeaUser]) {
        IdeaDetailViewController *ivc = [[IdeaDetailViewController alloc] init];
        ivc.group_id = [self.dataSource[indexPath.item] group_id];
        ivc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ivc animated:YES];
    }else if ([self.url isEqualToString:kRecomUser]){
        RecDetailViewController *rdv = [[RecDetailViewController alloc] init];
        rdv.tid = [self.dataSource[indexPath.item] tid];
        rdv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rdv animated:YES];
    }
}

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
