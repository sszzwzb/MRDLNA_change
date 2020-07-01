//
//  AddFriendWayViewController.m
//  MicroSchool
//
//  Created by Kate on 14-10-17.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "AddFriendWayViewController.h"
#import "FRNetPoolUtils.h"

@interface AddFriendWayViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *thirdLineImgV;
@property (strong, nonatomic) IBOutlet UIImageView *secondeLineImgV;
@property (strong, nonatomic) IBOutlet UIImageView *firstLineImgV;
@property (strong, nonatomic) IBOutlet UIButton *firstBtn;
@property (strong, nonatomic) IBOutlet UIButton *secondeBtn;
@property (strong, nonatomic) IBOutlet UIButton *thirdBtn;
- (IBAction)selectAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *detailLab;
@end

@implementation AddFriendWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@"加入方式"];
    [super setCustomizeRightButtonWithName:@"保存"];
    /*
     
     允许任何人添加，无需申请。
     申请人需提交验证申请，审批通过后方可加入。
     不可添加好友。
     */
    if ([_joinPerm intValue] == 1) {
        _firstLineImgV.hidden = NO;
        _secondeLineImgV.hidden = YES;
        _thirdLineImgV.hidden = YES;
        _detailLab.text = @"任何人无需验证都可以添加我为好友";
    }else if ([_joinPerm intValue] == 2){
        _firstLineImgV.hidden = YES;
        _secondeLineImgV.hidden = NO;
        _thirdLineImgV.hidden = YES;
        _detailLab.text = @"需要验证后才能添加我为好友";
    }else if ([_joinPerm intValue] == 3){
        _firstLineImgV.hidden = YES;
        _secondeLineImgV.hidden = YES;
        _thirdLineImgV.hidden = NO;
        _detailLab.text = @"禁止任何人添加我为好友";
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];

}

// 返回
-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 保存
-(void)selectRightAction:(id)sender{
    
    // 调用设置好友加入方式保存接口
    [self setFriendAuthority];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setFriendAuthority{
    
    // 调用加入方式保存接口
    [Utilities showProcessingHud:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 调用班级成员接口
        NSString *msg = [FRNetPoolUtils setFriendJoinPerm:_joinPerm];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities dismissProcessingHud:self.view];
            
            if (msg != nil) {
                
                [Utilities showAlert:@"错误" message:msg cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
                
                [userDetail setObject:_joinPerm forKey:@"authority"];
                
                [g_userInfo setUserDetailInfo:userDetail];
                [self.navigationController popViewControllerAnimated:YES];
                
                [ReportObject event:ID_SET_ADD_FRIEND];//2015.06.25
            }
        });
    });

}

- (IBAction)selectAction:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    
    if (button.tag == 301) {
        
        _firstLineImgV.hidden = NO;
        _secondeLineImgV.hidden = YES;
        _thirdLineImgV.hidden = YES;
        _joinPerm = @"1";
        
        _detailLab.text = @"任何人无需验证都可以添加我为好友";
        
    }else if (button.tag == 302){
        
        _firstLineImgV.hidden = YES;
        _secondeLineImgV.hidden = NO;
        _thirdLineImgV.hidden = YES;
        _joinPerm = @"2";
        
        _detailLab.text = @"需要验证后才能添加我为好友";

        
    }else if (button.tag == 303){
        
        _firstLineImgV.hidden = YES;
        _secondeLineImgV.hidden = YES;
        _thirdLineImgV.hidden = NO;
        _joinPerm = @"3";
        
        _detailLab.text = @"禁止任何人添加我为好友";
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
