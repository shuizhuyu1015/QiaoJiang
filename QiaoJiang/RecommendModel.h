//
//  RecommendModel.h
//  QiaoJiang
//
//  Created by mac on 16/3/30.
//  Copyright © 2016年 GL. All rights reserved.
//

#import "JSONModel.h"

@interface RecommendModel : JSONModel

@property (nonatomic,copy) NSString *tid;
@property (nonatomic,copy) NSString *subject;
@property (nonatomic,copy) NSString *views;
@property (nonatomic,copy) NSString *feature;
@property (nonatomic,copy) NSString *author;
@property (nonatomic,copy) NSString *authorid;
@property (nonatomic,copy) NSString *user_pic;

@end
