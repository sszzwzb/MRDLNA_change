//
//  SettingDutiesViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/6/9.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "SettingDutiesViewController.h"

@interface SettingDutiesViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation SettingDutiesViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeTitle:@"本校职务"];
    [self setCustomizeLeftButton];
    
    
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
        [self.view addSubview:noNetworkV];
        return;
    }
    
    _tableView.tableFooterView = [[UIView alloc] init];
    [self getData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 保存职务
-(void)selectRightAction:(id)sender{
    
    /**
     * 设置个人学校职务
     * @author luke
     * @date 2015.06.08
     * @args
     *  op=setTitle, sid=, uid=, title=职务ID
     */
    
    if (_titleID == nil) {
        
        [Utilities showAlert:@"提示" message:@"您还没有选择本校职务" cancelButtonTitle:@"确定" otherButtonTitle:nil];
        
    }else{
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"Profile",@"ac",
                              @"2",@"v",
                              @"setTitle", @"op",
                              _titleID, @"title",
                              nil];
        
        [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
            
            NSDictionary *respDic = (NSDictionary*)responseObject;
            NSString *result = [respDic objectForKey:@"result"];
            
            if ([result integerValue] == 1) {
                
                GlobalSingletonUserInfo* g_userSettingInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
                NSMutableDictionary *settingPersonalInfo = [g_userSettingInfo getUserSettingPersonalInfo];
                NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
                
                [settingPersonalInfo setObject:_dutyName forKey:@"duty"];
                [userDetail setObject:_dutyName forKey:@"duty"];
                
                // 更新单例中得数据
                [g_userSettingInfo setUserPersonalInfo:settingPersonalInfo];
                [g_userInfo setUserDetailInfo:userDetail];
                
                [self.navigationController popViewControllerAnimated:YES];
                [ReportObject event:ID_SET_PERSON_INFO];//2015.06.25
                
            }else{
                
                [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试 " cancelButtonTitle:@"确定" otherButtonTitle:nil];
            }
            
            
        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
            
        }];

    }
    
    
}

-(void)reload{
    
    [_tableView reloadData];
}

-(void)getData{
    
    /**
     * 学校职务选项
     * @author luke
     * @date 2015.06.08
     * @args
     *  op=getTitles, sid=, uid=
     */
     [Utilities showProcessingHud:self.view];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Profile",@"ac",
                          @"2",@"v",
                          @"getTitles", @"op",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        NSLog(@"respDic:%@",respDic);
        
        [Utilities dismissProcessingHud:self.view];
        
        if ([result integerValue] == 1) {
            
            [super setCustomizeRightButtonWithName:@"保存"];
            
            listArray = [[NSMutableArray alloc]initWithArray:[respDic objectForKey:@"message"]];
            
            for (int i =0; i< [listArray count]; i++) {
                
                NSString *selected = [[listArray objectAtIndex:i] objectForKey:@"selected"];
                NSString *tagId= [[listArray objectAtIndex:i] objectForKey:@"id"];
                NSString *dutyName = [[listArray objectAtIndex:i] objectForKey:@"title"];
                
                if ([selected integerValue] == 1) {
                    
                    _titleID = tagId;
                    _dutyName = dutyName;
                    
                }
                
            }
            
            [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
        }else{
            [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试 " cancelButtonTitle:@"确定" otherButtonTitle:nil];

        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        
    }];

    
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [listArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    NSString *title = [[listArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    NSString *select = [[listArray objectAtIndex:indexPath.row] objectForKey:@"selected"];
    cell.textLabel.text = title;
    if ([select integerValue] == 1) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSArray *array = [tableView visibleCells];
    for (UITableViewCell *cell in array) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    [[tableView cellForRowAtIndexPath:indexPath]setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    _titleID = [[listArray objectAtIndex:indexPath.row] objectForKey:@"id"];
    _dutyName = [[listArray objectAtIndex:indexPath.row] objectForKey:@"title"];

}
    
    

@end
