//
//  TopLineNewsController.h
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopLineNewsController : UIViewController

@end

@interface TagGroupMode : NSObject
@property(nonatomic,strong)NSString *title;
@property (nonatomic, strong) NSMutableArray<NSString *> *childs;
@end

NS_ASSUME_NONNULL_END
