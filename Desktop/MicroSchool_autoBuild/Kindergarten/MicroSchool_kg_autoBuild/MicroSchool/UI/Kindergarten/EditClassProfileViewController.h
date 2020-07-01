//
//  EditClassProfileViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 16/3/16.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface EditClassProfileViewController :  BaseViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>{
    
    UIImagePickerController *imagePickerController;
    NSString *introStr;
    NSString *joinPermStr;
    NSDictionary *dic;
    
    BOOL setHeadImg;
    
    UIImageView *headImgV;
}
@property(nonatomic,strong)NSString *cId;

@end
