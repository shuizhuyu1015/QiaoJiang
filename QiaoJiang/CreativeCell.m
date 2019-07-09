//
//  CreativeCell.m
//  QiaoJiang
//
//  Created by GL on 2019/7/8.
//  Copyright © 2019年 GL. All rights reserved.
//

#import "CreativeCell.h"
#import "UIImageView+WebCache.h"

@interface CreativeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation CreativeCell
{
    NSString *user_id;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bannerImageView.clipsToBounds = YES;
    
    self.userImageView.layer.cornerRadius = 45/2;
    self.userImageView.layer.borderWidth = 1;
    self.userImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userImageView.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIcon:)];
    [self.userImageView addGestureRecognizer:tap];
    self.userImageView.userInteractionEnabled = YES;
}

-(void)clickIcon:(UITapGestureRecognizer *)tap
{
    if (self.block) {
        self.block(user_id);
    }
}

//导入模型,刷新UI
-(void)refreshModel:(id)model
{
    if ([model isKindOfClass:[IdeaModel class]]) {
        
        [self.bannerImageView sd_setImageWithURL:[NSURL URLWithString:[model imageUrl]] placeholderImage:[UIImage imageNamed:@"default_item"]];
        
        NSString *title = [model title];
        self.titleLabel.text = title;
        self.countLabel.text = [model click_num];
        
        self.userLabel.text = [NSString stringWithFormat:@"by %@",[model user_name]];
        
        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:[model user_pic]]];
        
        user_id = [model user_id];
        
    }else if ([model isKindOfClass:[RecommendModel class]]){
        [self.bannerImageView sd_setImageWithURL:[NSURL URLWithString:[model feature]] placeholderImage:[UIImage imageNamed:@"default_item"] options:SDWebImageRetryFailed];
        
        self.titleLabel.text = [model subject];
        self.countLabel.text = [model views];
        
        self.userLabel.text = [NSString stringWithFormat:@"by %@",[model author]];
        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:[model user_pic]]];
        
        user_id = [model authorid];
    }
    
}

@end
