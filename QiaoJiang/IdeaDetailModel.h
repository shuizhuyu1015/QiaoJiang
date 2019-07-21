//
//  IdeaDetailModel.h
//  QiaoJiang
//
//  Created by mac on 16/3/29.
//  Copyright © 2016年 GL. All rights reserved.
//

#import "JSONModel.h"

@protocol RelatedIdea
@end

@interface RelatedIdea : JSONModel
@property (nonatomic,copy) NSString *coverImg;
@property (nonatomic,copy) NSString *relatedID;
@property (nonatomic,copy) NSString *subTitle;
@end

@interface Case : JSONModel <NSCoding>
@property (nonatomic,copy) NSString *user_name;
@property (nonatomic,copy) NSString *user_pic;
@property (nonatomic,copy) NSString *user_id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *cover;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *size;
@property (nonatomic,copy) NSString *budget;
@property (nonatomic,copy) NSString *area;
@property (nonatomic,copy) NSString *style;
@property (nonatomic,copy) NSString *group_id;
@end

@interface IdeaDetailModel : JSONModel

@property (nonatomic,strong) Case *userCase;
@property (nonatomic,strong) NSArray <RelatedIdea> *relatedIdea;

@end
