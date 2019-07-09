//
//  CategoryModel.h
//  Test2
//
//  Created by mac on 16/4/1.
//  Copyright © 2016年 GL. All rights reserved.
//

#import "JSONModel.h"

@protocol Category2sModel

@end

@interface Category2sModel : JSONModel
@property (nonatomic,copy) NSString *category2Name;
@property (nonatomic,assign) NSInteger category1Id;
@property (nonatomic,assign) NSInteger category2Id;
@end

@interface CategoryModel : JSONModel

@property (nonatomic,copy) NSString *category1Name;
@property (nonatomic,strong) NSArray <Category2sModel> *category2s;

@end
