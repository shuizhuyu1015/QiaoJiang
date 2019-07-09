//
//  JingXuanCell.m
//  QiaoJiang
//
//  Created by mac on 16/3/17.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import "JingXuanCell.h"
#import "DetailItemCell.h"

@interface JingXuanCell () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation JingXuanCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:238/255.0 alpha:1.0];
    _collectionView.backgroundColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:238/255.0 alpha:1.0];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"DetailItemCell" bundle:nil] forCellWithReuseIdentifier:@"decell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _collectionView.scrollsToTop = NO;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"decell" forIndexPath:indexPath];
    [cell refreshUI:self.dataSource[indexPath.item]];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = self.bounds.size.width-32;
    return CGSizeMake(w/3, 155);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.block) {
        self.block([self.dataSource[indexPath.item] productId]);
    }
}

-(void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [_collectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
