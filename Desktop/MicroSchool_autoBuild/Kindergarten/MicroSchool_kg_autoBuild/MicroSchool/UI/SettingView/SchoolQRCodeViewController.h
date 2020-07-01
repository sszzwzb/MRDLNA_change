//
//  SchoolQRCodeViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/10/28.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <MessageUI/MessageUI.h>

@interface SchoolQRCodeViewController : BaseViewController<UIActionSheetDelegate,MFMessageComposeViewControllerDelegate>{
    
    UIImage *codeImage;
    UIView *noDataView;
    NSString *downloadUrl;
    MFMessageComposeViewController *picker;
    
}

@end
