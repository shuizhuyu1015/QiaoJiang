//
//  ClassifyGoodsVC.m
//  QiaoJiang
//
//  Created by GL on 2019/7/23.
//  Copyright © 2019年 GL. All rights reserved.
//

#import "ClassifyGoodsVC.h"
#import "MultilevelMenu.h"
#import "NSDictionary+URLParamToDict.h"

#import "CategoryModel.h"

#import "GoodsListVC.h"
#import "SearchProductVC.h"

@interface ClassifyGoodsVC ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ClassifyGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(clickSearch)];
    
    [self loadClassifyData];
}

#pragma mark - 点击搜索
-(void)clickSearch {
    SearchProductVC *svc = [[SearchProductVC alloc] init];
    [self.navigationController pushViewController:svc animated:NO];
}

#pragma mark - 获取分类数据
-(void)loadClassifyData {
    [[HDNetworking sharedHDNetworking] GET:GET_CLASSIFY_DATA parameters:nil success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 200) {
            NSArray *allData = responseObject[@"data"][@"modules"];
            for (NSDictionary *dataDic in allData) {
                NSMutableDictionary *categoryDic = [[NSMutableDictionary alloc] initWithDictionary:dataDic[@"data"]];
                
                NSMutableArray *arrM = [[NSMutableArray alloc] init];
                //剔除不需要的数据
                NSArray *subArr = categoryDic[@"subCategory"];
                for (NSDictionary *subDic in subArr) {
                    NSString *title = [NSString replace:subDic[@"title"]];
                    // 不隐藏，且不包含“折扣”，不包含“定制”，则加入数据源
                    if (![subDic[@"hideImage"] boolValue] && ![title containsString:@"折扣"] && ![title containsString:@"定制"]) {
                        [arrM addObject:subDic];
                    }
                }
                [categoryDic setValue:arrM forKey:@"subCategory"];
                
                CategoryModel *model = [[CategoryModel alloc] initWithDictionary:categoryDic error:nil];
                [self.dataSource addObject:model];
            }
            [self setupClassifyMenu];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 布局视图
-(void)setupClassifyMenu {
    NSMutableArray *dataList = [[NSMutableArray alloc] init];
    for (CategoryModel *cModel in self.dataSource) {
        RightMeun *firstMenu = [[RightMeun alloc] init];
        firstMenu.meunName = cModel.title;
        
        RightMeun *secondMenu = [[RightMeun alloc] init];

        NSMutableArray *subArr = [[NSMutableArray alloc] init];
        for (AdvertiseModel *aModel in cModel.subCategory) {
            RightMeun *subCate = [[RightMeun alloc] init];
            subCate.meunName = aModel.title;
            subCate.urlName = aModel.banner.src;
            [subArr addObject:subCate];
        }
        secondMenu.nextArray = subArr;
        
        firstMenu.nextArray = @[secondMenu];
        [dataList addObject:firstMenu];
    }
    
    MultilevelMenu *menu = [[MultilevelMenu alloc] initWithFrame:CGRectMake(0, 0, WID, HEI-kTopHeight-kTabBarHeight) WithData:dataList withSelectIndex:^(NSInteger left, NSInteger right, RightMeun *info) {
        NSLog(@"左侧第 %@ 个菜单，第 %@ 个分类， %@", @(left), @(right), info.meunName);
        [self clickLevel1MenuAtIndex:left level2MenuAtIndex:right categoryTitle:info.meunName];
    }];
    menu.numberOfPerLine = 2;
    menu.leftSelectColor = [UIColor colorWithHexString:@"60BAB9"];
    [self.view addSubview:menu];
}

#pragma mark - 点击跳转分类
/*!
 @brief 判断菜单类型，提取参数
 @param level1Index 左侧一级菜单下标
 @param level2Index 右侧二级菜单下标
 @param title 分类菜单名
 */
-(void)clickLevel1MenuAtIndex:(NSInteger)level1Index level2MenuAtIndex:(NSInteger)level2Index categoryTitle:(NSString *)title {
    CategoryModel *cModel = self.dataSource[level1Index];
    AdvertiseModel *aModel = cModel.subCategory[level2Index];
    
    GoodsSourceType sourceType = 0;
    NSArray *ids = nil;
    NSString *searchId = nil;
    
    if ([aModel.link.type isEqualToString:@"all"]) {
        sourceType = GoodsSourceTypeSearchAll;
        
    }else if ([aModel.link.type isEqualToString:@"deeplink"]) {
        NSURL *url = [NSURL URLWithString:aModel.link.value];
        if ([url.host isEqualToString:@"search"]) {
            if ([url.query containsString:@"new=1"]) {
                sourceType = GoodsSourceTypeSearchNew;
            }else if ([url.query containsString:@"param=discount"]){
                sourceType = GoodsSourceTypeSearchDiscount;
            }
        }
    }else if ([aModel.link.type isEqualToString:@"list"]) {
        sourceType = GoodsSourceTypeSearchList;
        searchId = aModel.link.value;
        
    }else if ([aModel.link.type isEqualToString:@"categoryOversea"]) {
        sourceType = GoodsSourceTypeSearchCategoryOversea;
        ids = [aModel.link.value componentsSeparatedByString:@","];
        
    }else if ([aModel.link.type isEqualToString:@"category"]) {
        sourceType = GoodsSourceTypeSearchCategory;
        ids = [aModel.link.value componentsSeparatedByString:@","];
        
    }else if ([aModel.link.type isEqualToString:@"brand"]) {
        sourceType = GoodsSourceTypeSearchBrand;
        searchId = aModel.link.value;
        
    }else if ([aModel.link.type isEqualToString:@"article"]) {
        [self getGoodsIdsByArticleId:aModel.link.value title:title];
        return;
    }
    [self jumpToGoodsVCBYTitle:title ids:ids searchId:searchId type:sourceType];
}

/*!
 @brief 跳转商品列表
 @param title 标题
 @param ids 商品id数组
 @param searchId 需要搜索的listid
 @param sourceType 页面类型
 */
-(void)jumpToGoodsVCBYTitle:(NSString *)title ids:(NSArray *)ids searchId:(NSString *)searchId type:(GoodsSourceType)sourceType {
    GoodsListVC *gvc = [[GoodsListVC alloc] init];
    gvc.sourceType = sourceType;
    gvc.ids = ids;
    gvc.searchId = searchId;
    gvc.navigationItem.title = title;
    [self.navigationController pushViewController:gvc animated:YES];
}

//获取article广告内商品ID
-(void)getGoodsIdsByArticleId:(NSString *)articleId title:(NSString *)title {
    
    NSString *url = [NSString stringWithFormat:GET_ARTICLE_DETAIL, articleId];
    [[HDNetworking sharedHDNetworking] GET:url parameters:nil success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 200) {
            NSArray *modules = responseObject[@"data"][@"modules"];
            __block NSArray *ids = nil;
            [modules enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *type = obj[@"type"];
                if ([type isEqualToString:@"list"]) {
                    //保存ids
                    ids = obj[@"data"][@"ids"];
                    //退出循环
                    *stop = YES;
                }
            }];
            [self jumpToGoodsVCBYTitle:title ids:ids searchId:nil type:GoodsSourceTypeProductSimple];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


#pragma mark - lazy
-(NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}


@end
