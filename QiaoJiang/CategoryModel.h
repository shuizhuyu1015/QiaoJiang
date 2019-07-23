//
//  CategoryModel.h
//  QiaoJiang
//
//  Created by Gray on 2019/7/23.
//  Copyright © 2019年 GL. All rights reserved.
//

#import "JSONModel.h"
#import "AdvertiseModel.h"

@protocol AdvertiseModel
@end

@interface CategoryModel : JSONModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray<AdvertiseModel> *subCategory;

@end
