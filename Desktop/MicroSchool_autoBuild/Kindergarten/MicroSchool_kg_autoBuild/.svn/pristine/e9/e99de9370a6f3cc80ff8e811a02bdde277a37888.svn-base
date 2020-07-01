//
//  SettingSpacenoteViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-31.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "SettingSpacenoteViewController.h"
#import "FRNetPoolUtils.h"

@interface SettingSpacenoteViewController ()

@end

@implementation SettingSpacenoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // 导航右菜单，提交
        
        network = [NetworkUtility alloc];
        network.delegate = self;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.e
    [super setCustomizeTitle:@"个性签名"];
    [super setCustomizeLeftButton];
    
    if ([self.fromName isEqualToString:@"dutyForInspector"]) {
        [super setCustomizeTitle:@"基本职责"];
    }
    
    [super setCustomizeRightButtonWithName:@"保存"];

}

-(void)selectRightAction:(id)sender
{
    [text_content resignFirstResponder];
    
    if ([self.fromName isEqualToString:@"dutyForInspector"]) {
        
        if (0 == [text_content.text length]) {
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"请输入基本职责"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
            
        }else {
            
            [self saveToServer];
            
        }
        
    }else{
        
#if 0
        if (0 == [text_content.text length]) {
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"请输入个性签名"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
            
        }else {
#endif
            [text_content resignFirstResponder];
            
            self.navigationItem.rightBarButtonItem.enabled = NO;
            
            [Utilities showProcessingHud:self.view];
            
            /*NSMutableDictionary *settingPersonalInfo = [g_userInfo getUserSettingPersonalInfo];
             
             [settingPersonalInfo setObject:text_title.text forKey:@"name"];
             
             [g_userInfo setUserSettingPersonalInfo:settingPersonalInfo];
             
             [self.navigationController popViewControllerAnimated:YES];*/
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Profile", @"ac",
                                  @"2", @"v",
                                  @"update", @"op",
                                  text_content.text,@"spacenote",
                                  nil];
            
            [network sendHttpReq:HttpReq_ProfileUpdate andData:data];
            
            
        }
        
#if 0
    }
#endif
}

-(void)selectLeftAction:(id)sender
{
    [network cancelCurrentRequest];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// add by kate 2014.10.23
-(void)saveToServer{
    
    [text_content resignFirstResponder];
    
    [Utilities showProcessingHud:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *phone = @"";
        NSString *job = @"";
        NSString *company = @"";
        NSString *duty = text_content.text;
        NSString *photo = @"";
        NSString *email = @"";
        
        // 个人信息保存接口
        NSString *msg = [FRNetPoolUtils updateProfile:phone job:job company:company duty:duty photoPath:photo email:email];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities dismissProcessingHud:self.view];
            
            if (msg!=nil) {
                
                [Utilities showAlert:@"错误" message:msg cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                NSMutableDictionary *tempDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"infoForInspector"];
                NSMutableDictionary *settingPersonalInfo = [[NSMutableDictionary alloc]initWithDictionary:tempDic copyItems:YES];
                
                [settingPersonalInfo setObject:text_content.text forKey:@"duty"];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:settingPersonalInfo forKey:@"infoForInspector"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshEduinspectorInfo" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
                
                [ReportObject event:ID_SET_EDU_PERSON];//2015.06.25
                
            }
            
        });
    });
    
}

