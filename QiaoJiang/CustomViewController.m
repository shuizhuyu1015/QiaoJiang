//
//  CustomViewController.m
//  QiaoJiang
//
//  Created by mac on 16/3/18.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import "CustomViewController.h"

@interface CustomViewController ()

@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.tintColor = [UIColor lightGrayColor];

    UIViewController *vc1 = self.viewControllers[0];
    vc1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"精选" image:[self loadImage:@"tab_shang_nor@2x"] selectedImage:[self loadImage:@"tab_shang_sel@2x"]];
    vc1.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    UIViewController *vc2 = self.viewControllers[1];
    vc2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"分类" image:[self loadImage:@"tab_fen_nor@2x"] selectedImage:[self loadImage:@"tab_fen_sel@2x"]];
    vc2.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    UIViewController *vc3 = self.viewControllers[2];
    vc3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"匠心" image:[self loadImage:@"tab_jiang_nor@2x"] selectedImage:[self loadImage:@"tab_jiang_sel@2x"]];
    vc3.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    UIViewController *vc4 = self.viewControllers[3];
    vc4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[self loadImage:@"tab_my_nor@2x"] selectedImage:[self loadImage:@"tab_my_sel@2x"]];
    vc4.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
}

-(UIImage *)loadImage:(NSString *)str
{
    UIImage *image = [[UIImage imageNamed:str] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
