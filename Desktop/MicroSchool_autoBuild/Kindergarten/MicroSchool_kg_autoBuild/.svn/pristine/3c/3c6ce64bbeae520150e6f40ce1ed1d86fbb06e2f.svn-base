//
//  GetBackPwdViewController.m
//  MicroSchool
//
//  Created by jojo on 14-7-27.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "GetBackPwdViewController.h"

@interface GetBackPwdViewController ()

@end

@implementation GetBackPwdViewController

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

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow1:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide1:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


-(void)dealloc
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super setCustomizeTitle:@"找回密码"];
    [super setCustomizeLeftButton];

    [text_name becomeFirstResponder];
}

-(void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[ UIScreen mainScreen] .applicationFrame] ;
    NSLog(@"height = %f",[ UIScreen mainScreen].applicationFrame.size.height);
    NSLog(@"width = %f",[ UIScreen mainScreen].applicationFrame.size.width);
    NSLog(@"x = %f",[ UIScreen mainScreen].applicationFrame.origin.x);
    NSLog(@"y = %f",[ UIScreen mainScreen].applicationFrame.origin.y);
    
    self.view = view;
    
    // 设置背景scrollView
    scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH ,HEIGHT - 44)];
    scrollerView.contentSize = CGSizeMake(WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44);
    scrollerView.scrollEnabled = YES;
    scrollerView.delegate = self;
    scrollerView.bounces = YES;
    scrollerView.alwaysBounceHorizontal = NO;
    scrollerView.alwaysBounceVertical = YES;
    scrollerView.directionalLockEnabled = YES;
    [self.view addSubview:scrollerView];
    
#define LABEL_Y_OFFSET		(40)
    
    // 手机号
    UIImageView *imageView_label=[[UIImageView alloc] initWithFrame:CGRectMake(30, LABEL_Y_OFFSET, 260, 40)];
//#319根据新UI注释掉背景图片
//    UIImage *images_label=[UIImage imageNamed:@"bg_account.png"];
//    [imageView_label setImage:images_label];
    [scrollerView addSubview:imageView_label];
    
    CGRect rect_number = CGRectMake(
                                    20,
                                    imageView_label.frame.origin.y + (imageView_label.frame.size.height - 20)/2,
                                    WIDTH-40,
                                    20);
    text_name = [[UITextField alloc]initWithFrame:rect_number];
    [self setInputTextField:@"手机号码" andRect:rect_number andType:@"text" andPoint:text_name];
//#319横线1
    CGRect len1 = CGRectMake(
                             20,
                             imageView_label.frame.origin.y + (imageView_label.frame.size.height - 20)/2+30,
                             WIDTH-40,
                             1);
    UILabel *lable1 = [[UILabel alloc]initWithFrame:len1];
    lable1.backgroundColor =[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1.0];
    [scrollerView addSubview:lable1];
    
    // 验证码
    UIImageView  *imageView_label_verify=[[UIImageView alloc] initWithFrame:CGRectMake(
                                                                                       20,
                                                                                       imageView_label.frame.origin.y + imageView_label.frame.size.height + 10,
                                                                                       WIDTH-40,
                                                                                       40)];
//    UIImage *images_label_verify=[UIImage imageNamed:@"bg_account.png"];
//    
//    [imageView_label_verify setImage:images_label_verify];
    [scrollerView addSubview:imageView_label_verify];
    
    CGRect rect_verify = CGRectMake(
                                    20,
                                    imageView_label_verify.frame.origin.y + (imageView_label_verify.frame.size.height - 20)/2,
                                    WIDTH-40,
                                    20);
//#319横线2
    CGRect len2 = CGRectMake(
                             20,
                             imageView_label_verify.frame.origin.y + (imageView_label_verify.frame.size.height - 20)/2+30,
                             WIDTH-40,
                             1);
    UILabel *lable2 = [[UILabel alloc]initWithFrame:len2];
    lable2.backgroundColor =[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1.0];
    [scrollerView addSubview:lable2];
    
    text_verify = [[UITextField alloc]initWithFrame:rect_verify];
    [self setInputTextField:@"验证码" andRect:rect_verify andType:@"veri" andPoint:text_verify];
    
    // 新密码
    UIImageView *imageView_label_newPwd=[[UIImageView alloc] initWithFrame:CGRectMake(
                                                                                      20,
                                                                                      imageView_label_verify.frame.origin.y + imageView_label_verify.frame.size.height + 10,
                                                                                      WIDTH-40,
                                                                                      40)];
    [scrollerView addSubview:imageView_label_newPwd];
    
    CGRect rect_number_newPwd = CGRectMake(
                                    20,
                                    imageView_label_newPwd.frame.origin.y + (imageView_label_newPwd.frame.size.height - 20)/2,
                                    WIDTH-40,
                                    20);
