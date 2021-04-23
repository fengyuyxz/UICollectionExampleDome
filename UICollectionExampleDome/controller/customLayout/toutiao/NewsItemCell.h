//
//  NewsItemCell.h
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsItemCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
-(void)begainAnimation;
-(void)stopAnimation;
@end

NS_ASSUME_NONNULL_END
