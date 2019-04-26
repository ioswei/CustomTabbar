//
//  AWLineTabBarController.m
//  PeoitXLoanProject
//
//  Created by iMac-1 on 2019/4/26.
//  Copyright © 2019 iOS_阿玮. All rights reserved.
//

#import "AWLineTabBarController.h"

#import "ViewController.h"

#define BTN_HEIGHT 50
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define BTNTAG 10000

@interface AWLineTabBarController ()
{
    UIButton *_button;
    UIButton *_butTitle;
    UIView *_lineView;
}
@end

@implementation AWLineTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initControllers];
    
    [self creatTabbar];
    
    //去除顶部的分割线 -- 根据需求 自定注释
//    [[UITabBar appearance] setShadowImage:[UIImage new]];
//    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];

}

#pragma mark - 如果想添加控制器到tabbar里面在这里面实例化就行
- (void)initControllers
{
  #pragma mark ————————————————主页
  ViewController *homeVC  = [[ViewController alloc]init];
  UINavigationController *navVC1 = [[UINavigationController alloc]initWithRootViewController:homeVC];
  [navVC1 setNavigationBarHidden:YES];
    
  #pragma mark ————————————————我的
    ViewController *mineVC = [[ViewController alloc]init];
    UINavigationController *navVC2 = [[UINavigationController alloc]initWithRootViewController:mineVC];
  [navVC2 setNavigationBarHidden:YES];
  
  ViewController *uerVC = [[ViewController alloc]init];
  UINavigationController *navVC3 = [[UINavigationController alloc] initWithRootViewController:uerVC];
  [navVC3 setNavigationBarHidden:YES];
    
    ViewController *uer1VC = [[ViewController alloc]init];
    UINavigationController *navVC4 = [[UINavigationController alloc] initWithRootViewController:uer1VC];
    [navVC4 setNavigationBarHidden:YES];
  
  NSArray *ctrlArr = [NSArray arrayWithObjects:navVC1,navVC2,navVC3,navVC4,nil];
  
  self.viewControllers=ctrlArr;
    //照着上面添加控制球就行了

   
}

- (void)creatTabbar{
    
    NSArray *titleArrs = @[@"事件",@"程序猿",@"程序媛",@"工程师"];
    //  只需要该图片名字就行
    NSArray * normImage = @[@"tabbar_home",@"tabbar_home",@"tabbar_home",@"tabbar_home"];
    //  只需修改选中图片的名字
    NSArray * selectImage = @[@"tabbar_homeSelect",@"tabbar_homeSelect",@"tabbar_homeSelect",@"tabbar_homeSelect"];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tabBar.frame.size.height)];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.userInteractionEnabled = YES;
    
    float btn_X = 0;
    float btn_width = SCREEN_WIDTH/self.viewControllers.count;
    if ([self getIsIpad]) {
        btn_X = 100;
        btn_width = (SCREEN_WIDTH-btn_X*2)/self.viewControllers.count;
    }
    
    for(int i = 0;i<self.viewControllers.count;i++){
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btn_X+btn_width*i, 0, btn_width, 34);
        [btn setImage:[UIImage imageNamed:normImage[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selectImage[i]] forState:UIControlStateSelected];
        [bgView addSubview:btn];

        
        UIButton *titleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        titleBtn.frame = CGRectMake(btn_X+btn_width*i, 26, btn_width, 20);
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [titleBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
        [titleBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateSelected)];
        [titleBtn setTitle:titleArrs[i] forState:(UIControlStateNormal)];
        [bgView addSubview:titleBtn];
        
        UIButton *chooseBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        chooseBtn.frame = CGRectMake(btn_X+btn_width*i, 0, btn_width, 54);
        [chooseBtn addTarget:self action:@selector(btnSelect:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:chooseBtn];
        
        if (i == 0) {
            _button = btn;
            _butTitle = titleBtn;
            titleBtn.selected = btn.selected = YES;
        }
        chooseBtn.tag = BTNTAG+i;
        btn.tag = BTNTAG+i+10;
        titleBtn.tag = BTNTAG+i+20;
        
    }
    
    //设置横线的宽度
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 54, SCREEN_WIDTH/self.viewControllers.count/2,2)];
    _lineView.backgroundColor = [UIColor redColor];
    _lineView.center = CGPointMake(_button.center.x, _button.center.y+30);
    [bgView addSubview:_lineView];
    
    [self.tabBar addSubview:bgView];
    
}

#pragma mark --- 震动动画
- (void)btnSelect:(UIButton *)sender{
    
    NSLog(@"------ %ld",sender.tag);
 
    _butTitle.selected = _button.selected = NO;

    UIButton *tmpImgBtn = [self.view viewWithTag:sender.tag+10];
    UIButton *tmpTitleBtn = [self.view viewWithTag:sender.tag+20];

    tmpTitleBtn.selected = tmpImgBtn.selected = YES;
    _butTitle = tmpTitleBtn;
    _button = tmpImgBtn;
    self.selectedIndex = sender.tag-BTNTAG;
    
    [UIView animateWithDuration:.233 animations:^{
        _lineView.center = CGPointMake(_button.center.x, _button.center.y+30);
    }];
    
}

//如果想要判断设备是ipad，要用如下方法
- (BOOL)getIsIpad{
    
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType isEqualToString:@"iPhone"]) {
        //iPhone
        return NO;
    }
    else if([deviceType isEqualToString:@"iPod touch"]) {
        //iPod Touch
        return NO;
    }
    else if([deviceType isEqualToString:@"iPad"]) {
        //iPad
        return YES;
    }
    return NO;
    
    //这两个防范判断不准，不要用
    //#define is_iPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    //
    //#define is_iPad (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
