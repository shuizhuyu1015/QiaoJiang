//
//  ClassifyGoodsVC.m
//  QiaoJiang
//
//  Created by GL on 2019/7/23.
//  Copyright © 2019年 GL. All rights reserved.
//

#import "ClassifyGoodsVC.h"
#import "MultilevelMenu.h"

#import "AdvertiseModel.h"

@interface ClassifyGoodsVC ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ClassifyGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

#pragma mark - 获取分类数据
-(void)loadClassifyData {
    [[HDNetworking sharedHDNetworking] GET:GET_CLASSIFY_DATA parameters:nil success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 200) {
            NSArray *allData = responseObject[@"data"][@"modules"];
            for (NSDictionary *dataDic in allData) {
                NSArray *subArr = dataDic[@"data"][@"subCategory"];
                NSMutableArray *categoriesArr = [[NSMutableArray alloc] init];
                for (NSDictionary *categoryDic in subArr) {
                    if (![categoryDic[@"hideImage"] boolValue]) {
                        AdvertiseModel *model = [[AdvertiseModel alloc] initWithDictionary:categoryDic error:nil];
                        [categoriesArr addObject:model];
                    }
                }
                
            }
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


@end
