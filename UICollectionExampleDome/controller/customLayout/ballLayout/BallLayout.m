//
//  BallLayout.m
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/20.
//

#import "BallLayout.h"

@implementation BallLayout
-(void)prepareLayout{
    [super prepareLayout];
    self.collectionView.delegate = self;
//
//
//    self.center = CGPointMake(CGRectGetWidth(self.collectionView.frame)*0.5, CGRectGetHeight(self.collectionView.frame)*0.5);
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
    UICollectionViewLayoutAttributes *atti=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    int itemCounts = (int)[self.collectionView numberOfItemsInSection:0];
        atti.center = CGPointMake(self.collectionView.frame.size.width/2+self.collectionView.contentOffset.x, self.collectionView.frame.size.height/2+self.collectionView.contentOffset.y);
        atti.size = CGSizeMake(30, 30);
        
        CATransform3D trans3D = CATransform3DIdentity;
        trans3D.m34 = -1/900.0;
        
    CGFloat radius = CGRectGetWidth(self.collectionView.frame)/2.0f-15;//15/tanf(M_PI*2/itemCounts/2);
        //根据偏移量 改变角度
        //添加了一个x的偏移量
        float offsety = self.collectionView.contentOffset.y;
        float offsetx = self.collectionView.contentOffset.x;
        //分别计算偏移的角度
        float angleOffsety = offsety/self.collectionView.frame.size.height;
        float angleOffsetx = offsetx/self.collectionView.frame.size.width;
        CGFloat angle1 = (float)(indexPath.row+angleOffsety-1)/itemCounts*M_PI*2;
        //x，y的默认方向相反
        CGFloat angle2 = (float)(indexPath.row-angleOffsetx-1)/itemCounts*M_PI*2;
        //这里我们进行四个方向的排列
       if (indexPath.row%4==1) {
            trans3D = CATransform3DRotate(trans3D, angle1, 1.0,0, 0);
           
        }else if(indexPath.row%4==2){
            trans3D = CATransform3DRotate(trans3D, angle2, 0, 1, 0);
            
        }else if(indexPath.row%4==3){
            trans3D = CATransform3DRotate(trans3D, angle1, 0.5,0.5, 0);
            
        }else{
            trans3D = CATransform3DRotate(trans3D, angle1, 0.5,-0.5,0);
            
        }
        
        trans3D = CATransform3DTranslate(trans3D, 0, 0, radius);
        
        atti.transform3D = trans3D;

    return atti;
}

-(CGSize)collectionViewContentSize
{
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame)*(count+2), CGRectGetHeight(self.collectionView.frame)*(count+2));
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    NSLog(@"%f",scrollView.contentOffset.x);
   // 小于半屏 则放到最后一屏多半屏 向上滚，小于200是改在一列数据上半往最后一项方向功能，加个偏移到count*4000是刚好偏移到最后一项
    
    CGFloat Height = CGRectGetHeight(self.collectionView.frame);
        if (scrollView.contentOffset.y<Height*0.5) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y+count*Height);
        //大于最后一屏多一屏 放回第一屏
        }else if(scrollView.contentOffset.y>(count+1)*Height){
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y-count*Height);
        }
    CGFloat Width = CGRectGetWidth(self.collectionView.frame);
    if (scrollView.contentOffset.x<Width*0.5) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x+count*Width,scrollView.contentOffset.y );
    //大于最后一屏多一屏 放回第一屏
    }else if(scrollView.contentOffset.x>(count+1)*Width){
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x-count*Width, scrollView.contentOffset.y);
    }

}
@end
