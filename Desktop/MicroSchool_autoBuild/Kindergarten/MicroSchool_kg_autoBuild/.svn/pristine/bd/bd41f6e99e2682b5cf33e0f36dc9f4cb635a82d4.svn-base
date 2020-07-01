//
//  PasswordViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-7.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "PasswordViewController.h"

@interface PasswordViewController ()

@end

@implementation PasswordViewController

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
    [super setCustomizeTitle:@"修改密码"];
    [super setCustomizeLeftButton];
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
    // 设置背景scrollView
    UIScrollView* scrollerView =[UIScrollView new];
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
    
    _textFieldOri =[UITextField new];
    _textFieldOri.borderStyle = UITextBorderStyleNone;
    _textFieldOri.backgroundColor = [UIColor clearColor];
    _textFieldOri.placeholder = @"请输入旧密码";
    _textFieldOri.font = [UIFont systemFontOfSize:15.0f];
    _textFieldOri.textColor = [UIColor blackColor];
    _textFieldOri.textAlignment = NSTextAlignmentLeft;
    _textFieldOri.keyboardType=UIKeyboardTypeDefault;
    _textFieldOri.returnKeyType =UIReturnKeyDone;
    _textFieldOri.delegate = self;
    _textFieldOri.secureTextEntry = YES;
    [_textFieldOri performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.01];
    [tableViewIns addSubview:_textFieldOri];
    
    if (iPhone5)
    {
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        {
            [_textFieldOri mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(tableViewIns.mas_top).with.offset(49);
                make.left.equalTo(tableViewIns.mas_left).with.offset(15);
                make.size.mas_equalTo(CGSizeMake(150,20));
            }];
        }else{
            [_textFieldOri mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(tableViewIns.mas_top).with.offset(25);
                make.left.equalTo(tableViewIns.mas_left).with.offset(15);
                make.size.mas_equalTo(CGSizeMake(150,20));
            }];
        }
    }
    else
    {
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        {
            [_textFieldOri mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(tableViewIns.mas_top).with.offset(49);
                make.left.equalTo(tableViewIns.mas_left).with.offset(15);
                make.size.mas_equalTo(CGSizeMake(150,20));
            }];
            
        }
        else
        {
            [_textFieldOri mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(tableViewIns.mas_top).with.offset(26);
                make.left.equalTo(tableViewIns.mas_left).with.offset(15);
                make.size.mas_equalTo(CGSizeMake(150,20));
            }];
        }
    }

    _textFieldOri.borderStyle = UITextBorderStyleNone;
    _textFieldOri.backgroundColor = [UIColor clearColor];
    _textFieldOri.placeholder = @"请输入旧密码";
    _textFieldOri.font = [UIFont systemFontOfSize:15.0f];
    _textFieldOri.textColor = [UIColor blackColor];
    _textFieldOri.textAlignment = NSTextAlignmentLeft;
    _textFieldOri.keyboardType=UIKeyboardTypeDefault;
    _textFieldOri.returnKeyType =UIReturnKeyDone;
    _textFieldOri.delegate = self;
    _textFieldOri.secureTextEntry = YES;
    [_textFieldOri performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.01];
    [tableViewIns addSubview:_textFieldOri];
    
    _textFieldNew =[UITextField new];
    _textFieldNew.borderStyle = UITextBorderStyleNone;
    _textFieldNew.backgroundColor = [UIColor clearColor];
    _textFieldNew.placeholder = @"请输入新密码";
    _textFieldNew.font = [UIFont systemFontOfSize:15.0f];
    _textFieldNew.textColor = [UIColor blackColor];
    _textFieldNew.textAlignment = NSTextAlignmentLeft;
    _textFieldNew.keyboardType=UIKeyboardTypeDefault;
    _textFieldNew.returnKeyType =UIReturnKeyDone;
    _textFieldNew.delegate = self;
    _textFieldNew.secureTextEntry = YES;
    [tableViewIns addSubview:_textFieldNew];
    [_textFieldNew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textFieldOri.mas_bottom).with.offset(30);
        make.left.equalTo(_textFieldOri.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(150,20));
    }];
    
    _textFieldVeri =[UITextField new];
    _textFieldVeri.borderStyle = UITextBorderStyleNone;
    _textFieldVeri.backgroundColor = [UIColor clearColor];
    _textFieldVeri.placeholder = @"再次输入新密码";
    _textFieldVeri.font = [UIFont systemFontOfSize:15.0f];
    _textFieldVeri.textColor = [UIColor blackColor];
    _textFieldVeri.textAlignment = NSTextAlignmentLeft;
    _textFieldVeri.keyboardType=UIKeyboardTypeDefault;
    _textFieldVeri.returnKeyType =UIReturnKeyDone;
    _textFieldVeri.delegate = self;
    _textFieldVeri.secureTextEntry = YES;
    [tableViewIns addSubview:_textFieldVeri];
    [_textFieldVeri mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textFieldNew.mas_bottom).with.offset(32);
        make.left.equalTo(_textFieldNew.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(150,20));
    }];

    UILabel *label =[UILabel new];
    label.text = @"密码6~12位";
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont systemFontOfSize:13.0f];
    label.numberOfLines = 0;
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor clearColor];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    [scrollerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textFieldVeri.mas_bottom).with.offset(20);
        make.left.equalTo(scrollerView.mas_left).with.offset(16);
        make.size.mas_equalTo(CGSizeMake(260,20));
    }];

    // 保存button
    button_save = [UIButton buttonWithType:UIButtonTypeCustom];
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
    [button_save setTitle:@"保存" forState:UIControlStateNormal];
    [button_save setTitle:@"保存" forState:UIControlStateHighlighted];
    
    [scrollerView addSubview:button_save];
    [button_save mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).with.offset(20);
        make.left.equalTo(scrollerView.mas_left).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(WIDTH-30,40));
    }];
}

