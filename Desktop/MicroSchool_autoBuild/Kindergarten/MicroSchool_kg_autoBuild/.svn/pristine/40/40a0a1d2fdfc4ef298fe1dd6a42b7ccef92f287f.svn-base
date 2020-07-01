//
//  SetPersonalInfoViewController.m
//  MicroSchool
//
//  Created by jojo on 13-12-29.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "SetPersonalInfoViewController.h"
#import "ContactViewController.h"
#import "SettingDutiesViewController.h"
#import "SettingSubjectsViewController.h"
#import "BindPhoneNumberViewController.h"
#import "MyTabBarController.h"

@interface SetPersonalInfoViewController ()

@end

@implementation SetPersonalInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        network = [NetworkUtility alloc];
        network.delegate = self;
        
        settingPersonalInfo =[[NSMutableDictionary alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super setCustomizeTitle:@"个人信息"];
    [super setCustomizeLeftButton];
    
    imgNewDuty = [[UIImageView alloc] init];
    imgNewSubject = [[UIImageView alloc] init];
    
    // 去单例中取得用户profile
    NSMutableDictionary *user;
    user = [g_userInfo getUserDetailInfo];
    
    NSMutableDictionary *personalInfo = [g_userInfo getUserPersonalInfo];
    
    [personalInfo setObject:[user objectForKey:@"name"] forKey:@"name"];
    [personalInfo setObject:[user objectForKey:@"sex"] forKey:@"gender"];
    [personalInfo setObject:[user objectForKey:@"spacenote"] forKey:@"spacenote"];
    
    [personalInfo setObject:[user objectForKey:@"birthyear"] forKey:@"birthyear"];
    [personalInfo setObject:[user objectForKey:@"birthmonth"] forKey:@"birthmonth"];
    [personalInfo setObject:[user objectForKey:@"birthday"] forKey:@"birthday"];
    
    [personalInfo setObject:[user objectForKey:@"birthprovince"] forKey:@"birthprovince"];
    [personalInfo setObject:[user objectForKey:@"birthcity"] forKey:@"birthcity"];
    
    [personalInfo setObject:[user objectForKey:@"resideprovince"] forKey:@"resideprovince"];
    [personalInfo setObject:[user objectForKey:@"residecity"] forKey:@"residecity"];
    
    [personalInfo setObject:[user objectForKey:@"blood"] forKey:@"blood"];
    //---update by 2014.10.16----------------------------------------------------
    [personalInfo setObject:[user objectForKey:@"qq"] forKey:@"qq"];// QQ号
    [personalInfo setObject:[user objectForKey:@"mobile"] forKey:@"mobile"];// 手机号
    //----------------------------------------------------------------------------
    
    NSString *usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
    [personalInfo setObject:usertype forKey:@"usertype"];
    [personalInfo setObject:[user objectForKey:@"role_classname"] forKey:@"class"];
    [personalInfo setObject:[user objectForKey:@"studentid"] forKey:@"studentid"];// @"身份证号"
    
    
    [personalInfo setObject:[user objectForKey:@"duty"] forKey:@"duty"];// 职务
    [personalInfo setObject:[user objectForKey:@"subject"] forKey:@"subject"];// 任教学科
    
    [g_userInfo setUserSettingPersonalInfo:personalInfo];
    
    settingPersonalInfo = personalInfo;
    
    [ReportObject event:ID_OPEN_PERSON_INFO];//2015.06.25
}

-(void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)submitAction:(id)sender
{
    // 防止多次快速提交
    self.navigationItem.rightBarButtonItem.enabled = NO;
    //    NSString *username = [user objectForKey:@"username"];
    //NSString *cid = [user objectForKey:@"cid"];
    //NSString *usertype = [user objectForKey:@"usertype"];
    
#if 0
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:AC_PROFILE_UPDATE, @"url",
                          //                          usertype, @"usertype",
                          username, @"username",
                          //cid, @"cid",
                          [settingPersonalInfo objectForKey:@"name"], @"name",
                          [settingPersonalInfo objectForKey:@"gender"], @"sex",
                          [settingPersonalInfo objectForKey:@"studentid"], @"studentid",
                          [settingPersonalInfo objectForKey:@"birthyear"], @"birthyear",
                          [settingPersonalInfo objectForKey:@"birthmonth"], @"birthmonth",
                          [settingPersonalInfo objectForKey:@"birthday"], @"birthday",
                          [settingPersonalInfo objectForKey:@"birthprovince"], @"birthprovince",
                          [settingPersonalInfo objectForKey:@"birthcity"], @"birthcity",
                          [settingPersonalInfo objectForKey:@"resideprovince"], @"resideprovince",
                          [settingPersonalInfo objectForKey:@"residecity"], @"residecity",
                          [settingPersonalInfo objectForKey:@"blood"], @"blood",
                          [settingPersonalInfo objectForKey:@"spacenote"], @"spacenote",
                          [settingPersonalInfo objectForKey:@"cid"], @"cid",
                          
                          nil];
#endif
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Profile", @"ac",
                          @"2", @"v",
                          @"update", @"op",
                          [settingPersonalInfo objectForKey:@"gender"], @"sex",
                          [settingPersonalInfo objectForKey:@"name"], @"name",
                          [settingPersonalInfo objectForKey:@"birthyear"], @"birthyear",
                          [settingPersonalInfo objectForKey:@"birthmonth"], @"birthmonth",
                          [settingPersonalInfo objectForKey:@"birthday"], @"birthday",
                          [settingPersonalInfo objectForKey:@"birthprovince"], @"birthprovince",
                          [settingPersonalInfo objectForKey:@"birthcity"], @"birthcity",
                          [settingPersonalInfo objectForKey:@"resideprovince"], @"resideprovince",
                          [settingPersonalInfo objectForKey:@"residecity"], @"residecity",
                          [settingPersonalInfo objectForKey:@"spacenote"], @"spacenote",
                          [settingPersonalInfo objectForKey:@"studentid"], @"studentid",
                          [settingPersonalInfo objectForKey:@"qq"], @"qq",
                          [settingPersonalInfo objectForKey:@"mobile"], @"mobile",
                          nil];
    
    [network sendHttpReq:HttpReq_ProfileUpdate andData:data];
    
    //    [network sendHttpReq:HttpReq_ProfileUpdate andData:data];
    
    //先将未到时间执行前的任务取消。
    //    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(doSubmit:) object:sender];
    //    [self performSelector:@selector(doSubmit:) withObject:sender afterDelay:0.2f];
}

