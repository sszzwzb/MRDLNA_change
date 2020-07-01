//
//  SetRelationsViewController.m
//  MicroSchool
//
//  Created by jojo on 15/10/10.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "SetRelationsViewController.h"

@interface SetRelationsViewController ()

@end

@implementation SetRelationsViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super setCustomizeTitle:@"与学生关系"];
    //    [super setCustomizeLeftButton];
    [self.navigationItem setHidesBackButton:YES];
    
    _dataArr = [[NSMutableArray alloc] init];
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
    
    [self doGetRelations];
}
-(UILabel*)nameLable:(NSString*)name{
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    lable.textAlignment =NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:17];
    lable.text =name;
    return lable;
}
- (void)doGetRelations
{
    [Utilities showProcessingHud:self.view];

    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"UserProfile",@"ac",
                          @"2",@"v",
                          @"getParentHoods", @"op",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            NSMutableArray *array = [respDic objectForKey:@"message"];
            _dataArr = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
            
            [_tableView reloadData];
        }else{
            [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
        }
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        
    }];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    return [_dataArr count];
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
    NSDictionary *dic = [_dataArr objectAtIndex:row];
    
//    cell.textLabel.text = [dic objectForKey:@"name"];
    [cell.contentView addSubview:[self nameLable:[dic objectForKey:@"name"]]];
//#3.22
//    cell.textLabel.center = cell.contentView.center;
//    [cell.textLabel setFrame:CGRectMake(0, 0, 300, 40)];
    
    GlobalSingletonUserInfo* g_userPersonalInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
    NSMutableDictionary *personalInfo = [g_userPersonalInfo getUserPersonalInfo];
    
    NSString *value = [personalInfo objectForKey:@"relations"];
    
    if ([[dic objectForKey:@"name"] isEqual:value]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    //设置textLabel的背景色为空
    cell.textLabel.backgroundColor = [UIColor greenColor];

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
    
    NSDictionary *dic = [_dataArr objectAtIndex:[indexPath row]];
    
    NSMutableDictionary *personalInfo = [g_userInfo getUserPersonalInfo];
    [personalInfo setObject:[dic objectForKey:@"name"] forKey:@"relations"];
    [personalInfo setObject:[dic objectForKey:@"id"] forKey:@"relationsId"];

    [g_userInfo setUserPersonalInfo:personalInfo];

    [self.navigationController popViewControllerAnimated:YES];
}

@end
