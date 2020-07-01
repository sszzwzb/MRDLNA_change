//
//  AccountandPrivacyViewController.m
//  MicroSchool
//
//  Created by Kate on 14-10-15.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "AccountandPrivacyViewController.h"
#import "PasswordViewController.h"
#import "MicroSchoolLoginViewController.h"
#import "AddFriendWayViewController.h"
#import "SetMyPrivacyViewController.h"
#import "MicroSchoolAppDelegate.h"
#import "WhoCanViewController.h"

@interface AccountandPrivacyViewController ()

@end

extern UINavigationController *navigation_Signup;
extern UINavigationController *navigation_NoUserType;
extern GuideViewController *guide_viewCtrl;

@implementation AccountandPrivacyViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@"账号安全"];
    
    network = [NetworkUtility alloc];
    network.delegate = self;

    
    // 背景图片
    UIImageView *imgView_bgImg =[UIImageView new];
    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    [self.view addSubview:imgView_bgImg];
    [imgView_bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(WIDTH,HEIGHT));
    }];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(
                                                              0,
                                                              0,
                                                              [UIScreen mainScreen].applicationFrame.size.width,
                                                              [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    [self.view addSubview:_tableView];
    
    imgView = [[UIImageView alloc]init];
    imgView.frame = CGRectMake(125, (44 - 18)/2+2, 30, 18);
    imgView.image = [UIImage imageNamed:@"icon_forNew.png"];
    
    imgViewForAddFriend = [[UIImageView alloc]init];
    imgViewForAddFriend.frame = CGRectMake(110, (44 - 18)/2+2, 30, 18);
    imgViewForAddFriend.image = [UIImage imageNamed:@"icon_forNew.png"];
    
    [ReportObject event:ID_OPEN_PRIVACY];//2015.06.25
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MyTabBarController setTabBarHidden:YES];
    user = [g_userInfo getUserDetailInfo];
    
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    
    if (section == 0 ) {
        return 1;
    }else if(section == 1){
        //return 4;
        //return 3;//去掉动态查看设置这条 tony确认2015.12.29
        return 3;//去掉加好友设置这条 经纬确认2016.09.09
    }else{
        return 1;
    }
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (2 == [indexPath section] && 0 == [indexPath row]){
        
        static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier0";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:GroupedTableIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
#if BUREAU_OF_EDUCATION
         cell.textLabel.text = @"变更身份";//cell的style为Default形式文字可居中
#else
        cell.textLabel.text = @"变更本校身份";//cell的style为Default形式文字可居中
#endif
       
//        cell.textLabel.textColor = [UIColor redColor];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        
        return cell;
        
    }else{
        static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
        
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
        if (1 == [indexPath section] && 0 == [indexPath row]) {
            cell.textLabel.text = @"修改密码";
        }
#if 0
        else if (1 == [indexPath section] && 1 == [indexPath row]){
            cell.textLabel.text = @"加好友设置";
            NSString *authority = [user objectForKey:@"authority"];
            if ([authority intValue] == 1) {
                cell.detailTextLabel.text = @"允许任何人加入";
            }else if ([authority intValue] == 2){
                cell.detailTextLabel.text = @"需消息验证";
            }else{
                cell.detailTextLabel.text = @"不可添加好友";
            }
            
            /*NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
             BOOL isNew_Done = [userDefaults boolForKey:@"AddFriendNew_Done"];
             if (isNew_Done) {
             [imgViewForAddFriend removeFromSuperview];
             }else{
             [cell addSubview:imgViewForAddFriend];
             }*/
            
        }
#endif
        //else if (1 == [indexPath section] && 2 == [indexPath row]){
        else if (1 == [indexPath section] && 1 == [indexPath row]){
            
            cell.textLabel.text = @"个人隐私设置";
            
            //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            // BOOL isNew_Done = [userDefaults boolForKey:@"PrivateNew_Done"];
            // if (isNew_Done) {
            // [imgView removeFromSuperview];
            // }else{
            // [cell addSubview:imgView];
            // }
         
            
        }
        else if (1 == [indexPath section] && 2 == [indexPath row]){
            cell.textLabel.text = @"不看Ta的师生圈";
        }
       //tony确认2015.12.29这条去掉
        /*else if (1 == [indexPath section] && 3 == [indexPath row]){
        
            cell.textLabel.text = @"动态查看设置";
            
            //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
             //BOOL isNew_Done = [userDefaults boolForKey:@"MomentsNew_Done"];
             //if (isNew_Done) {
             //[imgView removeFromSuperview];
             //}else{
             //[cell addSubview:imgView];
             //}
         
            
        }*/
        else if (0 == [indexPath section] && 0 == [indexPath row]){
            // 0 学生 6 家长 7 老师
            // 去单例中取得用户profile
            
            NSString *usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
#if BUREAU_OF_EDUCATION
            cell.textLabel.text = @"身份";
#else
            cell.textLabel.text = @"在校身份";
#endif
            
            
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
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }
        return cell;
        

    }

    
  }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    if (1 == [indexPath section] && 0 == [indexPath row]) {
        
        PasswordViewController *passwordViewCtrl = [[PasswordViewController alloc] init];
        [self.navigationController pushViewController:passwordViewCtrl animated:YES];
        passwordViewCtrl.title = @"修改密码";
        
    }
