//
//  ClassListViewController.m
//  MicroSchool
//
//  Created by Kate on 14-9-16.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "ClassListViewController.h"

#import "UIImageView+WebCache.h"
#import "ClassMainViewController.h"
#import "ClassMainViewController2.h"
#import "ClassMainNoHomeworkViewController.h"
#import "ClassMainNoScheduleViewController.h"
#import "FRNetPoolUtils.h"
#import "ClassFilterViewController.h"
#import "ClassDetailViewController.h"
#import "MyTabBarController.h"
#import "GraduateViewController.h"//2015.09.16
#import "MyClassDetailViewController.h"
#import "ApplyAddClassViewController.h"
#import "MicroSchoolAppDelegate.h"

@interface ClassListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ClassListViewController

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
    
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
        [self.view addSubview:noNetworkV];
        return;
    }
    
    
    _tableView.tableFooterView = [[UIView alloc]init];
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateClassListUI)
                                                 name:@"updateClassList"
                                               object:nil];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(classAppliedSuccess:) name:@"zhixiao_classListAppliedSuccess" object:nil];

    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:@"" forKey:@"yeargradeForFilter"];
    
    
    [Utilities dismissProcessingHud:self.view];
    [Utilities showProcessingHud:self.view];
    NSLog(@"7777777");
    [self getData:@""];
    
    self.view.frame = CGRectMake(0, 0,WIDTH,HEIGHT);
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"tableviewHeight:%f",_tableView.frame.size.height);
    
    //----add by kate 2015.05.05---------------------------------------------------------------------
    schoolType = [[NSUserDefaults standardUserDefaults]objectForKey:@"schoolType"];
    // 教育局专版和幼儿园没有右上角的筛选
    
    /*
     type:学校类型 'university' => '大学', 'senior' => '高中', 'technical' => '中职', 'junior' => '初中',
     'primary' => '小学', 'kindergarten' => '幼儿园', 'training' => '培训', 'other' => '其他', 'bureau'=> '教育局'
     */
    
    if ([@"primary" isEqualToString:schoolType] || [@"junior" isEqualToString:schoolType] || [@"technical" isEqualToString:schoolType] || [@"senior" isEqualToString:schoolType] || [@"university" isEqualToString:schoolType]) {
        [self setCustomizeRightButton:@"icon_more"];
        [self setCustomizeTitle:@"班级"];
        
    }else{
        if ([schoolType isEqualToString:@"bureau"]) {//教育局 假数据
            // 需要后台给title,设置此页的title,教育局专版和幼儿园没有右上角的筛选
            [self setCustomizeTitle:@"部门列表"];
        }else{
            [self setCustomizeTitle:@"班级列表"];
        }
    }
    //------------------------------------------------------------------------------------------------
    
    [ReportObject event:ID_OPEN_ADD_CLASS_LIST];//2015.06.24
}

-(void)updateClassListUI{
    
    NSString *yeargradeForFilter = [[NSUserDefaults standardUserDefaults]objectForKey:@"yeargradeForFilter"];
    [Utilities dismissProcessingHud:self.view];
    [Utilities showProcessingHud:self.view];
    NSLog(@"66666666666");
    [self getData:yeargradeForFilter];
}

