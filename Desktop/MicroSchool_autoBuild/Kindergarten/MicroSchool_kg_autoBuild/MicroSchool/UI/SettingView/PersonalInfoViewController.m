//
//  PersonalInfoViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-7.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "MyTabBarController.h"

@interface PersonalInfoViewController ()

@end

@implementation PersonalInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)selectRightAction:(id)sender
{
    SetPersonalInfoViewController *setPersonalViewCtrl = [[SetPersonalInfoViewController alloc] init];
    [self.navigationController pushViewController:setPersonalViewCtrl animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [MyTabBarController setTabBarHidden:YES];
    if (![@""  isEqual: [infoDic objectForKey:@"birthStr"]]) {
        [self doShowUserInfo];
    }
    
    [super hideLeftAndRightLine];
    
    // 导航右菜单，编辑
    [super setCustomizeRightButton:@"icon_edit_forums.png"];
    [super setCustomizeLeftButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [super setCustomizeTitle:@"个人资料"];
    
    // 导航右菜单，编辑
    [super setCustomizeRightButton:@"icon_edit_forums.png"];
    [super setCustomizeLeftButton];
    
    [Utilities showProcessingHud:self.view];
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

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    
    // 背景图片
    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height)];
    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    [self.view addSubview:imgView_bgImg];

    // 设置背景scrollView
    UIScrollView* scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH , [UIScreen mainScreen].applicationFrame.size.height - 44)];
    if (iPhone5) {
        scrollerView.contentSize = CGSizeMake(WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44);
    } else {
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        {
            scrollerView.contentSize = CGSizeMake(WIDTH, [UIScreen mainScreen].applicationFrame.size.height + 55);
        }
        else
        {
            scrollerView.contentSize = CGSizeMake(WIDTH, [UIScreen mainScreen].applicationFrame.size.height + 25);
        }
    }
    scrollerView.scrollEnabled = YES;
    scrollerView.delegate = self;
    scrollerView.bounces = YES;
    scrollerView.alwaysBounceHorizontal = NO;
    scrollerView.alwaysBounceVertical = YES;
    scrollerView.directionalLockEnabled = YES;
    [self.view addSubview:scrollerView];

    // 头像背景图片
    UIImageView *image_head_bg =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                             15,15,70,70)];
//    image_head_bg.image=[UIImage imageNamed:@"bg_photo.png"];
//    image_head_bg.layer.masksToBounds = YES;
//    image_head_bg.layer.cornerRadius = 70/2;
//    image_head_bg.contentMode = UIViewContentModeScaleToFill;
//    [scrollerView addSubview:image_head_bg];

    // 头像
    image_head =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                             15,15,70,70)];
