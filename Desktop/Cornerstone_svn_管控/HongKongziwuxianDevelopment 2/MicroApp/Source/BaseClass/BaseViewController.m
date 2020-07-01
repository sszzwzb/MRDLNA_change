//
//  BaseViewController.m
//  NewMicroSchool
//
//  Created by kaiyi on 2017/8/24.
//  Copyright © 2017年 kaiyi. All rights reserved.
//

#import "BaseViewController.h"

#import "IQKeyboardManager.h"

@interface BaseViewController () <UISearchBarDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.'
    
    self.view.backgroundColor = [UIColor whiteColor];
    //network = [NetworkUtility alloc];
    
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    /**  iPhone X 顶部 44 + 44
     *   iphone  20 + 44
     *
     *   iPhone X 底部 68
     *   iphone  0
     */
//    NSLog(@"self.navigationController.navigationBar.frame  y == %lf   %lf",self.navigationController.navigationBar.bounds.origin.y  ,   CGRectGetMinY(self.navigationController.navigationBar.frame));
//
//    NSLog(@"self.view.frame  y == %lf   %lf",self.view.bounds.origin.y  ,   CGRectGetMinY(self.view.frame));
//
//    NSLog(@"状态栏height %lf",[[UIApplication sharedApplication] statusBarFrame].size.height);
    
    
    
//    UINavigationBar
//    UIStatusBar
//    UITabBar
    
    //  关闭三方键盘上的toolbar
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

-(void)viewSafeAreaInsetsDidChange
{
    [super viewSafeAreaInsetsDidChange];

    if (@available(iOS 11.0, *)) {
        NSLog(@"viewSafeAreaInsetsDidChange-%@",NSStringFromUIEdgeInsets(self.view.safeAreaInsets));
    }
    
    [self updateOrientation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"当前类为：%@",NSStringFromClass([self class]));
    
    NSArray * ctrlArray = self.navigationController.viewControllers;
    NSLog(@"ctrlArray helloword  ====  %@",ctrlArray);
}

-(void)viewWillDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;   //  白色状态栏
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    
}

-(void)selectLeftAction:(id)sender
{
    
}

-(void)selectRightAction:(id)sender
{
    
}

//右滑返回手势 如果是右滑返回走这个方法 相当于 selectLeftAction
- (BOOL)gestureRecognizerShouldBegin{
    
    return YES;
}



#pragma mark -
#pragma mark Title
-(void)setCustomizeTitle:(NSString *)title
{
    [self setCustomizeTitle:title
                      bgImg:@"nav14"
                 titleColor:[UIColor whiteColor]];
}


-(void)setCustomizeTitle:(NSString *)title bgImg:(NSString*)bgImgName
{
    [self setCustomizeTitle:title
                      bgImg:bgImgName
                 titleColor:[UIColor whiteColor]];
}

-(void)setCustomizeTitle:(NSString *)title bgImg:(NSString*)bgImgName titleColor:(UIColor*)color
{
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth -150.0)/2.0, 0, 150, 44)];
    usernameLabel.text = title;
    usernameLabel.textColor = color;
    
    //设置Label背景透明
    usernameLabel.backgroundColor = [UIColor clearColor];
    
    //设置文本字体与大小
    usernameLabel.font = [UIFont boldSystemFontOfSize:17];
    
    //usernameLabel.adjustsFontSizeToFitWidth=YES;
    usernameLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = usernameLabel;
    
    
    
    //  statusBar  透明
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = [UIColor clearColor];
//        statusBar.layer.contents = (id)[UIImage imageNamed:bgImgName].CGImage;
    }
    
    
    self.navigationController.navigationBar.translucent = UIBarStyleDefault;
    
    //  注意图片尺寸要够大
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:bgImgName]imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forBarMetrics:UIBarMetricsDefault];
    
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}


#pragma mark -
#pragma mark UISearchBar and Delegate
-(void)setCustomizeSearchBarTitle:(NSString *)title
{
    [self setCustomizeSearchBarTitle:title isBut:NO];
}

