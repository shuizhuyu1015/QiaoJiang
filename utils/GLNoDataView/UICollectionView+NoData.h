//
//  UICollectionView+NoData.h
//  QiaoJiang
//
//  Created by GL on 2019/7/25.
//  Copyright © 2019年 GL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (NoData)

-(void)displayView:(UIView *)displayView ifNecessaryForItemCount:(NSUInteger)itemCount;

@end

NS_ASSUME_NONNULL_END
