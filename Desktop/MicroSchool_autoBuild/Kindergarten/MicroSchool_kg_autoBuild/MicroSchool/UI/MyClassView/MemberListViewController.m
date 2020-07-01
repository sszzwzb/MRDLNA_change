//
//  MemberListViewController.m
//  MicroSchool
//
//  Created by Kate on 14-9-20.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "MemberListViewController.h"
#import "MemberTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ClassFilterViewController.h"
#import "FRNetPoolUtils.h"
#import "FriendProfileViewController.h"
#import "Toast+UIView.h"
#import "MyTabBarController.h"
#import "MsgDetailsMixViewController.h"

@interface MemberListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MemberListViewController

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
//    if([_fromName isEqualToString:@"classDetail"]){
//    
//    }else{
//        [self setCustomizeRightButton:@"icon_sxbj.png"];
//    }
    [MyTabBarController setTabBarHidden:YES];
    [self setCustomizeRightButtonWithName:@"筛选"];

    [self setCustomizeLeftButton];
    //[self setCustomizeTitle:@"成员管理"];
    [self setCustomizeTitle:_titleName];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUI)
                                                 name:@"updateMemberList"
                                               object:nil];
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:@"-1" forKey:@"userTypeForFilter"];

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self getData:@"-1"];
    
    // 2015.06.24
    if (![_fromName isEqualToString:@"classDetail"]) {//从成员管理进入
        [ReportObject event:ID_OPEN_CLASS_MEMBER_LIST];//2015.06.24
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
   
}

-(void)updateUI{
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *typeFlag = [userdefaults objectForKey:@"userTypeForFilter"];
    [self getData:typeFlag];
    
    //---------------------------------------------
    //0:学生|6:家长|7:老师 2015.06.24
    if ([typeFlag integerValue] == 0) {
        [ReportObject event:ID_OPEN_CLASS_STUDENT_LIST];
    }else if ([typeFlag integerValue] == 7){
        [ReportObject event:ID_OPEN_CLASS_TEACHER_LIST];
    }else if([typeFlag integerValue] == 6){
        [ReportObject event:ID_OPEN_CLASS_PARENT_LIST];
    }
    //----------------------------------------------------
}

// 2016.03.16
-(void)refreshFilter:(NSString*)typeFlag{
    
    [self getData:typeFlag];
    
    //---------------------------------------------
    //0:学生|6:家长|7:老师 2015.06.24
    if ([typeFlag integerValue] == 0) {
        [ReportObject event:ID_OPEN_CLASS_STUDENT_LIST];
    }else if ([typeFlag integerValue] == 7){
        [ReportObject event:ID_OPEN_CLASS_TEACHER_LIST];
    }else if([typeFlag integerValue] == 6){
        [ReportObject event:ID_OPEN_CLASS_PARENT_LIST];
    }
    //----------------------------------------------------
}

// 进入成员筛选列表
-(void)selectRightAction:(id)sender{
    
//    ClassFilterViewController *classFilterV = [[ClassFilterViewController alloc]init];
//    classFilterV.fromName = @"selectUserType";
//    [self.navigationController pushViewController:classFilterV animated:YES];
    
    NSDictionary *dic0 = [NSDictionary dictionaryWithObjectsAndKeys:@"全部成员",@"name",@"-1",@"userTypeForFilter", nil];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"老师",@"name",@"7",@"userTypeForFilter", nil];
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:@"家长",@"name",@"6",@"userTypeForFilter", nil];
    tagArray = [[NSMutableArray alloc] initWithObjects:dic0,dic1,dic2, nil];
    
   
    if (!isRightButtonClicked) {
        
        
        viewMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height)];
        
        imageView_bgMask =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height-44)];
        [imageView_bgMask setBackgroundColor:[[UIColor alloc] initWithRed:93/255.0f green:106/255.0f blue:122/255.0f alpha:0.4]];
        imageView_bgMask.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
        [imageView_bgMask addGestureRecognizer:singleTouch];
        
        // 选项菜单
        imageView_rightMenu =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                          [UIScreen mainScreen].applicationFrame.size.width - 112 - 10,
                                                                          5,
                                                                          112,
                                                                          30.0*[tagArray count]+7)];
        imageView_rightMenu.contentMode = UIViewContentModeScaleToFill;
        
        if ([tagArray count] < 2) {
            [imageView_rightMenu setImage:[UIImage imageNamed:@"ClassKin/bg_contacts_one.png"]];
        }else{
            [imageView_rightMenu setImage:[UIImage imageNamed:@"ClassKin/bg_contacts_more.png"]];
        }
        
        
        [imageView_bgMask addSubview:imageView_rightMenu];
        
        for (int i=0; i<[tagArray count]; i++) {
            
            NSDictionary *tagDic = [tagArray objectAtIndex:i];
            //NSString *tagId = [NSString stringWithFormat:@"%@",[tagDic objectForKey:@"userTypeForFilter"]];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 600+i;
            button.frame = CGRectMake(imageView_rightMenu.frame.origin.x,imageView_rightMenu.frame.origin.y+7+(35.0-5.0)*i, 112, 35.0-5.0);
            [button setTitle:[tagDic objectForKey:@"name"] forState:UIControlStateNormal];
            [button setTitle:[tagDic objectForKey:@"name"] forState:UIControlStateHighlighted];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:174.0/255.0 green:221.0/255.0 blue:215.0/255.0 alpha:1] forState:UIControlStateHighlighted];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
            
            [button addTarget:self action:@selector(selectTag:) forControlEvents: UIControlEventTouchUpInside];
            
            UIImageView *lineV = [[UIImageView alloc] init];
            lineV.image = [UIImage imageNamed:@"ClassKin/bg_contacts_line.png"];
            lineV.frame = CGRectMake(10, button.frame.size.height-1, button.frame.size.width-20, 1);
            if (i<[tagArray count]-1) {
                [button addSubview:lineV];
            }
            
            [imageView_bgMask addSubview:button];
            
        }
        
        [viewMask addSubview:imageView_bgMask];
        
        [self.view addSubview:viewMask];
        
        isRightButtonClicked = true;
        
        
    }else{
        
        [viewMask removeFromSuperview];
        
        isRightButtonClicked = false;
        
    }

}