- (IBAction)save_btnclick:(id)sender
{
    button_save.enabled = NO;

    if(_textFieldOri.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                      message:@"旧密码不能为空，请重新输入"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
        button_save.enabled = YES;
    }
    else if(![_textFieldNew.text  isEqual: _textFieldVeri.text])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                      message:@"两次输入新密码不一致，请重新输入"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
        button_save.enabled = YES;
    }
    else if((_textFieldNew.text.length == 0) || (_textFieldVeri.text.length == 0))
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                       message:@"新密码输入不能为空，请重新输入"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
        button_save.enabled = YES;
    }
    else if((_textFieldNew.text.length < 6) || (_textFieldVeri.text.length < 6))
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                       message:@"新密码输入小于6位，请重新输入。"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
        button_save.enabled = YES;
    }

    else
    {
        [self hideKeyBoard];
        [Utilities showProcessingHud:self.view];
        
        // 获取当前用户的信息
        NSDictionary *user = [g_userInfo getUserDetailInfo];
        NSString *username= [user objectForKey:@"username"];
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              AC_PASSWORD, @"url",
                              username, @"username",
                              _textFieldOri.text, @"password",
                              _textFieldVeri.text, @"newpasswd1",
                              nil];
        
        [network sendHttpReq:HttpReq_ChangePassword andData:data];
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
    PasswordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    
    if (cell == nil) {
        cell = [[PasswordTableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
//    if (0 == [indexPath section] && 0 == [indexPath row]) {
//        cell.pwd = @"旧密码:";
//    }else if (0 == [indexPath section] && 1 == [indexPath row]){
//        cell.pwd = @"新密码:";
//    }else if (0 == [indexPath section] && 2 == [indexPath row]){
//        cell.pwd = @"确认密码:";
//    }else{
//        return nil;
//    }
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    //设置textLabel的背景色为空
    cell.textLabel.backgroundColor = [UIColor clearColor];

    return cell;
}

//定义UITextFiled的代理方法：
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField!= _textFieldOri){
        if (range.location >= 12)
            return NO; // return NO to not change text
    }
    
    return YES;
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    [Utilities dismissProcessingHud:self.view];
    button_save.enabled = YES;
    
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    NSString* message_info = [resultJSON objectForKey:@"message"];
    
    
    if(true == [result intValue])
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"成功"
                                                       message:message_info
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
        
        // 修改成功，gps上报
        DataReport *dr = [DataReport sharedGlobalSingletonDataReport];
        [dr dataReportGPStype:DataReport_Act_ChangePwd];
        [ReportObject event:ID_RESET_PASSWORD];//2015.06.25
    }
    else
    {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:message_info
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

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    PasswordTableViewCell *cell = (PasswordTableViewCell *)[[textField superview] superview];
//    NSIndexPath *indexPath = [tableViewIns indexPathForCell:cell];
//    
//    NSLog(@"%d",indexPath.row);
//}
@end
