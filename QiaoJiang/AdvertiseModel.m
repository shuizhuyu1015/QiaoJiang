//
//  AdvertiseModel.m
//  QiaoJiang
//
//  Created by GL on 2019/7/11.
//  Copyright © 2019年 GL. All rights reserved.
//

#import "AdvertiseModel.h"

@implementation BannerModel

-(NSString *)description {
    return [NSString stringWithFormat:@"%@", @{@"src":self.src}];
}

@end


@implementation LinkModel

-(NSString *)description {
    return [NSString stringWithFormat:@"%@", @{@"type":self.type, @"value":self.value}];
}

@end


@implementation TitleModel

@end


@implementation AdvertiseModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"image":@"banner", @"items":@"titles"}];
}

-(NSString *)description {
    return [NSString stringWithFormat:@"%@", @{@"banner":self.banner,
                                               @"link":self.link,
                                               @"trackTitle":self.trackTitle}];
}

@end
