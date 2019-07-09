//
//  ProductViewController.m
//  QiaoJiang
//
//  Created by mac on 16/3/21.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import "ProductViewController.h"
#import "interface.h"
#import "ProHeadView.h"
#import "ProductModel.h"
#import "InfoCell.h"
#import "OtherCell.h"
#import "ProRefModel.h"

#define kScreenSize [UIScreen mainScreen].bounds.size

@interface ProductViewController () <UITableViewDataSource,UITableViewDelegate>
{
    ProHeadView *_pv;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation ProductViewController

-(void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _pv = [[NSBundle mainBundle] loadNibNamed:@"ProHeadView" owner:nil options:nil][0];
    _tableView.tableHeaderView = _pv;
    
    [_tableView registerNib:[UINib nibWithNibName:@"InfoCell" bundle:nil] forCellReuseIdentifier:@"InfoCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"OtherCell" bundle:nil] forCellReuseIdentifier:@"OtherCellID"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"商品详情";
    
    //设置返回item
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    //设置导航右item
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 80, 50);
    [button setImage:[UIImage imageNamed:@"tab_shang_sel@2x"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(7, 35, -7, -35)];
    [button addTarget:self action:@selector(clickBBI:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];;
    
    [self initTableView];
    [self loadNetworkData];
    
}

-(void)clickBBI:(UIBarButtonItem *)bbi
{
        //在任一产品页,点击返回首页
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//加载规格参数数据
-(void)loadNetworkData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载...";
    
    NSString *url = [NSString stringWithFormat:kProduct,self.productId];
    [[NetworkHelper shareInstance] Get:url parameter:nil success:^(id responseObject) {
        
        if ([_tableView.mj_header isRefreshing]) {
            [self.dataSource removeAllObjects];
        }
        
        NSDictionary *dic = responseObject[@"data"];
        NSMutableArray *arrM = [[NSMutableArray alloc] init];
        ProductModel *proM = [[ProductModel alloc] initWithDictionary:dic error:nil];
        [arrM addObject:proM];
        
        [self.dataSource addObject:arrM];
        
        _pv.images = proM.pictures; //传送滚屏图片
        _pv.nameLabel.text = proM.productName;
        _pv.nameLabel.adjustsFontSizeToFitWidth = YES;
        _pv.priceLabel.text = [NSString stringWithFormat:@"￥%ld.%ld",proM.finalPrice/10000,proM.finalPrice%10000/1000];
        
        [self loadOtherData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
    }];
}
//加载底部collectionView数据
-(void)loadOtherData
{
    NSString *url = [NSString stringWithFormat:kProductRef,self.productId];
    [[NetworkHelper shareInstance] Get:url parameter:nil success:^(id responseObject) {
        
        NSMutableArray *arrM = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in responseObject[@"data"][@"items"]) {
            ProRefModel *rm = [[ProRefModel alloc] initWithDictionary:dic error:nil];
            [arrM addObject:rm];
        }
        
        [self.dataSource addObject:arrM];
        
        [_tableView reloadData];

    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        InfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"InfoCellID" forIndexPath:indexPath];
        [infoCell refreshInfo:self.dataSource[indexPath.row][0]];
        infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return infoCell;
        
    }else{
        OtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherCellID" forIndexPath:indexPath];
        cell.dataSource = self.dataSource[indexPath.row];
        cell.block = ^void(NSInteger productId){
            ProductViewController *pvc = [[ProductViewController alloc] init];
            pvc.productId = productId;
            [self.navigationController pushViewController:pvc animated:YES];
        };
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    label.text = @"商品信息";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor colorWithRed:121/255.0 green:199/255.0 blue:198/255.0 alpha:1.0];
    return label;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    label.text = @"没有更多内容啦~";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor lightGrayColor];
    return label;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 485;
    }else{
        return 700;
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
