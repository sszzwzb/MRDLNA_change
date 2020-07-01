//
//  CameraSettingViewController.h
//  MicroSchool
//
//  Created by Kate on 2016/10/24.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CameraSetTableViewCell.h"

@interface CameraSettingViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,CameraSetTableViewCellDelegate>{
    
    UISwitch *push;
    NSMutableArray *listArray;
    NSMutableArray *tempArray;
    NSInteger sectionCount;
    UILabel *classNameLabel;
}
@property(nonatomic,strong)NSString *cId;
@property(nonatomic,strong)NSString *cameraId;
@end
