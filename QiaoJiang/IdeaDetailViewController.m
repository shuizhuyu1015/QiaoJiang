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

#define kScreenSize [UIScreen mainScreen].bounds.size

@interface IdeaDetailViewController () <UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) DetailHeaderView *hv;
@property (nonatomic,strong) UIWebView *webView;

@end

@implementation IdeaDetailViewController
{
    IdeaDetailModel *dm;
}

-(void)resetNavigation
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"家装创意";
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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64) style:UITableViewStyleGrouped];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self resetNavigation];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    label.center = self.view.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"正在加载,请骚等...";
    label.textColor = [UIColor grayColor];
    [self.view addSubview:label];
    
    //创建webView
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 1)];
    _webView.delegate = self;
    _webView.scrollView.scrollEnabled = NO;
    _webView.scalesPageToFit = YES;
    _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadNetworkData];
    });
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
    NSString *url = [NSString stringWithFormat:kDetail,self.group_id];
    [[NetworkHelper shareInstance] Get:url parameter:nil success:^(id responseObject) {
        
        dm = [[IdeaDetailModel alloc] initWithDictionary:responseObject[@"data"] error:nil];
        [self.dataSource addObjectsFromArray:dm.relatedIdea];
        
        [self initTableView]; //请求成功,加载tableView
        
        [_hv refreshUI:dm];
        [self initWebView:dm.userCase.content]; //webView加载html请求
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(NSError *error) {
        
    }];
}

//加载webView
-(void)initWebView:(NSString *)content
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"web" ofType:@"html"];
    NSString *template = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *html = [NSString stringWithFormat:template,content]; //拼接html模板
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
    NSString *js = [NSString stringWithFormat:@"imgAutoFit(%lf)",kScreenSize.width - 16];
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
        return NO;
    }else{
        return YES;
    }
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
        RelatedCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"RelatedCellID" forIndexPath:indexPath];
        [cell2 refreshUI:self.dataSource[indexPath.row]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
