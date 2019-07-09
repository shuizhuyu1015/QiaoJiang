//
//  FooterView.m
//  QiaoJiang
//
//  Created by mac on 16/3/19.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#import "FooterView.h"
#import "FooterCell.h"
#import "interface.h"
#import "JingXuanModel.h"

@interface FooterView () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation FooterView

-(void)awakeFromNib
{
    [super awakeFromNib];
    _collectionView.backgroundColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:238/255.0 alpha:1.0];
    [_collectionView registerNib:[UINib nibWithNibName:@"FooterCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.scrollEnabled = NO;
    _collectionView.scrollsToTop = NO;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSString *urlStr = [NSString stringWithFormat:kImage,[self.dataSource[indexPath.item] productSpecialCategoryUrl]];
    [cell.footerImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"default_item"]];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = self.bounds.size.width-75;
    CGFloat h = (w/2) / 1.618;
    return CGSizeMake(w/2, h);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FooterModel *fm = self.dataSource[indexPath.item];
    if (self.block) {
        self.block(fm.category2.category1Id,fm.category2.category2Id);
    }
}

-(void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [_collectionView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
