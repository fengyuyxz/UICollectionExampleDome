//
//  TagLayout.h
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TagLayoutProtocal <NSObject>

-(NSString *)tagText:(__weak UICollectionView * _Nonnull)collectinView indexPath:(NSIndexPath * _Nonnull)indexPath;

@end
@interface TagLayout : UICollectionViewLayout
// 代理
@property(nonatomic,weak) id<TagLayoutProtocal> delegate;

///标签内边距
@property (nonatomic, assign) CGFloat tagInnerMargin;
///元素间距
@property (nonatomic, assign) CGFloat itemSpacing;
///行间距
@property (nonatomic, assign) CGFloat lineSpacing;
///head 高度
@property (nonatomic, assign) CGFloat headerHeight;
///section header高度
@property (nonatomic, assign) CGFloat secionHeaderHeight;

@property (nonatomic, strong) NSString *headerKind;

@end

NS_ASSUME_NONNULL_END