// 进入班级筛选列表
-(void)selectRightAction:(id)sender{
    
    //    ClassFilterViewController *classFilterV = [[ClassFilterViewController alloc]init];
    //    [self.navigationController pushViewController:classFilterV animated:YES];
    
    if (!isRightButtonClicked) {
        viewMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height)];
        
        imageView_bgMask =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height-44)];
        [imageView_bgMask setBackgroundColor:[[UIColor alloc] initWithRed:93/255.0f green:106/255.0f blue:122/255.0f alpha:0.4]];
        imageView_bgMask.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
        [imageView_bgMask addGestureRecognizer:singleTouch];
        
        // 选项菜单
        imageView_rightMenu =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                          [UIScreen mainScreen].applicationFrame.size.width - 128 - 10,
                                                                          5,
                                                                          128,
                                                                          87.0)];
        imageView_rightMenu.contentMode = UIViewContentModeScaleToFill;
        [imageView_rightMenu setImage:[UIImage imageNamed:@"friend/bg_contacts_more.png"]];
        
        
        // 年级筛选button
        button_search = [UIButton buttonWithType:UIButtonTypeCustom];
        button_search.frame = CGRectMake(
                                         imageView_rightMenu.frame.origin.x,
                                         imageView_rightMenu.frame.origin.y + 10,
                                         120,
                                         35);
        
        UIImage *buttonImg_d;
        UIImage *buttonImg_p;
        
        buttonImg_d = [UIImage imageNamed:@"icon_filter_class_d.png"];
        buttonImg_p = [UIImage imageNamed:@"icon_filter_class_p.png"];
        
        [button_search setImage:buttonImg_d forState:UIControlStateNormal];
        [button_search setImage:buttonImg_p forState:UIControlStateHighlighted];
        
        
        [button_search setTitle:@"年级筛选" forState:UIControlStateNormal];
        [button_search setTitle:@"年级筛选" forState:UIControlStateHighlighted];
        
        button_search.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button_search setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [button_search setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button_search setTitleColor:[UIColor colorWithRed:75.0/255.0 green:170.0/255.0 blue:252.0/255.0 alpha:1] forState:UIControlStateHighlighted];
        button_search.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        //button_search.backgroundColor = [UIColor yellowColor];
        
        [button_search addTarget:self action:@selector(gotoFilterView) forControlEvents: UIControlEventTouchUpInside];
        
        // 已毕业button
        button_multiSend = [UIButton buttonWithType:UIButtonTypeCustom];
        button_multiSend.frame = CGRectMake(
                                            button_search.frame.origin.x,
                                            button_search.frame.origin.y + button_search.frame.size.height,
                                            120,
                                            35);
        
        buttonImg_d = [UIImage imageNamed:@"icon_graducate_class_d.png"];
        buttonImg_p = [UIImage imageNamed:@"icon_graducate_class_p.png"];
        
        [button_multiSend setImage:buttonImg_d forState:UIControlStateNormal];
        [button_multiSend setImage:buttonImg_p forState:UIControlStateHighlighted];
        
        [button_multiSend setTitle:@"毕业班级" forState:UIControlStateNormal];
        [button_multiSend setTitle:@"毕业班级" forState:UIControlStateHighlighted];
        
        button_multiSend.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button_multiSend setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [button_multiSend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button_multiSend setTitleColor:[UIColor colorWithRed:75.0/255.0 green:170.0/255.0 blue:252.0/255.0 alpha:1] forState:UIControlStateHighlighted];
        button_multiSend.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        
        [button_multiSend addTarget:self action:@selector(gotoGraduateView) forControlEvents: UIControlEventTouchUpInside];
        
        [imageView_bgMask addSubview:imageView_rightMenu];
        [imageView_bgMask addSubview:button_search];
        [imageView_bgMask addSubview:button_multiSend];
        
        
        [viewMask addSubview:imageView_bgMask];
        
        [self.view addSubview:viewMask];
        
        isRightButtonClicked = true;
    } else {
        
        [viewMask removeFromSuperview];
        
        isRightButtonClicked = false;
        
    }
    
}
//add 2015.09.16
-(void)gotoFilterView{
    
    ClassFilterViewController *classFilterV = [[ClassFilterViewController alloc]init];
    [self.navigationController pushViewController:classFilterV animated:YES];
    
}
//add 2015.09.16
-(void)gotoGraduateView{
    
    GraduateViewController *graduateV = [[GraduateViewController alloc]init];
    graduateV.viewType = _viewType;
    [self.navigationController pushViewController:graduateV animated:YES];
}

//add 2015.09.16
-(void)dismissKeyboard:(id)sender{
    
    [viewMask removeFromSuperview];
    isRightButtonClicked = false;
}

// 返回
-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)reload{
    
    [_tableView reloadData];
}