#if 0  // 经纬确认2016.09.09这条去掉
    else if (1 == [indexPath section] && 1 == [indexPath row]){
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AddFriendNew_Done"];
        NSString *authority = [user objectForKey:@"authority"];
        AddFriendWayViewController *addFriendV = [[AddFriendWayViewController alloc]init];
        addFriendV.joinPerm = authority;
        [self.navigationController pushViewController:addFriendV animated:YES];
        
    }
#endif
    
    //else if (1 == [indexPath section] && 2 == [indexPath row]){
    else if (1 == [indexPath section] && 1 == [indexPath row]){
     
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"PrivateNew_Done"];
        SetMyPrivacyViewController *setPV = [[SetMyPrivacyViewController alloc]init];
        [self.navigationController pushViewController:setPV animated:YES];
        
    }
    else if (1 == [indexPath section] && 2 == [indexPath row]){
        GroupChatSettingViewController *groupChatSet = [[GroupChatSettingViewController alloc]init];
        groupChatSet.viewType = @"hiddenMomentsList";
        [self.navigationController pushViewController:groupChatSet animated:YES];
    }
    //tony确认2015.12.29这条去掉
    /*else if (1 == [indexPath section] && 3 == [indexPath row]){
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MomentsNew_Done"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"New_Done"];
        WhoCanViewController *wcv = [[WhoCanViewController alloc]init];
        wcv.fromName = @"setViewM";
        [self.navigationController pushViewController:wcv animated:YES];
        
    }*/
    else if (0 == [indexPath section] && 0 == [indexPath row]){
        
    }else if (2 == [indexPath section] && 0 == [indexPath row]){
        
        [self showPointsIntroduce];
        
//        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
//                                                       message:@"退出学校后，您的个人信息将保留，但学校相关信息将被清空，请慎重操作！"
//                                                      delegate:self
//                                             cancelButtonTitle:@"取消"
//                                             otherButtonTitles:@"确定退出",nil];
//        alert.tag = 99;
//        [alert show];

        
    }
    
}

- (void)showPointsIntroduce{
    
#if BUREAU_OF_EDUCATION
    NSString *note = @"变更身份时，您会退到登录页，此时请使用本帐号和密码重新登录并选择身份！\n\n若您仅是想退出或切换帐号，请通过【系统设置 - 退出登录】进行操作。";
#else
    NSString *note = @"变更本校身份时，您会退到登录页，此时请使用本帐号和密码重新登录并选择身份！\n\n若您仅是想退出或切换帐号，请通过【系统设置 - 退出登录】进行操作。";
#endif
    
    
    CGSize size = [note sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(240,400) lineBreakMode:NSLineBreakByTruncatingTail];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -20,240, size.height)];
    
    textLabel.font = [UIFont systemFontOfSize:14.0];
    textLabel.textColor = [UIColor blackColor];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.lineBreakMode =NSLineBreakByWordWrapping;
    textLabel.numberOfLines =0;
    textLabel.textAlignment =NSTextAlignmentLeft;
    textLabel.text = note;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
#if BUREAU_OF_EDUCATION
        NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"变更身份时，您会退到登录页，此时请使用本帐号和密码重新登录并选择身份！\n\n若您仅是想退出或切换帐号，请通过【系统设置 - 退出登录】进行操作。"];
#else
        NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"变更本校身份时，您会退到登录页，此时请使用本帐号和密码重新登录并选择身份！\n\n若您仅是想退出或切换帐号，请通过【系统设置 - 退出登录】进行操作。"];
