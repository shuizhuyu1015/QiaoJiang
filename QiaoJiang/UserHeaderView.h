//
//  UserHeaderView.h
//  QiaoJiang
//
//  Created by mac on 16/4/6.
//  Copyright © 2016年 GL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@end
