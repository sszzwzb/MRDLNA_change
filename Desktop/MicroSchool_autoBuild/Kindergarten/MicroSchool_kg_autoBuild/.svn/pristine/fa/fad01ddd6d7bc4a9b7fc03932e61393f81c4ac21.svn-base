//
//  MyPrivacyWaysViewController.m
//  MicroSchool
//
//  Created by Kate on 14-10-27.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "MyPrivacyWaysViewController.h"
#import "FRNetPoolUtils.h"

@interface MyPrivacyWaysViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *thirdLineImgV;
@property (strong, nonatomic) IBOutlet UIImageView *secondeLineImgV;
@property (strong, nonatomic) IBOutlet UIImageView *firstLineImgV;
@property (strong, nonatomic) IBOutlet UIButton *firstBtn;
@property (strong, nonatomic) IBOutlet UIButton *secondeBtn;
@property (strong, nonatomic) IBOutlet UIButton *thirdBtn;
- (IBAction)selectAction:(id)sender;
@end

@implementation MyPrivacyWaysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeTitle:_fromName];
    [self setCustomizeLeftButton];
    [super setCustomizeRightButtonWithName:@"保存"];
    
    if ([_joinPerm intValue] == 0) {
        _firstLineImgV.hidden = NO;
        _secondeLineImgV.hidden = YES;
        _thirdLineImgV.hidden = YES;
    }else if ([_joinPerm intValue] == 1){
        _firstLineImgV.hidden = YES;
        _secondeLineImgV.hidden = NO;
        _thirdLineImgV.hidden = YES;
        
    }else if ([_joinPerm intValue] == 3){
        _firstLineImgV.hidden = YES;
        _secondeLineImgV.hidden = YES;
        _thirdLineImgV.hidden = NO;
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];

}

// 返回
-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectRightAction:(id)sender{
    
    [self setPrivacyAuthority];
}

-(void)setPrivacyAuthority{
    
    [Utilities showProcessingHud:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 调用设置个人隐私接口
        NSString *msg = [FRNetPoolUtils setPrivacyWay:_type subType:_subtype way:_joinPerm];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities dismissProcessingHud:self.view];
            
            if (msg != nil) {
                
                [Utilities showAlert:@"提示" message:msg cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyPrivacyView" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
                [ReportObject event:ID_SET_MY_PRIVACY];//2015.06.25
            }
        });
    });
    
}

- (IBAction)selectAction:(id)sender{
    
    UIButton *button = (UIButton*)sender;
    
    if (button.tag == 301) {
        
        _firstLineImgV.hidden = NO;
        _secondeLineImgV.hidden = YES;
        _thirdLineImgV.hidden = YES;
        _joinPerm = @"0";
        
    }else if (button.tag == 302){
        
        _firstLineImgV.hidden = YES;
        _secondeLineImgV.hidden = NO;
        _thirdLineImgV.hidden = YES;
        _joinPerm = @"1";
        
    }else if (button.tag == 303){
        
        _firstLineImgV.hidden = YES;
        _secondeLineImgV.hidden = YES;
        _thirdLineImgV.hidden = NO;
        _joinPerm = @"3";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
