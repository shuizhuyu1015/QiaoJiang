//
//  ProHeadView.m
//  QiaoJiang
//
//  Created by mac on 16/3/21.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import "ProHeadView.h"
#import "interface.h"
#import "ProductModel.h"

@interface ProHeadView () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation ProHeadView

-(void)awakeFromNib
{
    [super awakeFromNib];
    _scrollView.delegate = self;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat w = scrollView.frame.size.width;
    _pageControl.currentPage = scrollView.contentOffset.x / w;
    
}

-(void)setImages:(NSArray *)images
{
    _images = images;
    if (_images.count == 0) {
        return;
    }
    
    CGFloat w = _scrollView.frame.size.width;
    CGFloat h = _scrollView.frame.size.height;
    _scrollView.contentSize = CGSizeMake(w * self.images.count, _scrollView.frame.size.height);
    _pageControl.numberOfPages = self.images.count;
    
    for (int i = 0; i<self.images.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(w * i, 0, w, h)];
        NSString *urlStr = [NSString stringWithFormat:kImage,[self.images[i] pictureUri]];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"default_item"]];
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [_scrollView addSubview:imageView];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
