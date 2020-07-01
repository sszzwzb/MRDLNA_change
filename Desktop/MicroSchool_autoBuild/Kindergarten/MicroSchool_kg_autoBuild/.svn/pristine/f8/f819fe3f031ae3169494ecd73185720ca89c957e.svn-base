//
//  EditClassIntroViewController.m
//  MicroSchool
//
//  Created by Kate on 14-9-22.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "EditClassIntroViewController.h"
#import "FRNetPoolUtils.h"

@interface EditClassIntroViewController ()

@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

@implementation EditClassIntroViewController

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
    clickNum = 0;
    [self setCustomizeLeftButton];
    NSString *schoolType = [[NSUserDefaults standardUserDefaults]objectForKey:@"schoolType"];//add 2015.05.11
    if ([@"bureau" isEqualToString:schoolType]) {
        [self setCustomizeTitle:@"部门简介"];
    }else{
        [self setCustomizeTitle:@"班级简介"];
    }
    
    [super setCustomizeRightButtonWithName:@"保存"];
    
    if ([_introStr length] == 0) {
        if ([@"bureau" isEqualToString:schoolType]) {//2015.09.14
            _textView.text = @"请填写部门简介";
        }else{
            _textView.text = @"请填写班级简介";
        }
        _textView.textColor = [UIColor grayColor];
    }else{
        
        _textView.text = _introStr;
        _textView.textColor = [UIColor blackColor];
    }
    
    [_textView becomeFirstResponder];
    
}

// 返回
-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setClassNote{
    
    [_textView resignFirstResponder];
    
    // 调用班级简介保存接口
    [Utilities showProcessingHud:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (clickNum == 0 && [_introStr length] == 0) {
            
            _introStr = @"";
            
        }else{
            
            _introStr = _textView.text;
            
        }
        
        // 调用班级简介保存接口
        NSString *msg = [FRNetPoolUtils setClassNote:_cId note:_introStr];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities dismissProcessingHud:self.view];
            
            if (msg != nil) {
                
                [Utilities showAlert:@"错误" message:msg cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyClassInfo" object:nil];
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                    
                    [self disablesAutomaticKeyboardDismissal];//iOS9还要加上此方法
                    [self.navigationController popViewControllerAnimated:NO];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
               
            }
        });
    });
    
}


// 保存
-(void)selectRightAction:(id)sender{
    
    [_textView resignFirstResponder];
    // 调用班级简介保存接口
    [self setClassNote];
    
}

/*! UIViewController的方法 2015.07.04*/
- (BOOL)disablesAutomaticKeyboardDismissal{
    
    //当以下这些语句都不好用时用此方法使键盘消失 iOS9
    [self.view endEditing:YES];
    [_textView resignFirstResponder];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    
    return NO;
}

// 限制100个字符 2.8.4版本班级简介修改为限制50个字
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    //点击了非删除键
    if( [text length] == 0 ) {
        
        if ( range.length > 50 ) {
            
            return NO;
        }
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    
    if ([textView.text isEqualToString:@"请填写班级简介"] && _textView.textColor == [UIColor grayColor]) {
        
        _introStr = @"";
        _textView.textColor = [UIColor blackColor];
        
    }
    
    if (clickNum == 0 && [_introStr length] == 0) {
        
        _textView.text = @"";
        clickNum++;
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
