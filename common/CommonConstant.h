//
//  CommonConstant.h
//  QiaoJiang
//
//  Created by GL on 2019/7/8.
//  Copyright © 2019年 GL. All rights reserved.
//

#ifndef CommonConstant_h
#define CommonConstant_h


/*! weakself宏 */
#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
/*! strongself宏 */
#define StrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;


#endif /* CommonConstant_h */
