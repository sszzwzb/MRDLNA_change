//
//  PayViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/10/8.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface PayViewController : BaseViewController<UIAlertViewDelegate>{
    
    NSString *urlStr;
    NSString *payUrlStr;
    NSString *serviceUrlStr;
    NSString *payStatus;//支付状态 从0到1关闭支付页 tony确认 给一个无试用期学校特殊处理 2015.12.21
    NSMutableArray *itemsArray;//2016.01.07
    NSInteger selected;
    
}

@property(nonatomic,strong)NSString *cId;
// 是否是跳转到safari之后回到支付页面
@property (nonatomic,assign) BOOL isBackFromSafari;
@property (nonatomic,strong) NSString *isTrial;//是否有试用期

@property(nonatomic,strong)NSString *titleName;
@property(nonatomic,strong)NSString *spaceStatus;
@property(nonatomic,strong)NSString *urlStr;
@property(nonatomic,strong)NSString *isBind;
@property(nonatomic,strong)NSString *fromName;
@property(nonatomic,strong)NSString *mid;
@property(nonatomic,strong)NSMutableDictionary *redPointDic;

@end
