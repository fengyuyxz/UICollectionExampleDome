//
//  CycileLayoutContoller.m
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/20.
//

#import "CycileLayoutContoller.h"
#import "CycileLayout.h"
#import "CycileCell.h"
#import "UIColor+random.h"
@interface CycileLayoutContoller ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger count;
@end

@implementation CycileLayoutContoller

- (void)viewDidLoad {
    [super viewDidLoad];
    _count=20;
    [self setupSubView];
}
// 设置样式
-(void)setupSubView
{
    CycileLayout *layout =({
        CycileLayout *layout = [[CycileLayout alloc]init];

        layout;
    });
    self.collectionView = ({
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        [collectionView registerClass:[CycileCell class] forCellWithReuseIdentifier:@"CycileCell"];
       
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        collectionView;
    });
    [self.view addSubview:self.collectionView];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CycileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CycileCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor randomColor];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.count-=1;
    [collectionView deleteItemsAtIndexPaths:@[indexPath]];
    /*
    [collectionView performBatchUpdates:^{
        
        } completion:^(BOOL finished) {
            
        }];*/
}

@end
