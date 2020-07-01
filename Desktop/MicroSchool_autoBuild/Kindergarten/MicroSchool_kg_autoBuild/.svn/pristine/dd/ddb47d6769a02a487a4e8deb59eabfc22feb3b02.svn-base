//
//  AddClassApplyViewController.m
//  MicroSchool
//
//  Created by Kate on 16/6/17.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "AddClassApplyViewController.h"
#import "ChooseTableViewCell.h"
#import "GenderViewController.h"
#import "SetRelationsViewController.h"
#import "ClassListViewController.h"
#import "NameViewController.h"

#import "GrowthNotValidateViewController.h"
#import "PayViewController.h"
#import "MomentsEntranceForTeacherController.h"
#import "Toast+UIView.h"
#import "MicroSchoolAppDelegate.h"
#import "MyInfoCenterViewController.h"

#import "RepeatNameViewController.h"
#import "SingleWebViewController.h"

#import "MyClassDetailViewController.h"

@interface AddClassApplyViewController ()

@end

@implementation AddClassApplyViewController
@synthesize dataDic;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:_titleName];
    
    // 隐藏导航条底部的线
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageViewa=(UIImageView *)obj;
                NSArray *list2=imageViewa.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }
    
    leftClassStr = @"";
    
    rightClassStr = @"";
    
    leftClassID = @"";
    
    rightClassID  = @"";
    
    leftParentID = @"";
    
    rightParentID = @"";
    
    NSArray *noIdDic0 =  [[NSArray alloc] initWithObjects:@"学生姓名",@"学生性别", nil];
   // NSArray *noIdDic1 =  [[NSArray alloc] initWithObjects:@"所在班级(可选)", nil];
    NSArray *IdDic0 =  [[NSArray alloc] initWithObjects:@"学生姓名",@"学生ID", nil];
    NSArray *commonArray = [[NSArray alloc] initWithObjects:@"与学生关系", nil];
  
    /*if ([_iden isEqualToString:@"parent"]) {
       
         noIdDic0 =  [[NSArray alloc] initWithObjects:@"学生姓名",@"性别",@"与学生关系", nil];
         IdDic0 =  [[NSArray alloc] initWithObjects:@"学生ID",@"与学生关系",nil];
    
    }
    
    if ([@"classApply" isEqualToString:_viewType]) {
        
        noIdDic1 =  [[NSArray alloc] initWithObjects:@"所在班级(必选)", nil];
    }*/
    
    //if (_cId) {
        
        sectionArray = [[NSMutableArray alloc] initWithObjects:noIdDic0,commonArray,nil];//暂无学生ID
        sectionArrayRight = [[NSMutableArray alloc] initWithObjects:IdDic0,commonArray,nil];//已有学生ID
        
    //}
   
     UIColor *color = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    _textField_name = [[UITextField alloc] initWithFrame: CGRectMake(118.0+20.0, 11, 168.0-10.0, 21.0)];
    _textField_name.clearsOnBeginEditing = NO;//鼠标点上时，不清空
    _textField_name.borderStyle = UITextBorderStyleNone;
    _textField_name.backgroundColor = [UIColor clearColor];
    _textField_name.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"学生姓名" attributes:@{NSForegroundColorAttributeName: color}];//设置placeholder颜色
    _textField_name.font = [UIFont systemFontOfSize:15.0f];
    _textField_name.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    _textField_name.textAlignment = NSTextAlignmentLeft;
    _textField_name.keyboardType=UIKeyboardTypeDefault;
    _textField_name.returnKeyType =UIReturnKeyDone;
    _textField_name.autocorrectionType=UITextAutocorrectionTypeNo;
    _textField_name.tintColor = [UIColor colorWithRed:18.0/255.0 green:65.0/255.0 blue:249.0/255.0 alpha:1];
    _textField_name.autocapitalizationType = UITextAutocapitalizationTypeNone;//add 2015.04.13
    [_textField_name setDelegate: self];
    _textField_name.tag = 120;
    //    [_textFieldOri performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.01];
    
    _textField_nameLeft = [[UITextField alloc] initWithFrame: CGRectMake(118.0+20.0, 11, 168.0-10.0, 21.0)];
    _textField_nameLeft.clearsOnBeginEditing = NO;//鼠标点上时，不清空
    _textField_nameLeft.borderStyle = UITextBorderStyleNone;
    _textField_nameLeft.backgroundColor = [UIColor clearColor];
    _textField_nameLeft.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"学生姓名" attributes:@{NSForegroundColorAttributeName: color}];//设置placeholder颜色
    _textField_nameLeft.font = [UIFont systemFontOfSize:15.0f];
    _textField_nameLeft.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    _textField_nameLeft.textAlignment = NSTextAlignmentLeft;
    _textField_nameLeft.keyboardType=UIKeyboardTypeDefault;
    _textField_nameLeft.returnKeyType =UIReturnKeyDone;
    _textField_nameLeft.autocorrectionType=UITextAutocorrectionTypeNo;
    _textField_nameLeft.tintColor = [UIColor colorWithRed:18.0/255.0 green:65.0/255.0 blue:249.0/255.0 alpha:1];
    _textField_nameLeft.autocapitalizationType = UITextAutocapitalizationTypeNone;//add 2015.04.13
    [_textField_nameLeft setDelegate: self];
    _textField_nameLeft.tag = 121;

    
    
    _textField_number = [[UITextField alloc] initWithFrame:CGRectMake(118.0+20.0, 11, 168.0-10.0, 21.0)];
    _textField_number.clearsOnBeginEditing = NO;//鼠标点上时，不清空
    _textField_number.borderStyle = UITextBorderStyleNone;
    _textField_number.backgroundColor = [UIColor clearColor];
    _textField_number.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"填写ID" attributes:@{NSForegroundColorAttributeName: color}];//设置placeholder颜色
    _textField_number.font = [UIFont systemFontOfSize:15.0f];
    _textField_number.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    _textField_number.textAlignment = NSTextAlignmentLeft;
    _textField_number.keyboardType=UIKeyboardTypeDefault;
    _textField_number.returnKeyType =UIReturnKeyDone;
    _textField_number.autocorrectionType=UITextAutocorrectionTypeNo;
    _textField_number.tintColor =[UIColor colorWithRed:18.0/255.0 green:65.0/255.0 blue:249.0/255.0 alpha:1];
    _textField_number.autocapitalizationType = UITextAutocapitalizationTypeNone;//add 2015.04.13
    [_textField_number setDelegate: self];
    _textField_number.tag = 121;
    
    if (![@"fromLogin"  isEqual: _type]) {
        
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userSettingDetailInfo"];
        if (nil != dic) {
            
            GlobalSingletonUserInfo* g_userPersonalInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
            [g_userPersonalInfo resetPersonalInfo];
            personalInfo = [g_userPersonalInfo getUserPersonalInfo];
            
            [personalInfo setObject:[dic objectForKey:@"name"] forKey:@"name"];
            [personalInfo setObject:[dic objectForKey:@"role_id"] forKey:@"identity"];
            
            NSString *gender;
            if ([@"1"  isEqual: [dic objectForKey:@"sex"]]) {
                gender = @"1";
            }else {
                gender = @"2";
            }
        
            [personalInfo setObject:gender forKey:@"gender"];
            [personalInfo setObject:[dic objectForKey:@"birthyear"] forKey:@"birthyear"];
            [personalInfo setObject:[dic objectForKey:@"birthmonth"] forKey:@"birthmonth"];
            [personalInfo setObject:[dic objectForKey:@"birthday"] forKey:@"birthday"];
        
        }else {
            // 去单例里重置下个人信息
            GlobalSingletonUserInfo *g_userPersonalInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
            [g_userPersonalInfo resetPersonalInfo];
            personalInfo = [g_userPersonalInfo getUserPersonalInfo];

            
        }
    }else {
        // 去单例里重置下个人信息
        GlobalSingletonUserInfo *g_userPersonalInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
        [g_userPersonalInfo resetPersonalInfo];
        personalInfo = [g_userPersonalInfo getUserPersonalInfo];
        
    }
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"weixiao_userLoginIsName"];
    [defaults synchronize];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signupClassSelect:) name:@"Zhixiao_signupClassSelect" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStudentID:) name:@"changeStudentID" object:nil];

    [self showContent];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backToPreView
{
    //if ([dataDic count] > 0) {
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        
//    }else{
//       [self.navigationController popViewControllerAnimated:YES];
//    }
    
}
- (void)test
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadPublishGrowingStatus" object:nil];
}


