//
//  MsgZoomImageViewController.m
//  ShenMaSale
//
//  Created by kakashi on 14-1-16.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import "MsgZoomImageViewController.h"
#import "PublicConstant.h"
#import "ImageResourceLoader.h"
#import "PublicConstant.h"
#import "FRNetPoolUtils.h"
//#import "CommonUtil.h"
#import "Toast+UIView.h"
#import "MBProgressHUD+Add.h"

@interface MsgZoomImageViewController ()

//从本地拉取大图
- (void)getPicForPath:(NSString *)imagePathForZoom;

// 从服务器拉大图
- (void)getPicFromServer;

@end

@implementation MsgZoomImageViewController

@synthesize _shouldGetPic;
@synthesize nowChat;
@synthesize picImage;
@synthesize scrollViewForPic;
@synthesize imagePath;
@synthesize imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.title = @"预览图片";
    
    
//    UIBarButtonItem *left = [CommonUtil customerLeftItem:@"聊天" target:self action:@selector(back:)];
//    if (left) {
//        self.navigationItem.leftBarButtonItem = left;
//    }
    
    //[super setCustomizeTitle:@"预览图片"];
    //[super setCustomizeLeftButton];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
    
    maxHeight = [[UIScreen mainScreen] bounds].size.height;
    
    self.view.backgroundColor = [UIColor blackColor];
    if (!_shouldGetPic) {
        [self getPicForPath:imagePath];
    } else {
        [self getPicFromServer];
    }
    
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickDismiss:)];
    [self.view addGestureRecognizer:singleTouch];
    
}

-(void)clickDismiss:(id)sender{
    
    [self selectLeftAction:nil];
    
}

-(void)selectLeftAction:(id)sender
{
    // 取消所有的网络请求
    [network cancelCurrentRequest];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [network cancelCurrentRequest];
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navigationController.navigationBarHidden = NO;
    

}

/*- (void)dealloc
{
    self.picImage = nil;
    
    if (scrollViewForPic) {
        [scrollViewForPic release];
    }
    scrollViewForPic = nil;
    
    if (imageView) {
        [imageView release];
    }
    imageView = nil;
    
    if (imagePath) {
        [imagePath release];
    }
    imagePath = nil;
    
    [nowChat release];
    nowChat = nil;
    
    [super dealloc];
}*/

//从本地拉取大图
- (void)getPicForPath:(NSString *)imagePathForZoom
{

    [Utilities showProcessingHud:self.view];
    self.picImage = [UIImage imageWithContentsOfFile:imagePathForZoom];
    
    scrollViewForPic = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, WIDTH, maxHeight)];
    [scrollViewForPic setBackgroundColor:[UIColor blackColor]];
    
    imageView = [[UIImageView alloc] initWithImage:picImage];
    
    CGFloat redius;
    if (picImage.size.height > maxHeight || picImage.size.width > 320) {
        if ((picImage.size.width / 320) < (picImage.size.height / maxHeight)) {
            redius = maxHeight / picImage.size.height;
        } else {
            redius = 320 / picImage.size.width;
        } 
    } else {
        redius = 1.0;
    } 
    [scrollViewForPic setDelegate:self];
    [scrollViewForPic setMaximumZoomScale:2.0];
    [scrollViewForPic setContentSize:picImage.size];
    [scrollViewForPic setMinimumZoomScale:redius];
    [scrollViewForPic setZoomScale:[scrollViewForPic minimumZoomScale]];
    [scrollViewForPic addSubview:imageView];
    scrollViewForPic.showsVerticalScrollIndicator = NO;
    scrollViewForPic.showsHorizontalScrollIndicator = NO;
    scrollViewForPic.exclusiveTouch = YES;
    [self.view addSubview:scrollViewForPic];
    
    CGFloat offsetX = (scrollViewForPic.bounds.size.width > scrollViewForPic.contentSize.width)?
    (scrollViewForPic.bounds.size.width - scrollViewForPic.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollViewForPic.bounds.size.height > scrollViewForPic.contentSize.height)?
    (scrollViewForPic.bounds.size.height - scrollViewForPic.contentSize.height) * 0.5 : 0.0;
    imageView.center = CGPointMake(scrollViewForPic.contentSize.width * 0.5 + offsetX,
                                   scrollViewForPic.contentSize.height * 0.5 + offsetY);
    
   
    [Utilities dismissProcessingHud:self.view];
    [self showRightButton];
    
}

