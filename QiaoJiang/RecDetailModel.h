//
//  RecDetailModel.h
//  QiaoJiang
//
//  Created by mac on 16/3/31.
//  Copyright © 2016年 GL. All rights reserved.
//

#import "JSONModel.h"

@protocol Related
@end

@interface Related : JSONModel
@property (nonatomic,copy) NSString *relateID;
@property (nonatomic,copy) NSString *subject;
@property (nonatomic,copy) NSString *cover;
@end

@interface RecDetailModel : JSONModel <NSCopying>

@property (nonatomic,copy) NSString *author;
@property (nonatomic,copy) NSString *authorid;
@property (nonatomic,copy) NSString *user_pic;
@property (nonatomic,copy) NSString *tid;
@property (nonatomic,copy) NSString *subject;
@property (nonatomic, copy) NSString<Optional> *coverUrl;
@property (nonatomic,copy) NSString *message_div;
@property (nonatomic,strong) NSArray <Related> *related;

@end
