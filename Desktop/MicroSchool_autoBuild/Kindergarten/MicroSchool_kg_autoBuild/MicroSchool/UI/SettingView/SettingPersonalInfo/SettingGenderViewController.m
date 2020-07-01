//
//  SettingGenderViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-31.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "SettingGenderViewController.h"


@interface SettingGenderViewController ()

@end

@implementation SettingGenderViewController

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
    [super setCustomizeTitle:@"性别"];
    [super setCustomizeLeftButton];
    [super setCustomizeRightButtonWithName:@"保存"];
    
    GlobalSingletonUserInfo* g_userSettingInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
    NSMutableDictionary *settingPersonalInfo = [g_userSettingInfo getUserSettingPersonalInfo];
    genderFlag = [settingPersonalInfo objectForKey:@"gender"];
   
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
    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,HEIGHT)];
    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    [self.view addSubview:imgView_bgImg];
    
    _tableViewIns = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStyleGrouped];
    _tableViewIns.delegate = self;
    _tableViewIns.dataSource = self;
    _tableViewIns.backgroundColor = [UIColor clearColor];
    _tableViewIns.backgroundView = nil;
    [_tableViewIns setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    //    UIImageView *imgView = [[UIImageView alloc]initWithFrame:(CGRectMake(0, 0, 320, 50))];
    //    imgView.image = [UIImage imageNamed:@"bg_tableViewCell"];
    //    tableViewIns.backgroundView = imgView;
    
    [self.view addSubview:_tableViewIns];
}

-(void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectRightAction:(id)sender{
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [Utilities showProcessingHud:self.view];

    /*NSMutableDictionary *settingPersonalInfo = [g_userInfo getUserSettingPersonalInfo];
             
             [settingPersonalInfo setObject:text_title.text forKey:@"name"];
             
             [g_userInfo setUserSettingPersonalInfo:settingPersonalInfo];
             
             [self.navigationController popViewControllerAnimated:YES];*/
    //NSLog(@"genderFlag:%@",genderFlag);
    
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Profile", @"ac",
                                  @"2", @"v",
                                  @"update", @"op",
                                  genderFlag,@"sex",
                                  nil];
            
            [network sendHttpReq:HttpReq_ProfileUpdate andData:data];
    
        
    

}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    return 2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定行的高度
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    
    GlobalSingletonUserInfo* g_userSettingInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
    NSMutableDictionary *settingPersonalInfo = [g_userSettingInfo getUserSettingPersonalInfo];
    
    NSString *value = [settingPersonalInfo objectForKey:@"gender"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    if (0 == [indexPath section] && 0 == [indexPath row]) {
        if ([@"1" isEqual:value]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        cell.textLabel.text = @"男";
    }else if (0 == [indexPath section] && 1 == [indexPath row]){
        if ([@"2" isEqual:value]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        cell.textLabel.text = @"女";
    }
   
    //设置textLabel的背景色为空
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}

//选中Cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    NSArray *array = [tableView visibleCells];
    for (UITableViewCell *cell in array) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    [[tableView cellForRowAtIndexPath:indexPath]setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    NSString *gender = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
//    GlobalSingletonUserInfo* g_userSettingInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
//    NSMutableDictionary *settingPersonalInfo = [g_userSettingInfo getUserSettingPersonalInfo];
    
    //NSString *genderStr = @"";
    
    if ([@"男"  isEqual: gender]) {
        //genderStr = @"1";
        genderFlag = @"1";
    }
    else {
       // genderStr = @"0";
        genderFlag = @"2";
    }
    
//    [settingPersonalInfo setObject:genderStr forKey:@"gender"];
//    
//    // 更新单例中得数据
//    [g_userSettingInfo setUserPersonalInfo:settingPersonalInfo];
    
    //[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    [Utilities dismissProcessingHud:self.view];
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    NSError *error;
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    //NSString* message_info = [resultJSON objectForKey:@"message"];
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    if(true == [result intValue])
    {
        GlobalSingletonUserInfo* g_userSettingInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
        NSMutableDictionary *settingPersonalInfo = [g_userSettingInfo getUserSettingPersonalInfo];
        NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
        
        [settingPersonalInfo setObject:genderFlag forKey:@"gender"];
        [userDetail setObject:genderFlag forKey:@"sex"];
        
        // 更新单例中得数据
        [g_userSettingInfo setUserPersonalInfo:settingPersonalInfo];
        [g_userInfo setUserDetailInfo:userDetail];
        
        // 修改成功，gps上报
        //            DataReport *dr = [DataReport sharedGlobalSingletonDataReport];
        //            [dr dataReportGPStype:DataReport_Act_SavePersonalInfo];
        
        [self.navigationController popViewControllerAnimated:YES];
        [ReportObject event:ID_SET_PERSON_INFO];//2015.06.25
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"失败"
                                                       message:@"个人信息设置失败"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
    
}

-(void)reciveHttpDataError:(NSError*)err
{
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                   message:@"网络连接错误，请稍候再试"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    [alert show];
}

@end
