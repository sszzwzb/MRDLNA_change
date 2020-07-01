//
//  enterNewProfileViewController.m
//  MicroSchool
//
//  Created by Kate on 14-10-22.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "enterNewProfileViewController.h"
#import "FRNetPoolUtils.h"

@interface enterNewProfileViewController ()

@end

@implementation enterNewProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.fromName isEqualToString:@"name"]) {
        [super setCustomizeTitle:@"真实姓名"];
    }else if ([self.fromName isEqualToString:@"tel"]) {
        [super setCustomizeTitle:@"电话"];
    }else if ([self.fromName isEqualToString:@"job"]) {
        [super setCustomizeTitle:@"职务"];
    }else if([self.fromName isEqualToString:@"company"]){
        [super setCustomizeTitle:@"单位"];
    }else if ([self.fromName isEqualToString:@"email"]){//2015.09.14
        [super setCustomizeTitle:@"邮箱"];
    }
    [super setCustomizeLeftButton];
    [super setCustomizeRightButtonWithName:@"保存"];
    
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
        
    }else if ([self.fromName isEqualToString:@"tel"]) {
        name = @"请输入电话";
        
        
    }else if ([self.fromName isEqualToString:@"job"]) {
        name = @"请输入职务";
        
        
    }else if([self.fromName isEqualToString:@"company"]){
        
        name = @"请输入单位";
        
    }else if ([self.fromName isEqualToString:@"email"]){//2015.09.14
        
        name = @"请输入邮箱";
        
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
    if ([self.fromName isEqualToString:@"tel"]){
        text_title.keyboardType=UIKeyboardTypePhonePad;
    }else{
        text_title.keyboardType=UIKeyboardTypeDefault;
    }
    
    text_title.returnKeyType =UIReturnKeyDone;
    text_title.delegate = self;
    [text_title performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.01];
    
    [_tableView addSubview:text_title];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    NSMutableDictionary *settingPersonalInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"infoForInspector"];
    
    if ([self.fromName isEqualToString:@"tel"]) {
        NSString *str = [settingPersonalInfo objectForKey:@"tel"];
        text_title.text = str;
        
    }else if ([self.fromName isEqualToString:@"job"]) {
        NSString *str = [settingPersonalInfo objectForKey:@"job"];
        text_title.text = str;
        
    }else if([self.fromName isEqualToString:@"company"]){
        
        NSString *str = [settingPersonalInfo objectForKey:@"company"];
        text_title.text = str;
    }else if ([self.fromName isEqualToString:@"email"]){//2015.09.14
        
        NSString *str = [settingPersonalInfo objectForKey:@"email"];
        text_title.text = str;
    }
    
}

-(void)saveToServer:(NSString*)param{
    
    //    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    HUD.labelText = @"保存中...";
    [Utilities showProcessingHud:self.view];// 2015.05.12
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *phone = @"";
        NSString *job = @"";
        NSString *company = @"";
        NSString *duty = @"";
        NSString *photo = @"";
        NSString *email = @"";//2015.09.14
        
        if ([self.fromName isEqualToString:@"tel"]) {
            
            phone = text_title.text;
            
        }else if ([self.fromName isEqualToString:@"job"]) {
            
            job = text_title.text;
            
        }else if([self.fromName isEqualToString:@"company"]){
            
            company = text_title.text;
            
        }else if ([self.fromName isEqualToString:@"email"]){//2015.09.14
            
            email = text_title.text;
        }
        
        // 个人信息保存接口
        NSString *msg = [FRNetPoolUtils updateProfile:phone job:job company:company duty:duty photoPath:photo email:email];//2015.09.14
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //[HUD hide:YES];
            [Utilities dismissProcessingHud:self.view];// 2015.05.12
            if (msg!=nil) {
                
                [Utilities showAlert:@"错误" message:msg cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                NSMutableDictionary *tempDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"infoForInspector"];
                NSMutableDictionary *settingPersonalInfo = [[NSMutableDictionary alloc]initWithDictionary:tempDic copyItems:YES];
                
                if ([self.fromName isEqualToString:@"tel"]) {
                    [settingPersonalInfo setObject:text_title.text forKey:@"tel"];
                    
                }else if ([self.fromName isEqualToString:@"job"]) {
                    [settingPersonalInfo setObject:text_title.text forKey:@"job"];
                    
                }else if([self.fromName isEqualToString:@"company"]){
                    
                    [settingPersonalInfo setObject:text_title.text forKey:@"company"];
                }else if ([self.fromName isEqualToString:@"email"]){//2015.09.14
                    [settingPersonalInfo setObject:text_title.text forKey:@"email"];
                }
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:settingPersonalInfo forKey:@"infoForInspector"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshEduinspectorInfo" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
                
                [ReportObject event:ID_SET_EDU_PERSON];//2015.06.25
                
            }
            
        });
    });
    
}

-(void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectRightAction:(id)sender
{
    [self submit];
    
}

-(void)submit{
    
    if ([@""  isEqual: text_title.text]) {
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"输入为空，请重新输入。"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
        
    }else {
        
        [text_title resignFirstResponder];
        
        if ([self.fromName isEqualToString:@"tel"]) {
            
            [self saveToServer:@"tel"];
            
        }else if ([self.fromName isEqualToString:@"job"]) {
            
            [self saveToServer:@"job"];
            
        }else if([self.fromName isEqualToString:@"company"]){
            
            [self saveToServer:@"company"];
            
        }else if ([self.fromName isEqualToString:@"email"]){//2015.09.14
            
            [self saveToServer:@"email"];
        }
        
    }
}

//2015.09.14
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([self.fromName isEqualToString:@"email"]) {// 30
        if (range.location > 30) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self submit];
    return YES;
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
