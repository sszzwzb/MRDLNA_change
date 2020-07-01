//
//  LeftViewController.m
//  WWSideslipViewControllerSample
//
//  Created by 王维 on 14-8-26.
//  Copyright (c) 2014年 wangwei. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "LeftViewController.h"
#import "NormalTableViewCell.h"
#import "MessageCenterViewController.h"
#import "BaseViewController.h"
#import "MyPointsViewController.h"
#import "MomentsViewController.h"
#import "SchoolQRCodeViewController.h"
#import "AccountandPrivacyViewController.h"
#import "SettingViewController.h"

// 屏幕高度
#define HEIGHT [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface LeftViewController (){

 NSString *isNewVersion;
}

@end

@implementation LeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self createrView];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isNewVersion = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"zhixiao_isNewVersion"]];
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    bgView.image = [UIImage imageNamed:@"左侧菜单-bg"];
    [self.view addSubview:bgView];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//加载View实例化tableview
-(void)createrView{
    [self.view setBackgroundColor:[UIColor clearColor]];
    UITableView *leftTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, WIDTH, HEIGHT)];
    
    leftTableview.delegate = self;
    leftTableview.dataSource = self;
    [leftTableview setBackgroundColor:[UIColor clearColor]];
    leftTableview.separatorStyle = NO;
    leftTableview.scrollEnabled = NO;
    [self.view addSubview:leftTableview];
    
}
#pragma mark - UITableViewDataSource
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 3;
            break;
        default:
            break;
    }
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 100;
            break;
            
        default:
            break;
    }
    return 40;
}
//个人头像，姓名，账号
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        NSDictionary *namePwd = [[NSUserDefaults standardUserDefaults] objectForKey:G_NSUserDefaults_UserLoginInfo];
        NSString *username = [namePwd objectForKey:@"username"];
        UIView *topView = [[UIView alloc]init];
        [topView setFrame:[UIScreen mainScreen].bounds];
        topView.backgroundColor = [UIColor clearColor];
//ImageView
        UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(17, 20, 44, 44)];
        imageView.image = [UIImage imageNamed:@"btn_pz_p@2x"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 22;
        [topView addSubview:imageView];
//UserName
        UILabel *userName = [[UILabel alloc]initWithFrame:CGRectMake(70, 20, 150, 20)];
        userName.text = username;
        [userName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        userName.textColor = [UIColor blackColor];
        [topView addSubview:userName];
//UserID
        UILabel *userID = [[UILabel alloc]initWithFrame:CGRectMake(70, 40, 150, 30)];
        userID.text = @"账号：13164559381";
        userID.font = [UIFont systemFontOfSize:13];
        userID.textColor = [UIColor grayColor];
        [topView addSubview:userID];
        return topView;
    }else if (section ==1){
        UIView *secView = [[UIView alloc]init];
        [secView setFrame:[UIScreen mainScreen].bounds];
        secView.backgroundColor = [UIColor clearColor];
        return secView;
    }
    return nil;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]init];
    [footerView setFrame:[UIScreen mainScreen].bounds];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
      if (indexPath.section ==0){
        NSArray *nameArray = @[@"我的消息",@"我的动态",@"我的积分"];
        NSArray *imgName = @[@"左侧菜单_03",@"左侧菜单_06",@"左侧菜单_08"];
        static NSString *CellIdentifier = @"NormalTableViewCell";
        NSString *cellNib = @"NormalTableViewCell";
        NormalTableViewCell *cell = [ tableView dequeueReusableCellWithIdentifier: CellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:cellNib owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.leftImageView.image = [UIImage imageNamed:imgName[indexPath.row]];
        cell.rightImg.image = [UIImage imageNamed:@"左侧菜单-箭头_03"];
        cell.leftImageView.layer.masksToBounds = YES;
        cell.leftImageView.layer.cornerRadius =15;
        cell.leftLable.text = nameArray[indexPath.row];
        cell.leftLable.textColor = [UIColor whiteColor];
//cell设置为透明
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        return cell;
    }else if (indexPath.section ==1){
        NSArray *nameArray = @[@"校园二维码",@"账号安全",@"设置"];
        NSArray *imgName = @[@"左侧菜单_10.png",@"左侧菜单_12",@"左侧菜单_14"];
        static NSString *CellIdentifier = @"NormalTableViewCell";
        NSString *cellNib = @"NormalTableViewCell";
        NormalTableViewCell *cell = [ tableView dequeueReusableCellWithIdentifier: CellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:cellNib owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//cell设置为透明
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.leftImageView.image = [UIImage imageNamed:imgName[indexPath.row]];
        cell.leftImageView.layer.masksToBounds = YES;
        cell.leftImageView.layer.cornerRadius =15;
        cell.leftLable.text = nameArray[indexPath.row];
        cell.rightImg.image = [UIImage imageNamed:@"左侧菜单-箭头_03"];
        cell.leftLable.textColor = [UIColor whiteColor];
        return cell;
    }
    return nil;
  }
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"index:%@", @(indexPath.row));
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    NSMutableDictionary *user = [g_userInfo getUserDetailInfo];
    NSString *userType = [user objectForKey:@"role_id"];
    
    NSString *name = [[[_itemsArr objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]] objectForKey:@"name"];
//    section 0
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0://我的消息"
            {
                MessageCenterViewController *vc = [[MessageCenterViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1://我的动态
            {
                MomentsViewController *momentsV = [[MomentsViewController alloc]init];
                momentsV.titleName = @"我的动态";
                momentsV.fromName = @"mine";
                [self.navigationController pushViewController:momentsV animated:YES];
            }
                break;
            case 2://我的积分
            {
                if ([userType integerValue] == 7) {//教师
                    [ReportObject event:ID_CLICK_MYPOINT_TEACHER];
                }else if ([userType integerValue] == 9){//管理员
                    [ReportObject event:ID_CLICK_MYPOINT_ADMIN];
                }
                
                MyPointsViewController *myPoint = [[MyPointsViewController alloc]init];
                myPoint.titleName = name;
                [self.navigationController pushViewController:myPoint animated:YES];
            }
                break;
            default:
                break;
        }
    }else if (indexPath.section ==1){
        switch (indexPath.row) {
            case 0://校园二维码
            {
                SchoolQRCodeViewController *schoolQRVC = [[SchoolQRCodeViewController alloc] init];
                [self.navigationController pushViewController:schoolQRVC animated:YES];
            }
                break;
            case 1://账号安全
            {
                AccountandPrivacyViewController *accountandprivacy = [[AccountandPrivacyViewController alloc]init];
                [self.navigationController pushViewController:accountandprivacy animated:YES];
            }
                break;
            case 2://设置
            {
                
                SettingViewController *settingView = [[SettingViewController alloc]init];
                settingView.isNewVersion = isNewVersion;
                [self.navigationController pushViewController:settingView animated:YES];
            }
                break;
            default:
                break;
        }
    }
   }
@end
