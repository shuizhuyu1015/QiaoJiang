//
//  GLScrollView.m
//
//  Created by mac on 16/1/12.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import "GLScrollView.h"

@interface GLScrollView () <UIScrollViewDelegate>
{
    NSInteger _count; // 记录图片下标，定时器滚动到哪一张图
}

@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UILabel *label;  // 图片标题
@property (nonatomic,strong) NSTimer *timer; //定时器

@end

@implementation GLScrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        CGFloat W = frame.size.width;
        CGFloat H = frame.size.height;
        
        //创建滚屏
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.bounces = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.tag = 10;
        [self addSubview:self.scrollView];

        //创建标题
//        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, H - 30, W/3 *2, 30)];
//        self.label.textAlignment = NSTextAlignmentCenter;
//        self.label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
//        // 设置颜色透明度
//        self.label.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
//        self.label.tag = 20;
//        [self addSubview:self.label];
        
        //创建pageControl
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(W / 3 * 1, H - 30, W / 3, 30)];
        self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        self.pageControl.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0];
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
        self.block(_count);
    }
}

// 重写imageArr的set方法，将图片名数组传进来创建滚屏图片
-(void)setImageArr:(NSArray *)imageArr
{
    _imageArr = imageArr;
    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;

    // 设置pageControl的numPage
    self.pageControl.hidden = imageArr.count <= 1 ? YES : NO;
    self.pageControl.numberOfPages = imageArr.count;
    // 用模型的标题属性,设置label的名字,
//    self.label.text = titleArr[0];
    
    //  √√√  重要,清除上次的图片,否则每刷新一次图片会叠加
    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    if (imageArr.count == 1) {
        // 设置scrolView的contentSize
        self.scrollView.contentSize = CGSizeMake(w, h);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[imageArr[0] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:[UIImage imageNamed:@"default_item"]];
        [self.scrollView addSubview:imageView];
        
    }else if (imageArr.count > 1){
        // 设置scrolView的contentSize
        self.scrollView.contentSize = CGSizeMake(w * (imageArr.count + 2), h);
        
        for (int i = 0; i<imageArr.count + 2; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(w * i, 0, w, h)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.tag = 111+i;
            if (i == 0) {
                // 开头是最后一张
                [imageView sd_setImageWithURL:[NSURL URLWithString:[[imageArr lastObject] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:[UIImage imageNamed:@"default_item"]];
            }else if (i == imageArr.count + 1){
                // 末尾是第一张
                [imageView sd_setImageWithURL:[NSURL URLWithString:[[imageArr firstObject] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:[UIImage imageNamed:@"default_item"]];
            }else{
                [imageView sd_setImageWithURL:[NSURL URLWithString:[imageArr[i-1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:[UIImage imageNamed:@"default_item"]];
            }
            
            [self.scrollView addSubview:imageView];
        }
        // 默认启动偏移量
        self.scrollView.contentOffset = CGPointMake(w, 0);
    }
    
    _count = 1; // 启动，开始第一张图片
    self.pageControl.currentPage = _count - 1;
    //启动定时器
    if (imageArr.count > 1) {
        [self.timer invalidate];
        self.timer = nil;
        [self startTimer];
    }
}

-(void)startTimer
{
   self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(updataTimer:) userInfo:nil repeats:YES];
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
//    self.label.text = titleArr[self.pageControl.currentPage];
    
}
// 总结: _count <---> contentOffset <---> currentPage 同步改变

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
    // label文字同步
//    self.label.text = titleArr[self.pageControl.currentPage]; // 如换成标题名，可在这里换成标题数组

    _count = scrollView.contentOffset.x / w;
     
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
    self.timer = nil;
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
