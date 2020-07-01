	//
//  LoginViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-6.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "LoginViewController.h"
#import "SchoolListForBureauViewController.h"

//---add by kate----------------------------------------
#import "GlobalSingletonUserInfo.h"
#import "MyClassListViewController.h"
#import "MicroSchoolAppDelegate.h"
#import "MomentsEntranceTableViewController.h"
#import "SubUINavigationController.h"
#import "SchoolHomeViewController.h"
//#import "ClassHomeViewController.h"
#import "ParksHomeViewController.h"
#import "MyClassDetailViewController.h"
#import "LeftViewController.h"
#import "WWSideslipViewController.h"

//--------------------------------------------

#import "SetPersonalViewController.h"

@interface LoginViewController ()

@end
UINavigationController *navigation_NoUserType;
SubUINavigationController *navigation_gotoPersonal;
@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        network = [NetworkUtility alloc];
        network.delegate = self;
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
//                                                    name:@"UITextFieldTextDidChangeNotification"
//                                                  object:_textFieldOri];
        
        //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
        //                                            name:@"UITextFieldTextDidChangeNotification"
        //                                         object:_textFieldOri];

    }
    return self;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_textFieldOri];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
 
    [super viewWillAppear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"LoginViewC" forKey:@"viewName"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_textFieldOri];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:_textFieldOri];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [super setCustomizeTitle:@"登录"];
    [super setCustomizeLeftButton];
    
    // 手势识别
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    singleTouch.delegate = self;
    [self.view addGestureRecognizer:singleTouch];
}

// 隐藏键盘
- (void)dismissKeyboard
{
    [_textFieldOri resignFirstResponder];
    [_textFieldNew resignFirstResponder];
}

-(void)selectLeftAction:(id)sender
{
    [_textFieldOri resignFirstResponder];
    [_textFieldNew resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
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
    // 设置背景scrollView
    scrollerView =[UIScrollView new];
    scrollerView.contentSize = CGSizeMake(WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44);
    scrollerView.scrollEnabled = YES;
    scrollerView.delegate = self;
    scrollerView.bounces = YES;
    scrollerView.alwaysBounceHorizontal = NO;
    scrollerView.alwaysBounceVertical = YES;
    scrollerView.directionalLockEnabled = YES;
    [self.view addSubview:scrollerView];
    [scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(WIDTH,HEIGHT-44));
    }];

    // tableview
    tableViewIns = [[UITableView alloc]initWithFrame:CGRectMake(
                                                                0,
                                                                0,
                                                                WIDTH,
                                                                300) style:UITableViewStyleGrouped];
    tableViewIns.delegate = self;
    tableViewIns.dataSource = self;
    [tableViewIns setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    tableViewIns.backgroundColor = [UIColor clearColor];
    tableViewIns.backgroundView = nil;
//#319
    tableViewIns.separatorStyle = NO;
    [scrollerView addSubview:tableViewIns];
//#319 新UI横线
    UILabel *lable1 = [UILabel new];
    lable1.backgroundColor = [UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1.0];
    [tableViewIns addSubview:lable1];
    [lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableViewIns.mas_top).with.offset(130);
        make.left.equalTo(tableViewIns.mas_left).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(WIDTH-40,1));
    }];
    
    UILabel *lable2 = [UILabel new];
    lable2.backgroundColor = [UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1.0];
    [tableViewIns addSubview:lable2];
    [lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableViewIns.mas_top).with.offset(85);
        make.left.equalTo(tableViewIns.mas_left).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(WIDTH-40,1));
    }];
    
    // 保存button
    UIButton *button_save = [UIButton buttonWithType:UIButtonTypeCustom];
    //button.center = CGPointMake(160.0f, 140.0f);
    
    button_save.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置title自适应对齐
    button_save.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [button_save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button_save setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button_save.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    
    [button_save setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal] ;
    [button_save setBackgroundImage:[UIImage imageNamed:@"btn_common_1_p.png"] forState:UIControlStateHighlighted] ;
    // 添加 action
    [button_save addTarget:self action:@selector(save_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    
    //设置title
    [button_save setTitle:@"登录" forState:UIControlStateNormal];
    [button_save setTitle:@"登录" forState:UIControlStateHighlighted];
    
    [scrollerView addSubview:button_save];
    [button_save mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollerView.mas_top).with.offset(160);
        make.left.equalTo(scrollerView.mas_left).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(WIDTH-30,40));
    }];
    
    // 找回密码
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //设置title自适应对齐
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [button setTitleColor:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    // 添加 action
    [button addTarget:self action:@selector(getBackPwd_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    
    //设置title
    [button setTitle:@"找回密码" forState:UIControlStateNormal];
    [button setTitle:@"找回密码" forState:UIControlStateHighlighted];
    
    [scrollerView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button_save.mas_top).with.offset(40);
        make.left.equalTo(scrollerView.mas_left).with.offset(WIDTH/2-40);
        make.size.mas_equalTo(CGSizeMake(80,40));
    }];

}

