//
//  OtherDetailCell.m
//  QiaoJiang
//
//  Created by mac on 16/3/21.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import "OtherDetailCell.h"
#import "interface.h"

@interface OtherDetailCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation OtherDetailCell

- (void)awakeFromNib {
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
}

-(void)refreshUI:(ProRefModel *)rm
{
    NSString *imgUrl = [NSString stringWithFormat:kImage,rm.productImage];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"default_item"]];
    self.nameLabel.text = rm.productName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%ld.%ld",rm.finalPrice/10000,rm.finalPrice%10000/1000];
}

@end
