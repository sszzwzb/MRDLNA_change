//
//  SetPersonalViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-12.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "SetPersonalViewController.h"
#import "GrowthNotValidateViewController.h"
#import "PayViewController.h"
#import "MomentsEntranceForTeacherController.h"
#import "SchoolHomeViewController.h"
//#import "ClassHomeViewController.h"
#import "ParksHomeViewController.h"
#import "MyClassDetailViewController.h"
#import "WWSideslipViewController.h"
#import "LeftViewController.h"

@interface SetPersonalViewController (){

    UILabel *publicLable;
    UILabel *classLable;
}

@end

//@synthesize datePicker = _datePicker;

@implementation SetPersonalViewController

extern UINavigationController *navigation_Signup;
extern UINavigationController *navigation_NoUserType;
extern SubUINavigationController *navigation_gotoPersonal;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        network = [NetworkUtility alloc];
        network.delegate = self;
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *schoolType = [[NSUserDefaults standardUserDefaults]objectForKey:@"schoolType"];//add 2015.05.11
    if ([@"growthSpace"  isEqual: _viewType] || [@"classDetail" isEqualToString:_viewType]) {//update by kate 2016.03.03
        [super setCustomizeTitle:@"绑定学生信息"];
    }else {
        if ([@"teacher"  isEqual: _iden]) {
            [super setCustomizeTitle:@"提交审核资料"];
        }else {
            if ([@"bureau" isEqualToString:schoolType]) {//2015.10.30
                [super setCustomizeTitle:@"加入部门申请"];
            }else{
                [super setCustomizeTitle:@"加入班级申请"];
            }
        }
    }
    
    if (![@"fromLogin"  isEqual: _type]) {//add 2015.10.30
        
        [super setCustomizeLeftButton];
        if (![Utilities isConnected]) {//2015.06.30
            UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
            [self.view addSubview:noNetworkV];
            return;
        }
        
    }
    
    
    
    NSDictionary *zsxm = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"真实姓名：", @"name",
                          nil];
    
    NSDictionary *xsxm = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"学生姓名：", @"name",
                          nil];
    
//    NSDictionary *xb = [[NSDictionary alloc]initWithObjectsAndKeys:
//                        @"性别",@"name",
//                        nil];
    
    NSDictionary *szbj;
    if (![@"classApply"  isEqual: _viewType]) {
        
        if ([@"bureau" isEqualToString:schoolType]){
            szbj = [[NSDictionary alloc]initWithObjectsAndKeys:
                    @"所在部门 (可选)",@"name",
                    nil];
        }else{
            szbj = [[NSDictionary alloc]initWithObjectsAndKeys:
                    @"所在班级 (可选)",@"name",
                    nil];
        }
        
        
    }else {
        
        if ([@"bureau" isEqualToString:schoolType]){
            szbj = [[NSDictionary alloc]initWithObjectsAndKeys:
                    @"所在部门",@"name",
                    nil];
        }else{
            szbj = [[NSDictionary alloc]initWithObjectsAndKeys:
                    @"所在班级",@"name",
                    nil];
        }
        
        
    }
    
    
    NSDictionary *xh = [[NSDictionary alloc]initWithObjectsAndKeys:
                        @"身份证号：",@"name",
                        nil];
    
    NSDictionary *yxsgx = [[NSDictionary alloc]initWithObjectsAndKeys:
                           @"与学生关系",@"name",
                           nil];
    
    NSDictionary *xsxh = [[NSDictionary alloc]initWithObjectsAndKeys:
                          @"学生ID：",@"name",
                          nil];
    
    _sectionNameAndSex = [NSArray arrayWithObjects:zsxm, nil];
    _sectionClassAndNumber = [NSArray arrayWithObjects:szbj, xh, nil];
   // _sectionNumber = [NSArray arrayWithObjects:xh, nil];
    _sectionNumber = [NSArray arrayWithObjects:xsxh, nil];
    _sectionClass = [NSArray arrayWithObjects:szbj, nil];
    
    // 注册时候家长身份又tm不要性别了，ctm
    _sectionParentNameAndSex = [NSArray arrayWithObjects:xsxm, yxsgx, nil];
    _sectionParentClassAndNumber = [NSArray arrayWithObjects:szbj, xsxh, nil];
    _sectionParentNumber = [NSArray arrayWithObjects:xsxh, nil];
    
    
    _textField_name = [[UITextField alloc] initWithFrame: CGRectMake(WIDTH/2-20, 0, 205, 40)];
    _textField_name.clearsOnBeginEditing = NO;//鼠标点上时，不清空
    _textField_name.borderStyle = UITextBorderStyleNone;
    _textField_name.backgroundColor = [UIColor clearColor];
    _textField_name.placeholder = @"填写姓名";
    _textField_name.font = [UIFont systemFontOfSize:14.0f];
    _textField_name.textColor = [UIColor blackColor];
    _textField_name.textAlignment = NSTextAlignmentLeft;
    _textField_name.keyboardType=UIKeyboardTypeDefault;
    _textField_name.returnKeyType =UIReturnKeyDone;
    _textField_name.autocorrectionType=UITextAutocorrectionTypeNo;
    _textField_name.tintColor = [UIColor colorWithRed:18.0/255.0 green:65.0/255.0 blue:249.0/255.0 alpha:1];//add by kate 2015.02.28
    _textField_name.autocapitalizationType = UITextAutocapitalizationTypeNone;//add 2015.04.13
    [_textField_name setDelegate: self];
    //    [_textFieldOri performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.01];
    
    
    _textField_number = [[UITextField alloc] initWithFrame: CGRectMake(WIDTH/2-20, 0, 245, 40)];
    _textField_number.clearsOnBeginEditing = NO;//鼠标点上时，不清空
    _textField_number.borderStyle = UITextBorderStyleNone;
    _textField_number.backgroundColor = [UIColor clearColor];
    _textField_number.placeholder = @"填写学生ID";
    _textField_number.font = [UIFont systemFontOfSize:14.0f];
    _textField_number.textColor = [UIColor blackColor];
    _textField_number.textAlignment = NSTextAlignmentLeft;
    _textField_number.keyboardType=UIKeyboardTypeDefault;
    _textField_number.returnKeyType =UIReturnKeyDone;
    _textField_number.autocorrectionType=UITextAutocorrectionTypeNo;
    _textField_number.tintColor = [UIColor colorWithRed:18.0/255.0 green:65.0/255.0 blue:249.0/255.0 alpha:1];//add by kate 2015.02.28
    _textField_number.autocapitalizationType = UITextAutocapitalizationTypeNone;//add 2015.04.13
    [_textField_number setDelegate: self];
    
    
    
    
    
    //    personalInfo = [NSMutableDictionary alloc];
    
    if (![@"fromLogin"  isEqual: _type]) {
        [super setCustomizeLeftButton];
        
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userSettingDetailInfo"];
        if (nil != dic) {
            GlobalSingletonUserInfo* g_userPersonalInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
            [g_userPersonalInfo resetPersonalInfo];
            personalInfo = [g_userPersonalInfo getUserPersonalInfo];
            
            [personalInfo setObject:[dic objectForKey:@"name"] forKey:@"name"];
            [personalInfo setObject:[dic objectForKey:@"role_id"] forKey:@"identity"];
            
            NSString *gender;
            if ([@"1"  isEqual: [dic objectForKey:@"sex"]]) {
                gender = @"男";
            }else {
                gender = @"女";
            }
            [personalInfo setObject:gender forKey:@"gender"];
            [personalInfo setObject:[dic objectForKey:@"birthyear"] forKey:@"birthyear"];
            [personalInfo setObject:[dic objectForKey:@"birthmonth"] forKey:@"birthmonth"];
            [personalInfo setObject:[dic objectForKey:@"birthday"] forKey:@"birthday"];
            //            [personalInfo setObject:[dic objectForKey:@"name"] forKey:@"schoolYear"];
            //            [personalInfo setObject:[dic objectForKey:@"name"] forKey:@"class"];
            //            [personalInfo setObject:[dic objectForKey:@"name"] forKey:@"cid"];
            
            //            [personalInfo setObject:[dic objectForKey:@"name"] forKey:@"number"];
            //            [personalInfo setObject:[dic objectForKey:@"name"] forKey:@"idNumber"];
            //            [personalInfo setObject:[dic objectForKey:@"name"] forKey:@"reason"];
            
            
        }else {
            // 去单例里重置下个人信息
            GlobalSingletonUserInfo* g_userPersonalInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
            [g_userPersonalInfo resetPersonalInfo];
            personalInfo = [g_userPersonalInfo getUserPersonalInfo];
        }
    }else {
        // 去单例里重置下个人信息
        GlobalSingletonUserInfo* g_userPersonalInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
        [g_userPersonalInfo resetPersonalInfo];
        personalInfo = [g_userPersonalInfo getUserPersonalInfo];
    }
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"weixiao_userLoginIsName"];
    [defaults synchronize];
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signupClassSelect:) name:@"Zhixiao_signupClassSelect" object:nil];
    
}

