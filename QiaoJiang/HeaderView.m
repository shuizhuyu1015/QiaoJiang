//
//  HeaderView.m
//  QiaoJiang
//
//  Created by mac on 16/3/19.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import "HeaderView.h"
#import "interface.h"

@implementation HeaderView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.view.layer.cornerRadius = 9;
    self.view.clipsToBounds = YES;
}

-(void)refreshUI:(JingXuanModel *)jm
{
    self.readCount.text = [NSString stringWithFormat:@"%ld",jm.readCount];
    
    NSString *urlStr = [NSString stringWithFormat:kImage,jm.naviAppImg];
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"default_item"]];
    self.headerImage.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImage.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeaderView:)];
    [self.headerImage addGestureRecognizer:tap];
    self.headerImage.userInteractionEnabled = YES;
}

-(void)clickHeaderView:(UITapGestureRecognizer *)tap
{
    if (self.block) {
        self.block();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
