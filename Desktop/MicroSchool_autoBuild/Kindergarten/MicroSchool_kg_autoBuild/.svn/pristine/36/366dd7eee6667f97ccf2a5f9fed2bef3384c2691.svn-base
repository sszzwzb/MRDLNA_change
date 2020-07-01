//
//  ScanViewController.h
//  MicroSchool
//
//  Created by Kate on 14-11-12.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#import "MyTabBarController.h"

#import "SingleWebViewController.h" 

@interface ScanViewController : BaseViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZBarReaderViewDelegate,ZBarReaderDelegate,UIScrollViewDelegate,HttpReqCallbackDelegate>{
    
    UIImagePickerController *uip;
    ZBarReaderViewController *reader;
    //ZBarReaderView *readerView ;
    UIScrollView *scrollView;// 自定义控件
    NSMutableArray *qrCodeListArray;
    // UIButton *infoButton;
    UIButton *customStoryBtn;//定制故事按钮
    UILabel *titleLabel;
    
    BOOL isSubmit;
    NSString *codeResult;// add by kate 2014.12.03
    
}


// scanView 为从扫一扫页面进去
@property(nonatomic,retain) NSString *viewType;

// 保存QRcode结果
@property(nonatomic,retain) NSString *qrCode;

@property(nonatomic,retain) NSString *qrCodeMd5;

@end
