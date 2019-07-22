//
//  IdeaDetailViewController.m
//  QiaoJiang
//
//  Created by mac on 16/3/29.
//  Copyright © 2016年 GL. All rights reserved.
//

#import "IdeaDetailViewController.h"
#import "interface.h"
#import "DetailHeaderView.h"
#import "RelatedCell.h"
#import "IdeaDetailModel.h"
#import "UserViewController.h"

#import <WebKit/WebKit.h>

#define kScreenSize [UIScreen mainScreen].bounds.size

@interface IdeaDetailViewController () <UITableViewDataSource,UITableViewDelegate,WKNavigationDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) DetailHeaderView *hv;
@property (nonatomic, strong) WKWebView *kWebView;

@end

@implementation IdeaDetailViewController
{
    IdeaDetailModel *dm;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"家装创意";
    [self resetNavigation];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    label.center = self.view.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"正在加载,请骚等...";
    label.textColor = [UIColor grayColor];
    [self.view addSubview:label];
    
    //创建webView
    _kWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, WID, 1)];
    _kWebView.navigationDelegate = self;
    _kWebView.scrollView.scrollEnabled = NO;
    
    [self loadNetworkData];
}

-(void)resetNavigation
{
    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
    NSData *collectedData = [userDefault objectForKey:COLLECTED_IDEA];
    NSDictionary *collectedDic = [NSKeyedUnarchiver unarchiveObjectWithData:collectedData];
    
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(0, 0, 40, 40);
    [collectBtn setImage:[UIImage imageNamed:@"collection_sel"] forState:UIControlStateSelected];
    [collectBtn setImage:[UIImage imageNamed:@"collection_nor"] forState:UIControlStateNormal];
    [collectBtn addTarget:self action:@selector(collectIdea:) forControlEvents:UIControlEventTouchUpInside];
    collectBtn.selected = [collectedDic.allKeys containsObject:self.group_id];
    UIBarButtonItem *collectionBBI = [[UIBarButtonItem alloc] initWithCustomView:collectBtn];
    
    UIBarButtonItem *closeBBI = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(clickCloseBBI)];
    
    UIBarButtonItem *flexBBI = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.navigationItem.rightBarButtonItems = @[closeBBI, flexBBI, collectionBBI];
}

//收藏本文
-(void)collectIdea:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
    NSData *collectedData = [userDefault objectForKey:COLLECTED_IDEA];
    NSDictionary *collectedDic = [NSKeyedUnarchiver unarchiveObjectWithData:collectedData];
    NSMutableDictionary *dicM = nil;
    if(collectedDic == nil) {
        dicM = [[NSMutableDictionary alloc] init];
    }else{
        dicM = [NSMutableDictionary dictionaryWithDictionary:collectedDic];
    }
    
    if(sender.isSelected){
        if(dm == nil) {
            return;
        }
        [dicM setValue:dm.userCase forKey:self.group_id];
        [self showHint:@"收藏成功"];
    }else{
        [dicM removeObjectForKey:self.group_id];
        [self showHint:@"取消收藏"];
    }
    NSData *allData = [NSKeyedArchiver archivedDataWithRootObject:dicM];
    [userDefault setObject:allData forKey:COLLECTED_IDEA];
    [userDefault synchronize];
}

-(void)clickCloseBBI {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//加载tableView
-(void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-kTopHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollsToTop = YES;
    _tableView.sectionFooterHeight = CGFLOAT_MIN;
    _tableView.contentInset = UIEdgeInsetsMake(327, 0, 0, 0);
    
    _hv = [[NSBundle mainBundle] loadNibNamed:@"DetailHeaderView" owner:self options:nil][0];
    _hv.frame = CGRectMake(0, -327, CGRectGetWidth(self.view.bounds), 327);
    __weak typeof(self) weakSelf = self;
    _hv.block = ^void(NSString *user_id){
        UserViewController *uvc = [[UserViewController alloc] init];
        uvc.user_id = user_id;
        uvc.url = kIdeaUser;
        uvc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:uvc animated:YES];
    };
    [_tableView addSubview:_hv];
    
    [_tableView registerNib:[UINib nibWithNibName:@"RelatedCell" bundle:nil] forCellReuseIdentifier:@"RelatedCellID"];
    
    [self.view addSubview:_tableView];
}

//请求数据
-(void)loadNetworkData
{
    NSString *url = [NSString stringWithFormat:kDetail,self.group_id];
    [[HDNetworking sharedHDNetworking] GET:url parameters:nil success:^(id  _Nonnull responseObject) {
        dm = [[IdeaDetailModel alloc] initWithDictionary:responseObject[@"data"] error:nil];
        [self.dataSource addObjectsFromArray:dm.relatedIdea];
        
        [self initTableView]; //请求成功,加载tableView
        
        [_hv refreshUI:dm];
        [self initWebView:dm.userCase.content]; //webView加载html请求
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

//加载webView
-(void)initWebView:(NSString *)content
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"web" ofType:@"html"];
    NSString *template = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *html = [NSString stringWithFormat:template,content]; //拼接html模板
    [self.kWebView loadHTMLString:html baseURL:nil];
}

#pragma mark - webView代理方法
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"图片加载中";
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSString *js = [NSString stringWithFormat:@"imgAutoFit(%lf)",WID - 16];
    [webView evaluateJavaScript:js completionHandler:nil];
    
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        CGFloat documentHeight = [result doubleValue];
        CGRect webFrame = webView.frame;
        webFrame.size.height = documentHeight;
        webView.frame = webFrame;
        [_tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if(navigationAction.navigationType == WKNavigationTypeLinkActivated)//判断是否是点击链接
    {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
    return;
}

#pragma mark - tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return self.dataSource.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            [cell.contentView addSubview:self.kWebView];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        RelatedCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"RelatedCellID" forIndexPath:indexPath];
        [cell2 refreshUI:self.dataSource[indexPath.row]];
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.kWebView.frame.size.height + 30;
    }
    return 116;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 50)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    if (section == 0) {
        if (dm) {
            label.text = [NSString stringWithFormat:@"#%@   #%@   #%@   #%@",dm.userCase.size, dm.userCase.style, dm.userCase.area, dm.userCase.budget];
        }
    }else{
        label.text = @"更多相关内容";
    }
    return label;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        IdeaDetailViewController *dvc = [[IdeaDetailViewController alloc] init];
        dvc.group_id = [self.dataSource[indexPath.row] relatedID];
        [self.navigationController pushViewController:dvc animated:YES];
    }
    
}

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

#pragma mark - scrollView代理方法
//下拉顶部图片放大
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    if (y < -327) {
        [_hv resetFrame:y];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
        NSURLCache * cache = [NSURLCache sharedURLCache];
        [cache removeAllCachedResponses];
        [cache setDiskCapacity:0];
        [cache setMemoryCapacity:0];
}


@end