-(void)signupClassSelect:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    
    if (nil != dic) {
        _classInfoDic = dic;
    }
}

-(void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_textField_name];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super hideLeftAndRightLine];
    [MyTabBarController setTabBarHidden:YES];
    [self addFooterButton];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_textField_name];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    if ([@"teacher"  isEqual: _iden]) {
        _itemsArr = [NSMutableArray arrayWithObjects:_sectionNameAndSex, nil];
        
        [tableViewIns reloadData];
    }else if([@"student"  isEqual: _iden]){
        if ([@"growthSpace"  isEqual: _viewType] || [@"classDetail" isEqualToString:_viewType]) {//update by kate 2016.03.03
            // 从成长空间进入，重新绑定学籍号
            _itemsArr = [NSMutableArray arrayWithObjects:_sectionNameAndSex, _sectionNumber, nil];
        }else {
            if (nil != _classInfoDic) {
                NSString *enroll = [_classInfoDic objectForKey:@"enroll"];
                
                // enroll为是否需要填写@"身份证号"的标识
                if (![@"0"  isEqual: enroll]) {
                    _itemsArr = [NSMutableArray arrayWithObjects:_sectionNameAndSex, _sectionClassAndNumber, nil];
                }else {
                    _itemsArr = [NSMutableArray arrayWithObjects:_sectionNameAndSex, _sectionClass, nil];
                }
            }else {
                
#if BUREAU_OF_EDUCATION
                if ([@"chooseIden" isEqualToString:_viewType]) {
                 _itemsArr = [NSMutableArray arrayWithObjects:_sectionNameAndSex, nil];
                }else{
                   _itemsArr = [NSMutableArray arrayWithObjects:_sectionNameAndSex, _sectionClass, nil];
                }
#else
                _itemsArr = [NSMutableArray arrayWithObjects:_sectionNameAndSex, _sectionClass, nil];
                
#endif
          
            }
        }
        
        [tableViewIns reloadData];
    }else if([@"parent"  isEqual: _iden]){
        if ([@"growthSpace"  isEqual: _viewType] || [@"classDetail" isEqualToString:_viewType]) {//update by kate 2016.03.03
            // 从成长空间进入，重新绑定学籍号
            _itemsArr = [NSMutableArray arrayWithObjects:_sectionParentNameAndSex, _sectionParentNumber, nil];
        }else {
            if (nil != _classInfoDic) {
                NSString *enroll = [_classInfoDic objectForKey:@"enroll"];
                
                // enroll为是否需要填写@"身份证号"的标识
                if (![@"0"  isEqual: enroll]) {
                    _itemsArr = [NSMutableArray arrayWithObjects:_sectionParentNameAndSex, _sectionParentClassAndNumber, nil];
                }else {
                    _itemsArr = [NSMutableArray arrayWithObjects:_sectionParentNameAndSex, _sectionClass, nil];
                }
            }else {
                
#if BUREAU_OF_EDUCATION
                
                if ([@"chooseIden" isEqualToString:_viewType]) {
                     _itemsArr = [NSMutableArray arrayWithObjects:_sectionParentNameAndSex, nil];
                }else{
                     _itemsArr = [NSMutableArray arrayWithObjects:_sectionParentNameAndSex, _sectionClass, nil];
                }
               
#else
                _itemsArr = [NSMutableArray arrayWithObjects:_sectionParentNameAndSex, _sectionClass, nil];
#endif
                
            }
        }
        
        [tableViewIns reloadData];
    }
}
- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    tableViewIns = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height) style:UITableViewStyleGrouped];
    tableViewIns.delegate = self;
    tableViewIns.dataSource = self;
    //    tableViewIns.backgroundColor = [UIColor clearColor];
    //    tableViewIns.backgroundView = nil;
    [tableViewIns setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    [self.view addSubview:tableViewIns];
    
    _button_next = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 提前初始化 用户选择老师时候的button
    button_photoMask = [UIButton buttonWithType:UIButtonTypeCustom];
    imgView_bg_photo = [[UIImageView alloc]init];
    label_photo = [[UILabel alloc] init];
    _imgView_photoSelect = [[UIImageView alloc]init];
    _imgView_reason = [[UIImageView alloc]init];
    _label_tips = [[UILabel alloc] init];
    _textView_content = [[UITextView alloc] init];
    
    _isFirstClickComment = false;
    
    _label_comment = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 20)];
    _label_comment.enabled = NO;
    _label_comment.text = @"填写申请说明 (可选)";
    _label_comment.font =  [UIFont systemFontOfSize:16];
    _label_comment.textColor = [UIColor grayColor];
    [_textView_content addSubview:_label_comment];
}

