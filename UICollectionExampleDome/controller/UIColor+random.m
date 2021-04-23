//
//  UIColor+random.m
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/15.
//

#import "UIColor+random.h"

@implementation UIColor (random)
+(UIColor *)randomColor
{
    CGFloat r,g,b;
    r = arc4random()%256 / 255.0;
    g = arc4random()%256 / 255.0;
    b = arc4random()%256 / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
    
}
@end
