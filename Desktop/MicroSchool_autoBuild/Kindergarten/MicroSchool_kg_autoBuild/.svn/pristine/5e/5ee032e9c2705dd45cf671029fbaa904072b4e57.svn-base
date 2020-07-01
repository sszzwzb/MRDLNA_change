//
//  SchoolYearViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-19.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "SchoolYearViewController.h"

@interface SchoolYearViewController ()

@end

@implementation SchoolYearViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        network = [NetworkUtility alloc];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [super setCustomizeTitle:@"入学年份"];
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
    UIView *view = [ [ UIView alloc] initWithFrame:[ UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    
    schoolYearArray = nil;
    _tableViewIns = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [ UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStylePlain];
    
    _tableViewIns.delegate = self;
    _tableViewIns.dataSource = self;
    [self.view addSubview:_tableViewIns];
    
    [self doGetSchoolYear];
}

-(void) doGetSchoolYear
{
    [Utilities showProcessingHud:self.view];

    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:AC_CLASS, @"url",
                          @"yeargrade", @"view",
                          nil];

    network.delegate = self;
    [network sendHttpReq:HttpReq_GetYeargrade andData:data];
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
        schoolYearArray = [resultJSON objectForKey:@"message"];
        
        //刷新表格内容
        [_tableViewIns reloadData];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"注册失败，请重试"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
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

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [schoolYearArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:@"CellTableIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    
    GlobalSingletonUserInfo* g_userPersonalInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
    NSMutableDictionary *personalInfo = [g_userPersonalInfo getUserPersonalInfo];
    
    NSString *personalInfo_yeargrade = [personalInfo objectForKey:@"schoolYear"];

    NSUInteger row = [indexPath row];

    NSDictionary* list_dic = [schoolYearArray objectAtIndex:row];
    NSString* yeargrade= [[list_dic objectForKey:@"yeargrade"] stringByAppendingString:@" 年"];
    
    if([@""  isEqual: personalInfo_yeargrade])
    {
        if(0 == row)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else if([yeargrade isEqual: personalInfo_yeargrade])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    cell.textLabel.text = yeargrade;
//    cell.textLabel.text = [schoolYearArray objectAtIndex:row];
    
    //设置textLabel的背景色为空
    cell.textLabel.backgroundColor = [UIColor clearColor];

    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    NSArray *array = [tableView visibleCells];
    for (UITableViewCell *cell in array) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    [[tableView cellForRowAtIndexPath:indexPath]setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    GlobalSingletonUserInfo* g_userPersonalInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
    NSMutableDictionary *personalInfo = [g_userPersonalInfo getUserPersonalInfo];
    
    NSString *schoolYear = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;

    [personalInfo setObject:schoolYear forKey:@"schoolYear"];
    [personalInfo setObject:@"" forKey:@"class"];
    [personalInfo setObject:@"" forKey:@"cid"];

    [g_userPersonalInfo setUserPersonalInfo:personalInfo];
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定行的高度
    return 50;
}

@end