#endif
       
        [hogan addAttribute:NSFontAttributeName
                      value:[UIFont systemFontOfSize:14.0]
                      range:NSMakeRange(0, [hogan length])];
        
        [hogan addAttribute:NSForegroundColorAttributeName
                      value:[UIColor blackColor]
                      range:NSMakeRange(0, [hogan length])];

        [alertController setValue:hogan forKey:@"attributedTitle"];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            
        }];
        [alertController addAction:cancelAction];

        UIAlertAction *resetAction = [UIAlertAction actionWithTitle:@"我要变更" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
            [Utilities showProcessingHud:self.view];
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"2",@"v",
                                  @"Profile", @"ac",
                                  @"quit", @"op",
                                  nil];
            
            [network sendHttpReq:HttpReq_QuitSchool andData:data];
        }];
        [alertController addAction:resetAction];

        
        
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc ] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        //iOS8下 UIAlertController 左对齐
        //----方法1 设置 AttributedString------------------------------------------------------------------
        /* NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc] initWithString:note];
         [messageText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [note length])];
         [messageText addAttribute:NSFontAttributeName
         value:[UIFont systemFontOfSize:14.0]
         range:NSMakeRange(0,[note length])];//字体
         
         [alertController setValue:messageText forKey:@"attributedMessage"];*/
        //--------------------------------------------------------------------------------------------------
        
        //----方法2 遍历UIAlertController的subview找到message所属的Label---------------------------------------
        NSArray *viewArray = [[[[[[[[[[[[alertController view] subviews] firstObject] subviews] firstObject] subviews] firstObject] subviews] firstObject] subviews] firstObject] subviews];
        UILabel *alertMessage = viewArray[0];
//        UILabel *alertMessage = viewArray[1];
        alertMessage.textAlignment = NSTextAlignmentLeft;
//        alertMessage.textColor = [UIColor redColor];
//        [alertMessage setTextColor:[UIColor redColor]];
        
        
//        alertMessage.text = @"slkdfslkdflsdfkl";
        NSString *a = alertMessage.text;
        
        
//        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
////            textField.placeholder = @"登录";
////            textField
//        }];
        //----------------------------------------------------------------------------------------------------
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:note delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.delegate = self;
        
        [alert setValue:textLabel forKey:@"accessoryView"];
        
        alert.message =@"";
        [alert show];
        
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [Utilities transformationHeight:15.0];
    }else{
        return [Utilities transformationHeight:7.5];
    } // 第一行是第二行的2倍关系
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return [Utilities transformationHeight:7.5];
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定行的高度
    return 50;
}

