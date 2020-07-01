//
//  MyClassViewController.m
//  MicroSchool
//
//  Created by jojo on 14-1-3.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "MyClassViewController.h"
#import "ClassMainViewController.h"

@interface MyClassViewController ()

@end

@implementation MyClassViewController

@synthesize toViewName;
@synthesize rowNum;

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
    [super setCustomizeTitle:@"我的班级"];
    [self setCustomizeLeftButtonWithImage:@""];
    
    if ([@"Transpond"  isEqual: self.toViewName]){// 2015.03.26
        
        [super setCustomizeTitle:@"选择班级"];
    }
    
    // 获取已加入班级
//    [self performSelector:@selector(doGetClass) withObject:nil afterDelay:0.1];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super hideLeftAndRightLine];
    [super setCustomizeLeftButton];

    if ([@"FriendCommon"  isEqual: self.toViewName] || [@"Transpond" isEqualToString:self.toViewName]) {//2015.03.25 转发
    } else {
        // 导航右菜单，进入班级选择
        [super setCustomizeRightButton:@"icon_choose.png"];
    }

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

//    // 姓名
    UILabel *label_title = [[UILabel alloc] initWithFrame:CGRectMake(
                                                           15,
                                                           10,
                                                           300,
                                                           20)];
    
    //label_title.text = @"点击屏幕右上角图标，来选择加入班级！";
    label_title.text = @"我已加入的班级，点击班级查看对应的成员。";
    label_title.textColor = [UIColor blackColor];
    label_title.backgroundColor = [UIColor clearColor];
    label_title.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:label_title];
    
    UILabel *label_title2 = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                     15,
                                                                     35,
                                                                     300,
                                                                     20)];
    
    //label_title.text = @"点击屏幕右上角图标，来选择加入班级！";
    label_title2.text = @"从主页的“我的班级”中，可以加入或退出班级。";
    label_title2.textColor = [UIColor grayColor];
    label_title2.backgroundColor = [UIColor clearColor];
    label_title2.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:label_title2];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(
                                                                0,
                                                                65,
                                                                WIDTH,
                                                                [UIScreen mainScreen].applicationFrame.size.height - 44 -65) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    //[_tableView setTableHeaderView:nil];
    _tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);

    [self.view addSubview:_tableView];
}

//#pragma myClassCellDelegate
//
//- (void)operateClassCallback:(NSMutableArray*)cellArray{
//    
//   
//
//}

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
    //return [NSString stringWithFormat: @"已经加入的班级\n总计: %ld个", (unsigned long)[array_class count]];
    //return @"点击右上角图标查看本校所有班级";
    return nil;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 320.0, 0.0)];
//    return  view;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 1.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    MyClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    
    if (cell == nil) {
        cell = [[MyClassTableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    NSUInteger row = [indexPath row];
    NSDictionary* list_dic = [array_class objectAtIndex:row];
    
    //NSString *yeargrade = [list_dic objectForKey:@"yeargrade"];
    NSString *name = [list_dic objectForKey:@"tagname"];
    //NSString *membernum = [list_dic objectForKey:@"membernum"];
    
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"共有%@人",membernum];

    //NSString *clasStr = [NSString stringWithFormat:@"%@级%@班", yeargrade, name];
    
    cell.className = name;
    cell.flag = 2;
    //[cell.imgView_thumb setImage:[UIImage imageNamed:@"icon_delete.png"]];
    
    //设置textLabel的背景色为空
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
//    
//    NSUInteger row = [indexPath row];
//    NSDictionary* list_dic = [array_class objectAtIndex:row];
//    
//    cid = [list_dic objectForKey:@"cid"];
//    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"退出这个班级么？"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:@"取消"
//                              , nil];
//    
//    [alertView show];
//
////    [self doOutClass:cid];
    
    NSLog(@"self.toViewName:%@",self.toViewName);
        
    if ([@"FriendCommon"  isEqual: self.toViewName]) {
        NSUInteger row = [indexPath row];
        NSDictionary* list_dic = [array_class objectAtIndex:row];
        //NSString *cId = [list_dic objectForKey:@"cid"];
        NSString *cId = [list_dic objectForKey:@"tagid"];
        [g_userInfo setUserCid:cId];

        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             cId, @"classid",
                             rowNum, @"row",
                             nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_changeToFriendCommonView" object:self userInfo:dic];

    }else if ([@"Transpond"  isEqual: self.toViewName]){//2015.03.25 转发
     
        NSUInteger row = [indexPath row];
        NSDictionary* list_dic = [array_class objectAtIndex:row];
        //NSString *cId = [list_dic objectForKey:@"cid"];
        NSString *cId = [list_dic objectForKey:@"tagid"];
        
        FriendMultiSelectViewController *friendSelectViewCtrl = [[FriendMultiSelectViewController alloc] init];
        friendSelectViewCtrl.classid = cId;
        friendSelectViewCtrl.friendType = _friendType;
        friendSelectViewCtrl.fromName = self.toViewName;
        friendSelectViewCtrl.entity = _entity;
        [self.navigationController pushViewController:friendSelectViewCtrl animated:YES];
        
    }else {
        
       /*---改版之后这个分支不会走 update by kate 2014.12.03---------------------------------
        NSUInteger row = [indexPath row];
        NSDictionary* list_dic = [array_class objectAtIndex:row];
        NSString *cId = [list_dic objectForKey:@"cid"];
        [g_userInfo setUserCid:cId];
        
        ClassMainViewController *classM = [[ClassMainViewController alloc]init];
        [self.navigationController pushViewController:classM animated:YES];
        */
        
    }
    
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    [Utilities dismissProcessingHud:self.view];
    
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if ([[resultJSON objectForKey:@"protocol"] isEqualToString:@"ClassAction.getMyClass"]) {
        
        if(true == [result intValue])
        {
           
            array_class = [[resultJSON objectForKey:@"message"] objectForKey:@"list"];
            
            //if ([array_class count] > 0) {
                 [_tableView reloadData];
            //}
            
//            NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
//            
//            // 存入到detailInfo中，可以实时的获取当前老师的选择班级数量
//            if (0 == [array_class count]) {
//                [userDetail setObject:@"" forKey:@"class"];
//            } else {
//                NSString *classNum = [NSString stringWithFormat:@"%lud", (unsigned long)[array_class count]];
//                [userDetail setObject:classNum forKey:@"class"];
//            }
//            [g_userInfo setUserDetailInfo:userDetail];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"获取班级失败，请重试"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        NSString *msg = [resultJSON objectForKey:@"message"];
        if(true == [result intValue])
        {
            
            [self doGetClass];
            [_tableView reloadData];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:msg
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self doOutClass];
    }
    else {
        // nothing
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
    
//    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          AC_CLASS, @"url",
//                          @"teacher",@"view",
//                          nil];
    
    NSDictionary *data = [[NSDictionary alloc]initWithObjectsAndKeys:REQ_URL,@"url",@"Class",@"ac",@"2",@"v",@"getMyClass",@"op", nil];
    
    [network sendHttpReq:HttpReq_GetClassTeacher andData:data];
}

-(void)doOutClass
{
    [Utilities showProcessingHud:self.view];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          AC_CLASS, @"url",
                          cid, @"cid",
                          @"out",@"op",
                          nil];
    
    [network sendHttpReq:HttpReq_OutClass andData:data];
}

@end
