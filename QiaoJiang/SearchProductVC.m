//
//  SearchProductVC.m
//  QiaoJiang
//
//  Created by Gray on 2019/7/24.
//  Copyright © 2019年 GL. All rights reserved.
//

#import "SearchProductVC.h"
#import "PYSearchView.h"

@interface SearchProductVC () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation SearchProductVC

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
}

//点击放大镜
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
//    self.page = 1;
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
