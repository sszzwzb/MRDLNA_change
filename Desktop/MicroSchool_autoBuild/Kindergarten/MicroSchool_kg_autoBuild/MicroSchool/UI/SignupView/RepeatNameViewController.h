//
//  RepeatNameViewController.h
//  
//
//  Created by banana on 16/6/22.
//
//

#import "BaseViewController.h"

@interface RepeatNameViewController : BaseViewController
@property (nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic,retain) NSDictionary *userInfoDic;//从用户信息完善页来
@property(nonatomic,strong)NSString *cId;//是否在班级内
@property(nonatomic,strong) NSString *viewType;
@end