// 获取数据从服务器
-(void)getData:(NSString*)yeargrade{//2015.09.16
    
    NSLog(@"55555555555");
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Class",@"ac",
                          @"2",@"v",
                          @"getClasses", @"op",
                          yeargrade, @"yeargrade",
                          @"0",@"classtype",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        NSLog(@"88888888");
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
        
    }];
    
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
    
    
    cell.delegate = self;
    cell.currentIndex = indexPath.row;
    
    //老师
    if (([Utilities getUserType] != UserType_Student) && ([Utilities getUserType]!= UserType_Parent)){
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else{//家长
        
       cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    
    NSString* head_url = [[listArray objectAtIndex:indexPath.row] objectForKey:@"pic"];
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"icon_class_avatar_defalt.png"]];
    //NSLog(@"title:%@",[[listArray objectAtIndex:indexPath.row] objectForKey:@"tagname"]);
    cell.titleLabel.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"tagname"];
    //NSLog(@"intro:%@",[[listArray objectAtIndex:indexPath.row] objectForKey:@"intro"]);
    cell.introductionLabel.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"intro"];
    //NSLog(@"joined:%@",[[listArray objectAtIndex:indexPath.row] objectForKey:@"joined"]);
    NSString *joined = [[listArray objectAtIndex:indexPath.row] objectForKey:@"joined"];
    NSString *applied = [[listArray objectAtIndex:indexPath.row] objectForKey:@"applied"];//申请字段

    if ([joined intValue] == 1) {
        cell.isAddedLabel.text = @"已加入";
        cell.isAddedLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        cell.addClassBtn.hidden = YES;
    }else{
        if([applied intValue] == 1){
            if ((UserType_Student != [Utilities getUserType]) &&
                (UserType_Parent != [Utilities getUserType])) {
                cell.isAddedLabel.text = @"申请中";//2015.10.15 春晖确认
            }else {
                cell.isAddedLabel.text = @"";
            }
            cell.isAddedLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
            cell.addClassBtn.hidden = YES;
        }else {
            
            cell.isAddedLabel.text = @"";
            
            if ([@"signup"  isEqual: _viewType]){
                
                cell.addClassBtn.hidden = YES;
                
            }else{
                
                if ([Utilities getUserType] != UserType_Student && [Utilities getUserType]!= UserType_Parent) {
                    
                    cell.addClassBtn.hidden = NO;
                    [cell.addClassBtn setTitleColor:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1] forState:UIControlStateNormal];
                    [cell.addClassBtn setTitleColor:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1] forState:UIControlStateHighlighted];
                    cell.addClassBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
                    [cell.addClassBtn setTitle:@"加入" forState:UIControlStateNormal];
                    [cell.addClassBtn setTitle:@"加入" forState:UIControlStateHighlighted];
                    [cell.addClassBtn setBackgroundImage:[UIImage imageNamed:@"ClassKin/small_btnBg_normal.png"] forState:UIControlStateNormal];
                    [cell.addClassBtn setBackgroundImage:[UIImage imageNamed:@"ClassKin/small_btnBg_press.png"] forState:UIControlStateHighlighted];
                    
                }else{
                    
                    cell.addClassBtn.hidden = YES;
                }
                
            }
           
           
        }
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
      NSLog(@"000000");
    [Utilities dismissProcessingHud:self.view];
     NSLog(@"didSelectRowAtIndexPath");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"deselectRowAtIndexPath");
    
    NSString *classTitle = [[listArray objectAtIndex:indexPath.row] objectForKey:@"tagname"];
    NSString *joined = [[listArray objectAtIndex:indexPath.row] objectForKey:@"joined"];
    NSString *applied = [[listArray objectAtIndex:indexPath.row] objectForKey:@"applied"];

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

        if ((UserType_Student != [Utilities getUserType]) && (UserType_Parent != [Utilities getUserType])) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            //是否确认加入“班级名”？ 取消 加入
