//
//  JingXuanModel.h
//  QiaoJiang
//
//  Created by mac on 16/3/17.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import "JSONModel.h"

@protocol DetailModel
@end

@protocol FooterModel
@end

@interface FootItemModel : JSONModel
@property (nonatomic,assign) NSInteger category1Id;
@property (nonatomic,assign) NSInteger category2Id;
@end
//组尾模型
@interface FooterModel : JSONModel
@property (nonatomic,copy) NSString *productSpecialCategoryUrl;
@property (nonatomic,strong) FootItemModel *category2;
@end


@interface Product : JSONModel
@property (nonatomic,copy) NSString *productImage;
@property (nonatomic,assign) NSInteger finalPrice;
@property (nonatomic,copy) NSString *productName;
@end
//cell产品模型
@interface DetailModel : JSONModel
@property (nonatomic,assign) NSInteger productId;
@property (nonatomic,strong) Product *product;
@end


@interface JingXuanModel : JSONModel
@property (nonatomic,copy) NSString *productSpecialName;
@property (nonatomic,assign) NSInteger productSpecialId;
@property (nonatomic,copy) NSString *naviAppImg;
@property (nonatomic,assign) NSInteger readCount;
//橱窗cell详细产品模型的数组
@property (nonatomic,strong) NSArray <DetailModel> *windowSpecialItemList;
//组尾模型数组
@property (nonatomic,strong) NSArray <FooterModel> *footers;
@end
