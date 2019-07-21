//
//  ProductDetailCell.m
//  QiaoJiang
//
//  Created by Gray on 2019/7/20.
//  Copyright © 2019年 GL. All rights reserved.
//

#import "ProductDetailCell.h"
@interface ProductDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation ProductDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)refreshCellUI:(ProductDetailModel *)model {
    self.brandLabel.text = model.brandName;
    
    self.nameLabel.text = model.name;
    
    self.priceLabel.text = [self extractPrice:model.variants];
}

//提取价格
-(NSString *)extractPrice:(NSArray *)variants {
    NSMutableArray *pricesArr = [[NSMutableArray alloc] init];
    for (ProductVariantModel *vModel in variants) {
        [pricesArr addObject:@(vModel.price)];
    }
    float maxPrice = [[pricesArr valueForKeyPath:@"@max.floatValue"] floatValue];
    float minPrice = [[pricesArr valueForKeyPath:@"@min.floatValue"] floatValue];
    
    NSString *displayStr = nil;
    if(maxPrice == minPrice) {
        displayStr = [NSString stringWithFormat:@"¥%.2f", minPrice];
    }else {
        displayStr = [NSString stringWithFormat:@"¥%.2f - ¥%.2f", minPrice, maxPrice];
    }
    
    return displayStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
