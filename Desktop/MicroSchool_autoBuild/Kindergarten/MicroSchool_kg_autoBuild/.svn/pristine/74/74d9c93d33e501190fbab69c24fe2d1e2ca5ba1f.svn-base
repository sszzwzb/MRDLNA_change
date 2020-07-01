//
//  NameViewController.m
//  MicroSchool
//
//  Created by jojo on 13-12-18.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "NameViewController.h"

@interface NameViewController ()

@end

@implementation NameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if ([@"classNum"  isEqual: _viewType]) {
        [super setCustomizeTitle:@"身份证号"];
    }else {
        [super setCustomizeTitle:@"真实姓名"];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super hideLeftAndRightLine];
    [super setCustomizeLeftButton];
    [super setCustomizeRightButtonWithName:@"保存"];
    
    GlobalSingletonUserInfo* g_userPersonalInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
    NSMutableDictionary *personalInfo = [g_userPersonalInfo getUserPersonalInfo];
    
    if ([@"classNum"  isEqual: _viewType]) {
        NSString *name = [personalInfo objectForKey:@"number"];
        text_title.text = name;
    }else {
        NSString *name = [personalInfo objectForKey:@"name"];
        text_title.text = name;
    }
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
    if (iPhone5)
    {
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
            text_title = [[UITextField alloc]initWithFrame:CGRectMake(10, 35, 310, 50)];
        }else{
            text_title = [[UITextField alloc]initWithFrame:CGRectMake(15, 24, 310, 50)];
        }
        
    }
    else
    {
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
            text_title = [[UITextField alloc]initWithFrame:CGRectMake(10, 35, 310, 50)];
        }else{
            text_title = [[UITextField alloc]initWithFrame:CGRectMake(15, 24, 310, 50)];
        }
    }

    text_title.borderStyle = UITextBorderStyleNone;
    text_title.backgroundColor = [UIColor clearColor];
    
    if ([@"classNum"  isEqual: _viewType]) {
        text_title.placeholder = @"请输入身份证号";
    }else {
        text_title.placeholder = @"请输入真实姓名";
    }

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

-(void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectRightAction:(id)sender
{
    if ([@"classNum"  isEqual: _viewType]) {
        if ([@""  isEqual: text_title.text]) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"输入为空，请重新输入。"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }else {
            NSMutableDictionary *personalInfo = [g_userInfo getUserPersonalInfo];
            [personalInfo setObject:text_title.text forKey:@"number"];
            
            [g_userInfo setUserPersonalInfo:personalInfo];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else {
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
            NSMutableDictionary *personalInfo = [g_userInfo getUserPersonalInfo];
            [personalInfo setObject:text_title.text forKey:@"name"];
            
            [g_userInfo setUserPersonalInfo:personalInfo];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([@"classNum"  isEqual: _viewType]){
        
        //这里默认是最多输入50位
        if (range.location >= 50)//"身份证号"
        {
            NSString *input = string;
            if ([input  isEqual: @""]) {
                return YES;
            }
            return NO;
        }
    }else{
        //这里默认是最多输入8位
        if (range.location >= 8)
        {
            NSString *input = string;
            if ([input  isEqual: @""]) {
                return YES;
            }
            return NO;
        }
    }
    
  
    return YES;
}
@end