-(void)doSubmit:(id)sender
{
    NSMutableDictionary *user = [g_userInfo getUserDetailInfo];
    
    //    NSString *uid = [NSString stringWithFormat:@"%@", [user objectForKey:@"uid"]];
    NSString *username = [user objectForKey:@"username"];
    NSString *cid = [user objectForKey:@"cid"];
    NSString *studentid = [user objectForKey:@"studentid"];
    //NSString *usertype = [user objectForKey:@"usertype"];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          AC_PROFILE_UPDATE, @"url",
                          username, @"username",
                          cid, @"cid",
                          [settingPersonalInfo objectForKey:@"name"], @"name",
                          [settingPersonalInfo objectForKey:@"gender"], @"sex",
                          studentid, @"studentid",
                          [settingPersonalInfo objectForKey:@"birthyear"], @"birthyear",
                          [settingPersonalInfo objectForKey:@"birthmonth"], @"birthmonth",
                          [settingPersonalInfo objectForKey:@"birthday"], @"birthday",
                          [settingPersonalInfo objectForKey:@"birthprovince"], @"birthprovince",
                          [settingPersonalInfo objectForKey:@"birthcity"], @"birthcity",
                          [settingPersonalInfo objectForKey:@"resideprovince"], @"resideprovince",
                          [settingPersonalInfo objectForKey:@"residecity"], @"residecity",
                          [settingPersonalInfo objectForKey:@"blood"], @"blood",
                          [settingPersonalInfo objectForKey:@"spacenote"], @"spacenote",
                          nil];
    
    [network sendHttpReq:HttpReq_ProfileUpdate andData:data];
}
-(void)viewWillAppear:(BOOL)animated
{
    //    GlobalSingletonUserInfo* g_userSettingInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
    //    settingPersonalInfo = [g_userSettingInfo getUserSettingPersonalInfo];
    [MyTabBarController setTabBarHidden:YES];
    user = [g_userInfo getUserDetailInfo];
    NSString *isDuty = [[NSUserDefaults standardUserDefaults]objectForKey:@"isDuty"];
    NSString *isSubject = [[NSUserDefaults standardUserDefaults]objectForKey:@"isSubject"];
    
    if ([isDuty integerValue] == 1) {
        [imgNewDuty removeFromSuperview];
    }
    if ([isSubject integerValue] == 1) {
        [imgNewSubject removeFromSuperview];
    }
    
    [_tableView reloadData];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    
    // 背景图片
    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,HEIGHT)];
    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    [self.view addSubview:imgView_bgImg];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(
                                                              0,
                                                              0,
                                                              WIDTH,
                                                              HEIGHT-44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    //这个方法用来告诉表格有几个分组
//    //    if ([@"7"  isEqual: [settingPersonalInfo objectForKey:@"usertype"]]) {
//    //        return 2;
//    //    } else {
//    //        return 2;
//    //    }
//    
//    if ([@"7"  isEqual: [settingPersonalInfo objectForKey:@"usertype"]] || [@"9"  isEqual: [settingPersonalInfo objectForKey:@"usertype"]]) {
//        
//        return 3;
//        
//    }else{
//        
//        return 2;
//    }
//#3.28  和春晖确认，学生号教师号样式相同
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
//    if ([@"7"  isEqual: [settingPersonalInfo objectForKey:@"usertype"]] || [@"9"  isEqual: [settingPersonalInfo objectForKey:@"usertype"]]) {
//        if (0 == section) {
//#if BUREAU_OF_EDUCATION
//        return 3;
//#else
//      return 4;
//            
//#endif
//            
//            
//        }else if (1 == section){
//            
//            return 2;
//            
//        }else if (2 == section) {
//            
//            return 5;
//        }
//        
//    }else if([@"2"  isEqual: [settingPersonalInfo objectForKey:@"usertype"]]){
//        
//        if (0 == section) {
//#if BUREAU_OF_EDUCATION
//            return 3;
//#else
//            return 4;
//            
//#endif
//        }
//        if (1 == section) {
//            return 5;
//        }
//        
//    }else if([@"0"  isEqual: [settingPersonalInfo objectForKey:@"usertype"]]) {
//        
//        if (0 == section) {
//            return 4;//学生身份不显示@"身份证号" Bug2262
//        }
//        if (1 == section) {
//            return 5;
//        }
//        
//    }else if([@"6"  isEqual: [settingPersonalInfo objectForKey:@"usertype"]]) {
//        
//        if (0 == section) {
//            return 4;
//        }
//        if (1 == section) {
//            return 5;
//        }
//        
//    }
//#3.28    和春晖确认
    if ([@"7"  isEqual: [settingPersonalInfo objectForKey:@"usertype"]] || [@"9"  isEqual: [settingPersonalInfo objectForKey:@"usertype"]]) {
        if (0 ==section) {
            return 3;
        }else if (1 ==section){
            return 3;
        }
    
    }else {
        if (0 ==section) {
            return 3;
        }else if (1 ==section){
            return 2;
        }
    }
        return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    
//    if ([@"7"  isEqual: [settingPersonalInfo objectForKey:@"usertype"]] || [@"9"  isEqual: [settingPersonalInfo objectForKey:@"usertype"]]) {
//        
//        //指定行的高度
//        if (0 == [indexPath section] && 0 == [indexPath row]) {
//            return 90;
//        }else if (2 == [indexPath section] && 4 == [indexPath row]){
//            
//            return 90;
//        }
//    }else{
//        //指定行的高度
//        if (0 == [indexPath section] && 0 == [indexPath row]) {
//            return 90;
//        }else if (1 == [indexPath section] && 4 == [indexPath row]){
//            
//            return 90;
//        }
//        
//    }
    if (0 == [indexPath section] && 0 == [indexPath row]) {
        return 75;
    }else{
        return 45;
    }
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    static NSString *GroupedTableIdentifier1 = @"GroupedTableIdentifier1";
    
    if (0 == [indexPath section] && 0 == [indexPath row]) {
        
        SetPersonalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier1];
        if(cell == nil) {
            cell = [[SetPersonalInfoTableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:GroupedTableIdentifier1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSMutableDictionary *user = [g_userInfo getUserDetailInfo];
        NSString *avatar = [user objectForKey:@"avatar"];
        
        cell.name = @"头像";
        if (nil == image_head)
        {
            [cell.imgView_thumb sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
        }
        else
        {
            [cell.imgView_thumb setImage:image_head];
        }
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleValue1
                    reuseIdentifier:GroupedTableIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:17.0];
        
//        if ([@"7"  isEqual: [settingPersonalInfo objectForKey:@"usertype"]] || [@"9"  isEqual: [settingPersonalInfo objectForKey:@"usertype"]]) {
//            if (0 == [indexPath section] && 0 == [indexPath row]) {
//            }else if (0 == [indexPath section] && 1 == [indexPath row]){
//                cell.textLabel.text = @"真实姓名";
//                cell.detailTextLabel.text = [settingPersonalInfo objectForKey:@"name"];
//            }else if (1 == [indexPath section] && 0 == [indexPath row]){
//                
//                cell.textLabel.text = @"手机号";
//                NSString *mobile = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[settingPersonalInfo objectForKey:@"mobile"]]];
//                if ([mobile length] == 0) {
//                    mobile = @"未绑定";
//                    [ReportObject event:ID_CLICK_PHONENUMBER_UNBIND];
//                }else{
//                    [ReportObject event:ID_CLICK_PHONENUMBER_BIND];
//                }
//                cell.detailTextLabel.text = mobile;
//                //                if ([@"0"  isEqual: [settingPersonalInfo objectForKey:@"gender"]]) {
//                //                    cell.detailTextLabel.text = @"女";
//                //                }
//                //                else {
//                //                    cell.detailTextLabel.text = @"男";
//                //                }
//            }else if (1 == [indexPath section] && 1 == [indexPath row]){
//                
//                cell.textLabel.text = @"QQ";
//                cell.detailTextLabel.text = [settingPersonalInfo objectForKey:@"qq"];
//                
//                //                cell.textLabel.text = @"个性签名";
//                //                cell.detailTextLabel.text = [settingPersonalInfo objectForKey:@"spacenote"];
//            }else if (0 == [indexPath section] && 2 == [indexPath row]){// 2015.06.09
//                
//#if BUREAU_OF_EDUCATION
//       cell.textLabel.text = @"职务";
//#else
//     cell.textLabel.text = @"本校职务";
//#endif
// 
//                cell.detailTextLabel.text = [settingPersonalInfo objectForKey:@"duty"];//职务
//                
//                /*去掉new标实
//                 NSString *isDuty = [[NSUserDefaults standardUserDefaults] objectForKey:@"isDuty"];
//                 if (!isDuty) {
//                 
//                 imgNewDuty.image = [UIImage imageNamed:@"icon_forNew.png"];
//                 imgNewDuty.frame = CGRectMake(15+4*16+5+10, (50.0-18.0)/2.0, 30.0, 18.0);
//                 [cell addSubview:imgNewDuty];
//                 
//                 }*/
//                
//                
//            }
//            else if (0 == [indexPath section] && 3 == [indexPath row]){// 2015.06.09
//                
//                cell.textLabel.text = @"任教学科";
//                cell.detailTextLabel.text = [settingPersonalInfo objectForKey:@"subject"];//科目
//                
//                /* 去掉new标实
//                 NSString *isSubject = [[NSUserDefaults standardUserDefaults] objectForKey:@"isSubject"];
//                 if (!isSubject) {
//                 
//                 imgNewSubject.image = [UIImage imageNamed:@"icon_forNew.png"];
//                 imgNewSubject.frame = CGRectMake(15+4*16+5+10, (50.0-18.0)/2.0, 30.0, 18.0);
//                 [cell addSubview:imgNewSubject];
//                 
//                 }*/
//                
//            }
//
//            else if (2 == [indexPath section] && 0 == [indexPath row]){
//                cell.textLabel.text = @"性别";
//                if ([@"2"  isEqual: [settingPersonalInfo objectForKey:@"gender"]]) {
//                    cell.detailTextLabel.text = @"女";
//                }else {
//                    cell.detailTextLabel.text = @"男";
//                }
//            }
//            else if (2 == [indexPath section] && 1 == [indexPath row]){
//                cell.textLabel.text = @"生日";
//                NSString* birthyear = [settingPersonalInfo objectForKey:@"birthyear"];
//                NSString* birthmonth = [settingPersonalInfo objectForKey:@"birthmonth"];
//                NSString* birthday = [settingPersonalInfo objectForKey:@"birthday"];
//                NSString *birthStr = [NSString stringWithFormat:@"%@年 %@月 %@日", birthyear, birthmonth, birthday];
//                cell.detailTextLabel.text = birthStr;
//            }else if (2 == [indexPath section] && 2 == [indexPath row]){
//                cell.textLabel.text = @"家乡";
//                NSString* birthprovince = [settingPersonalInfo objectForKey:@"birthprovince"];
//                NSString* birthcity = [settingPersonalInfo objectForKey:@"birthcity"];
//                NSString *homeTownStr;
//                if ([@""  isEqual: birthcity]) {
//                    homeTownStr = @"";
//                } else {
//                    homeTownStr = [NSString stringWithFormat:@"%@ %@", birthprovince, birthcity];
//                }
//                cell.detailTextLabel.text = homeTownStr;
//            }else if (2 == [indexPath section] && 3 == [indexPath row]){
//                cell.textLabel.text = @"居住地";
//                NSString* resideprovince = [settingPersonalInfo objectForKey:@"resideprovince"];
//                NSString* residecity = [settingPersonalInfo objectForKey:@"residecity"];
//                NSString *liveStr;
//                if ([@""  isEqual: residecity]) {
//                    liveStr = @"";
//                } else {
//                    liveStr = [NSString stringWithFormat:@"%@ %@", resideprovince, residecity];
//                }
//                cell.detailTextLabel.text = liveStr;
//            }else if (2 == [indexPath section] && 4 == [indexPath row]){
//                
//                imgNewDuty.image = nil;
//                imgNewSubject.image = nil;
//                cell.textLabel.text = @"个性签名";
//                cell.detailTextLabel.text = [settingPersonalInfo objectForKey:@"spacenote"];
//                
//            }else{
//                return nil;
//            }
//        }else if ([@"2"  isEqual: [settingPersonalInfo objectForKey:@"usertype"]]) {
//            
//            if (0 == [indexPath section] && 0 == [indexPath row]) {
//            }else if (0 == [indexPath section] && 1 == [indexPath row]){
//                cell.textLabel.text = @"真实姓名";
//                cell.detailTextLabel.text = [settingPersonalInfo objectForKey:@"name"];
//            }else if (0 == [indexPath section] && 2 == [indexPath row]){
//                
//                cell.textLabel.text = @"手机号";
//                NSString *mobile = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[settingPersonalInfo objectForKey:@"mobile"]]];
//                if ([mobile length] == 0) {
//                    mobile = @"未绑定";
//                    [ReportObject event:ID_CLICK_PHONENUMBER_UNBIND];
//                }else{
//                    [ReportObject event:ID_CLICK_PHONENUMBER_BIND];
//                }
//                cell.detailTextLabel.text = mobile;
//                
//                cell.detailTextLabel.text = [settingPersonalInfo objectForKey:@"mobile"];
//                
//            }else if (0 == [indexPath section] && 3 == [indexPath row]){
//                cell.textLabel.text = @"QQ";
//                cell.detailTextLabel.text = [settingPersonalInfo objectForKey:@"qq"];
//                
//            }else if (1 == [indexPath section] && 0 == [indexPath row]){
//                
//                cell.textLabel.text = @"性别";
//                if ([@"2"  isEqual: [settingPersonalInfo objectForKey:@"gender"]]) {
//                    cell.detailTextLabel.text = @"女";
//                }
//                else {
//                    cell.detailTextLabel.text = @"男";
//                }
//            }
//            else if (1 == [indexPath section] && 1 == [indexPath row]){
//                cell.textLabel.text = @"生日";
//                NSString* birthyear = [settingPersonalInfo objectForKey:@"birthyear"];
//                NSString* birthmonth = [settingPersonalInfo objectForKey:@"birthmonth"];
//                NSString* birthday = [settingPersonalInfo objectForKey:@"birthday"];
//                NSString *birthStr = [NSString stringWithFormat:@"%@年 %@月 %@日", birthyear, birthmonth, birthday];
//                cell.detailTextLabel.text = birthStr;
//            }else if (1 == [indexPath section] && 2 == [indexPath row]){
//                cell.textLabel.text = @"家乡";
//                NSString* birthprovince = [settingPersonalInfo objectForKey:@"birthprovince"];
//                NSString* birthcity = [settingPersonalInfo objectForKey:@"birthcity"];
//                NSString *homeTownStr;
//                if ([@""  isEqual: birthcity]) {
//                    homeTownStr = @"";
//                } else {
//                    homeTownStr = [NSString stringWithFormat:@"%@ %@", birthprovince, birthcity];
//                }
//                cell.detailTextLabel.text = homeTownStr;
//            }else if (1 == [indexPath section] && 3 == [indexPath row]){
//                cell.textLabel.text = @"居住地";
//                NSString* resideprovince = [settingPersonalInfo objectForKey:@"resideprovince"];
//                NSString* residecity = [settingPersonalInfo objectForKey:@"residecity"];
//                NSString *liveStr;
//                if ([@""  isEqual: residecity]) {
//                    liveStr = @"";
//                } else {
//                    liveStr = [NSString stringWithFormat:@"%@ %@", resideprovince, residecity];
//                }
//                cell.detailTextLabel.text = liveStr;
//            }else if (1 == [indexPath section] && 4 == [indexPath row]){
//                
//                cell.textLabel.text = @"个性签名";
//                cell.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//                cell.detailTextLabel.text = [settingPersonalInfo objectForKey:@"spacenote"];
//                
//            }else{
//                return nil;
//            }
//        }else if([@"0"  isEqual: [settingPersonalInfo objectForKey:@"usertype"]]) {
//            if (0 == [indexPath section] && 0 == [indexPath row]) {
//            }else if (0 == [indexPath section] && 1 == [indexPath row]){
//                cell.textLabel.text = @"真实姓名";
//                cell.detailTextLabel.text = [settingPersonalInfo objectForKey:@"name"];
//                
//                // 老师家长身份不可以修改真实姓名
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                cell.accessoryType = UITableViewCellAccessoryNone;
//                
//            }else{
//                
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//                
//                if (0 == [indexPath section] && 2 == [indexPath row]){
//                    
//                    cell.textLabel.text = @"手机号";
//                    NSString *mobile = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[settingPersonalInfo objectForKey:@"mobile"]]];
//                    if ([mobile length] == 0) {
//                        mobile = @"未绑定";
//                        [ReportObject event:ID_CLICK_PHONENUMBER_UNBIND];
//                    }else{
//                        [ReportObject event:ID_CLICK_PHONENUMBER_BIND];
//                    }
//                    cell.detailTextLabel.text = mobile;
//                    
//                    cell.detailTextLabel.text = [settingPersonalInfo objectForKey:@"mobile"];
//                    
//                }else if (0 == [indexPath section] && 3 == [indexPath row]){
//                    cell.textLabel.text = @"QQ";
//                    cell.detailTextLabel.text = [settingPersonalInfo objectForKey:@"qq"];
//                    
//                }
//#if 0
//                //学生身份隐藏@"身份证号" Bug 2262
//                else if (0 == [indexPath section] && 4 == [indexPath row]){
//                    cell.textLabel.text = @"身份证号";
//                    NSString *studentid = [settingPersonalInfo objectForKey:@"studentid"];
//                    cell.detailTextLabel.text = studentid;
//                }
//#endif
//                else if (1 == [indexPath section] && 0 == [indexPath row]){
//                    
//                    cell.textLabel.text = @"性别";
//                    if ([@"2"  isEqual: [settingPersonalInfo objectForKey:@"gender"]]) {
//                        cell.detailTextLabel.text = @"女";
//                    }
//                    else {
//                        cell.detailTextLabel.text = @"男";
//                    }
//                }
//                else if (1 == [indexPath section] && 1 == [indexPath row]){
//                    cell.textLabel.text = @"生日";
//                    NSString* birthyear = [settingPersonalInfo objectForKey:@"birthyear"];
//                    NSString* birthmonth = [settingPersonalInfo objectForKey:@"birthmonth"];
//                    NSString* birthday = [settingPersonalInfo objectForKey:@"birthday"];
//                    NSString *birthStr = [NSString stringWithFormat:@"%@年 %@月 %@日", birthyear, birthmonth, birthday];
//                    cell.detailTextLabel.text = birthStr;
//                }else if (1 == [indexPath section] && 2 == [indexPath row]){
//                    cell.textLabel.text = @"家乡";
//                    NSString* birthprovince = [settingPersonalInfo objectForKey:@"birthprovince"];
//                    NSString* birthcity = [settingPersonalInfo objectForKey:@"birthcity"];
//                    NSString *homeTownStr;
//                    if ([@""  isEqual: birthcity]) {
//                        homeTownStr = @"";
//                    } else {
//                        homeTownStr = [NSString stringWithFormat:@"%@ %@", birthprovince, birthcity];
//                    }
//                    cell.detailTextLabel.text = homeTownStr;
//                }else if (1 == [indexPath section] && 3 == [indexPath row]){
//                    cell.textLabel.text = @"居住地";
//                    NSString* resideprovince = [settingPersonalInfo objectForKey:@"resideprovince"];
//                    NSString* residecity = [settingPersonalInfo objectForKey:@"residecity"];
//                    NSString *liveStr;
//                    if ([@""  isEqual: residecity]) {
//                        liveStr = @"";
//                    } else {
//                        liveStr = [NSString stringWithFormat:@"%@ %@", resideprovince, residecity];
//                    }
//                    cell.detailTextLabel.text = liveStr;
//                }else if (1 == [indexPath section] && 4 == [indexPath row]){
//                    
//                    cell.textLabel.text = @"个性签名";
//                    cell.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//                    cell.detailTextLabel.text = [settingPersonalInfo objectForKey:@"spacenote"];
//                    
//                }else{
//                    return nil;
//                }
//            }
//            
//        }else if([@"6"  isEqual: [settingPersonalInfo objectForKey:@"usertype"]] ) {
//            if (0 == [indexPath section] && 0 == [indexPath row]) {
//            }else if (0 == [indexPath section] && 1 == [indexPath row]){
//                cell.textLabel.text = @"本校昵称";
//                cell.detailTextLabel.text = [settingPersonalInfo objectForKey:@"name"];
//                
//                // 老师家长身份不可以修改真实姓名
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                cell.accessoryType = UITableViewCellAccessoryNone;
//                
//            }else{
//                
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//                
//                if (0 == [indexPath section] && 2 == [indexPath row]){
//                    
//                    cell.textLabel.text = @"手机号";
//                    NSString *mobile = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[settingPersonalInfo objectForKey:@"mobile"]]];
//                    if ([mobile length] == 0) {
//                        mobile = @"未绑定";
//                        [ReportObject event:ID_CLICK_PHONENUMBER_UNBIND];
//                    }else{
//                        [ReportObject event:ID_CLICK_PHONENUMBER_BIND];
//                    }
//                    cell.detailTextLabel.text = mobile;
//                    
//                    cell.detailTextLabel.text = [settingPersonalInfo objectForKey:@"mobile"];
//                    
//                }else if (0 == [indexPath section] && 3 == [indexPath row]){
//                    cell.textLabel.text = @"QQ";
//                    cell.detailTextLabel.text = [settingPersonalInfo objectForKey:@"qq"];
//                    
//                }else if (1 == [indexPath section] && 0 == [indexPath row]){
//                    
//                    cell.textLabel.text = @"性别";
//                    if ([@"2"  isEqual: [settingPersonalInfo objectForKey:@"gender"]]) {
//                        cell.detailTextLabel.text = @"女";
//                    }
//                    else {
//                        cell.detailTextLabel.text = @"男";
//                    }
//                }else if (1 == [indexPath section] && 1 == [indexPath row]){
//                    cell.textLabel.text = @"生日";
//                    NSString* birthyear = [settingPersonalInfo objectForKey:@"birthyear"];
//                    NSString* birthmonth = [settingPersonalInfo objectForKey:@"birthmonth"];
//                    NSString* birthday = [settingPersonalInfo objectForKey:@"birthday"];
//                    NSString *birthStr = [NSString stringWithFormat:@"%@年 %@月 %@日", birthyear, birthmonth, birthday];
//                    cell.detailTextLabel.text = birthStr;
//                }else if (1 == [indexPath section] && 2 == [indexPath row]){
//                    cell.textLabel.text = @"家乡";
//                    NSString* birthprovince = [settingPersonalInfo objectForKey:@"birthprovince"];
//                    NSString* birthcity = [settingPersonalInfo objectForKey:@"birthcity"];
//                    NSString *homeTownStr;
//                    if ([@""  isEqual: birthcity]) {
//                        homeTownStr = @"";
//                    } else {
//                        homeTownStr = [NSString stringWithFormat:@"%@ %@", birthprovince, birthcity];
//                    }
//                    cell.detailTextLabel.text = homeTownStr;
//                }else if (1 == [indexPath section] && 3 == [indexPath row]){
//                    cell.textLabel.text = @"居住地";
//                    NSString* resideprovince = [settingPersonalInfo objectForKey:@"resideprovince"];
//                    NSString* residecity = [settingPersonalInfo objectForKey:@"residecity"];
//                    NSString *liveStr;
//                    if ([@""  isEqual: residecity]) {
//                        liveStr = @"";
//                    } else {
//                        liveStr = [NSString stringWithFormat:@"%@ %@", resideprovince, residecity];
//                    }
//                    cell.detailTextLabel.text = liveStr;
//                }else if (1 == [indexPath section] && 4 == [indexPath row]){
//                    
//                    cell.textLabel.text = @"个性签名";
//                    cell.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//                    cell.detailTextLabel.text = [settingPersonalInfo objectForKey:@"spacenote"];
//                    
//                }else{
//                    return nil;
//                }
//            }
//            
//            
//        }
//
         if (0 == [indexPath section] && 0 == [indexPath row]) {
             
    }else if (0 == [indexPath section] && 1 == [indexPath row]){//姓名
        if ([@"7"  isEqual: [settingPersonalInfo objectForKey:@"usertype"]] || [@"9"  isEqual: [settingPersonalInfo objectForKey:@"usertype"]]) {//教师
            cell.textLabel.text = @"姓名";
            cell.detailTextLabel.text = [settingPersonalInfo objectForKey:@"name"];
        }else{//学生
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.textLabel.text = @"姓名";
            cell.detailTextLabel.text = [settingPersonalInfo objectForKey:@"name"];
        }
    }else if (0 == [indexPath section] && 2 == [indexPath row]){//性别
            cell.textLabel.text = @"性别";
        if ([@"2"  isEqual: [settingPersonalInfo objectForKey:@"gender"]]) {
            cell.detailTextLabel.text = @"女";
    }else {
            cell.detailTextLabel.text = @"男";
    }
    }else if (1 == [indexPath section] && 0 == [indexPath row]){//手机号
            cell.textLabel.text = @"手机号";
            NSString *mobile = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[settingPersonalInfo objectForKey:@"mobile"]]];
          if ([mobile length] == 0) {
            mobile = @"未绑定";
            [ReportObject event:ID_CLICK_PHONENUMBER_UNBIND];
    }else{
            [ReportObject event:ID_CLICK_PHONENUMBER_BIND];
    }
            cell.detailTextLabel.text = mobile;
    }else if (1 == [indexPath section] && 1 == [indexPath row]){//本校身份
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.textLabel.text = @"本校身份";
//#4.1个人资料页新增管理员选项。原来是7&9都是教师，现在7是教师9是管理员。
         NSString *usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
        if ([usertype intValue] == 7) {
            cell.detailTextLabel.text = @"教师";
        }else if([usertype intValue] == 6){
            cell.detailTextLabel.text = @"家长";
        }else if([usertype intValue] == 0){
            cell.detailTextLabel.text = @"学生";
        }else if([usertype intValue] == 2){
            cell.detailTextLabel.text = @"督学";
        }else if([usertype intValue] == 9){
            cell.detailTextLabel.text = @"管理员";
        }
    }else if (1 == [indexPath section] && 2 == [indexPath row]){//职务
            cell.textLabel.text = @"职务";
            cell.detailTextLabel.text = [settingPersonalInfo objectForKey:@"duty"];
    }
        return cell;
    }
}

