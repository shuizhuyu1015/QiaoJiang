//
//  NSString+replace.h
//  tgjhealth
//
//  Created by 泰管家 on 16/1/8.
//  Copyright © 2016年 泰管家. All rights reserved.
//
//
#import <Foundation/Foundation.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface NSString (replace)

+ (NSString *)replace: (id) str;
/*!
 @brief 修正浮点型精度丢失
 @param str 传入接口取到的数据
 @return 修正精度后的数据
 */
+ (NSString *)reviseString:(NSString *)str;

+ (NSString *)timeString;

+ (NSString *)currentDate;
+ (NSString *)currentDate:(NSDate *) date;

+ (NSString *)getIPAddress;

+ (NSString *)currentTimeWithDate: (NSDate *)date;
+ (NSString *)currentTime:(NSDate *)date;
+ (NSString *)tenMiniteInterval:(NSString *)currentTime;

/*!
 @brief
 @discussion
 @param
 @param
 @param
 @return
 */
+(NSString *)removeEmoji:(NSString *)str;

@end
