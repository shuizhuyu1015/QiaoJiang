//
//  JingXuanModel.m
//  QiaoJiang
//
//  Created by mac on 16/3/17.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import "JingXuanModel.h"

@implementation FootItemModel
@end

@implementation FooterModel
@end


@implementation Product
@end

@implementation DetailModel
@end


@implementation JingXuanModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"productSpecialCategoryList":@"footers"}];
}

@end