// 标签筛选
-(void)selectTag:(id)sender{
    
    UIButton *button = (UIButton*)sender;
    NSInteger i = button.tag - 600;
    
    [self dismissKeyboard:nil];
    
    NSString *typeId = [[tagArray objectAtIndex:i] objectForKey:@"userTypeForFilter"];
    //全部：-1 老师：7 家长：6
    
    [self refreshFilter:typeId];
    
}

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
-(void)getData:(NSString*)userType{
    
    [Utilities showProcessingHud:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 调用班级成员接口
        NSMutableArray *array = [FRNetPoolUtils getMembers:_cId role:userType];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities dismissProcessingHud:self.view];
            
            if (![Utilities isConnected]) {//2015.06.30
                UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
                [self.view addSubview:noNetworkV];
            }
            
            if (array == nil) {
                
                //[Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                if ([array count] > 0 ) {
                    //_tableView.hidden = NO;
                    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                    
                    [noDataView removeFromSuperview];//2015.09.23
                    
                }else{//2015.09.23
                    
                    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                    noDataView = [Utilities showNodataView:@"无筛选结果" msg2:@"" andRect:rect];
                    [self.view addSubview:noDataView];
                }
                
                listArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                
                //NSLog(@"listArray:%@",listArray);
                
                [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                
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
    static NSString *CellTableIdentifier = @"MemberTableViewCell";
    
    MemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        
//        cell = [[MemberTableViewCell alloc]
//                initWithStyle:UITableViewCellStyleDefault
//                reuseIdentifier:CellTableIdentifier];
        
        UINib *nib = [UINib nibWithNibName:@"MemberTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.delegte = self;
    
    
    
    NSString* head_url = [[listArray objectAtIndex:indexPath.row] objectForKey:@"avatar"];
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"bg_photo"]];
    cell.titleLabel.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    NSString *uid = [NSString stringWithFormat:@"%@",[[listArray objectAtIndex:indexPath.row] objectForKey:@"uid"]];

    
    if([_fromName isEqualToString:@"classDetail"]){
        
        cell.classMemberTypeLab.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"role"];
        cell.operateBtn.imageView.image = nil;
        cell.operateBtn.userInteractionEnabled = NO;
        cell.operateBtn.hidden = YES;// iOS8 必须这么写才能不显示按钮...
        
    }else{
        
      cell.userTypeLabel.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"role"];
        
        if([[Utilities getUniqueUidWithoutQuit] isEqualToString:uid]){
            
            [cell.operateBtn setBackgroundImage:nil forState:UIControlStateNormal];
            [cell.operateBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
            cell.operateBtn.userInteractionEnabled = NO;
            cell.operateBtn.hidden = YES;// iOS8 必须这么写才能不显示按钮...
            
        }else{
            
            [cell.operateBtn setBackgroundImage:[UIImage imageNamed:@"ClassKin/small_btnBg_normal.png"] forState:UIControlStateNormal];
            [cell.operateBtn setBackgroundImage:[UIImage imageNamed:@"ClassKin/small_btnBg_press.png"] forState:UIControlStateHighlighted];
            cell.operateBtn.hidden = NO;
            cell.operateBtn.userInteractionEnabled = YES;
        }
      
        
    }
    cell.headImgView.layer.masksToBounds = YES;
    cell.headImgView.layer.cornerRadius = cell.headImgView.frame.size.height/2.0;
    cell.index = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    
    
    return cell;
    
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    if([_fromName isEqualToString:@"classDetail"]){
#if 0
        NSDictionary *user = [g_userInfo getUserDetailInfo];
        NSString *selfUId= [user objectForKey:@"uid"];
        
        NSString *uid = [[listArray objectAtIndex:indexPath.row] objectForKey:@"uid"];
        
        if ([selfUId isEqualToString:uid]) {
            
            [self.view makeToast:@"只可查看他人的个人资料"
                        duration:0.5
                        position:@"center"
                           title:nil];

            
        }else{
            FriendProfileViewController *fpvc = [[FriendProfileViewController alloc]init];
            fpvc.fuid =  uid;
            [self.navigationController pushViewController:fpvc animated:YES];
        }
#endif
        
        NSDictionary *user = [g_userInfo getUserDetailInfo];
        NSString *selfUId= [user objectForKey:@"uid"];
        NSString *uid = [[listArray objectAtIndex:indexPath.row] objectForKey:@"uid"];
        if ([selfUId isEqualToString:uid]) {
            
            [self.view makeToast:@"只可与其他人聊天"
                        duration:0.5
                        position:@"center"
                           title:nil];
            
            
        }else{
            
            
            UserObject *user = [[UserObject alloc]init];
            
            NSDictionary *dic = [listArray objectAtIndex:indexPath.row];
            user.user_id = [[dic objectForKey:@"uid"] integerValue];
            user.name = [dic objectForKey:@"name"];
            user.headimgurl = [dic objectForKey:@"avatar"];
            
            [user updateToDB];
            
#if 0
            
            // 更改聊天列表的title
            NSString *updateListSql =[NSString stringWithFormat: @"update msgList set title = '%@' where user_id = %lli", user.name, user.user_id];
            [[DBDao getDaoInstance] executeSql:updateListSql];
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
            MsgDetailsViewController *chatDeatilController = [[MsgDetailsViewController alloc] init];
            chatDeatilController.user = user;
            chatDeatilController.frontName = @"user";
            [chatDeatilController getChatDetailData];
            [self.navigationController pushViewController:chatDeatilController animated:YES];
#endif
            
            [[DBDao getDaoInstance] createMsgInfoMixTable:0 userId:user.user_id];
            // 更改聊天列表的title
            NSString *updateListSql =[NSString stringWithFormat: @"update msgListMix set title = '%@' where user_id = %lli", user.name, user.user_id];
            [[DBDao getDaoInstance] executeSql:updateListSql];
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
            
            MsgDetailsMixViewController *chatDeatilController = [[MsgDetailsMixViewController alloc] init];
            chatDeatilController.user = user;
            chatDeatilController.titleName = user.name;
            [chatDeatilController getChatDetailData];
            [self.navigationController pushViewController:chatDeatilController animated:YES];
            
            
        }
        
    }
}

