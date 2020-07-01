//
//  CommentViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-7.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()

@end

@implementation CommentViewController

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
    [super setCustomizeTitle:@"意见反馈"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super hideLeftAndRightLine];
    [super setCustomizeLeftButton];
    // 导航右菜单，提交
    [super setCustomizeRightButton:@"icon_send.png"];
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

-(void)selectRightAction:(id)sender
{
    if ([@""  isEqual: text_content.text]) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"反馈内容不能为空，请重试。"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    } else {
        [self hideKeyBoard];
        [Utilities showProcessingHud:self.view];
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Feedback", @"ac",
                              @"admin", @"op",
                              text_content.text, @"message",
                              nil];
        
        [network sendHttpReq:HttpReq_Feedback andData:data];
    }
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
    
//    GlobalSingletonUserInfo* g_userSettingInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
//    NSMutableDictionary *settingPersonalInfo = [g_userSettingInfo getUserSettingPersonalInfo];
//    
//    NSString *spacenote = [settingPersonalInfo objectForKey:@"spacenote"];

    //text_content.text = spacenote;
//    text_content.placeholder = @"随便提点什么意见吧";

    text_content.textColor = [UIColor blackColor];
    
    //设置代理 需在interface中声明UITextViewDelegate
    text_content.delegate = self;
    
    //字体大小
    text_content.font = [UIFont fontWithName:@"Arial" size:15.0f];
    
    //是否可以滚动
    text_content.scrollEnabled = NO;
    text_content.returnKeyType = UIReturnKeyDone;
    //获得焦点
    [text_content performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.01];
    
    [self.view addSubview:text_content];
    
    // 剩余字数
    label_leftNum = [[UILabel alloc] initWithFrame:CGRectMake(imgView_input.frame.origin.x + imgView_input.frame.size.width - 55, imgView_input.frame.origin.y + imgView_input.frame.size.height - 25, 60, 20)];
    
    NSInteger num = 40;
    
    label_leftNum.text = [NSString stringWithFormat: @"剩余%d", num];
    label_leftNum.font = [UIFont systemFontOfSize:15];
    label_leftNum.textColor = [UIColor grayColor];
    label_leftNum.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label_leftNum];
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    if (range.location>39)
    {
//        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
//                                                       message:@"反馈过长了哦"
//                                                      delegate:nil
//                                             cancelButtonTitle:@"确定"
//                                             otherButtonTitles:nil];
//        [alert show];
        
        return NO;
    }
    else
    {
//        NSInteger aaa = range.length;
        NSInteger bbb = range.location;
        NSString *test = text;
        
        NSInteger left = 40 - range.location - 1;
        if (0 == bbb) {
            label_leftNum.text = [NSString stringWithFormat: @"剩余%d",40 - [test length]];
        }
        else {
            label_leftNum.text = [NSString stringWithFormat: @"剩余%d",left];
        }
        return YES;
    }
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    [Utilities dismissProcessingHud:self.view];
    
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    //NSString* message_info = [resultJSON objectForKey:@"message"];
    NSString *msg = [resultJSON objectForKey:@"message"];

    if(true == [result intValue])
    {
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:msg
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
        
        // 反馈成功，gps上报
        DataReport *dr = [DataReport sharedGlobalSingletonDataReport];
        [dr dataReportGPStype:DataReport_Act_FeedBack];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:msg
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
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

@end
