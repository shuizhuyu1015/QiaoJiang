//
//  DetailHeaderView.h
//  QiaoJiang
//
//  Created by mac on 16/3/29.
//  Copyright © 2016年 GL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IdeaDetailModel.h"
#import "RecDetailModel.h"

typedef void(^UserBlock)(NSString *);

@interface DetailHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic,copy) UserBlock block;

-(void)refreshUI:(id)model;

-(void)resetFrame:(CGFloat)y;

@end
