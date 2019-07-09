//
//  SpecialViewController.m
//  QiaoJiang
//
//  Created by mac on 16/3/22.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import "SpecialViewController.h"
#import "interface.h"
#import "OtherDetailCell.h"
#import "ProRefModel.h"
#import "SpecialHeaderView.h"
#import "ProductViewController.h"

@interface SpecialViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout *layout;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) SpecialHeaderView *header; //段头
@end

@implementation SpecialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.title = self.productSpecialName;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.itemSize = CGSizeMake((screenSize.width-35)/2, 210);
    _layout.sectionInset = UIEdgeInsetsMake(10, 11, 10, 11);
    _layout.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 150);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor colorWithRed:237/255.0 green:241/255.0 blue:240/255.0 alpha:1.0];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"OtherDetailCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"SpecialHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerID"];
    
    [self.view addSubview:_collectionView];
    
    [self loadNetworkData];
    
}

-(void)loadNetworkData
{
    NSString *urlStr = [NSString stringWithFormat:kHeader,self.productSpecialId];
    [[NetworkHelper shareInstance] Get:urlStr parameter:nil success:^(id responseObject) {
        for (NSDictionary *dic in responseObject[@"data"][@"items"]) {
            ProRefModel *pf = [[ProRefModel alloc] initWithDictionary:dic error:nil];
            [self.dataSource addObject:pf];
        }
        
        [_collectionView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
    }];
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

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        _header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerID" forIndexPath:indexPath];
        NSString *urlStr = [NSString stringWithFormat:kImage,self.naviAppImg];
        [_header.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"default_item"]];
        return _header;
    }else{
        return nil;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductViewController *pvc = [[ProductViewController alloc] init];
    pvc.productId = [self.dataSource[indexPath.item] productId];
    [self.navigationController pushViewController:pvc animated:YES];
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
