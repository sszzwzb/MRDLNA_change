//
//  WhoCanViewController.m
//  MicroSchool
//
//  Created by Kate on 15-1-13.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "WhoCanViewController.h"
#import "ChooseClassViewController.h"
#import "FRNetPoolUtils.h"

@interface WhoCanViewController ()
@property (strong, nonatomic) IBOutlet UILabel *TitleLabel1;
@property (strong, nonatomic) IBOutlet UILabel *TitleLabel2;
@property (strong, nonatomic) IBOutlet UILabel *TitleLabel3;
@property (strong, nonatomic) IBOutlet UIImageView *selectImg1;
@property (strong, nonatomic) IBOutlet UIImageView *selectImg2;
@property (strong, nonatomic) IBOutlet UIImageView *selectImg3;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;
- (IBAction)didSelectAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UIButton *classBtn;
@property (strong, nonatomic) IBOutlet UIView *secLineV;
@property (strong, nonatomic) IBOutlet UIImageView *bgImgV;

@end

extern NSString *privilege;//权限
NSString *privilegeFromMyM;
@implementation WhoCanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@"谁可以看"];
     self.view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
    
    [super setCustomizeRightButtonWithName:@"保存"];
    
    // 谁可以看 学生/家长改成两项 其他依然三项 tony确认 2015.12.29
    NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
    NSString *userType = [NSString stringWithFormat:@"%@",[userDetail objectForKey:@"role_id"]];
    
    if ([userType integerValue] == 0 || [userType integerValue] == 6) {
        
        _secLineV.hidden = YES;
        _classBtn.hidden = YES;
        _TitleLabel3.hidden = YES;
        _selectImg3.hidden = YES;
//        _bgImgV.frame = CGRectMake(0, _bgImgV.frame.origin.y, _bgImgV.frame.size.width, _bgImgV.frame.size.height - 50.0);
//        _detailView.frame = CGRectMake(0, _detailView.frame.origin.y - 50.0, _detailView.frame.size.width,  _detailView.frame.size.height);
        
        
    }
    
    
    if ([_fromName isEqualToString:@"setPublishM"]) {//发动态查看权限设置
        
        if (privilege == nil) {
             _privilege = @"32";
        }else{
            
            if ([privilege length] == 0) {
                _privilege = @"32";
            }else{
                
                _privilege  = privilege;
            }
        }
        
        // 2.9.2 2015.12.29 a.旧版公开和班级都显示成公开。
        //if ([_privilege intValue] == 32) {
        if ([_privilege integerValue] == 32 || [_privilege integerValue] == 16) {
            
            //_selectImg2.hidden = YES;
            [_selectImg2 setImage:[UIImage imageNamed:@"unSelect.png"]];
            _selectImg3.hidden = YES;
            _detailTextView.text = @"本校成员可见";
            if ([userType integerValue] == 0 || [userType integerValue] == 6){
                _detailTextView.text = @"全体师生可见";
            }
            
            #if BUREAU_OF_EDUCATION
            
            _detailTextView.text = @"本教育局可见";
#endif
            
        }else if ([_privilege intValue] == 1){
            
            //_selectImg1.hidden = YES;
            [_selectImg1 setImage:[UIImage imageNamed:@"unSelect.png"]];
            _selectImg3.hidden = YES;
            _detailTextView.text = @"仅自己可见";

            
        }
        /* 2.9.2 2015.12.29
         else if ([_privilege intValue] == 16){
            
            _selectImg1.hidden = YES;
            _selectImg2.hidden = YES;
            _detailTextView.text = @"以下班级成员可见";
            
            if(_isClass){
                
                _detailTextView.text = [NSString stringWithFormat:@"以下班级成员可见:\n%@",_cName];
            }

            
        }*/
#if BUREAU_OF_EDUCATION
        
        _TitleLabel3.text = @"部门";
#endif
        
    }else if ([_fromName isEqualToString:@"setViewM"]){//动态查看设置
        
        [self setCustomizeTitle:@"动态查看设置"];
        _TitleLabel1.text = @"全部";
        _TitleLabel2.text = @"自己";
        _TitleLabel3.text = @"班级";
        
        noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64.0 )];
        noDataView.backgroundColor = [UIColor whiteColor];
        noDataView.hidden = NO;
        [self.view addSubview:noDataView];
        
        _detailView.frame = CGRectMake(0, _detailView.frame.origin.y, [UIScreen mainScreen].bounds.size.width, 60.0);
        
        
        [self getDataForType];
        
        
    }else if ([_fromName isEqualToString:@"setMyM"]){
        
        [ReportObject event:ID_CIRCLE_SEE_SET_SEE];//2015.06.25
        
        // 2.9.2 2015.12.29 a.旧版公开和班级都显示成公开。
        //if(_privilegeFromMyMoment == 32){
        if (_privilegeFromMyMoment == 32 || _privilegeFromMyMoment == 16) {
            
            //_selectImg2.hidden = YES;
            [_selectImg2 setImage:[UIImage imageNamed:@"unSelect.png"]];
            _selectImg3.hidden = YES;
            _detailTextView.text = @"本校成员可见";
            if ([userType integerValue] == 0 || [userType integerValue] == 6){
                _detailTextView.text = @"全体师生可见";
            }
            
        }else if (_privilegeFromMyMoment == 1){
            
            //_selectImg1.hidden = YES;
            [_selectImg1 setImage:[UIImage imageNamed:@"unSelect.png"]];
            _selectImg3.hidden = YES;
            _detailTextView.text = @"仅自己可见";

            
        }
        /*2.9.2 2015.12.29
         else if (_privilegeFromMyMoment == 16){
            
            _selectImg1.hidden = YES;
            _selectImg2.hidden = YES;
            _detailTextView.text = @"以下班级成员可见";
        }*/
        
        privilegeFromMyM = [NSString stringWithFormat:@"%d",_privilegeFromMyMoment];
        
        NSString *mid = [NSString stringWithFormat:@"%@_classListCheckArray",_fmid];
        NSString *midForStu = [NSString stringWithFormat:@"%@_cidsForPublish",_fmid];
        NSString *mNameForStu = [NSString stringWithFormat:@"%@_cNamesForPublish",_fmid];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:mid];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:midForStu];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:mNameForStu];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    
}

