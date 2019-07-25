//
//  UITableView+EmptyPlaceHolder.m
//  tgjhealth
//
//  Created by GL on 2018/7/24.
//  Copyright © 2018年 泰管家. All rights reserved.
//

#import "UITableView+EmptyPlaceHolder.h"

@implementation UITableView (EmptyPlaceHolder)

-(void)tableViewDisplayView:(UIView *)displayView ifNecessaryForRowCount:(NSUInteger)rowCount {
    if (rowCount == 0) {
        self.backgroundView = displayView;
        self.scrollEnabled = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.backgroundView = nil;
        self.scrollEnabled = YES;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}

@end
