//
//  ClassFilterViewController.m
//  MicroSchool
//
//  Created by Kate on 14-9-18.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "ClassFilterViewController.h"
#import "FilterTableViewCell.h"
#import "FRNetPoolUtils.h"

@interface ClassFilterViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation ClassFilterViewController

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
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeLeftButton];
    
    
     selectListArray = [[NSMutableArray alloc] init];
    
    if ([_fromName isEqualToString:@"selectUserType"]) {// 成员列表
        
       [self setCustomizeTitle:@"筛选成员"];
        
        NSDictionary *dic0 = [NSDictionary dictionaryWithObjectsAndKeys:@"全部成员",@"name",@"-1",@"userTypeForFilter", nil];
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"老师",@"name",@"7",@"userTypeForFilter", nil];
        NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:@"家长",@"name",@"6",@"userTypeForFilter", nil];
        NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys:@"学生",@"name",@"0",@"userTypeForFilter", nil];
        
        listArray = [[NSMutableArray alloc]initWithObjects:dic0,dic1,dic2,dic3,nil];
        
        for (int i=0; i<[listArray count]; i++) {
            [selectListArray addObject:@"0"];
        }

        
    }else if ([_fromName isEqualToString:@"selectTeacherType"]){// 教师列表
    
        /*
         1、默认筛选条件为管理员；
         2、未加入班级教师去掉；
         3、管理员条件更改为本班管理员；
         4、本班教师保持不变；
         5、全部更改为全校教师；
         6、顺序调整为本班管理员、本班教师、全校教师；
         */
        
        [self setCustomizeTitle:@"筛选成员"];
        
        //NSDictionary *dic0 = [NSDictionary dictionaryWithObjectsAndKeys:@"全部老师",@"name",@"-2",@"teacherTypeForFilter", nil];
        //NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"本班管理员",@"name",@"9",@"teacherTypeForFilter", nil];
        //NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:@"本班老师",@"name",@"0",@"teacherTypeForFilter", nil];
        //NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys:@"未加入班级教师",@"name",@"-1",@"teacherTypeForFilter", nil];
#if BUREAU_OF_EDUCATION
       
        NSDictionary *dic0 = [NSDictionary dictionaryWithObjectsAndKeys:@"本部门教师",@"name",@"1",@"teacherTypeForFilter", nil];
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"非本部门教师",@"name",@"-1",@"teacherTypeForFilter", nil];
        
#else
        NSDictionary *dic0 = [NSDictionary dictionaryWithObjectsAndKeys:@"本班老师",@"name",@"1",@"teacherTypeForFilter", nil];
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"非本班老师",@"name",@"-1",@"teacherTypeForFilter", nil];
        
#endif
        
        listArray = [[NSMutableArray alloc]initWithObjects:dic0,dic1,nil];
        
        for (int i=0; i<[listArray count]; i++) {
            [selectListArray addObject:@"0"];
        }

    
    }else if ([self.fromName isEqualToString:@"yeargradeForClass"]){//入学年份
        
        [self setCustomizeTitle:@"入学年份"];
        [super setCustomizeRightButtonWithName:@"保存"];
        
    }else if ([self.fromName isEqualToString:@"classType"]){//班级类型
#if BUREAU_OF_EDUCATION
     [self setCustomizeTitle:@"部门类型"];
        
#else
     [self setCustomizeTitle:@"班级类型"];
        
#endif
        
        [super setCustomizeRightButtonWithName:@"保存"];

    }
    else{
        
        [self setCustomizeTitle:@"筛选年级"];
       

    }
    
    _tableview.tableFooterView = [[UIView alloc]init];
}

