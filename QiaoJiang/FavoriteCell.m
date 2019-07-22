//
//  FavoriteCell.m
//  QiaoJiang
//
//  Created by Gray on 2019/7/21.
//  Copyright © 2019年 GL. All rights reserved.
//

#import "FavoriteCell.h"

@interface FavoriteCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *markLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@end

@implementation FavoriteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)refreshUI:(id)model {
    if ([model isKindOfClass:[ProductDisplayModel class]]) {
        ProductDisplayModel *pModel = model;
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[pModel.featureImage stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:[UIImage imageNamed:@"default_item"]];
        
        self.titleLabel.text = pModel.name;
        
        self.markLabel.text = pModel.brandName;
        
        self.tagLabel.text = [NSString stringWithFormat:@"¥%.2f", pModel.price];
        
    }else if ([model isKindOfClass:[Case class]]) {
        Case *cModel = model;
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[cModel.cover stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:[UIImage imageNamed:@"default_item"]];
        
        self.titleLabel.text = cModel.title;
        
        self.markLabel.text = cModel.user_name;
        
        self.tagLabel.text = [NSString stringWithFormat:@"预算：%@", cModel.budget];
        
    }else if ([model isKindOfClass:[RecDetailModel class]]) {
        RecDetailModel *rModel = model;
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[rModel.coverUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:[UIImage imageNamed:@"default_item"]];
        
        self.titleLabel.text = rModel.subject;
        
        self.markLabel.text = rModel.author;
        
        self.tagLabel.text = nil;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