-(void)submitAction:(id)sender
{
    [text_content resignFirstResponder];
    
    if ([self.fromName isEqualToString:@"dutyForInspector"]) {
        
        if (0 == [text_content.text length]) {
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"请输入基本职责"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
            
        }else {
            
            [self saveToServer];
            
        }
        
    }else{
        
#if 0
        if (0 == [text_content.text length]) {
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"请输入个性签名"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
            
        }else {
#endif
            [text_content resignFirstResponder];
            
            self.navigationItem.rightBarButtonItem.enabled = NO;
            
            [Utilities showProcessingHud:self.view];
            
            /*NSMutableDictionary *settingPersonalInfo = [g_userInfo getUserSettingPersonalInfo];
             
             [settingPersonalInfo setObject:text_title.text forKey:@"name"];
             
             [g_userInfo setUserSettingPersonalInfo:settingPersonalInfo];
             
             [self.navigationController popViewControllerAnimated:YES];*/
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Profile", @"ac",
                                  @"2", @"v",
                                  @"update", @"op",
                                  text_content.text,@"spacenote",
                                  nil];
            
            [network sendHttpReq:HttpReq_ProfileUpdate andData:data];
            
            
        }
        
#if 0
    }
#endif
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    
    // 背景图片
    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height - 44)];
    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    [self.view addSubview:imgView_bgImg];
    
    // 输入框背景图
    UIImageView *imgView_input = [[UIImageView alloc]initWithFrame:CGRectMake(10,20,300,150)];
    imgView_input.image=[UIImage imageNamed:@"bg_account.png"];
    [self.view addSubview:imgView_input];
    
    //初始化
    text_content = [[UITextView alloc] initWithFrame:CGRectMake(imgView_input.frame.origin.x + 3,
                                                                imgView_input.frame.origin.y + 3,
                                                                imgView_input.frame.size.width - 6,
                                                                imgView_input.frame.size.height - 25)];
    text_content.backgroundColor = [UIColor clearColor];
    
    GlobalSingletonUserInfo* g_userSettingInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
    NSMutableDictionary *settingPersonalInfo = [g_userSettingInfo getUserSettingPersonalInfo];
    
    NSString *spacenote = [settingPersonalInfo objectForKey:@"spacenote"];
    
    if (spacenote.length >= 50) {
        spacenote = [spacenote substringToIndex:50];
    }
    
    text_content.text = spacenote;
    
    if ([self.fromName isEqualToString:@"dutyForInspector"]) {
        
        NSMutableDictionary *settingPersonalInfoI = [[NSUserDefaults standardUserDefaults]objectForKey:@"infoForInspector"];
        
        text_content.text = [settingPersonalInfoI objectForKey:@"duty"];
        
        text_content.frame = CGRectMake(imgView_input.frame.origin.x + 3,
                                        imgView_input.frame.origin.y + 3,
                                        imgView_input.frame.size.width - 6,
                                        imgView_input.frame.size.height - 5);
        
    }else{
        
        //是否可以滚动
        text_content.scrollEnabled = NO;
    }
    
    text_content.textColor = [UIColor blackColor];
    
    //设置代理 需在interface中声明UITextViewDelegate
    text_content.delegate = self;
    
    //字体大小
    text_content.font = [UIFont fontWithName:@"Arial" size:15.0f];
    
    
    
    //获得焦点
    [text_content becomeFirstResponder];
    
    if ([self.fromName isEqualToString:@"dutyForInspector"]) {
        
        text_content.returnKeyType = UIReturnKeyDefault;//返回键的类型
        
    }else{
        
        text_content.returnKeyType = UIReturnKeyDone;//返回键的类型
        
    }
    
    [self.view addSubview:text_content];
    
    // 剩余字数
    label_leftNum = [[UILabel alloc] initWithFrame:CGRectMake(imgView_input.frame.origin.x + imgView_input.frame.size.width - 55, imgView_input.frame.origin.y + imgView_input.frame.size.height - 25, 60, 20)];
    
    NSInteger num;
    if (51 == spacenote.length) {
        num = 0;
    } else {
        num = 50 - spacenote.length;
    }
    
    label_leftNum.text = [NSString stringWithFormat: @"剩余%d", num];
    label_leftNum.font = [UIFont systemFontOfSize:15];
    label_leftNum.textColor = [UIColor grayColor];
    label_leftNum.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label_leftNum];
    
    if ([self.fromName isEqualToString:@"dutyForInspector"]) {
        
        label_leftNum.hidden = YES;
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([self.fromName isEqualToString:@"dutyForInspector"]){
        return YES;
    }else{//个性签名
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
        //获取高亮部分内容
        //NSString * selectedtext = [textView textInRange:selectedRange];
        
        //如果有高亮且当前字数开始位置小于最大限制时允许输入
        if (selectedRange && pos) {
            NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
            NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
            NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
            
            if (offsetRange.location < 50) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        
        
        NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
        
        NSInteger caninputlen = 50 - comcatstr.length;
        
        if (caninputlen >= 0)
        {
            return YES;
        }
        else
        {
            NSInteger len = text.length + caninputlen;
            //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
            NSRange rg = {0,MAX(len,0)};
            
            if (rg.length > 0)
            {
                NSString *s = @"";
                //判断是否只普通的字符或asc码(对于中文和表情返回NO)
                BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
                if (asc) {
                    s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
                }
                else
                {
                    __block NSInteger idx = 0;
                    __block NSString  *trimString = @"";//截取出的字串
                    //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                    [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                             options:NSStringEnumerationByComposedCharacterSequences
                                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                              
                                              if (idx >= rg.length) {
                                                  *stop = YES; //取出所需要就break，提高效率
                                                  return ;
                                              }
                                              
                                              trimString = [trimString stringByAppendingString:substring];
                                              
                                              idx++;
                                          }];
                    
                    s = trimString;
                }
                //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
                [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
                //既然是超出部分截取了，哪一定是最大限制了。
                label_leftNum.text = [NSString stringWithFormat:@"%d/%ld",0,(long)50];
            }
            return NO;
        }
 
    }
    
    
}

