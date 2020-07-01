//
//  MyQRCodeViewController.m
//  MicroSchool
//
//  Created by jojo on 15/6/2.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "MyQRCodeViewController.h"
#import "MyTabBarController.h"

@interface MyQRCodeViewController ()

@end

@implementation MyQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super setCustomizeTitle:@"我的二维码"];
    [super setCustomizeLeftButton];
    
    
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
        [self.view addSubview:noNetworkV];
        return;
    }
    
    [self setCustomizeRightButtonWithName:@"保存"];
    
    [self doGetQRCode];
    
    [ReportObject event:ID_OPEN_MY_QRCODE];//2015.06.25
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MyTabBarController setTabBarHidden:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectRightAction:(id)sender
{
    [self saveImage];
    
    [Utilities showProcessingHud:self.view];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)doGetQRCode
{
    [Utilities showProcessingHud:self.view];
    NSString *uid = [Utilities getUniqueUid];
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"QRCode",@"ac",
                          @"2",@"v",
                          @"contact", @"op",
                          uid, @"contact",
                          G_SCHOOL_ID, @"school",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            NSDictionary *msg = [respDic objectForKey:@"message"];
            _qrCode = [msg objectForKey:@"code"];
            
            NSDictionary *message_info = [g_userInfo getUserDetailInfo];
            NSString* avatar = [message_info objectForKey:@"avatar"];
            
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:avatar] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize)
             {
                 
             } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
             {
                 if (image && finished) {
                     [Utilities dismissProcessingHud:self.view];
                     
                     _avatarImg = image;
                     [self doShowQRCodeView];
                 }else{
                     [Utilities dismissProcessingHud:self.view];

                     [Utilities showFailedHud:@"获取群信息错误，请稍后再试。" descView:self.view];
                 }
             }];
            
            
            
#if 0
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"",@"ac",
                                  @"2",@"v",
                                  @"", @"op",
                                  nil];
            
            [[TSNetworking sharedClient] requestGetFileWithCustomizeURL:avatar params:data successBlock:^(TSNetworking *request, id responseObject) {
                [Utilities dismissProcessingHud:self.view];
                
                NSDictionary *respDic = (NSDictionary*)responseObject;
//                NSString *result = [respDic objectForKey:@"result"];
                
                if(true == [result intValue]) {
                    
                    
                } else {
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                                   message:@"获取信息错误，请稍候再试"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil];
                    [alert show];
                }
                
            } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                [Utilities doHandleTSNetworkingErr:error descView:self.view];
            }];
#endif

            
            
            
        } else {
            [Utilities dismissProcessingHud:self.view];

            [Utilities showFailedHud:@"获取群信息错误，请稍后再试。" descView:self.view];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
}

