//
//  IdeaDetailModel.m
//  QiaoJiang
//
//  Created by mac on 16/3/29.
//  Copyright © 2016年 GL. All rights reserved.
//

#import "IdeaDetailModel.h"

@implementation RelatedIdea

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"relatedID",@"cover":@"coverImg",@"subject":@"subTitle"}];
}

@end

@implementation Case

@end

@implementation IdeaDetailModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"case":@"userCase",@"related":@"relatedIdea"}];
}

@end
