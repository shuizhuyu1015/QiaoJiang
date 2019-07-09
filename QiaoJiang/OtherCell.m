//
//  OtherCell.m
//  QiaoJiang
//
//  Created by mac on 16/3/21.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import "OtherCell.h"
#import "OtherDetailCell.h"
#import "OtherHeadView.h"

@interface OtherCell () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation OtherCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"OtherDetailCell" bundle:nil] forCellWithReuseIdentifier:@"OtherDetailCellID"];
    [_collectionView registerNib:[UINib nibWithNibName:@"OtherHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"OtherHeadViewID"];
    _collectionView.backgroundColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:238/255.0 alpha:1.0];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    OtherDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OtherDetailCellID" forIndexPath:indexPath];
    [cell refreshUI:self.dataSource[indexPath.item]];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        OtherHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"OtherHeadViewID" forIndexPath:indexPath];
        return headerView;
    }else{
        return nil;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = self.bounds.size.width-30;
    return CGSizeMake(w/2, 210);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.block) {
        self.block([self.dataSource[indexPath.item] productId]);
    }
}

-(void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    [_collectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