//                                                             image_head_bg.frame.origin.x + 4,
//                                                             image_head_bg.frame.origin.y + 4,
//                                                             image_head_bg.frame.size.width - 8,
//                                                             image_head_bg.frame.size.height - 8)];
    image_head.layer.masksToBounds = YES;
    image_head.layer.cornerRadius = 70/2;
    image_head.contentMode = UIViewContentModeScaleToFill;
    [scrollerView addSubview:image_head];
    
    // 性别icon
    imgView_gender =[[UIImageView alloc]initWithFrame:CGRectMake(
                                            image_head_bg.frame.origin.x + image_head_bg.frame.size.width + 10,
                                                                 image_head_bg.frame.origin.y + 5,
                                                                 20,
                                                                 20)];
    [scrollerView addSubview:imgView_gender];

    // 姓名
    label_name = [[UILabel alloc] initWithFrame:CGRectMake(
                                                           imgView_gender.frame.origin.x + imgView_gender.frame.size.width + 3,
                                                           imgView_gender.frame.origin.y,
                                                           280,
                                                           20)];
    
    label_name.textColor = [UIColor blackColor];
    label_name.backgroundColor = [UIColor clearColor];
    label_name.font = [UIFont systemFontOfSize:16.0f];
    [scrollerView addSubview:label_name];
    
    // 个性签名
    label_sign = [[UILabel alloc] initWithFrame:CGRectMake(
                                                           imgView_gender.frame.origin.x,
                                                           imgView_gender.frame.origin.y + imgView_gender.frame.size.height + 5,
                                                           
                                                           200, 20)];
    label_sign.textColor = [UIColor grayColor];
    label_sign.font = [UIFont systemFontOfSize:12.0f];
    label_sign.backgroundColor = [UIColor clearColor];
    label_sign.lineBreakMode = NSLineBreakByTruncatingTail;
    [scrollerView addSubview:label_sign];

    // tableview
    if (iPhone5) {
        tableViewIns = [[UITableView alloc]initWithFrame:CGRectMake(
                                                                    0,
                                                                    image_head_bg.frame.origin.y + image_head_bg.frame.size.height - 10,
                                                                    WIDTH,
                                                                    scrollerView.frame.size.height) style:UITableViewStyleGrouped];
    }
    else {
        tableViewIns = [[UITableView alloc]initWithFrame:CGRectMake(
                                                                    0,
                                                                    image_head_bg.frame.origin.y + image_head_bg.frame.size.height,
                                                                    WIDTH,
                                                                    scrollerView.frame.size.height) style:UITableViewStyleGrouped];
    }
    tableViewIns.delegate = self;
    tableViewIns.dataSource = self;
    [tableViewIns setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    tableViewIns.backgroundColor = [UIColor clearColor];
    tableViewIns.scrollEnabled = NO;
    tableViewIns.backgroundView = nil;
    
    [scrollerView addSubview:tableViewIns];
    
    [self doShowUserInfo];
//    [self performSelector:@selector(doGetProfile) withObject:nil afterDelay:0.2];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    if ([@"7"  isEqual: [infoDic objectForKey:@"usertype"]]) {
        return 1;
    } else {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    if ([@"7"  isEqual: [infoDic objectForKey:@"usertype"]]) {
        if (0 == section) {
            return 4;
        }
    } else {
        if (0 == section) {
            return 1;
        } else if (1 == section) {
            return 4;
        }
    }

    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定行的高度
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
     cell.detailTextLabel.font = [UIFont systemFontOfSize:17.0];
    
    if ([@"7"  isEqual: [infoDic objectForKey:@"usertype"]]) {
        if (0 == [indexPath section] && 0 == [indexPath row]) {
            cell.textLabel.text = @"生日";
            cell.detailTextLabel.text = [infoDic objectForKey:@"birthStr"];
        }else if (0 == [indexPath section] && 1 == [indexPath row]){
            cell.textLabel.text = @"家乡";
            cell.detailTextLabel.text = [infoDic objectForKey:@"homeTownStr"];
        }else if (0 == [indexPath section] && 2 == [indexPath row]){
            cell.textLabel.text = @"居住地";
            cell.detailTextLabel.text = [infoDic objectForKey:@"liveStr"];
        }else if (0 == [indexPath section] && 3 == [indexPath row]){
            cell.textLabel.text = @"血型";
            cell.detailTextLabel.text = [infoDic objectForKey:@"bloodStr"];
        }else{
            return nil;
        }
    } else {
        if (0 == [indexPath section] && 0 == [indexPath row]) {
            cell.textLabel.text = @"身份证号";
            cell.detailTextLabel.text = [infoDic objectForKey:@"studentid"];
        }else if (1 == [indexPath section] && 0 == [indexPath row]) {
            cell.textLabel.text = @"生日";
            cell.detailTextLabel.text = [infoDic objectForKey:@"birthStr"];
        }else if (1 == [indexPath section] && 1 == [indexPath row]){
            cell.textLabel.text = @"家乡";
            cell.detailTextLabel.text = [infoDic objectForKey:@"homeTownStr"];
        }else if (1 == [indexPath section] && 2 == [indexPath row]){
            cell.textLabel.text = @"居住地";
            cell.detailTextLabel.text = [infoDic objectForKey:@"liveStr"];
        }else if (1 == [indexPath section] && 3 == [indexPath row]){
            cell.textLabel.text = @"血型";
            cell.detailTextLabel.text = [infoDic objectForKey:@"bloodStr"];
        }else{
            return nil;
        }
    }

    //设置textLabel的背景色为空
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
}

