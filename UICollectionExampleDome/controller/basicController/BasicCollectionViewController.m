//
//  BasicCollectionViewController.m
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/15.
//

#import "BasicCollectionViewController.h"
#import "BasicCollecionViewCell.h"
#import "UIColor+random.h"
#import "ImageDetailController.h"
#import "ImageContextMenuConfiguration.h"
@interface BasicCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation BasicCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
}
static NSString * const basicCellIdentify = @"BasicCollecionViewCell";
-(void)setupCollectionView
{
    UICollectionViewFlowLayout *layout =({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection =UICollectionViewScrollDirectionVertical;
        CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat lineSpace = 5;
        //设置区间距
        layout.sectionInset = UIEdgeInsetsMake(0, lineSpace, 0, lineSpace);
        //设行间距
        layout.minimumLineSpacing = lineSpace;
        //设置列间距
        layout.minimumInteritemSpacing = lineSpace;
        // 设置 cell 大小
        layout.itemSize = CGSizeMake((width-lineSpace-lineSpace-lineSpace)*0.5, width*0.5);
        layout;
    });
    self.collectionView = ({
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        [collectionView registerNib:[UINib nibWithNibName:@"BasicCollecionViewCell" bundle:nil] forCellWithReuseIdentifier:basicCellIdentify];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView;
    });
    [self.view addSubview:self.collectionView];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 100;
}
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BasicCollecionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:basicCellIdentify forIndexPath:indexPath];
   
    
    if (!cell.selectedBackgroundView) {
        UIView *backgroundView = [UIView new];
            backgroundView.backgroundColor = [UIColor colorWithRed:250/255.0f green:239/255.0f blue:218/255.0f alpha:1];
            cell.selectedBackgroundView = backgroundView;
    }
    int index = arc4random()%6;
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"image_%d",index]];
    cell.backgroundColor = [UIColor randomColor];
    return cell;
}
// 将要显示加入简单动画
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    cell.transform = CGAffineTransformMakeScale(0.5, 0.5);//CGAffineTransformMake(1.4, 0, 0, 1.4, 10, 10);
       [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
           cell.transform = CGAffineTransformIdentity;
       } completion:nil];
   

}
// 是否显示长安弹窗菜单栏(copy cut等)13后启用改用 collectionView:contextMenuConfigurationForItemAtIndexPath:
- (BOOL)collectionView:(UICollectionView *)collectionView
shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView
      canPerformAction:(SEL)action
    forItemAtIndexPath:(NSIndexPath *)indexPath
            withSender:(id)sender {
    NSLog(@"%@",NSStringFromSelector(action) );
    // 仅支持copy
    if ([NSStringFromSelector(action) isEqualToString:@"copy:"]) {
        return YES;
    }
    return NO;  // YES for the Cut, copy, paste actions
}


- (void)collectionView:(UICollectionView *)collectionView
         performAction:(SEL)action
    forItemAtIndexPath:(NSIndexPath *)indexPath
            withSender:(id)sender {
    NSLog(@"performAction");
}
- (void)collectionView:(UICollectionView *)collectionView willPerformPreviewActionForMenuWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionCommitAnimating>)animator{
    
    
//    BasicCollecionViewCell *cell = (BasicCollecionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    UIImage *image=cell.imageView.image;
//    ImageDetailController *imageVC=[[ImageDetailController alloc]initWithNibName:@"ImageDetailController" bundle:nil];
//    imageVC.image = image;
//    [self.navigationController pushViewController:imageVC animated:NO];
    ImageDetailController* vc = (ImageDetailController *)animator.previewViewController;
    if(vc)
    {
//        [vc dismissViewControllerAnimated:YES completion:^{
//            [self.navigationController pushViewController:vc animated:YES];
//        }];
        [animator addCompletion:^{
            BasicCollecionViewCell *cell = (BasicCollecionViewCell *)[collectionView cellForItemAtIndexPath:vc.indexPath];
            UIImage *image=cell.imageView.image;
            ImageDetailController *imageVC=[[ImageDetailController alloc]initWithNibName:@"ImageDetailController" bundle:nil];
            imageVC.image = image;
            [self showViewController:imageVC sender:nil];
        }];
        
    }
}
//
- (UIContextMenuConfiguration *)collectionView:(UICollectionView *)collectionView contextMenuConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point
{
    
    BasicCollecionViewCell *cell = (BasicCollecionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIImage *image=cell.imageView.image;
    return [ImageContextMenuConfiguration createImage:image indexPath:indexPath];
}
// 要高亮显示，需要设置cell中的selectedBackgroundView的颜色
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}
-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
