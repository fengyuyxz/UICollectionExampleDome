//
//  ImageDetailController.m
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/15.
//

#import "ImageDetailController.h"

@interface ImageDetailController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ImageDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.imageView.image = self.image;
}
-(void)setImage:(UIImage *)image{
    _image=image;
   
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