// 返回
-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 2015.09.17
-(void)selectRightAction:(id)sender{
    
    if ([self.fromName isEqualToString:@"yeargradeForClass"]) {
        
        /**
         * 修改班级年份
         * 1. 前置条件班级管理员
         * @author luke
         * @date 2015.09.14
         * @args
         *  v=2, ac=Class, op=setYeargrade, sid=, cid=, uid=, year=年份数字
         */
        
        if ([_yeargradeForClass length] == 0) {
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"请选择入学年份。"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];

            
        }else{
            
            [Utilities showProcessingHud:self.view];
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Class",@"ac",
                                  @"2",@"v",
                                  @"setYeargrade", @"op",
                                  _cId, @"cid",
                                  _yeargradeForClass,@"year",
                                  nil];
            
            [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
                
                [Utilities dismissProcessingHud:self.view];
                NSDictionary *respDic = (NSDictionary*)responseObject;
                NSString *result = [respDic objectForKey:@"result"];
                
                if ([result integerValue] == 1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyClassInfo" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                    
                }
                
                
            } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                
                [Utilities dismissProcessingHud:self.view];
                [Utilities doHandleTSNetworkingErr:error descView:self.view];
                
            }];
            
 
        }
        
    }else if ([self.fromName isEqualToString:@"classType"]){
     
        /**
         * 修改班级类型
         * 1. 前置条件班级管理员
         * @author luke
         * @date 2015.09.14
         * @args
         *  v=2, ac=Class, op=setClassType, sid=, cid=, uid=, key=班级类型KEY值,[0,1,2]
         *
         */
        if ([_classType length] == 0) {
            
#if BUREAU_OF_EDUCATION
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"请选择部门类型。"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
#else
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"请选择班级类型。"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
#endif
           
            
        }else{
            
            [Utilities showProcessingHud:self.view];
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Class",@"ac",
                                  @"2",@"v",
                                  @"setClassType", @"op",
                                  _cId, @"cid",
                                  _classType,@"key",
                                  nil];
            
            [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
                
                [Utilities dismissProcessingHud:self.view];
                NSDictionary *respDic = (NSDictionary*)responseObject;
                NSString *result = [respDic objectForKey:@"result"];
                
                if ([result integerValue] == 1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyClassInfo" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                    
                }
                
                
            } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                
                [Utilities dismissProcessingHud:self.view];
                [Utilities doHandleTSNetworkingErr:error descView:self.view];
                
            }];
        }
        
    }
}


// 获取数据从服务器
-(void)getData{
    [Utilities showProcessingHud:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *array = [FRNetPoolUtils getFilterList];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities dismissProcessingHud:self.view];
            
            if (array == nil) {
                
                [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                if ([self.fromName isEqualToString:@"yeargradeForClass"]) {//入学年份
                    
                    if ([array count] > 0) {
                        
                        listArray = [[NSMutableArray alloc]init];
                        
                        for (int i=0; i<[array count]; i++) {
                            
                            NSString *yeargrade = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"yeargrade"]];
                            if ([yeargrade integerValue] == 0) {
                                
                            }else{
                                [listArray addObject:[array objectAtIndex:i]];
                            }
                            
                        }
                        
                         [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                    }
                    
                }else{
                    if ([array count] > 0 ) {
                        
                        listArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                        
                        for (int i=0; i<[listArray count]; i++) {
                            [selectListArray addObject:@"0"];
                        }
                        
                        [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                        
                    }else{
                        
                    }
                }
                
            }
        });
    });

}

-(void)getClassType{
    
    /**
     * 获取班级类型
     * @author luke
     * @date 2015.09.14
     * @args
     *  v=2, ac=Class, op=getClassTypes, sid=, cid=, uid=
     */
    [Utilities showProcessingHud:self.view];
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Class",@"ac",
                          @"2",@"v",
                          @"getClassTypes", @"op",
                          _cId, @"cid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            NSMutableArray *array = [respDic objectForKey:@"message"];
            listArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
            [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
           
        }else{
            [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
            
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        
    }];

    
}

