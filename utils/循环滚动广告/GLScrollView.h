//
//  GLScrollView.h
//
//  Created by mac on 16/1/12.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyBlock)(NSString *);

@interface GLScrollView : UIView

@property (nonatomic,copy) MyBlock block;

@property (nonatomic,strong) NSArray *imageArr; // 图片名字数组

@end
