//
//  ClassifyGoodsVC.m
//  QiaoJiang
//
//  Created by GL on 2019/7/23.
//  Copyright © 2019年 GL. All rights reserved.
//

#import "ClassifyGoodsVC.h"
#import "MultilevelMenu.h"

#import "CategoryModel.h"

@interface ClassifyGoodsVC ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ClassifyGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadClassifyData];
}

#pragma mark - 获取分类数据
-(void)loadClassifyData {
    [[HDNetworking sharedHDNetworking] GET:GET_CLASSIFY_DATA parameters:nil success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 200) {
            NSArray *allData = responseObject[@"data"][@"modules"];
            for (NSDictionary *dataDic in allData) {
                NSDictionary *categoryDic = dataDic[@"data"];
                CategoryModel *model = [[CategoryModel alloc] initWithDictionary:categoryDic error:nil];
                [self.dataSource addObject:model];
            }
            [self setupClassifyMenu];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 布局分类view
-(void)setupClassifyMenu {
    NSMutableArray *dataList = [[NSMutableArray alloc] init];
    for (CategoryModel *cModel in self.dataSource) {
        RightMeun *firstMenu = [[RightMeun alloc] init];
        firstMenu.meunName = cModel.title;
        
        RightMeun *secondMenu = [[RightMeun alloc] init];

        NSMutableArray *subArr = [[NSMutableArray alloc] init];
        for (AdvertiseModel *aModel in cModel.subCategory) {
            if (aModel.hideImage.boolValue == NO) {
                RightMeun *subCate = [[RightMeun alloc] init];
                subCate.meunName = aModel.title;
                subCate.urlName = aModel.banner.src;
                [subArr addObject:subCate];
            }
        }
        secondMenu.nextArray = subArr;
        
        firstMenu.nextArray = @[secondMenu];
        [dataList addObject:firstMenu];
    }
    
    MultilevelMenu *menu = [[MultilevelMenu alloc] initWithFrame:CGRectMake(0, 0, WID, HEI-kTopHeight-kTabBarHeight) WithData:dataList withSelectIndex:^(NSInteger left, NSInteger right, RightMeun *info) {
        
        NSLog(@"左侧第 %ld 个菜单，第 %ld 个分类， %@", left, right, info.meunName);
    }];
    [self.view addSubview:menu];
}

#pragma mark - lazy
-(NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}


@end
