//
//  HomeworkStateListViewController.m
//  MicroSchool
//
//  Created by CheungStephen on 2/3/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "HomeworkStateListViewController.h"

@interface HomeworkStateListViewController ()

@end

@implementation HomeworkStateListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setCustomizeLeftButton];
    [super setCustomizeTitle:_titleName];
    
    if (![Utilities isConnected]) {
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
        [self.view addSubview:noNetworkV];
        return;
    }
    
    _dataArr =[[NSMutableArray alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStylePlain];
    
    _tableView.backgroundColor = [[UIColor alloc] initWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:1.0];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:_tableView];
    
    [self doGetStateList];
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

-(void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doGetStateList {
    // notDone      未完成
    // notComment   未批改
    // done         已完成
    NSString *state = @"";
    if ([@"notDone"  isEqual: _viewType]) {
        state = @"3";
    }else if ([@"notComment"  isEqual: _viewType]) {
        state = @"0";
    }else if ([@"done"  isEqual: _viewType]) {
        state = @"2";
    }
    
    /**
     * 作业完成情况学生列表
     * @author luke
     * @date 2016.02.01
     * @args
     *  v=3 ac=HomeworkTeacher op=students sid=5303 cid=6735 uid=6939 tid= state=0:未改,1:未做,2:完成
     */
    
    // 0:未改,3:未做,2:完成

    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"HomeworkTeacher",@"ac",
                          @"3",@"v",
                          @"students", @"op",
                          state, @"state",
                          _cid, @"cid",
                          _tid, @"tid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            [_dataArr addObjectsFromArray:[respDic objectForKey:@"message"]];
            [_tableView reloadData];
        } else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"获取信息错误，请稍候再试"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArr count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    
    NSUInteger row = [indexPath row];
    NSDictionary* list_dic = [_dataArr objectAtIndex:row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:CellTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    if ([@"notDone"  isEqual: _viewType]) {
        // 未完成就不显示右边的箭头
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [list_dic objectForKey:@"name"];
    
    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    if (![@"notDone"  isEqual: _viewType]) {
        // 除了未完成都可以点击
        NSDictionary* list_dic = [_dataArr objectAtIndex:[indexPath row]];
        
        HomeworkStateDetailViewController *vc = [[HomeworkStateDetailViewController alloc] init];
        vc.titleName = [list_dic objectForKey:@"name"];
        vc.number = [list_dic objectForKey:@"number"];
        vc.cid = _cid;
        vc.tid = _tid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
