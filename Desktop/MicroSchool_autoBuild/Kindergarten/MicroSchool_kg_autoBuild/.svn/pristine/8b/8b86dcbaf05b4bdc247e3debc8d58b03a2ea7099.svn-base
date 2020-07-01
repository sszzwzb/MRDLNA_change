//
//  SignManageViewController.m
//  MicroSchool
//
//  Created by banana on 16/9/13.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "SignManageViewController.h"
#import "ChangeSignNumberViewController.h"
@interface SignManageViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>{
    NSDictionary *user_info;
}
@property (nonatomic, strong) TSTableView *signManageVC;
@property (nonatomic, strong) UITextField *textView;
@property (nonatomic, strong) NSString *usertype;
@property (nonatomic, strong) UISwitch* mySwitch;
@property (nonatomic, assign) BOOL config;
@end


@implementation SignManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setCustomizeTitle:@"管理"];
    [self setCustomizeLeftButton];
    user_info = [g_userInfo getUserDetailInfo];
    
    _usertype = [NSString stringWithFormat:@"%@", [user_info objectForKey:@"role_id"]];
    //家长
    if([_usertype intValue] == 6){
        
    }else if([_usertype intValue] == 0){
        //学生
        [self setCustomizeRightButtonWithName:@"保存"];
    }else{
        //其他
        
        [self setCustomizeRightButtonWithName:@"保存"];
    }
    
}
- (void)buildTableView{
    self.signManageVC = [[TSTableView alloc] init];
    _signManageVC.frame = CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height - 44);
    _signManageVC.scrollEnabled = NO;
    //    _signManageVC.backgroundColor = [UIColor whiteColor];
    _signManageVC.delegate = self;
    _signManageVC.dataSource = self;
    [self.view addSubview:_signManageVC];
    if ([_usertype intValue] == 6) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, 86)];
        headView.backgroundColor = TS_COLOR_BACKGROUND_GREY_RGB;
        _signManageVC.tableHeaderView = headView;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255  blue:102.0 / 255 alpha:1];
        nameLabel.text = [NSString stringWithFormat:@"当前子女: %@", [user_info objectForKey:@"student_name"]];
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.frame = CGRectMake(15, 25, [UIScreen mainScreen].applicationFrame.size.width - 30 , 16);
        [headView addSubview:nameLabel];
        
        UILabel *IDLabel = [[UILabel alloc] init];
        IDLabel.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255  blue:102.0 / 255 alpha:1];
        IDLabel.font = [UIFont systemFontOfSize:14];
        IDLabel.text = [NSString stringWithFormat:@"ID: %@", [user_info objectForKey:@"student_number"]];
        IDLabel.frame = CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y + 22, [UIScreen mainScreen].applicationFrame.size.width - 30 , 16);
        [headView addSubview:IDLabel];
        
    }else{
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        headView.backgroundColor = [UIColor clearColor];
        _signManageVC.tableHeaderView = headView;
    }
}
- (void)askCardId{
    NSDictionary *message_info;
    message_info = [g_userInfo getUserDetailInfo];
    
    // 数据部分
    if (nil == message_info) {
        message_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDetailInfo"];
    }
    NSString *cid = [message_info objectForKey:@"role_cid"];
    NSString *uid = [message_info objectForKey:@"uid"];
    NSString *studentNumberId = [NSString stringWithFormat:@"%@",[message_info objectForKey:@"student_number_id"]];
    [Utilities showProcessingHud:self.view];
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Checkin",@"ac",
                          @"3",@"v",
                          @"card", @"op",
                          cid, @"cid",
                          uid, @"uid",
                          studentNumberId, @"number",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            _haveOldCard = [[respDic objectForKey:@"message"] objectForKey:@"card"];
            if ([(NSDictionary *)[respDic objectForKey:@"message"] count] <= 0) {
                [Utilities showNodataView:@"数据错误 请重试" msg2:@"" andRect:[Utilities getScreenRectWithoutBar] descView:self.view imgName:nil startY:0];
            }else{
                _haveOldCard = [[respDic objectForKey:@"message"] objectForKey:@"card"];
                [self buildTableView];
            }
            if ([[[respDic objectForKey:@"message"] objectForKey:@"notification"] isEqual:@"0"]) {
                _config = 1;
            }else{
                _config = 0;
            }
        }else{
            
            [Utilities showTextHud:@"网络异常，请稍后再试" descView:self.view];
            
            
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([_usertype intValue] == 6) {
        
        UIView *footView = [[UIView alloc] init];
        footView.frame = CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, 40);
        footView.backgroundColor = [UIColor clearColor];
        return footView;
    }else{
        UIView *tempView = [[UIView alloc] init];
        return tempView;
    }
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([_usertype integerValue] == 6) {
        return 20;
    }else{
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([_usertype intValue] == 6) {
        
        UIView *headView = [[UIView alloc] init];
        headView.frame = CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, 0.5);
        headView.backgroundColor = TS_COLOR_BACKGROUND_GREY_RGB;
        return headView;
    }else{
        UIView *tempView = [[UIView alloc] init];
        return tempView;
    }
}
#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == self.textView) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 10) {
            return NO;
        }
    }
    
    return YES;
}

