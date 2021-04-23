//
//  PickerRoundController.m
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/20.
//

#import "PickerRoundController.h"
#import "PickerRoundCell.h"
#import "UIColor+random.h"
#import "PickerRoundLayout.h"
@interface PickerRoundController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger count;

@end

@implementation PickerRoundController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubView];
}
// 设置样式
-(void)setupSubView
{
    _count = 10;
    self.view.backgroundColor = [UIColor whiteColor];
    PickerRoundLayout *layout =({
        PickerRoundLayout *layout = [[PickerRoundLayout alloc]init];

        layout;
    });
    self.collectionView = ({
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)*0.5-200, CGRectGetWidth(self.view.bounds), 400) collectionViewLayout:layout];
        [collectionView registerNib:[UINib nibWithNibName:@"PickerRoundCell" bundle:nil] forCellWithReuseIdentifier:@"PickerRoundCell"];
       
        
        collectionView.dataSource = self;
        
        collectionView;
    });
    
    [self.view addSubview:self.collectionView];
    //默认是在第二列，滚一平在第一列
    self.collectionView.contentOffset = CGPointMake(0, 400);
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PickerRoundCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PickerRoundCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor randomColor];
    cell.titleLabel.text = [NSString stringWithFormat:@"第%ld行数",(long)indexPath.row];
    return cell;
}

@end
