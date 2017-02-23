//
//  ViewController.m
//  jianshuPersonCenter
//
//  Created by tianfeng on 16/10/11.
//  Copyright © 2016年 zyl. All rights reserved.
//

#import "ViewController.h"
#import "HeadView.h"

#define  Screen_W   [[UIScreen mainScreen] bounds].size.width
#define  Screen_H   [[UIScreen mainScreen] bounds].size.height
#define  kOriginalImageHeight 200

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,headViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic,strong)HeadView *headView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutView];
    [self setNavigationBarClear];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

-(void)setNavigationBarClear{
    
    //给导航条设置一个空的背景图使其透明化
    [self.navigationController .navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    //去除导航条透明后导航条下的黑线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}

-(void)layoutView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.scrollView];
    self.scrollView.bounces = NO;
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(Screen_W *3 , [UIScreen mainScreen].bounds.size.height)];
    
    //tabelView
    for (int i =0; i<3; i++) {
        UITableView * tabView = [[UITableView alloc]initWithFrame:CGRectMake(i*[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
        tabView.tag = i;
        tabView.delegate = self;
        tabView.dataSource = self;
        tabView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
        tabView.backgroundColor = [UIColor redColor];
        [self.scrollView addSubview:tabView];
//        tabView.bounces = NO;
    }
    
    self.headView = [[[NSBundle mainBundle]loadNibNamed:@"HeadView" owner:nil options:nil] firstObject];
    CGPoint centerPoit = self.view.center;
    centerPoit.y = 90;
    CGRect frame = self.view.frame;
    frame.size.height = 180;
    self.headView.frame = frame;
    self.headView.delegate =self;
    self.headView .center = centerPoit;
//    [self.scrollView addSubview:self.headView];
    [self.view addSubview:self.headView];
    self.scrollView.scrollEnabled = NO;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    if (tableView.tag ==0) {
        cell.textLabel.text = @"0";
    }
    else if (tableView.tag ==1) {
        cell.textLabel.text = @"1";
    }
    else if (tableView.tag ==2) {
        cell.textLabel.text = @"2";
    }

    
    return cell;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"scrollView.x====%f",scrollView.contentOffset.x);
    NSLog(@"scrollView.y====%f",scrollView.contentOffset.y);
    
    CGFloat offSet_Y = scrollView.contentOffset.y;
    //向下拖动图片时
    if (offSet_Y < - kOriginalImageHeight) {
//        //获取imageView的原始frame
//        CGRect frame = self.headView.frame;
//        //修改imageView的Y值等于offSet_Y
//        frame.origin.y = offSet_Y;
//        //修改imageView的height 等于offSet_Y 的绝对值此时偏移量为负数
//        frame.size.height =  - offSet_Y;
//        //重新赋值
//        self.headView.frame = frame;
        CGPoint centerPoit = self.view.center;
        centerPoit.y = 90;
        CGRect frame = self.view.frame;
        frame.size.height = 180;
        self.headView.frame = frame;
    }
    //tableView相对于图片的偏移量
//    NSLog(@"offSet_Y====%f",offSet_Y);

    CGFloat reOffset = offSet_Y + kOriginalImageHeight ;
    
    CGRect frame = self.headView.frame;
    if (offSet_Y >= -kOriginalImageHeight) {
         frame.origin.y = -(offSet_Y +kOriginalImageHeight);
    }
    self.headView.frame = frame;

    //  (kOriginalImageHeight - 64)这个数值决定了导航条在图片上滑时开始出现  alpha从 0 ~ 0.99 变化
    //  当图片底部到达导航条底部时导航条  aphla 变为1导航条完全出现
    CGFloat alpha = reOffset/(kOriginalImageHeight -64);
    if (alpha>=1)  alpha =0.99;
    // 设置导航条的背景图片其透明度随  alpha 值 而改变
    UIImage *image = [self imageWithColor:[UIColor colorWithRed:0.227 green:0.753 blue:0.757 alpha:alpha]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}
-(void)headViewButtonClicked:(UIButton *)btn
{
    NSLog(@"%ld",btn.tag);
//    CGRect frame = self.headView.frame;
//    frame.origin.x = btn.tag * [UIScreen mainScreen].bounds.size.width;
//    self.headView.frame = frame;
    [self.scrollView setContentOffset:CGPointMake(btn.tag *Screen_W ,0) animated:YES];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect=CGRectMake(0.0f,0.0f, 1.0f,1.0f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return theImage;
}

@end
