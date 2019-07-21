//
//  ProductDetailCell.h
//  QiaoJiang
//
//  Created by Gray on 2019/7/20.
//  Copyright © 2019年 GL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDetailModel.h"

@interface ProductDetailCell : UITableViewCell

-(void)refreshCellUI:(ProductDetailModel *)model;

@end