- (void)addFooterButton
{
    _button_next.titleLabel.textAlignment = NSTextAlignmentCenter;
    _button_next.frame = CGRectMake(15, 10, WIDTH-30, 40);
    
    // 设置title自适应对齐
    _button_next.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [_button_next setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button_next setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    _button_next.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    
    [_button_next setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal] ;
    [_button_next setBackgroundImage:[UIImage imageNamed:@"btn_common__1_p.png"] forState:UIControlStateHighlighted] ;
    
    // 添加 action
    [_button_next addTarget:self action:@selector(createNext_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    
    //设置title
    [_button_next setTitle:@"提交申请" forState:UIControlStateNormal];
    [_button_next setTitle:@"提交申请" forState:UIControlStateHighlighted];
    
    UIView *ftView = [[UIView alloc] init];
    
    if ([@"teacher"  isEqual: _iden]) {
        ftView.frame = CGRectMake(0, 0, WIDTH, 1200);
        //        tableViewIns.tableFooterView.frame = CGRectMake(0, 0, 320, 1064);
        
        
        if (iPhone5) {
            imgView_bg_photo.frame = CGRectMake(0,
                                                0,
                                                WIDTH,
                                                120);
        }else {
            if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
            {
                imgView_bg_photo.frame = CGRectMake(0,
                                                    0,
                                                    WIDTH,
                                                    120);
            }else {
                imgView_bg_photo.frame =CGRectMake(0,
                                                   0,
                                                   WIDTH,
                                                   120);
            }
        }
        
        // 理由背景
        imgView_bg_photo.image = [UIImage imageNamed:@"submmit_input2.png"];

        [ftView addSubview:imgView_bg_photo];
        
        // 申请理由输入框
        _textView_content.frame = CGRectMake(imgView_bg_photo.frame.origin.x + 3,
                                             imgView_bg_photo.frame.origin.y + 3,
                                             imgView_bg_photo.frame.size.width - 6,
                                             imgView_bg_photo.frame.size.height - 35);
        
        _textView_content.backgroundColor = [UIColor clearColor];
        _textView_content.scrollEnabled = YES;
        _textView_content.textColor = [UIColor blackColor];
        _textView_content.delegate = self;
        
        //字体大小
        _textView_content.font = [UIFont fontWithName:@"Arial" size:15.0f];
        _textView_content.returnKeyType = UIReturnKeyDone;//返回键的类型
        
        [ftView addSubview:_textView_content];
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//#3.21上传图片背景
        // 图片选择背景
        _imgView_photoSelect.frame = CGRectMake(0,
                                                imgView_bg_photo.frame.origin.y + imgView_bg_photo.frame.size.height+10,
                                                WIDTH,
                                                140);
        _imgView_photoSelect.image = [UIImage imageNamed:@"submmit_input.png"];
        [ftView addSubview:_imgView_photoSelect];
        
        
        
        
        
        
        
        
        
        button_photoMask.frame = CGRectMake(5,
                                            _imgView_photoSelect.frame.origin.y + 55,
                                            82,
                                            82);
        button_photoMask.titleLabel.textAlignment = NSTextAlignmentCenter;
        button_photoMask.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [button_photoMask setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button_photoMask setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        button_photoMask.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        if (nil == photo) {
            [button_photoMask setBackgroundImage:[UIImage imageNamed:@"submimit_select.png"] forState:UIControlStateNormal] ;
            [button_photoMask setBackgroundImage:[UIImage imageNamed:@"submimit_select_p.png"] forState:UIControlStateHighlighted] ;
        } else {
            [button_photoMask setBackgroundImage:photo forState:UIControlStateNormal] ;
            [button_photoMask setBackgroundImage:photo forState:UIControlStateHighlighted] ;
            
        }
        
        [button_photoMask setBackgroundColor:[UIColor clearColor]];
        
        [button_photoMask addTarget:self action:@selector(addPhoto_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        [ftView addSubview:button_photoMask];
        
        label_photo = [[UILabel alloc] initWithFrame:CGRectMake(_imgView_photoSelect.frame.origin.x + 10,
                                                                _imgView_photoSelect.frame.origin.y + 10, 185, 20)];
        
        label_photo.lineBreakMode = NSLineBreakByWordWrapping;
        label_photo.text = @"请上传有效证件 (可选)";
        label_photo.font = [UIFont systemFontOfSize:15.0f];
        label_photo.numberOfLines = 0;
        label_photo.textColor = [UIColor grayColor];
        label_photo.backgroundColor = [UIColor clearColor];
        label_photo.lineBreakMode = NSLineBreakByTruncatingTail;
        [ftView addSubview:label_photo];
        
        _label_tips.frame = CGRectMake(label_photo.frame.origin.x, label_photo.frame.origin.y + label_photo.frame.size.height, label_photo.frame.size.width+20, label_photo.frame.size.height);
        _label_tips.lineBreakMode = NSLineBreakByWordWrapping;
        _label_tips.text = @"教师证、身份证、校方证明等";
        _label_tips.font = [UIFont systemFontOfSize:15.0f];
        _label_tips.numberOfLines = 0;
        _label_tips.textColor = [UIColor grayColor];
        _label_tips.backgroundColor = [UIColor clearColor];
        _label_tips.lineBreakMode = NSLineBreakByTruncatingTail;
        [ftView addSubview:_label_tips];
        
        // 提交button
        _button_next.frame = CGRectMake(20,
                                        _imgView_photoSelect.frame.origin.y + _imgView_photoSelect.frame.size.height +20,
                                        280,
                                        40);
        
    }else if([@"student"  isEqual: _iden]){
        ftView.frame = CGRectMake(0, 0, WIDTH, 104);
    }else if([@"parent"  isEqual: _iden]){
        ftView.frame = CGRectMake(0, 0, WIDTH, 104);
    }
    
    [ftView addSubview:_button_next];
    
    if ((![@"classApply"  isEqual: _viewType]) &&
        (![@"resendTeacherRequest"  isEqual: _viewType]) &&
        (![@"growthSpace"  isEqual: _viewType]) && ![@"classDetail" isEqualToString:_viewType]) {//udpate by kate 2016.03.03
        //切换账号按钮
        btn_changeProfile = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_changeProfile.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-80.0)/2.0, _button_next.frame.origin.y+40+10, 80.0, 40);
        [btn_changeProfile addTarget:self action:@selector(changeProfile:) forControlEvents: UIControlEventTouchUpInside];
        [btn_changeProfile setTitle:@"切换账号" forState:UIControlStateNormal];
        [btn_changeProfile setTitle:@"切换账号" forState:UIControlStateHighlighted];
        btn_changeProfile.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [btn_changeProfile setTitleColor:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1] forState:UIControlStateNormal];
        [btn_changeProfile setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//#3.28  如果从leftVC的重新申请过来的，就不显示切换账号。
        if ([self.perNum isEqualToString:@"1"]) {
            
        }else{
        [ftView addSubview:btn_changeProfile];
    }
    }
    
    tableViewIns.tableFooterView = ftView;
    
    
}

//切换账号
-(void)changeProfile:(id)sender{
    
    UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定退出当前账号进入登录/注册页面吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    alerV.tag = 301;
    [alerV show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 301) {
        if (buttonIndex == 1) {
            NSString *fromNameToHome = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"fromNameToHome"]];
            NSLog(@"fromNameToHome:%@",fromNameToHome);
            MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
            if ([fromNameToHome isEqualToString:@"noUserName_splash"] || [fromNameToHome isEqualToString:@"noUserType"]){
                
                NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"zhixiao_regUid"];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:nil forKey:[NSString stringWithFormat:@"zhixiao_regIdentity_%@", uid]];
                [userDefaults setObject:nil forKey:[NSString stringWithFormat:@"zhixiao_regNamePwd_%@", uid]];
                [userDefaults setObject:nil forKey:[NSString stringWithFormat:@"zhixiao_regStatus_%@", uid]];
                [userDefaults setObject:nil forKey:[NSString stringWithFormat:@"zhixiao_regRealName_%@", uid]];
                [userDefaults setObject:nil forKey:[NSString stringWithFormat:@"zhixiao_regSuccess_%@", uid]];
                [userDefaults synchronize];
                
                
                [appDelegate unbindBaiduPush];//解绑 2015.12.08
                if(appDelegate.window.rootViewController!=appDelegate.splash_viewController){
                    appDelegate.window.rootViewController = appDelegate.splash_viewController;//重置rootview add by kate 2015.10.23
                }
                [appDelegate removeDefaultsInfo];
                [navigation_NoUserType dismissViewControllerAnimated:YES completion:nil];
                [navigation_gotoPersonal dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSplash" object:nil];
            }else{
                [appDelegate unbindBaiduPush];//解绑 2015.12.08
                [navigation_Signup dismissViewControllerAnimated:YES completion:nil];
                
            }
        }
    }
}

// 修改从UIImagePickerController 返回后statusbar消失问题
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    }
}

- (IBAction)addPhoto_btnclick:(id)sender
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = sourceType;
    [self presentModalViewController:picker animated:YES];
}

- (IBAction)createNext_btnclick:(id)sender
{
    NSString *gender = [personalInfo objectForKey:@"gender"];
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
    
    if ([@"teacher"  isEqual: _iden]) {
        //if([NSString stringWithFormat:@"%@", [personalInfo objectForKey:@"name"]].length == 0)
        if(_textField_name.text.length == 0)
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                           message:@"真实姓名不能为空，请重新输入"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            [Utilities showProcessingHud:self.view];
            
#if 0
            [self doApplyActionTeacher];
#else
            
            if (nil == self->imagePath1) {
                self->imagePath1 = @"";
            }
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Apply", @"ac",
                                  @"2", @"v",
                                  @"teacher", @"op",
                                  _textField_name.text, @"realname",
                                  _textView_content.text, @"description",
                                  gender, @"sex",
                                  self->imagePath1, @"idfile",
                                  nil];
            
            [network sendHttpReq:HttpReq_RegisterPersonalTea andData:data];
            self.perNum = @"0";
#endif
        }
    }else {
        if (![@"classApply"  isEqual: _viewType]) {
            if(_textField_name.text.length == 0) {
                if ([@"parent"  isEqual: _iden]) {
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                                   message:@"学生姓名不能为空，请重新输入"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil];
                    [alert show];
                }else {
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                                   message:@"真实姓名不能为空，请重新输入"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil];
                    [alert show];
                }
            }else {
                if ([@"parent"  isEqual: _iden]) {
                    if ([@""  isEqual: [personalInfo objectForKey:@"relationsId"]]) {
                        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                                       message:@"与学生关系不能为空，请重新选择"
                                                                      delegate:nil
                                                             cancelButtonTitle:@"确定"
                                                             otherButtonTitles:nil];
                        [alert show];
                    }else {
                        [Utilities showProcessingHud:self.view];
                        
                        [self doSubmitProfile];
                    }
                }else {
                    [Utilities showProcessingHud:self.view];
                    
                    [self doSubmitProfile];
                }
            }
        }else {
            if(_textField_name.text.length == 0) {
                if ([@"parent"  isEqual: _iden]) {
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                                   message:@"学生姓名不能为空，请重新输入"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil];
                    [alert show];
                }else {
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                                   message:@"真实姓名不能为空，请重新输入"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil];
                    [alert show];
                }
            }else if ([@""  isEqual: [personalInfo objectForKey:@"cid"]]) {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                               message:@"班级不能为空，请重新选择"
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
                [alert show];
            }else {
                if ([@"parent"  isEqual: _iden]) {
                    if ([@""  isEqual: [personalInfo objectForKey:@"relationsId"]]) {
                        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                                       message:@"与学生关系不能为空，请重新选择"
                                                                      delegate:nil
                                                             cancelButtonTitle:@"确定"
                                                             otherButtonTitles:nil];
                        [alert show];
                    }else {
                        [Utilities showProcessingHud:self.view];
                        
                        [self doSubmitProfile];
                    }
                }else {
                    [Utilities showProcessingHud:self.view];
                    
                    [self doSubmitProfile];
                }
            }
        }
    }
     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_PROFILE object:nil];
}



