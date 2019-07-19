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

- (IBAction)clickSetBtn:(UIBarButtonItem *)sender {
    SettingViewController *svc = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
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
