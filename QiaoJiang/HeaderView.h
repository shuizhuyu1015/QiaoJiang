//
//  HeaderView.h
//  QiaoJiang
//
//  Created by mac on 16/3/19.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JingXuanModel.h"

typedef void(^HeaderBlock)(void);

@interface HeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (nonatomic,copy) HeaderBlock block;
@property (weak, nonatomic) IBOutlet UILabel *readCount;
@property (weak, nonatomic) IBOutlet UIView *view;

-(void)refreshUI:(JingXuanModel *)jm;

@end
