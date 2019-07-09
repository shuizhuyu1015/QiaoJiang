//
//  JingXuanViewController.m
//  QiaoJiang
//
//  Created by mac on 16/3/17.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import "JingXuanViewController.h"
#import "interface.h"
#import "FooterView.h"
#import "HeaderView.h"
#import "GLScrollView.h"
#import "JingXuanCell.h"
#import "JingXuanModel.h"
#import "IdeaModel.h"
#import "ProductViewController.h"
#import "SpecialViewController.h"
#import "IdeaDetailViewController.h"
#import "ClassifyViewController.h"

@interface JingXuanViewController () <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *arrM; //广告图数组

@end

@implementation JingXuanViewController
{
    GLScrollView *sv;
}

//布局UI
-(void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-49-64) style:UITableViewStyleGrouped];
    
    sv = [[GLScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), 200)];
    [self loadBannerData]; //请求表头数据
    __weak UIViewController *vc = self;
    sv.block = ^void(NSString *group_id){
        NSLog(@"%@",group_id);
        IdeaDetailViewController *dvc = [[IdeaDetailViewController alloc] init];
        dvc.group_id = group_id;
        dvc.hidesBottomBarWhenPushed = YES;
        [vc.navigationController pushViewController:dvc animated:YES];
    };
    _tableView.tableHeaderView = sv;
    
    [_tableView registerNib:[UINib nibWithNibName:@"JingXuanCell" bundle:nil] forCellReuseIdentifier:@"JingXuanCellID"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"HeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"headerViewID"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"FooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"footerViewID"];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadBannerData]; //请求表头数据
        [self loadNetworkData];
    }];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollsToTop = YES;
    
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //返回键只保留箭头
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    //item字体颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //title字体属性
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    //状态栏白字
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [self loadNetworkData];
}

-(void)loadBannerData
{
    NSInteger page = 1;
    [[NetworkHelper shareInstance] Get:[NSString stringWithFormat:kIdea,page] parameter:nil success:^(id responseObject) {
        if ([_tableView.mj_header isRefreshing]) {
            [self.arrM removeAllObjects];
        }
        for (NSDictionary *dic in responseObject[@"data"][@"cases"]) {
            IdeaModel *im = [[IdeaModel alloc] initWithDictionary:dic error:nil];
            [self.arrM addObject:im];
        }
        sv.imageArr = self.arrM;
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
    }];
}

-(void)loadNetworkData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载中";
    
    [[NetworkHelper shareInstance] Get:kShop parameter:nil success:^(id responseObject) {
        if ([_tableView.mj_header isRefreshing]) {
            [self.dataSource removeAllObjects];
        }

        for (NSDictionary *dic in responseObject[@"data"][@"items"]) {
            JingXuanModel *jxm = [[JingXuanModel alloc] initWithDictionary:dic error:nil];
                [self.dataSource addObject:jxm];
        }
        
        if (!_tableView) {
            [self initTableView]; //请求数据成功，创建tableView
        }else{
            [_tableView reloadData];
        }

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - tableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JingXuanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JingXuanCellID" forIndexPath:indexPath];
    JingXuanModel *jxm = self.dataSource[indexPath.section];
    cell.dataSource = jxm.windowSpecialItemList;
    cell.block = ^void(NSInteger productId){
        NSLog(@"%ld",productId);
        ProductViewController *pvc = [[ProductViewController alloc] init];
        pvc.productId = productId;
        pvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pvc animated:YES];
    };
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerViewID"];
    [headerView refreshUI:self.dataSource[section]];
    
    headerView.block = ^void(void){
        SpecialViewController *svc = [[SpecialViewController alloc] init];
        svc.productSpecialId = [self.dataSource[section] productSpecialId];
        svc.productSpecialName = [self.dataSource[section] productSpecialName];
        svc.naviAppImg = [self.dataSource[section] naviAppImg];
        svc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:svc animated:YES];
    };
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    FooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footerViewID"];
    footerView.dataSource = [self.dataSource[section] footers];
    footerView.block = ^void(NSInteger category1Id, NSInteger category2Id){
        NSLog(@"%ld,%ld",category1Id,category2Id);
        ClassifyViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"cvcID"];
        cvc.category1Id = category1Id;
        cvc.category2Id = category2Id;
        [self.navigationController pushViewController:cvc animated:YES];
    };
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 320;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 150;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

-(NSMutableArray *)arrM
{
    if (_arrM == nil) {
        _arrM = [[NSMutableArray alloc] init];
    }
    return _arrM;
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
