//
//  ProHeadView.h
//  QiaoJiang
//
//  Created by mac on 16/3/21.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProHeadView : UIView

@property (nonatomic,strong) NSArray *images;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
