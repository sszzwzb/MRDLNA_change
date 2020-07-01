//
//  SchoolQRCodeViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/10/28.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "SchoolQRCodeViewController.h"
#import "Toast+UIView.h"
#import "UIImageView+WebCache.h"
#import "QRCodeGenerator+LogoView.h"
#import "MyTabBarController.h"

@interface SchoolQRCodeViewController ()
@property (strong, nonatomic) IBOutlet UIView *BaseView;
@property (strong, nonatomic) IBOutlet UILabel *SchoolName;
@property (strong, nonatomic) IBOutlet UIImageView *SchoolLogoImgV;
@property (strong, nonatomic) IBOutlet UIImageView *qrCodeImageView;

@end

@implementation SchoolQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (![Utilities isConnected]) {
        
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
        [self.view addSubview:noNetworkV];
        return;
    }
    
    [self setCustomizeTitle:@"我的学校"];
    [self setCustomizeLeftButton];
    [self setCustomizeRightButton:@"icon_more.png"];
    
    self.view.hidden = YES;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [Utilities showProcessingHud:self.view];
    [self getData];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MyTabBarController setTabBarHidden:YES];
}
-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectRightAction:(id)sender{
    
    //UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享链接",@"分享图片",@"拷贝链接",@"保存图片", nil];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享链接",@"保存图片", nil];
    //actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    
}

/**
 * 获取学校信息
 * @author luke
 * @args
 *  op=profile, sid=
 * @example:
 {
 "protocol": "SchoolAction.profile",
 "result": true,
 "message": {
    "sid": "3151",
    "name": "大连东方实验高级中学",
    "logo": "http://test.5xiaoyuan.cn/attachment/201508/19/49439_143995006027Yn.jpg",
    "mtagtype": "senior",
    "url": "http://test.5xiaoyuan.cn/wap_down/download.php?type=-1&schoolId=3151&sid=3151"
   }
 }
 *
 */
-(void)getData{
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"School",@"ac",
                          @"2",@"v",
                          @"profile", @"op",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            NSLog(@"二维码数据:%@",respDic);
            
            NSDictionary *messageDic = [respDic objectForKey:@"message"];
            if ([messageDic count] > 0) {
                
                self.view.hidden = NO;
                [noDataView removeFromSuperview];
                
                NSString *logoUrlStr = [messageDic objectForKey:@"pic"];
                NSString *name = [messageDic objectForKey:@"name"];
                downloadUrl = [[NSString alloc]initWithFormat:@"%@",[messageDic objectForKey:@"url"]];
                
                [_SchoolLogoImgV sd_setImageWithURL:[NSURL URLWithString:logoUrlStr] placeholderImage:[UIImage imageNamed:@"SchoolExhibition/icon_school_avatar_defalt.png"]];
                _SchoolName.text = name;
                
                codeImage = [QRCodeGenerator qrImageForString:downloadUrl imageSize:_qrCodeImageView.bounds.size.width*2];
                _qrCodeImageView.image = codeImage;
                
                
            }else{
                
                CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44);
                noDataView = [Utilities showNodataView:@"暂无相关数据" msg2:@"" andRect:rect];
                [self.view addSubview:noDataView];
            }
            
        }else{
            [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
            
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    /*if (buttonIndex == 4) {
        
    }else if(buttonIndex == 3){
        
        [self saveImageToPhoto:nil];
        
    }else if (buttonIndex == 2){
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:downloadUrl];
        
    }
    else {
        [self showSMSPicker:buttonIndex];
    }*/
    
    if (buttonIndex == 0) {
        [self showSMSPicker:0];
    }else if(buttonIndex  == 1){
        [self saveImageToPhoto:nil];
    }
    
}

//短信
-(void)showSMSPicker:(NSInteger)type{
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    if (messageClass != nil) {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet:type];
        }
        else {
          
            [Utilities showAlert:@"提示" message:@"设备不支持短信功能" cancelButtonTitle:@"确定" otherButtonTitle:nil];
            
        }
    }
    else {
        
    }
}
-(void)displaySMSComposerSheet:(NSInteger)type
{
    picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate =self;
    if (type == 0) {
        //发送文本
        NSString *smsBody =[NSString stringWithFormat:@"你可以通过这个地址查看我的学校：%@",downloadUrl] ;
        picker.body = smsBody;
        [self presentViewController:picker animated:YES completion:nil];

    }else{
        
        Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
        if ([messageClass canSendAttachments]){
            //发送图片附件
            NSData *myData = UIImagePNGRepresentation(codeImage);
            [picker addAttachmentData:myData typeIdentifier:@"image/png" filename:@"test.png"];
            [self presentViewController:picker animated:YES completion:nil];

        }else{
            [Utilities showAlert:@"提示" message:@"设备不支持短信发附件功能" cancelButtonTitle:@"确定" otherButtonTitle:nil];
        }
       
    }
 
    
}

//图片保存到相册
- (void)saveImageToPhoto:(id)sender
{
    
    codeImage = [self screenImageWithSize:_BaseView];
    
    
    UIImageWriteToSavedPhotosAlbum(codeImage, self, @selector(imageSave:didFinishSavingWithError:contextInfo:), nil);
    
}

- (void)imageSave:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [self.view makeToast:@"保存图片失败，请稍后再试" duration:1.5 position:@"center" image:nil];
    } else {
        if (image == nil) {
            [self.view makeToast:@"保存图片失败，请稍后再试" duration:1.5 position:@"center" image:nil];
        }else{
            [self.view makeToast:@"图片已保存到相册" duration:1.5 position:@"center" image:nil];
        }
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Result: SMS sending canceled");
            break;
        case MessageComposeResultSent:
            NSLog(@"Result: SMS sent");
            [self.view makeToast:@"短信发送成功" duration:1.5 position:@"center" image:nil];
            break;
        case MessageComposeResultFailed:
           
            [self.view makeToast:@"短信发送失败，请稍后再试" duration:1.5 position:@"center" image:nil];

            break;
        default:
            NSLog(@"Result: SMS not sent");
            break;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

-(UIImage *)screenImageWithSize:(UIView*)view{
    
   /*注释部分的方法不适用与Retina屏，废弃，截图完之后会虚
     UIGraphicsBeginImageContext（）方法会构建一个基于位图（bitmap）的图形context，并且这个context会成为当前context。然后通过renderInContext方法把 app.window.layer 渲染进当前的图形context。最后通过UIGraphicsGetImageFromCurrentImageContext（）获取当前图形context上的图片，从而获取屏幕截图。
     
     UIGraphicsBeginImageContext（）方法传入唯一参数，是一个CGSize变量，用来指定图形context的大小，所以获取屏幕截图的时候这个size该是屏幕的大小。其实了解了这个过程，就知道这个方法可以获取任意区域的截图，当然是必须当前页面的一部分。你需要截取哪个view的图像，就让这个view的layer调用renderInContext把图形渲染进当前图形context
    
    
    UIGraphicsBeginImageContext(imgSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate; //获取app的appdelegate，便于取到当前的window用来截屏
//    [app.window.layer renderInContext:context];
    
    [_BaseView.layer renderInContext:context];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;*/
    
        //UIView * view = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:YES];
        if(&UIGraphicsBeginImageContextWithOptions != NULL)
        {
            UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
        } else {
            UIGraphicsBeginImageContext(view.frame.size);
        }
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
