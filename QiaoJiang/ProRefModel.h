//
//  ProRefModel.h
//  QiaoJiang
//
//  Created by mac on 16/3/21.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import "JSONModel.h"

@interface ProRefModel : JSONModel

@property (nonatomic,copy) NSString *productName;
@property (nonatomic,assign) NSInteger finalPrice;
@property (nonatomic,copy) NSString *productImage;
@property (nonatomic,assign) NSInteger productId;

@end