-(void)setCustomizeSearchBarButTitle:(NSString *)title
{
    [self setCustomizeSearchBarTitle:title isBut:YES];
}

-(void)setCustomizeSearchBarTitle:(NSString *)title isBut:(BOOL)isbut
{
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    //  搜索   iphone X  有问题，iphone X UISearchBar高度是 70  //  实际
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44);  //  正常实际 27
    [searchBar setBackgroundImage:[[UIImage alloc]init]];
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.showsCancelButton = NO;
//    [self.view addSubview:_searchBar];
    searchBar.placeholder = title;
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    if (isbut) {
        UIButton *but = [UIButton buttonWithType:(UIButtonTypeCustom)];
        but.frame = CGRectMake(0, 0, CGRectGetWidth(searchBar.frame), CGRectGetHeight(searchBar.frame));
        [searchBar addSubview:but];
        
        but.backgroundColor = [UIColor clearColor];
        [but addTarget:self action:@selector(selectSearchBarButAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
    } else {
        searchBar.delegate = self;
    }
    
    self.navigationItem.titleView = searchBar;
    
    if (@available(iOS 11.0, *)) {
        [[searchBar.heightAnchor constraintEqualToConstant:44.0] setActive:YES];
    }
}

-(void)selectSearchBarButAction:(id)sender
{
    
}

//点击键盘上搜索时的相应事件
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSLog(@"搜索 = %@",searchBar.text);
    
    [self.navigationItem.titleView endEditing:YES];
}


#pragma mark -
#pragma mark LeftButton
-(void)setCustomizeLeftButton
{
    
//    [self setCustomizeLeftButtonChoiceImage:@"navicons_03.png"
//                                selectedImg:@"navicons_03.png"];

    [self setCustomizeLeftButtonChoiceImage:@"TabBack_normal"
                                selectedImg:@"TabBack_normal"];
    
}

-(void)setCustomizeLeftButtonWithName:(NSString*)name
{
    
    [self setCustomizeLeftButtonWithName:name
                                   color:[UIColor colorWithRed:91/255.0 green:141/255.0 blue:255/255.0 alpha:1]];
}

-(void)setCustomizeLeftButtonWithName:(NSString*)name color:(UIColor*)color
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    rightButton.frame = CGRectMake(0, 0, 44, 24);
    rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //设置title自适应对齐
    rightButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightMedium];
    // 设置颜色和字体
    [rightButton setTitleColor:color forState:UIControlStateNormal];
    
    [rightButton setTitleColor:[UIColor colorWithRed:83/255.0 green:108/255.0 blue:185/255.0 alpha:1] forState:UIControlStateHighlighted];

    rightButton.titleLabel.font =  [UIFont systemFontOfSize:16.0f weight:UIFontWeightMedium];
    // 设置title
    [rightButton setTitle:name forState:UIControlStateNormal];
    [rightButton setTitle:name forState:UIControlStateHighlighted];
    //    [rightButton setImage:[UIImage imageNamed:fileName] forState:UIControlStateNormal];
    //    [rightButton setImage:[UIImage imageNamed:fileName] forState:UIControlStateSelected];
    [rightButton addTarget:self action:@selector(selectLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    //UINavigationItem *navigatorItem = [TTNavigator navigator].visibleViewController.navigationItem;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    if(([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)){//边距调整 kate
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        /**
         *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
         *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
         */
        //        negativeSpacer.width = -15;
        negativeSpacer.width = 0;
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightBarButton, nil];
    }else{
        self.navigationItem.leftBarButtonItem = rightBarButton;
    }
    
}


-(void)setCustomizeLeftButtonChoiceImage:(NSString*)imageName
{
    
    if ([imageName isEqualToString:@"leftBarButtonItem"]) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;  //  黑色状态栏
    }
    
    [self setCustomizeLeftButtonChoiceImage:imageName selectedImg:imageName];
}


