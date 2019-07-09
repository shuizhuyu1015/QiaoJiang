//
//  RelatedCell.h
//  QiaoJiang
//
//  Created by administrator on 16/3/29.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IdeaDetailModel.h"
#import "RecDetailModel.h"

@interface RelatedCell : UITableViewCell

-(void)refreshUI:(RelatedIdea *)ri;

-(void)refreshModel:(Related *)re;

@end
