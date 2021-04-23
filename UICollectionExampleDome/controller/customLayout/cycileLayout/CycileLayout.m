//
//  CycileLayout.m
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/20.
//

#import "CycileLayout.h"
@interface CycileLayout()
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributesCache;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *deleteIndexPaths;
@property (nonatomic, assign) CGPoint center;
@end
@implementation CycileLayout
-(void)prepareLayout{
    [super prepareLayout];
    if (!_attributesCache) {
        _attributesCache = [[NSMutableArray alloc]init];
    }
    [_attributesCache removeAllObjects];
    if (!_deleteIndexPaths) {
        _deleteIndexPaths= [[NSMutableArray alloc]init];
    }
    //获得总数
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    //计算屏幕大圆半径
    CGFloat radius = MIN(CGRectGetWidth(self.collectionView.frame), CGRectGetHeight(self.collectionView.frame))/2.0f;
    //获得collectionview中心点
    CGPoint center = self.collectionView.center;
    self.center=center;
    // 计算平均一份的角度
    CGFloat angle = 2 * M_PI / itemCount;
    //计算布局属性
    for (NSInteger i=0; i<itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *attribut = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attribut.size = CGSizeMake(50, 50);
        CGFloat itemX = center.x - cos(angle*i)*(radius-25);
        CGFloat itemY = center.y - sin(angle*i)*(radius-25);
        attribut.center = CGPointMake(itemX, itemY);
        [_attributesCache addObject:attribut];
    }
}


-(NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return _attributesCache;
}
-(CGSize)collectionViewContentSize
{
    return self.collectionView.frame.size;
}
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    // So far, calling super hasn't been strictly necessary here, but leaving it in
    // for good measure
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    
    if ([self.deleteIndexPaths containsObject:itemIndexPath])
    {
        // only change attributes on deleted cells
       if (!attributes)
            attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        
        // Configure attributes ...
        attributes.alpha = 0.0;
        attributes.center = CGPointMake(_center.x, _center.y);
        attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
    }
    
    return attributes;
}

// 新增删除时调用弄
- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems{
 //一定要调用super 的prepareForCollectionViewUpdates否则没有动画效果
//    [super prepareForCollectionViewUpdates:updateItems];
//    [self.removeCache removeAllObjects];
//    [self.addCache removeAllObjects];
    [self.deleteIndexPaths removeAllObjects];
    for (UICollectionViewUpdateItem *item in updateItems) {
        switch (item.updateAction) {
            case UICollectionUpdateActionInsert:
            {
                if (item.indexPathAfterUpdate) {
//                    [self.addCache addObject:item.indexPathAfterUpdate];
                }
            }
                break;
            case UICollectionUpdateActionDelete:
            {
                if (item.indexPathBeforeUpdate) {
                    [self.deleteIndexPaths addObject:item.indexPathBeforeUpdate];
                }
            }
                break;
            default:
                break;
        }
        
    }
    
}
@end
