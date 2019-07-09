//
//  MyViewController.m
//  QiaoJiang
//
//  Created by mac on 16/3/24.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import "MyViewController.h"
#import "SettingViewController.h"

@interface MyViewController ()

@end

@implementation MyViewController

-(void)resetNavigation
{
    //返回键只保留箭头
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    //item字体颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //title字体属性
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    //导航和状态栏样式,黑底白字
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (IBAction)clickSetBtn:(UIBarButtonItem *)sender {
    SettingViewController *svc = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self resetNavigation];
    

    
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
