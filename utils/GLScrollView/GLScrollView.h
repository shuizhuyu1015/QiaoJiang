//
//  GLScrollView.h
//
//  Created by mac on 16/1/12.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyBlock)(NSInteger);

@interface GLScrollView : UIView

@property (nonatomic,copy) MyBlock block;
@property (nonatomic,strong) UIScrollView *scrollView;  // 滚动视图
@property (nonatomic,strong) NSArray *imageArr; // 模型数组

@end
