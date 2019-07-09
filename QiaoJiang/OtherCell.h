//
//  OtherCell.h
//  QiaoJiang
//
//  Created by mac on 16/3/21.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OtherBlock)(NSInteger);

@interface OtherCell : UITableViewCell

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,copy) OtherBlock block;

@end