-(void)setCustomizeLeftButtonChoiceImage:(NSString*)imageName selectedImg:(NSString *)selectedimageName
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    leftButton.frame = CGRectMake(8, 0, 33, 33);
    [leftButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:selectedimageName] forState:UIControlStateSelected];
    
    
    [leftButton addTarget:self action:@selector(selectLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    //UINavigationItem *navigatorItem = [TTNavigator navigator].visibleViewController.navigationItem;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    
    if(([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)){//边距调整 kate
        /** *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-15时，间距正好调整
         *  为10；width为正数时，正好相反，相当于往左移动width数值个像素
         */
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -10;  //  修改位置
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, leftBarButton, nil];
        
    }else{
        self.navigationItem.leftBarButtonItem = leftBarButton;
    }
    
}

//  带向下箭头的按键
-(void)setCustomizeLeftButtonChoiceDownArrowButtonWittName:(NSString*)name
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    rightButton.frame = CGRectMake(0, 0, 80, 24);
    rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //设置title自适应对齐
    rightButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightMedium];
    // 设置颜色和字体
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [rightButton setTitleColor:[UIColor colorWithRed:83/255.0 green:108/255.0 blue:185/255.0 alpha:1] forState:UIControlStateHighlighted];
    
    rightButton.titleLabel.font =  [UIFont systemFontOfSize:16.0f weight:UIFontWeightMedium];
    // 设置title
    [rightButton setTitle:name forState:UIControlStateNormal];
    [rightButton setTitle:name forState:UIControlStateHighlighted];
    
    
    rightButton.titleLabel.backgroundColor = [UIColor clearColor];
    rightButton.imageView.backgroundColor = [UIColor clearColor];
    
    UIImage *image = [UIImage imageNamed:@"mizhu_downIcon"];
    
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, rightButton.titleLabel.bounds.size.width, 0, -rightButton.titleLabel.bounds.size.width)];
    
    [rightButton setImage:image forState:UIControlStateNormal];
    [rightButton setImage:image forState:UIControlStateSelected];
    
    [rightButton addTarget:self action:@selector(selectLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    //UINavigationItem *navigatorItem = [TTNavigator navigator].visibleViewController.navigationItem;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    if(([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)){//边距调整 kate
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        /**
         *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
         *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
         */
        //        negativeSpacer.width = -15;
        negativeSpacer.width = 0;
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightBarButton, nil];
    }else{
        self.navigationItem.leftBarButtonItem = rightBarButton;
    }
}

-(void)hideLeftButton {
    //    [self.navigationItem.rightBarButtonItems setValue:nil forKey:nil];
}




#pragma mark -
#pragma mark RightButton
-(void)setCustomizeRightButton
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    rightButton.frame = CGRectMake(0, 0, 33, 33);
    [rightButton setImage:[UIImage imageNamed:@"navicons_21"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"navicons_21"] forState:UIControlStateSelected];
    [rightButton addTarget:self action:@selector(selectRightAction:) forControlEvents:UIControlEventTouchUpInside];
    //UINavigationItem *navigatorItem = [TTNavigator navigator].visibleViewController.navigationItem;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    //self.navigationItem.rightBarButtonItem = rightBarButton;
    
    if(([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)){//边距调整 kate
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        /**
         *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
         *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
         */
        //        negativeSpacer.width = -10;
        negativeSpacer.width = -2;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightBarButton, nil];
    }else{
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }
    
}

-(void)setCustomizeRightButtonWithName:(NSString*)name
{
    [self setCustomizeRightButtonWithName:name
                                    color:[UIColor colorWithRed:91/255.0 green:141/255.0 blue:255/255.0 alpha:1]
                                     font:[UIFont systemFontOfSize:16.f weight:UIFontWeightMedium]
                                    width:44.0];
}

