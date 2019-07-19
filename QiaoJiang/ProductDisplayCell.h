//
//  ProductDisplayCell.h
//  QiaoJiang
//
//  Created by GL on 2019/7/12.
//  Copyright © 2019年 GL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDisplayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProductDisplayCell : UICollectionViewCell

-(void)refreshUI:(ProductDisplayModel *)model;

@end

NS_ASSUME_NONNULL_END
