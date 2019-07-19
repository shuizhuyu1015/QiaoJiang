//
//  ProductDisplayModel.m
//  QiaoJiang
//
//  Created by GL on 2019/7/12.
//  Copyright © 2019年 GL. All rights reserved.
//

#import "ProductDisplayModel.h"

@implementation ProductDisplayModel

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"brand.name":@"brandName", @"id":@"productId"}];
}

-(NSString *)description {
    return [NSString stringWithFormat:@"%@", @{@"brandName":self.brandName,
                                               @"name":self.name,
                                               @"productId":self.productId,
                                               @"price":@(self.price),
                                               @"rawPrice":@(self.rawPrice),
                                               @"rush":@(self.rush)
                                               }];
}

@end