// 获取动态权限
-(void)getDataForType{
    
    /*
     @args
     *  op=getBrowserPrivilege, sid=, uid=
     * @example:
     *
     * {"protocol":"CircleAction.getBrowserPrivilege","result":true,"message":{"privilege":"1","cids":"6075"}}
     */
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *diction = [FRNetPoolUtils getPrivilege];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities dismissProcessingHud:self.view];// 2015.05.12
            
            if (diction == nil) {
                
                noDataView.hidden = NO;
                
                [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                noDataView.hidden = YES;
                
                NSString *privilege = [diction objectForKey:@"privilege"];
                _privilegeFromSet = [Utilities getType:privilege];
              
                //在“发现”中，查看所有本校成员的动态
                //在“发现”中，仅查看自己的动态
                //在“发现”中，仅查看我所在班级成员的动态
                
                if (_privilegeFromSet == 32) {
                    
                    //_selectImg2.hidden = YES;
                    [_selectImg2 setImage:[UIImage imageNamed:@"unSelect.png"]];
                    _selectImg3.hidden = YES;
                    _detailTextView.text = @"在“发现”中，查看所有本校成员的动态。";
                    
                }else if (_privilegeFromSet == 1){
                    
                    //_selectImg1.hidden = YES;
                    [_selectImg1 setImage:[UIImage imageNamed:@"unSelect.png"]];
                    _selectImg3.hidden = YES;
                    _detailTextView.text = @"在“发现”中，仅查看自己的动态。";
                    
                }else if (_privilegeFromSet == 16){
                    
                    _selectImg1.hidden = YES;
                    _selectImg2.hidden = YES;
                    _detailTextView.text = @"在“发现”中，仅查看我所在班级成员的动态。";
                    
                }
                
            }
        });
        
    });

}

