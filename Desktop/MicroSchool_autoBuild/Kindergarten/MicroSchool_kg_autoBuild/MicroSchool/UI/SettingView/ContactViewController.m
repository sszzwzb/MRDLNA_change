//
//  ContactViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-7.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()

@end

@implementation ContactViewController

#define IS_MAIL 0

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
    [super setCustomizeTitle:@"联系方式"];
    [super setCustomizeLeftButton];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self hideKeyBoard];
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
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(
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
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    
    [scrollerView addSubview:_tableView];
    
    
    // 获取当前用户的信息
    NSMutableDictionary *user = [g_userInfo getUserDetailInfo];
    NSString *mobile= [user objectForKey:@"mobile"];
    NSString *email= [user objectForKey:@"email"];
    NSString *qq= [user objectForKey:@"qq"];
    //NSString *msn= [user objectForKey:@"msn"];
    
    // 电话
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        _labelPhone = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                110,
                                                                49,
                                                                180,
                                                                20)];
    }
    else
    {
        _labelPhone = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                110,
                                                                26,
                                                                180,
                                                                20)];
    }
    
    if (mobile.length == 0) {
        mobile = @"暂无";
    }
    _labelPhone.text = mobile;
    _labelPhone.textColor = [UIColor blackColor];
    _labelPhone.backgroundColor = [UIColor clearColor];
    _labelPhone.font = [UIFont systemFontOfSize:15.0f];
    _labelPhone.textAlignment = NSTextAlignmentLeft;
    [_tableView addSubview:_labelPhone];
    
    if (IS_MAIL) {
        // 邮箱
        CGRect rect_mail = CGRectMake(
                                      _labelPhone.frame.origin.x,
                                      _labelPhone.frame.origin.y + _labelPhone.frame.size.height + 30,
                                      180,
                                      20);
        _textFieldMail = [[UITextField alloc]initWithFrame:rect_mail];
        [_textFieldMail performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.01];
        
        [self setInputTextField:email andRect:rect_mail andType:@"text" andPoint:_textFieldMail];
        
        // qq
        CGRect rect_qq = CGRectMake(
                                    _textFieldMail.frame.origin.x,
                                    _textFieldMail.frame.origin.y + _textFieldMail.frame.size.height + 30,
                                    180,
                                    20);
        _textFieldQq = [[UITextField alloc]initWithFrame:rect_qq];
        [self setInputTextField:qq andRect:rect_qq andType:@"text" andPoint:_textFieldQq];
        
        // msn
        CGRect rect_msn = CGRectMake(
                                     _textFieldQq.frame.origin.x,
                                     _textFieldQq.frame.origin.y + _textFieldQq.frame.size.height + 30,
                                     180,
                                     20);
        _textFieldMsn = [[UITextField alloc]initWithFrame:rect_msn];
        //[self setInputTextField:msn andRect:rect_msn andType:@"text" andPoint:_textFieldMsn];
    } else {
        // qq
        CGRect rect_qq = CGRectMake(
                                    _labelPhone.frame.origin.x,
                                    _labelPhone.frame.origin.y + _labelPhone.frame.size.height + 30,
                                    180,
                                    20);
        _textFieldQq = [[UITextField alloc]initWithFrame:rect_qq];
        [_textFieldQq performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.01];
        
        [self setInputTextField:qq andRect:rect_qq andType:@"text" andPoint:_textFieldQq];
        
        // msn
        CGRect rect_msn = CGRectMake(
                                     _textFieldQq.frame.origin.x,
                                     _textFieldQq.frame.origin.y + _textFieldQq.frame.size.height + 30,
                                     180,
                                     20);
        _textFieldMsn = [[UITextField alloc]initWithFrame:rect_msn];
//        [self setInputTextField:msn andRect:rect_msn andType:@"text" andPoint:_textFieldMsn];
    }

    // 保存button
    button_save = [UIButton buttonWithType:UIButtonTypeCustom];
    button_save.frame = CGRectMake(30, _textFieldMsn.frame.origin.y + _textFieldMsn.frame.size.height + 30, 260, 40);
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
    [button_save setTitle:@"保存" forState:UIControlStateNormal];
    [button_save setTitle:@"保存" forState:UIControlStateHighlighted];
    
    [scrollerView addSubview:button_save];
}