- (void)doSubmitProfile
{
    [_textField_name resignFirstResponder];
    [_textField_number resignFirstResponder];
    [_imgView_reason resignFirstResponder];
    
    BOOL grothSpaceSubmit = YES;
    
    // 成长空间绑定学籍@"身份证号"必填  学生家长申请班级时@"身份证号"必填
    if ([@"growthSpace"  isEqual: _viewType] || [@"classDetail" isEqualToString:_viewType]) {//udpate by kate 2016.03.03
        if ([@""  isEqual: _textField_number.text]) {
            [Utilities dismissProcessingHud:self.view];
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                           message:@"学生ID不能为空，请重新选择"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
            
            grothSpaceSubmit = NO;
        }else {
            grothSpaceSubmit = YES;
        }
    }else {
        if (nil != _classInfoDic) {
            NSString *enroll = [_classInfoDic objectForKey:@"enroll"];
            
            // enroll为是否需要填写@"身份证号"的标识
            if (![@"0"  isEqual: enroll]) {
                // 需要@"身份证号"
                if ([@""  isEqual: _textField_number.text]) {
                    [Utilities dismissProcessingHud:self.view];
                    
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                                   message:@"学生ID不能为空，请重新选择"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil];
                    [alert show];
                    
                    grothSpaceSubmit = NO;
                }else {
                    grothSpaceSubmit = YES;
                }
            }else {
                // 不用@"身份证号"
            }
        }else {
            // 不用@"身份证号"
        }
    }
    
    
    if (grothSpaceSubmit) {
        NSString *gender = [personalInfo objectForKey:@"gender"];
        
        NSDictionary *data;
        
        NSString *cid = @"";
        if ([@"growthSpace"  isEqual: _viewType] || [@"classDetail" isEqualToString:_viewType]) {//update by kate 2016.03.03
            cid = _cId;
        }else {
            cid = [personalInfo objectForKey:@"cid"];
        }
        
        if ([@"student"  isEqual: _iden]) {
            data = [[NSDictionary alloc] initWithObjectsAndKeys:
                    REQ_URL, @"url",
                    @"UserProfile", @"ac",
                    @"2", @"v",
                    @"student", @"op",
                    gender, @"sex",
                    cid, @"cid",
                    _textField_name.text, @"name",
                    _textField_number.text, @"number",
                    nil];
            
        }else if ([@"parent"  isEqual: _iden]) {
            
            data = [[NSDictionary alloc] initWithObjectsAndKeys:
                    REQ_URL, @"url",
                    @"UserProfile", @"ac",
                    @"2", @"v",
                    @"parent", @"op",
                    gender, @"sex",
                    cid, @"cid",
                    [personalInfo objectForKey:@"relationsId"], @"parent",
                    _textField_name.text, @"name",
                    _textField_number.text, @"number",
                    nil];
            
            
        }else if ([@"teacher"  isEqual: _iden]) {
            data = [[NSDictionary alloc] initWithObjectsAndKeys:
                    REQ_URL, @"url",
                    @"UserProfile", @"ac",
                    @"2", @"v",
                    @"parent", @"op",
                    [personalInfo objectForKey:@"cid"], @"cid",
                    [personalInfo objectForKey:@"relationsId"], @"parent",
                    [personalInfo objectForKey:@"name"], @"name",
                    [personalInfo objectForKey:@"number"], @"number",
                    nil];
            
        }
        
        [[TSNetworking sharedClient] requestWithCustomizeURL:API_URL params:data successBlock:^(TSNetworking *request, id responseObject) {
            [Utilities dismissProcessingHud:self.view];
            
            NSDictionary *respDic = (NSDictionary*)responseObject;
            NSString *result = [respDic objectForKey:@"result"];
            
            NSLog(@"respDic:%@",respDic);
            
            if(true == [result intValue]) {
                if ([@"classApply"  isEqual: _viewType]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"zhixiao_myClassAppliedSuccessAndChangeStatus" object:self userInfo:nil];
                    
                    // 学生和老师在申请完班级后，改变一下真实姓名。
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    dic = [g_userInfo getUserDetailInfo];
                    
                    NSString *name = [NSString stringWithFormat:@"%@%@", _textField_name.text, [personalInfo objectForKey:@"relations"]];
                    
                    [dic setValue:name forKey:@"name"];
                    if ([_iden isEqualToString:@"parent"] || [_iden isEqualToString:@"student"]) {
                        [dic setObject:cid forKey:@"role_cid"];
                    }
                    
                    [g_userInfo setUserDetailInfo:dic];
                    
                    
                    [self.view makeToast:[[respDic objectForKey:@"message"] objectForKey:@"alert"]
                                duration:0.8
                                position:@"center"
                                   title:nil];
                    
                    [self performSelector:@selector(backToPreView) withObject:nil afterDelay:0.8];
                    
                }else if ([@"growthSpace"  isEqual: _viewType]) {
                    [ReportObject event:ID_BIND_SPACE_SUCCESSFULLY];
                    
                    // done :如果空间状态为0未开通 直接到空间主页
                    NSString *status = [[respDic objectForKey:@"message"] objectForKey:@"status"];
                    NSString *trial = [NSString stringWithFormat:@"%@",[[respDic objectForKey:@"message"] objectForKey:@"trial"]];
                    
                    if (_publish == 1) {//从动态列表进入或发布页进来
                        
                        //如果已开通 返回
                        [self performSelector:@selector(test) withObject:nil afterDelay:0.5];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadGrowingPathStatus" object:nil];//刷新列表页
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshGrowPathStatus" object:nil];//刷新MomentsDeatilView的空间状态
                        
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadPublishGrowingStatus" object:nil];//刷新发布页的空间状态
                        
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
                            
                            [self.navigationController popViewControllerAnimated:YES];
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
                    
                }else if ([@"classDetail"  isEqual: _viewType]){//add by kate 2016.03.03
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else if ([@"resendTeacherRequest"  isEqual: _viewType]) {
                    NSMutableDictionary *userDetailInfo = [g_userInfo getUserDetailInfo];
                    [userDetailInfo setObject:@"0" forKey:@"role_checked"];
                    [g_userInfo setUserDetailInfo:userDetailInfo];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    // 注册成功，gps上报
                    DataReport *dr = [DataReport sharedGlobalSingletonDataReport];
                    [dr dataReportGPStype:@"DataReport_Act_Regist"];
                    
                    [ReportObject event:ID_FIRST_SET_ACCOUNT];//2015.06.23
                    
                    NSDictionary* message_info = [respDic objectForKey:@"message"];
                    
                    // add by ht 20140915 为了确定是否完成了注册流程，增加userDefaults变量
                    // 保存真实姓名
                    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"zhixiao_regUid"];
                    
                    if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"zhixiao_regNamePwd_%@", uid]] == nil) {
                    
                        NSDictionary *regNamePwd = [[NSDictionary alloc] initWithObjectsAndKeys:[_regNamePwd objectForKey:@"username"], @"username",[_regNamePwd objectForKey:@"password"], @"password", uid, @"uid", nil];
                        [[NSUserDefaults standardUserDefaults] setObject:regNamePwd forKey:[NSString stringWithFormat:@"zhixiao_regNamePwd_%@", uid]];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                    }
                    
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[personalInfo objectForKey:@"name"] forKey:[NSString stringWithFormat:@"zhixiao_regRealName_%@", uid]];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    // 保存注册完毕信息
                    [[NSUserDefaults standardUserDefaults] setObject:@"regSuccess" forKey:[NSString stringWithFormat:@"zhixiao_regSuccess_%@", uid]];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    // 保存是否是注册登录流程
                    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:[NSString stringWithFormat:@"zhixiao_regStatus_%@", uid]];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    // 向userDefaults里面添加该用户的真实名字，为了判断登录的时候进入个人信息完善页面，还是直接登录。
                    NSDictionary *userLoginIsName = [[NSDictionary alloc] initWithObjectsAndKeys:[personalInfo objectForKey:@"name"], @"name", nil];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:userLoginIsName forKey:@"weixiao_userLoginIsName"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    NSString *yeargrade = [personalInfo objectForKey:@"schoolYear"];
                    NSArray  *array= [yeargrade componentsSeparatedByString:@" "];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[array objectAtIndex:0] forKey:@"weixiao_userLoginYearGrade"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [ReportObject event:ID_FIRST_JUMP_AVATAR];//2015.06.23
                    
                    [self getMyProfile];

                    
                    // 登陆成功将单例中的标志设置为1，下次进入app就不会显示guide
                    GlobalSingletonUserInfo* g_userLoginIndex = GlobalSingletonUserInfo.sharedGlobalSingleton;
                    [g_userLoginIndex setLoginIndex:(NSInteger*)1];
                    
                    [self.view makeToast:[[respDic objectForKey:@"message"] objectForKey:@"alert"]
                                duration:0.8
                                position:@"center"
                                   title:nil];
                    
                    [self performSelector:@selector(gotoMain) withObject:nil afterDelay:0.8];
                    
                    //                [self initTabBarController];
                    //                MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
                    //                [self presentViewController:appDelegate.tabBarController animated:YES completion:nil];// add by kate
                    
