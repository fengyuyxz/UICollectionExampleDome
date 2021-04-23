//
//  ImageContextMenuConfiguration.h
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ImageContextMenuConfiguration : NSObject
+(UIContextMenuConfiguration *)createImage:(UIImage *)image indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
