//
//  NoSignedViewController.h
//  MicroSchool
//
//  Created by Kate on 16/8/29.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface NoSignedViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
    UITextField *_textFieldOri;

}

@property(nonatomic,strong) NSString *titleName;

@end
