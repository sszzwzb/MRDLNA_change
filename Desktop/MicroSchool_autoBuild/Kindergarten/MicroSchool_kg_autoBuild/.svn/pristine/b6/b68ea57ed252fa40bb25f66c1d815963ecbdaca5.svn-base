//
//  SettingNumberViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-1-16.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "SettingNumberViewController.h"

@interface SettingNumberViewController ()

@end

@implementation SettingNumberViewController

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
	// Do any additional setup after loading the view.
    [super setCustomizeTitle:@"身份证号"];
    [super setCustomizeLeftButton];
    [super setCustomizeRightButtonWithName:@"保存"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectRightAction:(id)sender
{
    [text_title resignFirstResponder];
    
    if ([@""  isEqual: text_title.text]) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"输入为空，请重新输入。"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    } else if (text_title.text.length >= 19) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"身份证号码超过19位，请重新输入。"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    } else {
        //        NSMutableDictionary *settingPersonalInfo = [g_userInfo getUserSettingPersonalInfo];
        //        [settingPersonalInfo setObject:text_title.text forKey:@"studentid"];
        //
        //        [g_userInfo setUserSettingPersonalInfo:settingPersonalInfo];
        //
        //        [self.navigationController popViewControllerAnimated:YES];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        [Utilities showProcessingHud:self.view];
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Profile", @"ac",
                              @"2", @"v",
                              @"update", @"op",
                              text_title.text,@"studentid",
                              nil];
        
        [network sendHttpReq:HttpReq_ProfileUpdate andData:data];
        
        
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
    
    tableViewIns = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStyleGrouped];
    tableViewIns.delegate = self;
    tableViewIns.dataSource = self;
    tableViewIns.backgroundColor = [UIColor clearColor];
    tableViewIns.backgroundView = nil;
    [tableViewIns setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    [self.view addSubview:tableViewIns];
    
    //    GlobalSingletonUserInfo* g_userPersonalInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
    //    NSMutableDictionary *personalInfo = [g_userPersonalInfo getUserPersonalInfo];
    //
    //    NSString *name = [personalInfo objectForKey:@"name"];
    if (iPhone5 || ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0))
    {
        text_title = [[UITextField alloc]initWithFrame:CGRectMake(10, 35, WIDTH-20, 50)];
    }
    else
    {
        text_title = [[UITextField alloc]initWithFrame:CGRectMake(15, 24, 310, 50)];
    }
    
    text_title.borderStyle = UITextBorderStyleNone;
    text_title.backgroundColor = [UIColor clearColor];
    text_title.placeholder = @"点击修改身份证号";
    text_title.font = [UIFont fontWithName:@"Arial" size:18.0f];
    text_title.textColor = [UIColor blackColor];
    //text_title.clearButtonMode = UITextFieldViewModeAlways;
    text_title.textAlignment = NSTextAlignmentLeft;
    text_title.keyboardType=UIKeyboardTypeDefault;
    text_title.returnKeyType =UIReturnKeyDone;
    text_title.delegate = self;
    [text_title becomeFirstResponder];
    
    [tableViewIns addSubview:text_title];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSMutableDictionary *personalInfo = [g_userInfo getUserSettingPersonalInfo];
    
    NSString *name = [personalInfo objectForKey:@"studentid"];
    text_title.text = name;
}

-(void)selectLeftAction:(id)sender
{
    [network cancelCurrentRequest];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)submitAction:(id)sender
{
    [text_title resignFirstResponder];
    
    if ([@""  isEqual: text_title.text]) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"输入为空，请重新输入。"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    } else if (text_title.text.length >= 19) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"身份证号码超过19位，请重新输入。"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    } else {
//        NSMutableDictionary *settingPersonalInfo = [g_userInfo getUserSettingPersonalInfo];
//        [settingPersonalInfo setObject:text_title.text forKey:@"studentid"];
//        
//        [g_userInfo setUserSettingPersonalInfo:settingPersonalInfo];
//        
//        [self.navigationController popViewControllerAnimated:YES];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        [Utilities showProcessingHud:self.view];
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Profile", @"ac",
                              @"2", @"v",
                              @"update", @"op",
                              text_title.text,@"studentid",
                              nil];
        
        [network sendHttpReq:HttpReq_ProfileUpdate andData:data];
        
        
    }
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定行的高度
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    //设置textLabel的背景色为空
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}

//选中Cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
}

//定义UITextFiled的代理方法：
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //这里默认是最多输入15位
    if (range.location >= 19)
    {
        NSString *input = string;
        if ([input  isEqual: @""]) {
            return YES;
        }
        return NO;
    }
    return YES;
}

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
        
        [settingPersonalInfo setObject:text_title.text forKey:@"studentid"];
        [userDetail setObject:text_title.text forKey:@"studentid"];
        
        // 更新单例中得数据
        [g_userSettingInfo setUserPersonalInfo:settingPersonalInfo];
        [g_userInfo setUserDetailInfo:userDetail];
        
        //            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"成功"
        //                                                           message:@"个人信息设置成功"
        //                                                          delegate:self
        //                                                 cancelButtonTitle:@"确定"
        //                                                 otherButtonTitles:nil];
        //            [alert show];
        
        // 修改成功，gps上报
        //            DataReport *dr = [DataReport sharedGlobalSingletonDataReport];
        //            [dr dataReportGPStype:DataReport_Act_SavePersonalInfo];
        
        [self.navigationController popViewControllerAnimated:YES];
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