-(void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (99 == alertView.tag) {
        if (buttonIndex == 1) {
            
            [Utilities showProcessingHud:self.view];
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"2",@"v",
                                  @"Profile", @"ac",
                                  @"quit", @"op",
                                  nil];
            
            [network sendHttpReq:HttpReq_QuitSchool andData:data];
        }
    }
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    [Utilities dismissProcessingHud:self.view];
    
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if(true == [result intValue])
    {
        // 清掉放在userDefaluts里面的登录信息，下次登录时不再自动登录
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSMutableArray *dynamicArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDynamicModule"];
        
        for (int i=0; i<[dynamicArr count]; i++) {
            
            NSDictionary *dic = [dynamicArr objectAtIndex:i];
            NSString *name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
            //NSLog(@"name:%@",name);
            [defaults removeObjectForKey:name];
        }
        
        [defaults removeObjectForKey:G_NSUserDefaults_UserLoginInfo];
        [defaults removeObjectForKey:G_NSUserDefaults_UserUniqueUid];
        [defaults removeObjectForKey:@"lastId_cnews"];
        [defaults removeObjectForKey:@"lastId_news"];
        [defaults removeObjectForKey:@"lastHomeIdDic"];
        [defaults removeObjectForKey:@"lastDisIdDic"];
        [defaults removeObjectForKey:@"lastClassDisIdDic"];
        [defaults removeObjectForKey:@"lastSelfNewIdDic"];
        [defaults removeObjectForKey:@"lastMyNewMsgIdDic"];
        [defaults removeObjectForKey:@"lastId_chat"];
        [defaults setObject:@"1" forKey:@"MessageSwitch"];
        [defaults removeObjectForKey:@"lastId_Education"];
        [defaults removeObjectForKey:@"lastId_CookMenu"];
        [defaults removeObjectForKey:@"lastId_OrientalSound"];
        [defaults removeObjectForKey:@"lastId_StudentHandbook"];
        [defaults setBool:NO forKey:@"DB_DONE"];
        [defaults setObject:nil forKey:@"zhixiao_isNewVersionPopupShow"];
        [defaults removeObjectForKey:@"lastIDForFeedback"];
        [defaults setObject:nil forKey:@"classArray"];// add by kate 2014.12.01
        [defaults setObject:nil forKey:@"MyMsgLastId"];// add by kate 2014.12.03
        [defaults setObject:@"" forKey:@"viewName"];
        [defaults setBool:NO forKey:@"HelpNew_Done"];
        [defaults setObject:nil forKey:@"tabTitles"];
        [defaults setObject:nil forKey:@"isKnowledge"];// add by kate 2015.03.04
        [defaults setBool:YES forKey:@"isShowPopViewForClass"];//2016.2.23
        [defaults synchronize];
        
        // 清除发布作业保存之前的标题
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:[NSString stringWithFormat:@"homeworkTitle"]];
        [[NSUserDefaults standardUserDefaults] synchronize];

        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"zhixiao_regUid"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:[NSString stringWithFormat:@"zhixiao_regIdentity_%@", uid]];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:[NSString stringWithFormat:@"zhixiao_regRealName_%@", uid]];
        [[NSUserDefaults standardUserDefaults] synchronize];

        // add by ht 20140915 如果注册完毕并且登录成功后，清空用户信息，以便下一次直接进入主界面，增加userDefaults变量
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"weixiao_userDetailInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"weixiao_userDynamicModule"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        /* NSString *dbFileStr = [[Utilities getMyInfoDir] stringByAppendingPathComponent:@"WeixiaoChat.db"];
         NSFileManager *fileManager = [NSFileManager defaultManager];
         if([fileManager removeItemAtPath:dbFileStr error:nil]){
         //NSLog(@"1");
         }else{
         //NSLog(@"0");
         }*/
        
        // 删除班级头像
        NSString *fullPath = [[Utilities SystemDir] stringByAppendingPathComponent:@"tempImgForClass.png"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if([fileManager removeItemAtPath:fullPath error:nil]){
            //NSLog(@"1");
        }else{
            //NSLog(@"0");
        }
        
        [[DBDao getDaoInstance] releaseDB];
        
        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
        NSString *fromNameToHome = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"fromNameToHome"]];
        
        if(appDelegate.window.rootViewController!=appDelegate.splash_viewController){
            
            appDelegate.window.rootViewController = appDelegate.splash_viewController;//重置rootview add 2015.10.23
            
            if([fromNameToHome isEqualToString:@"splash"]){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSplash" object:nil];
            }else if ([fromNameToHome isEqualToString:@"setHeadImg"]){
                
                [navigation_Signup dismissViewControllerAnimated:YES completion:nil];
                
                
            }else if ([fromNameToHome isEqualToString:@"noUserType"]){
                [navigation_NoUserType dismissViewControllerAnimated:YES completion:nil];
            }else if ([fromNameToHome isEqualToString:@"noUserName_splash"]){
                
                if (guide_viewCtrl) {
                    [guide_viewCtrl dismissViewControllerAnimated:YES completion:nil];
                }
                
                [navigation_NoUserType dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSplash" object:nil];
            }
            appDelegate.tabBarController = nil;
            
            
        }else{
            [appDelegate.tabBarController dismissViewControllerAnimated:NO completion:^{
                if([fromNameToHome isEqualToString:@"splash"]){
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSplash" object:nil];
                }else if ([fromNameToHome isEqualToString:@"setHeadImg"]){
                    
                    [navigation_Signup dismissViewControllerAnimated:YES completion:nil];
                    
                    
                }else if ([fromNameToHome isEqualToString:@"noUserType"]){
                    [navigation_NoUserType dismissViewControllerAnimated:YES completion:nil];
                }else if ([fromNameToHome isEqualToString:@"noUserName_splash"]){
                    
                    if (guide_viewCtrl) {
                        [guide_viewCtrl dismissViewControllerAnimated:YES completion:nil];
                    }
                    
                    [navigation_NoUserType dismissViewControllerAnimated:YES completion:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSplash" object:nil];
                }
            }];
            appDelegate.tabBarController = nil;
        }
        
        
        /*if([fromNameToHome isEqualToString:@"splash"]){
         
            [appDelegate.tabBarController dismissViewControllerAnimated:YES completion:nil];
            appDelegate.tabBarController = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSplash" object:nil];
        }else if ([fromNameToHome isEqualToString:@"setHeadImg"]){
            
            [navigation_Signup dismissViewControllerAnimated:YES completion:^{
                [appDelegate.tabBarController dismissViewControllerAnimated:YES completion:nil];
                appDelegate.tabBarController = nil;
            }];
            
            
        }else if ([fromNameToHome isEqualToString:@"noUserType"]){
            [navigation_NoUserType dismissViewControllerAnimated:NO completion:^{
                [appDelegate.tabBarController dismissViewControllerAnimated:YES completion:nil];
                appDelegate.tabBarController = nil;
            }];
        }else{
            [appDelegate.tabBarController dismissViewControllerAnimated:YES completion:nil];
            appDelegate.tabBarController = nil;
        }*/
        
        [ReportObject event:ID_QUIT_SCHOOL];//2015.06.25
        
    }
    else
    {
        NSString* message_info = [resultJSON objectForKey:@"message"];
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:message_info
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
