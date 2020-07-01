//
//  DiscussHistoryViewController.m
//  MicroSchool
//
//  Created by jojo on 14/12/8.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "DiscussHistoryViewController.h"

@interface DiscussHistoryViewController ()

@end

@implementation DiscussHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    network = [NetworkUtility alloc];
    network.delegate = self;

    [super setCustomizeTitle:@"浏览记录"];
    [super setCustomizeLeftButton];

    [Utilities showProcessingHud:self.view];

    [self doGetHistory];


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

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[ UIScreen mainScreen] .applicationFrame] ;
    self.view = view;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];

}

-(void)selectLeftAction:(id)sender
{
    // 取消所有的网络请求
    [network cancelCurrentRequest];
    
    // 退回到上个画面
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doGetHistory
{
    if (_isFromNewsDetail) {
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"2", @"v",
                              @"News", @"ac",
                              @"history", @"op",
                              _tid,@"nid",
                              @"0",@"page",
                              @"10000", @"size",
                              nil];
        
        [network sendHttpReq:HttpReq_ThreadHistory andData:data];
    }else{
    // 获取浏览痕迹
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"2", @"v",
                          @"ThreadHistory", @"ac",
                          @"viewList", @"op",
                          _tid, @"tid",
                          _cid,@"cid",
                          nil];
    
    [network sendHttpReq:HttpReq_ThreadHistory andData:data];\
    }
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [historyDic count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    NSUInteger row = [indexPath row];
    
    NSDictionary* list_dic = [historyDic objectAtIndex:row];
    
    DiscussHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        cell = [[DiscussHistoryTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;

    cell.label_name.text = [list_dic objectForKey:@"name"];

    Utilities *util = [Utilities alloc];
    cell.label_dateline.text = [util linuxDateToString:[list_dic objectForKey:@"dateline"] andFormat:@"%@-%@ %@:%@" andType:DateFormat_MDHM];

    [cell.imageView_img sd_setImageWithURL:[NSURL URLWithString:[list_dic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];

    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if ([g_uid intValue] == [[[historyDic objectAtIndex:[indexPath row]] objectForKey:@"uid"] intValue]) {
//        [self.view makeToast:@"只可查看他人的个人资料."
//                    duration:0.5
//                    position:@"center"
//                       title:nil];
//    }else {
        FriendProfileViewController *friendProfileViewCtrl = [[FriendProfileViewController alloc] init];
        friendProfileViewCtrl.fuid = [[historyDic objectAtIndex:[indexPath row]] objectForKey:@"uid"];
        [self.navigationController pushViewController:friendProfileViewCtrl animated:YES];
//    }
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    [Utilities dismissProcessingHud:self.view];
    
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    NSString *protocol = [resultJSON objectForKey:@"protocol"];
    
    if ([@"ThreadHistoryAction.viewList" isEqual: protocol]) {
        if(true == [result intValue])
        {
            NSArray *message = [resultJSON objectForKey:@"message"];
            historyDic = message;
            
            [_tableView reloadData];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"获取浏览痕迹错误，请稍候再试"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    } else if([@"EduinspectorAction.profile" isEqual: protocol]) {
        
    }else if([@"NewsAction.history" isEqual: protocol]) {
        NSDictionary *message = [resultJSON objectForKey:@"message"];
        
        historyDic = [message objectForKey:@"list"];
        
        [_tableView reloadData];
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

@end