-(void)reload{
    
    [_tableview reloadData];
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
    static NSString *CellTableIdentifier = @"FilterTableViewCell";
    
    FilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        
        //        cell = [[ClassListTableViewCell alloc]
        //                initWithStyle:UITableViewCellStyleDefault
        //                reuseIdentifier:CellTableIdentifier];
        
        UINib *nib = [UINib nibWithNibName:@"FilterTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    }
    
//    if(cell.isSelected == 1) {
//        cell.selectedImgV.hidden = NO;
//    }else{
//        cell.selectedImgV.hidden = YES;
//    }
    cell.selectedImgV.hidden = YES;
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if ([_fromName isEqualToString:@"selectTeacherType"]){// 老师筛选
        
        NSString *flag = [userdefaults objectForKey:@"teacherTypeForFilter"];
        if ([flag isEqualToString:@"1"]) {
            if (indexPath.row == 0) {
               [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }else{
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
            
        }else{
            if (indexPath.row == 0) {
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }else{
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }
        }
        
    }else if ([_fromName isEqualToString:@"selectUserType"]){// 成员筛选
        
       
        NSString *flag = [userdefaults objectForKey:@"userTypeForFilter"];
        if ([flag isEqualToString:@"-1"]) {
            if (indexPath.row == 0) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }else{
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
            
        }else if([flag isEqualToString:@"7"]){
            if (indexPath.row == 1) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }else{
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
        }else if([flag isEqualToString:@"6"]){
            if (indexPath.row == 2) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }else{
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
        }else if([flag isEqualToString:@"0"]){
            if (indexPath.row == 3) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }else{
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
        }
        
    }else if ([_fromName isEqualToString:@"yeargradeForClass"]){//入学年份
        
         NSString *yeargrade = [[listArray objectAtIndex:indexPath.row] objectForKey:@"yeargrade"];
         NSString *flag = _yeargradeForClass;
        
        if ([flag intValue] == 0 || [flag length] == 0) {
            
           [cell setAccessoryType:UITableViewCellAccessoryNone];
            
        }else{
            if ([yeargrade isEqualToString:flag]) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }else{
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
        }
        
    }else if ([_fromName isEqualToString:@"classType"]){
        
        NSString *classType = [NSString stringWithFormat:@"%@",[[listArray objectAtIndex:indexPath.row] objectForKey:@"key"]];
        NSString *flag = _classType;//类型id
        
        if ([flag length] == 0) {
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            
        }else{
            if ([classType isEqualToString:flag]) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }else{
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
        }
        
    }else{// 年级筛选
        
        NSString *yeargrade = [[listArray objectAtIndex:indexPath.row] objectForKey:@"yeargrade"];
        NSString *flag = [userdefaults objectForKey:@"yeargradeForFilter"];
        
        if ([flag intValue] == 0) {
            if (indexPath.row == 0) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }else{
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
        }else{
            if ([yeargrade isEqualToString:flag]) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }else{
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
        }
    
    }
    
    if ([_fromName isEqualToString:@"classType"]) {//班级类型
        NSString *name = [[listArray objectAtIndex:indexPath.row] objectForKey:@"value"];
        cell.titleLabel.text = name;
    }else{
        NSString *name = [[listArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.titleLabel.text = name;
    }
    
    return cell;
    
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"99999999999999999 %@", indexPath);
    //    NSLog(@"99999999999999999 %d", indexPath.section);
    //    NSLog(@"99999999999999999 %d", indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
   
//    for (int i =0 ; i< [selectListArray count]; i++) {
//        
//        NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:i inSection:0];
//        FilterTableViewCell *cell = (FilterTableViewCell*)[tableView cellForRowAtIndexPath:indexPath1];
//        
//        if (indexPath.row == i) {
//            cell.selectedImgV.hidden = NO;
//            cell.isSelected = 1;
//        }else{
//            cell.selectedImgV.hidden = YES;
//            cell.isSelected = 0;
//        }
//    }
    NSLog(@"ClassFilter");
    //{筛选条件：[-1:all|0:学生|6:家长|7:老师]}
    if ([_fromName isEqualToString:@"selectUserType"]) {// 成员筛选
    
        NSString *typeFlag = [[listArray objectAtIndex:indexPath.row] objectForKey:@"userTypeForFilter"];
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setObject:typeFlag forKey:@"userTypeForFilter"];
        [userdefaults synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMemberList" object:nil];
        
    
    }if ([_fromName isEqualToString:@"selectTeacherType"]) {// 教师筛选
        
        // grade=(Integer,不传递->全部,-1->未加入班级教师,0->已经加入班级老师并且是成员,9->已经加入班级老师并且是管理员 1->本班老师)
        NSString *teacherTypeFlag = [[listArray objectAtIndex:indexPath.row] objectForKey:@"teacherTypeForFilter"];
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setObject:teacherTypeFlag forKey:@"teacherTypeForFilter"];
        [userdefaults synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAdminMemberList" object:nil];
        
    }else if ([_fromName isEqualToString:@"yeargradeForClass"]){//入学年份
    
        NSString *yeargrade = [[listArray objectAtIndex:indexPath.row] objectForKey:@"yeargrade"];
        _yeargradeForClass = yeargrade;
        [_tableview reloadData];
        
    }else if ([_fromName isEqualToString:@"classType"]){//班级类型
        
        NSString *classType = [NSString stringWithFormat:@"%@",[[listArray objectAtIndex:indexPath.row] objectForKey:@"key"]];
        _classType = classType;
        [_tableview reloadData];

    }else{// 年级筛选
        
        NSString *yeargrade = [[listArray objectAtIndex:indexPath.row] objectForKey:@"yeargrade"];
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setObject:yeargrade forKey:@"yeargradeForFilter"];
        [userdefaults synchronize];
        NSLog(@"updateClassList");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateClassList" object:nil];

    }
    
    if ([_fromName isEqualToString:@"yeargradeForClass"] || [_fromName isEqualToString:@"classType"]) {
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];

    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if ([_fromName isEqualToString:@"selectUserType"] || [_fromName isEqualToString:@"selectTeacherType"]) {// 成员筛选
    
    }else if ([_fromName isEqualToString:@"classType"]){//班级类型
        
        [self getClassType];
        
    }else{// 年级筛选 入学年份
        
      [self getData];
    
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
