//
//  SettingClassViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-1-16.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "SettingClassViewController.h"

@interface SettingClassViewController ()

@end

@implementation SettingClassViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        network = [NetworkUtility alloc];
        network.delegate = self;
        
        cidList =[[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [super setCustomizeTitle:@"班级"];
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
    
    classArray = nil;
    _tableViewIns = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [ UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStylePlain];
    
    _tableViewIns.delegate = self;
    _tableViewIns.dataSource = self;
    [self.view addSubview:_tableViewIns];
    
    [self doGetSchoolYear];
}

-(void) doGetSchoolYear
{
    NSMutableDictionary *personalInfo = [g_userInfo getUserSettingPersonalInfo];
    
    NSString *schoolYear = [personalInfo objectForKey:@"yeargrade"];
    
    if([@""  isEqual: schoolYear])
    {
        schoolYear = @"2013";
    }
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:AC_CLASS, @"url",
                          schoolYear, @"yeargrade",
                          @"list", @"view",
                          nil];
    
    [network sendHttpReq:HttpReq_GetClass andData:data];
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
        classArray = [resultJSON objectForKey:@"message"];
        
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
    return [classArray count];
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
    NSMutableDictionary *personalInfo = [g_userInfo getUserSettingPersonalInfo];
    
    NSString *name_personalInfo = [personalInfo objectForKey:@"class"];
    
    NSUInteger row = [indexPath row];
    
    NSDictionary* list_dic = [classArray objectAtIndex:row];
    NSString* name= [[list_dic objectForKey:@"name"] stringByAppendingString:@" 班"];
    
    [cidList addObject:[list_dic objectForKey:@"cid"]];
    
    
    if([@""  isEqual: name_personalInfo])
    {
        if(0 == row)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else if([name isEqual: name_personalInfo])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    cell.textLabel.text = name;
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
    
    NSMutableDictionary *personalInfo = [g_userInfo getUserSettingPersonalInfo];
    
    NSString *class = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    NSString *cid = [cidList objectAtIndex:indexPath.row];
    
    NSArray *arr = [class componentsSeparatedByString:@" "];

    [personalInfo setObject:[arr objectAtIndex:0] forKey:@"class"];
    [personalInfo setObject:cid forKey:@"cid"];
    
    [g_userInfo setUserSettingPersonalInfo:personalInfo];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定行的高度
    return 50;
}

@end
