//
//  GoodsListVC.h
//  QiaoJiang
//
//  Created by GL on 2019/7/12.
//  Copyright © 2019年 GL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GoodsSourceType) {
    GoodsSourceTypeSearchAll = 0,          //搜索全部
    GoodsSourceTypeSearchDiscount,     //搜索折扣
    GoodsSourceTypeSearchList,        //通过listid搜索
    GoodsSourceTypeSearchNew,         //搜索新品
    GoodsSourceTypeSearchCategoryOversea,  //搜索跨境分类
    GoodsSourceTypeSearchCategory,     //搜索分类
    GoodsSourceTypeSearchBrand,        //搜索品牌
    GoodsSourceTypeProductSimple      //通过ids查找
};

@interface GoodsListVC : BaseVC

@property (nonatomic, assign) GoodsSourceType sourceType;
@property (nonatomic, strong) NSArray *ids;
@property (nonatomic, copy) NSString *searchId;

@end

NS_ASSUME_NONNULL_END
