//
//  ProductDisplayCell.m
//  QiaoJiang
//
//  Created by GL on 2019/7/12.
//  Copyright © 2019年 GL. All rights reserved.
//

#import "ProductDisplayCell.h"

@interface ProductDisplayCell ()
@property (weak, nonatomic) IBOutlet UIImageView *featureImageView;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rawPriceLabel;

@end

@implementation ProductDisplayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
}

-(void)refreshUI:(ProductDisplayModel *)model {
    [self.featureImageView sd_setImageWithURL:[NSURL URLWithString:model.featureImage] placeholderImage:[UIImage imageNamed:@"default_item"]];
    
    self.brandLabel.text = [NSString stringWithFormat:@"品牌：%@", model.brandName];
    
    self.nameLabel.text = model.name;
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", model.price];
    
    if (model.rush) {
        NSString *rawPriceStr = [NSString stringWithFormat:@"¥%.2f", model.rawPrice];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:rawPriceStr];
        [attStr addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid), NSStrokeColorAttributeName:[UIColor grayColor], NSBaselineOffsetAttributeName:@(0)} range:NSMakeRange(0, rawPriceStr.length)];
        self.rawPriceLabel.attributedText = attStr;
    }else{
        self.rawPriceLabel.text = nil;
    }
}

@end
