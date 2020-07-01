//
//  SetHeadImgViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-1-10.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "SetHeadImgViewController.h"
//---add by kate----------------------------------------
#import "GlobalSingletonUserInfo.h"
#import "MomentsViewController.h"
#import "MicroSchoolMainMenuViewController.h"
#import "MyInfoCenterViewController.h"
#import "ClassDetailViewController.h"
#import "MyClassListViewController.h"
#import "MicroSchoolAppDelegate.h"
#import "MomentsEntranceTableViewController.h"
#import "SchoolListForBureauViewController.h"
#import "LeftViewController.h"
#import "WWSideslipViewController.h"
//#import "MomentsEntranceForTeacherController.h"
//--------------------------------------------

@interface SetHeadImgViewController ()

@end

@implementation SetHeadImgViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        network = [NetworkUtility alloc];
        network.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [super setCustomizeTitle:@"设置头像"];
    [self.navigationItem setHidesBackButton:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super hideLeftAndRightLine];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 修改从UIImagePickerController 返回后statusbar消失问题
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    }
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    
    // 背景图片
    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height)];
    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    [self.view addSubview:imgView_bgImg];
    
    // 设置背景scrollView
    UIScrollView* scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH , [UIScreen mainScreen].applicationFrame.size.height - 44)];
    scrollerView.contentSize = CGSizeMake(WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44);
    scrollerView.scrollEnabled = YES;
    scrollerView.delegate = self;
    scrollerView.bounces = YES;
    scrollerView.alwaysBounceHorizontal = NO;
    scrollerView.alwaysBounceVertical = YES;
    scrollerView.directionalLockEnabled = YES;
    [self.view addSubview:scrollerView];
    
    _imgView_HeadImg =[[UIImageView alloc]initWithFrame:CGRectMake((WIDTH-100)/2,30,100,100)];
    _imgView_HeadImg.layer.masksToBounds = YES;
    _imgView_HeadImg.layer.cornerRadius = 100/2;
    _imgView_HeadImg.image=[UIImage imageNamed:@"icon_avatar_big.png"];
    [scrollerView addSubview:_imgView_HeadImg];

    // 文字信息
    UILabel *label_photo = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                     _imgView_HeadImg.frame.origin.y + _imgView_HeadImg.frame.size.height + 30,
                                                                     WIDTH-40, 20)];
    label_photo.lineBreakMode = NSLineBreakByWordWrapping;
    label_photo.text = @"请设置头像，方便朋友认出你。";
    label_photo.font = [UIFont systemFontOfSize:16.0f];
    label_photo.numberOfLines = 0;
    label_photo.textColor = [UIColor grayColor];
    label_photo.backgroundColor = [UIColor clearColor];
    label_photo.lineBreakMode = NSLineBreakByTruncatingTail;
    [scrollerView addSubview:label_photo];

    // 去照相机button
    UIButton *button_take = [UIButton buttonWithType:UIButtonTypeCustom];
    button_take.frame = CGRectMake(
                                     20,
                                     label_photo.frame.origin.y + label_photo.frame.size.height + 30,
                                     130,
                                     40);
    button_take.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置title自适应对齐
    button_take.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [button_take setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button_take setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button_take.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [button_take setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal] ;
    [button_take setBackgroundImage:[UIImage imageNamed:@"btn_common_1_p.png"] forState:UIControlStateHighlighted] ;
    
    // 添加 action
    [button_take addTarget:self action:@selector(take_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    
    //设置title
    [button_take setTitle:@"相机拍照" forState:UIControlStateNormal];
    [button_take setTitle:@"相机拍照" forState:UIControlStateHighlighted];
    //[button_create setUserInteractionEnabled:NO];
    
    [scrollerView addSubview:button_take];

    // 去图库button
    UIButton *button_lib = [UIButton buttonWithType:UIButtonTypeCustom];
    button_lib.frame = CGRectMake(
                                   170,
                                   label_photo.frame.origin.y + label_photo.frame.size.height + 30,
                                   130,
                                   40);
    button_lib.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置title自适应对齐
    button_lib.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [button_lib setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button_lib setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button_lib.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [button_lib setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal] ;
    [button_lib setBackgroundImage:[UIImage imageNamed:@"btn_common_1_p.png"] forState:UIControlStateHighlighted] ;
    
    // 添加 action
    [button_lib addTarget:self action:@selector(lib_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    
    //设置title
    [button_lib setTitle:@"手机相册" forState:UIControlStateNormal];
    [button_lib setTitle:@"手机相册" forState:UIControlStateHighlighted];
    
    [scrollerView addSubview:button_lib];
    
    // 确定button
    UIButton *button_create = [UIButton buttonWithType:UIButtonTypeCustom];
        button_create.frame = CGRectMake(button_take.frame.origin.x,
                                         button_take.frame.origin.y + button_take.frame.size.height + 20, 280, 40);
    
    button_create.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置title自适应对齐
    button_create.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [button_create setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button_create setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button_create.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    //button.backgroundColor = [UIColor clearColor];
    
    //UIImage* myImage = [[UIImage alloc]initWithContentsOfFile:[NSString stringWithFormat:@"btn_blue_nor@2x.png"]];
    [button_create setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal] ;
    [button_create setBackgroundImage:[UIImage imageNamed:@"btn_common__1_p.png"] forState:UIControlStateHighlighted] ;
    
    // 添加 action
    [button_create addTarget:self action:@selector(done_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    
    //设置title
    [button_create setTitle:@"完成" forState:UIControlStateNormal];
    [button_create setTitle:@"完成" forState:UIControlStateHighlighted];
    
    [scrollerView addSubview:button_create];

    // 确定button
    UIButton *button_tiaoguo = [UIButton buttonWithType:UIButtonTypeCustom];
    button_tiaoguo.frame = CGRectMake(0,
                                     button_create.frame.origin.y + button_create.frame.size.height + 10, WIDTH, 40);
    
    button_tiaoguo.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置title自适应对齐
    button_tiaoguo.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [button_tiaoguo setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button_tiaoguo setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    button_tiaoguo.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    //button.backgroundColor = [UIColor clearColor];
    
    //UIImage* myImage = [[UIImage alloc]initWithContentsOfFile:[NSString stringWithFormat:@"btn_blue_nor@2x.png"]];
//    [button_tiaoguo setBackgroundImage:[UIImage imageNamed:@"btn_common_2-d.png"] forState:UIControlStateNormal] ;
//    [button_tiaoguo setBackgroundImage:[UIImage imageNamed:@"btn_common_2_p.png"] forState:UIControlStateHighlighted] ;
    
    // 添加 action
    [button_tiaoguo addTarget:self action:@selector(tiaoguo_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    
    //设置title
    [button_tiaoguo setTitle:@"暂不设置头像" forState:UIControlStateNormal];
    [button_tiaoguo setTitle:@"暂不设置头像" forState:UIControlStateHighlighted];
    
    [scrollerView addSubview:button_tiaoguo];
}

#pragma Delegate method UIImagePickerControllerDelegate
//图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{

    //当图片不为空时显示图片并保存图片
    if (image != nil) {
        [_imgView_HeadImg setImage:image];

        //        image_head_pre = image;
        UIImage *scaledImage;
        UIImage *updateImage;
        
        CGSize imageSize = image.size;
        
        // 如果宽度超过800，则按照比例进行缩放，把宽度固定在800
        if (image.size.width >= 800) {
            float scaleRate = 800/image.size.width;
            
            float w = 800;
            float h = image.size.height * scaleRate;
            
            scaledImage = [Utilities imageWithImageSimple:image scaledToSize:CGSizeMake(w, h)];
        }
        
        if (scaledImage != Nil) {
            updateImage = scaledImage;
        } else {
            updateImage = image;
        }
        
        CGSize imageSize1 = updateImage.size;
        
//        photo = updateImage;
        
        //        [button_photoMask setBackgroundImage:image forState:UIControlStateNormal] ;
        //        [button_photoMask setBackgroundImage:image forState:UIControlStateHighlighted] ;
        
        //获取Documents文件夹目录
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [path objectAtIndex:0];
        //指定新建文件夹路径
        NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"ImageFile"];
        //创建ImageFile文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
        //保存图片的路径
        self->imagePath1 = [imageDocPath stringByAppendingPathComponent:@"image.png"];
        
#if 1
        //以下是保存文件到沙盒路径下
        //把图片转成NSData类型的数据来保存文件
        NSData *data;
//        //判断图片是不是png格式的文件
//        if (UIImagePNGRepresentation(updateImage)) {
//            //返回为png图像。
//            data = UIImagePNGRepresentation(updateImage);
//        }else {
            //返回为JPEG图像。
            data = UIImageJPEGRepresentation(updateImage, 0.3);
//        }
#else
        NSData *data;
        data = UIImageJPEGRepresentation(updateImage, 0.75);
#endif

        //保存
        [[NSFileManager defaultManager] createFileAtPath:self->imagePath1 contents:data attributes:nil];
        
        //        [self doUpdateAvatar];
    }
    //关闭相册界面
    [picker dismissModalViewControllerAnimated:YES];
}

- (IBAction)lib_btnclick:(id)sender
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentModalViewController:picker animated:YES];
}

- (IBAction)take_btnclick:(id)sender
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentModalViewController:picker animated:YES];
}

-(void) doUpdateAvatar
{
    if (nil == self->imagePath1) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"请重新选择图片。"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [Utilities showProcessingHud:self.view];
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Avatar",@"ac",
                              @"2",@"v",
                              @"upload", @"op",
                              self->imagePath1, @"avatar",
                              nil];

        network.delegate = self;
        [network sendHttpReq:HttpReq_Avatar andData:data];
    }
}

- (IBAction)done_btnclick:(id)sender
{
    [self doUpdateAvatar];
}

- (IBAction)tiaoguo_btnclick:(id)sender
{
    //忽略设置个人头像
    [ReportObject event:ID_FIRST_JUMP_AVATAR];//2015.06.23
    
    // 登陆成功将单例中的标志设置为1，下次进入app就不会显示guide
    GlobalSingletonUserInfo* g_userLoginIndex = GlobalSingletonUserInfo.sharedGlobalSingleton;
    [g_userLoginIndex setLoginIndex:(NSInteger*)1];
    
   /*---update by kate 2014.12.26---------------------------------------
    // 到下一画面
    MicroSchoolMainMenuViewController *mainMenuViewCtrl = [[MicroSchoolMainMenuViewController alloc] init];
    
    MicroSchoolMainMenuNaviViewController *navigation = [[MicroSchoolMainMenuNaviViewController alloc] init];
    [navigation initWithRootViewController:mainMenuViewCtrl];
    
    //[navigation pushViewController:signUp animated:YES];
    [self presentViewController:navigation animated:YES completion:nil];*/
//    [[NSUserDefaults standardUserDefaults]setObject:@"setHeadImg" forKey:@"fromNameToHome"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
    [self initTabBarController];
    //-----------------------------------------------------------------------------
    // update 2015.10.21 教育服务发布商品 不能进入相册问题 原因是controller不在window上
    //                        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    //                        [self presentViewController:appDelegate.tabBarController animated:NO completion:nil];
    
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    LeftViewController * leftController = [[LeftViewController alloc] init];
    WWSideslipViewController * wwsideslioController = [[WWSideslipViewController alloc] initWithLeftView:leftController andMainView:appDelegate.tabBarController andBackgroundImage:[UIImage imageNamed:@""]];
    appDelegate.window.rootViewController = wwsideslioController;
    //-------------------------------------------------------------------------------
    //---------------------------------------------------------------------
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    [Utilities dismissProcessingHud:self.view];
    
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];

    if ([@"AvatarAction.upload"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
        if(true == [result intValue])
        {
            // 登陆成功将单例中的标志设置为1，下次进入app就不会显示guide
            GlobalSingletonUserInfo* g_userLoginIndex = GlobalSingletonUserInfo.sharedGlobalSingleton;
            [g_userLoginIndex setLoginIndex:(NSInteger*)1];
            
            // 设置个人头像
            [ReportObject event:ID_FIRST_SET_AVATAR];//2015.06.23

           //----update by kate-----------------------------------
            // 到下一画面
           /* MicroSchoolMainMenuViewController *mainMenuViewCtrl = [[MicroSchoolMainMenuViewController alloc] init];

            MicroSchoolMainMenuNaviViewController *navigation = [[MicroSchoolMainMenuNaviViewController alloc] init];
            [navigation initWithRootViewController:mainMenuViewCtrl];
            
            //[navigation pushViewController:signUp animated:YES];
            [self presentViewController:navigation animated:YES completion:nil];*/
//             [[NSUserDefaults standardUserDefaults]setObject:@"setHeadImg" forKey:@"fromNameToHome"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
            [self initTabBarController];// add by kate
            //-----------------------------------------------------------------------------
            // update 2015.10.21 教育服务发布商品 不能进入相册问题 原因是controller不在window上
            //                        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
            //                        [self presentViewController:appDelegate.tabBarController animated:NO completion:nil];
            
            MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
            LeftViewController * leftController = [[LeftViewController alloc] init];
            WWSideslipViewController * wwsideslioController = [[WWSideslipViewController alloc] initWithLeftView:leftController andMainView:appDelegate.tabBarController andBackgroundImage:[UIImage imageNamed:@""]];
            appDelegate.window.rootViewController = wwsideslioController;
            
            //-------------------------------------------------------------------------------
            //-------------------------------------------------------

//            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"成功"
//                                                           message:@"头像上传成功"
//                                                          delegate:nil
//                                                 cancelButtonTitle:@"确定"
//                                                 otherButtonTitles:nil];
//            [alert show];
            
//            [[SDImageCache sharedImageCache] clearDisk];
//            [[SDImageCache sharedImageCache] clearMemory];
//            
//            image_head = image_head_pre;
//            [self->_tableView reloadData];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"失败"
                                                           message:@"头像上传失败"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)reciveHttpDataError:(NSError*)err
{
    [Utilities dismissProcessingHud:self.view];
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                   message:@"网络连接错误，请稍候再试"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    [alert show];
}

/*
 * 自定义tabbar add by kate
 */
- (void)initTabBarController
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (!appDelegate.tabBarController) {
        
        [appDelegate bindBaiduPush];//只有在进入主页后收到推送才显示 志伟确认 2015.12.09
        // 校园
        MicroSchoolMainMenuViewController *content = [[MicroSchoolMainMenuViewController alloc] init];
        // 班级
//        NSDictionary *userD = [g_userInfo
//                               getUserDetailInfo];
//        
//        // 数据部分
//        if (nil == userD) {
//            userD = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDetailInfo"];
//        }
//        
//        NSString *usertype = [NSString stringWithFormat:@"%@",[userD objectForKey:@"role_id"]];
        
        NSString *cid = @"0";
        
        ClassDetailViewController *customization = [[ClassDetailViewController alloc] init];
        customization.fromName = @"tab";
        
        MyClassListViewController *classV = [[MyClassListViewController alloc]init];
        
        //----update by kate 2015.02.03-------------------------------------
        // 动态
        //        MomentsViewController *commentList  = [[MomentsViewController alloc]init];
        //        commentList.titleName = @"发现";
        //        commentList.fromName = @"school";
        //        commentList.cid = @"0";
        
        MomentsEntranceTableViewController *commentList = [[MomentsEntranceTableViewController alloc]init];
        commentList.titleName = @"发现";
        //--------------------------------------------------------------
        
#if 0
        MomentsEntranceForTeacherController *commentListForTeacher = [[MomentsEntranceTableViewController alloc]init];
        commentListForTeacher.titleName = @"发现";
        
#endif
        
        //------------------------- add by kate 2015.05.21---------------------------------
        SchoolListForBureauViewController *schoolListBureau;
        NSString *schoolType = [[NSUserDefaults standardUserDefaults]objectForKey:@"schoolType"];//add 2015.05.11
        if ([@"bureau" isEqualToString:schoolType]){
            
            schoolListBureau = [[SchoolListForBureauViewController alloc]init];
            
        }
        //-------------------------------------------------------------------------------------
        
        // 我
        MyInfoCenterViewController *myView = [[MyInfoCenterViewController alloc] init];
        
        //隐藏tabbar所留下的黑边（试着注释后你会知道这个的作用）
        content.hidesBottomBarWhenPushed = YES;
        customization.hidesBottomBarWhenPushed = YES;
        classV.hidesBottomBarWhenPushed = YES;
        commentList.hidesBottomBarWhenPushed = YES;
        myView.hidesBottomBarWhenPushed = YES;
        schoolListBureau.hidesBottomBarWhenPushed = YES;//add by kate 2015.05.21
        content.title = @"校园";
        customization.title = @"班级";
        commentList.title = @"发现";
        myView.title = @"我";
        schoolListBureau.title = @"下属单位";//add by kate 2015.05.21
        
         UINavigationController *schoolListBureauNavi = [[UINavigationController alloc] initWithRootViewController:schoolListBureau];// add by kate 2015.05.21
        
        UINavigationController *contentNavi = [[UINavigationController alloc] initWithRootViewController:content];
        
        //-------------------------------------------
         UINavigationController *customizationNavi = [[UINavigationController alloc] initWithRootViewController:classV];
        customization.cId = cid;
        //---------------------------------------------
        
        customizationNavi = [[UINavigationController alloc] initWithRootViewController:classV];
        customization.cId = @"0";

        UINavigationController *storeListNavi = [[UINavigationController alloc]initWithRootViewController:commentList];
        
     
       UINavigationController *myNavi = [[UINavigationController alloc] initWithRootViewController:myView];
        
        
        //----------update by kate 2015.05.21-----------------------------------------------------------------
        
        NSArray *controllers;
        
        /*2015.10.29 教育局改版 恢复班级功能
        if ([@"bureau" isEqualToString:schoolType]){
            
            controllers = [NSArray arrayWithObjects:contentNavi, schoolListBureauNavi,storeListNavi,myNavi, nil];
            
        }else{*/
             controllers = [NSArray arrayWithObjects:contentNavi, customizationNavi,storeListNavi,myNavi, nil];
            
        //}
        
       //-------------------------------------------------------------------------------------------------------
        
        
        //设置tabbar的控制器
        MyTabBarController *tabBar = [[MyTabBarController alloc] initWithSelectIndex:0];
        tabBar.viewControllers = controllers;
        tabBar.selectedIndex = 0;
        appDelegate.tabBarController = tabBar;
        
    }
    
    [appDelegate.tabBarController selectedTab:[[appDelegate.tabBarController buttons] objectAtIndex:0]];
    UINavigationController *tabBarControllerNavi = (UINavigationController *)self.tabBarController.selectedViewController;
    [tabBarControllerNavi popToRootViewControllerAnimated:NO];
    
    appDelegate.tabBarController.view.frame = [[UIScreen mainScreen] bounds];
    
    
    //    [self.window setRootViewController:self.tabBarController];
    //    [self.window bringSubviewToFront:self.tabBarController.view];
    
}

//// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return YES;
}
////
//// 是否支持横竖屏显示
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
