//
//  IdNumberViewController.m
//  MicroSchool
//
//  Created by jojo on 14-1-8.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "IdNumberViewController.h"

@interface IdNumberViewController ()

@end

@implementation IdNumberViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // 导航右菜单，提交
//        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [rightButton setBackgroundColor:[UIColor clearColor]];
//        rightButton.frame = CGRectMake(280, 0, 40, 40);
//        [rightButton setImage:[UIImage imageNamed:@"icon_send.png"] forState:UIControlStateNormal];
//        [rightButton setImage:[UIImage imageNamed:@"icon_send.png"] forState:UIControlStateSelected];
//        [rightButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
//        //UINavigationItem *navigatorItem = [TTNavigator navigator].visibleViewController.navigationItem;
//        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//        self.navigationItem.rightBarButtonItem = rightBarButton;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [super setCustomizeTitle:@"身份证号"];
    [super setCustomizeLeftButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super hideLeftAndRightLine];
    [super setCustomizeLeftButton];
    [super setCustomizeRightButton:@"icon_send.png"];

    NSMutableDictionary *personalInfo = [g_userInfo getUserPersonalInfo];
    
    NSString *name = [personalInfo objectForKey:@"idNumber"];
    text_title.text = name;
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
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        text_title = [[UITextField alloc]initWithFrame:CGRectMake(10, 35, 310, 50)];
    }
    else
    {
        text_title = [[UITextField alloc]initWithFrame:CGRectMake(15, 24, 310, 50)];
    }

    text_title.borderStyle = UITextBorderStyleNone;
    text_title.backgroundColor = [UIColor clearColor];
    text_title.placeholder = @"请输入身份证号码";
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
    if (text_title.text.length > 18) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"身份证号码超过18位，请重新输入。"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    } else {
        NSMutableDictionary *personalInfo = [g_userInfo getUserPersonalInfo];
        [personalInfo setObject:text_title.text forKey:@"idNumber"];
        
        [g_userInfo setUserPersonalInfo:personalInfo];
        
        [self.navigationController popViewControllerAnimated:YES];
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
    //这里默认是最多输入18位
    if (range.location >= 18)
    {
        NSString *input = string;
        if ([input  isEqual: @""]) {
            return YES;
        }
        return NO;
    }
    return YES;
}

@end
