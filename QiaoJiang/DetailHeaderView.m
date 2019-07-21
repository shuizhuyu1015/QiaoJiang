//
//  DetailHeaderView.m
//  QiaoJiang
//
//  Created by mac on 16/3/29.
//  Copyright © 2016年 GL. All rights reserved.
//

#import "DetailHeaderView.h"
#import "UIImageView+WebCache.h"

@implementation DetailHeaderView
{
    NSString *user_id;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.userImage.layer.cornerRadius = 25;
    self.userImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userImage.layer.borderWidth = 1;
    self.userImage.clipsToBounds = YES;
    self.coverImage.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImage.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserImage:)];
    [self.userImage addGestureRecognizer:tap];
    self.userImage.userInteractionEnabled = YES;
}

-(void)clickUserImage:(UITapGestureRecognizer *)tap
{
    if (self.block) {
        self.block(user_id);
    }
}

-(void)refreshUI:(id)model
{
    if ([model isKindOfClass:[IdeaDetailModel class]]) {
        [self.coverImage sd_setImageWithURL:[NSURL URLWithString:[[model userCase] cover]] placeholderImage:[UIImage imageNamed:@"default_item"]];
        self.name.text = [[model userCase] user_name];
        [self.userImage sd_setImageWithURL:[NSURL URLWithString:[[model userCase] user_pic]] placeholderImage:[UIImage imageNamed:@"default_item"]];
        self.titleLabel.text = [[model userCase] title];
        
        user_id = [[model userCase] user_id];
        
    }else if ([model isKindOfClass:[RecDetailModel class]]){
        [self.coverImage sd_setImageWithURL:[NSURL URLWithString:[model coverUrl]] placeholderImage:[UIImage imageNamed:@"default_item"]];
        self.name.text = [model author];
        [self.userImage sd_setImageWithURL:[NSURL URLWithString:[model user_pic]] placeholderImage:[UIImage imageNamed:@"default_item"]];
        self.titleLabel.text = [model subject];
        
        user_id = [model authorid];
    }
    
}

-(void)resetFrame:(CGFloat)y
{
    CGRect rect = self.frame;
    rect.origin.y = y;
    rect.size.height = -y;
    self.frame = rect;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
