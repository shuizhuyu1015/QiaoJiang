//
//  NSDictionary+URLParamToDict.h
//  QiaoJiang
//
//  Created by GL on 2019/7/12.
//  Copyright © 2019年 GL. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (URLParamToDict)

/*!
 @brief URL参数转字典(NSURLComponents方式，参数内含中文无效)
 */
+(NSDictionary *)dictionaryByURLComponents:(NSString *)urlStr;

/*!
 @brief URL参数转字典(常规字符串拆分方式)
 */
+(NSDictionary *)dictionaryWithUrlString:(NSString *)urlStr;

@end

NS_ASSUME_NONNULL_END
