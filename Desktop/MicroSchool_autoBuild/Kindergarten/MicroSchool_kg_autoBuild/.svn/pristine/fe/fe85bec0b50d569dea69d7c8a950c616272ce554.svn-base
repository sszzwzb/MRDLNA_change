//
//  SettingNameViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-31.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "SettingNameViewController.h"

@interface SettingNameViewController ()

@end

@implementation SettingNameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // 导航右菜单，提交
        network = [NetworkUtility alloc];
        network.delegate = self;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:text_title];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:text_title];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if ([self.fromName isEqualToString:@"qq"]) {
        [super setCustomizeTitle:@"QQ"];
    }else if ([self.fromName isEqualToString:@"groupChatSettingName"]) {
        [super setCustomizeTitle:@"群聊名称"];
    }else if ([self.fromName isEqualToString:@"className"]){
        [super setCustomizeTitle:@"班级名称"];
    }else{
        [super setCustomizeTitle:@"真实姓名"];
    }
    [super setCustomizeLeftButton];
    
    [super setCustomizeRightButtonWithName:@"保存"];

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:text_title];
}

-(void)selectRightAction:(id)sender
{
    [text_title resignFirstResponder];
    
    if ([self.fromName isEqualToString:@"qq"]) {
        
        if (text_title.text.length > 50) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"位数输入过长，请重新输入。"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        } else {
            
            /*NSMutableDictionary *settingPersonalInfo = [g_userInfo getUserSettingPersonalInfo];
             
             [settingPersonalInfo setObject:text_title.text forKey:@"qq"];
             
             [g_userInfo setUserSettingPersonalInfo:settingPersonalInfo];
             
             [self.navigationController popViewControllerAnimated:YES];*/
            
            self.navigationItem.rightBarButtonItem.enabled = NO;
            
            [Utilities showProcessingHud:self.view];
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Profile", @"ac",
                                  @"2", @"v",
                                  @"update", @"op",
                                  text_title.text,@"qq",
                                  nil];
            
            [network sendHttpReq:HttpReq_ProfileUpdate andData:data];
            
        }
        
    }else if ([self.fromName isEqualToString:@"groupChatSettingName"]) {
        if ([@""  isEqual: text_title.text]) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"输入为空，请重新输入。"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }else {
            [Utilities showProcessingHud:self.view];
            self.navigationItem.rightBarButtonItem.enabled = NO;
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"GroupChat",@"ac",
                                  @"2",@"v",
                                  @"setGroupName", @"op",
                                  _gid, @"gid",
                                  text_title.text, @"groupName",
                                  nil];
            
            [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
                [Utilities dismissProcessingHud:self.view];
                self.navigationItem.rightBarButtonItem.enabled = YES;
                
                NSDictionary *respDic = (NSDictionary*)responseObject;
                NSString *result = [respDic objectForKey:@"result"];
                
                if(true == [result intValue]) {
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         text_title.text, @"name",
                                         nil];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_GROUPCHAT_CHANGEGROUPNAME object:self userInfo:dic];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    NSString *msg = [respDic objectForKey:@"message"];
                    [Utilities showFailedHud:msg descView:self.view];
                }
            } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                self.navigationItem.rightBarButtonItem.enabled = YES;
                
                [Utilities doHandleTSNetworkingErr:error descView:self.view];
            }];
        }
    }else if ([self.fromName isEqualToString:@"className"]){//班级名称
        
        /**
         * 修改班级名称
         * 1. 前置条件班级管理员
         * @author luke
         * @date 2015.09.14
         * @args
         *  v=2, ac=Class, op=setClassName, sid=, cid=, uid=, name=班级名称,长度限制40
         *
         */
        if ([@""  isEqual: text_title.text]) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"输入为空，请重新输入。"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }else {
            [Utilities showProcessingHud:self.view];
            self.navigationItem.rightBarButtonItem.enabled = NO;
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"Class",@"ac",
                                  @"2",@"v",
                                  @"setClassName", @"op",
                                  _cid, @"cid",
                                  text_title.text, @"name",
                                  nil];
            
            [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
                [Utilities dismissProcessingHud:self.view];
                self.navigationItem.rightBarButtonItem.enabled = YES;
                
                NSDictionary *respDic = (NSDictionary*)responseObject;
                NSString *result = [respDic objectForKey:@"result"];
                
                if(true == [result intValue]) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyClassInfo" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    NSString *msg = [respDic objectForKey:@"message"];
                    [Utilities showFailedHud:msg descView:self.view];
                }
            } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                self.navigationItem.rightBarButtonItem.enabled = YES;
                
                [Utilities doHandleTSNetworkingErr:error descView:self.view];
            }];
        }
        
    }
    else{
        
        if ([@""  isEqual: text_title.text]) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"输入为空，请重新输入。"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        } else if (text_title.text.length > 8) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"名字超过8位，请重新输入。"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        } else {
            
            /*NSMutableDictionary *settingPersonalInfo = [g_userInfo getUserSettingPersonalInfo];
             
             [settingPersonalInfo setObject:text_title.text forKey:@"name"];
             
             [g_userInfo setUserSettingPersonalInfo:settingPersonalInfo];
             
             [self.navigationController popViewControllerAnimated:YES];*/
            
            self.navigationItem.rightBarButtonItem.enabled = NO;
            
            [Utilities showProcessingHud:self.view];
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Profile", @"ac",
                                  @"2", @"v",
                                  @"update", @"op",
                                  text_title.text,@"name",
                                  nil];
            
            [network sendHttpReq:HttpReq_ProfileUpdate andData:data];
        }
        
    }
    
    
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear: animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:text_title];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    
    // 背景图片
    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height - 44)];
    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    [self.view addSubview:imgView_bgImg];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    [self.view addSubview:_tableView];
    
    GlobalSingletonUserInfo* g_userPersonalInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
    NSMutableDictionary *settingPersonalInfo = [g_userPersonalInfo getUserSettingPersonalInfo];
    
    NSString *name = [settingPersonalInfo objectForKey:@"name"];
    
    if ([self.fromName isEqualToString:@"qq"]) {
        name = [settingPersonalInfo objectForKey:@"qq"];
    }else if ([self.fromName isEqualToString:@"groupChatSettingName"]) {
//        name = _groupChatName;
    }else if ([self.fromName isEqualToString:@"className"]){
        name = _className;
    }
    
    if (iPhone5)
    {
        text_title = [[UITextField alloc]initWithFrame:CGRectMake(10, 35, 310, 50)];
    }
    else
    {
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        {
            text_title = [[UITextField alloc]initWithFrame:CGRectMake(15, 35, 310, 50)];
        }
        else
        {
            text_title = [[UITextField alloc]initWithFrame:CGRectMake(15, 24, 310, 50)];
        }
    }
    
    text_title.borderStyle = UITextBorderStyleNone;
    text_title.backgroundColor = [UIColor clearColor];
    text_title.placeholder = name;
    text_title.font = [UIFont fontWithName:@"Arial" size:18.0f];
    text_title.textColor = [UIColor blackColor];
    text_title.clearButtonMode = UITextFieldViewModeNever;
    text_title.textAlignment = NSTextAlignmentLeft;
    text_title.keyboardType=UIKeyboardTypeDefault;
    text_title.returnKeyType =UIReturnKeyDone;
    text_title.delegate = self;
    [text_title performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.01];

    [_tableView addSubview:text_title];
}

