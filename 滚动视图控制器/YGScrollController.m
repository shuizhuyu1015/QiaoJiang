//
//  YGScrollController.m
//  滚动视图
//
//  Created by wuyiguang on 15/11/5.
//  Copyright (c) 2015年 YG. All rights reserved.
//

#import "YGScrollController.h"
#import "YGScrollTitleView.h"
#import "SearchViewController.h"
#include "interface.h"

@interface YGScrollController () <UIScrollViewDelegate>

// 用来放viewController的view
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) YGScrollTitleView *titleView;

@end

@implementation YGScrollController
{
    NSArray *_titles;
    NSMutableArray *_tops;
}

-(void)resetNavigation
{
    // 设置自动调整ScrollView的ContentInset
    self.automaticallyAdjustsScrollViewInsets = NO;
    //返回键只保留箭头
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    //item字体颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //title字体属性
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    //状态栏白字
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(clickSearch:)];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self resetNavigation];
    
    // 标题
    _titles = @[@"家装创意", @"小匠推荐"];
    
    [self addYGScrollTitleView];
    
    [self refreshControlller];
}

//点击搜索
-(void)clickSearch:(UIBarButtonItem *)bbi
{
    SearchViewController *svc = [[SearchViewController alloc] init];
    //判断当前是哪个view
    if (_scrollView.contentOffset.x / _scrollView.bounds.size.width == 0) {
        svc.url = kIdeaSearch;
    }else if (_scrollView.contentOffset.x / _scrollView.bounds.size.width == 1){
        svc.url = kRecSearch;
    }
    svc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:svc animated:YES];
}

#pragma mark - 创建YGScrollTitleView

- (void)addYGScrollTitleView
{
    // 创建YGSrollViewTitleView
    _titleView = [[YGScrollTitleView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 40) titles:_titles callBack:^(NSInteger pageIndex) {
        
        // 点击头部按钮时的回调
        // 设置scrollView的偏移量
        [_scrollView setContentOffset:CGPointMake(pageIndex * _scrollView.bounds.size.width, 0) animated:NO];
        
        //重置bool数组的值
        [self resetTops:pageIndex];
        //发送点击标题改变bool值的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"点标题" object:_tops];
    }];
    
    [self.view addSubview:_titleView];
    
    
    // 创建滚动视图控制器的scrollView
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame), self.view.bounds.size.width, self.view.bounds.size.height)];
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * _titles.count, _scrollView.bounds.size.height);
    
    [self.view addSubview:_scrollView];
}

#pragma mark - 加载视图控制器

- (void)refreshControlller
{
    _tops = [[NSMutableArray alloc] init];
    // 需要添加到scrollView中的视图控制器
    NSArray *vcNames = @[@"IdeaViewController", @"RecommendViewController"];
    
    for (int i = 0; i < _titles.count; i++)
    {
        [_tops addObject:@(NO)];
        
        UIViewController *vc = [[NSClassFromString(vcNames[i]) alloc] init];
        
        // 1. 往父视图控制器中添加vc
        [self addChildViewController:vc];
        
        // 2. 将vc的view的x坐标偏移
        vc.view.frame = CGRectMake(_scrollView.bounds.size.width * i, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
        // 3. vc.view添加到scrollView上
        [_scrollView addSubview:vc.view];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    [_titleView selectButtonIndex:index];
    
    //重置bool数组的值
    [self resetTops:index];
    //发送滚动bool值通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"滚动" object:_tops];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_titleView moveTopViewLine:scrollView.contentOffset];
}

//重置bool数组的值
-(void)resetTops:(NSInteger)index
{
    for (NSInteger i = 0; i<_tops.count; i++) {
        if (i == index) {
            [_tops replaceObjectAtIndex:i withObject:@(YES)];
        }else{
            [_tops replaceObjectAtIndex:i withObject:@(NO)];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