#if 0
                    SetHeadImgViewController *headImgViewCtrl = [[SetHeadImgViewController alloc] init];
                    
                    [self.navigationController pushViewController:headImgViewCtrl animated:YES];
                    headImgViewCtrl.title = @"设置头像";
#endif
                }
            } else {
                
                NSString* info = [[respDic objectForKey:@"message"] objectForKey:@"alert"];
                
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                               message:info
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
                [alert show];
            }
            
        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
            [Utilities doHandleTSNetworkingErr:error descView:self.view];
        }];
        
    }
}

-(void)backToPreView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)test
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadPublishGrowingStatus" object:nil];
}

-(void) gotoMain
{
    
    [self initTabBarController];
    //-----------------------------------------------------------------------------
    // update 2015.10.21 教育服务发布商品 不能进入相册问题 原因是controller不在window上
    //                        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    //                        [self presentViewController:appDelegate.tabBarController animated:NO completion:nil];
    
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    LeftViewController * leftController = [[LeftViewController alloc] init];
    WWSideslipViewController * wwsideslioController = [[WWSideslipViewController alloc] initWithLeftView:leftController andMainView:appDelegate.tabBarController andBackgroundImage:[UIImage imageNamed:@""]];
    appDelegate.window.rootViewController = wwsideslioController;
    
    //-------------------------------------------------------------------------------
}


#pragma Delegate method UIImagePickerControllerDelegate
//图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    //当图片不为空时显示图片并保存图片
    if (image != nil) {
        //        image_head_pre = image;
        UIImage *scaledImage;
        UIImage *updateImage;
        
        CGSize imageSize = image.size;
        
        // 如果宽度超过800，则按照比例进行缩放，把宽度固定在800
        if (image.size.width >= 800) {
            float scaleRate = 800/image.size.width;
            
            float w = 800;
            float h = image.size.height * scaleRate;
            
            scaledImage = [Utilities imageWithImageSimple:image scaledToSize:CGSizeMake(w, h)];
        }
        
        if (scaledImage != Nil) {
            updateImage = scaledImage;
        } else {
            updateImage = image;
        }
        
        CGSize imageSize1 = updateImage.size;
        
        photo = updateImage;
        
        //        [button_photoMask setBackgroundImage:image forState:UIControlStateNormal] ;
        //        [button_photoMask setBackgroundImage:image forState:UIControlStateHighlighted] ;
        
        //获取Documents文件夹目录
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [path objectAtIndex:0];
        //指定新建文件夹路径
        NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"ImageFile"];
        //创建ImageFile文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
        //保存图片的路径
        self->imagePath1 = [imageDocPath stringByAppendingPathComponent:@"image.png"];
        
        //以下是保存文件到沙盒路径下
        //把图片转成NSData类型的数据来保存文件
        NSData *data;
        //判断图片是不是png格式的文件
        //        if (UIImagePNGRepresentation(updateImage)) {
        //            //返回为png图像。
        //            data = UIImagePNGRepresentation(updateImage);
        //        }else {
        //返回为JPEG图像。
        data = UIImageJPEGRepresentation(updateImage, 0.3);
        //       }
        //保存
        [[NSFileManager defaultManager] createFileAtPath:self->imagePath1 contents:data attributes:nil];
        
        //        [self doUpdateAvatar];
    }
    //关闭相册界面
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_itemsArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)[_itemsArr objectAtIndex:section] count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    
    if ([@"teacher"  isEqual: _iden]) {
        if (iPhone5)
        {
            tableViewIns.contentSize = CGSizeMake(WIDTH, 568);
        }else {
            if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
            {
                tableViewIns.contentSize = CGSizeMake(WIDTH, 598);
            }else {
                tableViewIns.contentSize = CGSizeMake(WIDTH, 518);
            }
        }
    }else {
        if (iPhone5)
        {
            tableViewIns.contentSize = CGSizeMake([UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height);
        }else {
            if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
            {
                tableViewIns.contentSize = CGSizeMake([UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height);
            }else {
                tableViewIns.contentSize = CGSizeMake(WIDTH, 548);
            }
        }
    }
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
    NSDictionary *dic = [[_itemsArr objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = [dic objectForKey:@"name"];
    cell.textLabel.textColor = [UIColor grayColor];
    
    //    cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
    
    if (([@"真实姓名："  isEqual: [dic objectForKey:@"name"]]) || [@"学生姓名："  isEqual: [dic objectForKey:@"name"]]) {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //        cell.detailTextLabel.text = [personalInfo objectForKey:@"name"];
        
        [cell.contentView addSubview: _textField_name];
        
    }
//    else if ([@"性别"  isEqual: [dic objectForKey:@"name"]]) {
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//        
//        NSString *gender = [personalInfo objectForKey:@"gender"];
//        if ([@"2" isEqual:gender]) {//2是女
//            gender = @"女";
//        } else {
//            gender = @"男";
//        }
//        [publicLable removeFromSuperview];
//        [cell.contentView addSubview:[self publicLable:gender]];
//        [publicLable mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(cell.contentView.mas_top).with.offset(0);
//            make.left.equalTo(cell.contentView.mas_left).with.offset(WIDTH/2-20);
//            make.size.mas_equalTo(CGSizeMake(60,40));
//        }];
//        [cell.detailTextLabel setTextAlignment:NSTextAlignmentLeft];
//        cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
//    }
    else if (([@"所在班级 (可选)"  isEqual: [dic objectForKey:@"name"]]) || [@"所在班级"  isEqual: [dic objectForKey:@"name"]] || ([@"所在部门 (可选)"  isEqual: [dic objectForKey:@"name"]]) || [@"所在部门"  isEqual: [dic objectForKey:@"name"]]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        [classLable removeFromSuperview];
        [cell.contentView addSubview:[self classLable:[personalInfo objectForKey:@"class"]]];
        [classLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top).with.offset(0);
            make.left.equalTo(cell.contentView.mas_left).with.offset(WIDTH/2-20);
            make.size.mas_equalTo(CGSizeMake(100,40));
        }];
    }else if ([@"身份证号："  isEqual: [dic objectForKey:@"name"]]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.contentView addSubview: _textField_number];
        
        cell.detailTextLabel.text = [personalInfo objectForKey:@"number"];
    }else if ([@"学生ID："  isEqual: [dic objectForKey:@"name"]]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.contentView addSubview: _textField_number];
        
        _textField_number.frame = CGRectMake(WIDTH/2-20, 1, 215, 40);
        cell.detailTextLabel.text = [personalInfo objectForKey:@"number"];
    }else if ([@"与学生关系"  isEqual: [dic objectForKey:@"name"]]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        [publicLable removeFromSuperview];
        [cell.contentView addSubview:[self publicLable:[personalInfo objectForKey:@"relations"]]];
        [publicLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top).with.offset(0);
            make.left.equalTo(cell.contentView.mas_left).with.offset(WIDTH/2-20);
            make.size.mas_equalTo(CGSizeMake(60,40));
        }];
    }
    
    
