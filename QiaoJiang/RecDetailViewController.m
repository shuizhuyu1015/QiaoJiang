//
//  RecDetailViewController.m
//  QiaoJiang
//
//  Created by mac on 16/3/30.
//  Copyright © 2016年 GL. All rights reserved.
//

#import "RecDetailViewController.h"
#import "interface.h"
#import "RecDetailModel.h"
#import "DetailHeaderView.h"
#import "RelatedCell.h"
#import "UserViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface RecDetailViewController () <UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) DetailHeaderView *hv;
@property (nonatomic,strong) UIWebView *webView;

@end

@implementation RecDetailViewController
{
    RecDetailModel *rdm;
}

-(void)resetNavigation
{
    self.navigationItem.title = @"小匠推荐";
    //设置导航右button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 80, 50);
    [button setImage:[UIImage imageNamed:@"tab_jiang_nor@2x"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(7, 35, -7, -35)];
    [button addTarget:self action:@selector(clickBBI:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];;
}

//加载tableView
-(void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), HEI-kTopHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollsToTop = YES;
    _tableView.sectionFooterHeight = CGFLOAT_MIN;
    //下拉放大需要注意写的方法,设置偏移量
    _tableView.contentInset = UIEdgeInsetsMake(327, 0, 0, 0);
    
    _hv = [[NSBundle mainBundle] loadNibNamed:@"DetailHeaderView" owner:self options:nil][0];
    _hv.frame = CGRectMake(0, -327, CGRectGetWidth(self.view.bounds), 327);
    __weak typeof(self) weakSelf = self;
    _hv.block = ^void(NSString *user_id){
        UserViewController *uvc = [[UserViewController alloc] init];
        uvc.user_id = user_id;
        uvc.url = kRecomUser;
        uvc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:uvc animated:YES];
    };
    //下拉放大需要注意的
    [_tableView addSubview:_hv];
    
    [_tableView registerNib:[UINib nibWithNibName:@"RelatedCell" bundle:nil] forCellReuseIdentifier:@"RelatedCellID2"];
    
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self resetNavigation];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    label.center = self.view.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"正在加载,请骚等...";
    label.textColor = [UIColor grayColor];
    [self.view addSubview:label];
    
    //创建webView
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    _webView.delegate = self;
    _webView.scrollView.scrollEnabled = NO;
    _webView.scalesPageToFit = YES;
    _webView.dataDetectorTypes = UIDataDetectorTypeLink;
    
    [self loadNetworkData];
}

-(void)clickBBI:(UIBarButtonItem *)bbi
{
    //点击返回首页
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//请求数据
-(void)loadNetworkData
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *url = [NSString stringWithFormat:kRecDetail,self.tid];
    [[HDNetworking sharedHDNetworking] GET:url parameters:nil success:^(id  _Nonnull responseObject) {
        rdm = [[RecDetailModel alloc] initWithDictionary:responseObject[@"data"][@"posts"][0] error:nil];
        [self.dataSource addObjectsFromArray:rdm.related];
        
        [self initTableView]; //请求成功,加载tableView
        
        //刷新表头
        [_hv.coverImage sd_setImageWithURL:[NSURL URLWithString:responseObject[@"data"][@"cover"]] placeholderImage:[UIImage imageNamed:@"default_item"]];
        [_hv refreshUI:rdm];
        
        [self initWebView:rdm.message_div]; //webView加载html请求
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

//加载webView
-(void)initWebView:(NSString *)body
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"web" ofType:@"html"];
    NSString *template = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *html = [NSString stringWithFormat:template,body]; //拼接html模板
    [_webView loadHTMLString:html baseURL:nil];
}
#pragma mark - webView代理方法
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"哎哟,图片有点多";
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *js = [NSString stringWithFormat:@"imgAutoFit(%lf)",kScreenWidth - 16];
    [_webView stringByEvaluatingJavaScriptFromString:js];

    CGFloat webViewHeight= [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"]floatValue];
    CGRect newFrame = webView.frame;
    newFrame.size.height = webViewHeight;
    webView.frame = newFrame; //重新获取webview的尺寸
    
    [_tableView reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if(navigationType==UIWebViewNavigationTypeLinkClicked)//判断是否是点击链接
    {
        NSURL *url = request.URL;
        NSLog(@"url = %@",request.URL);
        if ([url.scheme isEqualToString:@"applewebdata"]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            if (url.query) {
                [[HDNetworking sharedHDNetworking] GET:[NSString stringWithFormat:@"http://m.yidoutang.com//apiv3/sharing/detail?%@",url.query] parameters:nil success:^(id  _Nonnull responseObject) {
                    NSString *url = responseObject[@"data"][@"sharing"][@"extended_url"];
                    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    }
                } failure:^(NSError * _Nonnull error) {
                    
                }];
                
            }else{
                NSString *str = [url absoluteString];
                NSArray *arr = [str componentsSeparatedByString:@"/"];
               NSString *goodsid = arr[arr.count - 2];
                NSLog(@"goodsid = %@",goodsid);
                [[HDNetworking sharedHDNetworking] GET:[NSString stringWithFormat:@"http://m.yidoutang.com//apiv3/sharing/detail?id=%@",goodsid] parameters:nil success:^(id  _Nonnull responseObject) {
                    NSString *url = responseObject[@"data"][@"sharing"][@"extended_url"];
                    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    }
                } failure:^(NSError * _Nonnull error) {
                    
                }];
            }
        }
        return NO;
    }
    return YES;
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
            [cell.contentView addSubview:_webView];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        RelatedCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"RelatedCellID2" forIndexPath:indexPath];
        [cell2 refreshModel:self.dataSource[indexPath.row]];
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return _webView.frame.size.height + 16;
    }
    return 116;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    if (section == 0) {
        label.text = @"好东西,要与大家分享~~😊";
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
        RecDetailViewController *rdv = [[RecDetailViewController alloc] init];
        rdv.tid = [self.dataSource[indexPath.row] relateID];
        [self.navigationController pushViewController:rdv animated:YES];
    }
}

#pragma mark - scrollView代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    if (y < -327) {  //下拉顶部图片放大
        [_hv resetFrame:y];
    }
}

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
        NSURLCache * cache = [NSURLCache sharedURLCache];
        [cache removeAllCachedResponses];
        [cache setDiskCapacity:0];
        [cache setMemoryCapacity:0];
    
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