- (IBAction)getBackPwd_btnclick:(id)sender
{
    GetBackPwdViewController *getBackPwdViewCtrl = [[GetBackPwdViewController alloc] init];
    [self.navigationController pushViewController:getBackPwdViewCtrl animated:YES];
}

- (IBAction)save_btnclick:(id)sender
{
    if(_textFieldOri.text.length == 0) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                      message:@"用户名不能为空，请重新输入"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
    }else if (_textFieldNew.text.length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                      message:@"密码不能为空，请重新输入"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
    }else {
        [super hideKeyBoard];
        [self doUserlogin];
    }
}

- (void)doUserlogin
{
    if (_textFieldNew.text.length < 6) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"密码小于6位，请重新输入"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    } else {
        [Utilities showProcessingHud:self.view];
        
#if NETWORKING_REFACTORING
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_code = [infoDictionary objectForKey:@"CFBundleVersion"];
        NSString *softVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Login", @"ac",
                              @"2", @"v",
                              @"unique", @"op",
                              _textFieldOri.text, @"username",
                              _textFieldNew.text, @"password",@"4", @"appid",
                              app_code, @"code",
                              softVersion, @"version",
                              nil];

        [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
            [Utilities dismissProcessingHud:self.view];
            
            NSDictionary *respDic = (NSDictionary*)responseObject;
            NSString *result = [respDic objectForKey:@"result"];
            
            if(true == [result intValue]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"zhixiao_delegate_checkVersion" object:self userInfo:nil];
                
                // 登录成功，gps上报
                DataReport *dr = [DataReport sharedGlobalSingletonDataReport];
                [dr dataReportGPStype:@"DataReport_Act_Login"];
                
                NSDictionary* message_info = [respDic objectForKey:@"message"];
                NSString* uid= [message_info objectForKey:@"uid"];
                
                // 保存token
                NSString* token= [message_info objectForKey:@"token"];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:token forKey:USER_LOGIN_TOKEN];
                [userDefaults synchronize];

                
                //-----add by kate 2015.05.05--------------------------------------------------------
                /*
                 type:学校类型 'university' => '大学', 'senior' => '高中', 'technical' => '中职', 'junior' => '初中',
                 'primary' => '小学', 'kindergarten' => '幼儿园', 'training' => '培训', 'other' => '其他', 'bureau'=> '教育局'
                 */
                NSString *schoolType = [NSString stringWithFormat:@"%@", [message_info objectForKey:@"type"]];
                NSLog(@"schoolType:%@",schoolType);
                NSString *oldType = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"schoolType"]]];
                if (![schoolType isEqualToString:oldType]) {
                    [[NSUserDefaults standardUserDefaults] setObject:schoolType forKey:@"schoolType"];
                }
                //-----------------------------------------------------------------------------------
                
                NSLog(@"resultJSON:%@",respDic);
                // 登陆成功将单例中的标志设置为1，下次进入app就不会显示guide
                //        GlobalSingletonUserInfo* g_userLoginIndex = GlobalSingletonUserInfo.sharedGlobalSingleton;
                //        [g_userLoginIndex setLoginIndex:(NSInteger*)1];
                
                // 将用户名,密码,uid,保存到UserDefaults里面，以便下一次自动登录
                NSDictionary *userLoginNamePwd = [[NSDictionary alloc] initWithObjectsAndKeys:_textFieldOri.text, @"username", _textFieldNew.text, @"password", uid, @"uid", nil];
                
                [[NSUserDefaults standardUserDefaults] setObject:userLoginNamePwd forKey:G_NSUserDefaults_UserLoginInfo];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // 保存程序内部唯一的合法uid。
                [[NSUserDefaults standardUserDefaults] setObject:uid forKey:G_NSUserDefaults_UserUniqueUid];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // 绑定百度云推送 add by kate
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_BIND_BAIDU_PUSH object:nil];
                
                [dr dataReportActiontype:@"login"];
                
//                [self doProfileActionView];
                
                [self handleUserProfile:message_info];
                
                //---------2015.11.11--kate------------------------------------------------------------------------
                MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
                [appDelegate checkAllRedPoints];
                //--------------------------------------------------------------------------------------------------

                
            } else {
                [Utilities dismissProcessingHud:self.view];
                
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
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_code = [infoDictionary objectForKey:@"CFBundleVersion"];
        NSString *softVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Login", @"ac",
                              @"2", @"v",
                              @"unique", @"op",
                              _textFieldOri.text, @"username",
                              _textFieldNew.text, @"password",@"4", @"appid",
                              app_code, @"code",
                              softVersion, @"version",
                              nil];
        
        [network sendHttpReq:HttpReq_Login andData:data];
