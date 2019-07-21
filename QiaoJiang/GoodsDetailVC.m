//
//  GoodsDetailVC.m
//  QiaoJiang
//
//  Created by GL on 2019/7/19.
//  Copyright © 2019年 GL. All rights reserved.
//

#import "GoodsDetailVC.h"
#import "ProductDetailCell.h"
#import "TextContentCell.h"
#import "GLScrollView.h"
#import "JJPhotoManeger.h"

static NSString *ProductDetailCellID = @"ProductDetailCellID";
static NSString *TextContentCellID = @"TextContentCellID";

@interface GoodsDetailVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GLScrollView *headerScrollView;
@property (nonatomic, strong) ProductDetailModel *productModel;
@property (nonatomic, strong) NSMutableArray *contentArr;

@end

@implementation GoodsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"商品详情";
    
    [self setupBBI];
    
    [self.view addSubview:self.tableView];
    
    [self getGoodsDetail];
    
    [self getRecommendDetails];
}

-(void)setupBBI {
    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
    NSArray *collectedArr = [userDefault objectForKey:COLLECTED_PRODUCTS];
    
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(0, 0, 40, 40);
    [collectBtn setImage:[UIImage imageNamed:@"collection_sel"] forState:UIControlStateSelected];
    [collectBtn setImage:[UIImage imageNamed:@"collection_nor"] forState:UIControlStateNormal];
    [collectBtn addTarget:self action:@selector(collectProduct:) forControlEvents:UIControlEventTouchUpInside];
    collectBtn.selected = [collectedArr containsObject:self.productId];
    
    UIBarButtonItem *collectionBBI = [[UIBarButtonItem alloc] initWithCustomView:collectBtn];
    self.navigationItem.rightBarButtonItem = collectionBBI;
}

/*!
 @brief 收藏商品
 */
-(void)collectProduct:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
    NSArray *collectedArr = [userDefault objectForKey:COLLECTED_PRODUCTS];
    NSMutableArray *arrM = nil;
    if(collectedArr == nil) {
        arrM = [[NSMutableArray alloc] init];
    }else{
        arrM = [NSMutableArray arrayWithArray:collectedArr];
    }

    if(sender.isSelected){
        [arrM addObject:self.productId];
        [self showHint:@"收藏成功"];
    }else{
        [arrM removeObject:self.productId];
        [self showHint:@"取消收藏"];
    }
    [userDefault setObject:arrM forKey:COLLECTED_PRODUCTS];
    [userDefault synchronize];
}

#pragma mark - 通过商品id获取详情
-(void)getGoodsDetail {
    NSString *url = [NSString stringWithFormat:GET_PRODUCT_BY_ID, self.productId];
    [[HDNetworking sharedHDNetworking] GET:url parameters:nil success:^(id  _Nonnull responseObject) {
        if([responseObject[@"code"] intValue] == 200) {
            NSDictionary *dataDic = responseObject[@"data"];
            _productModel = [[ProductDetailModel alloc] initWithDictionary:dataDic error:nil];
            [self.tableView reloadData];
            self.headerScrollView.imageArr = self.productModel.images;
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 获取产品推荐理由等
-(void)getRecommendDetails {
    NSString *url = [NSString stringWithFormat:GET_PRODUCT_DETAILS_BY_ID, self.productId];
    [[HDNetworking sharedHDNetworking] GET:url parameters:nil success:^(id  _Nonnull responseObject) {
        if([responseObject[@"code"] intValue] == 200) {
            NSArray *detailsArr = responseObject[@"data"][@"details"];
            for (NSDictionary *dic in detailsArr) {
                ProductRecommentModel *model = [[ProductRecommentModel alloc] initWithDictionary:dic error:nil];
                if(![model.title isEqualToString:@"运输说明"] && ![model.title isEqualToString:@"退换货说明"]){
                    [self.contentArr addObject:model];
                }
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - tableview代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 + self.contentArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        ProductDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ProductDetailCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshCellUI:self.productModel];
        return cell;
    }else{
        TextContentCell *cell = [tableView dequeueReusableCellWithIdentifier:TextContentCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(self.contentArr.count){
            ProductRecommentModel *model = self.contentArr[indexPath.section-1];
            [cell refreshCellUI:model.modules];
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return 105;
    }else{
        return UITableViewAutomaticDimension;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return nil;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WID, 44)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, WID-30, 44)];
    if(self.contentArr.count){
        ProductRecommentModel *model = self.contentArr[section-1];
        titleLabel.text = model.title;
    }
    [headerView addSubview:titleLabel];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return 0.01;
    }else{
        return 44;
    }
}

/*!
 @brief 查看轮播大图
 */
-(void)showBigImageAtIndex:(NSInteger)index {
    NSMutableArray *imageViewsArr = [[NSMutableArray alloc] init];
    for (NSString *imgUrl in self.productModel.images) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[imgUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
        [imageViewsArr addObject:imageView];
    }
    [[JJPhotoManeger maneger] showNetworkPhotoViewer:imageViewsArr urlStrArr:self.productModel.images selecView:imageViewsArr[index-1]];
}

#pragma mark - 懒加载
-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WID, HEI-kTopHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 100;
        [_tableView registerNib:[UINib nibWithNibName:@"ProductDetailCell" bundle:nil] forCellReuseIdentifier:ProductDetailCellID];
        [_tableView registerClass:[TextContentCell class] forCellReuseIdentifier:TextContentCellID];
        _tableView.tableHeaderView = self.headerScrollView;
    }
    return _tableView;
}

-(GLScrollView *)headerScrollView {
    if(_headerScrollView == nil){
        _headerScrollView = [[GLScrollView alloc] initWithFrame:CGRectMake(0, 0, WID, 300)];
        @WeakObj(self)
        _headerScrollView.block = ^(NSInteger index) {
            [selfWeak showBigImageAtIndex:index];
        };
    }
    return _headerScrollView;
}

-(NSMutableArray *)contentArr {
    if(_contentArr == nil){
        _contentArr = [[NSMutableArray alloc] init];
    }
    return _contentArr;
}


@end
