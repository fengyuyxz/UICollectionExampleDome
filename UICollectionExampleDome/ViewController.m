//
//  ViewController.m
//  UICollectionExampleDome
//
//  Created by yanxuezhou on 2021/4/15.
//

#import "ViewController.h"
static NSString * const titleKey = @"name";
static NSString * const vcKey = @"vcName";
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<NSDictionary<NSString *,NSString *> *> *items;
@end

@implementation ViewController
//
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _items = @[@{titleKey:@"基本使用",
                 vcKey:@"BasicCollectionViewController"},
               @{titleKey:@"卡片布局",
                 vcKey:@"CardLayoutViewController"},
               @{titleKey:@"头部伸缩布局",
                 vcKey:@"TensileLayoutController"},
                 @{titleKey:@"瀑布流",
                   vcKey:@"WaterfallLayoutController"},
               @{titleKey:@"标题",
                 vcKey:@"TagViewController"},
               @{titleKey:@"圆环布局",
                 vcKey:@"CycileLayoutContoller"},
               @{titleKey:@"模仿pickerView滚轮",
                 vcKey:@"PickerRoundController"},
               @{titleKey:@"球形布局",
                 vcKey:@"BallController"},
               @{titleKey:@"切换布局动画1",
                 vcKey:@"SwitchCardLayoutController"},
               @{titleKey:@"仿头条新增关注类型页面",
                 vcKey:@"TopLineNewsController"}
    ];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"tableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = self.items[indexPath.row][titleKey];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *className = self.items[indexPath.row][vcKey];
    Class clazz = NSClassFromString(className);
    if (clazz) {
        UIViewController *vc = [[clazz alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
