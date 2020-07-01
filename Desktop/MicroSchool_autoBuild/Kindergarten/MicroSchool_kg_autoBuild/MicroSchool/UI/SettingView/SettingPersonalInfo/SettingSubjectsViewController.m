//
//  SettingSubjectsViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/6/9.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "SettingSubjectsViewController.h"
#import "MutableSelectTableViewCell.h"

@interface SettingSubjectsViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingSubjectsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeTitle:@"任教学科"];
    [self setCustomizeLeftButton];
    
    
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
        [self.view addSubview:noNetworkV];
        return;
    }
    _tableView.tableFooterView = [[UIView alloc] init];
    tagIdArray = [[NSMutableArray alloc]init];
    tagNameArray = [[NSMutableArray alloc]init];
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

// 设置科目
-(void)selectRightAction:(id)sender{
    
    /**
     * 设置个人学校科目
     * @author luke
     * @date 2015.06.08
     * @args
     *  op=setCourses, sid=, uid=, courses=科目ID,....
     */
    
    if ([tagIdArray count] == 0) {
        
        [Utilities showAlert:@"提示" message:@"您还没有选择任教学科" cancelButtonTitle:@"确定" otherButtonTitle:nil];
        
    }else{
        
        [Utilities showProcessingHud:self.view];
        
        NSString *courses = @"";
        for (int i = 0; i<[tagIdArray count]; i++) {
            
            NSString *item = @"";
            if (i == 0) {
                courses = [tagIdArray objectAtIndex:0];
            }else{
                item = [tagIdArray objectAtIndex:i];
                courses = [NSString stringWithFormat:@"%@,%@",courses,item];

            }
            
        }
        
        NSString *coursesName = @"";
        for (int i = 0; i<[tagNameArray count]; i++) {
            
            NSString *item = @"";
            if (i == 0) {
                coursesName = [tagNameArray objectAtIndex:0];
            }else{
                
                item = [tagNameArray objectAtIndex:i];
                coursesName = [NSString stringWithFormat:@"%@,%@",coursesName,item];
                
            }
            
    
        }
        
       
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"Profile",@"ac",
                              @"2",@"v",
                              @"setCourses", @"op",
                              courses,@"courses",
                              nil];
        
        [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
            
            NSDictionary *respDic = (NSDictionary*)responseObject;
            NSString *result = [respDic objectForKey:@"result"];
            
            NSLog(@"respDic:%@",respDic);
            
            
            [Utilities dismissProcessingHud:self.view];
            if ([result integerValue] == 1) {
                
                GlobalSingletonUserInfo* g_userSettingInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
                NSMutableDictionary *settingPersonalInfo = [g_userSettingInfo getUserSettingPersonalInfo];
                NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
                
                [settingPersonalInfo setObject:coursesName forKey:@"subject"];
                [userDetail setObject:coursesName forKey:@"subject"];
                
                // 更新单例中得数据
                [g_userSettingInfo setUserPersonalInfo:settingPersonalInfo];
                [g_userInfo setUserDetailInfo:userDetail];
                
                [self.navigationController popViewControllerAnimated:YES];
                [ReportObject event:ID_SET_PERSON_INFO];//2015.06.25
                
            }else{
                
                [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试 " cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }
            
            
        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
            
            [Utilities dismissProcessingHud:self.view];
            
        }];

    }
    
    
    
}

-(void)getData{
    
    /**
     * 学校科目选项
     * @author luke
     * @date 2015.06.08
     * @args
     *  op=getCourses, sid=, uid=,
     */
    [Utilities showProcessingHud:self.view];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Profile",@"ac",
                          @"2",@"v",
                          @"getCourses", @"op",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        NSLog(@"respDic:%@",respDic);
        
        /*
         {
         course = English;
         id = 3;
         selected = 0;
         }
         */
         [Utilities dismissProcessingHud:self.view];
        if ([result integerValue] == 1) {
            
            [super setCustomizeRightButtonWithName:@"保存"];
            
            listArray = [[NSMutableArray alloc]initWithArray:[respDic objectForKey:@"message"]];
            checkList = [[NSMutableArray alloc]init];
            
            for (int i =0; i< [listArray count]; i++) {
                
                NSString *selected = [[listArray objectAtIndex:i] objectForKey:@"selected"];
                NSString *course = [[listArray objectAtIndex:i] objectForKey:@"course"];
                NSString *tagId= [[listArray objectAtIndex:i] objectForKey:@"id"];
                
                if ([selected integerValue] == 1) {
                    [tagIdArray addObject:tagId];
                    [tagNameArray addObject:course];
                }
                
                [checkList addObject:selected];
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
    
    static NSString *GroupedTableIdentifier = @"MutableSelectTableViewCell";
    
    MutableSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    if(cell == nil) {
       
        UINib *nib = [UINib nibWithNibName:@"MutableSelectTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:GroupedTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([[checkList objectAtIndex:indexPath.row] integerValue] == 1) {
       
        cell.checkImgV.image = [UIImage imageNamed:@"rb_gander_p_01.png"];
        
    }else{
        cell.checkImgV.image = [UIImage imageNamed:@"rb_gander_d_01.png"];

    }
    
    cell.titleLabel.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"course"];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSString *tagId = [[listArray objectAtIndex:indexPath.row] objectForKey:@"id"];
    NSString *tagName = [[listArray objectAtIndex:indexPath.row] objectForKey:@"course"];
    
    NSString *isCheck = [checkList objectAtIndex:indexPath.row];
    
   
    if ([isCheck integerValue] == 1) {
        
        
        [checkList replaceObjectAtIndex:indexPath.row withObject:@"0"];
        [tagIdArray removeObject:tagId];
        [tagNameArray removeObject:tagName];
        
    }else{
        
        if ([tagIdArray count] < 4) {
            
            [checkList replaceObjectAtIndex:indexPath.row withObject:@"1"];
            [tagIdArray addObject:tagId];
            [tagNameArray addObject:tagName];
        }else{
            
            [Utilities showAlert:@"提示" message:@"您最多只能选择四个学科" cancelButtonTitle:@"确定" otherButtonTitle:nil];
        }
        
    }
    
    [_tableView reloadData];
    
}




@end
