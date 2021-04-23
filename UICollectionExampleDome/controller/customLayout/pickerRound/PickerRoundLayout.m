//
//  PickerRoundLayout.m
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/20.
//

#import "PickerRoundLayout.h"
@interface PickerRoundLayout()<UIScrollViewDelegate>
@property (nonatomic, assign) CGPoint center;
@end
@implementation PickerRoundLayout
-(void)prepareLayout{
    [super prepareLayout];
    self.collectionView.delegate = self;
    
    
    self.center = CGPointMake(CGRectGetWidth(self.collectionView.frame)*0.5, CGRectGetHeight(self.collectionView.frame)*0.5);
}
-(NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray<UICollectionViewLayoutAttributes *> *cache=[[NSMutableArray alloc]init];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int row=0; row<count; row++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        UICollectionViewLayoutAttributes *attr=[self layoutAttributesForItemAtIndexPath:indexPath];
        [cache addObject:attr];
    }
    return cache;
}
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attr=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attr.size = CGSizeMake(300, 100);
//    attr.center = CGPointMake(self.collectionView.frame.size.width/2, self.collectionView.frame.size.height/2+self.collectionView.contentOffset.y);;
    attr.center = CGPointMake(self.collectionView.frame.size.width/2, self.collectionView.frame.size.height/2+self.collectionView.contentOffset.y);
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    CGFloat radius2 = 50/(sin(2*M_PI/count/2.0f));
    CGFloat radius = 50/tanf(M_PI*2/count/2);

    
    
    //获取当前的偏移量
        float offset = self.collectionView.contentOffset.y;
        //在角度设置上，添加一个偏移角度
        float angleOffset = offset/self.collectionView.frame.size.height;
    CGFloat angle = 2*M_PI/count*(indexPath.row+angleOffset-1);
    CATransform3D trans3D = CATransform3DIdentity;
    trans3D.m34 =-1/900.0;
    //
    trans3D =CATransform3DRotate(trans3D, angle, 1, 0, 0);
    
    //这个方法也返回一个transform3D对象，追加平移效果，后面三个参数，对应平移的x，y，z轴，我们沿z轴平移
    trans3D= CATransform3DTranslate(trans3D, 0, 0, radius2);
//    transform=CATransform3DTranslate(transform, 0, 0, radius2);
    attr.transform3D = trans3D;
    
    return attr;
}
-(CGSize)collectionViewContentSize
{
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), CGRectGetHeight(self.collectionView.frame)*(count+2));
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    NSLog(@"%f",scrollView.contentOffset.y);
   // 小于半屏 则放到最后一屏多半屏 向上滚，小于200是改在一列数据上半往最后一项方向功能，加个偏移到count*4000是刚好偏移到最后一项
        if (scrollView.contentOffset.y<200) {
            scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y+count*400);
        //大于最后一屏多一屏 放回第一屏
        }else if(scrollView.contentOffset.y>(count+1)*400){
            scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y-count*400);
        }

}
@end
