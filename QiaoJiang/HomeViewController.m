//
//  HomeViewController.m
//  QiaoJiang
//
//  Created by GL on 2019/7/11.
//  Copyright © 2019年 GL. All rights reserved.
//

#import "HomeViewController.h"
#import "AdvertiseModel.h"
#import "AdvertiseCell.h"
#import "GLScrollView.h"

#import "GoodsListVC.h"
#import "GoodsDetailVC.h"

#import "UINavigationBar+Awesome.h"
#import "NSDictionary+URLParamToDict.h"
#import "JSONKit.h"

static NSString *AdvertiseCellID = @"AdvertiseCellID";

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *banners;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GLScrollView *bannerScrollView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    adjustsScrollViewInsets_NO(self.tableView, self);
    
    [self getHomeRecommendData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

#pragma mark - action
//点击banner滚动图
-(void)clickBannerAtIndex:(NSInteger)index {
    AdvertiseModel *model = self.banners[index];
    [self analyseCurrentModel:model];
}


#pragma mark - 获取首页数据
-(void)getHomeRecommendData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    [[HDNetworking sharedHDNetworking] GET:HOME_RECOMMEND parameters:nil success:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseObject[@"code"] intValue] == 200) {
            NSArray *modules = responseObject[@"data"][@"modules"];
            
            NSMutableArray *imagesArr = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dataDic in modules) {
                NSString *dataType = dataDic[@"type"];
                if ([dataType isEqualToString:@"image-banner"]) {
                    NSArray *bannerItems = dataDic[@"data"][@"items"];
                    for (NSDictionary *singleDic in bannerItems) {
                        NSString *linkType = singleDic[@"link"][@"type"];
                        NSString *linkValue = singleDic[@"link"][@"value"];
                        if ([linkType isEqualToString:@"deeplink"] && ![linkValue containsString:@"points-mall"]) {
                            AdvertiseModel *bannerModel = [[AdvertiseModel alloc] initWithDictionary:singleDic error:nil];
                            [self.banners addObject:bannerModel];
                            [imagesArr addObject:bannerModel.banner.src];
                        }
                    }
                }else if ([dataType isEqualToString:@"image-index"]) {
                    NSDictionary *adDic = dataDic[@"data"];
                    NSString *linkType = adDic[@"link"][@"type"];
                    NSString *linkValue = adDic[@"link"][@"value"];
                    NSString *trackTitle = adDic[@"trackTitle"];
                    if ([linkType isEqualToString:@"product"]
                        || [linkType isEqualToString:@"list"]
                        || ([linkType isEqualToString:@"deeplink"] && ![linkValue containsString:@"points-mall"])
                        || ([linkType isEqualToString:@"article"] && ![trackTitle containsString:@"sale"] && ![trackTitle containsString:@"券"] && ![trackTitle containsString:@"新人"])) {
                        AdvertiseModel *adModel = [[AdvertiseModel alloc] initWithDictionary:adDic error:nil];
                        [self.dataSource addObject:adModel];
                    }
                }
            }
            self.bannerScrollView.imageArr = imagesArr;
            [self.tableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    AdvertiseModel *model = self.dataSource[indexPath.row];
    AdvertiseCell *cell = [tableView dequeueReusableCellWithIdentifier:AdvertiseCellID forIndexPath:indexPath];
    [cell refreshImage:model.banner.src title:model.titles];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AdvertiseModel *model = self.dataSource[indexPath.row];
    CGFloat cellHei = WID / model.banner.width * model.banner.height;
    return cellHei;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AdvertiseModel *model = self.dataSource[indexPath.row];

    [self analyseCurrentModel:model];
}

/*!
 @brief 分析当前选中广告模型
 */
-(void)analyseCurrentModel:(AdvertiseModel *)model {
    if ([model.link.type isEqualToString:@"article"]) {
        //先获取ids
        [self getGoodsIDsByArticleID:model.link.value title:model.trackTitle];
        
    }else if ([model.link.type isEqualToString:@"deeplink"]) {
        NSURL *url = [NSURL URLWithString:model.link.value];
        NSDictionary *paras = [NSDictionary dictionaryByURLComponents:url.absoluteString];
        if ([url.host isEqualToString:@"entry"]) {
            if ([paras.allValues containsObject:@"shop-story"]) {
                //先获取ids
                [self getShopStoryDetailByShopID:[paras[@"shopId"] integerValue] title:model.trackTitle];
            }
        }else if ([url.host isEqualToString:@"search"]){
            if ([paras.allValues containsObject:@"discount"]) {
                [self jumpToGoodsVCBYTitle:model.trackTitle ids:nil searchId:nil type:GoodsSourceTypeSearchDiscount];
            }
        }
    }else if ([model.link.type isEqualToString:@"list"]) {
        [self jumpToGoodsVCBYTitle:model.trackTitle ids:nil searchId:model.link.value type:GoodsSourceTypeSearchList];
        
    }else if ([model.link.type isEqualToString:@"product"]) {
        [self jumpToGoodsDetailVCByID:model.link.value];
    }
}

//获取article广告内商品ID
-(void)getGoodsIDsByArticleID:(NSString *)articleId title:(NSString *)title {
    NSString *url = [NSString stringWithFormat:GET_ARTICLE_DETAIL, articleId];
    [[HDNetworking sharedHDNetworking] GET:url parameters:nil success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 200) {
            NSArray *modules = responseObject[@"data"][@"modules"];
            [modules enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *type = obj[@"type"];
                if ([type isEqualToString:@"list"]) {
                    NSArray *ids = obj[@"data"][@"ids"];
                    [self jumpToGoodsVCBYTitle:title ids:ids searchId:nil type:GoodsSourceTypeProductSimple];
                    *stop = YES;
                }
            }];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

//获取shop-story广告商品ID
-(void)getShopStoryDetailByShopID:(NSInteger)shopID title:(NSString *)title {
    NSString *url = [NSString stringWithFormat:GET_SHOP_STORY, @(shopID)];
    [[HDNetworking sharedHDNetworking] GET:url parameters:nil success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] intValue] == 200) {
            NSArray *modules =  [responseObject[@"data"][@"modules"] objectFromJSONString];
            [modules enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *type = obj[@"type"];
                if ([type isEqualToString:@"shop-list"]) {
                    NSArray *ids = obj[@"data"][@"ids"];
                    [self jumpToGoodsVCBYTitle:title ids:ids searchId:nil type:GoodsSourceTypeProductSimple];
                    *stop = YES;
                }
            }];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
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

/*!
 @brief 跳转商品详情
 @param productId 单个商品id
 */
-(void)jumpToGoodsDetailVCByID:(NSString *)productId {
    GoodsDetailVC *dvc = [[GoodsDetailVC alloc] init];
    dvc.productId = productId;
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark - 懒加载
-(NSMutableArray *)banners {
    if (_banners == nil) {
        _banners = [[NSMutableArray alloc] init];
    }
    return _banners;
}

-(NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WID, HEI-kTabBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"AdvertiseCell" bundle:nil] forCellReuseIdentifier:AdvertiseCellID];
        _tableView.tableHeaderView = self.bannerScrollView;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

-(GLScrollView *)bannerScrollView {
    if (_bannerScrollView == nil) {
        CGFloat scale = WID / 1125;
        @WeakObj(self)
        _bannerScrollView = [[GLScrollView alloc] initWithFrame:CGRectMake(0, 0, WID, 1500*scale)];
        _bannerScrollView.block = ^(NSInteger index) {
            [selfWeak clickBannerAtIndex:index-1];
        };
    }
    return _bannerScrollView;
}

@end
