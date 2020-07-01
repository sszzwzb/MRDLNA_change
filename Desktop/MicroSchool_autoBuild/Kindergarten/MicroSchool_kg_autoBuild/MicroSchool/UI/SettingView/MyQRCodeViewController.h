//
//  MyQRCodeViewController.h
//  MicroSchool
//
//  Created by jojo on 15/6/2.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "QRCodeGenerator+LogoView.h"

#import "UIImage+wiRoundedRectImage.h"
#import "UIImage+Border.h"
#import "SDWebImageDownloader.h"

@interface MyQRCodeViewController : BaseViewController

@property (nonatomic, retain) UIImageView *qrCodeImageView;

@property (nonatomic, retain) NSString *qrCode;
@property (nonatomic, retain) NSString *qrCodeMd5;

@property (nonatomic, retain) UIImage *avatarImg;

@end