//选中Cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    NSString *mobile = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[settingPersonalInfo objectForKey:@"mobile"]]];
//    
//    if ([@"7"  isEqual: [settingPersonalInfo objectForKey:@"usertype"]] || [@"9"  isEqual: [settingPersonalInfo objectForKey:@"usertype"]] ) {//头像
//        if (0 == [indexPath section] && 0 == [indexPath row]) {
//            UIActionSheet *myActionSheet = [[UIActionSheet alloc]
//                                            initWithTitle:nil
//                                            delegate:self
//                                            cancelButtonTitle:@"取消"
//                                            destructiveButtonTitle:nil
//                                            otherButtonTitles: @"从相册选择", @"拍照",nil];
//            [myActionSheet showInView:self.view];
//        }else if (0 == [indexPath section] && 1 == [indexPath row]){//真实姓名
//            
//            SettingNameViewController *nameViewCtrl = [[SettingNameViewController alloc] init];
//            [self.navigationController pushViewController:nameViewCtrl animated:YES];
//            
//        }else if(1 == [indexPath section] && 0 == [indexPath row]){//手机号
//            
//            // 去绑定电话/更改绑定电话 页
//            BindPhoneNumberViewController *bindPhoneNumV = [[BindPhoneNumberViewController alloc] init];
//            if ([mobile length] == 0) {
//                bindPhoneNumV.fromName = @"bind";
//            }
//            [self.navigationController pushViewController:bindPhoneNumV animated:YES];
//            
//            
//        }else if (1 == [indexPath section] && 1 == [indexPath row]){//QQ
//            
//            SettingNameViewController *nameViewCtrl = [[SettingNameViewController alloc] init];
//            nameViewCtrl.fromName = @"qq";
//            [self.navigationController pushViewController:nameViewCtrl animated:YES];
//            
//        }else if (0 == [indexPath section] && 2 == [indexPath row]){// 2015.06.09
//            
//            SettingDutiesViewController *dutyViewCtrl = [[SettingDutiesViewController alloc]init];
//            [self.navigationController pushViewController:dutyViewCtrl animated:YES];
//            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isDuty"];
//            
//            
//        }else if (0 == [indexPath section] && 3 == [indexPath row]){// 2015.06.09
//            
//            SettingSubjectsViewController *dutyViewCtrl = [[SettingSubjectsViewController alloc]init];
//            [self.navigationController pushViewController:dutyViewCtrl animated:YES];
//            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isSubject"];
//            
//        }else if (2 == [indexPath section] && 0 == [indexPath row]){//性别
//            
//            SettingGenderViewController *genderViewCtrl = [[SettingGenderViewController alloc] init];
//            [self.navigationController pushViewController:genderViewCtrl animated:YES];
//            
//        }else if (2 == [indexPath section] && 1 == [indexPath row]){//生日
//            
//            SettingBirthViewController *brithViewCtrl = [[SettingBirthViewController alloc] init];
//            [self.navigationController pushViewController:brithViewCtrl animated:YES];
//            
//        }else if (2 == [indexPath section] && 2 == [indexPath row]){//家乡
//            
//            SettingHomeViewController *homeViewCtrl = [[SettingHomeViewController alloc] init];
//            homeViewCtrl.fromName = _fromName;
//            [self.navigationController pushViewController:homeViewCtrl animated:YES];
//            
//        }else if (2 == [indexPath section] && 3 == [indexPath row]){//居住地
//            
//            SettingResideViewController *resideViewCtrl = [[SettingResideViewController alloc] init];
//            resideViewCtrl.fromName = _fromName;
//            [self.navigationController pushViewController:resideViewCtrl animated:YES];
//            
//        }else{//个人简介
//            
//            SettingSpacenoteViewController *spacenoteViewCtrl = [[SettingSpacenoteViewController alloc] init];
//            [self.navigationController pushViewController:spacenoteViewCtrl animated:YES];
//            
//        }
//    }else if ([@"2"  isEqual: [settingPersonalInfo objectForKey:@"usertype"]]){
//        
//        if (0 == [indexPath section] && 0 == [indexPath row]) {//头像
//            UIActionSheet *myActionSheet = [[UIActionSheet alloc]
//                                            initWithTitle:nil
//                                            delegate:self
//                                            cancelButtonTitle:@"取消"
//                                            destructiveButtonTitle:nil
//                                            otherButtonTitles: @"从相册选择", @"拍照",nil];
//            [myActionSheet showInView:self.view];
//        }else if (0 == [indexPath section] && 1 == [indexPath row]){//真实姓名
//            SettingNameViewController *nameViewCtrl = [[SettingNameViewController alloc] init];
//            [self.navigationController pushViewController:nameViewCtrl animated:YES];
//        }else if(0 == [indexPath section] && 2 == [indexPath row]){// 手机号
//            
//            // 去绑定电话/更改绑定电话 页
//            BindPhoneNumberViewController *bindPhoneNumV = [[BindPhoneNumberViewController alloc] init];
//            if ([mobile length] == 0) {
//                bindPhoneNumV.fromName = @"bind";
//            }
//            [self.navigationController pushViewController:bindPhoneNumV animated:YES];
//            
//        }else if (0 == [indexPath section] && 3 == [indexPath row]){//QQ
//            
//            SettingNameViewController *nameViewCtrl = [[SettingNameViewController alloc] init];
//            nameViewCtrl.fromName = @"qq";
//            [self.navigationController pushViewController:nameViewCtrl animated:YES];
//            
//        }else if (1 == [indexPath section] && 0 == [indexPath row]){//性别
//            
//            SettingGenderViewController *genderViewCtrl = [[SettingGenderViewController alloc] init];
//            [self.navigationController pushViewController:genderViewCtrl animated:YES];
//            
//        }else if (1 == [indexPath section] && 1 == [indexPath row]){//生日
//            
//            SettingBirthViewController *brithViewCtrl = [[SettingBirthViewController alloc] init];
//            [self.navigationController pushViewController:brithViewCtrl animated:YES];
//            
//        }else if (1 == [indexPath section] && 2 == [indexPath row]){//家乡
//            SettingHomeViewController *homeViewCtrl = [[SettingHomeViewController alloc] init];
//            homeViewCtrl.fromName = _fromName;
//            [self.navigationController pushViewController:homeViewCtrl animated:YES];
//            
//        }else if (1 == [indexPath section] && 3 == [indexPath row]){//居住地
//            
//            SettingResideViewController *resideViewCtrl = [[SettingResideViewController alloc] init];
//            resideViewCtrl.fromName = _fromName;
//            [self.navigationController pushViewController:resideViewCtrl animated:YES];
//            
//        }else{//个人简介
//            
//            SettingSpacenoteViewController *spacenoteViewCtrl = [[SettingSpacenoteViewController alloc] init];
//            [self.navigationController pushViewController:spacenoteViewCtrl animated:YES];
//            
//        }
//        
//    }else if([@"0"  isEqual: [settingPersonalInfo objectForKey:@"usertype"]]) {
//        if (0 == [indexPath section] && 0 == [indexPath row]) {//头像
//            UIActionSheet *myActionSheet = [[UIActionSheet alloc]
//                                            initWithTitle:nil
//                                            delegate:self
//                                            cancelButtonTitle:@"取消"
//                                            destructiveButtonTitle:nil
//                                            otherButtonTitles: @"从相册选择", @"拍照",nil];
//            [myActionSheet showInView:self.view];
//        }else if (0 == [indexPath section] && 1 == [indexPath row]){
//            //真实姓名
//#if 0
//            // modify by ht 2015.10.11 学生与家长不可以修改正式姓名了
//            [Utilities showFailedHud:@"无法修改真实姓名." descView:self.view];
//            
//            SettingNameViewController *nameViewCtrl = [[SettingNameViewController alloc] init];
//            [self.navigationController pushViewController:nameViewCtrl animated:YES];
//#endif
//        }else if(0 == [indexPath section] && 2 == [indexPath row]){// 手机号
//            // 去绑定电话/更改绑定电话 页
//            BindPhoneNumberViewController *bindPhoneNumV = [[BindPhoneNumberViewController alloc] init];
//            if ([mobile length] == 0) {
//                bindPhoneNumV.fromName = @"bind";
//            }
//            [self.navigationController pushViewController:bindPhoneNumV animated:YES];
//        }
//        else if (0 == [indexPath section] && 3 == [indexPath row]){//QQ
//            
//            SettingNameViewController *nameViewCtrl = [[SettingNameViewController alloc] init];
//            nameViewCtrl.fromName = @"qq";
//            [self.navigationController pushViewController:nameViewCtrl animated:YES];
//            
//        }
//#if 0
//        else if (0 == [indexPath section] && 4 == [indexPath row]){//@"身份证号"
//            
//            SettingNumberViewController *numberViewCtrl = [[SettingNumberViewController alloc] init];
//            [self.navigationController pushViewController:numberViewCtrl animated:YES];
//            
//        }
//#endif
//        else if (1 == [indexPath section] && 0 == [indexPath row]){//性别
//            
//            SettingGenderViewController *genderViewCtrl = [[SettingGenderViewController alloc] init];
//            [self.navigationController pushViewController:genderViewCtrl animated:YES];
//            
//        }else if (1 == [indexPath section] && 1 == [indexPath row]){//生日
//            
//            SettingBirthViewController *brithViewCtrl = [[SettingBirthViewController alloc] init];
//            [self.navigationController pushViewController:brithViewCtrl animated:YES];
//            
//        }else if (1 == [indexPath section] && 2 == [indexPath row]){//家乡
//            SettingHomeViewController *homeViewCtrl = [[SettingHomeViewController alloc] init];
//            homeViewCtrl.fromName = _fromName;
//            [self.navigationController pushViewController:homeViewCtrl animated:YES];
//            
//        }else if (1 == [indexPath section] && 3 == [indexPath row]){//居住地
//            
//            SettingResideViewController *resideViewCtrl = [[SettingResideViewController alloc] init];
//            resideViewCtrl.fromName = _fromName;
//            [self.navigationController pushViewController:resideViewCtrl animated:YES];
//            
//        }else{//个人简介
//            
//            SettingSpacenoteViewController *spacenoteViewCtrl = [[SettingSpacenoteViewController alloc] init];
//            [self.navigationController pushViewController:spacenoteViewCtrl animated:YES];
//            
//        }
//    }else if([@"6"  isEqual: [settingPersonalInfo objectForKey:@"usertype"]] ) {
//        if (0 == [indexPath section] && 0 == [indexPath row]) {//头像
//            UIActionSheet *myActionSheet = [[UIActionSheet alloc]
//                                            initWithTitle:nil
//                                            delegate:self
//                                            cancelButtonTitle:@"取消"
//                                            destructiveButtonTitle:nil
//                                            otherButtonTitles: @"从相册选择", @"拍照",nil];
//            [myActionSheet showInView:self.view];
//        }else if (0 == [indexPath section] && 1 == [indexPath row]){
//            //真实姓名
//#if 0
//            // modify by ht 2015.10.11 学生与家长不可以修改正式姓名了
//            [Utilities showFailedHud:@"无法修改本校昵称." descView:self.view];
//            
//            SettingNameViewController *nameViewCtrl = [[SettingNameViewController alloc] init];
//            [self.navigationController pushViewController:nameViewCtrl animated:YES];
//#endif
//        }else if(0 == [indexPath section] && 2 == [indexPath row]){// 手机号
//            // 去绑定电话/更改绑定电话 页
//            BindPhoneNumberViewController *bindPhoneNumV = [[BindPhoneNumberViewController alloc] init];
//            if ([mobile length] == 0) {
//                bindPhoneNumV.fromName = @"bind";
//            }
//            [self.navigationController pushViewController:bindPhoneNumV animated:YES];
//        }
//        else if (0 == [indexPath section] && 3 == [indexPath row]){//QQ
//            
//            SettingNameViewController *nameViewCtrl = [[SettingNameViewController alloc] init];
//            nameViewCtrl.fromName = @"qq";
//            [self.navigationController pushViewController:nameViewCtrl animated:YES];
//            
//        }else if (0 == [indexPath section] && 4 == [indexPath row]){//@"身份证号"
//            
//            SettingNumberViewController *numberViewCtrl = [[SettingNumberViewController alloc] init];
//            [self.navigationController pushViewController:numberViewCtrl animated:YES];
//            
//        }else if (1 == [indexPath section] && 0 == [indexPath row]){//性别
//            
//            SettingGenderViewController *genderViewCtrl = [[SettingGenderViewController alloc] init];
//            [self.navigationController pushViewController:genderViewCtrl animated:YES];
//            
//        }else if (1 == [indexPath section] && 1 == [indexPath row]){//生日
//            
//            SettingBirthViewController *brithViewCtrl = [[SettingBirthViewController alloc] init];
//            [self.navigationController pushViewController:brithViewCtrl animated:YES];
//            
//        }else if (1 == [indexPath section] && 2 == [indexPath row]){//家乡
//            SettingHomeViewController *homeViewCtrl = [[SettingHomeViewController alloc] init];
//            homeViewCtrl.fromName = _fromName;
//            [self.navigationController pushViewController:homeViewCtrl animated:YES];
//            
//        }else if (1 == [indexPath section] && 3 == [indexPath row]){//居住地
//            
//            SettingResideViewController *resideViewCtrl = [[SettingResideViewController alloc] init];
//            resideViewCtrl.fromName = _fromName;
//            [self.navigationController pushViewController:resideViewCtrl animated:YES];
//            
//        }else{//个人简介
//            
//            SettingSpacenoteViewController *spacenoteViewCtrl = [[SettingSpacenoteViewController alloc] init];
//            [self.navigationController pushViewController:spacenoteViewCtrl animated:YES];
//            
//        }
//    }
//#3.28  和春晖确认
    if (0 == [indexPath section] && 0 == [indexPath row]) {//头像
        UIActionSheet *myActionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                            delegate:self
                                                            cancelButtonTitle:@"取消"
                                                            destructiveButtonTitle:nil
                                                            otherButtonTitles: @"从相册选择", @"拍照",nil];
                                                    [myActionSheet showInView:self.view];
    
    }else if (0 == [indexPath section] && 1 == [indexPath row]){//姓名
        if ([@"7"  isEqual: [settingPersonalInfo objectForKey:@"usertype"]] || [@"9"  isEqual: [settingPersonalInfo objectForKey:@"usertype"]]) {//教师
            SettingNameViewController *nameViewCtrl = [[SettingNameViewController alloc] init];
            [self.navigationController pushViewController:nameViewCtrl animated:YES];
        
        
        }else{//学生
        
        }

    }else if (0 == [indexPath section] && 2 == [indexPath row]){//性别
        SettingGenderViewController *genderViewCtrl = [[SettingGenderViewController alloc] init];
        [self.navigationController pushViewController:genderViewCtrl animated:YES];
    }else if (1 == [indexPath section] && 0 == [indexPath row]){//手机号
        // 去绑定电话/更改绑定电话 页
        BindPhoneNumberViewController *bindPhoneNumV = [[BindPhoneNumberViewController alloc] init];
           if ([mobile length] == 0) {
                bindPhoneNumV.fromName = @"bind";
    }
        [self.navigationController pushViewController:bindPhoneNumV animated:YES];
    
    }else if (1 == [indexPath section] && 1 == [indexPath row]){//本校身份
    
    
    }else if (1 == [indexPath section] && 2 == [indexPath row]){//职务
        SettingDutiesViewController *dutyViewCtrl = [[SettingDutiesViewController alloc]init];
            [self.navigationController pushViewController:dutyViewCtrl animated:YES];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isDuty"];
    
    
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            // 从相册选择
            [self LocalPhoto];
            break;
        case 1:
            // 拍照
            //[self takePhoto];
            [Utilities takePhotoFromViewController:self];//update by kate 2015.04.17
            break;
        default:
            break;
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

//从相册选择
-(void)LocalPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    // 资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    // 设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:nil];
}