-(void)setCustomizeRightButtonWithName:(NSString*)name font:(UIFont*)font
{
    [self setCustomizeRightButtonWithName:name
                                    color:[UIColor colorWithRed:91/255.0 green:141/255.0 blue:255/255.0 alpha:1]
                                     font:font
                                    width:44.0];
}

-(void)setCustomizeRightButtonWithName:(NSString*)name color:(UIColor *)color
{
    [self setCustomizeRightButtonWithName:name
                                    color:color
                                     font:[UIFont systemFontOfSize:16.f weight:UIFontWeightMedium]
                                    width:44.0];
}

-(void)setCustomizeRightButtonWithName:(NSString*)name color:(UIColor *)color width:(CGFloat)width
{
    [self setCustomizeRightButtonWithName:name
                                    color:color
                                     font:[UIFont systemFontOfSize:16.f weight:UIFontWeightMedium]
                                    width:width];
}

-(void)setCustomizeRightButtonWithName:(NSString*)name color:(UIColor *)color font:(UIFont *)fontT width:(CGFloat)width
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    rightButton.frame = CGRectMake(0, 0, width, 24);
    rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightButton.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 10);
    
    //设置title自适应对齐
    rightButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [rightButton setTitleColor:color forState:UIControlStateNormal];
    
    [rightButton setTitleColor:[UIColor colorWithRed:83/255.0 green:108/255.0 blue:185/255.0 alpha:1] forState:UIControlStateHighlighted];
    
    rightButton.titleLabel.font = fontT;
    
    // 设置title
    [rightButton setTitle:name forState:UIControlStateNormal];
    [rightButton setTitle:name forState:UIControlStateHighlighted];
    //    [rightButton setImage:[UIImage imageNamed:fileName] forState:UIControlStateNormal];
    //    [rightButton setImage:[UIImage imageNamed:fileName] forState:UIControlStateSelected];
    [rightButton addTarget:self action:@selector(selectRightAction:) forControlEvents:UIControlEventTouchUpInside];
    //UINavigationItem *navigatorItem = [TTNavigator navigator].visibleViewController.navigationItem;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    if(([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)){//边距调整
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        /**
         *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
         *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
         */
        //        negativeSpacer.width = -15;
        negativeSpacer.width = -5;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightBarButton, nil];
    }else{
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }
    
}

-(void)setCustomizeRightButtonChoiceImage:(NSString*)imageName
{
    [self setCustomizeRightButtonChoiceImage:imageName selectedImg:imageName];
}

-(void)setCustomizeRightButtonChoiceImage:(NSString*)imageName selectedImg:(NSString *)selectedimageName
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    leftButton.frame = CGRectMake(8, 0, 33, 33);
    [leftButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:selectedimageName] forState:UIControlStateSelected];
    
    
    [leftButton addTarget:self action:@selector(selectRightAction:) forControlEvents:UIControlEventTouchUpInside];
    //UINavigationItem *navigatorItem = [TTNavigator navigator].visibleViewController.navigationItem;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    
    if(([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)){//边距调整 kate
        /** *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-15时，间距正好调整
         *  为10；width为正数时，正好相反，相当于往左移动width数值个像素
         */
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -10;  //  修改位置
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, leftBarButton, nil];
        
    }else{
        self.navigationItem.rightBarButtonItem = leftBarButton;
    }
    
}