#if 9
- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > 50)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:50];
        
        [textView setText:s];
    }
    
    //不让显示负数 口口日
    label_leftNum.text = [NSString stringWithFormat:@"剩余%ld",MAX(0,50 - existTextNum)];
}
#endif


#if 0
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([self.fromName isEqualToString:@"dutyForInspector"]) {
        return YES;
    }else{
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            return NO;
        }
        
        if (range.location>100)
        {
            //        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
            //                                                       message:@"签名过长了哦"
            //                                                      delegate:nil
            //                                             cancelButtonTitle:@"确定"
            //                                             otherButtonTitles:nil];
            //        [alert show];
            
            return NO;
        }
        else
        {
            NSInteger aaa = range.length;
            NSInteger bbb = range.location;
            
            NSInteger left = 100 - range.location;
            if (0 == bbb) {
                label_leftNum.text = [NSString stringWithFormat: @"剩余%d",100 - aaa];
            }
            else {
                label_leftNum.text = [NSString stringWithFormat: @"剩余%d",left];
            }
            return YES;
        }
        
    }
    
}
#endif

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    [Utilities dismissProcessingHud:self.view];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    NSError *error;
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    //NSString* message_info = [resultJSON objectForKey:@"message"];
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    if(true == [result intValue])
    {
        GlobalSingletonUserInfo* g_userSettingInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
        NSMutableDictionary *settingPersonalInfo = [g_userSettingInfo getUserSettingPersonalInfo];
        NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
        
        // 更新城市名称到单例
        [settingPersonalInfo setObject:text_content.text forKey:@"spacenote"];
        [userDetail setObject:text_content.text forKey:@"spacenote"];
        
        // 更新单例中得数据
        [g_userSettingInfo setUserPersonalInfo:settingPersonalInfo];
        [g_userInfo setUserDetailInfo:userDetail];
        
        // 修改成功，gps上报
        //            DataReport *dr = [DataReport sharedGlobalSingletonDataReport];
        //            [dr dataReportGPStype:DataReport_Act_SavePersonalInfo];
        
        [self.navigationController popViewControllerAnimated:YES];
        [ReportObject event:ID_SET_PERSON_INFO];//2015.06.25
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"失败"
                                                       message:@"个人信息设置失败"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
    
}

-(void)reciveHttpDataError:(NSError*)err
{
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                   message:@"网络连接错误，请稍候再试"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    [alert show];
}

@end
