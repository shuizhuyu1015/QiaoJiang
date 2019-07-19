//
//  ProductDisplayModel.h
//  QiaoJiang
//
//  Created by GL on 2019/7/12.
//  Copyright © 2019年 GL. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProductDisplayModel : JSONModel

@property (nonatomic, copy) NSString *featureImage;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, assign) float price;
@property (nonatomic, assign) float rawPrice;
@property (nonatomic, assign) BOOL rush;

@end

NS_ASSUME_NONNULL_END