-(void)doShowUserInfo
{
    [Utilities dismissProcessingHud:self.view];

    NSDictionary *message_info = [g_userInfo getUserDetailInfo];
    
    NSString *usertype = [NSString stringWithFormat:@"%@", [message_info objectForKey:@"role_id"]];

    // 拼接入学年份，班级，@"身份证号"
    NSString *class = [message_info objectForKey:@"role_classname"];
    if ([@""  isEqual: class]) {
        class = @"(未加入班级)";
    }
    
    NSString *studentid = [message_info objectForKey:@"studentid"];
    
    // 拼接生日，家乡，住址，血型str
    NSString* birthyear = [message_info objectForKey:@"birthyear"];
    NSString* birthmonth = [message_info objectForKey:@"birthmonth"];
    NSString* birthday = [message_info objectForKey:@"birthday"];
    NSString *birthStr = [NSString stringWithFormat:@"%@年 %@月 %@日", birthyear, birthmonth, birthday];
    
    NSString* birthprovince = [message_info objectForKey:@"birthprovince"];
    NSString* birthcity = [message_info objectForKey:@"birthcity"];
    NSString *homeTownStr;
    if ([@""  isEqual: birthcity]) {
        homeTownStr = @"";
    } else {
        homeTownStr = [NSString stringWithFormat:@"%@ %@", birthprovince, birthcity];
    }
    //NSString *homeTownStr = [NSString stringWithFormat:@"%@ %@", birthprovince, birthcity];
    
    NSString* resideprovince = [message_info objectForKey:@"resideprovince"];
    NSString* residecity = [message_info objectForKey:@"residecity"];
    NSString *liveStr;
    if ([@""  isEqual: residecity]) {
        liveStr = @"";
    } else {
        liveStr = [NSString stringWithFormat:@"%@ %@", resideprovince, residecity];
    }
    //NSString *liveStr = [NSString stringWithFormat:@"%@ %@", resideprovince, residecity];
    
    NSString* blood = [message_info objectForKey:@"blood"];
    NSString *bloodStr = [NSString stringWithFormat:@"%@ 型", blood];
    
    infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:
               birthStr,@"birthStr",
               homeTownStr,@"homeTownStr",
               liveStr,@"liveStr",
               bloodStr,@"bloodStr",
//               yeargradeStr,@"yeargradeStr",
               class,@"classStr",
               studentid,@"studentid",
               usertype,@"usertype",
               nil];
    
    NSString* uid = [message_info objectForKey:@"uid"];
    NSString* sex = [message_info objectForKey:@"sex"];
    NSString* username = [message_info objectForKey:@"name"];
    NSString* spacenote = [message_info objectForKey:@"spacenote"];
    NSString* title = [message_info objectForKey:@"role_name"];

    // 头像
    //---update by kate 2014.11.14------------------------------------------------------------------
    //Utilities *util = [Utilities alloc];
    //NSString* head_url = [util getAvatarFromUid:[NSString stringWithFormat:@"%@", uid] andType:@"1"];
    NSString* head_url = [message_info objectForKey:@"avatar"];
    [image_head sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];
    //------------------------------------------------------------------------------------------
    
    // 性别
    if ([@"1"  isEqual: sex]) {
        [imgView_gender setImage:[UIImage imageNamed:@"icon_male.png"]];
    }
    else {
        [imgView_gender setImage:[UIImage imageNamed:@"icon_female.png"]];
    }
    
    // 名字
    username = [[username stringByAppendingString:@"|"] stringByAppendingString:title];
    label_name.text = username;
    
    // 签名
    if ([@""  isEqual: spacenote]) {
        spacenote = @"（您还没有设置个性签名）";
        label_sign.textColor = [UIColor blueColor];
    }else {
        label_sign.textColor = [UIColor blackColor];
    }
    label_sign.text = spacenote;
    
    // 重新刷新tableview
    [tableViewIns reloadData];
}

@end