#if 0
    if ([@"teacher"  isEqual: _iden]) {
        if (0 == [indexPath section] && 0 == [indexPath row]) {
            cell.textLabel.text = @"真实姓名 (必填)";
            cell.detailTextLabel.text = [personalInfo objectForKey:@"name"];
        }else if (0 == [indexPath section] && 1 == [indexPath row]){
            cell.textLabel.text = @"性别";
            cell.detailTextLabel.text = [personalInfo objectForKey:@"gender"];
        }else if (1 == [indexPath section] && 0 == [indexPath row]){
            cell.textLabel.text = @"申请说明(必填)";
            cell.detailTextLabel.text = [personalInfo objectForKey:@"reason"];
        }
    }else {
        if (0 == [indexPath section] && 0 == [indexPath row]) {
            cell.textLabel.text = @"真实姓名 (必填)";
            cell.detailTextLabel.text = [personalInfo objectForKey:@"name"];
        }else if (0 == [indexPath section] && 1 == [indexPath row]){
            cell.textLabel.text = @"性别";
            cell.detailTextLabel.text = [personalInfo objectForKey:@"gender"];
        }else if (1 == [indexPath section] && 0 == [indexPath row]){
            cell.textLabel.text = @"身份证号";
            cell.detailTextLabel.text = [personalInfo objectForKey:@"number"];
        }
    }
#endif
    
    
    //设置textLabel的背景色为空
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}
//4.11
-(UILabel*)publicLable:(NSString*)str1{
    publicLable = [UILabel new];
    publicLable.text = str1;
    publicLable.textAlignment = NSTextAlignmentLeft;
    publicLable.font=[UIFont systemFontOfSize:14.0];
    return publicLable;
}
-(UILabel*)classLable:(NSString*)str1{
    classLable = [UILabel new];
    classLable.text = str1;
    classLable.textAlignment = NSTextAlignmentLeft;
    classLable.font=[UIFont systemFontOfSize:14.0];
    return classLable;
}
//选中Cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    [_textField_name resignFirstResponder];
    [_textField_number resignFirstResponder];
    [_imgView_reason resignFirstResponder];
    
    NSDictionary *dic = [[_itemsArr objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    
    if ([@"真实姓名 (必填):"  isEqual: [dic objectForKey:@"name"]]) {
        //        NameViewController *nameViewCtrl = [[NameViewController alloc] init];
        //        [self.navigationController pushViewController:nameViewCtrl animated:YES];
    }else if ([@"性别"  isEqual: [dic objectForKey:@"name"]]) {
        GenderViewController *genderViewCtrl = [[GenderViewController alloc] init];
        [self.navigationController pushViewController:genderViewCtrl animated:YES];
    }else if ([@"与学生关系"  isEqual: [dic objectForKey:@"name"]]) {
        SetRelationsViewController *relations = [[SetRelationsViewController alloc] init];
        [self.navigationController pushViewController:relations animated:YES];
    }else if (([@"所在班级 (可选)"  isEqual: [dic objectForKey:@"name"]]) || ([@"所在班级"  isEqual: [dic objectForKey:@"name"]]) || ([@"所在部门"  isEqual: [dic objectForKey:@"name"]]) || ([@"所在部门 (可选)"  isEqual: [dic objectForKey:@"name"]])) {
        ClassListViewController *class = [[ClassListViewController alloc] init];
        class.viewType = @"signup";
        [self.navigationController pushViewController:class animated:YES];
    }else if ([@"身份证号"  isEqual: [dic objectForKey:@"name"]] || [@"学生ID"  isEqual: [dic objectForKey:@"name"]]) {
        NameViewController *nameViewCtrl = [[NameViewController alloc] init];
        nameViewCtrl.viewType = @"classNum";
        [self.navigationController pushViewController:nameViewCtrl animated:YES];
    }
}

#if 9
#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    [Utilities dismissProcessingHud:self.view];
    
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if ([@"ProfileAction.setup"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
        if(true == [result intValue])
        {
            NSDictionary* message_info = [resultJSON objectForKey:@"message"];
            
            // 注册成功，gps上报
            DataReport *dr = [DataReport sharedGlobalSingletonDataReport];
            [dr dataReportGPStype:@"DataReport_Act_Regist"];
            
            //完善个人信息
            [ReportObject event:ID_FIRST_SET_ACCOUNT];//2015.06.23
            
            /*NSDictionary *regNamePwd = [[NSDictionary alloc] initWithObjectsAndKeys:username, @"username", _textFieldNew.text, @"password", uid, @"uid", nil];
            
            [[NSUserDefaults standardUserDefaults] setObject:regNamePwd forKey:[NSString stringWithFormat:@"zhixiao_regNamePwd_%@", uid]];
            [[NSUserDefaults standardUserDefaults] synchronize];*/
            
            // add by ht 20140915 为了确定是否完成了注册流程，增加userDefaults变量
            // 保存真实姓名
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"zhixiao_regUid"];
            
            
                [[NSUserDefaults standardUserDefaults] setObject:[personalInfo objectForKey:@"name"] forKey:[NSString stringWithFormat:@"zhixiao_regRealName_%@", uid]];
                [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            // 保存注册完毕信息
            [[NSUserDefaults standardUserDefaults] setObject:@"regSuccess" forKey:[NSString stringWithFormat:@"zhixiao_regSuccess_%@", uid]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 保存是否是注册登录流程
            [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:[NSString stringWithFormat:@"zhixiao_regStatus_%@", uid]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 向userDefaults里面添加该用户的真实名字，为了判断登录的时候进入个人信息完善页面，还是直接登录。
            NSDictionary *userLoginIsName = [[NSDictionary alloc] initWithObjectsAndKeys:[personalInfo objectForKey:@"name"], @"name", nil];
            
            [[NSUserDefaults standardUserDefaults] setObject:userLoginIsName forKey:@"weixiao_userLoginIsName"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString *yeargrade = [personalInfo objectForKey:@"schoolYear"];
            NSArray  *array= [yeargrade componentsSeparatedByString:@" "];
            
            [[NSUserDefaults standardUserDefaults] setObject:[array objectAtIndex:0] forKey:@"weixiao_userLoginYearGrade"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [_textField_name resignFirstResponder];
            [_textField_number resignFirstResponder];
            [_imgView_reason resignFirstResponder];
            
            SetHeadImgViewController *headImgViewCtrl = [[SetHeadImgViewController alloc] init];
            
            [self.navigationController pushViewController:headImgViewCtrl animated:YES];
            headImgViewCtrl.title = @"设置头像";
        }
        else
        {
            
            //NSLog(@"result:%@",[resultJSON objectForKey:@"message"]);
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:[NSString stringWithFormat:@"%@",[resultJSON objectForKey:@"message"]]
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }else if ([@"ApplyAction.teacher"  isEqual: [resultJSON objectForKey:@"protocol"]]){
        if(true == [result intValue])
        {
            if ([@"resendTeacherRequest"  isEqual: _viewType]) {
                NSMutableDictionary *userDetailInfo = [g_userInfo getUserDetailInfo];
                [userDetailInfo setObject:@"0" forKey:@"role_checked"];
                [g_userInfo setUserDetailInfo:userDetailInfo];
                
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                // 注册成功，gps上报
                DataReport *dr = [DataReport sharedGlobalSingletonDataReport];
                [dr dataReportGPStype:@"DataReport_Act_Regist"];
                
                //完善个人资料
                [ReportObject event:ID_FIRST_SET_ACCOUNT];//2015.06.23
                
                NSDictionary* message_info = [resultJSON objectForKey:@"message"];
                
                // add by ht 20140915 为了确定是否完成了注册流程，增加userDefaults变量
                // 保存真实姓名
                NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"zhixiao_regUid"];
                
                if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"zhixiao_regNamePwd_%@", uid]] == nil) {
                    
                    NSDictionary *regNamePwd = [[NSDictionary alloc] initWithObjectsAndKeys:[_regNamePwd objectForKey:@"username"], @"username",[_regNamePwd objectForKey:@"password"], @"password", uid, @"uid", nil];
                    [[NSUserDefaults standardUserDefaults] setObject:regNamePwd forKey:[NSString stringWithFormat:@"zhixiao_regNamePwd_%@", uid]];
                    [[NSUserDefaults standardUserDefaults] synchronize];

                }
                
                [[NSUserDefaults standardUserDefaults] setObject:[personalInfo objectForKey:@"name"] forKey:[NSString stringWithFormat:@"zhixiao_regRealName_%@", uid]];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // 保存注册完毕信息
                [[NSUserDefaults standardUserDefaults] setObject:@"regSuccess" forKey:[NSString stringWithFormat:@"zhixiao_regSuccess_%@", uid]];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // 保存是否是注册登录流程
                [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:[NSString stringWithFormat:@"zhixiao_regStatus_%@", uid]];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // 向userDefaults里面添加该用户的真实名字，为了判断登录的时候进入个人信息完善页面，还是直接登录。
                NSDictionary *userLoginIsName = [[NSDictionary alloc] initWithObjectsAndKeys:[personalInfo objectForKey:@"name"], @"name", nil];
                
                [[NSUserDefaults standardUserDefaults] setObject:userLoginIsName forKey:@"weixiao_userLoginIsName"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSString *yeargrade = [personalInfo objectForKey:@"schoolYear"];
                NSArray  *array= [yeargrade componentsSeparatedByString:@" "];
                
                [[NSUserDefaults standardUserDefaults] setObject:[array objectAtIndex:0] forKey:@"weixiao_userLoginYearGrade"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self getMyProfile];
                
                
                [self initTabBarController];
                //-----------------------------------------------------------------------------
                // update 2015.10.21 教育服务发布商品 不能进入相册问题 原因是controller不在window上
                //                        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
                //                        [self presentViewController:appDelegate.tabBarController animated:NO completion:nil];
                
                [_textField_name resignFirstResponder];
                [_textField_number resignFirstResponder];
                [_imgView_reason resignFirstResponder];
                
                MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
                LeftViewController * leftController = [[LeftViewController alloc] init];
                WWSideslipViewController * wwsideslioController = [[WWSideslipViewController alloc] initWithLeftView:leftController andMainView:appDelegate.tabBarController andBackgroundImage:[UIImage imageNamed:@""]];
                appDelegate.window.rootViewController = wwsideslioController;
                
                //-------------------------------------------------------------------------------
                
#if 0
                SetHeadImgViewController *headImgViewCtrl = [[SetHeadImgViewController alloc] init];
                
                [self.navigationController pushViewController:headImgViewCtrl animated:YES];
                headImgViewCtrl.title = @"设置头像";
#endif
            }
        }
        else
        {
            NSString* info = [resultJSON objectForKey:@"message"];
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:info
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void)getMyProfile{
    NSString *uid= [Utilities getUniqueUid];
    
    if (uid) {
        // 登录成功后去服务器获取个人详细信息
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Profile", @"ac",
                              @"2", @"v",
                              @"view", @"op",
                              nil];
        
        [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
            [Utilities dismissProcessingHud:self.view];
            
            NSDictionary *respDic = (NSDictionary*)responseObject;
            NSString *result = [respDic objectForKey:@"result"];
            NSDictionary *msg = [respDic objectForKey:@"message"];
            
            if(true == [result intValue]) {
                NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithDictionary:[msg objectForKey:@"profile"]];
                
                NSDictionary *vip = [msg objectForKey:@"vip"];
                [infoDic setValue:[Utilities replaceNull:[vip objectForKey:@"opened"]] forKey:@"vip_opened"];
                [infoDic setValue:[Utilities replaceNull:[vip objectForKey:@"schoolEnabled"]] forKey:@"vip_schoolEnabled"];
                
                [Utilities doSaveUserInfoToDefaultAndSingle:infoDic andRole:[msg objectForKey:@"role"]];

//                [Utilities doSaveUserInfoToDefaultAndSingle:[msg objectForKey:@"profile"] andRole:[msg objectForKey:@"role"]];
                } else {
            }
            
        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
            [Utilities doHandleTSNetworkingErr:error descView:self.view];
        }];
    }
}

-(void)reciveHttpDataError:(NSError*)err
{
    [Utilities dismissProcessingHud:self.view];
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                   message:@"网络连接错误，请稍候再试"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    [alert show];
}
#endif

//// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return NO;
}
////
//// 是否支持横竖屏显示
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}