- (void)selectRightAction:(id)sender
{
    [_textView resignFirstResponder];
    if (![Utilities isConnected]) {
        [Utilities showTextHud:@"网络异常，请检查网络。" descView:self.view];
    }else{
        if ([_textView.text isEqualToString:@""]) {
            
            [Utilities showTextHud:@"请输入签到卡ID" descView:self.view];
            
        }else if ([_textView.text length]!=10){
            
            [Utilities showTextHud:@"请输入正确的10位卡号" descView:self.view];
            
        }else{
//            TSAlertView *alert = [[TSAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确认将您绑定的考勤卡改为卡号为%@的考勤卡?", _textView.text]];
            
//            [alert addBtnTitle:@"取消" action:^{
//                // nothing to do
//            }];
//            [alert addBtnTitle:@"确定" action:^{
//
//
//
//                [self getData];
//
//            }];
//
//            [alert showAlertWithSender:self];
            
            NSString *msg = [NSString stringWithFormat:@"确认将您绑定的签到卡改为卡号为%@的签到卡?", _textView.text];
            TSPopupItemHandler handlerTest = ^(NSInteger index, NSString *btnTitle){
                
                [self getData];
            };
            
            NSArray *itemsArr =
            @[TSItemMake(@"确定", TSItemTypeNormal, handlerTest)];
            [Utilities showPopupView:[NSString stringWithFormat:@"%@", msg] items:itemsArr];
        }
    }
    
}
-(void)getData{//2015.09.16
    if ([_textView.text isEqual:@""]) {
        [Utilities showTextHud:@"请输入卡号" descView:self.view];
    }else{
        NSDictionary *message_info;
        message_info = [g_userInfo getUserDetailInfo];
        
        // 数据部分
        if (nil == message_info) {
            message_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDetailInfo"];
        }
        NSString *cid = [message_info objectForKey:@"role_cid"];
        NSString *uid = [message_info objectForKey:@"uid"];
        [Utilities showProcessingHud:self.view];
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Checkin",@"ac",
                              @"3",@"v",
                              @"ChangeCard", @"op",
                              cid, @"cid",
                              uid, @"uid",
                              _haveOldCard, @"oldCard",
                              _textView.text, @"newCard",
                              nil];
        
        [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
            
            [Utilities dismissProcessingHud:self.view];
            NSDictionary *respDic = (NSDictionary*)responseObject;
            NSString *result = [respDic objectForKey:@"result"];
            
            if ([result integerValue] == 1) {
                
                NSLog(@"success");
                
                [Utilities showSuccessedHud:@"保存成功" descView:self.view];
                [self performSelector:@selector(back) withObject:nil afterDelay:0.5];
                
                
            }else{
                
                [Utilities showTextHud:[respDic objectForKey:@"message"] descView:self.view];
                
            }
            
            
        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
            [Utilities dismissProcessingHud:self.view];
            [Utilities showTextHud:@"请重新输入" descView:self.view];
        }];
    }
    
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:_signManageVC.frame];
        [self.view addSubview:noNetworkV];
        return;
    }
    
    [self askCardId];
}
#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_usertype intValue] == 6) {
        return 2;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"leaveHomeCell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }else{
    }
    
    
    if ([_usertype intValue] == 6) {
        if (indexPath.section == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            
            
            UILabel *textLabel = [[UILabel alloc] init];
            textLabel.text = @"签到卡号";
            textLabel.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
            textLabel.font = [UIFont systemFontOfSize:16];
            textLabel.frame = CGRectMake(15, 15, 70, 18);
            textLabel.backgroundColor = [UIColor clearColor];
            [cell addSubview:textLabel];
            
            
            
            UILabel *textView = [[UILabel alloc] init];
            textView.text = _haveOldCard;
            textView.textColor = [UIColor colorWithRed:51.0 / 255 green:51.0 / 255 blue:51.0 / 255 alpha:1];
            //        textView.returnKeyType = UIReturnKeyDone;
            textView.font = [UIFont systemFontOfSize:16];
            textView.frame = CGRectMake(100, 15, 150, 18);
            textView.backgroundColor = [UIColor clearColor];
            //        textView.delegate = self;
            [cell addSubview:textView];
            
            UILabel *detailtext = [[UILabel alloc] init];
            detailtext.text = @"更改";
            detailtext.textColor = [UIColor colorWithRed:153.0 / 255 green:153.0 / 255 blue:153.0 / 255 alpha:1];
            detailtext.font = [UIFont systemFontOfSize:14];
            detailtext.frame = CGRectMake([UIScreen mainScreen].applicationFrame.size.width - 50 - 15, 13, 40, 18);
            detailtext.backgroundColor = [UIColor clearColor];
            [cell addSubview:detailtext];
        }else{
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            UILabel *textLabel = [[UILabel alloc] init];
            textLabel.text = @"打卡推送消息";
            textLabel.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
            textLabel.font = [UIFont systemFontOfSize:16];
            textLabel.frame = CGRectMake(15, 15, 150, 18);
            textLabel.backgroundColor = [UIColor clearColor];
            [cell addSubview:textLabel];
            
            
            
            
            _mySwitch = [[ UISwitch alloc]initWithFrame:CGRectMake([UIScreen mainScreen].applicationFrame.size.width - 70 , 8,0.0,0.0)];
//            [_mySwitch setOnTintColor:[UIColor colorWithRed:51.0 / 255 green:153.0 / 255 blue:255.0 / 255 alpha:1]];
            [cell addSubview:_mySwitch];//添加到父视图
            [_mySwitch setOn:_config animated:YES];
            [_mySwitch addTarget: self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
            
        }
    }else{
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.text = @"签到卡号";
        textLabel.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
        textLabel.font = [UIFont systemFontOfSize:16];
        textLabel.frame = CGRectMake(15, 15, 70, 18);
        textLabel.backgroundColor = [UIColor clearColor];
        [cell addSubview:textLabel];
        
        self.textView = [[UITextField alloc] init];
        _textView.text = _haveOldCard;
        _textView.keyboardType = UIKeyboardTypeNumberPad;
        _textView.textColor = [UIColor colorWithRed:51.0 / 255 green:51.0 / 255 blue:51.0 / 255 alpha:1];
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.frame = CGRectMake(100, 15, 200, 18);
        _textView.backgroundColor = [UIColor clearColor];
        _textView.delegate = self;
        [cell addSubview:_textView];
    }
    return cell;
    
}

