//
//  JingXuanCell.h
//  QiaoJiang
//
//  Created by mac on 16/3/17.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JXBlock)(NSInteger productId);

@interface JingXuanCell : UITableViewCell

@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,copy) JXBlock block;

@end
