//
//  CommonConstant.h
//  QiaoJiang
//
//  Created by GL on 2019/7/8.
//  Copyright © 2019年 GL. All rights reserved.
//

#ifndef CommonConstant_h
#define CommonConstant_h

#define WID [[UIScreen mainScreen] bounds].size.width
#define HEI [[UIScreen mainScreen] bounds].size.height

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTabBarHeight (kStatusBarHeight > 20 ? 83 : 49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)
#define IS_iPhoneX_XS ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812)
#define IS_iPhoneXR_XSMax ([UIScreen mainScreen].bounds.size.width == 414 && [UIScreen mainScreen].bounds.size.height == 896)

/*! weakself宏 */
#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
/*! strongself宏 */
#define StrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;

/* iOS 11适配 */
#define adjustsScrollViewInsets_NO(scrollView,vc) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) { \
NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)]; \
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature]; \
NSInteger argument = 2; \
invocation.target = scrollView; \
invocation.selector = @selector(setContentInsetAdjustmentBehavior:); \
[invocation setArgument:&argument atIndex:2]; \
[invocation invoke]; \
} else { \
vc.automaticallyAdjustsScrollViewInsets = NO; \
} \
_Pragma("clang diagnostic pop") \
} while (0)


#endif /* CommonConstant_h */
