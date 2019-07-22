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

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.user_name forKey:@"user_name"];
    [aCoder encodeObject:self.cover forKey:@"cover"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.budget forKey:@"budget"];
    [aCoder encodeObject:self.group_id forKey:@"group_id"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]){
        self.user_name = [aDecoder decodeObjectForKey:@"user_name"];
        self.cover = [aDecoder decodeObjectForKey:@"cover"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.budget = [aDecoder decodeObjectForKey:@"budget"];
        self.group_id = [aDecoder decodeObjectForKey:@"group_id"];
    }
    return self;
}

@end

@implementation IdeaDetailModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"case":@"userCase",@"related":@"relatedIdea"}];
}

@end
