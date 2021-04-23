//
//  CycileRoundLayout.m
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/21.
//

#import "CycileRoundLayout.h"

@implementation CycileRoundLayout
{
    NSInteger _count;
}
-(void)prepareLayout{
    [super prepareLayout];
    _count =  [self.collectionView numberOfItemsInSection:0];
}
-(NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *attrList = [[NSMutableArray alloc]init];
    
    for (int row=0;row<_count; row++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:0];
        UICollectionViewLayoutAttributes *att=[self layoutAttributesForItemAtIndexPath:path];
        [attrList addObject:att];
    }
    return attrList;
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.size = CGSizeMake(60, 60);
    CGPoint center =CGPointMake(CGRectGetWidth(self.collectionView.frame)*0.5, CGRectGetHeight(self.collectionView.frame)*0.5);
    CGFloat radius = MIN(CGRectGetWidth(self.collectionView.frame), CGRectGetHeight(self.collectionView.frame))/2.0f -50;
    CGFloat progress = self.collectionView.contentOffset.y/CGRectGetHeight(self.collectionView.frame);
    CGFloat angle = 2*M_PI/_count*(indexPath.row+progress);
    CGFloat x = radius * cos(angle);
    CGFloat y = radius * sin(angle);
    attr.center = CGPointMake(center.x+x+self.collectionView.contentOffset.x, center.y+y+self.collectionView.contentOffset.y);
    
    return attr;
}
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

-(CGSize)collectionViewContentSize{
    return CGSizeMake(self.collectionView.frame.size.width, CGRectGetHeight(self.collectionView.frame)*_count);
}

@end
