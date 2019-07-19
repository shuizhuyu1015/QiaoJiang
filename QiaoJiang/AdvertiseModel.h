//
//  AdvertiseModel.h
//  QiaoJiang
//
//  Created by GL on 2019/7/11.
//  Copyright © 2019年 GL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BannerModel : JSONModel

@property (nonatomic, copy) NSString *src;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@end


@interface LinkModel : JSONModel

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *value;

@end


@protocol TitleModel
@end

@interface TitleModel : JSONModel

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *textColor;

@end


@interface AdvertiseModel : JSONModel

@property (nonatomic, strong) BannerModel *banner;
@property (nonatomic, strong) LinkModel *link;
@property (nonatomic, strong) NSArray<TitleModel> *titles;
@property (nonatomic, copy) NSString *trackTitle;

@end

NS_ASSUME_NONNULL_END
