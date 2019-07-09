//
//  IdeaModel.h
//  QiaoJiang
//
//  Created by mac on 16/3/25.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import "JSONModel.h"

@interface IdeaModel : JSONModel

@property (nonatomic,copy) NSString *user_name;
@property (nonatomic,copy) NSString *user_pic;
@property (nonatomic,copy) NSString *group_id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *user_id;
@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,copy) NSString *click_num;

@end
