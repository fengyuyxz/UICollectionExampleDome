//
//  WaterfallLayout.h
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WaterfallLayout <NSObject>
@required
-(CGFloat)itemHight:(__weak UICollectionView * _Nonnull)collectionView indexPath:(NSIndexPath * _Nonnull )indexPath;

@end

@interface WaterfallLayout : UICollectionViewLayout
@property (nonatomic, assign) int columns;//列数

/// 列间距
@property (nonatomic, assign) CGFloat minimumLineSpacing;

/// 行间距
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
@property(nonatomic,weak)id<WaterfallLayout> delegate;
@end

NS_ASSUME_NONNULL_END

