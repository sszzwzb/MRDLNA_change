//
//  SignStatisticsViewController.m
//  MicroSchool
//
//  Created by banana on 16/9/13.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "SignStatisticsViewController.h"
#import "SignStatisticsViewControTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MyCheckinHome.h"
@interface SignStatisticsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) TSTableView *signStatisticsTb;
@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation SignStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.listArray = [NSMutableArray array];
    [self setCustomizeTitle:@"签到"];
    [self setCustomizeLeftButton];
    [self getData];
}

- (void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)buildTableView{
    self.signStatisticsTb = [[TSTableView alloc] init];
    _signStatisticsTb.frame = CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height - 44);
    _signStatisticsTb.backgroundColor = [UIColor whiteColor];
    _signStatisticsTb.delegate = self;
    _signStatisticsTb.dataSource = self;
    [self.view addSubview:_signStatisticsTb];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];


}
// 获取数据从服务器
-(void)getData{//2015.09.16

    NSDictionary *message_info;
    message_info = [g_userInfo getUserDetailInfo];
    
    // 数据部分
    if (nil == message_info) {
        message_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDetailInfo"];
    }
    NSString *role_cid = [message_info objectForKey:@"role_cid"];
    NSString *uid = [message_info objectForKey:@"uid"];
    [Utilities showProcessingHud:self.view];
    NSDictionary *data;
    if (_isFromClass) {
        if ([[message_info objectForKey:@"role_id"] integerValue] != 6 && [[message_info objectForKey:@"role_id"] integerValue] != 0) {
            role_cid = _cid;
        }
        data = [[NSDictionary alloc] initWithObjectsAndKeys:
                REQ_URL, @"url",
                @"Checkin",@"ac",
                @"3",@"v",
                @"students", @"op",
                role_cid, @"cid",
                uid, @"uid",
                nil];
    }else{
    data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Checkin",@"ac",
                          @"3",@"v",
                          @"teachers", @"op",
                          role_cid, @"cid",
                          uid, @"uid",
                          nil];
    }
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            _listArray = [respDic objectForKey:@"message"];
            if (_listArray.count > 0) {
                
                [self buildTableView];
            }else{
                [Utilities showNodataView:@"空空如也" msg2:@"去其他地方看看吧" andRect:[Utilities getScreenRectWithoutBar] descView:self.view imgName:nil startY:0];
            }
        }else{
            
            [Utilities showTextHud:TEXT_NONETWORK descView:self.view];
            
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
    
}



