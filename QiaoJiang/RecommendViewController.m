//
//  RecommendViewController.m
//  QiaoJiang
//
//  Created by mac on 16/3/30.
//  Copyright © 2016年 GL. All rights reserved.
//

#import "RecommendViewController.h"
#import "interface.h"
#import "RecommendModel.h"
#import "CreativeCell.h"
#import "RecDetailViewController.h"
#import "UserViewController.h"

@interface RecommendViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger page; //请求第几页
@end

@implementation RecommendViewController
-(instancetype)init
{
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor whiteColor];
        //接收bool值改变通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNoti:) name:@"滚动" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNoti:) name:@"点标题" object:nil];
    }
    return self;
}

-(void)getNoti:(NSNotification *)noti
{
    _collectionView.scrollsToTop = [noti.object[1] boolValue];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//创建collectionView
-(void)initCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.view.bounds) - 20, 266);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds),CGRectGetHeight(self.view.bounds)-104-49) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:238/255.0 alpha:1.0];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollsToTop = NO;

    [_collectionView registerNib:[UINib nibWithNibName:@"CreativeCell" bundle:nil] forCellWithReuseIdentifier:@"CreativeCellID"];
    
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self loadNetworkData];
    }];
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [self loadNetworkData];
    }];
    
    [self.view addSubview:_collectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initCollectionView];
    
    self.page = 1;
    [self loadNetworkData];

}

//加载网络数据
-(void)loadNetworkData
{
    NSString *urlStr = [NSString stringWithFormat:kRecommend,self.page];
    [[NetworkHelper shareInstance] Get:urlStr parameter:nil success:^(id responseObject) {
        
        if ([_collectionView.mj_header isRefreshing]) {
            [self.dataSource removeAllObjects];
        }
        
        NSError *error;
        for (NSDictionary *dic in responseObject[@"data"][@"guides"]) {
            RecommendModel *rm = [[RecommendModel alloc] initWithDictionary:dic error:&error];
            if (error) {
                NSLog(@"%@",error);
            }
            [self.dataSource addObject:rm];
        }
        //        NSLog(@"%@",self.dataSource);
        [_collectionView reloadData];
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
    }];
}

#pragma mark - collectionView代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CreativeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CreativeCellID" forIndexPath:indexPath];
    [cell refreshModel:self.dataSource[indexPath.item]];
    @WeakObj(self)
    cell.block = ^void(NSString *user_id){
        UserViewController *uvc = [[UserViewController alloc] init];
        uvc.user_id = user_id;
        uvc.url = kRecomUser;
        uvc.hidesBottomBarWhenPushed = YES;
        [selfWeak.navigationController pushViewController:uvc animated:YES];
    };
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecDetailViewController *rdv = [[RecDetailViewController alloc] init];
    rdv.tid = [self.dataSource[indexPath.item] tid];
    rdv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rdv animated:YES];
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
