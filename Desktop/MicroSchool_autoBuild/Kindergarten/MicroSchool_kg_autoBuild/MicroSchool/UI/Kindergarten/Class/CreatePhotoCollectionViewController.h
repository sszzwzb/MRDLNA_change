//
//  CreatePhotoCollectionViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 16/4/5.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CreatePhotoCollectionViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    
    UITextField *text_title;
}


@property(strong,nonatomic)NSString *cid;
@property(strong,nonatomic)NSString *fromName;
@property(assign,nonatomic)NSInteger isSelectPhoto;
@end
