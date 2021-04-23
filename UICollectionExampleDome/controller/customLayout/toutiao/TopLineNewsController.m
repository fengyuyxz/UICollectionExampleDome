//
//  TopLineNewsController.m
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/21.
//

#import "TopLineNewsController.h"
#import "NewsItemCell.h"
#import "BasicSectionHeaderView.h"
#import "UIColor+random.h"
@interface TopLineNewsController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<TagGroupMode *> *dataSource;

// rightbar but
@property(nonatomic,weak) UIButton *rightBut;
/// 选中的cell快照
@property (nonatomic, strong) UIView *snapshot;

/// 手指按住collectionview所在的位置点
@property (nonatomic, assign) CGPoint fingerLocation;

@property (nonatomic, strong) NSIndexPath *originalIndexPath;

/// 手指按住位置的indexPath
@property (nonatomic, strong) NSIndexPath *relocatedIndexPath;
@end

@implementation TopLineNewsController
{
    BOOL isEdit;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
    [self loadData];
}
-(void)setupCollectionView
{
    UIButton *abut=[UIButton buttonWithType:UIButtonTypeCustom];
    [abut setTitle:@"编辑" forState:UIControlStateNormal];
    [abut setTitle:@"完成" forState:UIControlStateSelected];
    [abut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [abut setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    abut.frame=CGRectMake(0, 0, 40, 40);
    [abut addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem=[[UIBarButtonItem alloc]initWithCustomView:abut];
    self.navigationItem.rightBarButtonItems=@[addItem];
    self.rightBut=abut;
    self.view.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *layout = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat mineInteritem = 15;
        layout.minimumInteritemSpacing = mineInteritem;
        layout.minimumLineSpacing = mineInteritem;
        layout.sectionInset = UIEdgeInsetsMake(0, mineInteritem, 0, mineInteritem);
        
        CGFloat width = CGRectGetWidth(self.view.frame);
        layout.itemSize = CGSizeMake((width-3*mineInteritem-mineInteritem*2)/4, 50);
        layout.headerReferenceSize=CGSizeMake(width, 60);
        layout;
    });
    self.collectionView = ({
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        [collectionView registerNib:[UINib nibWithNibName:@"NewsItemCell" bundle:nil] forCellWithReuseIdentifier:@"NewsItemCell"];
       
        [collectionView registerNib:[UINib nibWithNibName:@"BasicSectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BasicSectionHeaderView"];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.backgroundColor = [UIColor whiteColor];
        
        // 添加长安 和 滑动手势
        UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        [collectionView addGestureRecognizer:longPress];
        UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        pan.delegate = self;
        [collectionView addGestureRecognizer:pan];
        
        collectionView;
    });
    
    [self.view addSubview:self.collectionView];
}
-(void)loadData
{
    if (self.dataSource==nil) {
        self.dataSource = [[NSMutableArray alloc]init];
    }
    [self.dataSource removeAllObjects];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            TagGroupMode *my=[[TagGroupMode alloc]init];
            my.title=@"我的频道";
            my.childs=[self getTags:16];
            [weakSelf.dataSource addObject:my];
            TagGroupMode *recommended=[[TagGroupMode alloc]init];
            recommended.title=@"为你推荐";
            recommended.childs=[self getTags:40];
            [weakSelf.dataSource addObject:recommended];
        [weakSelf.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        
    });
}
-(void)edit:(UIButton *)but
{
    isEdit = but.selected=!but.selected;
    if (but.selected) {
        
        
        [self cellBeginAnimation];
    }else{
        [self.collectionView allowsMultipleSelection];
        [self cellFinishAnimation];
    }
}

/// 进入编辑cell开始动画
-(void)cellBeginAnimation
{
    NSArray<NewsItemCell *> *cells= [self getMyChannelCells];
    [cells makeObjectsPerformSelector:@selector(begainAnimation)];
}
/// 完成编辑cell结束动画
-(void)cellFinishAnimation
{
    NSArray<NewsItemCell *> *cells= [self getMyChannelCells];
    [cells makeObjectsPerformSelector:@selector(stopAnimation)];
}
-(void)longPress:(UILongPressGestureRecognizer *)pan
{
    [self handGesture:pan];
}
-(void)pan:(UIPanGestureRecognizer *)pan
{
    [self handGesture:pan];
}
-(void)handGesture:(UIGestureRecognizer *)sender
{
    UIGestureRecognizerState state=sender.state;
    // 手势在collection中的位置
    self.fingerLocation = [sender locationInView:self.collectionView];
    //手指按住对应的cell的indexpath 可能为空
   self.relocatedIndexPath = [self.collectionView indexPathForItemAtPoint:self.fingerLocation];
    switch (state) {
        case UIGestureRecognizerStateBegan:
        {
            self.originalIndexPath = self.relocatedIndexPath;
             //不是按在第一section 也不是之前选中的cell 不进入编辑或移动
            if (self.originalIndexPath==nil||self.originalIndexPath.section!=0||self.snapshot!=nil) {
                return;
            }
            // 进入编辑模式
            if (!isEdit) {
                isEdit=self.rightBut.selected=YES;
                [self cellBeginAnimation];
                
            }
            [self cellSelectedAtIndexPath:self.originalIndexPath];
//            [self.collectionView beginInteractiveMovementForItemAtIndexPath:self.relocatedIndexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (self.originalIndexPath==nil&&self.snapshot==nil) {
                return;
            }
            
            
                CGPoint center = self.snapshot.center;
                center.x=self.fingerLocation.x;
                center.y=self.fingerLocation.y;
                self.snapshot.center = center;
                
                // 判断是否进入了其他cell的范围, 并且不是第二个sections,如果进入了其他cell。或原位置则返回
                if (self.relocatedIndexPath==self.originalIndexPath&&self.relocatedIndexPath.section!=0) {
                    return;
                }
            //重新进行排序
                [self cellRelocatedToNewIndex:self.relocatedIndexPath];
            
            
//            [self.collectionView updateInteractiveMovementTargetPosition:self.fingerLocation];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (self.originalIndexPath==nil && self.snapshot==nil) {
                return;
            }
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            UICollectionViewLayoutAttributes *att=[self.collectionView layoutAttributesForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
            //如果当前位置在第二区域内
            if (self.fingerLocation.y>CGRectGetMaxY(att.frame)) {
                // 将数据加入到第二区
                [self.collectionView performBatchUpdates:^{
                    [self betweenSectionsMoveCell:self.originalIndexPath];
                                } completion:^(BOOL finished) {
                                    [self didEndDraging];
                                }];
               
            }else{
                [self didEndDraging];
            }
        }
            break;
            
        default:
            break;
    }
    
}