#if 0
            //这种方法很多情况下 点击一条会出现莫名的转圈
            NSLog(@"TSPopupItemHandler");
            TSPopupItemHandler handlerTest = ^(NSInteger index, NSString *btnTitle){
                
                // 调用加入班级的接口
                NSLog(@"userInfoDic:%@",_userInfoDic);
                
                NSLog(@"11111111");
                
                if ([btnTitle isEqualToString:@"确定"]) {
                    [Utilities showProcessingHud:self.view];
                    [self doSubmitProfile];//加入班级
                }
              
                
            };
            
            NSArray *itemsArr =
            @[TSItemMake(@"确定", TSItemTypeNormal, handlerTest)];
            NSLog(@"showPopupView");
            [Utilities showPopupView:[NSString stringWithFormat:@"是否确认加入%@?",[dic objectForKey:@"name"]] items:itemsArr];
#endif
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:[NSString stringWithFormat:@"是否确认加入%@?",[dic objectForKey:@"name"]]
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"确定",nil];
            alert.tag = 235;
            [alert show];
            
            
        }
        
        
    }else {
        if ([joined intValue]!=1) {// 未加入
            //classTypeint = 3;
//            // 课表作业都没有
//            ClassMainViewController2 *myClassViewCtrl = [[ClassMainViewController2 alloc] init];
//            myClassViewCtrl.titleName = classTitle;
//            myClassViewCtrl.cId = cId;
//            myClassViewCtrl.joined = joined;
//            myClassViewCtrl.applied = applied;
//            [self.navigationController pushViewController:myClassViewCtrl animated:YES];
            
        }else{
            
//            MyClassDetailViewController *myClassViewCtrl = [[MyClassDetailViewController alloc]init];
//            myClassViewCtrl.titleName = classTitle;
//            myClassViewCtrl.cId = cId;
//            myClassViewCtrl.fromName = @"ClassList";
//            [self.navigationController pushViewController:myClassViewCtrl animated:YES];
            
        }
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    [self dismissKeyboard:nil];
    
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)classAppliedSuccess:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    
    NSString *cid = [dic objectForKey:@"cId"];
    
    // 找到提交申请班级在list中的位置
    int pos = -1;
    for (int i=0; i<[listArray count]; i++) {
        NSDictionary *arrDic = [listArray objectAtIndex:i];
        NSString *arrDicCid = [arrDic objectForKey:@"tagid"];
        
        if (cid == arrDicCid) {
            pos = i;
            break;
        }
    }
    
    // 去list更改applied的值
    if (-1 != pos) {
        NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] initWithDictionary:[listArray objectAtIndex:pos]];
        [mutableDic setValue:@"1" forKey:@"applied"];
        
        [listArray replaceObjectAtIndex:pos withObject:mutableDic];
        
        [_tableView reloadData];
    }
}

#pragma cell代理回调
-(void)addClass:(NSInteger)currentIndex{
    
    //加入班级
    NSDictionary *userInfo = [g_userInfo getUserDetailInfo];
    NSString *usertype = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"role_id"]];
    
        // 现在接口 0 学生 6 家长 7 老师 9 校园管理员 2督学
    
    NSDictionary *dic = [listArray objectAtIndex:currentIndex];
    NSString *titleName = [dic objectForKey:@"name"];
    cId = [dic objectForKey:@"tagid"];
    className = titleName;
    
        if ([usertype intValue] == 9 || [usertype intValue] == 2) {
            
            //调用加入班级接口 加入成功刷新该页
            [self joinClass:cId className:className];
            
        }else{//将老师变为同学生老师一样的权限 2015.05.05
            if ([joinperm intValue] == 0) {// 0 允许任何人加入
                
                //调用加入班级接口 加入成功刷新该页
                [self joinClass:cId className:className];
                
            }else if ([joinperm intValue] == 1){// 1 需消息验证
        
                ApplyAddClassViewController *addClassV = [[ApplyAddClassViewController alloc]init];
                addClassV.cId = cId;
                addClassV.className = titleName;
                [self.navigationController pushViewController:addClassV animated:YES];

            }else if([joinperm intValue] == 2){// 2 只可邀请加入
                
                [Utilities showAlert:@"错误" message:@"本班限制加入，请联系班级管理员" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
                
            }
            
        }
 
}

