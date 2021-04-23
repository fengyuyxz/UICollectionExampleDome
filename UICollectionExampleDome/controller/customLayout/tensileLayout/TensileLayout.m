//
//  TensileLayout.m
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/16.
//

#import "TensileLayout.h"

@implementation TensileLayout
-(void)prepareLayout{
    [super prepareLayout];
//    CGFloat cWidth  = CGRectGetWidth(self.collectionView.frame);
    
//    self.minimumLineSpacing = 1;
//    CGFloat itemWidth = cWidth - self.sectionInset.left -  self.sectionInset.left;
//    self.itemSize = CGSizeMake(itemWidth, 120);
//    self.headerReferenceSize =CGSizeMake(itemWidth, 220);
    
}
-(NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    if (!self.collectionView) {
        return nil;
    }
    NSArray<__kindof UICollectionViewLayoutAttributes *> * attributeList = [super layoutAttributesForElementsInRect:rect];
    CGPoint contetOffset = self.collectionView.contentOffset;
    UIEdgeInsets inset = self.collectionView.contentInset;
    CGFloat minY = -inset.top;
    NSLog(@"%f",contetOffset.y);
    if (contetOffset.y<minY) {
        CGFloat detal = fabs(contetOffset.y - minY);
        
        for (UICollectionViewLayoutAttributes *attr in attributeList) {
            if ([attr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
                CGRect headRect = attr.frame;
                headRect.size.height += detal;
                headRect.origin.y-=detal;
                attr.frame = headRect;
                
                
            }
        }
    }
    
//    NSLog(@"%@ /n %f",NSStringFromCGPoint(contetOffset),-inset.top);
    return attributeList;
}
//-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
//    
//    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
//        UICollectionViewLayoutAttributes *atr = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
//    }
//    return nil;
//}
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
@end
