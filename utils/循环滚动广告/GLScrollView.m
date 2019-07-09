//
//  GLScrollView.m
//
//  Created by mac on 16/1/12.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import "GLScrollView.h"
#import "interface.h"
#import "IdeaModel.h"

@interface GLScrollView () <UIScrollViewDelegate>
{
    NSInteger _count; // 记录图片下标，定时器滚动到哪一张图
}

@property (nonatomic,strong) UIScrollView *scrollView;  // 滚动视图
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UILabel *label;  // 图片标题
@property (nonatomic,strong) NSTimer *timer; //定时器

@end

@implementation GLScrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        CGFloat w = frame.size.width;
        CGFloat h = frame.size.height;
        //创建滚屏
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.bounces = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.tag = 10;
        self.scrollView.scrollsToTop = NO;
        [self addSubview:self.scrollView];
        
        //创建标题
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, h - 30, w/3 *2, 30)];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = [UIColor whiteColor];
        self.label.font = [UIFont systemFontOfSize:15];
        // 设置颜色透明度
        self.label.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        self.label.tag = 20;
        [self addSubview:self.label];
        
        //创建pageControl
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(w / 3 * 2, h - 30, w / 3, 30)];
        self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        self.pageControl.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        self.pageControl.tag = 30;
        [self addSubview:self.pageControl];
        
        //图片手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
        [self.scrollView addGestureRecognizer:tap];
    }
    return self;
}

-(void)clickImage:(UITapGestureRecognizer *)tap
{
    if (self.block) {
        self.block([_imageArr[_count-1] group_id]);
    }
}

// 重写imageArr的set方法，将图片名数组传进来创建滚屏图片
-(void)setImageArr:(NSArray *)imageArr
{
    if (imageArr.count == 0) {
        return;
    }
    _imageArr = imageArr;
    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    
    // 设置scrolView的contentSize
    self.scrollView.contentSize = CGSizeMake(w * (_imageArr.count + 2), 0);
    // 设置pageControl的numPage
    self.pageControl.numberOfPages = _imageArr.count;
    // 设置label的名字   
    self.label.text = [_imageArr[0] title];
    
    for (int i = 0; i<imageArr.count + 2; i++) {
        //  √√√  重要,否则每刷新一次图片会叠加
        UIView *tmpV = [_scrollView viewWithTag:111 + i];
        [tmpV removeFromSuperview]; //清除上次的图片
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(w * i, 0, w, h)];
         imageView.tag = 111 + i;
        NSURL *url = nil;
        if (i == 0) {
            // 开头是最后一张
            url = [NSURL URLWithString:[[_imageArr lastObject] imageUrl]];
        }else if (i == imageArr.count + 1){
            // 末尾是第一张
            url = [NSURL URLWithString:[[_imageArr firstObject] imageUrl]];
        }else{
            url = [NSURL URLWithString:[_imageArr[i-1] imageUrl]];
        }
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_item"]];
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.scrollView addSubview:imageView];

    }
    // 默认启动偏移量
    self.scrollView.contentOffset = CGPointMake(w, 0);
    
    //启动定时器
    [self.timer invalidate];
    [self startTimer];
    _count = 1; // 启动，开始第一张图片

}

-(void)startTimer
{
   self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updataTimer:) userInfo:nil repeats:YES];
    
    //定时器和滚动视图共存
    NSRunLoop *currentRunloop = [NSRunLoop currentRunLoop];
    [currentRunloop addTimer:_timer forMode:NSRunLoopCommonModes];
}

// 定时器回调方法，自动滚屏
-(void)updataTimer:(NSTimer *)timer
{
    _count++;
    if (_count == self.imageArr.count + 1) {
        _count = 1;
        // 解决循环滚动问题: 已经滚动最后一张图，将要滚动到第一张图的时候，瞬间切换到{0，0}过渡
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
    // 设置scrollView的偏移量
    [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width * _count, 0) animated:YES];
    // 设置pageControl的当前点
    self.pageControl.currentPage = _count - 1;
    self.label.text = [self.imageArr[_count-1] title];
    
}
// 总结: _count <---> contentOffser <---> currentPage 同步改变

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat w = self.bounds.size.width;
    if (scrollView.contentOffset.x / w == self.imageArr.count + 1) {
        scrollView.contentOffset = CGPointMake(w, 0);
    }else if (scrollView.contentOffset.x / w == 0){
        scrollView.contentOffset = CGPointMake(w * self.imageArr.count, 0);
    }
    // pageControl同步
    self.pageControl.currentPage = scrollView.contentOffset.x / w - 1;
    
    _count = self.pageControl.currentPage + 1;
    
    // label文字同步
    self.label.text = [self.imageArr[_count-1] title];
    

}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
