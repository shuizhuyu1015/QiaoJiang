//
//  UICollectionView+NoData.m
//  QiaoJiang
//
//  Created by GL on 2019/7/25.
//  Copyright © 2019年 GL. All rights reserved.
//

#import "UICollectionView+NoData.h"

@implementation UICollectionView (NoData)

-(void)displayView:(UIView *)displayView ifNecessaryForItemCount:(NSUInteger)itemCount {
    if (itemCount == 0) {
        self.backgroundView = displayView;
        self.scrollEnabled = NO;
    } else {
        self.backgroundView = nil;
        self.scrollEnabled = YES;
    }
}

@end
