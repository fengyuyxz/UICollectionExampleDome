//
//  CycilcStaticLayout.m
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/21.
//

#import "CycilcStaticLayout.h"

@implementation CycilcStaticLayout
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
    attr.size = CGSizeMake(100, 100);
    attr.center = CGPointMake(CGRectGetWidth(self.collectionView.frame)*0.5, CGRectGetHeight(self.collectionView.frame)*0.5);
    if(indexPath.row>=5){
        attr.hidden = YES;
    }else{
        attr.zIndex=_count-indexPath.row;
        CGFloat angel = 2*M_PI/5.0*indexPath.row;
        attr.transform = CGAffineTransformMakeRotation(angel);
    }
    
    return attr;
}
@end