- (void) switchValueChanged:(id)sender{
    UISwitch* control = (UISwitch*)sender;
    if(control == _mySwitch){
        if(_mySwitch.on==YES){
            NSLog(@"开关被打开");
            _config = 1;
        }else{
            NSLog(@"开关被关闭");
            _config = 0;
        }
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_textView resignFirstResponder];
    TSAlertView *alert = [[TSAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确认将您绑定的签到卡改为卡号为%@的签到卡?", _textView.text]];
    
    [alert addBtnTitle:@"取消" action:^{
        // nothing to do
    }];
    [alert addBtnTitle:@"确定" action:^{
        
        
        [self getData];
        
    }];
    
    [alert showAlertWithSender:self];
    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_signManageVC deselectRowAtIndexPath:indexPath animated:YES];
    if ([_usertype integerValue] == 6) {
        
        ChangeSignNumberViewController *csn = [[ChangeSignNumberViewController alloc] init];
        csn.haveOldCard = _haveOldCard;
        [self.navigationController pushViewController:csn animated:YES];
    }
}

- (void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    NSString *cid = [NSString stringWithFormat:@"%ld", [[user_info objectForKey:@"role_cid"] integerValue]];
    NSString *uid = [NSString stringWithFormat:@"%ld", [[user_info objectForKey:@"uid"]integerValue]];
    NSString *number = [NSString stringWithFormat:@"%ld", [[user_info objectForKey:@"student_number_id"]integerValue]];
    NSString *tempConfig;
    if (_config) {
        tempConfig = @"0";
    }else{
        tempConfig = @"1";
    }
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"3", @"v",
                          @"Checkin", @"ac",
                          @"notificationConfig", @"op",
                          cid, @"cid",
                          uid, @"uid",
                          number, @"number",
                          tempConfig, @"config",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        NSString *msg = [respDic objectForKey:@"message"];
        
        if(true == [result intValue]) {
            
            
            [Utilities showSuccessedHud:msg descView:self.view];
            
            
        } else {
            
            
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {

    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