//拍照
-(void)takePhoto{
    // 资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    // 判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        // 设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        // 资源类型为照相机
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else {
        NSLog(@"该设备无摄像头");
    }
}

#pragma Delegate method UIImagePickerControllerDelegate
// 图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    // 当图片不为空时显示图片并保存图片
    if (image != nil) {
        image_head_pre = image;
        
        
        //--- 加入和setHeadImgViewController一样的压缩--------
        UIImage *scaledImage;
        UIImage *updateImage;
        
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
        
        //----------------------------------------------------------
        
        // 获取Documents文件夹目录
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [path objectAtIndex:0];
        // 指定新建文件夹路径
        NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"ImageFile"];
        // 创建ImageFile文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
        // 保存图片的路径
        self->imagePath = [imageDocPath stringByAppendingPathComponent:@"image.png"];
        
        // 以下是保存文件到沙盒路径下
        // 把图片转成NSData类型的数据来保存文件
        NSData *data;
        // 判断图片是不是png格式的文件
        //        if (UIImagePNGRepresentation(updateImage)) {
        //            // 返回为png图像。
        //            data = UIImagePNGRepresentation(updateImage);
        //        }else {
        //            // 返回为JPEG图像。
        data = UIImageJPEGRepresentation(updateImage, 0.3);
        //       }
        // 保存
        [[NSFileManager defaultManager] createFileAtPath:self->imagePath contents:data attributes:nil];
        
        [self doUpdateAvatar];
    }
    // 关闭相册界面
    [picker dismissModalViewControllerAnimated:YES];
}

