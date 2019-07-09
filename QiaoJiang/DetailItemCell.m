//
//  DetailItemCell.m
//  QiaoJiang
//
//  Created by mac on 16/3/18.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import "DetailItemCell.h"
#import "UIImageView+WebCache.h"
#import "interface.h"

@interface DetailItemCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation DetailItemCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

-(void)refreshUI:(DetailModel *)dm
{
    NSString *urlStr = [NSString stringWithFormat:kImage,dm.product.productImage];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"default_item"]];
    
    self.nameLabel.text = dm.product.productName;
    
    NSString *price = [NSString stringWithFormat:@"￥%ld.%ld",dm.product.finalPrice/10000,dm.product.finalPrice%10000/1000];
    self.priceLabel.text = price;
}

@end
