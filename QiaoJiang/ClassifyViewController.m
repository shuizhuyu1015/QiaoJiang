//
//  ClassifyViewController.m
//  QiaoJiang
//
//  Created by mac on 16/3/31.
//  Copyright © 2016年 GL. All rights reserved.
//

#import "ClassifyViewController.h"
#import "JSDropDownMenu.h"
#import "CategoryModel.h"
#import "interface.h"
#import "OtherDetailCell.h"
#import "ProRefModel.h"
#import "ProductViewController.h"

@interface ClassifyViewController () <JSDropDownMenuDataSource,JSDropDownMenuDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
}
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *menuData; //菜单数据源
@property (nonatomic,strong) NSMutableArray *dataSource; //主屏数据源
@property (nonatomic,assign) NSInteger offset; //偏移量
@property (nonatomic,assign) NSInteger category1; //保存类别参数1
@property (nonatomic,assign) NSInteger category2; //保存类别参数2
@property (nonatomic,copy) NSString *selectUrl;
@property (nonatomic,copy) NSString *allUrl;

@end

@implementation ClassifyViewController

//设置导航的效果
-(void)resetNavigation
{
    //返回键只保留箭头
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    //item字体颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //title字体属性
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    //状态栏白字
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self resetNavigation];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.offset = 0;
    [self requestMenuData]; //加载菜单
    
    if (self.category1Id && self.category2Id) {
        NSString *url = [kSearch stringByAppendingString:@"&category1Id=%ld&category2Id=%ld"];
        [self loadNetworkData:[NSString stringWithFormat:url,self.offset,self.category1Id,self.category2Id]];
    }else{
        [self loadNetworkData:_allUrl];
    }
}

//请求菜单数据
-(void)requestMenuData
{
    _allUrl = [NSString stringWithFormat:kSearch,self.offset];
    [[NetworkHelper shareInstance] Get:_allUrl parameter:nil success:^(id responseObject) {
        for (NSDictionary *dic in responseObject[@"data"][@"categorys"]) {
            CategoryModel *cm = [[CategoryModel alloc] initWithDictionary:dic error:nil];
            [self.menuData addObject:cm];
        }
        [self createMenu];
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
    }];
}

//创建菜单
-(void)createMenu
{
    JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:30];
    menu.indicatorColor = [UIColor colorWithRed:121/255.0 green:199/255.0 blue:198/255.0 alpha:1];
    menu.separatorColor = [UIColor lightGrayColor];
    menu.textColor = [UIColor blackColor];
    menu.dataSource = self;
    menu.delegate = self;
    
    [self.view addSubview:menu];
}

//加载collectionView数据
-(void)loadNetworkData:(NSString *)url
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"客官稍等...";
    
    [[NetworkHelper shareInstance] Get:url parameter:nil success:^(id responseObject) {
        if ([_collectionView.mj_header isRefreshing]) {
            [self.dataSource removeAllObjects];
        }
        
        for (NSDictionary *dic in responseObject[@"data"][@"items"]) {
            ProRefModel *pm = [[ProRefModel alloc] initWithDictionary:dic error:nil];
            [self.dataSource addObject:pm];
        }
        
        if (!_collectionView) {
            [self createCollectionView];
        }else{
            [_collectionView reloadData];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
    }];
}

//创建collectionView
-(void)createCollectionView
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((screenSize.width-30)/2, 210);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 94, screenSize.width, screenSize.height-94-49) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:_collectionView];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"OtherDetailCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [_collectionView reloadData];
    
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.offset = 0;
        [self reloadUrl];
    }];
    
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.offset += 30;
        [self reloadUrl];
    }];
}

//刷新url
-(void)reloadUrl
{
    if (_selectUrl) {
        _selectUrl = [NSString stringWithFormat:[kSearch stringByAppendingString:@"&category1Id=%ld&category2Id=%ld"],self.offset,_category1,_category2];
        [self loadNetworkData:_selectUrl];
    }else if (self.category1Id && self.category2Id){
        NSString *url = [kSearch stringByAppendingString:@"&category1Id=%ld&category2Id=%ld"];
        [self loadNetworkData:[NSString stringWithFormat:url,self.offset,self.category1Id,self.category2Id]];
    }else{
        _allUrl = [NSString stringWithFormat:kSearch,self.offset];
        [self loadNetworkData:_allUrl];
    }
}

#pragma mark - collectionView代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    OtherDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell refreshUI:self.dataSource[indexPath.item]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    ProductViewController *pvc = [[ProductViewController alloc] init];
    pvc.productId = [self.dataSource[indexPath.item] productId];
    pvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pvc animated:YES];
}

#pragma mark - 菜单代理方法
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 3;
}

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    if (column == 1) {
        return YES;
    }
    return NO;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    if (column == 0) {
        return YES;
    }
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    if (column == 0) {
        return 0.3;
    }
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    if (column==0) {
        return _currentData1Index;
    }
    if (column==1) {
        return _currentData2Index;
    }else{
        return _currentData3Index;
    }
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    if (column == 0) {
        if (leftOrRight==0) {
            return _menuData.count;
        } else{
            CategoryModel *cm = [self.menuData objectAtIndex:leftRow];
            return [cm.category2s count];
        }
    }else if (column == 1){
        return 4;
    }else{
        return 4;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    switch (column) {
        case 0:
            return @"全部";
            break;
        case 1:
            return @"默认排序";
            break;
        case 2:
            return @"价格";
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    if (indexPath.column == 0) {
        if (indexPath.leftOrRight==0) {
            CategoryModel *cm = self.menuData[indexPath.row];
            return cm.category1Name;
        } else{
            NSInteger leftRow = indexPath.leftRow;
            CategoryModel *cm = self.menuData[leftRow];
            return [cm.category2s[indexPath.row] category2Name];
        }
    }else if (indexPath.column == 1){
        switch (indexPath.row) {
            case 0:
                return @"默认排序";
                break;
            case 1:
                return @"销量最高";
                break;
            case 2:
                return @"价格最低";
                break;
            case 3:
                return @"点评最多";
                break;
            default:
                return nil;
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
                return @"不限";
                break;
            case 1:
                return @"￥0-￥400";
                break;
            case 2:
                return @"￥400-￥800";
                break;
            case 3:
                return @"￥800-￥1200";
                break;
            case 4:
                return @"￥1200-￥1600";
                break;
            default:
                return nil;
                break;
        }
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    if (indexPath.column == 0) {
        if(indexPath.leftOrRight==0){
            _currentData1Index = indexPath.row;
            return;
        }
        CategoryModel *cm = self.menuData[indexPath.leftRow];
        Category2sModel *c2 = cm.category2s[indexPath.row];
        
        _category1 = c2.category1Id;
        _category2 = c2.category2Id;
        self.offset = 0;
        _selectUrl = [NSString stringWithFormat:[kSearch stringByAppendingString:@"&category1Id=%ld&category2Id=%ld"],self.offset,_category1,_category2];
        
        [_collectionView.mj_header beginRefreshing];
        
    }else if (indexPath.column == 1){
        _currentData2Index = indexPath.row;
    }else{
        _currentData3Index = indexPath.row;
    }
    
}

-(NSMutableArray *)menuData
{
    if (_menuData == nil) {
        _menuData = [[NSMutableArray alloc] init];
    }
    return _menuData;
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
