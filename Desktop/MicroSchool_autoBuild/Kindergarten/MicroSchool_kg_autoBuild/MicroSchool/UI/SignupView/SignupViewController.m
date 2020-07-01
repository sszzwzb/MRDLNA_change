//
//  SignupViewController.m
//  MicroSchool
//
//  Created by jojo on 13-11-3.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "SignupViewController.h"
#import "MicroSchoolAppDelegate.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        network = [NetworkUtility alloc];
        network.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [super setCustomizeTitle:@"注册"];
    [super setCustomizeLeftButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[ UIScreen mainScreen] .applicationFrame] ;
    NSLog(@"height = %f",[ UIScreen mainScreen].applicationFrame.size.height);
    NSLog(@"width = %f",[ UIScreen mainScreen].applicationFrame.size.width);
    
    NSLog(@"x = %f",[ UIScreen mainScreen].applicationFrame.origin.x);
    NSLog(@"y = %f",[ UIScreen mainScreen].applicationFrame.origin.y);

    self.view = view;
    
    // 背景图片

#define LABEL_Y_OFFSET		(40)
    
    // 手机号
//#319注释边框
    UIImageView *imageView_label=[[UIImageView alloc] initWithFrame:CGRectMake(30, LABEL_Y_OFFSET, 260, 40)];
//    UIImage *images_label=[UIImage imageNamed:@"bg_account.png"];
//    
//    [imageView_label setImage:images_label];
    [self.view addSubview:imageView_label];
    
    CGRect rect_number = CGRectMake(
                                    20,
                                    imageView_label.frame.origin.y + (imageView_label.frame.size.height - 20)/2,
                                    245,
                                    20);
    text_name = [[UITextField alloc]initWithFrame:rect_number];
//#319横线1
    CGRect len1 = CGRectMake(
                            20,
                            imageView_label.frame.origin.y + (imageView_label.frame.size.height - 20)/2+30,
                            WIDTH-40,
                            1);
    UILabel *lable1 = [[UILabel alloc]initWithFrame:len1];
    lable1.backgroundColor =[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1.0];
    [self.view addSubview:lable1];
    
    [self setInputTextField:@"输入手机号码" andRect:rect_number andType:@"text" andPoint:text_name];
    [text_name becomeFirstResponder];

    // 验证码
    UIImageView  *imageView_label_verify=[[UIImageView alloc] initWithFrame:CGRectMake(
                                         imageView_label.frame.origin.x,
                                         imageView_label.frame.origin.y + imageView_label.frame.size.height + 10,
                                                                                       150,
                                                                                       40)];
//#319注释边框
//    UIImage *images_label_verify=[UIImage imageNamed:@"bg_account.png"];
//    
//    [imageView_label_verify setImage:images_label_verify];
    [self.view addSubview:imageView_label_verify];

    CGRect rect_verify = CGRectMake(
                                    20,
                                    imageView_label_verify.frame.origin.y + (imageView_label_verify.frame.size.height - 20)/2,
                                    135,
                                    20);
//#319横线2
    CGRect len2 = CGRectMake(
                             20,
                             imageView_label_verify.frame.origin.y + imageView_label_verify.frame.size.height,
                             WIDTH-40,
                             1);
    UILabel *lable2 = [[UILabel alloc]initWithFrame:len2];
    lable2.backgroundColor =[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1.0];
    [self.view addSubview:lable2];
    text_verify = [[UITextField alloc]initWithFrame:rect_verify];
    [self setInputTextField:@"输入验证码" andRect:rect_verify andType:@"veri" andPoint:text_verify];
    
    // 设置密码
    UIImageView  *imageView_label_pwd=[[UIImageView alloc] initWithFrame:CGRectMake(
                                                                                       20,
                                                                                       imageView_label_verify.frame.origin.y + imageView_label_verify.frame.size.height + 10,
                                                                                       260,
                                                                                       40)];
//#319注释边框
//    UIImage *images_label_pwd=[UIImage imageNamed:@"bg_account.png"];
    
//    [imageView_label_pwd setImage:images_label_pwd];
    [self.view addSubview:imageView_label_pwd];
    
    CGRect rect_pwd = CGRectMake(
                                    20,
                                    imageView_label_pwd.frame.origin.y + (imageView_label_pwd.frame.size.height - 20)/2,
                                    245,
                                    20);
