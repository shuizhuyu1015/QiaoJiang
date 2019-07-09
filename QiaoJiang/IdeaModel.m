//
//  IdeaModel.m
//  QiaoJiang
//
//  Created by mac on 16/3/25.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import "IdeaModel.h"

@implementation IdeaModel

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"image":@"imageUrl"}];
}

@end