-(void)setMomentsViewType{
    
    //个人动态查看权限设置
    [Utilities showProcessingHud:self.view];// 2015.05.12
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *msg = [FRNetPoolUtils setMomentsViewType:[NSString stringWithFormat:@"%d",_privilegeFromSet]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities dismissProcessingHud:self.view];// 2015.05.12
            
            if (msg == nil) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadSchoolMomentsView" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                [Utilities showAlert:@"提示" message:msg cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }
        });
        
    });
    

}

// 对某动态进行动态查看设置
-(void)setMySingleMomentsViewType{
    
    //某动态查看权限设置
    [Utilities showProcessingHud:self.view];// 2015.05.12
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *msg = [FRNetPoolUtils setMySingleMomentViewType:_fmid privilege:privilegeFromMyM cids:_cidsFromDetail];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [Utilities dismissProcessingHud:self.view];// 2015.05.12
            
            if (msg == nil) {
                
                NSString *mid = [NSString stringWithFormat:@"%@_classListCheckArray",_fmid];
                NSMutableArray *tempArray = [[NSUserDefaults standardUserDefaults]objectForKey:mid];
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:tempArray,@"chooseClassList",nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPrivilegeForDetail" object:privilegeFromMyM userInfo:dic];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                [Utilities showAlert:@"提示" message:msg cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }
        });
        
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
     if ([_fromName isEqualToString:@"setPublishM"]) {//发动态设置
     
         if([privilege intValue] == 16){
             
              NSMutableArray *array2 = [[NSUserDefaults standardUserDefaults]objectForKey:@"classListCheckArray2"];
             
             if(array2 == nil){
                 
                 if(!_isClass){
                     privilege = @"32";
                 }
                 
             }
             
         }
         
     }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectRightAction:(id)sender{
    
    NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
    NSString *userType = [NSString stringWithFormat:@"%@",[userDetail objectForKey:@"role_id"]];
    NSLog(@"userType:%@",userType);
    
     NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *cid = [Utilities replaceNull:[userInfo objectForKey:@"role_cid"]];
    NSString *cName = [Utilities replaceNull:[userInfo objectForKey:@"role_classname"]];


    if ([_fromName isEqualToString:@"setPublishM"]) {//发动态查看权限设置
        
        [ReportObject event:ID_CIRCLE_DETAIL_SET_SEE];//2015.06.25
        
        if ([_privilege intValue] == 16) {
            if([@"7" isEqualToString:userType] || [@"2" isEqualToString:userType] || [@"9" isEqualToString:userType])
            {
                NSMutableArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:@"classListCheckArray"];
                NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:array];
                [[NSUserDefaults standardUserDefaults] setObject:tempArray forKey:@"classListCheckArray2"];
//                NSLog(@"array:%@",array);
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                if ([cid length] == 0 || [cid intValue] == 0) {
                    
                    UIAlertView *alerV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"至少选择一个班级。\n如果没有班级，请先加入一个班级。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alerV show];
                    
                }else{
                    
                    privilege = _privilege;
                    [[NSUserDefaults standardUserDefaults]setObject:cid forKey:@"cidsForPublish"];
                    [[NSUserDefaults standardUserDefaults]setObject:cName forKey:@"cNamesForPublish"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
                
            }
        }else{
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadPublishGrowingStatus" object:nil];

            privilege = _privilege;
            //保存权限返回上一页
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"cidsForPublish"];
             [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"cNamesForPublish"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }else if ([_fromName isEqualToString:@"setViewM"]){//动态查看设置
        
        [self setMomentsViewType];
        
        [ReportObject event:ID_CIRCLE_SET_SEE];//2015.06.25
        
    }else if ([_fromName isEqualToString:@"setMyM"]){//动态详情
        
        [ReportObject event:ID_CIRCLE_DETAIL_SET_SEE];//2015.06.25
        
        NSString *mid = [NSString stringWithFormat:@"%@_classListCheckArray",_fmid];
//         NSString *midForStu = [NSString stringWithFormat:@"%@_cidsForPublish",_fmid];
//         NSString *mNameForStu = [NSString stringWithFormat:@"%@_cNamesForPublish",_fmid];
        
        if (_privilegeFromMyMoment == 16) {
            if([@"7" isEqualToString:userType] || [@"2" isEqualToString:userType] || [@"9" isEqualToString:userType])
            {
                 privilegeFromMyM = [NSString stringWithFormat:@"%d",_privilegeFromMyMoment];
                [self setMySingleMomentsViewType];
                
            }else{
                
                if ([cid length] == 0 || [cid intValue] == 0) {
                    
                    UIAlertView *alerV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"至少选择一个班级。\n如果没有班级，请先加入一个班级。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alerV show];
                    
                }else{
                    
                     privilegeFromMyM = [NSString stringWithFormat:@"%d",_privilegeFromMyMoment];
                    if (_classList!=nil) {
                        
                    }else{
                        _cidsFromDetail = cid;
                    }
                   
                    [self setMySingleMomentsViewType];
//                    [[NSUserDefaults standardUserDefaults]setObject:cid forKey:midForStu];
//                    [[NSUserDefaults standardUserDefaults]setObject:cName forKey:mNameForStu];
//                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                }
                
            }
        }else{
            
            //保存权限返回上一页
             privilegeFromMyM = [NSString stringWithFormat:@"%d",_privilegeFromMyMoment];
            [self setMySingleMomentsViewType];
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:mid];
//            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:midForStu];
//            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:mNameForStu];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }
        
    }
    
}

- (IBAction)didSelectAction:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    
    NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
    NSString *userType = [NSString stringWithFormat:@"%@",[userDetail objectForKey:@"role_id"]];
    //NSLog(@"userType:%@",userType);
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *cid = [Utilities replaceNull:[userInfo objectForKey:@"role_cid"]];
    NSString *cName = [Utilities replaceNull:[userInfo objectForKey:@"role_classname"]];
    
    if ([_fromName isEqualToString:@"setPublishM"]) {
        
        if (button.tag == 301) {
            
            _privilege = @"32";
            _detailTextView.text = @"本校成员可见";
            if ([userType integerValue] == 0 || [userType integerValue] == 6){
                _detailTextView.text = @"全体师生可见";
            }
            
#if BUREAU_OF_EDUCATION
            
            _detailTextView.text = @"本教育局可见";
#endif
            
            //_selectImg2.hidden = YES;
            _selectImg3.hidden = YES;
            _selectImg1.hidden = NO;
            
            [_selectImg2 setImage:[UIImage imageNamed:@"unSelect.png"]];
            [_selectImg1 setImage:[UIImage imageNamed:@"selected.png"]];
            
            _detailView.frame = CGRectMake(_detailView.frame.origin.x, _detailView.frame.origin.y, _detailView.frame.size.width, 110);
            _detailTextView.frame = CGRectMake(_detailTextView.frame.origin.x, _detailTextView.frame.origin.y, _detailTextView.frame.size.width, 96.0);
            
        }else if (button.tag == 302){
            
            
            _privilege = @"1";
            _detailTextView.text = @"仅自己可见";
            //_selectImg1.hidden = YES;
            _selectImg3.hidden = YES;
            _selectImg2.hidden = NO;
            
            [_selectImg1 setImage:[UIImage imageNamed:@"unSelect.png"]];
            [_selectImg2 setImage:[UIImage imageNamed:@"selected.png"]];
            
            _detailView.frame = CGRectMake(_detailView.frame.origin.x, _detailView.frame.origin.y, _detailView.frame.size.width, 110);
            _detailTextView.frame = CGRectMake(_detailTextView.frame.origin.x, _detailTextView.frame.origin.y, _detailTextView.frame.size.width, 96.0);

            
        }else if (button.tag == 303){
            
            if([@"7" isEqualToString:userType] || [@"2" isEqualToString:userType] || [@"9" isEqualToString:userType])
            {
                if(_isClass){
                   
                    ChooseClassViewController *ccv = [[ChooseClassViewController alloc]init];
                    ccv.fromName = @"setPublishM";
                    ccv.isClass = YES;
                    ccv.cid = _cid;
                    [self.navigationController pushViewController:ccv animated:YES];
                    
                }else{
                    ChooseClassViewController *ccv = [[ChooseClassViewController alloc]init];
                    ccv.fromName = @"setPublishM";
                    [self.navigationController pushViewController:ccv animated:YES];
                }
                
            }else{
                
                _selectImg1.hidden = YES;
                _selectImg2.hidden = YES;
                _selectImg3.hidden = NO;
                
                if ([cid length] == 0) {
                    
                }else{
                    _privilege = @"16";
                }
                _detailTextView.text = [NSString stringWithFormat:@"以下班级成员可见:\n%@",cName];
            }
        }
        
    }else if ([_fromName isEqualToString:@"setViewM"]){
        
        if(button.tag == 301){
            _privilegeFromSet = 32;
            //_selectImg2.hidden = YES;
            _selectImg3.hidden = YES;
            _selectImg1.hidden = NO;
            
            [_selectImg2 setImage:[UIImage imageNamed:@"unSelect.png"]];
            [_selectImg1 setImage:[UIImage imageNamed:@"selected.png"]];
            
            _detailTextView.text = @"在“发现”中，查看所有本校成员的动态。";

        }else if (button.tag == 302){
            
            _privilegeFromSet = 1;
            //_selectImg1.hidden = YES;
            _selectImg3.hidden = YES;
            _selectImg2.hidden = NO;
            
            [_selectImg1 setImage:[UIImage imageNamed:@"unSelect.png"]];
            [_selectImg2 setImage:[UIImage imageNamed:@"selected.png"]];
            
            _detailTextView.text = @"在“发现”中，仅查看自己的动态。";
            
        }else if (button.tag == 303){
            
            _privilegeFromSet = 16;
            _selectImg1.hidden = YES;
            _selectImg2.hidden = YES;
            _selectImg3.hidden = NO;
            _detailTextView.text = @"在“发现”中，仅查看我所在班级成员的动态。";

        }
        
    }else if ([_fromName isEqualToString:@"setMyM"]){
     
        if(button.tag == 301){
           
            _privilegeFromMyMoment = 32;
            
            _privilege = @"32";
            _detailTextView.text = @"本校成员可见";
            if ([userType integerValue] == 0 || [userType integerValue] == 6){
                _detailTextView.text = @"全体师生可见";
            }
            //_selectImg2.hidden = YES;
            _selectImg3.hidden = YES;
            _selectImg1.hidden = NO;
            
            [_selectImg2 setImage:[UIImage imageNamed:@"unSelect.png"]];
            [_selectImg1 setImage:[UIImage imageNamed:@"selected.png"]];
            
            _detailView.frame = CGRectMake(_detailView.frame.origin.x, _detailView.frame.origin.y, _detailView.frame.size.width, 110);
            _detailTextView.frame = CGRectMake(_detailTextView.frame.origin.x, _detailTextView.frame.origin.y, _detailTextView.frame.size.width, 96.0);
            
            
        }else if (button.tag == 302){
            
            _privilegeFromMyMoment = 1;
            
            _detailTextView.text = @"仅自己可见";
            //_selectImg1.hidden = YES;
            _selectImg3.hidden = YES;
            _selectImg2.hidden = NO;
            
            [_selectImg1 setImage:[UIImage imageNamed:@"unSelect.png"]];
            [_selectImg2 setImage:[UIImage imageNamed:@"selected.png"]];
            
            _detailView.frame = CGRectMake(_detailView.frame.origin.x, _detailView.frame.origin.y, _detailView.frame.size.width, 110);
            _detailTextView.frame = CGRectMake(_detailTextView.frame.origin.x, _detailTextView.frame.origin.y, _detailTextView.frame.size.width, 96.0);
            
        }else if(button.tag == 303){
            
            _selectImg1.hidden = YES;
            _selectImg2.hidden = YES;
            _selectImg3.hidden = NO;
            
            if([@"7" isEqualToString:userType] || [@"2" isEqualToString:userType] || [@"9" isEqualToString:userType])
            {
                ChooseClassViewController *ccv = [[ChooseClassViewController alloc]init];
                ccv.fromName = @"setMyM";
                ccv.fmid = _fmid;
                ccv.classList = _classList;
                [self.navigationController pushViewController:ccv animated:YES];
                
            }else{
                
                if ([cid length] == 0) {
                    
                }else{
                    _privilegeFromMyMoment = 16;
                }
                _detailTextView.text = [NSString stringWithFormat:@"以下班级成员可见:\n%@",cName];
            }
            
        }

    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    NSMutableArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:@"classListCheckArray"];
    
    NSString *mid = [NSString stringWithFormat:@"%@_classListCheckArray",_fmid];
    NSMutableArray *arrayForMyM = [[NSUserDefaults standardUserDefaults]objectForKey:mid];
    
    if ([_fromName isEqualToString:@"setPublishM"]) {//发动态设置
        
        NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
        NSString *userType = [NSString stringWithFormat:@"%@",[userDetail objectForKey:@"role_id"]];
        //NSLog(@"userType:%@",userType);
   
        if([@"7" isEqualToString:userType] || [@"2" isEqualToString:userType] || [@"9" isEqualToString:userType])
        {
           if ([privilege intValue] == 16) {
               
               if([array count] > 0){
                   
                   _selectImg1.hidden = YES;
                   _selectImg2.hidden = YES;
                   _selectImg3.hidden = NO;
                   
                    _privilege = @"16";
                   
                   NSString *str = @"以下班级成员可见:";
                   
                   int classCount = 0;
                   
                   for (int i=0; i<[array count]; i++) {
                       
                       NSString *cName = [[array objectAtIndex:i] objectForKey:@"cName"];
                       NSString *isChecked = [[array objectAtIndex:i]objectForKey:@"isChecked"];
                       if ([isChecked intValue] == 1) {
                           
                           str = [str stringByAppendingFormat:@"\n%@",cName];
                           classCount++;
                       }
                       
                   }
                   _detailTextView.text = str;
                   if (classCount > 4) {
                       
                       _detailView.frame = CGRectMake(_detailView.frame.origin.x, _detailView.frame.origin.y, _detailView.frame.size.width, 110+48.0);
                       _detailTextView.frame = CGRectMake(_detailTextView.frame.origin.x, _detailTextView.frame.origin.y, _detailTextView.frame.size.width, 96.0+ 48.0);
                       
                   }
               }
              
           }
        }else{
            
            if ([privilege intValue] == 16) {
                
                NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
                //NSString *cid = [Utilities replaceNull:[userInfo objectForKey:@"role_cid"]];
                NSString *cName = [Utilities replaceNull:[userInfo objectForKey:@"role_classname"]];
                _detailTextView.text = [NSString stringWithFormat:@"以下班级成员可见:\n%@",cName];
                

                _detailTextView.text = @"本班成员和全体老师可见";//2015.12.29 a.旧版公开和班级都显示成公开。
                
                if ([userType integerValue] == 0 || [userType integerValue] == 6){
                    _detailTextView.text = @"全体师生可见";
                }

            }
        }
         
    }else if([_fromName isEqualToString:@"setMyM"]){//动态详情设置
        
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
        NSString *cid = [Utilities replaceNull:[userInfo objectForKey:@"role_cid"]];
        NSString *cName = [Utilities replaceNull:[userInfo objectForKey:@"role_classname"]];
    
       // NSString *cNameForStu = [NSString stringWithFormat:@"%@_cNamesForPublish",_fmid];
        
        NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
        NSString *userType = [NSString stringWithFormat:@"%@",[userDetail objectForKey:@"role_id"]];
        //NSLog(@"userType:%@",userType);
        
        if([@"7" isEqualToString:userType] || [@"2" isEqualToString:userType] || [@"9" isEqualToString:userType])
        {
            if ([privilegeFromMyM intValue] == 16) {
                
                _privilegeFromMyMoment = 16;
                
                NSString *str = @"以下班级成员可见:";
                NSString *cidForTeacher = @"";
                
                if ([arrayForMyM count] >0) {
                    _classList = nil;
                }
                
                if (_classList!=nil) {
                    
                    if ([_classList count] >0) {
                        for (int i=0; i<[_classList count]; i++) {
                            
                            NSString *cName = [[_classList objectAtIndex:i] objectForKey:@"name"];
                            NSString *cid = [[_classList objectAtIndex:i] objectForKey:@"cid"];
                         
                            str = [str stringByAppendingFormat:@"\n%@",cName];
                            
                            if ([cidForTeacher length] == 0) {
                                cidForTeacher = cid;
                            }else{
                                cidForTeacher = [cidForTeacher stringByAppendingFormat:@",%@",cid];
                            }
                            
                        }
                        
                        if ([_classList count] > 4) {
                            
                            _detailView.frame = CGRectMake(_detailView.frame.origin.x, _detailView.frame.origin.y, _detailView.frame.size.width, 110+48.0);
                            _detailTextView.frame = CGRectMake(_detailTextView.frame.origin.x, _detailTextView.frame.origin.y, _detailTextView.frame.size.width, 96.0+ 48.0);
                            
                        }
                        
                    }

                    
                }else{
                    if ([arrayForMyM count] >0) {
                        
                        int classCount = 0;
                        
                        for (int i=0; i<[arrayForMyM count]; i++) {
                            
                            NSString *cName = [[arrayForMyM objectAtIndex:i] objectForKey:@"cName"];
                            NSString *cid = [[arrayForMyM objectAtIndex:i] objectForKey:@"cid"];
                            NSString *isChecked = [[arrayForMyM objectAtIndex:i]objectForKey:@"isChecked"];
                            
                            NSLog(@"isChecked:%@",isChecked);
                            
                            if ([isChecked intValue] == 1) {
                                
                                if([cidForTeacher length] == 0){
                                    cidForTeacher = cid;
                                }
                                
                                str = [str stringByAppendingFormat:@"\n%@",cName];
                                
                                if ([cidForTeacher length] == 0) {
                                    cidForTeacher = cid;
                                }else{
                                      cidForTeacher = [cidForTeacher stringByAppendingFormat:@",%@",cid];
                                }
                              
                            }
                            
                        }
                        
                        if (classCount > 4) {
                            
                            _detailView.frame = CGRectMake(_detailView.frame.origin.x, _detailView.frame.origin.y, _detailView.frame.size.width, 110+48.0);
                            _detailTextView.frame = CGRectMake(_detailTextView.frame.origin.x, _detailTextView.frame.origin.y, _detailTextView.frame.size.width, 96.0+ 48.0);
                            
                        }
                    }

                }
                _cidsFromDetail = cidForTeacher;
                _detailTextView.text = str;
            }
        }else{
            
//             NSString *midForStu = [NSString stringWithFormat:@"%@_cidsForPublish",_fmid];
            
            if ([privilegeFromMyM intValue] == 16) {
                
                _privilegeFromMyMoment = 16;
                if (_cidsFromDetail == nil) {
                    _cidsFromDetail = cid;
                }
                
                _detailTextView.text = [NSString stringWithFormat:@"以下班级成员可见:\n%@",cName];
                _detailTextView.text = @"本班成员和全体老师可见";//2015.12.29 a.旧版公开和班级都显示成公开。
                if ([userType integerValue] == 0 || [userType integerValue] == 6){
                    _detailTextView.text = @"全体师生可见";
                }

            
            }

        }

    }
    
}

@end
