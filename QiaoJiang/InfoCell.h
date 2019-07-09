//
//  InfoCell.h
//  QiaoJiang
//
//  Created by mac on 16/3/21.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@interface InfoCell : UITableViewCell

-(void)refreshInfo:(ProductModel *)pm;

@end
