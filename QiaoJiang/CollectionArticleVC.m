//
//  CollectionArticleVC.m
//  QiaoJiang
//
//  Created by GL on 2019/7/22.
//  Copyright © 2019年 GL. All rights reserved.
//

#import "CollectionArticleVC.h"

@interface CollectionArticleVC ()

@end

@implementation CollectionArticleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"收藏";
    
    [self loadData];
}

#pragma mark - 加载数据
-(void)loadData {
    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
    NSData *collectedData = [userDefault objectForKey:COLLECTED_IDEA];
    NSDictionary *collectedDic = [NSKeyedUnarchiver unarchiveObjectWithData:collectedData];
    NSLog(@"data = %@", collectedDic);
}

@end
