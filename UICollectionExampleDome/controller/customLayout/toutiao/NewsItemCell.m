//
//  NewsItemCell.m
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/21.
//

#import "NewsItemCell.h"
#define angle2Rad(angle) ((angle)/180.0f * M_PI)
@implementation NewsItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
}
-(void)begainAnimation{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    CGFloat startAngle = angle2Rad(-1.5);
    CGFloat endAngle = angle2Rad(1.5);
    /*
    animation.values=@[@(startAngle),@(endAngle),@(startAngle)];
    animation.duration=0.35;
    animation.repeatCount = MAXFLOAT;
    */
    
    animation.fromValue = @(startAngle);
    animation.toValue = @(endAngle);
    animation.duration=0.15;
    animation.removedOnCompletion=NO;
    animation.repeatCount = MAXFLOAT;
    animation.autoreverses = YES;
    
    [self.layer addAnimation:animation forKey:nil];
}
-(void)stopAnimation
{
    [self.layer removeAllAnimations];
}
@end
