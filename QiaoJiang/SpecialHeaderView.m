//
//  SpecialHeaderView.m
//  QiaoJiang
//
//  Created by mac on 16/3/22.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import "SpecialHeaderView.h"

@implementation SpecialHeaderView

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
}

@end