// 加入班级接口
-(void)joinClass:(NSString*)_cId className:(NSString*)title{
    
    [Utilities showProcessingHud:self.view];
    
    NSLog(@"44444444");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //NSString *result = [FRNetPoolUtils applyAddClass:_cId reason:@""];
        NSDictionary *result = [FRNetPoolUtils addClass:_cId reason:@""];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities dismissProcessingHud:self.view];
            
            if (result) {
                
                NSDictionary *messageInfo = [result objectForKey:@"message"];
                
                if([[result objectForKey:@"result"] integerValue]==1 ){
                    
                    if ([[messageInfo objectForKey:@"cid"] integerValue] == 0) {
                        
                    }else{
                        [self refreshMyClass:title];
                    }
                    
                }else{
                    
                    resultCid = [messageInfo objectForKey:@"cid"];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                   message:[messageInfo objectForKey:@"message"]
                                                                  delegate:self
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil];
                    alert.tag = 230;
                    [alert show];
                    
                }
            }else{
                [Utilities showAlert:@"提示" message:@"网络连接错误，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
            }
            
            
        });
        
    });
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 230) {
        if ([resultCid integerValue]!=0) {
            cId = resultCid;
            [self refreshMyClass:className];
        }
    }else if(alertView.tag == 235){
        
        //done:调用加入班级的接口
        if (buttonIndex  == 1) {
            NSLog(@"userInfoDic:%@",_userInfoDic);
            [Utilities showProcessingHud:self.view];
            [self doSubmitProfile];//加入班级
        }
        
        
    }
}

// 刷新我的班级
-(void)refreshMyClass:(NSString*)name{
    
    NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
    NSString *userType = [NSString stringWithFormat:@"%@",[userDetail objectForKey:@"role_id"]];
    NSLog(@"userType:%@",userType);
    //userType = @"2";//测试代码
    //userType = @"6";//测试代码
    if ([@"classDetail" isEqualToString:_viewType]) {
        
        MyClassListViewController *myClass = [[MyClassListViewController alloc]init];
        myClass.hidesBottomBarWhenPushed = YES;
        UINavigationController *customizationNavi = [[UINavigationController alloc] initWithRootViewController:myClass];
        
        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
        NSMutableArray *array = [NSMutableArray arrayWithArray:appDelegate.tabBarController.viewControllers];
        [array replaceObjectAtIndex:1 withObject:customizationNavi];
        [appDelegate.tabBarController setViewControllers:array];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadMyClassList" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadSchoolMomentsView" object:nil];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0]
                                              animated:YES];
        
    }else{
        
        if([@"7" isEqualToString:userType] || [@"2" isEqualToString:userType] || [@"9" isEqualToString:userType])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadMyClassList" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadSchoolMomentsView" object:nil];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0]
                                                  animated:YES];
        }else
        {
            [userDetail setObject:name forKey:@"role_classname"];
            [userDetail setObject:cId forKey:@"role_cid"];
            
            [[NSUserDefaults standardUserDefaults] setObject:userDetail forKey:@"weixiao_userDetailInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadSchoolMomentsView" object:nil];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0]
                                                  animated:YES];
            MyClassDetailViewController *myClass = [[MyClassDetailViewController alloc]init];
            myClass.fromName = @"tab";
            myClass.cId = cId;
            myClass.hidesBottomBarWhenPushed = YES;
            UINavigationController *customizationNavi = [[UINavigationController alloc] initWithRootViewController:myClass];
            
            MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
            NSMutableArray *array = [NSMutableArray arrayWithArray:appDelegate.tabBarController.viewControllers];
            [array replaceObjectAtIndex:1 withObject:customizationNavi];
            [appDelegate.tabBarController setViewControllers:array];
            
            
        }
        
    }
   
}


