//
//  BindPhoneNumberViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/8/11.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "BindPhoneNumberViewController.h"
#import "Toast+UIView.h"

@interface BindPhoneNumberViewController ()
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTxf;
@property (strong, nonatomic) IBOutlet UITextField *codeTxf;
@property (strong, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (strong, nonatomic) IBOutlet UILabel *bindTitleLabel;
@property (strong, nonatomic) IBOutlet UITextField *pwdTxf;
@property (strong, nonatomic) IBOutlet UILabel *changeTitleLabel;
- (IBAction)getCode_btnclick:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *pwdImgV;

@end

@implementation BindPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
//    [_getCodeBtn setBackgroundImage:[UIImage imageNamed:@"btn_common_2-d.png"] forState:UIControlStateNormal] ;
//    [_getCodeBtn setBackgroundImage:[UIImage imageNamed:@"btn_common_2_p.png"] forState:UIControlStateHighlighted];
    _getCodeBtn.alpha = 0.7;
    _getCodeBtn.enabled = NO;
    [self setCustomizeLeftButton];
    [super setCustomizeRightButtonWithName:@"保存"];
    
    if ([@"bind" isEqualToString:_fromName]) {
        
        [self setCustomizeTitle:@"绑定手机号"];
        _changeTitleLabel.hidden = YES;
        _pwdTxf.hidden = YES;
        _pwdImgV.hidden = YES;
        
    }else{
        
        [self setCustomizeTitle:@"更换手机号"];
        _bindTitleLabel.hidden = YES;
        
    }
    
    // 手势识别
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    singleTouch.delegate = self;
    [self.view addGestureRecognizer:singleTouch];
    
}

-(void)dismissKeyboard{
    
    [_phoneNumberTxf resignFirstResponder];
    [_codeTxf resignFirstResponder];
    [_pwdTxf resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectRightAction:(id)sender{
    
    if ([@"bind" isEqualToString:_fromName]) {
        
        [ReportObject event:ID_CLICK_SAVE_BIND];
        
        if(_phoneNumberTxf.text.length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                          message:@"手机号不能为空，请重新输入"
                                                         delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [alert show];
        }
        else if(_codeTxf.text.length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                          message:@"验证码不能为空，请重新输入"
                                                         delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            [super hideKeyBoard];
            
            [self performSelector:@selector(bindPhoneNumber) withObject:nil afterDelay:0.1];
        }

    }else{//更换手机号
        
        [ReportObject event:ID_CLICK_SAVE_CHANGE];
        
        if(_phoneNumberTxf.text.length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                          message:@"手机号不能为空，请重新输入"
                                                         delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [alert show];
        }
        else if(_codeTxf.text.length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                          message:@"验证码不能为空，请重新输入"
                                                         delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [alert show];
        }else if (_pwdTxf.text.length == 0){
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                          message:@"密码不能为空，请重新输入"
                                                         delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [alert show];
            
        }else if (_pwdTxf.text.length < 6){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                          message:@"密码小于6位，请重新输入"
                                                         delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            [super hideKeyBoard];
            
            [self performSelector:@selector(changePhoneNumber) withObject:nil afterDelay:0.1];
        }
        
    }
}

/**
 * 绑定手机号码
 * @author luke
 * @date 2015.08.10
 * @args
 *  ac=Profile, v=2, op=setMobile, sid=, uid=, mobile=新手机号码, code=短信验证码
 */
-(void)bindPhoneNumber{
    
    [Utilities showProcessingHud:self.view];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Profile", @"ac",
                          @"2", @"v",
                          @"setMobile", @"op",
                          _phoneNumberTxf.text, @"mobile",
                          _codeTxf.text,@"code",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            
            [ReportObject event:ID_CLICK_SAVE_SUCESS_BIND];
            
            GlobalSingletonUserInfo* g_userSettingInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
            NSMutableDictionary *settingPersonalInfo = [g_userSettingInfo getUserSettingPersonalInfo];
            NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
            
            [settingPersonalInfo setObject:_phoneNumberTxf.text forKey:@"mobile"];
            [userDetail setObject:_phoneNumberTxf.text forKey:@"mobile"];
            
            // 更新单例中得数据
            [g_userSettingInfo setUserPersonalInfo:settingPersonalInfo];
            [g_userInfo setUserDetailInfo:userDetail];
            
            
            NSString *message_info = [respDic objectForKey:@"message"];
            [Utilities showSuccessedHud:message_info descView:self.view];
            
            [self performSelector:@selector(back) withObject:nil afterDelay:1];
        
            
        } else {
            
            NSString* message_info = [respDic objectForKey:@"message"];
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:message_info
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];

}

/**
 * 申请短信验证码
 * @author luke
 * @date 2015.08.10
 * @args
 *  v=2, ac=Profile, op=requestVerifyCode, sid=, uid=, mobile=
 */
-(void)doGetCode
{

    [Utilities showProcessingHud:self.view];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Profile", @"ac",
                          @"2", @"v",
                          @"requestVerifyCode", @"op",
                          _phoneNumberTxf.text, @"mobile",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            NSString* message_info = [respDic objectForKey:@"message"];
            
            [self.view makeToast:message_info
                        duration:2.5
                        position:@"center"
                           title:@"获取成功"];
            _phoneNumberTxf.userInteractionEnabled= NO;
            //secondsCountDown = 60;
            secondsCountDown = 180;//2015.08.26
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            
        } else {
            
            NSString* message_info = [respDic objectForKey:@"message"];
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:message_info
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];


}