- (IBAction)save_btnclick:(id)sender
{
    // 防止多次快速提交
    button_save.enabled = NO;

    if (30 < _textFieldQq.text.length) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"QQ号码大于30位，请重新输入"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
        button_save.enabled = YES;  
    }
//    else if (30 < _textFieldMsn.text.length) {
//        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
//                                                       message:@"MSN号码大于30位，请重新输入"
//                                                      delegate:nil
//                                             cancelButtonTitle:@"确定"
//                                             otherButtonTitles:nil];
//        [alert show];
//        button_save.enabled = YES;
//    }
    else {
        
        [Utilities showProcessingHud:self.view];
        // 获取当前用户的信息
        NSDictionary *user = [g_userInfo getUserDetailInfo];
        NSString *uid= [user objectForKey:@"uid"];
        NSString *username= [user objectForKey:@"username"];
        
        if (IS_MAIL) {
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  AC_CONTACT, @"url",
                                  username, @"username",
                                  _textFieldMail.text, @"email",
                                  _textFieldQq.text, @"qq",
                                  @"", @"msn",
                                  nil];
            
            [network sendHttpReq:HttpReq_UpdateContact andData:data];
        } else {
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:AC_CONTACT, @"url",
                                  username, @"username",
                                  _textFieldQq.text, @"qq",
                                  @"", @"msn",
                                  nil];
            [network sendHttpReq:HttpReq_UpdateContact andData:data];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) setInputTextField:(NSString*) nameString andRect:(CGRect) rect andType:(NSString*) type andPoint:(UITextField*) text
{
    //text = [[UITextField alloc]initWithFrame:rect];
    
    text.borderStyle = UITextBorderStyleNone;
    text.backgroundColor = [UIColor clearColor];
    
    if (nil == nameString) {
        text.text = @"";
    }
    else {
        text.text = nameString;
    }
    
    text.font = [UIFont systemFontOfSize:15.0f];
    text.textColor = [UIColor blackColor];
    text.clearButtonMode = UITextFieldViewModeNever;
    text.textAlignment = NSTextAlignmentLeft;
    if ([@"text"  isEqual: type])
    {
        text.keyboardType=UIKeyboardTypeDefault;
    }
    else if ([@"veri"  isEqual: type])
    {
        text.keyboardType=UIKeyboardTypeNumberPad;
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
    [_tableView addSubview:text];
}

//定义UITextFiled的代理方法：
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.location >= 30)
        return NO; // return NO to not change text
    return YES;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    if (0 == section) {
        if (IS_MAIL) {
            return 4;
        } else {
            return 2;
        }
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.textAlignment = NSTextAlignmentRight;

    if (IS_MAIL) {
        if (0 == [indexPath section] && 0 == [indexPath row]) {
            cell.textLabel.text = @"电话:";
        }else if (0 == [indexPath section] && 1 == [indexPath row]){
            cell.textLabel.text = @"电子邮箱:";
        }else if (0 == [indexPath section] && 2 == [indexPath row]){
            cell.textLabel.text = @"QQ:";
        }else if (0 == [indexPath section] && 3 == [indexPath row]){
            cell.textLabel.text = @"MSN:";
        }else{
            return nil;
        }
    } else {
        if (0 == [indexPath section] && 0 == [indexPath row]) {
            cell.textLabel.text = @"电话:";
        }else if (0 == [indexPath section] && 1 == [indexPath row]){
            cell.textLabel.text = @"QQ:";
        }else if (0 == [indexPath section] && 2 == [indexPath row]){
            cell.textLabel.text = @"MSN:";
        }else{
            return nil;
        }
    }
    
    //设置textLabel的背景色为空
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
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
    //NSString* message_info = [resultJSON objectForKey:@"message"];
    
    if(true == [result intValue])
    {
        NSMutableDictionary *userInfo = [g_userInfo getUserDetailInfo];

        if (IS_MAIL) {
            [userInfo setObject:_textFieldMail.text forKey:@"email"];
        }
        
        [userInfo setObject:_textFieldQq.text forKey:@"qq"];
        

        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"完成"
                                                       message:@"联系方式更新成功"
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
        
        // 修改成功，gps上报
        DataReport *dr = [DataReport sharedGlobalSingletonDataReport];
        [dr dataReportGPStype:DataReport_Act_Contact];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"失败"
                                                       message:@"联系方式更新失败，请重试"
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