-(void)doSubmitProfile{
    
    NSLog(@"22222");
    
    NSDictionary *data;
    NSMutableDictionary *personalInfo = [g_userInfo getUserPersonalInfo];
    NSString *joinClassId = [personalInfo objectForKey:@"cid"];
    NSString *number = [_userInfoDic objectForKey:@"number"];
  
    
    if ([number integerValue] == 0) {
        
        /**
         * 学生无ID加入班级
         * @args
         * v=4 ac=StudentIdBind op=studentJoinHasNoId, sid=, uid=, cid=, sex=  name=真实姓名 joinClassId=要加入的班级
         */
        
        if ([[_userInfoDic objectForKey:@"parent"] integerValue] == 7) {
            
            data = [[NSDictionary alloc] initWithObjectsAndKeys:
                    REQ_URL, @"url",
                    @"StudentIdBind", @"ac",
                    @"4", @"v",
                    @"studentJoinHasNoId", @"op",
                    [_userInfoDic objectForKey:@"name"], @"name",
                    [_userInfoDic objectForKey:@"sex"],@"sex",
                    joinClassId,@"joinClassId",
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
                    [_userInfoDic objectForKey:@"name"], @"name",
                    [_userInfoDic objectForKey:@"sex"],@"sex",
                    [_userInfoDic objectForKey:@"parent"],@"parent",
                    joinClassId,@"joinClassId",
                    nil];
            
        }


        
    }else{//已有学生ID
        
        /**
         * 学生加入班级
         * @args
         *  v=4 ac=StudentIdBind op=student, sid=, uid=, cid=, sex=, name=真实姓名, number=学籍号，无则提交0 joinClassId=要加入的班级
         */
        
        if ([[_userInfoDic objectForKey:@"parent"] integerValue] == 7) {
            
            data = [[NSDictionary alloc] initWithObjectsAndKeys:
                    REQ_URL, @"url",
                    @"StudentIdBind", @"ac",
                    @"4", @"v",
                    @"student", @"op",
                    [_userInfoDic objectForKey:@"name"], @"name",
                    [_userInfoDic objectForKey:@"sex"],@"sex",
                    number,@"number",
                    joinClassId,@"joinClassId",
                    nil];
            
            
        }else{
            
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
                    [_userInfoDic objectForKey:@"name"], @"name",
                    [_userInfoDic objectForKey:@"sex"],@"sex",
                    [_userInfoDic objectForKey:@"parent"],@"parent",
                    number,@"number",
                    joinClassId,@"joinClassId",
                    nil];
            
        }
        
    }
    
    NSLog(@"data:%@",data);
    [[TSNetworking sharedClient] requestWithCustomizeURL:API_URL params:data successBlock:^(TSNetworking *request, id responseObject) {
        
          NSLog(@"33333333");
        [Utilities dismissProcessingHud:self.view];
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        NSLog(@"respDic:%@",respDic);
        
        if([result integerValue] == 1){
            
            if ([[[respDic objectForKey:@"message"] objectForKey:@"joinError"] integerValue] == 1) {
                
                [Utilities showAlert:@"提示" message:[[respDic objectForKey:@"message"] objectForKey:@"alert"] cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
                
            }else{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"zhixiao_myClassAppliedSuccessAndChangeStatus" object:self userInfo:nil];
                
                // 学生和老师在申请完班级后，改变一下真实姓名。
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                dic = [g_userInfo getUserDetailInfo];
                
                NSString *name = [NSString stringWithFormat:@"%@%@", [_userInfoDic objectForKey:@"name"], [personalInfo objectForKey:@"relations"]];
                
                [dic setValue:name forKey:@"name"];
                [dic setObject:joinClassId forKey:@"role_cid"];
                
                
                [g_userInfo setUserDetailInfo:dic];
                
                
                [self performSelector:@selector(backToPreView) withObject:nil afterDelay:0.2];
                
                //if (_flag == 3){//切换子女页的添加新子女
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"zhixiao_refleshSwitchChildView" object:self userInfo:nil];
                
                //}
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_PROFILE object:nil];
            }
            
            
        }else{
            
            [Utilities showTextHud: [respDic objectForKey:@"message"] descView:self.view];
        }
        
        
    }failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
    
    
}

-(void)backToPreView
{
    if (_flag == 1 || _flag == 2) {
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-4] animated:YES];
        
    }else{
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3] animated:YES];
        
    }
    
    
}

@end
