//
//  ApplyAddClassViewController.m
//  MicroSchool
//
//  Created by Kate on 14-9-18.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "ApplyAddClassViewController.h"
#import "FRNetPoolUtils.h"
#import "Toast+UIView.h"

@interface ApplyAddClassViewController ()
@property (strong, nonatomic) IBOutlet UIButton *applyBtn;
- (IBAction)submit:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ApplyAddClassViewController



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
    [self setCustomizeTitle:@"加入申请"];
    [self setCustomizeLeftButton];
//    [_applyBtn setBackgroundImage:[UIImage imageNamed:@"btn_common_1-d.png"] forState:UIControlStateNormal] ;
//    [_applyBtn setBackgroundImage:[UIImage imageNamed:@"btn_common_1_p.png"] forState:UIControlStateHighlighted] ;
    clickNum = 0;
    if (IS_IPHONE_5) {
        
    }else{
        
        _applyBtn.frame = CGRectMake(10, 480 - 60 - 55, 300, 40);
    }
    
    // 手势识别
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    singleTouch.delegate = self;
    [self.view addGestureRecognizer:singleTouch];
    
    [_textView becomeFirstResponder];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 隐藏键盘
- (void)dismissKeyboard
{
    [_textView resignFirstResponder];
}

// 加入班级接口
-(void)joinClass{
    [Utilities showProcessingHud:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //NSString *result = [FRNetPoolUtils applyAddClass:_cId reason:_textView.text];
        NSDictionary *result = [FRNetPoolUtils addClass:_cId reason:_textView.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities dismissProcessingHud:self.view];
            
            if (result) {
                
                 NSDictionary *messageInfo = [result objectForKey:@"message"];
                
                if ([[result objectForKey:@"result"] integerValue] == 1) {
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                   message:[messageInfo objectForKey:@"message"]
                                                                  delegate:self
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil];
                    alert.tag = 231;
                    [alert show];
                    
                    NSString *yeargrade = @"";
                    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
                    [userdefaults setObject:yeargrade forKey:@"yeargradeForFilter"];
                  
                    
                }else{
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                   message:[messageInfo objectForKey:@"message"]
                                                                  delegate:self
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil];
                    alert.tag = 230;
                    [alert show];

                    
                }
                

            }else{
                
                [Utilities showAlert:@"错误" message:@"网络链接错误，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
            }
            
        });
        
    });
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 230 || alertView.tag == 231) {
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             _cId, @"cId",
                             _className, @"className",
                             nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"zhixiao_classListAppliedSuccess" object:self userInfo:dic];

//        [[NSNotificationCenter defaultCenter] postNotificationName:@"zhixiao_myClassAppliedSuccessAndChangeStatus" object:self userInfo:dic];

        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2]
                                              animated:YES];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            
            [self disablesAutomaticKeyboardDismissal];//iOS9还要加上此方法
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2]
                                                  animated:NO];
        }else{
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2]
                                                  animated:YES];
        }
    }
}

/*! UIViewController的方法 2015.07.04*/
- (BOOL)disablesAutomaticKeyboardDismissal{
    
    //当以下这些语句都不好用时用此方法使键盘消失 iOS9
    [self.view endEditing:YES];
    [_textView resignFirstResponder];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    
    return NO;
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 提交加入班级申请
- (IBAction)submit:(id)sender {
    
    [ReportObject event:ID_JOIN_CLASS];// 2015.06.24
    
    if (clickNum == 0 || [_textView.text length] == 0) {
        
        //[Utilities showAlert:@"提示" message:@"请填写申请理由" cancelButtonTitle:@"确定" otherButtonTitle:nil];
        [self.view makeToast:@"请填写申请理由"
                    duration:2.5
                    position:@"center"
                       title:nil];
        
    }else{
        
        //调用申请加入班级接口 跳转回上一页 重新拉取班级数据
        [self joinClass];
      
        
    }
    
}

// 限制100个字符
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        [self submit:nil];
        
        return NO;
    }
    
    //点击了非删除键
    if( [text length] == 0 ) {
        
        if ( range.length > 100 ) {
            
            return NO;
        }
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    _textView.textColor = [UIColor blackColor];
    
    if (clickNum == 0) {
        
        _textView.text = @"";
        
    }
    clickNum++;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
}

@end