-(void)showContent{
    
    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    submitBtn.frame = CGRectMake(20, 10, 280, 44);
    submitBtn.frame = CGRectMake(0, 0, 0, 0);
    // 设置title自适应对齐
    submitBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal] ;
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"btn_common__1_p.png"] forState:UIControlStateHighlighted] ;
    
    // 添加 action
    [submitBtn addTarget:self action:@selector(submitAction:) forControlEvents: UIControlEventTouchUpInside];
    
    //设置title
    [submitBtn setTitle:@"确认" forState:UIControlStateNormal];
    [submitBtn setTitle:@"确认" forState:UIControlStateHighlighted];
    
    [self.view addSubview:submitBtn];
   
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    /*tableViewLeft = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    tableViewLeft.delegate = self;
    tableViewLeft.dataSource = self;
    [self.view addSubview:tableViewLeft];*/
    
    //如果对tableView进行monsory适配 那么代理方法一定要写 否则报错
    //已有ID
    tableViewRight = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    tableViewRight.delegate = self;
    tableViewRight.dataSource = self;
    tableViewRight.scrollEnabled = NO;//禁止滑动
    [self.view addSubview:tableViewRight];
    
    if ([dataDic count] > 0 ) {//说明有绑定的数据，只显示一个table 接口用rightTable的接口
       
        [tableViewRight mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view).with.offset(0);
            make.top.equalTo(self.view).with.offset(0);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, 200.0));
            
        }];
        
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view).with.offset(20);
            make.top.equalTo(tableViewRight.mas_bottom).with.offset(0);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-40.0, 42.0));
            
        }];
        
        _textField_name.userInteractionEnabled = NO;//不可编辑
        _textField_number.userInteractionEnabled = NO;//不可编辑
        
        
    }else{
        //说明没有有绑定的数据，可以切换
        
        segmentBaseView = [UIView new];
        segmentBaseView.backgroundColor = [UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1];
        [self.view addSubview:segmentBaseView];
        
        [segmentBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view).with.offset(0);
            make.top.equalTo(self.view).with.offset(0);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, 47.0));
            
        }];
        
        //segmentControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"新学生入口",@"已有学生ID",nil]];
        segmentControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"已有学生ID",@"暂无学生ID",nil]];
        segmentControl.frame = CGRectMake(0, 0, 0, 0);
        segmentControl.layer.masksToBounds = YES;
        segmentControl.layer.cornerRadius = 29.0 / 2.0f;
        segmentControl.layer.borderWidth = 1.0f;
        segmentControl.layer.borderColor = [UIColor whiteColor].CGColor;
        segmentControl.selectedSegmentIndex = 0;
        segmentControl.tintColor = [UIColor whiteColor];
        [segmentControl addTarget:self action:@selector(didClickSegmentedControlAction:)forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:segmentControl];
        
        [segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(segmentBaseView).with.offset(10);
            make.top.equalTo(segmentBaseView).with.offset(8);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-20, 29.0));
            
        }];
      
       //新学生入口
       tableViewLeft = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
       tableViewLeft.delegate = self;
       tableViewLeft.dataSource = self;
       tableViewLeft.scrollEnabled = NO;//禁止滑动
       [self.view addSubview:tableViewLeft];
        
        tableViewLeft.hidden = YES;
        
        [tableViewLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view).with.offset(0);
            make.top.equalTo(segmentBaseView.mas_bottom).with.offset(0);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, 200.0));
            
            
        }];
        
        [tableViewRight mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view).with.offset(0);
            make.top.equalTo(segmentBaseView.mas_bottom).with.offset(0);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, 200.0));
           
            
        }];
        
        /*[submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view).with.offset(20);
            make.top.equalTo(tableViewLeft.mas_bottom).with.offset(0);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-40.0, 44.0));
            
        }];*/
        
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view).with.offset(20);
            make.top.equalTo(tableViewRight.mas_bottom).with.offset(0);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-40.0, 42.0));
            
        }];
        
        tipLabel = [UILabel new];
        tipLabel.text = @"如何查找ID？";
        tipLabel.font = [UIFont systemFontOfSize:15.0];
        tipLabel.textColor = [UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:tipLabel];
        
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view).with.offset(0);
            make.top.equalTo(submitBtn.mas_bottom).with.offset(20);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, 22.0));
            
        }];
        
        bottomLine = [UIView new];
        bottomLine.backgroundColor = [UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1];
        [tipLabel addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view).with.offset(([Utilities getScreenSizeWithoutBar].width - 82.0)/2.0-4);
            make.top.equalTo(tipLabel.mas_bottom).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(82.0, 1.0));
            
        }];
        
        howtoFindIdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        howtoFindIdBtn.backgroundColor = [UIColor clearColor];
        [howtoFindIdBtn addTarget:self action:@selector(howtoView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:howtoFindIdBtn];
        [howtoFindIdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(bottomLine).with.offset(0);
            make.top.equalTo(tipLabel).with.offset(-4);
            make.size.mas_equalTo(CGSizeMake(82.0, 30.0));
            
        }];
        
    }
    
}

