//
//  FavoriteGoodsVC.m
//  QiaoJiang
//
//  Created by Gray on 2019/7/21.
//  Copyright © 2019年 GL. All rights reserved.
//

#import "FavoriteGoodsVC.h"
#import "FavoriteCell.h"
#import "GLEmptyDataView.h"
#import "UITableView+EmptyPlaceHolder.h"

#import "GoodsDetailVC.h"

static NSString *FavoriteGoodsCellID = @"FavoriteGoodsCellID";

@interface FavoriteGoodsVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) GLEmptyDataView *noDataView;

@end

@implementation FavoriteGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"喜欢";
    
    [self.view addSubview:self.tableView];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
}

#pragma mark - 加载数据
-(void)loadData {
    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
    NSArray *collectedArr = [userDefault objectForKey:COLLECTED_PRODUCTS];
    if (collectedArr == nil) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [[HDNetworking sharedHDNetworking] POST:GET_PRODUCTS_BY_IDS parameters:collectedArr success:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.dataSource removeAllObjects];
        if ([responseObject[@"code"] intValue] == 200) {
            NSArray *dataArr = responseObject[@"data"];
            for (NSDictionary *productDic in dataArr) {
                ProductDisplayModel *model = [[ProductDisplayModel alloc] initWithDictionary:productDic error:nil];
                [self.dataSource addObject:model];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - tableview代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [tableView tableViewDisplayView:self.noDataView ifNecessaryForRowCount:self.dataSource.count];
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:FavoriteGoodsCellID forIndexPath:indexPath];
    ProductDisplayModel *model = self.dataSource[indexPath.section];
    [cell refreshUI:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 107;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除沙盒中当前行的ID
        ProductDisplayModel *model = self.dataSource[indexPath.section];
        NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
        NSArray *collectedArr = [userDefault objectForKey:COLLECTED_PRODUCTS];
        NSMutableArray *arrM = [[NSMutableArray alloc] initWithArray:collectedArr];
        [arrM removeObject:model.productId];
        [userDefault setObject:arrM forKey:COLLECTED_PRODUCTS];
        [userDefault synchronize];
        //删除数据源当前行数据
        [self.dataSource removeObjectAtIndex:indexPath.section];
        //删除当前行
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProductDisplayModel *model = self.dataSource[indexPath.section];
    
    GoodsDetailVC *dvc = [[GoodsDetailVC alloc] init];
    dvc.productId = model.productId;
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark - lazy
-(NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WID, HEI-kTopHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"FavoriteCell" bundle:nil] forCellReuseIdentifier:FavoriteGoodsCellID];
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    }
    return _tableView;
}

-(GLEmptyDataView *)noDataView {
    if (_noDataView == nil) {
        _noDataView = [[GLEmptyDataView alloc] initWithFrame:self.tableView.bounds];
    }
    return _noDataView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
