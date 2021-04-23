//
//  TensileLayoutController.m
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/16.
//

#import "TensileLayoutController.h"
#import "TensileLayout.h"
#import "BasicCollecionViewCell.h"
#import "UIColor+random.h"
#import "TensileImageHeadView.h"
@interface TensileLayoutController ()<UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation TensileLayoutController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupCollectionView];
    
}
static NSString * const basicCellIdentify = @"BasicCollecionViewCell";
-(void)setupCollectionView
{
    TensileLayout *layout =({
        TensileLayout *layout = [[TensileLayout alloc]init];
        layout.scrollDirection =UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 150);
        layout.minimumLineSpacing = 2;
        layout.sectionInset=UIEdgeInsetsMake(10, 0, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(self.view.bounds.size.width, 50);
        layout;
    });
    self.collectionView = ({
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        [collectionView registerNib:[UINib nibWithNibName:@"BasicCollecionViewCell" bundle:nil] forCellWithReuseIdentifier:basicCellIdentify];
        [collectionView registerNib:[UINib nibWithNibName:@"TensileImageHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TensileImageHeadView"];
        collectionView.dataSource = self;
        
//        collectionView.contentInset=UIEdgeInsetsMake(88, 0, 0, 0);
        collectionView.alwaysBounceVertical=YES;
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
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        TensileImageHeadView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"TensileImageHeadView" forIndexPath:indexPath];
        view.imageView.image = [UIImage imageNamed:@"kt_sh"];
        return view;

    }
    return nil;
}
@end
