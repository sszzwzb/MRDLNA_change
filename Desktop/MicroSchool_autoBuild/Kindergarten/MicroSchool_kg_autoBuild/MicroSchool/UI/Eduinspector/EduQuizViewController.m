//
//  EduQuizViewController.m
//  MicroSchool
//
//  Created by jojo on 14-8-29.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "EduQuizViewController.h"

@interface EduQuizViewController ()

@end

@implementation EduQuizViewController

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
    [super setCustomizeTitle:@"我要提问"];
    [super setCustomizeLeftButton];
}

-(void)selectLeftAction:(id)sender
{
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        [self disablesAutomaticKeyboardDismissal];//iOS9还要加上此方法
        // 退回到上个画面
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        // 退回到上个画面
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

/*! UIViewController的方法 2015.07.04*/
- (BOOL)disablesAutomaticKeyboardDismissal{
    
    //当以下这些语句都不好用时用此方法使键盘消失 iOS9
    [self.view endEditing:YES];
    [text_content resignFirstResponder];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    
    return NO;
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
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    
    _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH , [UIScreen mainScreen].applicationFrame.size.height - 44)];
    
    _scrollerView.contentSize = CGSizeMake(WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44);
    
    _scrollerView.scrollEnabled = YES;
    _scrollerView.delegate = self;
    [self.view addSubview:_scrollerView];

    // 背景图片
//    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,[UIScreen mainScreen].applicationFrame.size.height - 44)];
//    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
//    [self.view addSubview:imgView_bgImg];
    
    // 输入框背景图
    UIImageView *imgView_input = [[UIImageView alloc]initWithFrame:CGRectMake(10,20,300,150)];
    imgView_input.image=[UIImage imageNamed:@"bg_account.png"];
    [_scrollerView addSubview:imgView_input];
    
    //初始化
    text_content = [[UITextView alloc] initWithFrame:CGRectMake(imgView_input.frame.origin.x + 3,
                                                                imgView_input.frame.origin.y + 3,
                                                                imgView_input.frame.size.width - 6,
                                                                imgView_input.frame.size.height - 6)];
    text_content.backgroundColor = [UIColor clearColor];
    
    //    GlobalSingletonUserInfo* g_userSettingInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
    //    NSMutableDictionary *settingPersonalInfo = [g_userSettingInfo getUserSettingPersonalInfo];
    //
    //    NSString *spacenote = [settingPersonalInfo objectForKey:@"spacenote"];
    
    //text_content.text = spacenote;
//    text_content.placeholder = @"请输入提问内容";
    
    text_content.textColor = [UIColor blackColor];
    
    //设置代理 需在interface中声明UITextViewDelegate
    text_content.delegate = self;
    
    //字体大小
    text_content.font = [UIFont fontWithName:@"Arial" size:15.0f];
    
    //是否可以滚动
    text_content.scrollEnabled = YES;
    text_content.returnKeyType = UIReturnKeyDone;
    //获得焦点
    [text_content performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.01];
    
    [_scrollerView addSubview:text_content];
    
    // 剩余字数
//    label_leftNum = [[UILabel alloc] initWithFrame:CGRectMake(imgView_input.frame.origin.x + imgView_input.frame.size.width - 55, imgView_input.frame.origin.y + imgView_input.frame.size.height - 25, 60, 20)];
//    
//    NSInteger num = 40;
//    
//    label_leftNum.text = [NSString stringWithFormat: @"剩余%d", num];
//    label_leftNum.font = [UIFont systemFontOfSize:15];
//    label_leftNum.textColor = [UIColor grayColor];
//    label_leftNum.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:label_leftNum];
    
    
    UILabel *label_note = [[UILabel alloc] initWithFrame:
                           CGRectMake(imgView_input.frame.origin.x,
                                      imgView_input.frame.origin.y+imgView_input.frame.size.height+5,
                                      300,
                                      40)];
    
    label_note.text = @"督学人员将尽快回复您的留言，同时内容将显示在问答页面中。";
    label_note.font = [UIFont systemFontOfSize:14];
    label_note.lineBreakMode = NSLineBreakByWordWrapping;
    label_note.numberOfLines = 0;

    label_note.textColor = [UIColor blackColor];
    label_note.backgroundColor = [UIColor clearColor];
    [_scrollerView addSubview:label_note];

    UIButton *btnQusetion = [UIButton buttonWithType:UIButtonTypeCustom];
    btnQusetion.frame = CGRectMake(40, label_note.frame.origin.y + label_note.frame.size.height + 10, 240, 40);
    
    btnQusetion.tag = 999;
    btnQusetion.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置title自适应对齐
    btnQusetion.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [btnQusetion setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnQusetion setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    btnQusetion.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [btnQusetion setBackgroundImage:[UIImage imageNamed:@"btn_common_2-d.png"] forState:UIControlStateNormal] ;
    [btnQusetion setBackgroundImage:[UIImage imageNamed:@"btn_common_2_p.png"] forState:UIControlStateHighlighted] ;
    
    // 添加 action
    [btnQusetion addTarget:self action:@selector(sendMsg_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    
    //设置title
    [btnQusetion setTitle:@"确定" forState:UIControlStateNormal];
    [btnQusetion setTitle:@"确定" forState:UIControlStateHighlighted];
    
    [_scrollerView addSubview:btnQusetion];

    if (!iPhone5) {
        _scrollerView.contentSize = CGSizeMake(WIDTH, [UIScreen mainScreen].applicationFrame.size.height+50);
    }
}

- (IBAction)sendMsg_btnclick:(id)sender
{
    if(text_content.text.length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"请输入提问内容"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    } else {
        
        [ReportObject event:ID_QUESTION_EDU];//2015.06.24
        [Utilities showProcessingHud:self.view];// 2015.05.12
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Eduinspector", @"ac",
                              @"interraction", @"op",
                              _insUid, @"aid",
                              @"0", @"rid",
                              text_content.text, @"message",
                              nil];
        
        [network sendHttpReq:HttpReq_EduinspectorDoInterractions andData:data];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    if (range.location >= 5000)//督学发帖 5000 2015.07.21
    {
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
   
    [Utilities dismissProcessingHud:self.view];// 2015.05.12
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    //NSString* message_info = [resultJSON objectForKey:@"message"];
    NSString *msg = [resultJSON objectForKey:@"message"];
    
    if(true == [result intValue])
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"成功"
                                                       message:msg
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
        
        // 提问成功，gps上报
        DataReport *dr = [DataReport sharedGlobalSingletonDataReport];
        [dr dataReportGPStype:DataReport_Act_SendQuestion];
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
    
    [Utilities dismissProcessingHud:self.view];// 2015.05.12
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                   message:@"网络连接错误，请稍候再试"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    [alert show];
}

@end
