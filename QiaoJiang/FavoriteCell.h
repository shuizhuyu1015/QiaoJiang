//
//  FavoriteCell.h
//  QiaoJiang
//
//  Created by Gray on 2019/7/21.
//  Copyright © 2019年 GL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IdeaDetailModel.h"
#import "RecDetailModel.h"
#import "ProductDisplayModel.h"

@interface FavoriteCell : UITableViewCell

-(void)refreshUI:(id)model;

@end
