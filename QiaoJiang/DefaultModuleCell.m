//
//  DefaultModuleCell.m
//  QiaoJiang
//
//  Created by Gray on 2019/7/21.
//  Copyright © 2019年 GL. All rights reserved.
//

#import "DefaultModuleCell.h"

@interface DefaultModuleCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation DefaultModuleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)refreshIcon:(NSString *)icon title:(NSString *)title {
    self.iconImage.image = [UIImage imageNamed:icon];
    self.titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