-(void) doUpdateAvatar
{
    [Utilities showProcessingHud:self.view];
    
    NSMutableDictionary *user = [g_userInfo getUserDetailInfo];
    
    NSString *uid = [NSString stringWithFormat:@"%@",[user objectForKey:@"uid"]];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Avatar",@"ac",
                          @"2",@"v",
                          @"upload", @"op",
                          self->imagePath, @"avatar",
                          nil];
    
    network.delegate = self;
    [network sendHttpReq:HttpReq_Avatar andData:data];
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    [Utilities dismissProcessingHud:self.view];
    
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    //NSString* message_info = [resultJSON objectForKey:@"message"];
    
    if ([@"AvatarAction.upload"  isEqual: [resultJSON objectForKey:@"protocol"]])
    {
        if(true == [result intValue])
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"成功"
                                                           message:@"头像上传成功"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
            
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] clearMemory];
            
            image_head = image_head_pre;
            [self->_tableView reloadData];
            
            [ReportObject event:ID_SET_PERSON_INFO];//2015.06.25
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"失败"
                                                           message:[resultJSON objectForKey:@"message"]
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
        if(true == [result intValue])
        {
            NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
            
            [userDetail setObject:[settingPersonalInfo objectForKey:@"name"] forKey:@"name"];
            [userDetail setObject:[settingPersonalInfo objectForKey:@"gender"] forKey:@"sex"];
            [userDetail setObject:[settingPersonalInfo objectForKey:@"spacenote"] forKey:@"spacenote"];
            [userDetail setObject:[settingPersonalInfo objectForKey:@"birthyear"] forKey:@"birthyear"];
            [userDetail setObject:[settingPersonalInfo objectForKey:@"birthmonth"] forKey:@"birthmonth"];
            [userDetail setObject:[settingPersonalInfo objectForKey:@"birthday"] forKey:@"birthday"];
            [userDetail setObject:[settingPersonalInfo objectForKey:@"birthprovince"] forKey:@"birthprovince"];
            [userDetail setObject:[settingPersonalInfo objectForKey:@"birthcity"] forKey:@"birthcity"];
            [userDetail setObject:[settingPersonalInfo objectForKey:@"resideprovince"] forKey:@"resideprovince"];
            [userDetail setObject:[settingPersonalInfo objectForKey:@"residecity"] forKey:@"residecity"];
            [userDetail setObject:[settingPersonalInfo objectForKey:@"blood"] forKey:@"blood"];
            //            [userDetail setObject:[settingPersonalInfo objectForKey:@"class"] forKey:@"role_classes"];
            [userDetail setObject:[settingPersonalInfo objectForKey:@"studentid"] forKey:@"studentid"];
            
            [g_userInfo setUserDetailInfo:userDetail];
            
            //            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"成功"
            //                                                           message:@"个人信息设置成功"
            //                                                          delegate:self
            //                                                 cancelButtonTitle:@"确定"
            //                                                 otherButtonTitles:nil];
            //            [alert show];
            
            // 修改成功，gps上报
            DataReport *dr = [DataReport sharedGlobalSingletonDataReport];
            [dr dataReportGPStype:DataReport_Act_SavePersonalInfo];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"失败"
                                                           message:@"个人信息设置失败"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

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

@end
