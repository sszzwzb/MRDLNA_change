//
//  NoCardViewController.m
//  MicroSchool
//
//  Created by Kate on 16/9/13.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "NoCardViewController.h"
#import "MyTabBarController.h"
#import "MyCheckinHome.h"

@interface NoCardViewController ()

@end

@implementation NoCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomizeTitle:_titleName];
    [self setCustomizeLeftButton];
    
    self.view.backgroundColor = TS_COLOR_BACKGROUND_GREY_RGB;
    
    UIColor *color = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    _textField_name = [[UITextField alloc] initWithFrame: CGRectMake(15.0, 11,[Utilities getScreenSize].width - 30.0, 21.0)];
    _textField_name.clearsOnBeginEditing = NO;//鼠标点上时，不清空
    _textField_name.borderStyle = UITextBorderStyleNone;
    _textField_name.backgroundColor = [UIColor clearColor];
    _textField_name.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入签到卡ID" attributes:@{NSForegroundColorAttributeName: color}];//设置placeholder颜色
    _textField_name.font = [UIFont systemFontOfSize:15.0f];
    _textField_name.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    _textField_name.textAlignment = NSTextAlignmentLeft;
    _textField_name.keyboardType = UIKeyboardTypeNumberPad;//考勤卡ID为纯数字 长度限制10位 经纬&Tony确认
    _textField_name.returnKeyType = UIReturnKeyDone;
    _textField_name.autocorrectionType = UITextAutocorrectionTypeNo;
    _textField_name.tintColor = [UIColor colorWithRed:18.0/255.0 green:65.0/255.0 blue:249.0/255.0 alpha:1];
    _textField_name.autocapitalizationType = UITextAutocapitalizationTypeNone;//add 2015.04.13
    [_textField_name setDelegate: self];
    _textField_name.tag = 120;
    
    
    float topHeight = 50.0;
    
    if (iPhone4) {
        topHeight = 25.0;
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Utilities getScreenSize].width, 44.0+topHeight+topHeight-9.0)];
    //headerView.backgroundColor = [UIColor redColor];
    UITextView *msgTxtV = [UITextView new];
    msgTxtV.backgroundColor = TS_COLOR_BACKGROUND_GREY_RGB;
    //msgTxtV.backgroundColor = [UIColor greenColor];
    msgTxtV.textAlignment = NSTextAlignmentCenter;
    msgTxtV.textColor = TS_COLOR_FONT_SUBTITLE_RGB102;
    msgTxtV.font = [UIFont systemFontOfSize:16.0];
    msgTxtV.text = @"您还没有绑定签到卡，\n请输入卡面上的卡号进行绑定";
    msgTxtV.userInteractionEnabled = NO;
    [headerView addSubview:msgTxtV];
    [msgTxtV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(headerView).with.offset(0);
        make.top.equalTo(headerView).with.offset(topHeight-9.0);
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width, 44.0));
        
    }];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;//禁止滑动
    tableView.backgroundColor = TS_COLOR_BACKGROUND_GREY_RGB;
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(0);
        if (iPhone4) {
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width, 44.0+topHeight+topHeight+44.0-9.0+topHeight));
        }else{
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width, 44.0+topHeight+topHeight+44.0-9.0+topHeight - 20.0));
        }
       
        tableView.tableHeaderView = headerView;
        
    }];
    
    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    // 设置title自适应对齐
    submitBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal] ;
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"btn_common__1_p.png"] forState:UIControlStateHighlighted] ;
    
    // 添加 action
    [submitBtn addTarget:self action:@selector(submitAction:) forControlEvents: UIControlEventTouchUpInside];
    
    //设置title
    [submitBtn setTitle:@"绑定" forState:UIControlStateNormal];
    [submitBtn setTitle:@"绑定" forState:UIControlStateHighlighted];
    
    [self.view addSubview:submitBtn];
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).with.offset(10.0);
        make.top.equalTo(tableView.mas_bottom).with.offset(0);
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width-20.0, 42.0));
        
    }];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MyTabBarController setTabBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)selectLeftAction:(id)sender{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        [self disablesAutomaticKeyboardDismissal];//iOS9还要加上此方法
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

// 点击绑定
-(void)submitAction:(id)sender{
    
    [_textField_name resignFirstResponder];
    
    if ([_textField_name.text isEqualToString:@""]) {
        
         [Utilities showTextHud:@"请输入签到卡ID" descView:self.view];
        
    }else if ([_textField_name.text length]!=10){
        
        [Utilities showTextHud:@"请输入正确的10位卡号" descView:self.view];
        
    }else{
        
        // 调用绑定接口
        TSPopupItemHandler handlerTest = ^(NSInteger index, NSString *btnTitle) {
            
            [self sendToServer];
            
        };
        
        NSArray *itemsArr = @[TSItemMake(@"绑定", TSItemTypeNormal, handlerTest)];
        [Utilities showPopupView:[NSString stringWithFormat:@"确认您的账号与ID号为%@的签到卡绑定？",_textField_name.text] items:itemsArr];

        
    }
    
    
}

// 绑定接口
-(void)sendToServer{
    
    /**
     * 卡片绑定
     * @author luke
     * @date 2016.09.13
     * @args
     * v=3 ac=Checkin op=bindCard2Number sid= cid= uid=  card=卡片ID grade=[0学生,7教师] number=[学生ID, 教师为0]
     */
    
    /**
     * 绑定学生打卡纪录
     * @author luke
     * @date 2016.09.13
     * @args
     * v=3 ac=Checkin op=bindCard2Number sid= cid= uid=  card=卡片ID grade=[0学生,7教师] number=[学生ID, 教师为0]
     */


    submitBtn.userInteractionEnabled = NO;
    NSDictionary *userInfo = [GlobalSingletonUserInfo.sharedGlobalSingleton getUserDetailInfo];
    NSString *userType = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"role_id"]];
    
    NSString *number = @"0";
    NSString *cid = @"0";
    
    if (_isStudent == 1) {
        number = [NSString stringWithFormat:@"%@", [userInfo objectForKey:@"student_number_id"]];
    }
    
    if (_cid) {
    
        cid = _cid;
    }
    
    // done:调用绑定接口，绑定成功去日历页，绑定失败弹出强提示 经纬确认
    [Utilities showProcessingHud:self.view];
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Checkin",@"ac",
                          @"3",@"v",
                          @"bindCard2Number", @"op",
                          cid,@"cid",
                          _textField_name.text,@"card",
                          userType,@"grade",
                          number,@"number",
                          nil];
    
    //NSLog(@"data:%@",data);
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        //NSLog(@"respDic:%@",respDic);
        
        if ([result integerValue] == 1) {
            
            [Utilities showSuccessedHud:[respDic objectForKey:@"message"] descView:self.view];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getMomentsNotify" object:self userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeBindStatus" object:self userInfo:nil];
            [self performSelector:@selector(gotoMyAttendace) withObject:nil afterDelay:0.5];
            
        }else{
            
            //[Utilities showFailedHud:[respDic objectForKey:@"message"] descView:self.view];
            submitBtn.userInteractionEnabled = YES;
            [Utilities showAlert:@"提示" message:[respDic objectForKey:@"message"] cancelButtonTitle:@"确定" otherButtonTitle:nil];
          
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        submitBtn.userInteractionEnabled = YES;
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        
    }];
    
}

// 去日历页
-(void)gotoMyAttendace{
    
    MyCheckinHome *mch = [[MyCheckinHome alloc] init];
    mch.fromName = @"firstBind";
    mch.card = _textField_name.text;
    mch.titleName = @"签到";
    mch.isStudent = _isStudent;
    mch.showRightItem = YES;
    [self.navigationController pushViewController:mch animated:YES];
    
    submitBtn.userInteractionEnabled = YES;
}

- (BOOL)disablesAutomaticKeyboardDismissal{
    
    //当以下这些语句都不好用时用此方法使键盘消失 iOS9
    [self.view endEditing:YES];
    [_textField_name resignFirstResponder];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.0;
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
    
    if (![cell.contentView viewWithTag:120]){
        [cell.contentView addSubview: _textField_name];
    }
    
    return cell;

}

// 卡号限制10位
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
        if (range.location >= 10) {
            return NO;
        }
    
        return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
        [self hideKeyBoard];
        [self submitAction:nil];
    
    return YES;
}

@end
