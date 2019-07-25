//
//  UITableView+EmptyPlaceHolder.h
//  tgjhealth
//
//  Created by GL on 2018/7/24.
//  Copyright © 2018年 泰管家. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (EmptyPlaceHolder)

- (void) tableViewDisplayView:(UIView *)displayView ifNecessaryForRowCount:(NSUInteger) rowCount;

@end
