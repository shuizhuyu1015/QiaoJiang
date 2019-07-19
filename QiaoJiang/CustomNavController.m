//
//  CustomNavController.m
//  QiaoJiang
//
//  Created by GL on 2019/7/12.
//  Copyright © 2019年 GL. All rights reserved.
//

#import "CustomNavController.h"

@interface CustomNavController () <UIGestureRecognizerDelegate>

@end

@implementation CustomNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //item字体颜色
    self.navigationBar.tintColor = [UIColor whiteColor];
    //title字体属性
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    //状态栏白字
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.interactivePopGestureRecognizer.delegate = self; //右滑返回
}

//重写push方法 ，设置全局返回按钮
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 非根控制器
        
        viewController.hidesBottomBarWhenPushed = YES;

    }
    
    // 真正在跳转
    [super pushViewController:viewController animated:animated];
    
    //修改tabbar的frame
//    CGRect tabbarFrame = self.tabBarController.tabBar.frame;
//    tabbarFrame.origin.y = HEI - tabbarFrame.size.height;
//    self.tabBarController.tabBar.frame = tabbarFrame;
}

-(void)backAction
{
    [self popViewControllerAnimated:YES];
}

#pragma mark -UIGestureRecognizerDelegate
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.childViewControllers.count > 0 ? YES : NO;
}



@end