// 点击头像去他人的个人资料页
-(void)gotoSingleInfo:(NSString*)userIDIndex{
    
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    NSString *selfUId= [user objectForKey:@"uid"];
    
    NSString *uid = [[listArray objectAtIndex:[userIDIndex integerValue]] objectForKey:@"uid"];
    
    if ([selfUId isEqualToString:uid]) {
        
        [self.view makeToast:@"只可查看他人的个人资料"
                    duration:0.5
                    position:@"center"
                       title:nil];
        
        
    }else{
        
        FriendProfileViewController *fpvc = [[FriendProfileViewController alloc]init];
        fpvc.fuid =  uid;
        [self.navigationController pushViewController:fpvc animated:YES];
        
    }
    
    
}

// 移除成员callback方法
-(void)removeFromClass:(NSString*)userIDIndex{
    
    userIndex = userIDIndex;
    // 调用移除方法
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:@"您确定要移出该成员？"
                                                  delegate:self
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:@"取消",nil];
    alert.tag = 122;
    [alert show];

    
}

-(void)remove{
    
    [Utilities showProcessingHud:self.view];
    
    NSString *rid = [[listArray objectAtIndex:[userIndex integerValue]] objectForKey:@"uid"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 调用班级成员接口
        NSString *msg = [FRNetPoolUtils removeMember:rid cid:_cId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities dismissProcessingHud:self.view];
            
            if (msg != nil) {
                
                [Utilities showAlert:@"错误" message:msg cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
                NSString *typeFlag = [userdefaults objectForKey:@"userTypeForFilter"];
                [self getData:typeFlag];
            }
        });
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 122) {
        
        if (buttonIndex == 0) {
           
            [self remove];
            [ReportObject event:ID_REMOVE_CLASS_MEMBER];//2015.06.24
            
        }else{
            
        }
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
