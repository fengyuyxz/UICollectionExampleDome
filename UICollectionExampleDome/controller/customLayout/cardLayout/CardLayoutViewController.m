//
//  CardLayoutViewController.m
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/15.
//

#import "CardLayoutViewController.h"
#import "BasicCollecionViewCell.h"
#import "UIColor+random.h"
#import "CardLayout.h"
@interface CardLayoutViewController ()<UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation CardLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupCollectionView];
}
static NSString * const basicCellIdentify = @"BasicCollecionViewCell";
-(void)setupCollectionView
{
    CardLayout *layout =({
        CardLayout *layout = [[CardLayout alloc]init];
        layout.scrollDirection =UICollectionViewScrollDirectionHorizontal;
        
        CGFloat width = CGRectGetWidth(self.view.bounds);
        CGFloat lineSpace = 10;
        CGFloat itemWidth = (width-lineSpace)*0.5;
        
        //设置区间距
        layout.sectionInset = UIEdgeInsetsMake(0, width*0.5-itemWidth*0.5, 0, width*0.5-itemWidth*0.5);
        //设行间距
        layout.minimumLineSpacing = lineSpace;
        //设置列间距
//        layout.minimumInteritemSpacing = lineSpace;
        // 设置 cell 大小
        layout.itemSize = CGSizeMake(itemWidth, 300);
        layout;
    });
    self.collectionView = ({
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)*0.5 - 200, CGRectGetWidth(self.view.bounds), 400) collectionViewLayout:layout];
        [collectionView registerNib:[UINib nibWithNibName:@"BasicCollecionViewCell" bundle:nil] forCellWithReuseIdentifier:basicCellIdentify];
        collectionView.dataSource = self;
        
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
@end