// 如何查找ID
-(void)howtoView{
    
    NSLog(@"111");
    
    //api的地址＋/weixiao/wap/about_student_id.php
    NSString *urlStr;
    
#if IS_TEST_SERVER
    urlStr = @"https://test.5xiaoyuan.cn/open/index.php/WebView/FindId/kg";
#else
    urlStr = @"http://www.5xiaoyuan.cn/open/index.php/WebView/FindId/kg";
#endif
 
    SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
    NSURL *url = [NSURL URLWithString:urlStr];
    fileViewer.webType = SWLoadURl;
    fileViewer.url = url;
    //fileViewer.hideBar = YES;
    fileViewer.isShowSubmenu = @"0";
    [self.navigationController pushViewController:fileViewer animated:YES];
    
}

-(void)didClickSegmentedControlAction:(UISegmentedControl*)segment{
    
    if (segment.selectedSegmentIndex == 1) {//新学生入口
        
        tipLabel.hidden = YES;
        howtoFindIdBtn.hidden = YES;
        howtoFindIdBtn.hidden = YES;
        tableViewRight.hidden = YES;
        tableViewLeft.hidden = NO;
        
        [submitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view).with.offset(20);
            make.top.equalTo(tableViewLeft.mas_bottom).with.offset(0);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-40.0, 42.0));
            
        }];
        
    }else{//已有学生ID
        
        tipLabel.hidden = NO;
        howtoFindIdBtn.hidden = NO;
        tableViewLeft.hidden = YES;
        tableViewRight.hidden = NO;
        
        [submitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view).with.offset(20);
            make.top.equalTo(tableViewRight.mas_bottom).with.offset(0);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-40.0, 42.0));

        }];
        
    }
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_textField_name];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_textField_nameLeft];

    if (segmentControl.selectedSegmentIndex == 1) {//新学生入口
        
        leftClassStr = [personalInfo objectForKey:@"class"];
        NSLog(@"leftClassStr:%@",leftClassStr);
        leftClassID = [personalInfo objectForKey:@"cid"];
        leftParentID = [NSString stringWithFormat:@"%@",[personalInfo objectForKey:@"relationsId"]];
        [tableViewLeft reloadData];
        
    }else{//已有ID
        
        rightClassStr = [personalInfo objectForKey:@"class"];
        rightClassID = [personalInfo objectForKey:@"cid"];
        NSLog(@"rightClassStr:%@",rightClassStr);
        rightParentID = [NSString  stringWithFormat:@"%@",[personalInfo objectForKey:@"relationsId"]];
        [tableViewRight reloadData];
    }
   
}

-(void)submitAction:(id)sender{
    
    [_textField_name resignFirstResponder];
    [_textField_number resignFirstResponder];
    
    //NSString *gender = [personalInfo objectForKey:@"gender"];
    //    if ([@"男" isEqual:gender]) {
    //        gender = @"1";
    //    } else {
    //        gender = @"2";
    //    }
    
    NSString *role;
    if ([@"student"  isEqual: _iden]) {
        role = @"0";
    }else if ([@"parent"  isEqual: _iden]) {
        role = @"6";
    }
    
   {
        if (![@"classApply"  isEqual: _viewType]) {
            
            if (segmentControl) {
                
                if (segmentControl.selectedSegmentIndex == 1){//新学生入口
                    
                        if([_textField_nameLeft.text length] == 0){
                            
                            [Utilities showTextHud:@"学生姓名不能为空，请重新输入" descView:self.view];
                            
                        }else if ([@""  isEqual: leftParentID]){
                            
                             [Utilities showTextHud:@"与学生关系不能为空，请重新选择" descView:self.view];
                            
                        }else{
                            
                            [Utilities showProcessingHud:self.view];
                          
                             [self checkChangeRole];//检查身份
                            
                        }
                    
                    
                }else{//已有ID
                    
                    
                        if([_textField_name.text length] == 0){
                            
                             [Utilities showTextHud:@"学生姓名不能为空，请重新输入" descView:self.view];
                            
                        }else if ([_textField_number.text length] == 0) {
                            
                             [Utilities showTextHud:@"学生ID不能为空，请重新输入" descView:self.view];
                            
                        }else if ([@""  isEqual: rightParentID]){
                            
                              [Utilities showTextHud:@"与学生关系不能为空，请重新选择" descView:self.view];
                            
                        }else{
                            
                            [Utilities showProcessingHud:self.view];
                           
                             [self checkChangeRole];//检查身份
                            
                        }
                 
                }
                
            }else{
                
                    if ([@""  isEqual: [personalInfo objectForKey:@"relationsId"]]){
                        
                        [Utilities showTextHud:@"与学生关系不能为空，请重新选择" descView:self.view];

                        
                    }else{
                       
                        [Utilities showProcessingHud:self.view];
                       
                         [self checkChangeRole];//检查身份
                        
                    }
               
            }
            
        }else {
            
            if (segmentControl) {
                
                if (segmentControl.selectedSegmentIndex == 1){//新学生入口
                    
                        if([_textField_nameLeft.text length] == 0){
                            
                            [Utilities showTextHud:@"学生姓名不能为空，请重新输入" descView:self.view];

                            
                        }else if ([leftParentID isEqualToString:@""]){
                            
                            [Utilities showTextHud:@"与学生关系不能为空，请重新选择" descView:self.view];
                            
                        }else{
                            
                            [Utilities showProcessingHud:self.view];
                           
                             [self checkChangeRole];//检查身份
                        }
                    
                }else{//已有ID
                    
                    if([_textField_name.text length] == 0){
                        
                        [Utilities showTextHud:@"学生姓名不能为空，请重新输入" descView:self.view];
                        
                    }else if ([_textField_number.text length] == 0) {
                            

                        [Utilities showTextHud:@"学生ID不能为空，请重新输入" descView:self.view];

                        }else if ([rightParentID isEqualToString:@""]){
                            
                            [Utilities showTextHud:@"与学生关系不能为空，请重新选择" descView:self.view];

                            
                        }else{
                            
                            [Utilities showProcessingHud:self.view];
                            
                             [self checkChangeRole];//检查身份
                        }
                    
                }
                
            }else{
                
                    if ([@""  isEqual: [personalInfo objectForKey:@"relationsId"]]){
                        
                        [Utilities showTextHud:@"与学生关系不能为空，请重新选择" descView:self.view];

                        
                    }else{
                        
                        [Utilities showProcessingHud:self.view];
                        
                        [self checkChangeRole];//检查身份
                        
                    }
             
            }
         
        }
    }

}

