//
//  WaterfallLayoutController.m
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/15.
//

#import "WaterfallLayoutController.h"
#import "UIColor+random.h"
#import "BasicCollecionViewCell.h"
#import "WaterfallLayout.h"
@interface WaterfallLayoutController ()<UICollectionViewDataSource,WaterfallLayout>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation WaterfallLayoutController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
}
static NSString * const basicCellIdentify = @"BasicCollecionViewCell";
-(void)setupCollectionView
{
    WaterfallLayout *layout =({
        WaterfallLayout *layout = [[WaterfallLayout alloc]init];
        CGFloat lineSpace = 2;
        //设置区间距
//        layout.sectionInset = UIEdgeInsetsMake(0, lineSpace, 0, lineSpace);
        //设行间距
        layout.minimumLineSpacing = lineSpace;
        //设置列间距
        layout.minimumInteritemSpacing = lineSpace;
        // 设置 cell 大小
        layout.delegate = self;
        layout;
    });
    self.collectionView = ({
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
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
-(CGFloat)itemHight:(__weak UICollectionView * _Nonnull)collectionView indexPath:(NSIndexPath * _Nonnull )indexPath{
    CGFloat hight = arc4random()%180+80.0;
    return hight;
}
@end
