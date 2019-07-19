//
//  AdvertiseCell.m
//  QiaoJiang
//
//  Created by GL on 2019/7/11.
//  Copyright © 2019年 GL. All rights reserved.
//

#import "AdvertiseCell.h"
#import "AdvertiseModel.h"

@interface AdvertiseCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation AdvertiseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)refreshImage:(NSString *)imageUrl title:(NSArray *)titles {
    [self.bannerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"default_item"]];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] init];
    for (TitleModel *tModel in titles) {
        if (tModel.text.length) {
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:tModel.text attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:[tModel.textColor stringByReplacingOccurrencesOfString:@"#" withString:@""]]}];
            [attStr appendAttributedString:str];
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        }
    }
    self.titleLabel.attributedText = attStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