/**
 * 检测身份改变
 * @auth yangzc
 * @date 16/6/1633
 * @args  v=4 ac=StudentIdBind op=checkChangeRole sid= cid= uid=  userType=[0:学生默认 6:家长]
 */
-(void)checkChangeRole{
    
    NSDictionary *data;
    
    NSString *leftUserType = @"0";//暂无学生ID
    NSString *rightUserType = @"0";//已有学生ID

    if (leftParentID!=nil && [leftParentID integerValue] != 7) {
        
        leftUserType = @"6";
        
    }
    if (rightParentID!=nil && [rightParentID integerValue] != 7){
        
        rightUserType = @"6";
    }
    
    if (segmentControl) {
        
        if (segmentControl.selectedSegmentIndex == 1) {//暂无学生ID
            
            data = [[NSDictionary alloc] initWithObjectsAndKeys:
                    REQ_URL, @"url",
                    @"StudentIdBind", @"ac",
                    @"4", @"v",
                    @"checkChangeRole", @"op",
                    leftUserType,@"userType",
                    nil];
            
        }else{//已有学生ID
            
            data = [[NSDictionary alloc] initWithObjectsAndKeys:
                    REQ_URL, @"url",
                    @"StudentIdBind", @"ac",
                    @"4", @"v",
                    @"checkChangeRole", @"op",
                    rightUserType,@"userType",
                    nil];
        }
        
     
        
    }else{//已有学生ID
        
        data = [[NSDictionary alloc] initWithObjectsAndKeys:
                REQ_URL, @"url",
                @"StudentIdBind", @"ac",
                @"4", @"v",
                @"checkChangeRole", @"op",
                rightUserType,@"userType",
                nil];
        
    }
    
  
    [[TSNetworking sharedClient] requestWithCustomizeURL:API_URL params:data successBlock:^(TSNetworking *request, id responseObject) {
        
        
        [Utilities dismissProcessingHud:self.view];
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        
        if ([result integerValue] == 1) {
            
            //如果选择家长时，在其他学校有过学生身份，将其学生身份转换为家长身份
            
            if (segmentControl) {
                
                if (segmentControl.selectedSegmentIndex == 1) {//暂无学生ID
                    //检查重名
                    [self checkName];
                    
                }else{//已有学生ID
                    
                    [Utilities showProcessingHud:self.view];
                    [self doSubmitProfile:YES];
                  
                }
                
            }else{//已有学生ID
                
                [Utilities showProcessingHud:self.view];
                [self doSubmitProfile:YES];

            }
          
            
        }else{// 当用户从家长变为学生后 弹出以下错误提示 无法申请学生身份
            
            [Utilities showAlert:@"提示" message: [NSString stringWithFormat:@"%@",[respDic objectForKey:@"message"]] cancelButtonTitle:@"确定" otherButtonTitle:nil];
            
        }
        

    }failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
}

/**
 * 检测重名信息
 * @args
 *   v=4 ac=StudentIdBind op=checkName, sid=, uid=, cid=,  name=真实姓名(张1) joinClassId=要加入的班级
 */
-(void)checkName{
    
    NSString *cid = @"";
    NSString *joinClassId = @"";
    if ([@"growthSpace"  isEqual: _viewType] || [@"classDetail" isEqualToString:_viewType]) {//update by kate 2016.03.03
        
        cid = _cId;
        joinClassId = _cId;
        
    }else {
        
        joinClassId = [personalInfo objectForKey:@"cid"];
        
        if (segmentControl) {
            
            if (segmentControl.selectedSegmentIndex == 1) {//新学生入口
                
                joinClassId = leftClassID;
                
            }else{//已有ID
                
                joinClassId = rightClassID;
            }
            
        }
        
        cid = @"0";
        
    }
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
            REQ_URL, @"url",
            @"StudentIdBind", @"ac",
            @"4", @"v",
            @"checkName", @"op",
            _textField_nameLeft.text, @"name",
            joinClassId,@"joinClassId",
            cid, @"cid",
            nil];

    [[TSNetworking sharedClient] requestWithCustomizeURL:API_URL params:data successBlock:^(TSNetworking *request, id responseObject) {
        
        
        [Utilities dismissProcessingHud:self.view];
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        NSLog(@"respDic:%@",respDic);
        
        if ([result integerValue] == 1) {//有重名 进入重名列表
            
            NSMutableArray *reNameArray = [respDic objectForKey:@"message"];
            
            if ([reNameArray count] > 0) {//有重名进入重名列表页
                
                NSString *parent = [personalInfo objectForKey:@"relationsId"];
                
                if (segmentControl) {
                    
                    if (segmentControl.selectedSegmentIndex == 1) {
                        parent = leftParentID;
                    }else{
                        parent = rightParentID;
                    }
                }
                
                NSString *gender = [personalInfo objectForKey:@"gender"];
                
                NSDictionary *userInfoDic = [[NSDictionary alloc] initWithObjectsAndKeys:_textField_nameLeft.text,@"name",gender,@"sex",parent,@"parent",@"0",@"number", nil];
                
                RepeatNameViewController *rnvc = [[RepeatNameViewController alloc] init];
                rnvc.dataArr = reNameArray;
                rnvc.userInfoDic = userInfoDic;
                rnvc.viewType = _viewType;
                rnvc.cId = _cId;
                [self.navigationController pushViewController:rnvc animated:YES];
                
            }else{//无重名
                
                if (_cId) {//在班级内 直接调用绑定接口
                    
                    [Utilities showProcessingHud:self.view];
                    [self doSubmitProfile:NO];//暂无学生ID
                    
                }else{//不在班级内 去班级选择页
                   
                    NSString *gender = [personalInfo objectForKey:@"gender"];
                    
                    NSString *parent = [personalInfo objectForKey:@"relationsId"];
                    
                    if (segmentControl) {
                        
                        if (segmentControl.selectedSegmentIndex == 1) {
                            parent = leftParentID;
                        }else{
                            parent = rightParentID;
                        }
                    }
                    
                    NSDictionary *userInfoDic = [[NSDictionary alloc] initWithObjectsAndKeys:_textField_nameLeft.text,@"name",gender,@"sex",parent,@"parent",@"0",@"number", nil];
                    NSLog(@"no rename apply");

                    ClassListViewController *class = [[ClassListViewController alloc] init];
                    class.viewType = @"signup";
                    class.userInfoDic = userInfoDic;
                    class.flag = _flag;
                    [self.navigationController pushViewController:class animated:YES];
                    
                }
               
            }
            
        }else{
            
         
            [Utilities showTextHud:[NSString stringWithFormat:@"%@",[respDic objectForKey:@"message"]] descView:self.view];
            
        }
        
    }failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
    
}

-(void)doSubmitProfile:(BOOL)isID{
    
    NSDictionary *data;
    NSString *gender = [personalInfo objectForKey:@"gender"];
    
    if (isID) {//已有学生ID
        
        NSString *joincid = [personalInfo objectForKey:@"cid"];
        
        if ([rightParentID integerValue] == 7){//学生
           
            /**
             * 学生加入班级
             * @args
             *  v=4 ac=StudentIdBind op=student, sid=, uid=, cid=, sex=, name=真实姓名, number=学籍号，无则提交0 joinClassId=要加入的班级
             */
            data = [[NSDictionary alloc] initWithObjectsAndKeys:
                    REQ_URL, @"url",
                    @"StudentIdBind", @"ac",
                    @"4", @"v",
                    @"student", @"op",
                    _textField_name.text, @"name",
                    gender,@"sex",
                    _textField_number.text,@"number",
                    joincid,@"joinClassId",
                    _cId,@"cid",
                    nil];
            
            
        }else{//家长
            /**
             * 家长加入班级
             * @args
             *  v=4 ac=StudentIdBind op=parent, sid=, uid=, cid=, sex= parent=亲子关系, name=真实姓名, number=学籍号，无则提交0 joinClassId=要加入的班级
             */
            data = [[NSDictionary alloc] initWithObjectsAndKeys:
                    REQ_URL, @"url",
                    @"StudentIdBind", @"ac",
                    @"4", @"v",
                    @"parent", @"op",
                    _textField_name.text, @"name",
                    gender,@"sex",
                    _textField_number.text,@"number",
                    rightParentID,@"parent",
                    joincid,@"joinClassId",
                    _cId,@"cid",
                    nil];
            
        }
        
    }else{//暂无学生ID
        
        //在班级内
        if ([leftParentID integerValue] == 7) {
           
            /**
             * 学生无ID加入班级
             * @args
             * v=4 ac=StudentIdBind op=studentJoinHasNoId, sid=, uid=, cid=, sex=  name=真实姓名 joinClassId=要加入的班级
             */
            data = [[NSDictionary alloc] initWithObjectsAndKeys:
                    REQ_URL, @"url",
                    @"StudentIdBind", @"ac",
                    @"4", @"v",
                    @"studentJoinHasNoId", @"op",
                    _textField_nameLeft.text, @"name",
                    gender,@"sex",
                    _cId,@"cid",
                    _cId,@"joinClassId",
                    nil];

        }else{
            /**
             * 家长无ID加入班级
             * @args
             * v=4 ac=StudentIdBind op=parentJoinHasNoId, sid=, uid=, cid=, sex=  parent=亲子关系, name=真实姓名 joinClassId=要加入的班级
             */
            data = [[NSDictionary alloc] initWithObjectsAndKeys:
                    REQ_URL, @"url",
                    @"StudentIdBind", @"ac",
                    @"4", @"v",
                    @"parentJoinHasNoId", @"op",
                    _textField_nameLeft.text, @"name",
                    gender,@"sex",
                    leftParentID,@"parent",
                    _cId,@"cid",
                    _cId,@"joinClassId",
                    nil];
            
        }
     
    }
    
    [[TSNetworking sharedClient] requestWithCustomizeURL:API_URL params:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        NSLog(@"respDic:%@",respDic);
        
        if(true == [result intValue]) {
            
            NSLog(@"data:%@",data);
            
            if ([[[respDic objectForKey:@"message"] objectForKey:@"joinError"] integerValue] == 1) {
                
                [Utilities showAlert:@"提示" message:[[respDic objectForKey:@"message"] objectForKey:@"alert"] cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
            
                if ([@"classApply"  isEqual: _viewType]) {
                    
                    //done:先判断需不需要跳转到班级列表页
                    if ([[[respDic objectForKey:@"message"] objectForKey:@"selectClass"] integerValue] == 1) {//true选班级
                        
                        NSString *parent = [personalInfo objectForKey:@"relationsId"];
                        NSString *number  = @"0";
                        NSString *name = _textField_nameLeft.text;
                        
                        if (segmentControl) {
                            
                            if (segmentControl.selectedSegmentIndex == 1) {
                                
                                parent = leftParentID;
                               
                                
                            }else{
                                
                                parent = rightParentID;
                                number = _textField_number.text;
                                name = _textField_name.text;
                                
                            }
                            
                        }else{
                           
                            parent = rightParentID;
                            number = _textField_number.text;
                            name = _textField_name.text;
                            
                        }
                        
                        NSDictionary *userInfoDic = [[NSDictionary alloc] initWithObjectsAndKeys:name,@"name",gender,@"sex",parent,@"parent",number,@"number", nil];
                        NSLog(@"class apply");

                        ClassListViewController *class = [[ClassListViewController alloc] init];
                        class.viewType = @"signup";
                        class.userInfoDic = userInfoDic;
                        class.flag = _flag;
                        [self.navigationController pushViewController:class animated:YES];
                        
                    }else{//不选班级
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"zhixiao_myClassAppliedSuccessAndChangeStatus" object:self userInfo:nil];
                        
                        // 学生和老师在申请完班级后，改变一下真实姓名。
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                        dic = [g_userInfo getUserDetailInfo];
                        
                        NSString *relations =  [personalInfo objectForKey:@"relations"];
                        if (segmentControl) {
                            
                            if (segmentControl.selectedSegmentIndex == 1) {
                                
                                relations = leftParentID;
                            }else{
                                relations = rightParentID;
                            }
                            
                        }
                        
                        NSString *name = [NSString stringWithFormat:@"%@%@", _textField_name.text, relations];
                        [dic setValue:name forKey:@"name"];
                        
                        if ([personalInfo objectForKey:@"cid"]) {
                            
                            if ([_iden isEqualToString:@"parent"] || [_iden isEqualToString:@"student"]) {
                                [dic setObject:[personalInfo objectForKey:@"cid"] forKey:@"role_cid"];
                            }
                            
                        }
                        
                        [g_userInfo setUserDetailInfo:dic];
                        
                        
                        [self performSelector:@selector(backToPreView) withObject:nil afterDelay:0.2];
                        
                    }
                    
                    
                }else if ([@"growthSpace"  isEqual: _viewType]) {
                    
                    if ([[[respDic objectForKey:@"message"] objectForKey:@"joinError"] integerValue] == 1) {
                        
                        [Utilities showAlert:@"提示" message:[[respDic objectForKey:@"message"] objectForKey:@"alert"] cancelButtonTitle:@"确定" otherButtonTitle:nil];
                        
                    }else{
                        
                        [ReportObject event:ID_BIND_SPACE_SUCCESSFULLY];
                        
                        // done :如果空间状态为0未开通 直接到空间主页
                        NSString *status = [[respDic objectForKey:@"message"] objectForKey:@"status"];
                        NSString *trial = [NSString stringWithFormat:@"%@",[[respDic objectForKey:@"message"] objectForKey:@"trial"]];
                        
                        if (_publish == 1) {//从动态列表进入或发布页进来
                            
                            //如果已开通 返回
                            [self performSelector:@selector(test) withObject:nil afterDelay:0.5];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadGrowingPathStatus" object:nil];
                            
                            if ([status integerValue] == 0) {
                                
                                if ([trial integerValue] == 0) {
                                    
                                    PayViewController *growVC = [[PayViewController alloc] init];
                                    growVC.fromName = @"publishB";
                                    growVC.cId = _cId;
                                    growVC.spaceStatus = status;
                                    growVC.isTrial = trial;
                                    [self.navigationController pushViewController:growVC animated:YES];
                                    
                                }else{
                                    GrowthNotValidateViewController *growVC = [[GrowthNotValidateViewController alloc] init];
                                    growVC.fromName = @"publishB";
                                    growVC.cId = _cId;
                                    growVC.urlStr = _growingPathStatusUrl;
                                    growVC.spaceStatus = status;
                                    [self.navigationController pushViewController:growVC animated:YES];
                                    
                                }
                                
                            }else if ([status integerValue] == 3 || [status integerValue] == 4){
                                
                                PayViewController *pvc = [[PayViewController alloc] init];
                                pvc.fromName = @"publishB";
                                pvc.cId = _cId;
                                [self.navigationController pushViewController:pvc animated:YES];
                                
                            }else{
                                
                                if (_flag == 1 || _flag == 2) {
                                    
                                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3] animated:YES];
                                    
                                }else{
                                    [self.navigationController popViewControllerAnimated:YES];
                                    
                                }
                                
                            }
                            
                        }else{//从班级详情页的模块进来
                            
                            if ([status integerValue] == 0) {
                                
                                if ([trial integerValue] == 0) {
                                    
                                    PayViewController *growVC = [[PayViewController alloc] init];
                                    growVC.fromName = @"class";
                                    growVC.cId = _cId;
                                    growVC.spaceStatus = status;
                                    growVC.isTrial = trial;
                                    [self.navigationController pushViewController:growVC animated:YES];
                                    
                                }else{
                                    
                                    GrowthNotValidateViewController *growVC = [[GrowthNotValidateViewController alloc] init];
                                    growVC.cId = _cId;
                                    growVC.urlStr = _growingPathStatusUrl;
                                    growVC.spaceStatus = status;
                                    [self.navigationController pushViewController:growVC animated:YES];
                                    
                                }
                            }else{
                                
                                GrowthNotValidateViewController *grouthViewCtrl = [[GrowthNotValidateViewController alloc] init];
                                grouthViewCtrl.fromName = @"bind";
                                grouthViewCtrl.cId = _cId;
                                grouthViewCtrl.urlStr = _growingPathStatusUrl;
                                grouthViewCtrl.spaceStatus = status;
                                [self.navigationController pushViewController:grouthViewCtrl animated:YES];
                                
                            }
                            
                        }
                    }
                    
                }else if ([@"classDetail"  isEqual: _viewType]){//add by kate 2016.03.03
                    
                    if ([[[respDic objectForKey:@"message"] objectForKey:@"joinError"] integerValue] == 1) {
                        
                        [Utilities showAlert:@"提示" message:[[respDic objectForKey:@"message"] objectForKey:@"alert"] cancelButtonTitle:@"确定" otherButtonTitle:nil];
                        
                    }else{
                        
                        if (_flag == 1 || _flag == 2) {
                            
                            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3] animated:YES];
                            
                        }else{
                            [self.navigationController popViewControllerAnimated:YES];
                            
                        }
                    }
                    
                }else if ([@"changeChild"  isEqual: _viewType]){//切换子女页的添加新子女
                    
                    if ([[[respDic objectForKey:@"message"] objectForKey:@"selectClass"] integerValue] == 1) {//true选班级
                        
                        NSString *parent = [personalInfo objectForKey:@"relationsId"];
                        NSString *number  = @"0";
                        NSString *name = _textField_nameLeft.text;
                        
                        if (segmentControl) {
                            
                            if (segmentControl.selectedSegmentIndex == 1) {
                                
                                parent = leftParentID;
                            
                            }else{
                                
                                parent = rightParentID;
                                number = _textField_number.text;
                                name = _textField_name.text;
                                
                            }
                        }
                        
                       
                        //NSDictionary *userInfoDic = [[NSDictionary alloc] initWithObjectsAndKeys:_textField_nameLeft.text,@"name",gender,@"sex",parent,@"parent",@"0",@"number", nil];
                        
                         NSDictionary *userInfoDic = [[NSDictionary alloc] initWithObjectsAndKeys:name,@"name",gender,@"sex",parent,@"parent",number,@"number", nil];
                        NSLog(@"changeChild apply");
                        ClassListViewController *class = [[ClassListViewController alloc] init];
                        class.viewType = @"signup";
                        class.userInfoDic = userInfoDic;
                        class.flag = _flag;
                        [self.navigationController pushViewController:class animated:YES];
                        
                    }else{
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"zhixiao_refleshSwitchChildView" object:self userInfo:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }
                    
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_PROFILE object:nil];
                
            }
        
            
        }else {
            
            NSString *info = [[respDic objectForKey:@"message"] objectForKey:@"alert"];
            
            [Utilities showTextHud:info descView:self.view];
            
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
      
}

