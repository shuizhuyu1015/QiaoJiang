//
//  SearchViewController.m
//  QiaoJiang
//
//  Created by administrator on 16/4/4.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import "SearchViewController.h"
#import "interface.h"
#import "RecommendModel.h"
#import "IdeaModel.h"
#import "CreativeCell.h"
#import "RecDetailViewController.h"
#import "IdeaDetailViewController.h"
#import "UserViewController.h"

#define kScreenSize [UIScreen mainScreen].bounds.size

@interface SearchViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>
@property (strong, nonatomic) UISearchBar *searchBar;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) NSInteger page;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //searchBar放到view再放到titleView上
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width-110, 25)];
    titleView.layer.cornerRadius = 8;
    titleView.clipsToBounds = YES;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(titleView.frame), 25)];
    UIColor *color = self.navigationController.navigationBar.barTintColor;
    self.searchBar.barTintColor = color;
    self.searchBar.tintColor=[UIColor blueColor];
    self.searchBar.placeholder = @"搜你想要的";
    self.searchBar.delegate = self;
    
    [titleView addSubview:self.searchBar];
    self.navigationItem.titleView = titleView;
    
    //右边搜索放大镜
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(beginSearch:)];

    //搜索结果提示的label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kScreenSize.width-250)/2, 150, 250, 50)];
    label.text = @"(￣(工)￣)没有任何搜索结果额!";
    label.textColor = [UIColor grayColor];
    [self.view addSubview:label];
    
    self.page = 1;
}

-(void)beginSearch:(UIBarButtonItem *)bbi
{
    [self.dataSource removeAllObjects];
    [self loadNetworkData];
    [self.searchBar resignFirstResponder];
}
#pragma mark- UISearchBarDelegate
//searchBar text改变时page还原为1
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.page = 1;
}
//点击键盘搜索按钮时回调
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.dataSource removeAllObjects];
    [self loadNetworkData];
    [searchBar resignFirstResponder];
}


//请求网络
-(void)loadNetworkData
{
    NSString *searchUrl = [NSString stringWithFormat:self.url,self.page, self.searchBar.text];
    searchUrl = [searchUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",searchUrl);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"我正在努力..";
    
    [[NetworkHelper shareInstance] Get:searchUrl parameter:nil success:^(id responseObject) {

        if ([_collectionView.mj_header isRefreshing]) {
            [self.dataSource removeAllObjects];
        }
        
        if ([self.url isEqualToString:kRecSearch]) {
            NSArray *tmpArr = responseObject[@"data"][@"guides"];
            //判断数组是否为null
            if (![tmpArr isEqual:[NSNull null]]) {
                for (NSDictionary *dic in responseObject[@"data"][@"guides"]) {
                    RecommendModel *rm = [[RecommendModel alloc] initWithDictionary:dic error:nil];
                    [self.dataSource addObject:rm];
                }
                [_collectionView.mj_footer endRefreshing];
            }else{
                [_collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            if ([responseObject[@"data"][@"cases"] count] == 0) {
                [_collectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                for (NSDictionary *dic in responseObject[@"data"][@"cases"]) {
                    IdeaModel *im = [[IdeaModel alloc] initWithDictionary:dic error:nil];
                    [self.dataSource addObject:im];
                }
                [_collectionView.mj_footer endRefreshing];
            }
        }
        
        if (!_collectionView) {
            [self createCollectionView]; //如果collection不存在,创建
        }
        [_collectionView reloadData];
        [_collectionView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.view.bounds) - 20, 266);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width,kScreenSize.height-64) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:238/255.0 alpha:1.0];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"CreativeCell" bundle:nil] forCellWithReuseIdentifier:@"CreativeCellID"];
    
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self loadNetworkData];
    }];
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [self loadNetworkData];
    }];
    
    [self.view addSubview:_collectionView];
}

#pragma mark - collectionView代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CreativeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CreativeCellID" forIndexPath:indexPath];
    [cell refreshModel:self.dataSource[indexPath.item]];
    @WeakObj(self)
    cell.block = ^void(NSString *user_id){
        UserViewController *uvc = [[UserViewController alloc] init];
        uvc.user_id = user_id;
        if ([selfWeak.url isEqualToString:kIdeaSearch]) {
            uvc.url = kIdeaUser;
        }else if ([selfWeak.url isEqualToString:kRecSearch]){
            uvc.url = kRecomUser;
        }
        uvc.hidesBottomBarWhenPushed = YES;
        [selfWeak.navigationController pushViewController:uvc animated:YES];
    };
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.url isEqualToString:kRecSearch]) {
        RecDetailViewController *rvc = [[RecDetailViewController alloc] init];
        rvc.tid = [self.dataSource[indexPath.item] tid];
        rvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rvc animated:YES];
    }else{
        IdeaDetailViewController *idv = [[IdeaDetailViewController alloc] init];
        idv.group_id = [self.dataSource[indexPath.item] group_id];
        idv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:idv animated:YES];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.searchBar resignFirstResponder];
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
