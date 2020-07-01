//
//  AddWayViewController.m
//  MicroSchool
//
//  Created by Kate on 14-9-20.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "AddWayViewController.h"
#import "FRNetPoolUtils.h"

@interface AddWayViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *thirdLineImgV;
@property (strong, nonatomic) IBOutlet UIImageView *secondeLineImgV;
@property (strong, nonatomic) IBOutlet UIImageView *firstLineImgV;
@property (strong, nonatomic) IBOutlet UIButton *firstBtn;
@property (strong, nonatomic) IBOutlet UIButton *secondeBtn;
@property (strong, nonatomic) IBOutlet UIButton *thirdBtn;
- (IBAction)selectAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *thirdView;
@property (strong, nonatomic) IBOutlet UIImageView *bgApplyImgV;

@end

@implementation AddWayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@"加入方式"];
    [super setCustomizeRightButtonWithName:@"保存"];
    
#if BUREAU_OF_EDUCATION
    
    _thirdView.hidden = YES;
    _bgApplyImgV.frame = CGRectMake(0, _bgApplyImgV.frame.origin.y, _bgApplyImgV.frame.size.width, 100.0);
    
#else
    
    
#endif
    
    /*
     任何人均可直接加入，无需申请。
     申请人需提交验证申请，审批通过后方可加入。
     只有被邀请的用户可以加入。
     
     */
    if ([_joinPerm intValue] == 0) {
        _firstLineImgV.hidden = NO;
        _secondeLineImgV.hidden = YES;
        _thirdLineImgV.hidden = YES;
    }else if ([_joinPerm intValue] == 1){
        _firstLineImgV.hidden = YES;
        _secondeLineImgV.hidden = NO;
        _thirdLineImgV.hidden = YES;

    }else if ([_joinPerm intValue] == 2){
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

// 保存
-(void)selectRightAction:(id)sender{
    
    // 调用调用加入方式保存接口
    [self setClassJoinPerm];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setClassJoinPerm{
    
    // 调用加入方式保存接口
    [Utilities showProcessingHud:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 调用班级成员接口
        NSString *msg = [FRNetPoolUtils setClassJoinPerm:_cId perm:_joinPerm];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities dismissProcessingHud:self.view];
            
            if (msg != nil) {
                
                [Utilities showAlert:@"错误" message:msg cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyClassInfo" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
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
        _joinPerm = @"2";
    }
    
}

@end
