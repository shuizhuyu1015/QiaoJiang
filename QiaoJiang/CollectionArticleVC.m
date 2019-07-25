//
//  CollectionArticleVC.m
//  QiaoJiang
//
//  Created by GL on 2019/7/22.
//  Copyright © 2019年 GL. All rights reserved.
//

#import "CollectionArticleVC.h"
#import "FavoriteCell.h"
#import "GLEmptyDataView.h"
#import "UITableView+EmptyPlaceHolder.h"

#import "IdeaDetailViewController.h"
#import "RecDetailViewController.h"

static NSString *CollectionCellID = @"CollectionCellID";

@interface CollectionArticleVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *allkeys;
@property (nonatomic, strong) NSMutableArray *allValues;
@property (nonatomic, strong) GLEmptyDataView *noDataView;

@end

@implementation CollectionArticleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"收藏";
    
    [self.view addSubview:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
}

#pragma mark - 加载数据
-(void)loadData {
    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
    NSData *collectedData = [userDefault objectForKey:COLLECTED_IDEA];
    NSDictionary *collectedDic = [NSKeyedUnarchiver unarchiveObjectWithData:collectedData];
    NSLog(@"data = %@", collectedDic);
    if (!collectedDic) {
        return;
    }
    [self.allkeys removeAllObjects];
    [self.allValues removeAllObjects];
    if (collectedDic.count) {
        [self.allkeys addObjectsFromArray:collectedDic.allKeys];
        [self.allValues addObjectsFromArray:collectedDic.allValues];
    }
    
    [self.tableView reloadData];
}

#pragma mark - tableview代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [tableView tableViewDisplayView:self.noDataView ifNecessaryForRowCount:self.allValues.count];
    return self.allValues.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:CollectionCellID forIndexPath:indexPath];
    [cell refreshUI:self.allValues[indexPath.section]];
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
        
        NSString *currentKey = self.allkeys[indexPath.section];
        
        //删除沙盒中当前行数据
        NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
        NSData *collectedData = [userDefault objectForKey:COLLECTED_IDEA];
        NSDictionary *collectedDic = [NSKeyedUnarchiver unarchiveObjectWithData:collectedData];
        
        NSMutableDictionary *dicM = [[NSMutableDictionary alloc] initWithDictionary:collectedDic];
        [dicM removeObjectForKey:currentKey];
        
        NSData *allData = [NSKeyedArchiver archivedDataWithRootObject:dicM];
        [userDefault setObject:allData forKey:COLLECTED_IDEA];
        [userDefault synchronize];
        
        //删除数据源当前行数据
        [self.allkeys removeObjectAtIndex:indexPath.section];
        [self.allValues removeObjectAtIndex:indexPath.section];
        
        //删除当前行view
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id model = self.allValues[indexPath.section];
    if ([model isKindOfClass:[Case class]]) {
        Case *cModel = model;
        IdeaDetailViewController *idv = [[IdeaDetailViewController alloc] init];
        idv.group_id = cModel.group_id;
        [self.navigationController pushViewController:idv animated:YES];
    }else if ([model isKindOfClass:[RecDetailModel class]]) {
        RecDetailModel *rModel = model;
        RecDetailViewController *rdv = [[RecDetailViewController alloc] init];
        rdv.tid = rModel.tid;
        [self.navigationController pushViewController:rdv animated:YES];
    }
}

#pragma mark - lazy
-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WID, HEI-kTopHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"FavoriteCell" bundle:nil] forCellReuseIdentifier:CollectionCellID];
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    }
    return _tableView;
}

-(NSMutableArray *)allValues {
    if (_allValues == nil) {
        _allValues = [[NSMutableArray alloc] init];
    }
    return _allValues;
}

-(NSMutableArray *)allkeys {
    if (_allkeys == nil) {
        _allkeys = [[NSMutableArray alloc] init];
    }
    return _allkeys;
}

-(GLEmptyDataView *)noDataView {
    if (_noDataView == nil) {
        _noDataView = [[GLEmptyDataView alloc] initWithFrame:self.tableView.bounds];
    }
    return _noDataView;
}

@end
