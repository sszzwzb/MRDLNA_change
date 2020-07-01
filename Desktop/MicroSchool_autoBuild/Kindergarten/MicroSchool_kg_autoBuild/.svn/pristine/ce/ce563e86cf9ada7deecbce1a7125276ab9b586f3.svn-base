//
//  BirthdayViewController.m
//  MicroSchool
//
//  Created by jojo on 13-12-18.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "BirthdayViewController.h"

@interface BirthdayViewController ()

@end

@implementation BirthdayViewController

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
    [super setCustomizeTitle:@"生日"];
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
    
    // 背景图片
    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,548)];
    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    [self.view addSubview:imgView_bgImg];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    [self.view addSubview:_tableView];
    
    NSMutableDictionary *settingPersonalInfo = [g_userInfo getUserPersonalInfo];
    
    NSString *birthyear = [settingPersonalInfo objectForKey:@"birthyear"];
    NSString *birthmonth = [settingPersonalInfo objectForKey:@"birthmonth"];
    NSString *birthday = [settingPersonalInfo objectForKey:@"birthday"];
    
    NSString *birthStr = [NSString stringWithFormat:@"%@年 %@月 %@日", birthyear, birthmonth, birthday];
    
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
    text_title.text = birthStr;
    text_title.font = [UIFont fontWithName:@"Arial" size:18.0f];
    text_title.textColor = [UIColor blackColor];
    //text_title.clearButtonMode = UITextFieldViewModeNever;
    text_title.textAlignment = NSTextAlignmentLeft;
    text_title.keyboardType=UIKeyboardTypeDefault;
    text_title.returnKeyType =UIReturnKeyDone;
    text_title.delegate = self;
    //    text_title.userInteractionEnabled = NO;
    [text_title becomeFirstResponder];
    
    [_tableView addSubview:text_title];
    
    // 建立 UIDatePicker
    datePicker = [[UIDatePicker alloc]init];
    // 時區的問題請再找其他協助 不是本篇重點
    datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    NSString *birthStr2 = [NSString stringWithFormat:@"%@-%@-%@", birthyear, birthmonth, birthday];
    Utilities *util = [Utilities alloc];
    
    NSDate *_date = [util NSStringToNSDate:birthStr2];
    [datePicker setDate:_date animated:YES];
    
    datePicker.locale = datelocale;
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT+8"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];

    // 以下這行是重點 (螢光筆畫兩行) 將 UITextField 的 inputView 設定成 UIDatePicker
    // 則原本會跳出鍵盤的地方 就改成選日期了
    text_title.inputView = datePicker;
    
    // 建立 UIToolbar
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    // 選取日期完成鈕 並給他一個 selector
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self
                                                                          action:@selector(cancelPicker)];
    // 把按鈕加進 UIToolbar
    toolBar.items = [NSArray arrayWithObject:right];
    // 以下這行也是重點 (螢光筆畫兩行)
    // 原本應該是鍵盤上方附帶內容的區塊 改成一個 UIToolbar 並加上完成鈕
    text_title.inputAccessoryView = toolBar;
}

// 按下完成鈕後的 method
-(void) cancelPicker {
    // endEditing: 是結束編輯狀態的 method
    if ([self.view endEditing:NO]) {
        Utilities *util = [Utilities alloc];
        
        text_title.text = [util nsDateToString:datePicker.date andFormat:@"%@年 %@月 %@日" andType:DateFormat_YMD];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:datePicker.date];
        
        NSInteger day = [components day];
        NSInteger month = [components month];
        NSInteger year = [components year];
        
        NSMutableDictionary *personalInfo = [g_userInfo getUserPersonalInfo];
        [personalInfo setObject:[NSString stringWithFormat: @"%ld", (long)year] forKey:@"birthyear"];
        [personalInfo setObject:[NSString stringWithFormat: @"%ld", (long)month] forKey:@"birthmonth"];
        [personalInfo setObject:[NSString stringWithFormat: @"%ld", (long)day] forKey:@"birthday"];

        [g_userInfo setUserPersonalInfo:personalInfo];

//        GlobalSingletonUserInfo* g_userPersonalInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
//        NSMutableDictionary *settingPersonalInfo = [g_userPersonalInfo getUserSettingPersonalInfo];
        
//        [settingPersonalInfo setObject:[NSString stringWithFormat: @"%ld", (long)year] forKey:@"birthyear"];
//        [settingPersonalInfo setObject:[NSString stringWithFormat: @"%ld", (long)month] forKey:@"birthmonth"];
//        [settingPersonalInfo setObject:[NSString stringWithFormat: @"%ld", (long)day] forKey:@"birthday"];
//
//        [g_userPersonalInfo setUserSettingPersonalInfo:settingPersonalInfo];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

-(void)dateChanged:(id)sender{
    UIDatePicker* control = (UIDatePicker*)sender;
    
    Utilities *util = [Utilities alloc];
    text_title.text = [util nsDateToString:control.date andFormat:@"%@年 %@月 %@日" andType:DateFormat_YMD];

//    NSDate* _date = control.date;
    /*添加你自己响应代码*/
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

@end
