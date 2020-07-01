//
//  GrowthNotValidateViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/9/18.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface GrowthNotValidateViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    
    NSInteger flag;//空间状态 1.未开通/首次激活 2.试用期 3.过期
    NSDictionary *profile;
    NSDictionary *rank;
    
    NSInteger rowCount;
    float sectionHeight;
    NSString *number;
    
    //--- 用于显示cell的红点
    UIImageView *scoreImgView;
    UIImageView *healthImgView;
    //--------------------------
    
    
}
@property(nonatomic,strong)NSString *titleName;
@property(nonatomic,strong)NSString *cId;
@property(nonatomic,strong)NSString *spaceStatus;
@property(nonatomic,strong)NSString *urlStr;
@property(nonatomic,strong)NSString *isBind;
@property(nonatomic,strong)NSString *fromName;
@property(nonatomic,strong)NSString *mid;
@property(nonatomic,strong)NSMutableDictionary *redPointDic;
@property(nonatomic,strong)NSString *isTrial;//是否跳过试用期
@property(nonatomic,strong)NSString *growthInfo;//2.9.4 介绍文言从后台拉取
@end
