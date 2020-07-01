//
//  StudentGrowthSpaceViewController.m
//  MicroSchool
//
//  Created by CheungStephen on 15/12/15.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "StudentGrowthSpaceViewController.h"
#import "FootmarkListViewController.h"

@interface StudentGrowthSpaceViewController ()

@end

@implementation StudentGrowthSpaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setCustomizeLeftButton];
    [super setCustomizeTitle:[NSString stringWithFormat:@"%@的成长空间", _name]];
    
    if (![Utilities isConnected]) {//2015.12.07
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
        [self.view addSubview:noNetworkV];
        return;
    }
    
    _dataArr =[[NSMutableArray alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStyleGrouped];
    
    _tableView.backgroundColor = [[UIColor alloc] initWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:1.0];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    // 隐藏tableview分割线
    //    [self->_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view addSubview:_tableView];
    
    NSDictionary *cjgl = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"xxcj.png", @"icon",
                          @"成绩管理", @"name",
                          nil];
    
    NSDictionary *typc = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"typc.png", @"icon",
                          @"身体健康", @"name",
                          nil];

    NSDictionary *stjl = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"stjk.png", @"icon",
                          @"身体记录", @"name",
                          nil];
    
    NSDictionary *czzj = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"czzj.png", @"icon",
                          @"成长足迹", @"name",
                          nil];

    NSArray *section1 = [NSArray arrayWithObjects:cjgl, nil];
    NSArray *section2 = [NSArray arrayWithObjects:typc, nil];
    NSArray *section3 = [NSArray arrayWithObjects:stjl, nil];
    NSArray *section4 = [NSArray arrayWithObjects:czzj, nil];
    
    //_dataArr = [NSMutableArray arrayWithObjects:section1, section2, section3, section4, nil];
    _dataArr = [NSMutableArray arrayWithObjects:section2,section4, nil];
    
    [_tableView reloadData];
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


#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArr count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (0 == section) {
        return 15;
    }else {
        return 5;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
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
    
    cell.textLabel.text = [[[_dataArr objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]] objectForKey:@"name"];
    cell.imageView.image = [UIImage imageNamed:[[[_dataArr objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]] objectForKey:@"icon"]];
    
    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
        
    NSString *name = [[[_dataArr objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]] objectForKey:@"name"];

    if ([@"成绩管理"  isEqual: name]) {
        TotalSubjectsViewController *vc = [[TotalSubjectsViewController alloc] init];
        vc.cId = _cid;
        vc.number = _number;
        vc.viewType = @"studentGrowthSpace";
        vc.name = _name;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([@"体育评测"  isEqual: name]) {
        HealthHistoryViewController *vc = [[HealthHistoryViewController alloc] init];
        vc.cid = _cid;
        vc.number = _number;
        vc.viewType = @"studentScores";
        //vc.titleName = [NSString stringWithFormat:@"%@的评测记录", _name];
        vc.titleName = @"体育评测";
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([@"身体健康"  isEqual: name]) {
        HealthHistoryViewController *vc = [[HealthHistoryViewController alloc] init];
        vc.cid = _cid;
        vc.number = _number;
        vc.viewType = @"studentConditions";
        //vc.titleName = [NSString stringWithFormat:@"%@的身体记录", _name];
        vc.titleName = @"身体健康";
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([@"成长足迹" isEqual:name]){
        FootmarkListViewController *flvc = [[FootmarkListViewController alloc] init];
        flvc.cid = _cid;
        flvc.number = _number;
        flvc.titleName = name;
        flvc.fromName = @"teacher";
        [self.navigationController pushViewController:flvc animated:YES];
        
    }
}

@end
