//
//  SwitchCardLayoutController.m
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/21.
//

#import "SwitchCardLayoutController.h"
#import "CycilcStaticLayout.h"
#import "UIColor+random.h"
#import "CycileRoundLayout.h"
@interface SwitchCardLayoutController ()<UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation SwitchCardLayoutController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor whiteColor];
    [self setupCollectionView];
}
-(void)setupCollectionView{
    CycileRoundLayout *layout=[[CycileRoundLayout alloc]init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)*0.5-CGRectGetWidth(self.view.frame)*0.5, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame)) collectionViewLayout:layout];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor randomColor];
    return cell;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.collectionView.collectionViewLayout isKindOfClass:[CycileRoundLayout class]]) {
        [self.collectionView setCollectionViewLayout:[[CycilcStaticLayout alloc]init] animated:YES];
    }else if ([self.collectionView.collectionViewLayout isKindOfClass:[CycilcStaticLayout class]]) {
        [self.collectionView setCollectionViewLayout:[[CycileRoundLayout alloc]init] animated:YES];
    }
}
@end