//#319横线3
    CGRect len3 = CGRectMake(
                             20,
                            imageView_label_newPwd.frame.origin.y + (imageView_label_newPwd.frame.size.height - 20)/2+30,
                             WIDTH-40,
                             1);
    UILabel *lable3 = [[UILabel alloc]initWithFrame:len3];
    lable3.backgroundColor =[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1.0];
    [scrollerView addSubview:lable3];
    text_newPwd = [[UITextField alloc]initWithFrame:rect_number_newPwd];
    [self setInputTextField:@"新密码" andRect:rect_number_newPwd andType:@"pwd" andPoint:text_newPwd];
    text_newPwd.secureTextEntry = YES;
    [text_newPwd becomeFirstResponder];

    // check box
    //    SSCheckBoxView *cb = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(35, LABEL_Y_OFFSET + 50 + 50, 28, 28) style:kSSCheckBoxViewStyleMono checked:YES];
    //    [self.view addSubview:cb];
    
    // 隐私条款label
    //    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(72, LABEL_Y_OFFSET + 50 + 50, 240, 30)];
    //    label.text = @"已阅读并同意使用条款和隐私政策";
    //    label.font = [UIFont fontWithName:@"Arial" size:13.0f];
    //    label.textColor = [UIColor blackColor];
    //    [self.view addSubview:label];
    
    // 下一步button
    button_create = [UIButton buttonWithType:UIButtonTypeCustom];
    button_create.frame = CGRectMake(
                                     20,
                                     imageView_label_newPwd.frame.origin.y + imageView_label_newPwd.frame.size.height + 20,
                                     WIDTH-40,
                                     40);
    //button.center = CGPointMake(160.0f, 140.0f);
    
    // 设置aligment 属性
    //button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    button_create.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置title自适应对齐
    button_create.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [button_create setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button_create setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button_create.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    
    [button_create setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal] ;
    [button_create setBackgroundImage:[UIImage imageNamed:@"btn_common_1_p.png"] forState:UIControlStateHighlighted] ;
    
    // 添加 action
    [button_create addTarget:self action:@selector(getBackPwd_btnclick) forControlEvents: UIControlEventTouchUpInside];
    
    //设置title
    [button_create setTitle:@"找回" forState:UIControlStateNormal];
    [button_create setTitle:@"找回" forState:UIControlStateHighlighted];
    //[button_create setUserInteractionEnabled:NO];
    
    [scrollerView addSubview:button_create];
    
    // 获取code button
    button_getCode = [UIButton buttonWithType:UIButtonTypeCustom];
    button_getCode.frame = CGRectMake(WIDTH-100, LABEL_Y_OFFSET + 50, 100, 40);
    //button.center = CGPointMake(160.0f, 140.0f);
    
    // 设置aligment 属性
    //button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    button_getCode.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置title自适应对齐
    button_getCode.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [button_getCode setTitleColor:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button_getCode setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button_getCode.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    
//    [button_getCode setBackgroundImage:[UIImage imageNamed:@"btn_common_2-d.png"] forState:UIControlStateNormal] ;
//    [button_getCode setBackgroundImage:[UIImage imageNamed:@"btn_common_2_p.png"] forState:UIControlStateHighlighted] ;
    
    // 添加 action
    [button_getCode addTarget:self action:@selector(getCode_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    
    button_getCode.alpha = 0.7;
    button_getCode.enabled = NO;
    
    //设置title
    [button_getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [button_getCode setTitle:@"获取验证码" forState:UIControlStateHighlighted];
    
    [scrollerView addSubview:button_getCode];
    
    [text_name becomeFirstResponder];
    
    if (!iPhone5) {
        scrollerView.contentSize = CGSizeMake(WIDTH, [UIScreen mainScreen].applicationFrame.size.height+20);
    }
}

-(void) setInputTextField:(NSString*) nameString andRect:(CGRect) rect andType:(NSString*) type andPoint:(UITextField*) text
{
    text.borderStyle = UITextBorderStyleNone;
    text.backgroundColor = [UIColor clearColor];
    text.placeholder = nameString;
    text.font = [UIFont fontWithName:@"Arial" size:15.0f];
    text.textColor = [UIColor blackColor];
    if ([@"获取验证码" isEqualToString:nameString]) {
        text.clearButtonMode = UITextFieldViewModeAlways;
    }
    
    text.textAlignment = NSTextAlignmentLeft;
    if ([@"text"  isEqual: type])
    {
        text.keyboardType=UIKeyboardTypeNumberPad;
    }
    else if ([@"veri"  isEqual: type])
    {
        text.keyboardType=UIKeyboardTypeNumberPad;
    }
    else if ([@"pwd"  isEqual: type])
    {
        text.keyboardType=UIKeyboardTypeDefault;
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
    [scrollerView addSubview:text];
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
        [super hideKeyBoard];
        // 先转菊花
        [Utilities showProcessingHud:self.view];
        
        [self performSelector:@selector(doGetCode) withObject:nil afterDelay:0.1];
    }
}

- (void)timeFireMethod
{
	secondsCountDown--;
    
    button_getCode.alpha = 0.7;
    button_getCode.enabled = NO;
    
    NSString *cdStr;
    cdStr = [NSString stringWithFormat:@"%d秒", secondsCountDown];
    
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
    } else {
        //这里默认是最多输入12位
        if (range.location >= 12)
            return NO; // return NO to not change text
        return YES;
    }
}

-(void)doGetCode
{
#if NETWORKING_REFACTORING
    /**  old  方法
     @"Password", @"ac",
     @"forget", @"op",
     */
    
    /**   新的
     //  mobile   Base64  DIY
     //  md5mobile   第一位 0 第二位sid 第三位 手机号 以上三个变量 md6 16位加密
     */
    
    NSString *md5mobile = [Utilities md5:[NSString stringWithFormat:@"0%@%@",G_SCHOOL_ID,text_name.text]];
    NSString *mobile = [Utilities encryptionDIY:text_name.text];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Password", @"ac",
                          @"forgets", @"op",
                          mobile, @"mobile",
                          md5mobile,@"md5mobile",
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
                           title:nil];
            text_name.userInteractionEnabled= NO;
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
#else
    /**  old  方法
     @"Password", @"ac",
     @"forget", @"op",
     */
    
    /**   新的
     //  mobile   Base64  DIY
     //  md5mobile   第一位 0 第二位sid 第三位 手机号 以上三个变量 md6 16位加密
     */
    
    NSString *md5mobile = [Utilities md5:[NSString stringWithFormat:@"0%@%@",G_SCHOOL_ID,text_name.text]];
    NSString *mobile = [Utilities encryptionDIY:text_name.text];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Password", @"ac",
                          @"forgets", @"op",
                          text_name.text, @"mobile",
                          md5mobile,@"md5mobile"
                          nil];
    
    [network sendHttpReq:HttpReq_GetbackPasswordCode andData:data];
#endif
}

-(void)getBackPwd_btnclick
{
    button_create.enabled = NO;

    if(text_name.text.length == 0) {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                      message:@"手机号不能为空，请重新输入"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
        button_create.enabled = YES;
    }else if (text_verify.text.length == 0)
    {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                      message:@"验证码为空，请重新输入"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
        button_create.enabled = YES;
    }else if (text_newPwd.text.length <6) {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                      message:@"密码小于6位，请重新输入"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
        button_create.enabled = YES;
    }else {
        [text_newPwd resignFirstResponder];
        [super hideKeyBoard];

        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Password", @"ac",
                              @"resetting", @"op",
                              text_name.text, @"mobile",
                              text_verify.text,@"code",
                              text_newPwd.text,@"password",
                              nil];
        
        [network sendHttpReq:HttpReq_GetbackPasswordReset andData:data];
    }
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    [Utilities dismissProcessingHud:self.view];
    button_create.enabled = YES;
    
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if([@"PasswordAction.forget" isEqualToString:[resultJSON objectForKey:@"protocol"]])
    {
        if(true == [result intValue])
        {
            NSString* message_info = [resultJSON objectForKey:@"message"];
            
            [self.view makeToast:message_info
                        duration:2.5
                        position:@"center"
                           title:nil];
            text_name.userInteractionEnabled= NO;
            //secondsCountDown = 60;
            secondsCountDown = 180;//2015.08.26
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            
            // test code
            //            text_verify.text = code.stringValue;
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
    else if([@"PasswordAction.resetting" isEqualToString:[resultJSON objectForKey:@"protocol"]])
    {
        if(true == [result intValue])
        {
            // 返回true 则认为code验证成功
            NSString* message_info = [resultJSON objectForKey:@"message"];
            
            [self.view makeToast:message_info
                        duration:1.5
                        position:@"center"
                           title:nil];

            [self performSelector:@selector(doBack) withObject:nil afterDelay:1.0];

            // 成功找回，gps上报
            DataReport *dr = [DataReport sharedGlobalSingletonDataReport];
            [dr dataReportGPStype:DataReport_Act_GetBackPwd];
            
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

-(void)doBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardWillShow1:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         
                         CGSize frame = scrollerView.contentSize;
                         
                         frame.height += 75;
                         //                         frame.height -= keyboardRect.size.height;
                         scrollerView.contentSize = frame;
                         
                         //                         keyboardHeight = keyboardRect.size.height;
                     }];
}

- (void)keyboardWillHide1:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGSize frame = scrollerView.contentSize;
                         
                         frame.height -= 75;
                         scrollerView.contentSize = frame;
                         
                         //                         keyboardHeight = keyboardRect.size.height;
                         //
                         //                         keyboardHeight = 0;
                     }];
}

@end