//#319横线3
    CGRect len3 = CGRectMake(
                             20,
                             imageView_label_pwd.frame.origin.y + (imageView_label_pwd.frame.size.height - 20)/2+30,
                             WIDTH-40,
                             1);
    UILabel *lable3 = [[UILabel alloc]initWithFrame:len3];
    lable3.backgroundColor =[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1.0];
    [self.view addSubview:lable3];
    
    text_pwd = [[UITextField alloc]initWithFrame:rect_pwd];
    [self setInputTextField:@"设置密码" andRect:rect_pwd andType:@"pwd" andPoint:text_pwd];

    // 隐私条款label
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(72, LABEL_Y_OFFSET + 50 + 50, 240, 30)];
//    label.text = @"已阅读并同意使用条款和隐私政策";
//    label.font = [UIFont fontWithName:@"Arial" size:13.0f];
//    label.textColor = [UIColor blackColor];
//    [self.view addSubview:label];
    
    // 下一步button
    UIButton *button_create = [UIButton buttonWithType:UIButtonTypeCustom];
    button_create = [Utilities addButton:button_create title:@"下一步" rect:CGRectMake(
                                                                    20,
                                                                    imageView_label_pwd.frame.origin.y + imageView_label_pwd.frame.size.height + 25,
                                                                    WIDTH-40,
                                                                    40)];
    
    [button_create addTarget:self action:@selector(longin_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:button_create];
    
    // 获取code button
    button_getCode = [UIButton buttonWithType:UIButtonTypeCustom];
    button_getCode.frame = CGRectMake(WIDTH-imageView_label_pwd.frame.origin.x -90, LABEL_Y_OFFSET + 50, 100, 40);
    
    button_getCode.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置title自适应对齐
    button_getCode.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [button_getCode setTitleColor:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button_getCode setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button_getCode.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
//#319消除验证btn背景
//    [button_getCode setBackgroundImage:[UIImage imageNamed:@"btn_common_2-d.png"] forState:UIControlStateNormal] ;
//    [button_getCode setBackgroundImage:[UIImage imageNamed:@"btn_common_2_p.png"] forState:UIControlStateHighlighted] ;

    // 添加 action
    [button_getCode addTarget:self action:@selector(getCode_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    
    button_getCode.alpha = 0.5;
    button_getCode.enabled = NO;

    //设置title
    [button_getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [button_getCode setTitle:@"获取验证码" forState:UIControlStateHighlighted];
    
    [self.view addSubview:button_getCode];
}


- (IBAction)longin_btnclick:(id)sender
{
    if(text_name.text.length == 0)
    {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                      message:@"手机号不能为空，请重新输入"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
    }
    else if(text_verify.text.length == 0)
    {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                      message:@"验证码不能为空，请重新输入"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
    }
    else if(text_pwd.text.length == 0)
    {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                      message:@"密码不能为空，请重新输入"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        if (text_pwd.text.length < 6) {
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                          message:@"密码不能小于6位，请重新输入"
                                                         delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [alert show];
        }else {
            [super hideKeyBoard];
            
            [self performSelector:@selector(doVerifyCode) withObject:nil afterDelay:0.1];
        }
    }
}

- (IBAction)getCode_btnclick:(id)sender
{
    if(text_name.text.length == 0)
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
//        if (YES == [self validateMobile:text_name.text]) {
            [super hideKeyBoard];

        [self performSelector:@selector(doGetCode) withObject:nil afterDelay:0.1];
        
//            text_name.userInteractionEnabled= NO;
//            secondsCountDown = 60;
//            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];

//            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:NO];
            
            //BOOL timeStart = YES;
            
//        } else {
//            
//        }

    }
}

- (void)timeFireMethod
{
	secondsCountDown--;
    
    button_getCode.alpha = 0.7;
    button_getCode.enabled = NO;
    
    NSString *cdStr;
    cdStr = [NSString stringWithFormat:@"%ld秒", (long)secondsCountDown];
    
    [button_getCode setTitle:cdStr forState:UIControlStateDisabled];
    [button_getCode setTitle:cdStr forState:UIControlStateDisabled];
    
	if(secondsCountDown==0){
        button_getCode.alpha = 1;
        button_getCode.enabled = YES;
        
        text_name.userInteractionEnabled= YES;
        
        [button_getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [button_getCode setTitle:@"获取验证码" forState:UIControlStateHighlighted];

        [countDownTimer invalidate];
	}
}


-(void)selectLeftAction:(id)sender
{
    [text_name resignFirstResponder];
    [text_verify resignFirstResponder];
    [text_pwd resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

    -(void) setInputTextField:(NSString*) nameString andRect:(CGRect) rect andType:(NSString*) type andPoint:(UITextField*) text
    {
        //text = [[UITextField alloc]initWithFrame:rect];
        
//        text.borderStyle = UITextBorderStyleNone;
        text.backgroundColor = [UIColor clearColor];
        text.placeholder = nameString;
        text.font = [UIFont fontWithName:@"Arial" size:16.0f];
        text.textColor = [UIColor blackColor];
        text.clearButtonMode = UITextFieldViewModeAlways;
        text.textAlignment = NSTextAlignmentLeft;
        
        if ([@"text"  isEqual: type])
        {
            text.keyboardType=UIKeyboardTypeNumberPad;
        }else if ([@"veri"  isEqual: type]) {
            text.keyboardType=UIKeyboardTypeNumberPad;
        }else if ([@"pwd"  isEqual: type]) {
            text.secureTextEntry = YES;
        }
        
        //首字母是否大写
        text.autocapitalizationType = UITextAutocapitalizationTypeNone;
        //return键变成什么键
        text.returnKeyType =UIReturnKeyDone;
        //键盘外观
        //textView.keyboardAppearance=UIKeyboardAppearanceDefault；
        //设置代理 用于实现协议
        text.delegate = self;
        
        //把textfield加到视图中
        [self.view addSubview:text];
    }

//定义UITextFiled的代理方法：
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (text_verify == textField)
        {
            //这里默认是最多输入4位
            if (range.location >= 4)
                return NO; // return NO to not change text
            return YES;
        }
    else if (text_name == textField)
        {
            NSString *inputStr = string;
            NSString *text =text_name.text;
            NSString *textStr;
            NSInteger location;
            
            if ([@""  isEqual: inputStr]) {
                NSInteger strLength = text.length;
                if ([text length] > strLength-1) {
                    
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
                button_getCode.alpha = 1;
                button_getCode.enabled = YES;
            } else if (range.location <= 10) {
                button_getCode.alpha = 0.7;
                button_getCode.enabled = NO;
                return YES;
            } else if (range.location > 10) {
                return NO;
            }

            return YES;
        }else {
            // 密码15位
            if (range.location >= 12)
                return NO; // return NO to not change text
            return YES;
        }
}

-(void)doGetCode
{
    // 先转菊花
    [Utilities showProcessingHud:self.view];
    
    /*   曾经的明文传 改为加密
    @"Register", @"ac",
    @"2", @"v",
    @"code", @"op",
    text_name.text, @"mobile",
    */
    
    /**   新的
     //  mobile   Base64  DIY
     //  md5mobile   第一位 0 第二位sid 第三位 手机号 以上三个变量 md6 16位加密
     */
    
    NSString *md5mobile = [Utilities md5:[NSString stringWithFormat:@"0%@%@",G_SCHOOL_ID,text_name.text]];
    NSString *mobile = [Utilities encryptionDIY:text_name.text];
    NSDictionary *data = @{
                           @"ac":@"Register",
                           @"v":@"2",
                           @"op":@"desmd5code",
                           @"md5mobile":md5mobile,
                           @"mobile":mobile,
                           };

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
            text_name.userInteractionEnabled= NO;
            //secondsCountDown = 60;
            secondsCountDown = 180;//2015.08.26
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        } else {
            NSString* message_info = [respDic objectForKey:@"message"];
            
            [self.view makeToast:message_info
                        duration:2.5
                        position:@"center"
                           title:nil];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
}

-(void)doVerifyCode
{
    // 先转菊花
    [Utilities showProcessingHud:self.view];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Register", @"ac",
                          @"2", @"v",
                          @"register", @"op",
                          text_name.text, @"username",
                          text_verify.text, @"code",
                          text_pwd.text, @"password",
                          text_name.text, @"mobile",
                          @"1", @"token",
                          @"4", @"device",
                          @"3", @"version",
                          nil];

    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            
            DataReport *dr = [DataReport sharedGlobalSingletonDataReport];
            [dr dataReportActiontype:@"register"];
            
            [ReportObject event:ID_REGISTER];// 2015.06.23
            
            // 注册成功返回
            NSDictionary* message_info = [respDic objectForKey:@"message"];
            
            NSString *uid = [message_info objectForKey:@"uid"];
            NSString *username = [message_info objectForKey:@"username"];
            
            // 保存token
            NSString* token= [message_info objectForKey:@"token"];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:token forKey:USER_LOGIN_TOKEN];
            [userDefaults synchronize];
            
            //-----add by kate 2015.05.05--------------------------------------------------------
            NSString *schoolType = [NSString stringWithFormat:@"%@",[message_info objectForKey:@"type"]];
            NSString *oldType = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"schoolType"]];
            if (![schoolType isEqualToString:oldType]) {
                [[NSUserDefaults standardUserDefaults] setObject:schoolType forKey:@"schoolType"];
            }
            //-----------------------------------------------------------------------------------
            
            // add by ht 20140915 为了确定登录状态，增加userDefaults变量
            // 保存uid
            NSString *regUid = uid;
            
            [[NSUserDefaults standardUserDefaults] setObject:regUid forKey:[NSString stringWithFormat:@"zhixiao_regUid"]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 保存用户名和密码
            NSDictionary *regNamePwd = [[NSDictionary alloc] initWithObjectsAndKeys:text_name.text, @"username", text_pwd.text, @"password", uid, @"uid", nil];
            
            [[NSUserDefaults standardUserDefaults] setObject:regNamePwd forKey:[NSString stringWithFormat:@"zhixiao_regNamePwd_%@", uid]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 将用户名,密码,uid,保存到UserDefaults里面，以便下一次自动登录
            NSDictionary *userLoginNamePwd = [[NSDictionary alloc] initWithObjectsAndKeys:text_name.text, @"username", text_pwd.text, @"password", uid, @"uid", nil];
            
            [[NSUserDefaults standardUserDefaults] setObject:userLoginNamePwd forKey:G_NSUserDefaults_UserLoginInfo];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 保存程序内部唯一的合法uid。
            [[NSUserDefaults standardUserDefaults] setObject:uid forKey:G_NSUserDefaults_UserUniqueUid];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 绑定百度云推送 add by kate
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_BIND_BAIDU_PUSH object:nil];
            
            SetIdentityViewController *idViewCtrl = [[SetIdentityViewController alloc] init];
            [self.navigationController pushViewController:idViewCtrl animated:YES];

            //        SetPersonalViewController *personalViewCtrl = [[SetPersonalViewController alloc] init];
            //        [self.navigationController pushViewController:personalViewCtrl animated:YES];
            //        personalViewCtrl.title = @"个人信息完善";
            
//            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
//                                                           message:@"注册成功"
//                                                          delegate:self
//                                                 cancelButtonTitle:@"完善个人资料"
//                                                 otherButtonTitles:nil];
//            [alert show];
            
            //---------2015.11.11 kate--------------------------------------------------------------------------------
            MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate checkAllRedPoints];
            //---------------------------------------------------------------------------------------------------------
            
            
        } else {
            NSString *message_info = [respDic objectForKey:@"message"];
            
            if ([message_info isEqualToString:@""]) {// add by kate 2015.1.14
                
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                               message:@"网络异常,请再试一次"
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
                [alert show];
                
            }else{
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                               message:message_info
                                                              delegate:nil
                                                     cancelButtonTitle:@"修改注册信息"
                                                     otherButtonTitles:nil];
                [alert show];
            }
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];

    
    
#if 0
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Register", @"ac",
                          @"2", @"v",
                          @"verify", @"op",
                          text_name.text, @"mobile",
                          text_verify.text,@"code",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            // 返回true 则认为code验证成功
            //            NSDictionary* message_info = [resultJSON objectForKey:@"message"];
            NSString *phone = text_name.text;
            
            [g_userInfo setUserPhoneNum:phone];
            
            // 成功，到注册用户名页面
            RegiestViewController *regViewCtrl = [[RegiestViewController alloc] init];
            [self.navigationController pushViewController:regViewCtrl animated:YES];
            regViewCtrl.title = @"用户注册";
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
#endif
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    [Utilities dismissProcessingHud:self.view];
    
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    NSString *protocol = [resultJSON objectForKey:@"protocol"];

    if([@"RegisterAction.code" isEqual: protocol])
    {
        if(true == [result intValue])
        {
            NSString* message_info = [resultJSON objectForKey:@"message"];
            
            [self.view makeToast:message_info
                        duration:2.5
                        position:@"center"
                           title:@"获取成功"];
            text_name.userInteractionEnabled= NO;
            //secondsCountDown = 60;
            secondsCountDown = 180;//2015.08.26
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        }
        else
        {
            NSString* message_info = [resultJSON objectForKey:@"message"];
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:message_info
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
    else if([@"RegisterAction.verify" isEqual: protocol])
    {
        if(true == [result intValue])
        {
            // 返回true 则认为code验证成功
//            NSDictionary* message_info = [resultJSON objectForKey:@"message"];
            NSString *phone = text_name.text;
            
            [g_userInfo setUserPhoneNum:phone];
            
            // 成功，到注册用户名页面
            RegiestViewController *regViewCtrl = [[RegiestViewController alloc] init];
            [self.navigationController pushViewController:regViewCtrl animated:YES];
            regViewCtrl.title = @"用户注册";
        }
        else
        {
            NSString* message_info = [resultJSON objectForKey:@"message"];

            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:message_info
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void)reciveHttpDataError:(NSError*)err
{
    [Utilities dismissProcessingHud:self.view];
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                   message:@"网络连接错误，请稍候再试"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    [alert show];
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

//// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return NO;
}
////
//// 是否支持横竖屏显示
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