- (void)doProfileActionSetup
{
    NSString *gender = [personalInfo objectForKey:@"gender"];
    if ([@"男" isEqual:gender]) {
        gender = @"1";
    } else {
        gender = @"2";
    }
    
    NSString *role;
    if ([@"student"  isEqual: _iden]) {
        role = @"0";
    }else if ([@"parent"  isEqual: _iden]) {
        role = @"6";
    }
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Profile", @"ac",
                          @"2", @"v",
                          @"setup", @"op",
                          gender, @"sex",
                          role, @"role",
                          [personalInfo objectForKey:@"name"], @"name",
                          [personalInfo objectForKey:@"birthyear"], @"birthyear",
                          [personalInfo objectForKey:@"birthmonth"], @"birthmonth",
                          [personalInfo objectForKey:@"birthday"], @"birthday",
                          [personalInfo objectForKey:@"number"], @"studentid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            NSDictionary* message_info = [respDic objectForKey:@"message"];
            
            // 注册成功，gps上报
            DataReport *dr = [DataReport sharedGlobalSingletonDataReport];
            [dr dataReportGPStype:@"DataReport_Act_Regist"];
            
            //完善个人资料
            [ReportObject event:ID_FIRST_SET_ACCOUNT];//2015.06.23
            
            // add by ht 20140915 为了确定是否完成了注册流程，增加userDefaults变量
            // 保存真实姓名
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"zhixiao_regUid"];
            [[NSUserDefaults standardUserDefaults] setObject:[personalInfo objectForKey:@"name"] forKey:[NSString stringWithFormat:@"zhixiao_regRealName_%@", uid]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 保存注册完毕信息
            [[NSUserDefaults standardUserDefaults] setObject:@"regSuccess" forKey:[NSString stringWithFormat:@"zhixiao_regSuccess_%@", uid]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 保存是否是注册登录流程
            [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:[NSString stringWithFormat:@"zhixiao_regStatus_%@", uid]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 向userDefaults里面添加该用户的真实名字，为了判断登录的时候进入个人信息完善页面，还是直接登录。
            NSDictionary *userLoginIsName = [[NSDictionary alloc] initWithObjectsAndKeys:[personalInfo objectForKey:@"name"], @"name", nil];
            
            [[NSUserDefaults standardUserDefaults] setObject:userLoginIsName forKey:@"weixiao_userLoginIsName"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString *yeargrade = [personalInfo objectForKey:@"schoolYear"];
            NSArray  *array= [yeargrade componentsSeparatedByString:@" "];
            
            [[NSUserDefaults standardUserDefaults] setObject:[array objectAtIndex:0] forKey:@"weixiao_userLoginYearGrade"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            SetHeadImgViewController *headImgViewCtrl = [[SetHeadImgViewController alloc] init];
            
            [self.navigationController pushViewController:headImgViewCtrl animated:YES];
            headImgViewCtrl.title = @"设置头像";
        } else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:[NSString stringWithFormat:@"%@",[respDic objectForKey:@"message"]]
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
}

- (void)doApplyActionTeacher
{
    NSString *gender = [personalInfo objectForKey:@"gender"];
    if ([@"男" isEqual:gender]) {
        gender = @"1";
    } else {
        gender = @"2";
    }
    
    NSArray *fileArray;
    
    if (nil == self->imagePath1) {
    }else {
        NSDictionary *fileDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 self->imagePath1, @"idfile",
                                 nil];
        fileArray = [NSArray arrayWithObjects:fileDic, nil];
    }
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Apply", @"ac",
                          @"2", @"v",
                          @"teacher", @"op",
                          [personalInfo objectForKey:@"name"], @"realname",
                          [personalInfo objectForKey:@"idNumber"], @"idnumber",
                          [personalInfo objectForKey:@"reason"], @"description",
                          gender, @"sex",
                          [personalInfo objectForKey:@"birthyear"], @"birthyear",
                          [personalInfo objectForKey:@"birthmonth"], @"birthmonth",
                          [personalInfo objectForKey:@"birthday"], @"birthday",
                          fileArray, @"files",
                          nil];
    
    [[TSNetworking sharedClient] requestWithCustomizeURL:API_URL params:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            // 注册成功，gps上报
            DataReport *dr = [DataReport sharedGlobalSingletonDataReport];
            [dr dataReportGPStype:@"DataReport_Act_Regist"];
            
            [ReportObject event:ID_FIRST_SET_ACCOUNT];//2015.06.23
            
            NSDictionary* message_info = [respDic objectForKey:@"message"];
            
            // add by ht 20140915 为了确定是否完成了注册流程，增加userDefaults变量
            // 保存真实姓名
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"zhixiao_regUid"];
            [[NSUserDefaults standardUserDefaults] setObject:[personalInfo objectForKey:@"name"] forKey:[NSString stringWithFormat:@"zhixiao_regRealName_%@", uid]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 保存注册完毕信息
            [[NSUserDefaults standardUserDefaults] setObject:@"regSuccess" forKey:[NSString stringWithFormat:@"zhixiao_regSuccess_%@", uid]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 保存是否是注册登录流程
            [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:[NSString stringWithFormat:@"zhixiao_regStatus_%@", uid]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 向userDefaults里面添加该用户的真实名字，为了判断登录的时候进入个人信息完善页面，还是直接登录。
            NSDictionary *userLoginIsName = [[NSDictionary alloc] initWithObjectsAndKeys:[personalInfo objectForKey:@"name"], @"name", nil];
            
            [[NSUserDefaults standardUserDefaults] setObject:userLoginIsName forKey:@"weixiao_userLoginIsName"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString *yeargrade = [personalInfo objectForKey:@"schoolYear"];
            NSArray  *array= [yeargrade componentsSeparatedByString:@" "];
            
            [[NSUserDefaults standardUserDefaults] setObject:[array objectAtIndex:0] forKey:@"weixiao_userLoginYearGrade"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            SetHeadImgViewController *headImgViewCtrl = [[SetHeadImgViewController alloc] init];
            
            [self.navigationController pushViewController:headImgViewCtrl animated:YES];
            headImgViewCtrl.title = @"设置头像";
        } else {
            NSString* info = [respDic objectForKey:@"message"];
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:info
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
}

- (void)initTabBarController
{
#if 9
    [UIApplication sharedApplication].statusBarHidden = NO;
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (!appDelegate.tabBarController) {
        
        [appDelegate bindBaiduPush];//只有在进入主页后收到推送才显示 志伟确认 2015.12.09
        // 校园
        SchoolHomeViewController *schoolV = [[SchoolHomeViewController alloc] init];

        NSString *cid = @"0";
        
        MyClassDetailViewController *classDetailV = [[MyClassDetailViewController alloc] init];
        classDetailV.fromName = @"tab";
        
        MyClassListViewController *classV = [[MyClassListViewController alloc] init];

        ParksHomeViewController *parkV = [[ParksHomeViewController alloc]init];
               
        //隐藏tabbar所留下的黑边（试着注释后你会知道这个的作用）
        schoolV.hidesBottomBarWhenPushed = YES;
        classDetailV.hidesBottomBarWhenPushed = YES;
        classV.hidesBottomBarWhenPushed = YES;
        schoolV.title = @"校园";
        classDetailV.title = @"班级";
        parkV.title = @"乐园";
        
        UINavigationController *schoolNavi = [[UINavigationController alloc] initWithRootViewController:schoolV];
        
        UINavigationController *customizationNavi = [[UINavigationController alloc] initWithRootViewController:classV];
        classDetailV.cId = cid;
        
        UINavigationController *ParkNavi = [[UINavigationController alloc]initWithRootViewController:parkV];
        
        //NSString *usertype = _iden;
    
        NSArray *controllers;
       
        controllers = [NSArray arrayWithObjects:schoolNavi, customizationNavi,ParkNavi, nil];
      
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
    
#endif
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < 50) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = 50 - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            //            label_leftNum.text = [NSString stringWithFormat:@"%d/%ld",0,(long)50];
        }
        return NO;
    }
    
}

#if 9
- (void)textViewDidChange:(UITextView *)textView
{
    if ([_textView_content.text length] == 0) {
        [_label_comment setHidden:NO];
    }else{
        [_label_comment setHidden:YES];
    }
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > 50)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:50];
        
        [textView setText:s];
    }
    
    //不让显示负数 口口日
    //    label_leftNum.text = [NSString stringWithFormat:@"剩余%ld",MAX(0,50 - existTextNum)];
}
#endif

#if 0
- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         
                         //                         CGSize frame = tableViewIns.contentSize;
                         //                         CGRect a = tableViewIns.frame;
                         
                         tableViewIns.contentSize
                         
                         if (iPhone4) {
                             a.size.height += 60;
                         }
                         //                         frame.height -= keyboardRect.size.height;
                         //                         tableViewIns.contentSize = frame;
                         
                         
                         tableViewIns.frame = a;
                         
                         //                         keyboardHeight = keyboardRect.size.height;
                     }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         //                         CGSize frame = tableViewIns.contentSize;
                         CGRect a = tableViewIns.frame;
                         
                         if (iPhone4) {
                             //                             frame.height -= 60;
                             a.size.height += 60;
                             
                         }
                         
                         //                         tableViewIns.contentSize = frame;
                         tableViewIns.frame = a;
                         
                         //                         keyboardHeight = keyboardRect.size.height;
                         //
                         //                         keyboardHeight = 0;
                     }];
}
#endif

