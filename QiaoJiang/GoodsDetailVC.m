//
//  GoodsDetailVC.m
//  QiaoJiang
//
//  Created by GL on 2019/7/19.
//  Copyright © 2019年 GL. All rights reserved.
//

#import "GoodsDetailVC.h"

@interface GoodsDetailVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GoodsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"商品详情";
}

/*!
 @brief 通过商品id获取详情
 */
-(void)getGoodsDetail {
    NSString *url = [NSString stringWithFormat:GET_PRODUCT_BY_ID, self.productId];
    [[HDNetworking sharedHDNetworking] GET:url parameters:nil success:^(id  _Nonnull responseObject) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 懒加载
-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WID, HEI-kTopHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


@end
