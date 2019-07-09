//
//  InfoCell.m
//  QiaoJiang
//
//  Created by mac on 16/3/21.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import "InfoCell.h"

@interface InfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *caizhiLabel;
@property (weak, nonatomic) IBOutlet UILabel *guigeLabel;
@property (weak, nonatomic) IBOutlet UILabel *chicunLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;

@end

@implementation InfoCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

-(void)refreshInfo:(ProductModel *)pm
{
    self.IDLabel.text = pm.productCode;
    self.timeLabel.text = pm.productStatusUpdateTime;
    self.caizhiLabel.text = [pm.productAttributes[0] attribute2Value];
    self.guigeLabel.text = [[pm.productAttributes[1] attribute2Options][0] optionName];
    self.chicunLabel.text = [pm.productAttributes[2] attribute2Value];
    self.placeLabel.text = [[pm.productAttributes[3] attribute2Options][0] optionName];
    self.postLabel.text = [[pm.productAttributes[4] attribute2Options][0] optionName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
