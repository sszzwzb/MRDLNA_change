//
//  SubjectFilterViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/10/9.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "SubjectFilterViewController.h"

@interface SubjectFilterViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SubjectFilterViewController

- (void)viewDidLoad {
    [ReportObject event:ID_OPEN_CHART_SIFT];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@"筛选科目"];
    
    _tableView.hidden = YES;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
        [self.view addSubview:noNetworkV];
        return;
    }
    
    [Utilities showProcessingHud:self.view];
    [self getData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * 查询科目列表
 * @author luke
 * @date 2015.10.10
 * @args
 *  v=2, ac=GrowingSpace, op=courses, sid=, uid=, cid=
 */
-(void)getData{
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"GrowingSpace",@"ac",
                          @"2",@"v",
                          @"courses", @"op",
                          _cId,@"cid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            NSLog(@"筛选科目:%@",respDic);
            
            _tableView.hidden = NO;
            
            NSMutableArray *array = [respDic objectForKey:@"message"];
            
            if ([array count] >0) {
                
                listArray = [[NSMutableArray alloc] initWithArray:array copyItems:YES];
                
            }else{
                
                
            }
            
        }else{
            [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
            
        }
        
        [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        
    }];
}


-(void)reload{
    
    [_tableView reloadData];
}


#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    NSString *title = [[listArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.textLabel.text = title;
    
    NSString *subjectId = [NSString stringWithFormat:@"%@",[[listArray objectAtIndex:indexPath.row] objectForKey:@"id"]];//
    NSString *flag = [[NSUserDefaults standardUserDefaults] objectForKey:@"subjectIdForFilter"];
    
    if ([flag intValue] == 0) {
        if (indexPath.row == 0) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }else{
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }else{
        if ([subjectId isEqualToString:flag]) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }else{
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
    
    return cell;
    
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *subjectId = [NSString stringWithFormat:@"%@",[[listArray objectAtIndex:indexPath.row] objectForKey:@"id"]];//
    NSString *subjectName = [[listArray objectAtIndex:indexPath.row] objectForKey:@"name"];//
    
    [userdefaults setObject:subjectId forKey:@"subjectIdForFilter"];
    [userdefaults setObject:subjectName forKey:@"subjectNameForFilter"];
    
    [userdefaults synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateChartList" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
