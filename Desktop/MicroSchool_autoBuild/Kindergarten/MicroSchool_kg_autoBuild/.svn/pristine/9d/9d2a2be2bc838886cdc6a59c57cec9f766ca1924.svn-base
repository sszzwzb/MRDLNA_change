//
//  MicroSchoolLoginViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-10-30.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "MicroSchoolLoginViewController.h"
#import "SubUINavigationController.h"



@interface MicroSchoolLoginViewController ()

@end

extern UINavigationController *navigation_Signup;

@implementation MicroSchoolLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.navigationController.navigationBarHidden = true;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = true;

    self.navigationController.navigationBar.translucent = NO;
}

- (void)loadView
{
    UIView *view = [[ UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height)];
    
    self.view = view;

    view.userInteractionEnabled = YES;
    NSLog(@"height = %f",[ UIScreen mainScreen].applicationFrame.size.height);
    NSLog(@"width = %f",[ UIScreen mainScreen].applicationFrame.size.width);

    NSLog(@"x = %f",[ UIScreen mainScreen].applicationFrame.origin.x);
    NSLog(@"y = %f",[ UIScreen mainScreen].applicationFrame.origin.y);

    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    UIImage *image;
    NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_splash_image"];
    
    if(imageData != nil)
    {
        image = [UIImage imageWithData:imageData];
    } 
    else
    {
        if (iPhone3gs) {
            image = [UIImage imageNamed:@"spl_320_480.png"];
        }else if (iPhone4) {
            image = [UIImage imageNamed:@"spl_640_960.png"];
        }else {
            image = [UIImage imageNamed:@"spl_640_1136.png"];
        }
    }
    // alloc一个uiView
    splashView=[UIView new];
    // 将imgView放入到闪屏view中
    [self.view addSubview:splashView];
    [splashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(WIDTH,HEIGHT));
    }];
    // 背景图片
    // 将闪屏图片放入imgView中
    imgView =[UIImageView new];
    imgView.image=image;
    [splashView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(splashView.mas_top).with.offset(0);
        make.left.equalTo(splashView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(WIDTH,HEIGHT));
    }];
    // 创建login button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    //设置title自适应对齐
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    // 设置颜色和字体
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button.alpha = 0.7;
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    [button setBackgroundImage:[UIImage imageNamed:@"MircroLogin.png"] forState:UIControlStateNormal] ;
    [button setBackgroundImage:[UIImage imageNamed:@"MircroLoginSelect.png"] forState:UIControlStateHighlighted] ;
    button.layer.cornerRadius = 20;
    button.layer.masksToBounds =YES;
    // 添加 action
    [button addTarget:self action:@selector(longin_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    //设置title
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button setTitle:@"登录" forState:UIControlStateHighlighted];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(HEIGHT-50);
        make.left.equalTo(self.view).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(WIDTH/2-20,40));
    }];
    // 创建creat button
    UIButton *button_create = [UIButton buttonWithType:UIButtonTypeCustom];
    button_create.layer.cornerRadius = 20;
    button_create.layer.masksToBounds = YES;
    button_create.alpha = 0.7;
    //button.center = CGPointMake(160.0f, 140.0f);
    button_create.titleLabel.textAlignment = NSTextAlignmentCenter;
    //设置title自适应对齐
    button_create.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    // 设置颜色和字体
    [button_create setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button_create setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button_create.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [button_create setBackgroundImage:[UIImage imageNamed:@"MircroLogin.png"] forState:UIControlStateNormal] ;
    [button_create setBackgroundImage:[UIImage imageNamed:@"MircroLoginSelect.png"] forState:UIControlStateHighlighted] ;

    // 添加 action
    [button_create addTarget:self action:@selector(create_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    
    //设置title
    [button_create setTitle:@"注册" forState:UIControlStateNormal];
    [button_create setTitle:@"注册" forState:UIControlStateHighlighted];
    
    [self.view addSubview:button_create];
    [button_create mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(HEIGHT-50);
        make.left.equalTo(self.view).with.offset((WIDTH/2)+5);
        make.size.mas_equalTo(CGSizeMake((WIDTH/2)-15,40));
    }];
    
    //---去掉版本号以及学校名字 2.9.4迭代3需求 2016.2.24----------------------------------------------------------------
    /*// 学校名称
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                               button.frame.origin.y - button.frame.size.height -30, 300, 100)];
    label.text = G_SCHOOL_NAME;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont boldSystemFontOfSize:18.0f];
    label.numberOfLines = 0;
    UIColor *testColor1= [UIColor colorWithRed:33/255.0 green:126/255.0 blue:213/255.0 alpha:1];

    label.textColor = testColor1;
    label.backgroundColor = [UIColor clearColor];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:label];

   // app名字
    UILabel *label_ver = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 250, 23)];
    label_ver.text = [NSString stringWithFormat:@"知校 %@", G_APP_VERSION];
    [label_ver setShadowColor:[UIColor blackColor]];
    [label_ver setShadowOffset:CGSizeMake(1, 1)];

    label_ver.lineBreakMode = NSLineBreakByWordWrapping;
    label_ver.font = [UIFont systemFontOfSize:17.0f];
    label_ver.numberOfLines = 0;
    label_ver.textColor = [UIColor whiteColor];
    label_ver.backgroundColor = [UIColor clearColor];
    label_ver.lineBreakMode = NSLineBreakByTruncatingTail;
    label_ver.textAlignment = NSTextAlignmentLeft;
    
    [self.view addSubview:label_ver];*/
    //--------------------------------------------------------------------------------------------------------------
    
    
}

- (NSString *)stringFormDict:(NSDictionary*)dict
{
    NSMutableString *str = [NSMutableString string];
    NSArray *keys = [dict allKeys];
    for (NSString *key in keys)
    {
        if ([[dict objectForKey:key] isKindOfClass:[NSDictionary class]])
        {
            id obj = [dict objectForKey:key];
            [str appendFormat:@"\n%@: %@",key,[self stringFormDict:obj]];
        }
        else if([[dict objectForKey:key] isKindOfClass:[NSArray class]])
        {
            [str appendFormat:@"\n%@:",key];
            for (id obj in [dict objectForKey:key])
            {
                [str appendFormat:@"\n%@",[self stringFormDict:obj]];
            }
        }
        else
        {
            [str appendFormat:@"\n%@: %@",key,[dict objectForKey:key]];
        }
    }
    NSLog(@"str = %@", str);
    return str;
}

- (IBAction)longin_btnclick:(id)sender
{
    LoginViewController *login = [[LoginViewController alloc] init];
    
    SubUINavigationController *navigation = [[SubUINavigationController alloc] init];
    [navigation setTitle:@"testNavigation"];
    [navigation initWithRootViewController:login];
    
    //[navigation pushViewController:signUp animated:YES];
    [self presentViewController:navigation animated:YES completion:nil];
   
}

- (IBAction)create_btnclick:(id)sender
{
#if 9
    SignupViewController *signUp = [[SignupViewController alloc] init];
    
   /* UINavigationController *navigation = [[UINavigationController alloc] init];
    [navigation setTitle:@"testNavigation"];
    [navigation initWithRootViewController:signUp];
     [self presentViewController:navigation animated:YES completion:nil];
    */
    
    navigation_Signup = [[SubUINavigationController alloc]initWithRootViewController:signUp];
    [self presentViewController:navigation_Signup animated:YES completion:nil];
    [[NSUserDefaults standardUserDefaults]setObject:@"setHeadImg" forKey:@"fromNameToHome"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    //----------------------------------------------------
    
    //[navigation pushViewController:signUp animated:YES];
   
#else
    SetPersonalViewController *signUp = [[SetPersonalViewController alloc] init];
    
    UINavigationController *navigation = [[UINavigationController alloc] init];
    [navigation setTitle:@"testNavigation"];
    [navigation initWithRootViewController:signUp];
    
    //[navigation pushViewController:signUp animated:YES];
    [self presentViewController:navigation animated:YES completion:nil];
#endif
}

-(IBAction)btnClicked{
    NSLog(@"%s",__FUNCTION__);
    if (indicator.visible==NO) {
        [indicator show:NO];
    }else {
        [indicator hide];
    }
}


//// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return NO;
}
////
//// 是否支持横竖屏显示
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
