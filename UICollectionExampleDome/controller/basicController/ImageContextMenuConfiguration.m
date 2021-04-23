//
//  ImageContextMenuConfiguration.m
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/15.
//

#import "ImageContextMenuConfiguration.h"
#import "ImageDetailController.h"
@implementation ImageContextMenuConfiguration
+(UIContextMenuConfiguration *)createImage:(UIImage *)image indexPath:(NSIndexPath *)indexPath{
    if (@available(iOS 13.0, *)) {
        UIContextMenuConfiguration * config = ({
            UIContextMenuConfiguration * config=[UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:^UIViewController * _Nullable{
                ImageDetailController *imageVC=[[ImageDetailController alloc]initWithNibName:@"ImageDetailController" bundle:nil];
                imageVC.image = image;
                imageVC.indexPath = indexPath;
                CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds)*0.5;
                imageVC.preferredContentSize = CGSizeMake(280, 360);
                return imageVC;
                
            } actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
                UIAction *copy = [UIAction actionWithTitle:@"复制" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {

                }];
                UIAction *share = [UIAction actionWithTitle:@"分享" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {

                }];
                NSMutableArray<UIMenuElement *> *scorList=[@[] mutableCopy];
                for (int i=1; i<=5; i++) {
                    UIAction *score = [UIAction actionWithTitle:[NSString stringWithFormat:@"%d 分",i] image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {

                    }];
                    [scorList addObject:score];
                }
                UIMenu *score= [UIMenu menuWithTitle:@"打分" image:[UIImage systemImageNamed:@"star.circle"] identifier:nil options:UIMenuOptionsDestructive children:scorList];
                
                UIMenu *mun = [UIMenu menuWithTitle:@"test" children:@[score,share]];
                return mun;
            }];
            config;
        });
        return config;
    } else {
        // Fallback on earlier versions
        return nil;
    }
   
}
@end
