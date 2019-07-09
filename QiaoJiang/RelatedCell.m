//
//  RelatedCell.m
//  QiaoJiang
//
//  Created by administrator on 16/3/29.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import "RelatedCell.h"
#import "UIImageView+WebCache.h"

@interface RelatedCell ()
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation RelatedCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

-(void)refreshUI:(RelatedIdea *)ri
{
        [self.picture sd_setImageWithURL:[NSURL URLWithString:[ri coverImg]] placeholderImage:[UIImage imageNamed:@"default_item"]];
        
        self.title.text = [ri subTitle];
}

-(void)refreshModel:(Related *)re
{
    [self.picture sd_setImageWithURL:[NSURL URLWithString:re.cover] placeholderImage:[UIImage imageNamed:@"default_item"]];
    self.label.text = @"推荐";
    self.title.text = re.subject;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
