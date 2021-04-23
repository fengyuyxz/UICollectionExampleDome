//
//  WaterfallLayout.m
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/16.
//

#import "WaterfallLayout.h"
@interface WaterfallLayout()

/// 用来缓存item的cell，避免重复计算
@property (nonatomic, strong) NSMutableArray<__kindof UICollectionViewLayoutAttributes *> *cacheItemAtributes;

@property (nonatomic, assign) CGFloat contentHight;
@end
@implementation WaterfallLayout
- (instancetype)init
{
    self = [super init];
    if (self) {
        _columns = 2;
        _contentHight=0;
    }
    return self;
}
-(void)prepareLayout{
    [super prepareLayout];
    _cacheItemAtributes = [[NSMutableArray alloc]init];
    //1. 获取collectionview的width
    CGFloat width = CGRectGetWidth(self.collectionView.frame);
    //2. 获得总共有多少个item
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    //3. 计算每个item的宽度
    
    CGFloat itemWidth = (width - self.minimumLineSpacing * (self.columns+1))/self.columns;
    
    //4. 获取item的高度。
    CGFloat heights[]={0,0};
    for (int index=0; index<itemCount; index++) {
        CGFloat itemHight = 0;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        if ([self.delegate respondsToSelector:@selector(itemHight:indexPath:)]) {
            itemHight = [self.delegate itemHight:self.collectionView indexPath:indexPath];
        }
        // 计算x偏移量
        // 这个item 是第几个
        int column = index%self.columns;
        CGFloat offsetX = column*itemWidth + (column+1)*self.minimumLineSpacing;
        //计算y的偏移量
        // 第几行
        int row = index/self.columns;
        CGFloat offsetY = heights[column]+self.minimumInteritemSpacing;
        
        UICollectionViewLayoutAttributes *attributes =[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        CGRect frame = CGRectMake(offsetX, offsetY, itemWidth, itemHight);
        attributes.frame = frame;
        self.contentHight = MAX(self.contentHight, CGRectGetMaxY(frame));
        [self.cacheItemAtributes addObject:attributes];
        heights[column]=offsetY+itemHight;
    }
    
}
-(CGSize)collectionViewContentSize{
    return CGSizeMake(self.collectionView.bounds.size.width, self.contentHight);
}
-(NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.cacheItemAtributes;
}

@end