/**
 * 修改手机号码
 * @author luke
 * @date 2015.08.10
 * @args
 *  ac=Profile, v=2, op=resetMobile, sid=, uid=, mobile=新手机号码, password=, code=短信验证码
 */
-(void)changePhoneNumber{
    
    [Utilities showProcessingHud:self.view];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Profile", @"ac",
                          @"2", @"v",
                          @"resetMobile", @"op",
                          _phoneNumberTxf.text, @"mobile",
                          _pwdTxf.text,@"password",
                          _codeTxf.text,@"code",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            
            [ReportObject event:ID_CLICK_SAVE_SUCESS_CHANGE];
            
            GlobalSingletonUserInfo* g_userSettingInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
            NSMutableDictionary *settingPersonalInfo = [g_userSettingInfo getUserSettingPersonalInfo];
            NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
            
            [settingPersonalInfo setObject:_phoneNumberTxf.text forKey:@"mobile"];
            [userDetail setObject:_phoneNumberTxf.text forKey:@"mobile"];
            
            // 更新单例中得数据
            [g_userSettingInfo setUserPersonalInfo:settingPersonalInfo];
            [g_userInfo setUserDetailInfo:userDetail];
            
           
            NSString *message_info = [respDic objectForKey:@"message"];
            [Utilities showSuccessedHud:message_info descView:self.view];
            [self performSelector:@selector(back) withObject:nil afterDelay:1];

            
            
        } else {
            
            NSString* message_info = [respDic objectForKey:@"message"];
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:message_info
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
}

- (IBAction)getCode_btnclick:(id)sender {
    
    if(_phoneNumberTxf.text.length == 0)
    {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                      message:@"手机号不能为空，请重新输入"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
    }
    else
    {
      
        [super hideKeyBoard];
        [self performSelector:@selector(doGetCode) withObject:nil afterDelay:0.1];
        
        
    }
}

- (void)timeFireMethod
{
    secondsCountDown--;
    
    _getCodeBtn.alpha = 0.7;
    _getCodeBtn.enabled = NO;
    
    NSString *cdStr;
    cdStr = [NSString stringWithFormat:@"%ld秒", (long)secondsCountDown];
    
    [_getCodeBtn setTitle:cdStr forState:UIControlStateDisabled];
    [_getCodeBtn setTitle:cdStr forState:UIControlStateDisabled];
    
    if(secondsCountDown==0){
        _getCodeBtn.alpha = 1;
        _getCodeBtn.enabled = YES;
        
        _phoneNumberTxf.userInteractionEnabled= YES;
        
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateHighlighted];
        
        [countDownTimer invalidate];
    }
}

// 定义UITextFiled的代理方法：
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (_codeTxf == textField)//验证码
    {
        //这里默认是最多输入4位
        if (range.location >= 4)
            return NO; // return NO to not change text
        return YES;
        
    }else if(_phoneNumberTxf == textField){//手机
        
        NSString *inputStr = string;
        NSString *text =_phoneNumberTxf.text;
        NSString *textStr;
        NSInteger location;
        
        
        if ([@""  isEqual: inputStr]) {
            
            NSInteger strLength = text.length;
            
            if ([text length] > strLength -1) {
                inputStr = [text substringToIndex:strLength-1];
                textStr = [text substringToIndex:strLength-1];
                location = range.location - 1;
            }
         
        } else {
            textStr = [text stringByAppendingString:inputStr];
            location = range.location;
        }
        
        if (location == 0) {
            if ([@"1"  isEqual: textStr]) {
                return YES;
            } else {
                return NO;
            }
        } else if (location == 1) {
            if ([@"13"  isEqual: textStr] | [@"14"  isEqual: textStr] | [@"15"  isEqual: textStr] | [@"18"  isEqual: textStr] | [@"17"  isEqual: textStr]) {
                return YES;
            } else {
                return NO;
            }
        } else if (location == 2) {
            if ([self validateMobile:textStr]) {
                return YES;
            } else {
                return NO;
            }
        } else if (location == 10) {
            _getCodeBtn.alpha = 1;
            _getCodeBtn.enabled = YES;
        } else if (range.location <= 10) {
            _getCodeBtn.alpha = 0.7;
            _getCodeBtn.enabled = NO;
            return YES;
        } else if (range.location > 10) {
            return NO;
        }
        
        return YES;
    }else{//密码
        if (range.location >= 12)
            return NO; // return NO to not change text
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self selectRightAction:nil];
    
    return YES;
}

- (BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    //NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0235-9]|4[7])$";
    NSString * MOBILE = @"^1(3|5|8|4|7)\\d$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    //    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    //    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    //    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    //NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    //NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    //NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if ([regextestmobile evaluateWithObject:mobileNum] == YES)
        //        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        //        || ([regextestct evaluateWithObject:mobileNum] == YES)
        //        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)back{
    
    [self dismissKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
    [ReportObject event:ID_SET_PERSON_INFO];//2015.06.25

    
}


@end