#if 0
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //键盘高度216
    
    //滑动效果（动画）
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
    self.view.frame = CGRectMake(0.0f, -100.0f, self.view.frame.size.width, self.view.frame.size.height);//64-216
    
    [UIView commitAnimations];
}

#pragma mark -屏幕恢复
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //滑动效果
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //恢复屏幕
    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);//64-216
    
    [UIView commitAnimations];
}
#endif




- (void)keyboardWillShow:(NSNotification *)notification {
    // 键盘弹出时，清空输入框，之后可以优化为为每一条记录之前输入的内容，类似微信。
    //    textView.text = @"";
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         
                         CGRect frame = tableViewIns.frame;
                         frame.size.height += keyboardHeight;
                         frame.size.height -= keyboardRect.size.height;
                         tableViewIns.frame = frame;
                         
                         
                         //                         frame = toolBar.frame;
                         //                         frame.origin.y += keyboardHeight;
                         //                         frame.origin.y -= keyboardRect.size.height;
                         //                         toolBar.frame = frame;
                         
                         keyboardHeight = keyboardRect.size.height;
                     }];
    
    [tableViewIns setContentOffset:CGPointMake(0.0, 60) animated:NO];  //隐藏搜索栏
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    //    toolBar.hidden = YES;
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGRect frame = tableViewIns.frame;
                         frame.size.height += keyboardHeight;
                         tableViewIns.frame = frame;
                         
                         //                         frame = toolBar.frame;
                         //                         frame.origin.y += keyboardHeight;
                         //                         toolBar.frame = frame;
                         
                         keyboardHeight = 0;
                     }];
}

#if 0
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _textField_number){
        // @"身份证号"
        //这里默认是最多输入50位
        if (range.location >= 50)
        {
            NSString *input = string;
            if ([input  isEqual: @""]) {
                return YES;
            }
            return NO;
        }
    }else if (textField == _textField_name) {
        // 真实姓名
        //这里默认是最多输入8位
        if (range.location >= 8)
        {
            NSString *input = string;
            if ([input  isEqual: @""]) {
                return YES;
            }
            return NO;
        }
    }
    
    return YES;
}
#endif


-(void)textFiledEditChanged:(NSNotification *)obj{
    
    NSString *viewName = [[NSUserDefaults standardUserDefaults] objectForKey:@"viewName"];
    
    
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

@end
