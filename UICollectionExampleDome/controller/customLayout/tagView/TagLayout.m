//
//  TagLayout.m
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/19.
//

#import "TagLayout.h"
@interface TagLayout()
typedef NS_ENUM(NSUInteger, TagLayoutElement) {
    TagLayoutElementCell,
    TagLayoutElementHeadr,
    TagLayoutElementSectionHeader,
};
//总高度
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *,NSMutableDictionary<NSIndexPath *,UICollectionViewLayoutAttributes*> *> *cache;
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *visibleAttributeList;

@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *removeCache;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *addCache;
@end

@implementation TagLayout
- (instancetype)init
{
    self = [super init];
    if (self) {
        _contentHeight = 0;
        _tagInnerMargin = 10;
        _lineSpacing = 10;
        _itemSpacing=10;
        _headerHeight = 150;
        _secionHeaderHeight = 60;
        _headerKind=@"ElementTagHeader";
        _visibleAttributeList=[[NSMutableArray alloc]init];
        _cache = [[NSMutableDictionary alloc]init];
        _removeCache=[[NSMutableArray alloc]init];
        _addCache=[[NSMutableArray alloc]init];
    }
    return self;
}
-(void)prepareLayout{
    [super prepareLayout];
    [_cache removeAllObjects];
    CGFloat width = self.collectionView.bounds.size.width;
    
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *headerIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UICollectionViewLayoutAttributes *headerAttr=[UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:_headerKind withIndexPath:headerIndexPath];
    CGRect headerFrame = CGRectMake(0, 0, width, self.headerHeight);
    headerAttr.frame = headerFrame;
    _contentHeight=CGRectGetMaxY(headerFrame);
    _cache[@(TagLayoutElementHeadr)]=[@{headerIndexPath:headerAttr} mutableCopy];
    
    for (NSInteger section=0; section<sectionCount; section++) {
        NSIndexPath *sectionHeardIndex = [NSIndexPath indexPathForRow:0 inSection:section];
        
        UICollectionViewLayoutAttributes *sectionheaderAttr=[UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:sectionHeardIndex];
        CGFloat sectionOriginY = _contentHeight;
        if (section!=0) {
            sectionOriginY+=self.lineSpacing;
        }
        CGRect sectionHeaderFrame = CGRectMake(0, sectionOriginY, width, self.secionHeaderHeight);
        sectionheaderAttr.frame = sectionHeaderFrame;
        _contentHeight=CGRectGetMaxY(sectionHeaderFrame);
        NSInteger numberOfSection = [self.collectionView numberOfItemsInSection:section];
        if (_cache[@(TagLayoutElementSectionHeader)]) {
            NSMutableDictionary *sectionHeaderIndex=_cache[@(TagLayoutElementSectionHeader)];
            sectionHeaderIndex[sectionHeardIndex]=sectionheaderAttr;
        }else{
            _cache[@(TagLayoutElementSectionHeader)]=[@{sectionHeardIndex:sectionheaderAttr} mutableCopy];
        }
        
        
        NSMutableDictionary<NSIndexPath *,UICollectionViewLayoutAttributes *> *cellCaceh;
        if (_cache[@(TagLayoutElementCell)]) {
            cellCaceh=_cache[@(TagLayoutElementCell)];
        }else{
            cellCaceh=[[NSMutableDictionary alloc]init];
            _cache[@(TagLayoutElementCell)]=cellCaceh;
        }
       
        CGRect itemRect = CGRectMake(0, self.contentHeight+self.lineSpacing, 0, 0);
        for (NSInteger row=0;row<numberOfSection;row++) {
            NSIndexPath *rowIndex = [NSIndexPath indexPathForRow:row inSection:section];
            NSString *text=@"";
            if ([self.delegate respondsToSelector:@selector(tagText:indexPath:)]) {
//                __weak typeof(UICollectionView) *cv = self.collectionView;
                text = [self.delegate tagText:self.collectionView indexPath:rowIndex];
            }
            CGSize textSize = [self getSizeWitText:text];
            CGFloat tagWidth = textSize.width+self.itemSpacing*2;
            CGFloat itemMaxX = CGRectGetMaxX(itemRect) + tagWidth;
            
            if (itemMaxX > width-self.itemSpacing) {
                itemRect = CGRectMake(self.itemSpacing, CGRectGetMaxY(itemRect)+self.lineSpacing, tagWidth, self.tagInnerMargin*2+textSize.height);
                
                
            }else{
                itemRect = CGRectMake(CGRectGetMaxX(itemRect)+self.itemSpacing, itemRect.origin.y, tagWidth, self.tagInnerMargin*2+textSize.height);
                
//                frame = CGRect(x: frame.maxX + itemSpacing, y: frame.origin.y , width: tagWidth , height: itemHeight)
            }
            
            
            UICollectionViewLayoutAttributes *cellAttr=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:rowIndex];
            cellAttr.transform=CGAffineTransformIdentity;
            cellAttr.frame=itemRect;
            cellCaceh[rowIndex]=cellAttr;
        }
        
        self.contentHeight=CGRectGetMaxY(itemRect);
    }
    
}
-(NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    [_visibleAttributeList removeAllObjects];
    
    CGFloat offsetY = self.collectionView.contentOffset.y;
    CGFloat minY = - self.collectionView.contentInset.top;
    for (NSNumber *key in self.cache.allKeys) {
        NSDictionary *dic = self.cache[key];
        
        for (NSIndexPath *indexPathKey in dic.allKeys) {
            UICollectionViewLayoutAttributes *attry = dic[indexPathKey];
            if (offsetY<minY) {
                CGFloat detal = fabs(offsetY - minY);
                if ([attry.representedElementKind isEqualToString:self.headerKind]) {
                    CGRect frame = attry.frame;
                frame.origin.y-=detal;
                frame.size.height+=detal;
                    attry.frame=frame;
                }
            }
            [_visibleAttributeList addObject:attry];
        }
    }
    return _visibleAttributeList;
    /*
    NSArray<__kindof UICollectionViewLayoutAttributes *> * list=[super layoutAttributesForElementsInRect:rect];
    
    
    if (offsetY<minY) {
        CGFloat detal = fabs(offsetY - minY);
        for (UICollectionViewLayoutAttributes *attr in list) {
            
                
            if ([attr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
                
                    CGRect frame = attr.frame;
                frame.origin.y-=detal;
                frame.size.height+=detal;
                attr.frame=frame;
                
            }
        }
    }
    
    return list;
     */
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.cache[@(TagLayoutElementCell)];
    UICollectionViewLayoutAttributes *attr=dic[indexPath];
    return attr;
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    if ([elementKind isEqualToString:self.headerKind]) {
        NSDictionary *dic = self.cache[@(TagLayoutElementHeadr)];
        UICollectionViewLayoutAttributes *attr=dic[indexPath];
        return attr;
    }else if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        NSDictionary *dic = self.cache[@(TagLayoutElementSectionHeader)];
        UICollectionViewLayoutAttributes *attr=dic[indexPath];
        return attr;
    }else{
        return nil;
    }
}
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
-(CGSize)collectionViewContentSize{
    return CGSizeMake(self.collectionView.bounds.size.width, self.contentHeight);
}
// 新增删除时调用弄
- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems{
 //一定要调用super 的prepareForCollectionViewUpdates否则没有动画效果
    [super prepareForCollectionViewUpdates:updateItems];
    [self.removeCache removeAllObjects];
    [self.addCache removeAllObjects];

    for (UICollectionViewUpdateItem *item in updateItems) {
        switch (item.updateAction) {
            case UICollectionUpdateActionInsert:
            {
                if (item.indexPathAfterUpdate) {
                    [self.addCache addObject:item.indexPathAfterUpdate];
                }
            }
                break;
            case UICollectionUpdateActionDelete:
            {
                if (item.indexPathBeforeUpdate) {
                    [self.removeCache addObject:item.indexPathBeforeUpdate];
                }
            }
                break;
            default:
                break;
        }
        
    }
    
}
- (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
    UICollectionViewLayoutAttributes *attr=[super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    if (!attr) {
        return nil;
    }
    if ([self.addCache containsObject:itemIndexPath]) {
        
        
            attr.transform=CGAffineTransformRotate(CGAffineTransformScale(attr.transform, 4, 4), M_PI/2.0f);
    }
   
    return attr;
}

- (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
    UICollectionViewLayoutAttributes *attr=[super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    if (!attr) {
        return nil;
    }
    if ([self.removeCache containsObject:itemIndexPath]) {
        attr.transform=CGAffineTransformRotate(CGAffineTransformScale(attr.transform, 4, 4), M_PI/2.0f);
        
        
        //CGAffineTransformMakeRotation(M_PI/2.0);
//        CGAffineTransformRotate(CGAffineTransformScale(CGAffineTransformIdentity, 4, 4), M_PI/180.0f*90);
    }
   
    return attr;
}
-(CGSize)getSizeWitText:(NSString *)text
{
    if (text==nil) {
        return CGSizeZero;
    }
    CGSize size = [text boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    //[text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSLi}];
    return size;
}
@end
