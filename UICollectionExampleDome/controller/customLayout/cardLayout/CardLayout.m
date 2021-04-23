//
//  CardLayout.m
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/15.
//

#import "CardLayout.h"

@implementation CardLayout
-(void)prepareLayout{
    [super prepareLayout];
}
//
-(NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    // 获取当前显示区域 等于collectionView 的size.with+collectionView的偏移量
    // scrollView 子视图的移动实际就是修改的bound的x，y值，修改一个视图的bound会影响到子视图的位置
    // bounds就是描述可视范围在内容的区域,因此可以通过设置bounds来获取当前显示的cell
    

    NSArray<UICollectionViewLayoutAttributes *> * attList = [super layoutAttributesForElementsInRect:self.collectionView.bounds];
    // 卡片在中间时最大，远离屏幕重新是缩小，因此可以可算cell离屏幕中心的距离来计算缩放比例
    //距离屏幕距离等于cell 中心点的位置-偏移量-屏幕中心
    for (UICollectionViewLayoutAttributes * attr in attList) {
        CGFloat delta =fabs((attr.center.x - self.collectionView.contentOffset.x - CGRectGetWidth(self.collectionView.frame)*0.5));
        CGFloat scale = 1-delta/(CGRectGetWidth(self.collectionView.frame)*0.5)*0.25;
        attr.transform = CGAffineTransformMakeScale(scale, scale);
       
    }
    
    return attList;
}
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
// 确定最终偏移量
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
//    NSLog(@"%@  %@",NSStringFromCGPoint(proposedContentOffset),NSStringFromCGPoint(velocity));
    CGPoint point = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
//    NSLog(@"%@  %@",NSStringFromCGPoint(proposedContentOffset),NSStringFromCGPoint(self.collectionView.contentOffset));
    return point;
}
@end