#endif
    }
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    if (0 == section) {
        return 2;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定行的高度
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    cell.backgroundColor=[UIColor clearColor];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    
    if (0 == [indexPath section] && 0 == [indexPath row]) {
        _textFieldOri =[UITextField new];//update by kate 2015.02.28
        _textFieldOri.clearsOnBeginEditing = NO;//鼠标点上时，不清空
        _textFieldOri.borderStyle = UITextBorderStyleNone;
        _textFieldOri.backgroundColor = [UIColor clearColor];
        _textFieldOri.placeholder = @"用户名/手机号码";
        _textFieldOri.font = [UIFont systemFontOfSize:16.0f];
        _textFieldOri.textColor = [UIColor blackColor];
        _textFieldOri.textAlignment = NSTextAlignmentLeft;
        _textFieldOri.keyboardType=UIKeyboardTypeDefault;
        _textFieldOri.returnKeyType =UIReturnKeyNext;//update 2015.04.13
        _textFieldOri.autocorrectionType=UITextAutocorrectionTypeNo;
        _textFieldOri.tintColor = [UIColor colorWithRed:18.0/255.0 green:65.0/255.0 blue:249.0/255.0 alpha:1];//add by kate 2015.02.28
        _textFieldOri.autocapitalizationType = UITextAutocapitalizationTypeNone;//add 2015.04.13
        [_textFieldOri setDelegate: self];
        [_textFieldOri performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.01];
        [cell.contentView addSubview: _textFieldOri];
        [_textFieldOri mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top).with.offset(5);
            make.left.equalTo(cell.contentView.mas_left).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(250,45));
        }];
    }else if (0 == [indexPath section] && 1 == [indexPath row]){
        _textFieldNew = [UITextField new];//update by kate 2015.02.28
        _textFieldNew.clearsOnBeginEditing = NO;//鼠标点上时，不清空
        _textFieldNew.borderStyle = UITextBorderStyleNone;
        _textFieldNew.backgroundColor = [UIColor clearColor];
        _textFieldNew.placeholder = @"密码";
        _textFieldNew.font = [UIFont systemFontOfSize:16.0f];
        _textFieldNew.textColor = [UIColor blackColor];
        _textFieldNew.textAlignment = NSTextAlignmentLeft;
        _textFieldNew.keyboardType=UIKeyboardTypeDefault;
        _textFieldNew.returnKeyType =UIReturnKeyDone;
        _textFieldNew.autocorrectionType=UITextAutocorrectionTypeNo;
        _textFieldNew.secureTextEntry = YES;
        _textFieldNew.tintColor = [UIColor colorWithRed:18.0/255.0 green:65.0/255.0 blue:249.0/255.0 alpha:1];//add by kate 2015.02.28
         _textFieldOri.autocapitalizationType = UITextAutocapitalizationTypeNone;//add 2015.04.13
        [_textFieldNew setDelegate: self];
        [cell.contentView addSubview: _textFieldNew];
        [_textFieldNew mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top).with.offset(5);
            make.left.equalTo(cell.contentView.mas_left).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(250,45));
        }];
    }else{
        return nil;
    }
    
    //设置textLabel的背景色为空
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}

//选中Cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    tableViewIns.allowsSelection=NO;
}

#if 0
//定义UITextFiled的代理方法：
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    /* 2.9.0 和 2.9.1都改 去掉长度限制 春晖确认
    if (_textFieldOri == textField) {
        if (range.location >= 15)
            return NO; // return NO to not change text
    }*/
    
