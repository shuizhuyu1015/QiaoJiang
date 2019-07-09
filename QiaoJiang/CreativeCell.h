//
//  CreativeCell.h
//  QiaoJiang
//
//  Created by GL on 2019/7/8.
//  Copyright © 2019年 GL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IdeaModel.h"
#import "RecommendModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^IconBlock)(NSString *);

@interface CreativeCell : UICollectionViewCell

@property (nonatomic,copy) IconBlock block;

-(void)refreshModel:(id)model;

@end

NS_ASSUME_NONNULL_END
