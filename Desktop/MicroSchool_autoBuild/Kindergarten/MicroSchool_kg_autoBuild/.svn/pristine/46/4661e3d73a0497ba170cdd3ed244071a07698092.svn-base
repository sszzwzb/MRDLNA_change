//
//  SettingHomeCityViewController.m
//  MicroSchool
//
//  Created by jojo on 13-12-31.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "SettingHomeCityViewController.h"

@interface SettingHomeCityViewController ()

@end

@implementation SettingHomeCityViewController

@synthesize cities;

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
    [super setCustomizeTitle:@"家乡"];
//    [super setCustomizeLeftButton];
    [self.navigationItem setHidesBackButton:YES];
    [super setCustomizeRightButtonWithName:@"保存"];
    
    network = [NetworkUtility alloc];
    network.delegate = self;
    
    _cities = self.cities;
    
    
     // 更新省名称到单例
     GlobalSingletonUserInfo* g_userSettingInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
     NSMutableDictionary *settingPersonalInfo = [g_userSettingInfo getUserSettingPersonalInfo];
     cityStr = [settingPersonalInfo objectForKey:@"birthcity"];
 
    if ([_birthProvince isEqualToString:[settingPersonalInfo objectForKey:@"birthprovince"]]) {
        
        for (int i = 0; i<[_cities count]; i++) {
            if ([cityStr isEqualToString:[_cities objectAtIndex:i]]) {
                currentRow = i;
            }
        }
    }else{
        
        currentRow = -1;
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super hideLeftAndRightLine];
    [super setCustomizeLeftButton];

}

-(void)selectLeftAction:(id)sender
{
    [network cancelCurrentRequest];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectRightAction:(id)sender{
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    /*NSMutableDictionary *settingPersonalInfo = [g_userInfo getUserSettingPersonalInfo];
     
     [settingPersonalInfo setObject:text_title.text forKey:@"name"];
     
     [g_userInfo setUserSettingPersonalInfo:settingPersonalInfo];
     
     [self.navigationController popViewControllerAnimated:YES];*/
    
    NSLog(@"cityStr:%@",cityStr);
    NSLog(@"_birthProvince:%@",_birthProvince);
    
    [Utilities showProcessingHud:self.view];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Profile", @"ac",
                          @"2", @"v",
                          @"update", @"op",
                          cityStr,@"birthcity",
                          _birthProvince,@"birthprovince",
                          nil];
    
    [network sendHttpReq:HttpReq_ProfileUpdate andData:data];

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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStyleGrouped];
    
    UIImageView *imgView_table_bg =[[UIImageView alloc]initWithFrame:CGRectMake(0,130,WIDTH,[UIScreen mainScreen].applicationFrame.size.height - 44)];
    [imgView_table_bg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    
    _tableView.backgroundView = imgView_table_bg;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    return [_cities count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定行的高度
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    
    NSUInteger row = [indexPath row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    cell.textLabel.text = [_cities objectAtIndex:row];
    
    //设置textLabel的背景色为空
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row == currentRow) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
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
    
    currentRow = [indexPath row];
    
    cityStr = [_cities objectAtIndex:currentRow];

    // 更新城市名称到单例
//    GlobalSingletonUserInfo* g_userSettingInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
//    NSMutableDictionary *settingPersonalInfo = [g_userSettingInfo getUserSettingPersonalInfo];
//    
//    [settingPersonalInfo setObject:cityStr forKey:@"birthcity"];
//    
//    [g_userSettingInfo setUserPersonalInfo:settingPersonalInfo];

    // 跳转到上上级页面，setPersonalInfoViewController
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3]
//                                          animated:YES];

    // 另一种方式
//    for (UIViewController *temp inself.navigationController.viewControllers) {
//        if ([temp isKindOfClass:[你要跳转到的Controller class]]) {
//            [self.navigationControllerpopToViewController:temp animated:YES];
//        }
//    }
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
  
    
    if(true == [result intValue])
    {
        GlobalSingletonUserInfo* g_userSettingInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
        NSMutableDictionary *settingPersonalInfo = [g_userSettingInfo getUserSettingPersonalInfo];
        NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
        
        // 更新城市名称到单例
        [settingPersonalInfo setObject:_birthProvince forKey:@"birthprovince"];
        [userDetail setObject:_birthProvince forKey:@"birthprovince"];
        
        [settingPersonalInfo setObject:cityStr forKey:@"birthcity"];
        [userDetail setObject:cityStr forKey:@"birthcity"];
        
        // 更新单例中得数据
        [g_userSettingInfo setUserPersonalInfo:settingPersonalInfo];
        [g_userInfo setUserDetailInfo:userDetail];
      
//        if ([_fromName isEqualToString:@"mainMenu"]) {
//            
//            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
//            
//        }else{
//            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
//            
//        }
        
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        
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
