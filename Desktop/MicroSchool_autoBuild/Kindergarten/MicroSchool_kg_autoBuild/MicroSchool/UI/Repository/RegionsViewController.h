//
//  RegionsViewController.h
//  MicroSchool
//
//  Created by Kate on 15-2-5.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MBProgressHUD+Add.h"
#import "FRNetPoolUtils.h"

@interface RegionsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    
    MBProgressHUD *HUD;
    
    UIView *noNetworkV;
    
    
}
@property(nonatomic,strong)NSString *fromName;//判断是从校校通来还是从知识库的教师列表来
@end
