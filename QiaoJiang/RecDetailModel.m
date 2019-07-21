//
//  RecDetailModel.m
//  QiaoJiang
//
//  Created by mac on 16/3/31.
//  Copyright © 2016年 GL. All rights reserved.
//

#import "RecDetailModel.h"

@implementation Related

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"relateID"}];
}

@end

@implementation RecDetailModel

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.author forKey:@"author"];
    [aCoder encodeObject:self.user_pic forKey:@"user_pic"];
    [aCoder encodeObject:self.coverUrl forKey:@"coverUrl"];
    [aCoder encodeObject:self.subject forKey:@"subject"];
    [aCoder encodeObject:self.tid forKey:@"tid"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]){
        self.author = [aDecoder decodeObjectForKey:@"author"];
        self.user_pic = [aDecoder decodeObjectForKey:@"user_pic"];
        self.coverUrl = [aDecoder decodeObjectForKey:@"coverUrl"];
        self.subject = [aDecoder decodeObjectForKey:@"subject"];
        self.tid = [aDecoder decodeObjectForKey:@"tid"];
    }
    return self;
}

@end
