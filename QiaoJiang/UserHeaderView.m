//
//  UserHeaderView.m
//  QiaoJiang
//
//  Created by mac on 16/4/6.
//  Copyright © 2016年 GL. All rights reserved.
//

#import "UserHeaderView.h"

@implementation UserHeaderView

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
        self.userImage.layer.cornerRadius = 30;
        self.userImage.layer.borderWidth = 1.5;
        self.userImage.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.userImage.clipsToBounds = YES;
        
        //背景模糊效果
//        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
//        effectView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bgImage.frame), CGRectGetHeight(self.bgImage.frame));
//        [self.bgImage addSubview:effectView];
}

@end
