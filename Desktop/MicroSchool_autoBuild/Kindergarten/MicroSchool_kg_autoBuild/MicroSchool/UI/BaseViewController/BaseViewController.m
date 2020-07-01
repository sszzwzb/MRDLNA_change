//
//  BaseViewController.m
//  AppTemplate
//
//  Created by Stephen Cheung on 13-8-7.
//  Copyright (c) 2013年 Stephen Cheung. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController (){
    UIButton *leftButton1;
    UIImageView *webBackImage;
    UIImageView *_headTouchImageView;
    UIImageView *thumbImageView;
    UIImageView *thumbImageViewMask;
    UIImageView *headDotImageView;

}

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //network = [NetworkUtility alloc];
   
    //2019.11.15 因 xcode11.2运行闪退注掉下面代码
//    imgView_leftLine =[[UIImageView alloc]initWithFrame:CGRectMake(57,4,2,35)];
//    [imgView_leftLine setImage:[UIImage imageNamed:@"title_line.png"]];
//    [imgView_leftLine setTag:999];
//
//    imgView_rightLine =[[UIImageView alloc]initWithFrame:CGRectMake(262,4,2,35)];
//    [imgView_rightLine setImage:[UIImage imageNamed:@"title_line.png"]];
//    [imgView_rightLine setTag:998];

    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    //[self.navigationController.navigationBar addSubview:imgView_bgImg];

    //[imgView_bgImg removeFromSuperview];
    
    
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    //适配iOS11的tableView问题
    [UITableView appearance].estimatedRowHeight = 0;
    [UITableView appearance].estimatedSectionHeaderHeight = 0;
    [UITableView appearance].estimatedSectionFooterHeight = 0;
    
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender
{
    //[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)selectRightAction:(id)sender
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
}

-(void)setCustomizeTitle:(NSString *)title
{
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(([Utilities getScreenSize].width -150.0)/2.0, 0, 150, 44)];
    usernameLabel.text=title;
    usernameLabel.textColor = [UIColor whiteColor];
    
    //设置Label背景透明
    usernameLabel.backgroundColor = [UIColor clearColor];
    
    //设置文本字体与大小
    usernameLabel.font = [UIFont boldSystemFontOfSize:17];
    
    //usernameLabel.adjustsFontSizeToFitWidth=YES;
    usernameLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = usernameLabel;
//#3.21导航颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"title_bgImage.png"] forBarMetrics:UIBarMetricsDefault];
}

-(void)setCustomizeBackgroundImg:(NSString *)path {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:path] forBarMetrics:UIBarMetricsDefault];

//    [self.navigationController.navigationBar setBackgroundColor:color];

}

-(void)setCustomizeTitle:(NSString *)title font:(UIFont*)font
{
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    usernameLabel.text=title;
    usernameLabel.textColor = [UIColor whiteColor];
    
    //设置Label背景透明
    usernameLabel.backgroundColor = [UIColor clearColor];
    usernameLabel.numberOfLines = 0;
    
    //设置文本字体与大小
    usernameLabel.font = font;
    
    //usernameLabel.adjustsFontSizeToFitWidth=YES;
    usernameLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = usernameLabel;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_img.png"] forBarMetrics:UIBarMetricsDefault];
}

-(void)setCustomizeLeftButton
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundColor:[UIColor clearColor]];
//    leftButton.frame = CGRectMake(0, 0, 33, 33);
//    [leftButton setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
//    [leftButton setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateSelected];
    leftButton.frame = CGRectMake(0, 0, 24, 24);
    [leftButton setImage:[UIImage imageNamed:@"leftBarButtonItem.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"leftBarButtonItem.png"] forState:UIControlStateSelected];
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
        negativeSpacer.width = -10;
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, leftBarButton, nil];

    }else{
       self.navigationItem.leftBarButtonItem = leftBarButton;
    }
    

}
//乐园页面webview二级页面调用此方法修改头像
-(void)setBackImage:(NSString *)imageName{
    thumbImageView.hidden = YES;
    headDotImageView.hidden = YES;
    webBackImage =[[UIImageView alloc] initWithFrame:CGRectMake(0, 5, [Utilities convertPixsW:30], [Utilities convertPixsH:30])];
    webBackImage.hidden = NO;
    
    [webBackImage setImage: [UIImage imageNamed:imageName]];
    webBackImage.contentMode = UIViewContentModeScaleAspectFill;
    webBackImage.layer.masksToBounds = YES;
    webBackImage.layer.cornerRadius = _headTouchImageView.frame.size.width/2;
       [thumbImageViewMask addSubview:webBackImage];
    [thumbImageViewMask setBackgroundColor: [UIColor clearColor]];

}
-(void)setCustomizeLeftButtonWithImage:(NSString*)imageName {
    
    leftButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton1 setBackgroundColor:[UIColor clearColor]];
    leftButton1.frame = CGRectMake(20, 0, 24, 24);
    
    
    
#if 0
    _headTouchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [Utilities convertPixsW:34], [Utilities convertPixsH:34])];
    _headTouchImageView.contentMode = UIViewContentModeScaleAspectFill;
