//
//  ScrollViewTopView.m
//  滚动视图
//
//  Created by wuyiguang on 15/12/5.
//  Copyright (c) 2015年 YG. All rights reserved.
//

#import "YGScrollTitleView.h"

// 按钮的起始tag
#define kBtnTag 777

// 每屏所显示按钮的最大个数
#define kSingleViewBtnCount 5

// 按钮的超出部分
#define kBtnBeyondWidth 5

@interface YGScrollTitleView ()

@property (nonatomic, copy) CallBack block;

@end

@implementation YGScrollTitleView
{
    UIScrollView *_scrollView;
    UIView *_topLine;
    
    // 记录当前选择的按钮
    NSInteger _index;
    
    // 记录titles count
    NSInteger _titlesCount;
    
    CGFloat _btnWidth;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles callBack:(CallBack)block
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        _titlesCount = titles.count;
        
        self.block = block;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.scrollsToTop = NO;
        
        [self addSubview:_scrollView];
        
        // 计算按钮的宽度
        if (titles.count <= kSingleViewBtnCount) {
            _btnWidth = self.bounds.size.width / titles.count;
        } else {
            _btnWidth = self.bounds.size.width / kSingleViewBtnCount + kBtnBeyondWidth;
        }
        
        _scrollView.contentSize = CGSizeMake(titles.count * _btnWidth, _scrollView.bounds.size.height);
        
        for (int i = 0; i < titles.count; i++)
        {
            UIButton *btn = [self createBtn:CGRectMake(_btnWidth * i, 0, _btnWidth, self.bounds.size.height) title:titles[i]];
            [_scrollView addSubview:btn];
            
            btn.tag = kBtnTag + i;
            
            if (i == 0) {
                btn.selected = YES;
                
                _index = 0;
                
                // 线条
                _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-2, _btnWidth, 2)];
                _topLine.backgroundColor = [UIColor colorWithRed:65/255.0 green:236/255.0 blue:155/255.0 alpha:1];
                [_scrollView addSubview:_topLine];
            }
        }
    }
    return self;
}

- (UIButton *)createBtn:(CGRect)frame title:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:70/255.0 green:195/255.0 blue:146/255.0 alpha:1] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)btnClick:(UIButton *)sender
{
    if (sender.selected) return;
    
    sender.selected = YES;
    
    UIButton *oldBtn = (UIButton *)[_scrollView viewWithTag:kBtnTag + _index];
    
    oldBtn.selected = NO;
    
    // 记录新的下标
    _index = sender.tag - kBtnTag;
    
    // 回调
    if (self.block) {
        self.block(_index);
    }
}

/**
 选择对应的按钮
 */
- (void)selectButtonIndex:(NSInteger)index
{
    UIButton *btn = (UIButton *)[_scrollView viewWithTag:kBtnTag + index];
    
    if (btn.selected) return;
    
    btn.selected = YES;
    
    // 将之前的变为不选中
    UIButton *oldBtn = (UIButton *)[_scrollView viewWithTag:kBtnTag + _index];
    
    oldBtn.selected = NO;
    
    // 记录
    _index = index;
}

/**
 设置底部线条的实时偏移量
 */
- (void)moveTopViewLine:(CGPoint)point
{
    CGRect rect = _topLine.frame;
    
    if (_titlesCount <= kSingleViewBtnCount)
    {
        rect.origin.x = point.x / _titlesCount;
    }
    else
    {
        // 计算超过kSingleViewBtnCount个数按钮的线条偏移量
        rect.origin.x = (point.x / kSingleViewBtnCount) + (point.x / self.bounds.size.width * kBtnBeyondWidth);
    }
    
    _topLine.frame = rect;
    
    // 修改scrollView的偏移量
    [_scrollView scrollRectToVisible:rect animated:YES];
}

@end
