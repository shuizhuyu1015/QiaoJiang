//
//  MyViewController.m
//  QiaoJiang
//
//  Created by mac on 16/3/24.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import "MyViewController.h"
#import "DefaultModuleCell.h"
#import "FavoriteGoodsVC.h"

#import "SettingViewController.h"
#import "CollectionArticleVC.h"

static NSString *DefaultModuleCellID = @"DefaultModuleCellID";

@interface MyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSoure;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(300*(HEI/667), 0, 100, 0);
}

- (IBAction)clickSetBtn:(UIBarButtonItem *)sender {
    SettingViewController *svc = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
}

#pragma mark - tableview代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return self.dataSoure.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorColor = [UIColor colorWithHexString:@"e2e2e2"];
    DefaultModuleCell *cell = [tableView dequeueReusableCellWithIdentifier:DefaultModuleCellID forIndexPath:indexPath];
    NSDictionary *contentDic = self.dataSoure[indexPath.row];
    [cell refreshIcon:contentDic[@"image"] title:contentDic[@"title"]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        FavoriteGoodsVC *fvc = [[FavoriteGoodsVC alloc] init];
        [self.navigationController pushViewController:fvc animated:YES];
    }else{
        CollectionArticleVC *cvc = [[CollectionArticleVC alloc] init];
        [self.navigationController pushViewController:cvc animated:YES];
    }
}

#pragma mark - lazy
-(NSMutableArray *)dataSoure {
    if(_dataSoure == nil){
        _dataSoure = [NSMutableArray arrayWithArray:@[@{@"title":@"喜欢的商品",
                                                        @"image":@"collection_sel"
                                                        },
                                                      @{@"title":@"收藏的文章",
                                                        @"image":@"collection"
                                                        }]];
    }
    return _dataSoure;
}

-(UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WID, HEI-kTopHeight-kTabBarHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgimg.jpeg"]];
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"DefaultModuleCell" bundle:nil] forCellReuseIdentifier:DefaultModuleCellID];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
