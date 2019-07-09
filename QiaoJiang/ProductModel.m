//
//  ProductModel.m
//  QiaoJiang
//
//  Created by mac on 16/3/21.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import "ProductModel.h"

@implementation OptionName
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end

@implementation Attribute

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@implementation PicURLModel

@end

@implementation ProductModel
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
