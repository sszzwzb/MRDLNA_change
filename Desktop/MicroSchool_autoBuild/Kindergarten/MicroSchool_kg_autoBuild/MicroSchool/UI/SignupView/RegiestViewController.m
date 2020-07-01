//
//  RegiestViewController.m
//  MicroSchool
//
//  Created by jojo on 13-11-5.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "RegiestViewController.h"

@interface RegiestViewController ()

@end

@implementation RegiestViewController

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_textFieldOri];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_textFieldNew];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_textFieldVeri];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:_textFieldOri];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:_textFieldNew];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:_textFieldVeri];

}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [super setCustomizeTitle:@"设置账户"];
    [super setCustomizeLeftButton];
    
    // 手势识别
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    singleTouch.delegate = self;
    [self.view addGestureRecognizer:singleTouch];
    
}

-(void)dismissKeyboard{
    
    [_textFieldOri resignFirstResponder];
    [_textFieldNew resignFirstResponder];
    [_textFieldVeri resignFirstResponder];
    
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

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    
    // 背景图片
    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height)];
    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    [self.view addSubview:imgView_bgImg];
    
    // 设置背景scrollView
    UIScrollView* scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH , [UIScreen mainScreen].applicationFrame.size.height - 44)];
    scrollerView.contentSize = CGSizeMake(WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44);
    scrollerView.scrollEnabled = YES;
    scrollerView.delegate = self;
    scrollerView.bounces = YES;
    scrollerView.alwaysBounceHorizontal = NO;
    scrollerView.alwaysBounceVertical = YES;
    scrollerView.directionalLockEnabled = YES;
    [self.view addSubview:scrollerView];
    
    // tableview
    //    if ([[[UIDevice currentDevice]systemVersion ]floatValue]>=7) {
    tableViewIns = [[UITableView alloc]initWithFrame:CGRectMake(
                                                                0,
                                                                0,
                                                                WIDTH,
                                                                300) style:UITableViewStyleGrouped];
    //    }
    //    else {
    //        tableViewIns = [[UITableView alloc]initWithFrame:CGRectMake(
    //                                                                    0,
    //                                                                    image_head_bg.frame.origin.y + image_head_bg.frame.size.height,
    //                                                                    320,
    //                                                                    scrollerView.frame.size.height) style:UITableViewStyleGrouped];
    //    }
    tableViewIns.delegate = self;
    tableViewIns.dataSource = self;
    [tableViewIns setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    tableViewIns.backgroundColor = [UIColor clearColor];
    tableViewIns.backgroundView = nil;
    
    [scrollerView addSubview:tableViewIns];
    
    if (iPhone5)
    {
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        {

        _textFieldOri = [[UITextField alloc]initWithFrame:CGRectMake(
                                                                     20,
                                                                     49,
                                                                     250,
                                                                     20)];
        }else{
            
            _textFieldOri = [[UITextField alloc]initWithFrame:CGRectMake(
                                                                         20,
                                                                         49-20,
                                                                         250,
                                                                         20)];
            
        }
    }
    else
    {
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        {
            _textFieldOri = [[UITextField alloc]initWithFrame:CGRectMake(
                                                                         20,
                                                                         49,
                                                                         250,
                                                                         20)];
        }
        else
        {
            _textFieldOri = [[UITextField alloc]initWithFrame:CGRectMake(
                                                                         20,
                                                                         26,
                                                                         250,
                                                                         20)];
        }
    }
    
    _textFieldOri.borderStyle = UITextBorderStyleNone;
    _textFieldOri.backgroundColor = [UIColor clearColor];
    _textFieldOri.placeholder = @"用户名";
    _textFieldOri.font = [UIFont systemFontOfSize:15.0f];
    _textFieldOri.textColor = [UIColor blackColor];
    _textFieldOri.textAlignment = NSTextAlignmentLeft;
    _textFieldOri.keyboardType=UIKeyboardTypeDefault;
    _textFieldOri.returnKeyType =UIReturnKeyNext;
    _textFieldOri.delegate = self;
    _textFieldOri.autocorrectionType= UITextAutocorrectionTypeNo;
    _textFieldOri.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_textFieldOri performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.01];
    [tableViewIns addSubview:_textFieldOri];
    
    _textFieldNew = [[UITextField alloc]initWithFrame:CGRectMake(
                                                                 _textFieldOri.frame.origin.x,
                                                                 _textFieldOri.frame.origin.y + _textFieldOri.frame.size.height + 30,
                                                                 150,
                                                                 20)];
    _textFieldNew.borderStyle = UITextBorderStyleNone;
    _textFieldNew.backgroundColor = [UIColor clearColor];
    _textFieldNew.placeholder = @"密码";
    _textFieldNew.font = [UIFont systemFontOfSize:15.0f];
    _textFieldNew.textColor = [UIColor blackColor];
    _textFieldNew.textAlignment = NSTextAlignmentLeft;
    _textFieldNew.keyboardType=UIKeyboardTypeDefault;
    _textFieldNew.returnKeyType =UIReturnKeyNext;
    _textFieldNew.delegate = self;
    _textFieldNew.secureTextEntry = YES;
    _textFieldNew.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [tableViewIns addSubview:_textFieldNew];
    
    _textFieldVeri = [[UITextField alloc]initWithFrame:CGRectMake(
                                                                  _textFieldNew.frame.origin.x,
                                                                  _textFieldNew.frame.origin.y + _textFieldNew.frame.size.height + 30,
                                                                  150,
                                                                  20)];
    _textFieldVeri.borderStyle = UITextBorderStyleNone;
    _textFieldVeri.backgroundColor = [UIColor clearColor];
    _textFieldVeri.placeholder = @"确认密码";
    _textFieldVeri.font = [UIFont systemFontOfSize:15.0f];
    _textFieldVeri.textColor = [UIColor blackColor];
    _textFieldVeri.textAlignment = NSTextAlignmentLeft;
    _textFieldVeri.keyboardType=UIKeyboardTypeDefault;
    _textFieldVeri.returnKeyType =UIReturnKeyDone;
    _textFieldVeri.delegate = self;
    _textFieldVeri.secureTextEntry = YES;
    _textFieldVeri.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [tableViewIns addSubview:_textFieldVeri];
    