-(void)gotoMain
{
    
    [self initTabBarController];
    //-----------------------------------------------------------------------------
    // update 2015.10.21 教育服务发布商品 不能进入相册问题 原因是controller不在window上
    //                        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    //                        [self presentViewController:appDelegate.tabBarController animated:NO completion:nil];
    
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = appDelegate.tabBarController;
    
    //-------------------------------------------------------------------------------
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == tableViewLeft) {
        return [sectionArray count];
 
    }else{
        return [sectionArrayRight count];
    }
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == tableViewLeft) {
       return [(NSMutableArray*)[sectionArray objectAtIndex:section] count];
    }else{
        return [(NSMutableArray*)[sectionArrayRight objectAtIndex:section] count];
        
    }
  
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

//    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]
//                initWithStyle:UITableViewCellStyleValue1
//                reuseIdentifier:GroupedTableIdentifier];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//    
//    }
    
    static NSString *GroupedTableIdentifier = @"ChooseTableViewCell";
    ChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    if(cell == nil) {
        
        UINib *nib = [UINib nibWithNibName:@"ChooseTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:GroupedTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    cell.titleLabel.frame = CGRectMake(cell.titleLabel.frame.origin.x, cell.titleLabel.frame.origin.y, 92.0+30.0, cell.titleLabel.frame.size.height);
    cell.valueLabel.frame = CGRectMake(118.0+20.0, cell.valueLabel.frame.origin.y, 168.0-10.0, cell.valueLabel.frame.size.height);
    cell.placeholderLabel.frame = CGRectMake(cell.valueLabel.frame.origin.x, cell.placeholderLabel.frame.origin.y, cell.placeholderLabel.frame.size.width, cell.placeholderLabel.frame.size.height);
    cell.valueLabel.textAlignment = NSTextAlignmentLeft;
    cell.valueLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    
    if (tableView == tableViewLeft) {
        
        NSString *title = [[sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.titleLabel.text = title;
        
        if ([title isEqualToString:@"姓名"] || [title isEqualToString:@"学生姓名"]) {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            if (![cell.contentView viewWithTag:121]){
                [cell.contentView addSubview: _textField_nameLeft];
            }
            cell.placeholderLabel.hidden = YES;
          
        }else{
            
            cell.placeholderLabel.hidden = NO;
            
            if ([title isEqualToString:@"学生性别"]) {
                
                cell.placeholderLabel.hidden = YES;
                
                 NSString *gender = [personalInfo objectForKey:@"gender"];
                if ([dataDic count] > 0) {
                    gender = [dataDic objectForKey:@"sex"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                
                    if ([@"2" isEqual:gender]) {//2是女
                        gender = @"女";
                    } else {
                        gender = @"男";
                    }
                
                cell.valueLabel.text = gender;
                
            }/*else if ([title isEqualToString:@"所在班级(可选)"] || [title isEqualToString:@"所在班级(必选)"]){
               
                if ([[personalInfo objectForKey:@"class"] length] > 0) {
                    
                    cell.placeholderLabel.hidden = YES;
                    cell.valueLabel.text = [personalInfo objectForKey:@"class"];
                }
              
            }*/else if ([title isEqualToString:@"与学生关系"]){
                
                if ([[personalInfo objectForKey:@"relations"] length] > 0) {
                    
                    cell.placeholderLabel.hidden = YES;
                    cell.valueLabel.text = [personalInfo objectForKey:@"relations"];
                }
                
            }
        }
       
    }else{
        
        NSString *title = [[sectionArrayRight objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.titleLabel.text = [[sectionArrayRight objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        
        if ([title isEqualToString:@"姓名"] || [title isEqualToString:@"学生姓名"]) {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            if (![cell.contentView viewWithTag:120]){
                [cell.contentView addSubview: _textField_name];
            }
            cell.placeholderLabel.hidden = YES;
            if ([dataDic count] > 0) {
                _textField_name.text = [dataDic objectForKey:@"student_name"];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }else{
                //_textField_name.text = [personalInfo objectForKey:@"name"];
            }
            
        }else if ([title isEqualToString:@"学生ID"]) {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            if (![cell.contentView viewWithTag:121]) {
                [cell.contentView addSubview: _textField_number];
            }
            if ([dataDic count] > 0) {
                _textField_number.text = [dataDic objectForKey:@"student_number"];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }else{
                //_textField_number.text = [personalInfo objectForKey:@"number"];
            }
            
             cell.placeholderLabel.hidden = YES;
            
        }else{
            
            cell.placeholderLabel.hidden = NO;
            /*if ([title isEqualToString:@"所在班级(可选)"] || [title isEqualToString:@"所在班级(必选)"] ){
                
                if ([[personalInfo objectForKey:@"class"] length] > 0) {
                
                    cell.valueLabel.text = [personalInfo objectForKey:@"class"];
                    cell.placeholderLabel.hidden = YES;
                }
                
            }else*/ if ([title isEqualToString:@"与学生关系"]){
                
                if ([[personalInfo objectForKey:@"relations"] length] > 0) {
                
                    cell.valueLabel.text = [personalInfo objectForKey:@"relations"];
                    cell.placeholderLabel.hidden = YES;
                }
                
                
            }
            
        }

    }
    
    return cell;
 
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
          return 22.0;
    }else{
        return 5.0;
    }
  
}

//选中Cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    [_textField_name resignFirstResponder];
    [_textField_number resignFirstResponder];
 
    NSString *title = @"";
    
    if (tableView == tableViewLeft){
       
          title = [[sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
    }else{
        
        title = [[sectionArrayRight objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        
    }
    
    if ([title isEqualToString:@"姓名"] || [title isEqualToString:@"学生姓名"]) {
       
        if (tableView == tableViewLeft) {
            
            [_textField_nameLeft becomeFirstResponder];
            
        }else{
            
             [_textField_name becomeFirstResponder];
        }
        
    }else if ([title isEqualToString:@"学生性别"]) {
        
        if ([dataDic count] > 0) {
           
        }else{
            GenderViewController *genderViewCtrl = [[GenderViewController alloc] init];
            [self.navigationController pushViewController:genderViewCtrl animated:YES];
        }
        
    }else if ([title isEqualToString:@"与学生关系"]) {
        
        SetRelationsViewController *relations = [[SetRelationsViewController alloc] init];
        [self.navigationController pushViewController:relations animated:YES];
        
    }else if ([title isEqualToString:@"所在班级(可选)"] || [title isEqualToString:@"所在班级(必选)"]) {
        
        NSLog(@"didSelect apply");
        ClassListViewController *class = [[ClassListViewController alloc] init];
        class.viewType = @"signup";
        [self.navigationController pushViewController:class animated:YES];
        
    }else if ([title isEqualToString:@"学生ID"]) {
        
        [_textField_number becomeFirstResponder];
    }
}

-(void)changeStudentID:(NSNotification*)notification{
    
    NSDictionary *inDic = [notification object];
    
    if ([inDic count] > 0) {
        
        _textField_number.text = [inDic objectForKey:@"student_number"];
        _textField_name.text = [inDic objectForKey:@"student_name"];
        rightParentID = [inDic objectForKey:@"parent"];
        [self doSubmitProfile:YES];//已有学生ID
        NSLog(@"changeStudentID 0");
    }else{
        
        [self doSubmitProfile:NO];//暂无学生ID
          NSLog(@"changeStudentID 1");
    }
}

-(void)signupClassSelect:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    
    if (nil != dic) {
        _classInfoDic = dic;
    }
}

-(void)textFiledEditChanged:(NSNotification *)obj{
    
    //NSString *viewName = [[NSUserDefaults standardUserDefaults] objectForKey:@"viewName"];
    
    NSInteger limit;
    limit = 8;
    
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > limit) {
                textField.text = [toBeString substringToIndex:limit];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > limit) {
            textField.text = [toBeString substringToIndex:limit];
        }
    }
}

/*
 * 自定义tabbar add by kate
 */
- (void)initTabBarController
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (!appDelegate.tabBarController) {
        
        [appDelegate bindBaiduPush];//只有在进入主页后收到推送才显示 志伟确认 2015.12.09
        // 校园
        SchoolHomeViewController *schoolV = [[SchoolHomeViewController alloc] init];
        // 班级
        NSDictionary *userD = [g_userInfo
                               getUserDetailInfo];
        // 数据部分
        if (nil == userD) {
            userD = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDetailInfo"];
        }
        
        NSString *usertype = [NSString stringWithFormat:@"%@",[userD objectForKey:@"role_id"]];
        
        NSString *cid = @"0";
        
        MyClassListViewController *classV = [[MyClassListViewController alloc] init];
        
        MyClassDetailViewController *classDetailV = [[MyClassDetailViewController alloc] init];
        
        ParksHomeViewController *parkV = [[ParksHomeViewController alloc]init];
        
        
        //隐藏tabbar所留下的黑边（试着注释后你会知道这个的作用）
        schoolV.hidesBottomBarWhenPushed = YES;
        classV.hidesBottomBarWhenPushed = YES;
        classDetailV.hidesBottomBarWhenPushed = YES;
        parkV.hidesBottomBarWhenPushed = YES;
        schoolV.title = @"校园";
        classV.title = @"班级";
        parkV.title = @"乐园";
        
        UINavigationController *schoolNavi = [[UINavigationController alloc] initWithRootViewController:schoolV];
        
        UINavigationController *customizationNavi = [[UINavigationController alloc] initWithRootViewController:classDetailV];
        
        UINavigationController *ParkNavi = [[UINavigationController alloc]initWithRootViewController:parkV];
        
        
        NSArray *controllers;
        
        if([@"7"  isEqualToString: usertype] || [@"2" isEqualToString:usertype] || [@"9" isEqualToString:usertype])
        {
            customizationNavi = [[UINavigationController alloc] initWithRootViewController:classV];
            
        }
        else
        {
            cid = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[userD objectForKey:@"role_cid"]]];
            if(cid == nil){
                cid = @"0";
            }else{
                if([cid length] == 0){
                    cid = @"0";
                }
            }
            if([cid isEqualToString:@"0"]){
                customizationNavi = [[UINavigationController alloc] initWithRootViewController:classV];
            }
            classDetailV.fromName = @"tab";
        }
        classDetailV.cId = cid;
        
        controllers = [NSArray arrayWithObjects:schoolNavi, customizationNavi,ParkNavi, nil];
        //}
        //-----------------------------------------------------------------------------------------------
        
        
        //设置tabbar的控制器
        MyTabBarController *tabBar = [[MyTabBarController alloc] initWithSelectIndex:0];
        tabBar.viewControllers = controllers;
        tabBar.selectedIndex = 0;
        appDelegate.tabBarController = tabBar;
        
    }
    
    [appDelegate.tabBarController selectedTab:[[appDelegate.tabBarController buttons] objectAtIndex:0]];
    UINavigationController *tabBarControllerNavi = (UINavigationController *)self.tabBarController.selectedViewController;
    [tabBarControllerNavi popToRootViewControllerAnimated:NO];
    
    appDelegate.tabBarController.view.frame = [[UIScreen mainScreen] bounds];
    
    
    //    [self.window setRootViewController:self.tabBarController];
    //    [self.window bringSubviewToFront:self.tabBarController.view];
    
    
    
}
@end
