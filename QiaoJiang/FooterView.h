//
//  FooterView.h
//  QiaoJiang
//
//  Created by mac on 16/3/19.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FooterBlock)(NSInteger,NSInteger);

@interface FooterView : UITableViewHeaderFooterView

@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,copy) FooterBlock block;

@end
