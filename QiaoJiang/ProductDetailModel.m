//
//  ProductDetailModel.m
//  QiaoJiang
//
//  Created by Gray on 2019/7/20.
//  Copyright © 2019年 GL. All rights reserved.
//

#import "ProductDetailModel.h"

@implementation RecommentContentModel

+(BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"image.src":@"imageSrc"}];
}

@end


@implementation ProductRecommentModel


@end


@implementation ProductVariantModel

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"variantId"}];
}

@end


@implementation ProductDetailModel

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"productId",
                                                       @"brand.name":@"brandName",
                                                       @"variant.spvs":@"variants"
                                                       }];
}

@end
