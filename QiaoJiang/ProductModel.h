//
//  ProductModel.h
//  QiaoJiang
//
//  Created by mac on 16/3/21.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import "JSONModel.h"

@protocol OptionName
@end

@protocol Attribute
@end

@protocol PicURLModel
@end

@interface OptionName : JSONModel
@property (nonatomic,copy) NSString *optionName;
@end
@interface Attribute : JSONModel
@property (nonatomic,copy) NSString *attribute2Value;
@property (nonatomic,strong) NSArray <OptionName> *attribute2Options;
@end

@interface PicURLModel : JSONModel
@property (nonatomic,copy) NSString *pictureUri;
@end

@interface ProductModel : JSONModel
@property (nonatomic,copy) NSString *productName;
@property (nonatomic,assign) NSInteger finalPrice;
@property (nonatomic,copy) NSString *productCode;
@property (nonatomic,copy) NSString *productStatusUpdateTime;
@property (nonatomic,strong) NSArray <PicURLModel> *pictures;
@property (nonatomic,strong) NSArray <Attribute> *productAttributes;
@end