-(void)viewWillAppear:(BOOL)animated
{
    GlobalSingletonUserInfo* g_userPersonalInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
    NSMutableDictionary *settingPersonalInfo = [g_userPersonalInfo getUserSettingPersonalInfo];
    
    if ([self.fromName isEqualToString:@"qq"]) {
    
        NSString *qq = [settingPersonalInfo objectForKey:@"qq"];
        text_title.text = qq;

        
    }else if ([self.fromName isEqualToString:@"groupChatSettingName"]) {
        text_title.text = _groupChatName;
    }else if ([self.fromName isEqualToString:@"className"]){
        text_title.text = _className;

    }else{
        
        NSString *name = [settingPersonalInfo objectForKey:@"name"];
        text_title.text = name;
    }
   
}

-(void)selectLeftAction:(id)sender
{
    [network cancelCurrentRequest];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)submitAction:(id)sender
{
    [text_title resignFirstResponder];
    
    if ([self.fromName isEqualToString:@"qq"]) {
    
        if (text_title.text.length > 50) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"位数输入过长，请重新输入。"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        } else {
            
            /*NSMutableDictionary *settingPersonalInfo = [g_userInfo getUserSettingPersonalInfo];
            
            [settingPersonalInfo setObject:text_title.text forKey:@"qq"];
            
            [g_userInfo setUserSettingPersonalInfo:settingPersonalInfo];
            
            [self.navigationController popViewControllerAnimated:YES];*/
            
            self.navigationItem.rightBarButtonItem.enabled = NO;
            
            [Utilities showProcessingHud:self.view];
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Profile", @"ac",
                                  @"2", @"v",
                                  @"update", @"op",
                                  text_title.text,@"qq",
                                  nil];
            
            [network sendHttpReq:HttpReq_ProfileUpdate andData:data];
            
        }
    
    }else if ([self.fromName isEqualToString:@"groupChatSettingName"]) {
        if ([@""  isEqual: text_title.text]) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"输入为空，请重新输入。"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }else {
            [Utilities showProcessingHud:self.view];
            self.navigationItem.rightBarButtonItem.enabled = NO;
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"GroupChat",@"ac",
                                  @"2",@"v",
                                  @"setGroupName", @"op",
                                  _gid, @"gid",
                                  text_title.text, @"groupName",
                                  nil];
            
            [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
                [Utilities dismissProcessingHud:self.view];
                self.navigationItem.rightBarButtonItem.enabled = YES;
                
                NSDictionary *respDic = (NSDictionary*)responseObject;
                NSString *result = [respDic objectForKey:@"result"];
                
                if(true == [result intValue]) {
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         text_title.text, @"name",
                                         nil];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_GROUPCHAT_CHANGEGROUPNAME object:self userInfo:dic];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    NSString *msg = [respDic objectForKey:@"message"];
                    [Utilities showFailedHud:msg descView:self.view];
                }
            } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                self.navigationItem.rightBarButtonItem.enabled = YES;
                
                [Utilities doHandleTSNetworkingErr:error descView:self.view];
            }];
        }
    }else if ([self.fromName isEqualToString:@"className"]){//班级名称
        
        /**
         * 修改班级名称
         * 1. 前置条件班级管理员
         * @author luke
         * @date 2015.09.14
         * @args
         *  v=2, ac=Class, op=setClassName, sid=, cid=, uid=, name=班级名称,长度限制40
         *
         */
        if ([@""  isEqual: text_title.text]) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"输入为空，请重新输入。"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }else {
            [Utilities showProcessingHud:self.view];
            self.navigationItem.rightBarButtonItem.enabled = NO;
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"Class",@"ac",
                                  @"2",@"v",
                                  @"setClassName", @"op",
                                  _cid, @"cid",
                                  text_title.text, @"name",
                                  nil];
            
            [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
                [Utilities dismissProcessingHud:self.view];
                self.navigationItem.rightBarButtonItem.enabled = YES;
                
                NSDictionary *respDic = (NSDictionary*)responseObject;
                NSString *result = [respDic objectForKey:@"result"];
                
                if(true == [result intValue]) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyClassInfo" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    NSString *msg = [respDic objectForKey:@"message"];
                    [Utilities showFailedHud:msg descView:self.view];
                }
            } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                self.navigationItem.rightBarButtonItem.enabled = YES;
                
                [Utilities doHandleTSNetworkingErr:error descView:self.view];
            }];
        }
        
    }
    else{
        
        if ([@""  isEqual: text_title.text]) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"输入为空，请重新输入。"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        } else if (text_title.text.length > 8) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"名字超过8位，请重新输入。"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        } else {
            
            /*NSMutableDictionary *settingPersonalInfo = [g_userInfo getUserSettingPersonalInfo];
            
            [settingPersonalInfo setObject:text_title.text forKey:@"name"];
            
            [g_userInfo setUserSettingPersonalInfo:settingPersonalInfo];
            
            [self.navigationController popViewControllerAnimated:YES];*/
            
            self.navigationItem.rightBarButtonItem.enabled = NO;
            
            [Utilities showProcessingHud:self.view];
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Profile", @"ac",
                                  @"2", @"v",
                                  @"update", @"op",
                                  text_title.text,@"name",
                                  nil];
            
            [network sendHttpReq:HttpReq_ProfileUpdate andData:data];
        }
        
    }
    
    
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
            
            if ([self.fromName isEqualToString:@"qq"]) {
               
                [settingPersonalInfo setObject:text_title.text forKey:@"qq"];
                 [userDetail setObject:text_title.text forKey:@"qq"];
                
            }else{
               
                [settingPersonalInfo setObject:text_title.text forKey:@"name"];
                 [userDetail setObject:text_title.text forKey:@"name"];
                
            }
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
#if 0
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([self.fromName isEqualToString:@"qq"]) {
        //这里默认是最多输入50位
        if (range.location >= 50)
        {
            NSString *input = string;
            if ([input  isEqual: @""]) {
                return YES;
            }
            return NO;
        }
        return YES;
    }else if ([self.fromName isEqualToString:@"groupChatSettingName"]) {
        
    }else if([self.fromName isEqualToString:@"className"]){//班级名称
        //这里默认是最多输入20位
        if (range.location >= 20)
        {
            NSString *input = string;
            if ([input  isEqual: @""]) {
                return YES;
            }
            return NO;
        }
        return YES;
    }else{//真实姓名
#if 0
        //这里默认是最多输入8位
        if (range.location >= 8)
        {
            NSString *input = string;
            if ([input  isEqual: @""]) {
                return YES;
            }
            return NO;
        }
        return YES;
#endif
        //判断加上输入的字符，是否超过界限
//        NSString *str = [NSString stringWithFormat:@"%@%@", text_title.text, string];
//        if (str.length > 8)
//        {
//            text_title.text = [text_title.text substringToIndex:8];
//            return NO;
//        }
        return YES;
    }

    
}
#endif

-(void)textFiledEditChanged:(NSNotification *)obj{
    NSInteger limit;
    
    if ([self.fromName isEqualToString:@"qq"]) {
        limit = 50;
    }else if ([self.fromName isEqualToString:@"groupChatSettingName"]) {
        limit = 8;
    }else{
        limit = 8;
    }

    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > limit) {
                textField.text = [toBeString substringToIndex:limit];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > limit) {
            textField.text = [toBeString substringToIndex:limit];
        }
    }
}

@end