//    _headTouchImageView.clipsToBounds = YES;
//    _headTouchImageView.userInteractionEnabled = YES;
//    _headTouchImageView.isShowBgImg = YES;
    _headTouchImageView.layer.masksToBounds = YES;
    _headTouchImageView.layer.cornerRadius = _headTouchImageView.frame.size.width/2;
    [_headTouchImageView setImage:[UIImage imageNamed:@"loading_gray.png"]];
//    [_headTouchImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    
    [leftButton addSubview:_headTouchImageView];
#endif
//#3.22
    NSDictionary *userDetailDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDetailInfo"];
    NSMutableDictionary *uD = [NSMutableDictionary dictionaryWithDictionary:userDetailDic];

    leftButton1.contentMode = UIViewContentModeScaleAspectFill;
    leftButton1.layer.masksToBounds = YES;
    leftButton1.layer.cornerRadius = leftButton1.frame.size.width/2;

    
    

    
    
    
    
    thumbImageView = [[UIImageView alloc]initWithFrame:CGRectMake(1, 1, 33, 33)];
    thumbImageView.hidden = NO;
    webBackImage.hidden = YES;
    [thumbImageView sd_setImageWithURL:[NSURL URLWithString:[uD objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];
    thumbImageView.layer.masksToBounds = YES;
    thumbImageView.layer.cornerRadius = thumbImageView.frame.size.width/2;
    
    thumbImageViewMask = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 35, 35)];
    thumbImageViewMask.layer.masksToBounds = YES;
    thumbImageViewMask.layer.cornerRadius = thumbImageView.frame.size.width/2;
    thumbImageViewMask.backgroundColor = [UIColor whiteColor];
    [thumbImageViewMask addSubview:thumbImageView];
    
    
                                                                           

    
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 54, 44)];
//    bgImageView.backgroundColor = [UIColor redColor];
    [bgImageView addSubview:thumbImageViewMask];
    
    
    
    headDotImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 12, 5, 19)];
    [headDotImageView setImage:[UIImage imageNamed:@"SchoolHomePics/schoolHomeHeadLeftDot"]];
    headDotImageView.hidden = NO;
    [bgImageView addSubview:headDotImageView];

    
    _redPointOnNavigationBar = [[UIImageView alloc]initWithFrame:CGRectMake(35, 5, 10, 10)];
    _redPointOnNavigationBar.image = [UIImage imageNamed:@"icon_new"];
    _redPointOnNavigationBar.hidden = YES;
    [bgImageView addSubview:_redPointOnNavigationBar];

    
    TSTapGestureRecognizer *myTapGesture7 = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(selectLeftAction:)];
    myTapGesture7.infoStr = @"0";
    [bgImageView addGestureRecognizer:myTapGesture7];

    
    
//    [leftButton sd_setImageWithURL:[NSURL URLWithString:[uD objectForKey:@"avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
//    [leftButton sd_setImageWithURL:[NSURL URLWithString:[uD objectForKey:@"avatar"]] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];

//    [leftButton setImage:[UIImage imageNamed:@"leftBarButtonItem.png"] forState:UIControlStateSelected];
    [leftButton1 addTarget:self action:@selector(selectLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    //UINavigationItem *navigatorItem = [TTNavigator navigator].visibleViewController.navigationItem;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:bgImageView];
    
    
    if(([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)){//边距调整 kate
        /** *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-15时，间距正好调整
         *  为10；width为正数时，正好相反，相当于往左移动width数值个像素
         */
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -16;
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, leftBarButton, nil];
        
    }else{
        self.navigationItem.leftBarButtonItem = leftBarButton;
    }
}

-(void)setRedPointHidden:(BOOL)isHidden {
    _redPointOnNavigationBar.hidden = isHidden;
}

-(void)setCustomizeRightButton
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    rightButton.frame = CGRectMake(0, 0, 33, 33);
    [rightButton setImage:[UIImage imageNamed:@"btn_setting.png"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"btn_setting.png"] forState:UIControlStateSelected];
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
        negativeSpacer.width = -10;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightBarButton, nil];
    }else{
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }

}

-(void)setCustomizeRightButton:(NSString*)fileName
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    //rightButton.frame = CGRectMake(0, 0, 33, 33);
    rightButton.frame = CGRectMake(0, 0, 24, 24);
    [rightButton setImage:[UIImage imageNamed:fileName] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:fileName] forState:UIControlStateSelected];
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
        negativeSpacer.width = -10;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightBarButton, nil];
    }else{
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }

}

-(void)setCustomizeRightButtonWithName:(NSString*)name
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    rightButton.frame = CGRectMake(0, 0, 44, 24);
    rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //设置title自适应对齐
    rightButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    //rightButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];

    // 设置title
    [rightButton setTitle:name forState:UIControlStateNormal];
    [rightButton setTitle:name forState:UIControlStateHighlighted];
