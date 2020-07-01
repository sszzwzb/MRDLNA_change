//
//  GraduateViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/9/16.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "GraduateViewController.h"
#import "ClassMainViewController2.h"
#import "ClassDetailViewController.h"
#import "ClassListTableViewCell.h"

@interface GraduateViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GraduateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeTitle:@"毕业班级"];
    [self setCustomizeLeftButton];
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
        [self.view addSubview:noNetworkV];
        return;
    }
    
    [self getDataByType:@"1"];
    
    _tableView.tableFooterView = [[UIView alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * 获取学校的班级列表
 * 1. classtype=0, 包含两种类型的班级：普通班和教研班,也是默认条件
 * 2. classtype=1, 毕业班级
 * @author luke
 * @date 2015.09.14
 * @args
 *  v=2, ac=Class, op=getClasses, sid=, uid=, yeargrade=, classtype=[0:在校，1:毕业]
 */
-(void)getDataByType:(NSString*)type{
    
    [Utilities showProcessingHud:self.view];
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
            REQ_URL, @"url",
            @"Class",@"ac",
            @"2",@"v",
            @"getClasses", @"op",
            @"", @"yeargrade",
            type,@"classtype",
            nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            NSMutableArray *array = [respDic objectForKey:@"message"];
            listArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
            [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
            
            if ([listArray count] > 0) {
                
                [noDataView removeFromSuperview];
               
            }else{
                CGRect rect = _tableView.frame;
                noDataView = [Utilities showNodataView:@"无毕业班级" msg2:@"" andRect:rect];
                [self.tableView addSubview:noDataView];
            }
 
        }else{
            [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
            
        }
        
        
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
    static NSString *CellTableIdentifier = @"ClassListTableViewCell";
    
    ClassListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        
        //        cell = [[ClassListTableViewCell alloc]
        //                initWithStyle:UITableViewCellStyleDefault
        //                reuseIdentifier:CellTableIdentifier];
        
        UINib *nib = [UINib nibWithNibName:@"ClassListTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    NSString* head_url = [[listArray objectAtIndex:indexPath.row] objectForKey:@"pic"];
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"icon_class_avatar_defalt.png"]];
    //NSLog(@"title:%@",[[listArray objectAtIndex:indexPath.row] objectForKey:@"tagname"]);
    cell.titleLabel.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"tagname"];
    //NSLog(@"intro:%@",[[listArray objectAtIndex:indexPath.row] objectForKey:@"intro"]);
    cell.introductionLabel.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"intro"];
    //NSLog(@"joined:%@",[[listArray objectAtIndex:indexPath.row] objectForKey:@"joined"]);
    NSString *joined = [[listArray objectAtIndex:indexPath.row] objectForKey:@"joined"];
    if ([joined intValue] == 1) {
        cell.isAddedLabel.text = @"已加入";
        
    }else{
        cell.isAddedLabel.text = @"";
        
    }
    
    //    cell.headImgView.layer.masksToBounds = YES;
    //    cell.headImgView.layer.cornerRadius = cell.headImgView.frame.size.height/2.0;
    
    return cell;
    
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"99999999999999999 %@", indexPath);
    //    NSLog(@"99999999999999999 %d", indexPath.section);
    //    NSLog(@"99999999999999999 %d", indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    NSString *classTitle = [[listArray objectAtIndex:indexPath.row] objectForKey:@"tagname"];
    NSString *joined = [[listArray objectAtIndex:indexPath.row] objectForKey:@"joined"];
    NSString *cId = [[listArray objectAtIndex:indexPath.row] objectForKey:@"tagid"];
    //    NSString *classType = [[NSUserDefaults standardUserDefaults]objectForKey:@"classType"];
    //    int classTypeint = [classType intValue];
    
    if ([@"signup"  isEqual: _viewType]) {
        // 从注册流程中选择班级
        NSDictionary *dic = [listArray objectAtIndex:indexPath.row];
        
        NSMutableDictionary *personalInfo = [g_userInfo getUserPersonalInfo];
        [personalInfo setObject:[dic objectForKey:@"name"] forKey:@"class"];
        [personalInfo setObject:[dic objectForKey:@"tagid"] forKey:@"cid"];
        
        [g_userInfo setUserPersonalInfo:personalInfo];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Zhixiao_signupClassSelect" object:self userInfo:[listArray objectAtIndex:indexPath.row]];
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]
                                              animated:YES];
        
    }else {

        if ([joined intValue]!=1) {// 未加入
            //classTypeint = 3;
            // 课表作业都没有
            ClassMainViewController2 *myClassViewCtrl = [[ClassMainViewController2 alloc] init];
            myClassViewCtrl.titleName = classTitle;
            myClassViewCtrl.cId = cId;
            myClassViewCtrl.joined = joined;
            [self.navigationController pushViewController:myClassViewCtrl animated:YES];
            
        }else{
            
            ClassDetailViewController *myClassViewCtrl = [[ClassDetailViewController alloc]init];//测试数据
            myClassViewCtrl.titleName = classTitle;
            myClassViewCtrl.cId = cId;
            myClassViewCtrl.fromName = @"ClassList";
            [self.navigationController pushViewController:myClassViewCtrl animated:YES];
            
        }
    }
    
    
}

@end