// 从服务器拉大图
- (void)getPicFromServer
{
    if ([nowChat.pic_url_original length] > 0) {
//        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        HUD.labelText = @"下载中...";
//        HUD.minShowTime = 0.6f;
        
      
        [Utilities showProcessingHud:self.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            BOOL isGetPic = [FRNetPoolUtils getPicWithUrl:nowChat.pic_url_original picType:PIC_TYPE_ORIGINAL userid:nowChat.user_id msgid:nowChat.msg_id];
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                [Utilities dismissProcessingHud:self.view];
                if (isGetPic) {
                    [self performSelector:@selector(getPicForPath:) withObject:imagePath afterDelay:1];
                }else{
                    
                   UILabel *_failureLabel = [[UILabel alloc] init];
                   _failureLabel.bounds = CGRectMake(0, 0, self.view.frame.size.width, 44);
                    _failureLabel.textAlignment = NSTextAlignmentCenter;
                    _failureLabel.center = self.view.center;
                    _failureLabel.text = @"网络不给力，图片下载失败";
                    _failureLabel.font = [UIFont boldSystemFontOfSize:20];
                    _failureLabel.textColor = [UIColor whiteColor];
                    _failureLabel.backgroundColor = [UIColor clearColor];
                    _failureLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
                    [self.view addSubview:_failureLabel];
                   
                }
            });
        });
    }
}

- (void)back:sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -zoom

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView 
{
    return imageView;
} 

- (void)scrollViewDidZoom:(UIScrollView *)aScrollView
{
    CGFloat offsetX = (scrollViewForPic.bounds.size.width > scrollViewForPic.contentSize.width)?
    (scrollViewForPic.bounds.size.width - scrollViewForPic.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollViewForPic.bounds.size.height > scrollViewForPic.contentSize.height)?
    (scrollViewForPic.bounds.size.height - scrollViewForPic.contentSize.height) * 0.5 : 0.0;
    imageView.center = CGPointMake(scrollViewForPic.contentSize.width * 0.5 + offsetX,
                                   scrollViewForPic.contentSize.height * 0.5 + offsetY);
}


#pragma mark - 保存图片相关

- (void)showRightButton
{
    // 保存图片按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    //rightButton.frame = CGRectMake(280, 0, 40, 40);
    rightButton.frame = CGRectMake(20, maxHeight - 40, 40, 40);
    [rightButton setImage:[UIImage imageNamed:@"icon_account_save1.png"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"icon_account_save1.png"] forState:UIControlStateSelected];
    [rightButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    //UINavigationItem *navigatorItem = [TTNavigator navigator].visibleViewController.navigationItem;
//    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    [self.view addSubview:rightButton];
    
}

//保存图片
- (void)saveImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImageWriteToSavedPhotosAlbum(self.picImage, self, @selector(imageSave:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)imageSave:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        //[self.view makeToast:@"保存图片失败" duration:1.5 position:@"center" image:nil];
         //[MBProgressHUD showSuccess:@"保存失败" toView:nil];
        [Utilities showSuccessedHud:@"保存失败" descView:nil];// 2015.05.12
    } else {
        //[self.view makeToast:@"图片已保存到相册" duration:1.5 position:@"center" image:nil];
        //[MBProgressHUD showSuccess:@"图片已保存" toView:nil];
        [Utilities showSuccessedHud:@"图片已保存" descView:nil];//2015.05.12

    }
}

@end
