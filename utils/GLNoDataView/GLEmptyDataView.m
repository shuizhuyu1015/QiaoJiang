//
//  GLEmptyDataView.m
//  tgjhealth
//
//  Created by GL on 2018/7/24.
//  Copyright © 2018年 泰管家. All rights reserved.
//

#import "GLEmptyDataView.h"

@interface GLEmptyDataView ()
@property (nonatomic,strong) UIImageView *holderImageView;
@property (nonatomic,strong) UILabel *holderLabel;
@end

@implementation GLEmptyDataView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void) setupUI
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.holderImageView];
    [self addSubview:self.holderLabel];
}

-(void)setPlaceHolderIcon:(NSString *)placeHolderIcon {
    _placeHolderIcon = placeHolderIcon;
    self.holderImageView.image = [UIImage imageNamed:placeHolderIcon];
}

-(void)setPlaceHolderText:(NSString *)placeHolderText {
    _placeHolderText = placeHolderText;
    self.holderLabel.text = placeHolderText;
}

- (UIImageView *) holderImageView
{
    if(_holderImageView == nil) {
        CGFloat imgWH = 120.0f;
        _holderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.center.x-imgWH*0.5, self.center.y-imgWH, imgWH, imgWH)];
        _holderImageView.image = [UIImage imageNamed:@"icon_noshuju"];
    }
    return _holderImageView;
}

- (UILabel *) holderLabel
{
    if(_holderLabel == nil) {
        _holderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.holderImageView.frame)+10, self.frame.size.width, 19)];
        _holderLabel.text = @"暂无数据";
        _holderLabel.font = [UIFont systemFontOfSize:15.0f];
        _holderLabel.textAlignment = NSTextAlignmentCenter;
        _holderLabel.textColor = [UIColor colorWithHexString:@"666666"];
    }
    return _holderLabel;
}

@end
