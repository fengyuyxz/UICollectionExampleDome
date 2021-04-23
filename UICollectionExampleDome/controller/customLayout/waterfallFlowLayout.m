//
//  waterfallfallLayout.m
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/15.
//

#import "waterfallFlowLayout.h"

@implementation waterfallFlowLayout
{
    NSMutableArray<NSNumber *> * _attributeAttay;
}
-(void)prepareLayout{
    [super prepareLayout];
    _attributeAttay=[[NSMutableArray alloc]init];
//    NSLog(@"%s",__func__);
//    CGFloat width = CGRectGetWidth(self.collectionView.frame);
//    
//    CGFloat itemWith = (width-self.minimumLineSpacing-self.sectionInset.left-self.sectionInset.right)*0.5;
    
    
    /*
    //设置区间距
    layout.sectionInset = UIEdgeInsetsMake(0, lineSpace, 0, lineSpace);
    //设行间距
    layout.minimumLineSpacing = lineSpace;
    //设置列间距
    layout.minimumInteritemSpacing = lineSpace;
    // 设置 cell 大小
    layout.itemSize = CGSizeMake((width-lineSpace-lineSpace-lineSpace)*0.5, width*0.5);
     */
}
-(NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSLog(@"%@",NSStringFromCGRect(rect));
    return [super layoutAttributesForElementsInRect:rect];
}
-(CGSize)collectionViewContentSize{
    return [super collectionViewContentSize];
}
@end