/// 拖动结束，显示cell，删除截图
-(void)didEndDraging{
    if (self.originalIndexPath==nil) {
        return;
    }
    NewsItemCell *cell = (NewsItemCell *)[self.collectionView cellForItemAtIndexPath:self.originalIndexPath];
    cell.hidden=NO;
    cell.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.snapshot.center = cell.center;
        self.snapshot.alpha = 0;
        cell.alpha = 1;
        if (self.originalIndexPath.section==1) {
            [cell stopAnimation];
        }
        } completion:^(BOOL finished) {
            [self.snapshot removeFromSuperview];
            self.snapshot = nil;
        }];
}
/// 两个区之间的cell 移动数据
/// @param indexPath 移动的indexPath
-(void)betweenSectionsMoveCell:(NSIndexPath *)indexPath
{
    NSString *title = self.dataSource[indexPath.section].childs[indexPath.row];
    [self.dataSource[indexPath.section].childs removeObjectAtIndex:self.originalIndexPath.row];
    
    //将其插入到第二区第一个位置
    NSIndexPath * anotherIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.dataSource[anotherIndexPath.section].childs insertObject:title atIndex:anotherIndexPath.row];
    [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:anotherIndexPath];
    self.originalIndexPath = anotherIndexPath;
}

/// 将原数据迁移位置
/// @param indexPath 新位置
-(void)cellRelocatedToNewIndex:(NSIndexPath *)indexPath
{
    if (indexPath&&indexPath.section==0) {
        NSString *title = self.dataSource[0].childs[self.originalIndexPath.row];
        [self.dataSource[0].childs removeObjectAtIndex:self.originalIndexPath.row];
        [self.dataSource[0].childs insertObject:title atIndex:indexPath.row];
        [self.collectionView moveItemAtIndexPath:self.originalIndexPath toIndexPath:indexPath];
        self.originalIndexPath = indexPath;
        NSLog(@"原数据迁移位置 %@",        self.originalIndexPath);
    }
}