- (void)doShowQRCodeView
{
    NSDictionary *message_info;
    message_info = [g_userInfo getUserDetailInfo];

    _qrCodeImageView =[[UIImageView alloc]initWithFrame:CGRectMake(60, 80, 200, 200)];
    _qrCodeImageView.contentMode = UIViewContentModeScaleToFill;
    [_qrCodeImageView setImage:[UIImage imageNamed:@"moments/icon_ckxq.png"]];
    _qrCodeImageView.userInteractionEnabled = NO;
    [self.view addSubview:_qrCodeImageView];

    /*//直接在生成的二维码上边加头像就行了啊，整这复杂，还没变圆角。。。2015.09.10
    //UIImage *yuanjiaoImg = [UIImage createRoundedRectImage:_avatarImg size:CGSizeMake(40, 40) radius:5];
    
    UIImage *yuanjiaoImg = [UIImage createRoundedRectImage:[UIImage imageNamed:@"BubbleMask.png"] size:CGSizeMake(40, 40) radius:5];

    UIImage *boaderImg = [self addBorderToImage:yuanjiaoImg];
    
    UIImage *myImage = [QRCodeGenerator qrImageForString:_qrCode imageSize:_qrCodeImageView.bounds.size.width LogoImage:boaderImg];
    
    _qrCodeImageView.image = myImage;*/
    //_qrCode = @"content://contacts/632355555/663866666";//测试代码
    //
    UIImage *myImage = [QRCodeGenerator qrImageForString:_qrCode imageSize:_qrCodeImageView.bounds.size.width*2];//Retina屏幕会虚，size要扩大2倍 2015.10.29
    _qrCodeImageView.image = myImage;
    UIImageView *testImgV = [[UIImageView alloc]initWithFrame:CGRectMake((_qrCodeImageView.frame.size.width-40)/2.0, (_qrCodeImageView.frame.size.height-40)/2.0, 40.0, 40.0)];
    testImgV.image = _avatarImg;
    testImgV.layer.cornerRadius = 6.0;
    testImgV.layer.masksToBounds = YES;
    testImgV.layer.borderColor =  [UIColor whiteColor].CGColor;
    testImgV.layer.borderWidth = 2;
    [_qrCodeImageView addSubview:testImgV];
    //-----------------------------------------------------------------------------------------------------------

    
    UILabel *_labelNote = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                0,
                                                                _qrCodeImageView.frame.origin.y + _qrCodeImageView.frame.size.height,
                                                                WIDTH,
                                                                21)];
    _labelNote.font = [UIFont systemFontOfSize:18.0f];
    _labelNote.textColor = [UIColor blackColor];
    _labelNote.backgroundColor = [UIColor clearColor];
    _labelNote.textAlignment = NSTextAlignmentCenter;
    _labelNote.text = @"扫一扫加我为好友";
    [self.view addSubview:_labelNote];
}


- (UIImage *)addBorderToImage:(UIImage *)image {
    
    CGImageRef bgimage = [image CGImage];
    float width = CGImageGetWidth(bgimage);
    float height = CGImageGetHeight(bgimage);
    
    // Create a temporary texture data buffer
    void *data = malloc(width * height * 4);
    
    // Draw image to buffer
    CGContextRef ctx = CGBitmapContextCreate(data,
                                             width,
                                             height,
                                             8,
                                             width * 4,
                                             CGImageGetColorSpace(image.CGImage),
                                             kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(ctx, CGRectMake(0, 0, (CGFloat)width, (CGFloat)height), bgimage);
    
    //Set the stroke (pen) color
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    
    //Set the width of the pen mark
    CGFloat borderWidth = (float)width*0.1;
    CGContextSetLineWidth(ctx, borderWidth);
    
    //Start at 0,0 and draw a square
    CGContextMoveToPoint(ctx, 0.0, 0.0);
    CGContextAddLineToPoint(ctx, 0.0, height);
    CGContextAddLineToPoint(ctx, width, height);
    CGContextAddLineToPoint(ctx, width, 0.0);
    CGContextAddLineToPoint(ctx, 0.0, 0.0);
    
    //Draw it
    CGContextStrokePath(ctx);
    
    // write it to a new image
    CGImageRef cgimage = CGBitmapContextCreateImage(ctx);
    UIImage *newImage = [UIImage imageWithCGImage:cgimage];
    CFRelease(cgimage);
    CGContextRelease(ctx);
    
    // auto-released
    return newImage;
}

#if 0
- (IBAction)saveImageToAlbum:(id)sender {
    UIImageWriteToSavedPhotosAlbum(_qrCodeImageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}


- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"呵呵";
    if (!error) {
        message = @"成功保存到相册";
    }else
    {
        message = [error description];
    }
    NSLog(@"message is %@",message);
}
#endif

- (void)saveImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImageWriteToSavedPhotosAlbum(_qrCodeImageView.image, self, @selector(imageSave:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)imageSave:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [Utilities dismissProcessingHud:self.view];

    if (error) {
        [Utilities showSuccessedHud:@"保存失败" descView:nil];
    } else {
        [Utilities showSuccessedHud:@"图片已保存" descView:nil];
    }
}

@end