#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"leaveHomeCell";
    SignStatisticsViewControTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[SignStatisticsViewControTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }else{
    }
    
    

    if (_isFromClass) {
        cell.nameLabel.text = [_listArray[indexPath.row] objectForKey:@"name"];
        cell.lateLabel.text = @"本月已签到";
        if ([[_listArray[indexPath.row] objectForKey:@"card"] integerValue] == 0) {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.leaveLabel.text = @"暂未绑定签到卡";
            cell.lateLabel.hidden = YES;
            cell.tLabel.hidden = YES;
            cell.numLabel.hidden = YES;
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if ([[[_listArray[indexPath.row] objectForKey:@"count"] stringValue] isEqual:@"0"]) {
            cell.numLabel.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
        }else{
            cell.numLabel.textColor = [UIColor colorWithRed:56.0 / 255 green:183.0 / 255 blue:169.0 / 255 alpha:1];
        }
        cell.numLabel.text = [[_listArray[indexPath.row] objectForKey:@"count"] stringValue];
        
        if ([(NSDictionary *)[_listArray[indexPath.row] objectForKey:@"first"] count] > 0 && [(NSDictionary *)[_listArray[indexPath.row] objectForKey:@"last"] count] > 0) {
            
            cell.leaveLabel.text = [NSString stringWithFormat:@"%@入园  %@离园", [self datalineToString:[[_listArray[indexPath.row] objectForKey:@"first"]objectForKey:@"dateline"] ], [self datalineToString: [[_listArray[indexPath.row] objectForKey:@"last"]objectForKey:@"dateline"]]];
        }else if([(NSDictionary *)[_listArray[indexPath.row] objectForKey:@"first"] count] > 0 && [(NSDictionary *)[_listArray[indexPath.row] objectForKey:@"last"] count] <= 0){
            cell.leaveLabel.text = [NSString stringWithFormat:@"%@入园  未离园", [self datalineToString:[[_listArray[indexPath.row] objectForKey:@"first"]objectForKey:@"dateline"] ]];
        }else if ([(NSDictionary *)[_listArray[indexPath.row] objectForKey:@"first"] count] <= 0 && [(NSDictionary *)[_listArray[indexPath.row] objectForKey:@"last"] count] > 0){
            cell.leaveLabel.text = [NSString stringWithFormat:@"未入园  %@离园", [self datalineToString: [[_listArray[indexPath.row] objectForKey:@"last"]objectForKey:@"dateline"]]];
        } else if([(NSDictionary *)[_listArray[indexPath.row] objectForKey:@"first"] count] == 0 && [(NSDictionary *)[_listArray[indexPath.row] objectForKey:@"last"] count] == 0){
            cell.leaveLabel.text = @"未入园  未离园";
        }
        }

    }else{
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.nameLabel.text = [_listArray[indexPath.row] objectForKey:@"name"];
    if ([[[_listArray[indexPath.row] objectForKey:@"count"] stringValue] isEqual:@"0"]) {
        cell.numLabel.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
    }else{
        cell.numLabel.textColor = [UIColor colorWithRed:227.0 / 255 green:110.0 / 255 blue:15.0 / 255 alpha:1];
    }
     cell.numLabel.text = [[_listArray[indexPath.row] objectForKey:@"count"] stringValue];

    if ([(NSDictionary *)[_listArray[indexPath.row] objectForKey:@"first"] count] > 0 && [(NSDictionary *)[_listArray[indexPath.row] objectForKey:@"last"] count] > 0) {
        
        cell.leaveLabel.text = [NSString stringWithFormat:@"%@入园  %@离园", [self datalineToString:[[_listArray[indexPath.row] objectForKey:@"first"]objectForKey:@"dateline"] ], [self datalineToString: [[_listArray[indexPath.row] objectForKey:@"last"]objectForKey:@"dateline"]]];
    }else if([(NSDictionary *)[_listArray[indexPath.row] objectForKey:@"first"] count] > 0 && [(NSDictionary *)[_listArray[indexPath.row] objectForKey:@"last"] count] <= 0){
    cell.leaveLabel.text = [NSString stringWithFormat:@"%@入园  未离园", [self datalineToString:[[_listArray[indexPath.row] objectForKey:@"first"]objectForKey:@"dateline"] ]];
    }else if ([(NSDictionary *)[_listArray[indexPath.row] objectForKey:@"first"] count] <= 0 && [(NSDictionary *)[_listArray[indexPath.row] objectForKey:@"last"] count] > 0){
    cell.leaveLabel.text = [NSString stringWithFormat:@"未入园  %@离园", [self datalineToString: [[_listArray[indexPath.row] objectForKey:@"last"]objectForKey:@"dateline"]]];
    } else if([(NSDictionary *)[_listArray[indexPath.row] objectForKey:@"first"] count] == 0 && [(NSDictionary *)[_listArray[indexPath.row] objectForKey:@"last"] count] == 0){
        cell.leaveLabel.text = @"未入园  未离园";
    }
    }
    return cell;
    
}
- (NSString *)datalineToString:(NSString *)str
{
    NSTimeInterval time=[str doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_listArray[indexPath.row] objectForKey:@"card"] integerValue] == 0 && _isFromClass) {
        }else{
               [_signStatisticsTb deselectRowAtIndexPath:indexPath animated:YES];
               MyCheckinHome *smvc = [[MyCheckinHome alloc] init];
               smvc.titleName = [NSString stringWithFormat:@"%@签到", [_listArray[indexPath.row] objectForKey:@"name"]];
               if (_isFromClass) {
                   smvc.isStudent = YES;
                   smvc.teacherUid = [_listArray[indexPath.row] objectForKey:@"number"];
               }else{
                   smvc.teacherUid = [_listArray[indexPath.row] objectForKey:@"uid"];
               }
               NSLog(@"%@", [_listArray[indexPath.row] objectForKey:@"number"]);
               
               [self.navigationController pushViewController:smvc animated:YES];

    }
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

@end