//    [_textFieldOri addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
//    [_textFieldOri addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
//
//
//    [_textFieldNew addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
//    [_textFieldNew addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
//
//    
//    [_textFieldVeri addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
//    [_textFieldVeri addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, _textFieldVeri.frame.origin.y+5, 200, 100)];
    label.text = @"密码6~12位";
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont systemFontOfSize:13.0f];
    label.numberOfLines = 0;
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor clearColor];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    [scrollerView addSubview:label];

    // 保存button
    UIButton *button_save = [UIButton buttonWithType:UIButtonTypeCustom];
    button_save.frame = CGRectMake(15, _textFieldVeri.frame.origin.y + _textFieldVeri.frame.size.height + 60, 290, 40);
    //button.center = CGPointMake(160.0f, 140.0f);
    
    button_save.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置title自适应对齐
    button_save.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [button_save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button_save setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button_save.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [button_save setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal] ;
    [button_save setBackgroundImage:[UIImage imageNamed:@"btn_common_1_p.png"] forState:UIControlStateHighlighted] ;
    // 添加 action
    [button_save addTarget:self action:@selector(save_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    
    //设置title
    [button_save setTitle:@"注册账号" forState:UIControlStateNormal];
    [button_save setTitle:@"注册账号" forState:UIControlStateHighlighted];
    
    [scrollerView addSubview:button_save];
}

- (IBAction)save_btnclick:(id)sender
{
#if 9
    if(_textFieldOri.text.length == 0)
        
    {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                      message:@"用户名不能为空，请重新输入"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
    }
    else if ((_textFieldOri.text.length != 0) && (_textFieldOri.text.length < 2))
    {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                      message:@"用户名长度不能小于2位"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
    }
    else if(![_textFieldNew.text  isEqual: _textFieldVeri.text])
    {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                      message:@"密码不一致，请重新输入"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
    }
    else if((_textFieldNew.text.length <6) || (_textFieldVeri.text.length <6))
    {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                      message:@"密码小于6位，请重新输入"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [self hideKeyBoard];
        
        // 先转菊花
        [Utilities showProcessingHud:self.view];
        [self performSelector:@selector(doRegist) withObject:nil afterDelay:0.1];
    }
    
#else
    SetPersonalViewController *personalViewCtrl = [[SetPersonalViewController alloc] init];
    
    [self.navigationController pushViewController:personalViewCtrl animated:YES];
    personalViewCtrl.title = @"个人信息完善";
#endif
}

- (void)doRegist
{
#if NETWORKING_REFACTORING
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Register", @"ac",
                          @"2", @"v",
                          @"register", @"op",
                          _textFieldOri.text, @"username",
                          _textFieldNew.text, @"password",
                          [g_userInfo getUserPhoneNum], @"mobile",
                          @"1", @"token",
                          @"4", @"device",
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
            NSString *schoolType = [message_info objectForKey:@"type"];
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
            NSDictionary *regNamePwd = [[NSDictionary alloc] initWithObjectsAndKeys:username, @"username", _textFieldNew.text, @"password", uid, @"uid", nil];
            
            [[NSUserDefaults standardUserDefaults] setObject:regNamePwd forKey:[NSString stringWithFormat:@"zhixiao_regNamePwd_%@", uid]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 将用户名,密码,uid,保存到UserDefaults里面，以便下一次自动登录
            NSDictionary *userLoginNamePwd = [[NSDictionary alloc] initWithObjectsAndKeys:username, @"username", _textFieldNew.text, @"password", uid, @"uid", nil];
            
            [[NSUserDefaults standardUserDefaults] setObject:userLoginNamePwd forKey:G_NSUserDefaults_UserLoginInfo];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 保存程序内部唯一的合法uid。
            [[NSUserDefaults standardUserDefaults] setObject:uid forKey:G_NSUserDefaults_UserUniqueUid];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 绑定百度云推送 add by kate
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_BIND_BAIDU_PUSH object:nil];
            
            //        SetPersonalViewController *personalViewCtrl = [[SetPersonalViewController alloc] init];
            //        [self.navigationController pushViewController:personalViewCtrl animated:YES];
            //        personalViewCtrl.title = @"个人信息完善";
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"注册成功"
                                                          delegate:self
                                                 cancelButtonTitle:@"完善个人资料"
                                                 otherButtonTitles:nil];
            [alert show];
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
#else
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Register", @"ac",
                          @"2", @"v",
                          @"register", @"op",
                          _textFieldOri.text, @"username",
                          _textFieldNew.text, @"password",
                          [g_userInfo getUserPhoneNum], @"mobile",
                          @"1", @"token",
                          @"4", @"device",
                          nil];
    
    [network sendHttpReq:HttpReq_Register andData:data];
#endif
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    if (0 == section) {
        return 3;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定行的高度
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    RegiestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    
    if (cell == nil) {
        cell = [[RegiestTableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    
    if (0 == [indexPath section] && 0 == [indexPath row]) {
        [cell.imgView_Veri setImage:[UIImage imageNamed:@"icon_user_name.png"]];
    }else if (0 == [indexPath section] && 1 == [indexPath row]){
        [cell.imgView_Veri setImage:[UIImage imageNamed:@"password.png"]];
    }else if (0 == [indexPath section] && 2 == [indexPath row]){
        [cell.imgView_Veri setImage:[UIImage imageNamed:@"password.png"]];
    }else{
        return nil;
    }
    
    //设置textLabel的背景色为空
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#if 0
//定义UITextFiled的代理方法：
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //这里默认是最多输入15位
    if (_textFieldOri == textField) {
        if (range.location >= 15)
            return NO; // return NO to not change text
    } else {
        if (range.location >= 12)
            return NO; // return NO to not change text
    }
    return YES;
}
#endif

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _textFieldOri) {
        [_textFieldNew becomeFirstResponder];
    }else if (textField == _textFieldNew){
        [_textFieldVeri becomeFirstResponder];
    }else{
        
        [self hideKeyBoard];
        [self save_btnclick:nil];
    }
    return YES;
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    [Utilities dismissProcessingHud:self.view];
    
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if(true == [result intValue])
    {
        DataReport *dr = [DataReport sharedGlobalSingletonDataReport];
        [dr dataReportActiontype:@"register"];

        
        // 注册成功返回
        NSDictionary* message_info = [resultJSON objectForKey:@"message"];
        
        NSString *uid = [message_info objectForKey:@"uid"];
        NSString *username = [message_info objectForKey:@"username"];
        
        //-----add by kate 2015.05.05--------------------------------------------------------
        NSString *schoolType = [message_info objectForKey:@"type"];
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
        NSDictionary *regNamePwd = [[NSDictionary alloc] initWithObjectsAndKeys:username, @"username", _textFieldNew.text, @"password", uid, @"uid", nil];
        
        [[NSUserDefaults standardUserDefaults] setObject:regNamePwd forKey:[NSString stringWithFormat:@"zhixiao_regNamePwd_%@", uid]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 将用户名,密码,uid,保存到UserDefaults里面，以便下一次自动登录
        NSDictionary *userLoginNamePwd = [[NSDictionary alloc] initWithObjectsAndKeys:username, @"username", _textFieldNew.text, @"password", uid, @"uid", nil];
        
        [[NSUserDefaults standardUserDefaults] setObject:userLoginNamePwd forKey:G_NSUserDefaults_UserLoginInfo];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 保存程序内部唯一的合法uid。
        [[NSUserDefaults standardUserDefaults] setObject:uid forKey:G_NSUserDefaults_UserUniqueUid];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 绑定百度云推送 add by kate
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_BIND_BAIDU_PUSH object:nil];

//        SetPersonalViewController *personalViewCtrl = [[SetPersonalViewController alloc] init];
//        [self.navigationController pushViewController:personalViewCtrl animated:YES];
//        personalViewCtrl.title = @"个人信息完善";
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"注册成功"
                                                      delegate:self
                                             cancelButtonTitle:@"完善个人资料"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSString *message_info = [resultJSON objectForKey:@"message"];

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

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    SetIdentityViewController *idViewCtrl = [[SetIdentityViewController alloc] init];
    [self.navigationController pushViewController:idViewCtrl animated:YES];
}

//-(void)textFieldDidBeginEditing:(UITextField *)textField{   //开始编辑时，整体上移
//    if (textField == _textFieldNew) {
//        [self moveView:-20];
//    }
//    if (textField == _textFieldVeri)
//    {
//        [self moveView:-60];
//    }
//}
//
//-(void)textFieldDidEndEditing:(UITextField *)textField{     //结束编辑时，整体下移
//    if (textField == _textFieldNew) {
//        [self moveView:20];
//    }
//    if (textField == _textFieldVeri)
//    {
//        [self moveView:60];
//    }
//}

-(void)moveView:(float)move{
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y +=move;//view的X轴上移
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];//设置调整界面的动画效果
}

-(void)textFiledEditChanged:(NSNotification *)obj{
    NSInteger limit;
    limit = 15;
    
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

//// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return YES;
}
////
//// 是否支持横竖屏显示
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
