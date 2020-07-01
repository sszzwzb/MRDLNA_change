//
//  DepartmentListViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/5/6.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "DepartmentListViewController.h"
#import "FriendCommonViewController.h"

@interface DepartmentListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DepartmentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.hidden = YES;
    
    [self setCustomizeLeftButton];
    
    if ([@"Transpond" isEqualToString:_toViewName]) {//从转发页来
         [self setCustomizeTitle:@"选择下属单位"];
    }else{
        if ([@"department" isEqualToString:_fromName]) {
            [self setCustomizeTitle:@"本单位"];
        }else if([@"subdepart" isEqualToString:_fromName]){
            [self setCustomizeTitle:@"下属单位"];
            [ReportObject event:ID_OPEN_CONTACT_SUBORDINATE_LIST];//2015.06.25
        }
    }
    
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
        [self.view addSubview:noNetworkV];
        return;
    }
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)reload{
    
    [_tableView reloadData];
}

-(void)getData{
    
//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.labelText = @"加载中...";
    [Utilities showProcessingHud:self.view];// 2015.05.12
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *array = nil;
        
        if ([_fromName isEqualToString:@"department"]) {
             array = [FRNetPoolUtils getDepartmentList];
        }else{
             array = [FRNetPoolUtils getSubordinateList];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //[HUD hide:YES];
            [Utilities dismissProcessingHud:self.view];//2015.05.12

            if (array == nil) {
                
                [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                _tableView.hidden = NO;
                
                if([array count] >0){
                    
                    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                    
                    listArray = [[NSMutableArray alloc]initWithArray:array];
                    
                    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                }
                
            }
        });
        
    });
    
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
    
    static NSString *GroupedTableIdentifier = @"reuseIdentifier0";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];

    if ([_fromName isEqualToString:@"department"]) {
        cell.textLabel.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    }else {
        cell.textLabel.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"tagname"];
    }
    
    return cell;
    
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSString *cid = [[listArray objectAtIndex:indexPath.row] objectForKey:@"cid"];
    NSString *tagName = [[listArray objectAtIndex:indexPath.row] objectForKey:@"tagname"];
    //NSString *schoolType = [[NSUserDefaults standardUserDefaults] objectForKey:@"schoolType"];
    
    if ([@"Transpond" isEqualToString:_toViewName]) {
        FriendMultiSelectViewController *friendSelectViewCtrl = [[FriendMultiSelectViewController alloc] init];
        friendSelectViewCtrl.classid = cid;
        friendSelectViewCtrl.friendType = @"friend";
        friendSelectViewCtrl.fromName = self.toViewName;
        if ([@"department" isEqualToString:_fromName]){
            friendSelectViewCtrl.flag = @"本单位";
            friendSelectViewCtrl.gid = [[listArray objectAtIndex:indexPath.row] objectForKey:@"gid"];
//            friendSelectViewCtrl.fromTitle = [[listArray objectAtIndex:indexPath.row] objectForKey:@"name"];

        }else{
            friendSelectViewCtrl.flag = @"下属单位";
        }
      
        friendSelectViewCtrl.entity = _entity;
        [self.navigationController pushViewController:friendSelectViewCtrl animated:YES];
    }else{
        FriendCommonViewController *friendCommonViewCtrl = [[FriendCommonViewController alloc] init];
        if ([@"department" isEqualToString:_fromName]){
            friendCommonViewCtrl.titleName = @"本单位";
            friendCommonViewCtrl.gid = [[listArray objectAtIndex:indexPath.row] objectForKey:@"gid"];
            friendCommonViewCtrl.fromTitle = [[listArray objectAtIndex:indexPath.row] objectForKey:@"name"];

            
        }else{
            friendCommonViewCtrl.titleName = @"下属单位";
            friendCommonViewCtrl.fromTitle = tagName;

        }
        friendCommonViewCtrl.classid = cid;
        [self.navigationController pushViewController:friendCommonViewCtrl animated:YES];
    }
    
}

@end
