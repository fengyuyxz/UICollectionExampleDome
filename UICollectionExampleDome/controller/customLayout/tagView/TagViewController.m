//
//  TagViewController.m
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/19.
//

#import "TagViewController.h"
#import "TagItemCell.h"
#import "UIColor+random.h"
#import "TensileImageHeadView.h"
#import "TagLayout.h"
#import "BasicSectionHeaderView.h"
@interface TagViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,TagLayoutProtocal>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<NSMutableArray<NSString *>*> *groupTitleData;
@end

@implementation TagViewController
static NSString * const tagCellIdentify =@"TagItemCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *rbut=[UIButton buttonWithType:UIButtonTypeCustom];
    [rbut addTarget:self action:@selector(removeClick) forControlEvents:UIControlEventTouchUpInside];
    [rbut setTitle:@"删除" forState:UIControlStateNormal];
    rbut.frame=CGRectMake(0, 0, 40, 40);
    UIBarButtonItem *removeItem=[[UIBarButtonItem alloc]initWithCustomView:rbut];
    
    UIButton *abut=[UIButton buttonWithType:UIButtonTypeCustom];
    [abut setTitle:@"添加" forState:UIControlStateNormal];
    abut.frame=CGRectMake(0, 0, 40, 40);
    [abut addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem=[[UIBarButtonItem alloc]initWithCustomView:abut];
    self.navigationItem.rightBarButtonItems=@[removeItem,addItem];
    // 添加视图样式
    [self setupSubView];
    //生成数据
    [self setupData];
}
-(void)add{
    NSString *title=[self getTagTitle];
    [self.groupTitleData[0] addObject:title];
    NSIndexPath *addIndex=[NSIndexPath indexPathForRow:self.groupTitleData[0].count-1 inSection:0];
    
    [self.collectionView insertItemsAtIndexPaths:@[addIndex]];
    
    
    
}
-(void)removeClick{
    if (self.groupTitleData[0].count==0) {
        return;
    }
    NSIndexPath *reIdex=[NSIndexPath indexPathForRow:self.groupTitleData[0].count-1 inSection:0];
    [self.groupTitleData[0] removeObjectAtIndex:reIdex.row];
    
    [self.collectionView performBatchUpdates:^{
        [self.collectionView deleteItemsAtIndexPaths:@[reIdex]];
        } completion:^(BOOL finished) {
            
        }];
}
// 设置样式
-(void)setupSubView
{
    TagLayout *layout =({
        TagLayout *layout = [[TagLayout alloc]init];
        layout.delegate=self;
//        layout.scrollDirection =UICollectionViewScrollDirectionVertical;
//        layout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 150);
//        layout.minimumLineSpacing = 2;
//        layout.sectionInset=UIEdgeInsetsMake(10, 0, 0, 0);
//        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        layout.itemSize = CGSizeMake(self.view.bounds.size.width, 50);
        layout;
    });
    self.collectionView = ({
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        [collectionView registerNib:[UINib nibWithNibName:@"TagItemCell" bundle:nil] forCellWithReuseIdentifier:tagCellIdentify];
        [collectionView registerNib:[UINib nibWithNibName:@"TensileImageHeadView" bundle:nil] forSupplementaryViewOfKind:@"ElementTagHeader" withReuseIdentifier:@"TensileImageHeadView"];
        [collectionView registerNib:[UINib nibWithNibName:@"BasicSectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BasicSectionHeaderView"];
        collectionView.contentInset=UIEdgeInsetsMake(88, 0, 0, 0);
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView;
    });
    [self.view addSubview:self.collectionView];
}
-(void)setupData
{
    if (self.groupTitleData == nil) {
        self.groupTitleData = [[NSMutableArray alloc]init];
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        for (int gourp=0; gourp<3; gourp++) {
            NSMutableArray *taglist= [[NSMutableArray alloc]init];
            for (int i=0; i<20; i++) {
                NSString *title=[self getTagTitle];
                [taglist addObject:title];
            }
            [weakSelf.groupTitleData addObject:taglist];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
        });
    });
}
-(NSString *)getTagTitle
{
    NSString *titles = @"少壮不努力老大徒伤悲春眠不觉晓处处问题鸟春来发几枝润物细无声北国风光万里雪飘张弓射大雕";
    NSInteger count = [titles length];
    NSInteger randomIndex = arc4random()%count;
    long start = MAX(0, (randomIndex-7));
    int step = arc4random()%5+2;// 2到7
    
    NSString *title = [titles substringWithRange:NSMakeRange(start, step)];
    return title;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    
    if (self.groupTitleData) {
        return self.groupTitleData.count;
    }
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *list = self.groupTitleData[section];
    if (list) {
        return list.count;
    }
    return 0;
}
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TagItemCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:tagCellIdentify forIndexPath:indexPath];
    NSArray *list = self.groupTitleData[indexPath.section];
    NSString *tag = list[indexPath.row];
    cell.titleLabel.text=tag;
    cell.backgroundColor =[UIColor randomColor];
    return cell;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:@"ElementTagHeader"]) {
        TensileImageHeadView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"TensileImageHeadView" forIndexPath:indexPath];
        view.imageView.image = [UIImage imageNamed:@"kt_sh"];
        return view;

    }else if([UICollectionElementKindSectionHeader isEqualToString:kind]){
        BasicSectionHeaderView *headview=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"BasicSectionHeaderView" forIndexPath:indexPath];
        headview.titleLabel.text=@"dsfasf";
        return headview;
    }
    return nil;
}

-(NSString *)tagText:(__weak UICollectionView * _Nonnull)collectinView indexPath:(NSIndexPath * _Nonnull)indexPath
{
    NSArray *list = self.groupTitleData[indexPath.section];
    NSString *tag = list[indexPath.row];
    return tag;
    
}
@end
