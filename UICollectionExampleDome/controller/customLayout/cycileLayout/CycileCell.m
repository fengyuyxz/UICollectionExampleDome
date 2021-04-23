//
//  CycileCell.m
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/20.
//

#import "CycileCell.h"

@implementation CycileCell
-(void)layoutSubviews{
    [super layoutSubviews];
    self.layer.cornerRadius = self.bounds.size.width*0.5;
}
@end
