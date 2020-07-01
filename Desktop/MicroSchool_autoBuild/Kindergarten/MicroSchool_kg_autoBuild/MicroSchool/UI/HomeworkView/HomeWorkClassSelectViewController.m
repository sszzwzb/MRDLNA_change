//
//  HomeWorkClassSelectViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-1-4.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "HomeWorkClassSelectViewController.h"

@interface HomeWorkClassSelectViewController ()

@end

@implementation HomeWorkClassSelectViewController

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

-(void)selectLeftAction:(id)sender
{
    // 取消所有的网络请求
    [network cancelCurrentRequest];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [super setCustomizeTitle:@"班级选择"];
    
//    [self performSelector:@selector(doGetClass) withObject:nil afterDelay:0.1];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super hideLeftAndRightLine];
    [super setCustomizeLeftButton];

    // 获取已加入班级
    [self doGetClass];
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
    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height)];
    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    [self.view addSubview:imgView_bgImg];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(
                                                              0,
                                                              0,
                                                              WIDTH,
                                                              [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    
    [self.view addSubview:_tableView];
    
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    return [array_class count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定行的高度
    return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat: @"已经加入的班级\n总计: %d个", [array_class count]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    NSUInteger row = [indexPath row];
    NSDictionary* list_dic = [array_class objectAtIndex:row];
    
    NSString *yeargrade = [list_dic objectForKey:@"yeargrade"];
    NSString *name = [list_dic objectForKey:@"name"];
    
    NSString *clasStr = [NSString stringWithFormat:@"%@级%@班", yeargrade, name];
    
    cell.textLabel.text = clasStr;
    
    //设置textLabel的背景色为空
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    NSUInteger row = [indexPath row];
    NSDictionary* list_dic = [array_class objectAtIndex:row];
    
    NSString *cid = [list_dic objectForKey:@"cid"];
    
    [g_userInfo setUserCid:cid];
    
    HomeworkViewController *homeworkViewCtrl = [[HomeworkViewController alloc] init];
    [self.navigationController pushViewController:homeworkViewCtrl animated:YES];
    homeworkViewCtrl.title = @"作业";
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    
    [Utilities dismissProcessingHud:self.view];
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if (HttpReq_GetClassTeacher == type) {
        if(true == [result intValue])
        {
            array_class = [resultJSON objectForKey:@"message"];
            
            [_tableView reloadData];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"用户名或密码错误，请重新输入"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
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

-(void)doGetClass
{
    [Utilities showProcessingHud:self.view];
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          AC_CLASS, @"url",
                          @"teacher",@"view",
                          nil];
    
    [network sendHttpReq:HttpReq_GetClassTeacher andData:data];
    
}

@end
