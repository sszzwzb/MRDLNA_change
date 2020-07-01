//
//  EduModuleListViewController.m
//  MicroSchool
//
//  Created by jojo on 14-8-28.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "EduModuleListViewController.h"

@interface EduModuleListViewController ()

@end

@implementation EduModuleListViewController

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
    
    [super setCustomizeTitle:@"责任督学"];
    [super setCustomizeLeftButton];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

-(void)selectLeftAction:(id)sender
{
    // 退回到上个画面
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //这个方法用来告诉表格有几个分组
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //这个方法告诉表格第section个分组有多少行
    return [_eduInsModuleList count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定行的高度
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        //cell.backgroundColor =   [UIColor clearColor];
    }

    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    cell.textLabel.text = [[_eduInsModuleList objectAtIndex:[indexPath row]] objectForKey:@"title"];

    return cell;
}

//选中Cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选中后的反显颜色即刻消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EduModuleDetailViewController *detailViewCtrl = [[EduModuleDetailViewController alloc] init];
    detailViewCtrl.detailInfo = [[_eduInsModuleList objectAtIndex:[indexPath row]] objectForKey:@"message"];
    detailViewCtrl.titlea = [[_eduInsModuleList objectAtIndex:[indexPath row]] objectForKey:@"title"];
    [self.navigationController pushViewController:detailViewCtrl animated:YES];
}

@end
