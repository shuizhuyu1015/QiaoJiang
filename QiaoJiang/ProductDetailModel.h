//
//  ProductDetailModel.h
//  QiaoJiang
//
//  Created by Gray on 2019/7/20.
//  Copyright © 2019年 GL. All rights reserved.
//

#import "JSONModel.h"

@protocol RecommentContentModel
@end

@interface RecommentContentModel : JSONModel

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *imageSrc;
@property (nonatomic, copy) NSString *link;

@end

@interface ProductRecommentModel :JSONModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray<RecommentContentModel> *modules;

@end


@protocol ProductVariantModel
@end

@interface ProductVariantModel : JSONModel

@property (nonatomic, assign) NSInteger variantId;
@property (nonatomic, copy) NSString *productCode;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) float price;
@property (nonatomic, assign) float rawPrice;
@property (nonatomic, copy) NSString *spvDesc;
@property (nonatomic, copy) NSString *image;

@end


@interface ProductDetailModel : JSONModel

@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) float price;
@property (nonatomic, assign) float rawPrice;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray<ProductVariantModel> *variants;

@end