/// 获取cell的截图 并隐藏改cell
/// @param path indexpath
-(void)cellSelectedAtIndexPath:(NSIndexPath *)path
{
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:path];
//    self.snapshot = cell.layer
    self.snapshot=[cell snapshotViewAfterScreenUpdates:YES];
    
    cell.hidden=YES;
    self.snapshot.center = cell.center;
    [self.collectionView addSubview:self.snapshot];
    [UIView animateWithDuration:0.25 animations:^{
        self.snapshot.transform = CGAffineTransformMakeScale(1.04, 1.04);
        self.snapshot.alpha = 0.98;
        
    }];
    
}
-(NSArray<NewsItemCell *> *)getMyChannelCells{
    NSInteger count = self.dataSource[0].childs.count;
    NSMutableArray *array=[[NSMutableArray alloc]init];
    for (NSInteger row =0; row<count; row++) {
        NSIndexPath *index=[NSIndexPath indexPathForRow:row inSection:0];
        NewsItemCell *cell=(NewsItemCell *)[self.collectionView cellForItemAtIndexPath:index];
        [array addObject:cell];
    }
    
    return array;
}
-(NSMutableArray *)getTags:(NSInteger)count
{
    NSMutableArray<NSString *> *tags=[[NSMutableArray alloc]init];
    for (int i=0; i<count; i++) {
        NSString *title=[self getTagTitle];
        [tags addObject:title];
    }
    return tags;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.dataSource) {
        return self.dataSource.count;
    }
    return 1;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        BasicSectionHeaderView *view=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"BasicSectionHeaderView" forIndexPath:indexPath];
        TagGroupMode *mode = self.dataSource[indexPath.section];
        view.titleLabel.text = mode.title;
        return view;
    }
    return nil;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataSource) {
        TagGroupMode *mode = self.dataSource[section];
        if (mode.childs) {
            return mode.childs.count;
        }
    }
    return 0;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NewsItemCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"NewsItemCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor randomColor];
    TagGroupMode *mode = self.dataSource[indexPath.section];
    
      NSString *title = mode.childs[indexPath.row];
    cell.titleLabel.text=title;
    return cell;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canEditItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    
}
- (BOOL)beginInteractiveMovementForItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)updateInteractiveMovementTargetPosition:(CGPoint)targetPosition
{
    
}
#pragma mark - 手势代理
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
        if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
            UIPanGestureRecognizer *pan=(UIPanGestureRecognizer *)gestureRecognizer;
            CGPoint point = [pan translationInView:self.collectionView];
            if (fabs(point.x)>0.2&&self.snapshot==nil) {
                return YES;
            }
            
        }
    
    return NO;
}
-(NSString *)getTagTitle
{
    NSString *titles = @"少壮不努力老大徒伤悲春眠不觉晓处处问题鸟春来发几枝润物细无声北国风光万里雪飘张弓射大雕";
    NSInteger count = [titles length];
    NSInteger randomIndex = arc4random()%count;
    long start = MAX(0, (randomIndex-7));
    int step = arc4random()%3+2;// 2到4
    
    NSString *title = [titles substringWithRange:NSMakeRange(start, step)];
    return title;
}

@end

@implementation TagGroupMode


@end