-(void)setCustomizeRightButtonChoiceImageUrl:(NSString*)imageUrl placeholderImage:(NSString *)placeholderImage isRound:(BOOL)round
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    rightButton.frame = CGRectMake(0, 0, 33, 33);
    [rightButton setImage:[UIImage imageNamed:placeholderImage] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:placeholderImage] forState:UIControlStateSelected];
    
    
    UIButton *testBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [testBut setBackgroundColor:[UIColor clearColor]];
    testBut.frame = rightButton.frame;
    [rightButton addSubview:testBut];
    [testBut sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:placeholderImage]];
    if (round) {
        testBut.layer.masksToBounds = YES;
        testBut.layer.cornerRadius = CGRectGetHeight(testBut.frame)/2;
        testBut.backgroundColor = [UIColor clearColor];
    }
    
    rightButton.userInteractionEnabled = YES;
    //    [rightButton addTarget:self action:@selector(selectRightAction:) forControlEvents:UIControlEventTouchUpInside];
    [testBut addTarget:self action:@selector(selectRightAction:) forControlEvents:UIControlEventTouchUpInside];
    //UINavigationItem *navigatorItem = [TTNavigator navigator].visibleViewController.navigationItem;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    //self.navigationItem.rightBarButtonItem = rightBarButton;
    
    if(([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)){//边距调整 kate
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        /**
         *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
         *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
         */
        //        negativeSpacer.width = -10;
        negativeSpacer.width = -2;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightBarButton, nil];
    }else{
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }
    
}


/**
 *  三个图片按键
 */
-(void)setCustomizeRightButtonChoiceImage1:(NSString*)image1 image2:(NSString*)image2 image3:(NSString*)image3
{
    UIButton *leftButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton1 setBackgroundColor:[UIColor clearColor]];
    leftButton1.frame = CGRectMake(8, 0, 33, 33);
    [leftButton1 setImage:[UIImage imageNamed:image1] forState:UIControlStateNormal];
    [leftButton1 setImage:[UIImage imageNamed:image1] forState:UIControlStateSelected];
    [leftButton1 addTarget:self action:@selector(selectRightAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton1 = [[UIBarButtonItem alloc] initWithCustomView:leftButton1];
    
    UIButton *leftButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton2 setBackgroundColor:[UIColor clearColor]];
    leftButton2.frame = CGRectMake(8, 0, 33 + 60, 33);
    [leftButton2 setImage:[UIImage imageNamed:image2] forState:UIControlStateNormal];
    [leftButton2 setImage:[UIImage imageNamed:image2] forState:UIControlStateSelected];
    [leftButton2 setTitle:@"中间文字" forState:(UIControlStateNormal)];
    [leftButton2 setTitleColor:color_blue forState:(UIControlStateNormal)];
    leftButton2.titleLabel.font = FONT(15.f);
    [leftButton2 addTarget:self action:@selector(selectRightAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton2 = [[UIBarButtonItem alloc] initWithCustomView:leftButton2];
    
    
    UIButton *leftButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton3 setBackgroundColor:[UIColor clearColor]];
    leftButton3.frame = CGRectMake(8, 0, 33, 33);
    [leftButton3 setImage:[UIImage imageNamed:image1] forState:UIControlStateNormal];
    [leftButton3 setImage:[UIImage imageNamed:image1] forState:UIControlStateSelected];
    [leftButton3 addTarget:self action:@selector(selectRightAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton3 = [[UIBarButtonItem alloc] initWithCustomView:leftButton3];
    
    
    if(([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)){//边距调整 kate
        /** *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-15时，间距正好调整
         *  为10；width为正数时，正好相反，相当于往左移动width数值个像素
         */
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -10;  //  修改位置
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, leftBarButton1,leftBarButton2,leftBarButton3, nil];
        
    }else{
        self.navigationItem.rightBarButtonItems = @[leftBarButton1,leftBarButton2,leftBarButton3];
    }
}




//  是否支持屏幕旋转
- (BOOL)shouldAutorotate {
    return NO;
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

//一开始的方向  很重要
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//设置隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}



/**
 更新屏幕safearea frame  英语适配 iPhone X
 */
- (void)updateOrientation {
//    if (@available(iOS 11.0, *)) {
//        CGRect frame = self.customerView.frame;
//        frame.origin.x = self.view.safeAreaInsets.left;
//        frame.size.width = self.view.frame.size.width - self.view.safeAreaInsets.left - self.view.safeAreaInsets.right;
//        frame.size.height = self.view.frame.size.height - self.view.safeAreaInsets.bottom;
//        self.customerView.frame = frame;
//    } else {
//        // Fallback on earlier versions
//    }
}


@end