//    [rightButton setImage:[UIImage imageNamed:fileName] forState:UIControlStateNormal];
//    [rightButton setImage:[UIImage imageNamed:fileName] forState:UIControlStateSelected];
    [rightButton addTarget:self action:@selector(selectRightAction:) forControlEvents:UIControlEventTouchUpInside];
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
    negativeSpacer.width = -15;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightBarButton, nil];
    }else{
           self.navigationItem.rightBarButtonItem = rightBarButton;
    }

}

-(void)setCustomizeLeftButtonWithName:(NSString*)name
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    rightButton.frame = CGRectMake(0, 0, 44, 24);
    rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //设置title自适应对齐
    rightButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    //rightButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    
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
        negativeSpacer.width = -15;
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightBarButton, nil];
    }else{
        self.navigationItem.leftBarButtonItem = rightBarButton;
    }
    
}

-(void)setCustomizeRightButtonWithName:(NSString*)name color:(UIColor *)color
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    rightButton.frame = CGRectMake(0, 0, 44, 24);
    rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightButton.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 10);

    //设置title自适应对齐
    rightButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [rightButton setTitleColor:color forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    //rightButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    
    // 设置title
    [rightButton setTitle:name forState:UIControlStateNormal];
    [rightButton setTitle:name forState:UIControlStateHighlighted];
    //    [rightButton setImage:[UIImage imageNamed:fileName] forState:UIControlStateNormal];
    //    [rightButton setImage:[UIImage imageNamed:fileName] forState:UIControlStateSelected];
    [rightButton addTarget:self action:@selector(selectRightAction:) forControlEvents:UIControlEventTouchUpInside];
    //UINavigationItem *navigatorItem = [TTNavigator navigator].visibleViewController.navigationItem;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
#if 9
    if(([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)){//边距调整 kate
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        /**
         *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
         *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
         */
        negativeSpacer.width = -15;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightBarButton, nil];
    }else{
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }
#endif
}

//Chenth 12.22 对应春晖提的 当创建(22)此时要一行
-(void)setCustomizeLongRightButtonWithName:(NSString*)name color:(UIColor *)color
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    rightButton.frame = CGRectMake(0, 0, 84, 24);
    rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightButton.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 10);
    
    //设置title自适应对齐
    rightButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [rightButton setTitleColor:color forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    //rightButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    
    // 设置title
    [rightButton setTitle:name forState:UIControlStateNormal];
    [rightButton setTitle:name forState:UIControlStateHighlighted];
    //    [rightButton setImage:[UIImage imageNamed:fileName] forState:UIControlStateNormal];
    //    [rightButton setImage:[UIImage imageNamed:fileName] forState:UIControlStateSelected];
    [rightButton addTarget:self action:@selector(selectRightAction:) forControlEvents:UIControlEventTouchUpInside];
    //UINavigationItem *navigatorItem = [TTNavigator navigator].visibleViewController.navigationItem;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
#if 9
    if(([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)){//边距调整 kate
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        /**
         *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
         *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
         */
        negativeSpacer.width = -15;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightBarButton, nil];
    }else{
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }
#endif
}
// add by kate 2015.05.28
-(void)setCustomizeRightButtonWithName:(NSString*)name font:(UIFont*)font
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    if ([name length] > 5) {
        rightButton.frame = CGRectMake(0, 0, 65, 24);
    }else{
       rightButton.frame = CGRectMake(0, 0, 48, 24);
       
    }

    
    //设置title自适应对齐
    rightButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    rightButton.titleLabel.font = font;
    rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    
    // 设置title
    [rightButton setTitle:name forState:UIControlStateNormal];
    [rightButton setTitle:name forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(selectRightAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    if(([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)){//边距调整 kate
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        /**
         *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
         *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
         */
        negativeSpacer.width = -15;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightBarButton, nil];
    }else{
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }

    
}



// 切换页面时候，可以关闭软键盘
- (void)hideKeyBoard
{
    for (UIWindow* window in [UIApplication sharedApplication].windows)
    {
        for (UIView* view in window.subviews)
        {
            [self dismissAllKeyBoardInView:view];
        }
    }
}

-(BOOL) dismissAllKeyBoardInView:(UIView *)view
{
    if([view isFirstResponder])
    {
        [view resignFirstResponder];
        return YES;
    }
    for(UIView *subView in view.subviews)
    {
        if([self dismissAllKeyBoardInView:subView])
        {
            return YES;
        }
    }
    return NO;
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)forbiddenLeftAndRightKey
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
}

-(void)enableLeftAndRightKey
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.leftBarButtonItem.enabled = YES;
}

-(void)showLeftLine
{
    
}

-(void)hideLeftLine
{
    for(id tmpView in [self.navigationController.navigationBar subviews])
    {
        UIImageView *imgView = (UIImageView *)tmpView;
        if (imgView.tag == 999) {
            [imgView removeFromSuperview];
        }
    }
}

-(void)hideLeftAndRightLine
{
    for(id tmpView in [self.navigationController.navigationBar subviews])
    {
        UIImageView *imgView = (UIImageView *)tmpView;
        if (imgView.tag == 999) {
            [imgView removeFromSuperview];
        }
        
        if (imgView.tag == 998) {
            [imgView removeFromSuperview];
        }
    }
}


@end