//    else {
//        if (range.location >= 12)
//            return NO; // return NO to not change text
//    }
    return YES;
}
#endif

 - (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _textFieldOri) {
        
        [_textFieldNew becomeFirstResponder];
        
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
    
    if ([@"LoginAction.unique"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
        if(true == [result intValue]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"zhixiao_delegate_checkVersion" object:self userInfo:nil];

            // 登录成功，gps上报
            DataReport *dr = [DataReport sharedGlobalSingletonDataReport];
            [dr dataReportGPStype:@"DataReport_Act_Login"];
            
            [ReportObject event:ID_LOGIN];//2015.06.23
            
            NSDictionary* message_info = [resultJSON objectForKey:@"message"];
            NSString* uid= [message_info objectForKey:@"uid"];
            
            //-----add by kate 2015.05.05--------------------------------------------------------
            /*
             type:学校类型 'university' => '大学', 'senior' => '高中', 'technical' => '中职', 'junior' => '初中',
             'primary' => '小学', 'kindergarten' => '幼儿园', 'training' => '培训', 'other' => '其他', 'bureau'=> '教育局'
             */
            NSString *schoolType = [message_info objectForKey:@"type"];
            NSLog(@"schoolType:%@",schoolType);
            NSString *oldType = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"schoolType"]];
            if (![schoolType isEqualToString:oldType]) {
                [[NSUserDefaults standardUserDefaults] setObject:schoolType forKey:@"schoolType"];
            }
            //-----------------------------------------------------------------------------------

            NSLog(@"resultJSON:%@",resultJSON);
            // 登陆成功将单例中的标志设置为1，下次进入app就不会显示guide
            //        GlobalSingletonUserInfo* g_userLoginIndex = GlobalSingletonUserInfo.sharedGlobalSingleton;
            //        [g_userLoginIndex setLoginIndex:(NSInteger*)1];
            
            // 将用户名,密码,uid,保存到UserDefaults里面，以便下一次自动登录
            NSDictionary *userLoginNamePwd = [[NSDictionary alloc] initWithObjectsAndKeys:_textFieldOri.text, @"username", _textFieldNew.text, @"password", uid, @"uid", nil];
            
            [[NSUserDefaults standardUserDefaults] setObject:userLoginNamePwd forKey:G_NSUserDefaults_UserLoginInfo];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 保存程序内部唯一的合法uid。
            [[NSUserDefaults standardUserDefaults] setObject:uid forKey:G_NSUserDefaults_UserUniqueUid];
            [[NSUserDefaults standardUserDefaults] synchronize];

            // 绑定百度云推送 add by kate
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_BIND_BAIDU_PUSH object:nil];
            
            [dr dataReportActiontype:@"login"];

            // 登录成功后去服务器获取个人详细信息
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Profile", @"ac",
                                  @"2", @"v",
                                  @"view", @"op",
                                  nil];

            [network sendHttpReq:HttpReq_Profile andData:data];
            
            
        }else {
            NSString* message_info = [resultJSON objectForKey:@"message"];
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:message_info
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }else if ([@"ProfileAction.view"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
        if(true == [result intValue]) {
            NSDictionary* message_info = [resultJSON objectForKey:@"message"];
            
            NSDictionary *profile = [message_info objectForKey:@"profile"];
            NSDictionary *role = [message_info objectForKey:@"role"];
            
            if ([@"-1" isEqual: [NSString stringWithFormat:@"%@", [role objectForKey:@"id"]]]) {
                NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithDictionary:profile];
                
                NSDictionary *vip = [message_info objectForKey:@"vip"];
                [infoDic setValue:[Utilities replaceNull:[vip objectForKey:@"opened"]] forKey:@"vip_opened"];
                [infoDic setValue:[Utilities replaceNull:[vip objectForKey:@"schoolEnabled"]] forKey:@"vip_schoolEnabled"];
                
                [Utilities doSaveSettingUserInfoToDefaultAndSingle:infoDic andRole:role];
                
                [[NSUserDefaults standardUserDefaults] setObject:[profile objectForKey:@"uid"] forKey:[NSString stringWithFormat:@"zhixiao_regUid"]];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // 登录时无身份信息
                if ([@"" isEqual: [profile objectForKey:@"name"]]) {
                    
                    _textFieldOri.text = @"";
                    _textFieldNew.text = @"";
                    
                    // 登录时真实姓名为空
                    SetIdentityViewController *setIdentity_viewCtrl = [[SetIdentityViewController alloc] init];
                    //                UINavigationController *navigation = [[UINavigationController alloc] init];
                    //
                    //                [navigation setTitle:@"testNavigation"];
                    //                [navigation initWithRootViewController:setIdentity_viewCtrl];
                    //[self presentViewController:navigation animated:YES completion:nil];
                    navigation_NoUserType = [[SubUINavigationController alloc] initWithRootViewController:setIdentity_viewCtrl];
                    [self presentViewController:navigation_NoUserType animated:YES completion:nil];
                    
                    [[NSUserDefaults standardUserDefaults]setObject:@"noUserType" forKey:@"fromNameToHome"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    
                }else {
                    _textFieldOri.text = @"";
                    _textFieldNew.text = @"";
                    
                    // 登录时真实姓名不为空
                    SetIdentityViewController *setIdentity_viewCtrl = [[SetIdentityViewController alloc] init];
                    //                UINavigationController *navigation = [[UINavigationController alloc] init];
                    //                [navigation setTitle:@"testNavigation"];
                    //                [navigation initWithRootViewController:setIdentity_viewCtrl];
                    //
                    //                [self presentViewController:navigation animated:YES completion:nil];
                    navigation_NoUserType = [[SubUINavigationController alloc] initWithRootViewController:setIdentity_viewCtrl];
                    [self presentViewController:navigation_NoUserType animated:YES completion:nil];
                    
                    [[NSUserDefaults standardUserDefaults]setObject:@"noUserType" forKey:@"fromNameToHome"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
            }else {
                // 登录时有身份信息
                if ([@"" isEqual: [profile objectForKey:@"name"]]) {
                    // 登录时真实姓名为空
                    NSString *iden;
                    if ([@"0" isEqual: [NSString stringWithFormat:@"%@", [role objectForKey:@"id"]]]) {
                        iden = @"student";
                    }else if ([@"6" isEqual: [NSString stringWithFormat:@"%@", [role objectForKey:@"id"]]]) {
                        iden = @"parent";
                    }else if ([@"7" isEqual: [NSString stringWithFormat:@"%@", [role objectForKey:@"id"]]]) {
                        iden = @"teacher";
                    }
                    
                    SetPersonalViewController *setPersonal_viewCtrl = [[SetPersonalViewController alloc] init];
                    setPersonal_viewCtrl.iden = iden;
                    setPersonal_viewCtrl.type = @"fromLogin";
                    SubUINavigationController *navigation = [[SubUINavigationController alloc] init];
                    [navigation setTitle:@"testNavigation"];
                    [navigation initWithRootViewController:setPersonal_viewCtrl];
                    
                    [self presentViewController:navigation animated:YES completion:nil];
                    
                }else {
                    // 登录时真实姓名不为空
                    // 存储个人信息
                    NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithDictionary:profile];
                    
                    NSDictionary *vip = [message_info objectForKey:@"vip"];
                    [infoDic setValue:[Utilities replaceNull:[vip objectForKey:@"opened"]] forKey:@"vip_opened"];
                    [infoDic setValue:[Utilities replaceNull:[vip objectForKey:@"schoolEnabled"]] forKey:@"vip_schoolEnabled"];
                    
                    [Utilities doSaveUserInfoToDefaultAndSingle:infoDic andRole:role];

                    
                    //----update by kate--------------------------------
                    // 到主页
                    /* MicroSchoolMainMenuViewController *mainMenuViewCtrl = [[MicroSchoolMainMenuViewController alloc] init];
                     MicroSchoolMainMenuNaviViewController *navigation = [[MicroSchoolMainMenuNaviViewController alloc] init];
                     [navigation initWithRootViewController:mainMenuViewCtrl];
                     [self presentViewController:navigation animated:YES completion:nil];*/
                    //[self dismissViewControllerAnimated:NO completion:nil];
                    [[NSUserDefaults standardUserDefaults]setObject:@"login" forKey:@"fromNameToHome"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    [self initTabBarController];// add by kate
                    //-----------------------------------------------------------------------------
                    // update 2015.10.21 教育服务发布商品 不能进入相册问题 原因是controller不在window上
                    //                        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
                    //                        [self presentViewController:appDelegate.tabBarController animated:NO completion:nil];
                    
                    
                    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
                    LeftViewController * leftController = [[LeftViewController alloc] init];
                    WWSideslipViewController * wwsideslioController = [[WWSideslipViewController alloc] initWithLeftView:leftController andMainView:appDelegate.tabBarController andBackgroundImage:[UIImage imageNamed:@""]];
                    appDelegate.window.rootViewController = wwsideslioController;
                    
                    //-------------------------------------------------------------------------------
                    _textFieldOri.text = @"";
                    _textFieldNew.text = @"";
                    //--------------------------------------------------
                }
            }
        }else {
            NSString* message_info = [resultJSON objectForKey:@"message"];
            
            if ([@""  isEqual: message_info]) {
                message_info = @"登录失败，请重新登录。";
            }
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

- (void)keyboardWillShow:(NSNotification *)notification {
    
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
                         
                         if (iPhone4) {
                             frame.height += 60;
                         }
//                         frame.height -= keyboardRect.size.height;
                         scrollerView.contentSize = frame;
                         
//                         keyboardHeight = keyboardRect.size.height;
                     }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
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
                         
                         if (iPhone4) {
                             frame.height -= 60;
                         }

                         scrollerView.contentSize = frame;
                         
//                         keyboardHeight = keyboardRect.size.height;
//                         
//                         keyboardHeight = 0;
                     }];
}

-(void)textFiledEditChanged:(NSNotification *)obj{
    
    NSString *viewName = [[NSUserDefaults standardUserDefaults] objectForKey:@"viewName"];
    
   if ([@"LoginViewC" isEqualToString:viewName]) {
        
    NSInteger limit;
    limit = 1000;
    
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
}

/*
 * 自定义tabbar add by kate
 */
- (void)initTabBarController
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (!appDelegate.tabBarController) {
        
        [appDelegate bindBaiduPush];//只有在进入主页后收到推送才显示 志伟确认 2015.12.09
        // 校园
        SchoolHomeViewController *schoolV = [[SchoolHomeViewController alloc] init];
        // 班级
        NSDictionary *userD = [g_userInfo
                               getUserDetailInfo];
        // 数据部分
        if (nil == userD) {
            userD = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDetailInfo"];
        }
        
        NSString *usertype = [NSString stringWithFormat:@"%@",[userD objectForKey:@"role_id"]];
        
        NSString *cid = @"0";
        
        MyClassListViewController *classV = [[MyClassListViewController alloc] init];
        
        MyClassDetailViewController *classDetailV = [[MyClassDetailViewController alloc] init];
        
        ParksHomeViewController *parkV = [[ParksHomeViewController alloc]init];
        
        
        //隐藏tabbar所留下的黑边（试着注释后你会知道这个的作用）
        schoolV.hidesBottomBarWhenPushed = YES;
        classV.hidesBottomBarWhenPushed = YES;
        classDetailV.hidesBottomBarWhenPushed = YES;
        parkV.hidesBottomBarWhenPushed = YES;
        schoolV.title = @"校园";
        classV.title = @"班级";
        parkV.title = @"乐园";
        
        UINavigationController *schoolNavi = [[UINavigationController alloc] initWithRootViewController:schoolV];
        
        UINavigationController *customizationNavi = [[UINavigationController alloc] initWithRootViewController:classDetailV];
        
        UINavigationController *ParkNavi = [[UINavigationController alloc]initWithRootViewController:parkV];

     
        NSArray *controllers;
            
            if([@"7"  isEqualToString: usertype] || [@"2" isEqualToString:usertype] || [@"9" isEqualToString:usertype])
            {
                customizationNavi = [[UINavigationController alloc] initWithRootViewController:classV];

            }
            else
            {
                cid = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[userD objectForKey:@"role_cid"]]];
                if(cid == nil){
                    cid = @"0";
                }else{
                    if([cid length] == 0){
                        cid = @"0";
                    }
                }
                if([cid isEqualToString:@"0"]){
                    customizationNavi = [[UINavigationController alloc] initWithRootViewController:classV];
                }
                classDetailV.fromName = @"tab";
            }
            classDetailV.cId = cid;
                       
            controllers = [NSArray arrayWithObjects:schoolNavi, customizationNavi,ParkNavi, nil];
        //}
        //-----------------------------------------------------------------------------------------------
        
 
        //设置tabbar的控制器
        MyTabBarController *tabBar = [[MyTabBarController alloc] initWithSelectIndex:0];
        tabBar.viewControllers = controllers;
        tabBar.selectedIndex = 0;
        appDelegate.tabBarController = tabBar;
        
    }
    
    [appDelegate.tabBarController selectedTab:[[appDelegate.tabBarController buttons] objectAtIndex:0]];
    UINavigationController *tabBarControllerNavi = (UINavigationController *)self.tabBarController.selectedViewController;
    [tabBarControllerNavi popToRootViewControllerAnimated:NO];
    
    appDelegate.tabBarController.view.frame = [[UIScreen mainScreen] bounds];
    
   
//    [self.window setRootViewController:self.tabBarController];
//    [self.window bringSubviewToFront:self.tabBarController.view];
    

    
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

- (void)handleUserProfile:(NSDictionary *)message_info {
    NSDictionary *profile = [message_info objectForKey:@"profile"];
    NSDictionary *role = [message_info objectForKey:@"role"];
    
    if ([@"-1" isEqual: [NSString stringWithFormat:@"%@", [role objectForKey:@"id"]]]) {
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithDictionary:profile];
        
        NSDictionary *vip = [message_info objectForKey:@"vip"];
        [infoDic setValue:[Utilities replaceNull:[vip objectForKey:@"opened"]] forKey:@"vip_opened"];
        [infoDic setValue:[Utilities replaceNull:[vip objectForKey:@"schoolEnabled"]] forKey:@"vip_schoolEnabled"];
        
        [Utilities doSaveSettingUserInfoToDefaultAndSingle:infoDic andRole:role];

        
        [[NSUserDefaults standardUserDefaults] setObject:[profile objectForKey:@"uid"] forKey:[NSString stringWithFormat:@"zhixiao_regUid"]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 登录时无身份信息
        if ([@"" isEqual: [profile objectForKey:@"name"]]) {
            
            _textFieldOri.text = @"";
            _textFieldNew.text = @"";
            
            // 登录时真实姓名为空
            SetIdentityViewController *setIdentity_viewCtrl = [[SetIdentityViewController alloc] init];
            //                UINavigationController *navigation = [[UINavigationController alloc] init];
            //
            //                [navigation setTitle:@"testNavigation"];
            //                [navigation initWithRootViewController:setIdentity_viewCtrl];
            //[self presentViewController:navigation animated:YES completion:nil];
            navigation_NoUserType = [[SubUINavigationController alloc] initWithRootViewController:setIdentity_viewCtrl];
            [self presentViewController:navigation_NoUserType animated:YES completion:nil];
            
            [[NSUserDefaults standardUserDefaults]setObject:@"noUserType" forKey:@"fromNameToHome"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            
        }else {
            
            
            NSDictionary *regNamePwd = [[NSDictionary alloc] initWithObjectsAndKeys:_textFieldOri.text, @"username", _textFieldNew.text, @"password",nil];
            
            // 登录时真实姓名不为空
            SetIdentityViewController *setIdentity_viewCtrl = [[SetIdentityViewController alloc] init];
            setIdentity_viewCtrl.regNamePwd = regNamePwd;
            //                UINavigationController *navigation = [[UINavigationController alloc] init];
            //                [navigation setTitle:@"testNavigation"];
            //                [navigation initWithRootViewController:setIdentity_viewCtrl];
            //
            //                [self presentViewController:navigation animated:YES completion:nil];
            navigation_NoUserType = [[SubUINavigationController alloc] initWithRootViewController:setIdentity_viewCtrl];
            [self presentViewController:navigation_NoUserType animated:YES completion:nil];
            
            [[NSUserDefaults standardUserDefaults]setObject:@"noUserType" forKey:@"fromNameToHome"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            _textFieldOri.text = @"";
            _textFieldNew.text = @"";
        }
    }else {
        // 登录时有身份信息
        if ([@"" isEqual: [profile objectForKey:@"name"]]) {
            // 登录时真实姓名为空
            NSString *iden;
            if ([@"0" isEqual: [NSString stringWithFormat:@"%@", [role objectForKey:@"id"]]]) {
                iden = @"student";
            }else if ([@"6" isEqual: [NSString stringWithFormat:@"%@", [role objectForKey:@"id"]]]) {
                iden = @"parent";
            }else if ([@"7" isEqual: [NSString stringWithFormat:@"%@", [role objectForKey:@"id"]]]) {
                iden = @"teacher";
            }
            
            SetPersonalViewController *setPersonal_viewCtrl = [[SetPersonalViewController alloc] init];
            setPersonal_viewCtrl.iden = iden;
            setPersonal_viewCtrl.type = @"fromLogin";
            //SubUINavigationController *navigation = [[SubUINavigationController alloc] init];
            //                    [navigation setTitle:@"testNavigation"];
            //                    [navigation initWithRootViewController:setPersonal_viewCtrl];
            //                    [self presentViewController:navigation animated:YES completion:nil];
            navigation_gotoPersonal = [[SubUINavigationController alloc]init];// 2015.10.20 切换账户不能退出问题
            [navigation_gotoPersonal setTitle:@"testNavigation"];
            [navigation_gotoPersonal initWithRootViewController:setPersonal_viewCtrl];
            [self presentViewController:navigation_gotoPersonal animated:YES completion:nil];
            
            _textFieldOri.text = @"";
            _textFieldNew.text = @"";
            
        }else {
            // 登录时真实姓名不为空
            // 存储个人信息
            NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithDictionary:profile];
            
            NSDictionary *vip = [message_info objectForKey:@"vip"];
            [infoDic setValue:[Utilities replaceNull:[vip objectForKey:@"opened"]] forKey:@"vip_opened"];
            [infoDic setValue:[Utilities replaceNull:[vip objectForKey:@"schoolEnabled"]] forKey:@"vip_schoolEnabled"];
            
            [Utilities doSaveUserInfoToDefaultAndSingle:infoDic andRole:role];

            
            //----update by kate--------------------------------
            // 到主页
            /* MicroSchoolMainMenuViewController *mainMenuViewCtrl = [[MicroSchoolMainMenuViewController alloc] init];
             MicroSchoolMainMenuNaviViewController *navigation = [[MicroSchoolMainMenuNaviViewController alloc] init];
             [navigation initWithRootViewController:mainMenuViewCtrl];
             [self presentViewController:navigation animated:YES completion:nil];*/
            //[self dismissViewControllerAnimated:NO completion:nil];
            [[NSUserDefaults standardUserDefaults]setObject:@"login" forKey:@"fromNameToHome"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self initTabBarController];// add by kate
            //-----------------------------------------------------------------------------
            // update 2015.10.21 教育服务发布商品 不能进入相册问题 原因是controller不在window上
            //                        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
            //                        [self presentViewController:appDelegate.tabBarController animated:NO completion:nil];
            MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
            LeftViewController * leftController = [[LeftViewController alloc] init];
            WWSideslipViewController * wwsideslioController = [[WWSideslipViewController alloc] initWithLeftView:leftController andMainView:appDelegate.tabBarController andBackgroundImage:[UIImage imageNamed:@""]];
            appDelegate.window.rootViewController = wwsideslioController;
            
            //-------------------------------------------------------------------------------
            _textFieldOri.text = @"";
            _textFieldNew.text = @"";
            //--------------------------------------------------
        }
    }
}

- (void)doProfileActionView
{
    [Utilities showProcessingHud:self.view];
    
    // 登录成功后去服务器获取个人详细信息
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Profile", @"ac",
                          @"2", @"v",
                          @"view", @"op",
                          nil];

    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        NSLog(@"respDic:%@",respDic);
        
        if(true == [result intValue]) {
            NSDictionary* message_info = [respDic objectForKey:@"message"];
            
            NSDictionary *profile = [message_info objectForKey:@"profile"];
            NSDictionary *role = [message_info objectForKey:@"role"];
            
            if ([@"-1" isEqual: [NSString stringWithFormat:@"%@", [role objectForKey:@"id"]]]) {
                NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithDictionary:profile];
                
                NSDictionary *vip = [message_info objectForKey:@"vip"];
                [infoDic setValue:[Utilities replaceNull:[vip objectForKey:@"opened"]] forKey:@"vip_opened"];
                [infoDic setValue:[Utilities replaceNull:[vip objectForKey:@"schoolEnabled"]] forKey:@"vip_schoolEnabled"];
                
                [Utilities doSaveSettingUserInfoToDefaultAndSingle:infoDic andRole:role];

                
                [[NSUserDefaults standardUserDefaults] setObject:[profile objectForKey:@"uid"] forKey:[NSString stringWithFormat:@"zhixiao_regUid"]];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // 登录时无身份信息
                if ([@"" isEqual: [profile objectForKey:@"name"]]) {
                    
                    _textFieldOri.text = @"";
                    _textFieldNew.text = @"";
                    
                    // 登录时真实姓名为空
                    SetIdentityViewController *setIdentity_viewCtrl = [[SetIdentityViewController alloc] init];
                    //                UINavigationController *navigation = [[UINavigationController alloc] init];
                    //
                    //                [navigation setTitle:@"testNavigation"];
                    //                [navigation initWithRootViewController:setIdentity_viewCtrl];
                    //[self presentViewController:navigation animated:YES completion:nil];
                    navigation_NoUserType = [[SubUINavigationController alloc] initWithRootViewController:setIdentity_viewCtrl];
                    [self presentViewController:navigation_NoUserType animated:YES completion:nil];
                    
                    [[NSUserDefaults standardUserDefaults]setObject:@"noUserType" forKey:@"fromNameToHome"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    
                }else {
                    _textFieldOri.text = @"";
                    _textFieldNew.text = @"";
                    
                    // 登录时真实姓名不为空
                    SetIdentityViewController *setIdentity_viewCtrl = [[SetIdentityViewController alloc] init];
                    //                UINavigationController *navigation = [[UINavigationController alloc] init];
                    //                [navigation setTitle:@"testNavigation"];
                    //                [navigation initWithRootViewController:setIdentity_viewCtrl];
                    //
                    //                [self presentViewController:navigation animated:YES completion:nil];
                    navigation_NoUserType = [[SubUINavigationController alloc] initWithRootViewController:setIdentity_viewCtrl];
                    [self presentViewController:navigation_NoUserType animated:YES completion:nil];
                    
                    [[NSUserDefaults standardUserDefaults]setObject:@"noUserType" forKey:@"fromNameToHome"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
            }else {
                // 登录时有身份信息
                if ([@"" isEqual: [profile objectForKey:@"name"]]) {
                    // 登录时真实姓名为空
                    NSString *iden;
                    if ([@"0" isEqual: [NSString stringWithFormat:@"%@", [role objectForKey:@"id"]]]) {
                        iden = @"student";
                    }else if ([@"6" isEqual: [NSString stringWithFormat:@"%@", [role objectForKey:@"id"]]]) {
                        iden = @"parent";
                    }else if ([@"7" isEqual: [NSString stringWithFormat:@"%@", [role objectForKey:@"id"]]]) {
                        iden = @"teacher";
                    }
                    
                    SetPersonalViewController *setPersonal_viewCtrl = [[SetPersonalViewController alloc] init];
                    setPersonal_viewCtrl.iden = iden;
                    setPersonal_viewCtrl.type = @"fromLogin";
                    //SubUINavigationController *navigation = [[SubUINavigationController alloc] init];
//                    [navigation setTitle:@"testNavigation"];
//                    [navigation initWithRootViewController:setPersonal_viewCtrl];
//                    [self presentViewController:navigation animated:YES completion:nil];
                    navigation_gotoPersonal = [[SubUINavigationController alloc]init];// 2015.10.20 切换账户不能退出问题
                    [navigation_gotoPersonal setTitle:@"testNavigation"];
                    [navigation_gotoPersonal initWithRootViewController:setPersonal_viewCtrl];
                    [self presentViewController:navigation_gotoPersonal animated:YES completion:nil];
                    
                    _textFieldOri.text = @"";
                    _textFieldNew.text = @"";
                    
                }else {
                    // 登录时真实姓名不为空
                    // 存储个人信息
                    NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithDictionary:profile];
                    
                    NSDictionary *vip = [message_info objectForKey:@"vip"];
                    [infoDic setValue:[Utilities replaceNull:[vip objectForKey:@"opened"]] forKey:@"vip_opened"];
                    [infoDic setValue:[Utilities replaceNull:[vip objectForKey:@"schoolEnabled"]] forKey:@"vip_schoolEnabled"];
                    
                    [Utilities doSaveUserInfoToDefaultAndSingle:infoDic andRole:role];

                    
                    //----update by kate--------------------------------
                    // 到主页
                    /* MicroSchoolMainMenuViewController *mainMenuViewCtrl = [[MicroSchoolMainMenuViewController alloc] init];
                     MicroSchoolMainMenuNaviViewController *navigation = [[MicroSchoolMainMenuNaviViewController alloc] init];
                     [navigation initWithRootViewController:mainMenuViewCtrl];
                     [self presentViewController:navigation animated:YES completion:nil];*/
                    //[self dismissViewControllerAnimated:NO completion:nil];
                    [[NSUserDefaults standardUserDefaults]setObject:@"login" forKey:@"fromNameToHome"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    [self initTabBarController];// add by kate
                    //-----------------------------------------------------------------------------
                    // update 2015.10.21 教育服务发布商品 不能进入相册问题 原因是controller不在window上
                    //                        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
                    //                        [self presentViewController:appDelegate.tabBarController animated:NO completion:nil];
                    
                    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
                    LeftViewController * leftController = [[LeftViewController alloc] init];
                    WWSideslipViewController * wwsideslioController = [[WWSideslipViewController alloc] initWithLeftView:leftController andMainView:appDelegate.tabBarController andBackgroundImage:[UIImage imageNamed:@""]];
                    appDelegate.window.rootViewController = wwsideslioController;
                    
                    //-------------------------------------------------------------------------------
                    _textFieldOri.text = @"";
                    _textFieldNew.text = @"";
                    //--------------------------------------------------
                }
            }
        } else {
            NSString* message_info = [respDic objectForKey:@"message"];
            
            if ([@""  isEqual: message_info]) {
                message_info = @"登录失败，请重新登录。";
            }
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

@end
