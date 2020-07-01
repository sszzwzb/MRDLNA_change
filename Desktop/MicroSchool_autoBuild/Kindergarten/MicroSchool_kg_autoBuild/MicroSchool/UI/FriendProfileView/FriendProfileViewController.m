//
//  FriendProfileViewController.m
//  MicroSchool
//
//  Created by jojo on 14/10/23.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "FriendProfileViewController.h"
#import "ParenthoodListForParentTableViewController.h"
#import "PersonalProfileViewController.h"
#import "MomentsViewController.h"

@interface FriendProfileViewController ()

@end

@implementation FriendProfileViewController

extern BOOL isScan;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
//    infoDic = [[NSMutableDictionary alloc] init];
//    profileIinfoArray = [[NSMutableArray alloc] init];
//    childrenArray = [[NSMutableArray alloc]init];

//    [super setCustomizeTitle:@"个人资料"];
//    [super setCustomizeLeftButton];
    
    // 后续扩展打开该注释
    //[self setCustomizeRightButtonWithName:@"icon_more.png"];

    g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;

    
    isBinded = NO;
    _changeCircleHiddenStatus = NO;

    
    [ReportObject event:ID_OPEN_USER_DETAIL];//2015.06.24
    

    
    
//    if ([_fromName isEqualToString:@"scan"]) {
//        [super setCustomizeTitle:@"个人资料"];
//        [super setCustomizeLeftButton];
//    }else {
#if 1
        
        CGRect frame = self.navigationController.navigationBar.frame;
        _alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height+20)];
        //    _alphaView.backgroundColor = [UIColor blueColor];
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height+20)];
        [imgV setImage:[UIImage imageNamed:@"bg_img.png"]];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   0,
                                                                   32,
                                                                   [UIScreen mainScreen].bounds.size.width,
                                                                   20)];
        title.textColor = [UIColor whiteColor];
        title.backgroundColor = [UIColor clearColor];
        title.textAlignment = NSTextAlignmentCenter;
        
        title.font = [UIFont boldSystemFontOfSize:17];
        title.text = @"个人资料";
        
        [_alphaView addSubview:imgV];
        [_alphaView addSubview:title];
        
        _alphaView.alpha = 0.0;
        
        [self.view insertSubview:_alphaView belowSubview:self.navigationController.navigationBar];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"CommonIconsAndPics/bigShadow.png"] forBarMetrics:UIBarMetricsCompact];
        //    self.navigationController.navigationBar.layer.masksToBounds = YES;
        
#endif
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setBackgroundColor:[UIColor clearColor]];
        leftButton.frame = CGRectMake(0, 25, 33, 33);
        [leftButton setImage:[UIImage imageNamed:@"leftBarButtonItem"] forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed:@"leftBarButtonItem"] forState:UIControlStateSelected];
        [leftButton addTarget:self action:@selector(selectLeftAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:leftButton];
//    }
    

    if (iPhone4) {
        _imgView_default =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,230)];
    }else {
        _imgView_default =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,230)];
    }
    
    [_imgView_default setImage:[UIImage imageNamed:@"personalInfo/bg"]];
    
    if (![_fromName isEqualToString:@"scan"]) {
        [self.view addSubview:_imgView_default];
    }

    UIButton *leftButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton1 setBackgroundColor:[UIColor clearColor]];
    leftButton1.frame = CGRectMake(0, 25, 33, 33);
    [leftButton1 setImage:[UIImage imageNamed:@"leftBarButtonItem"] forState:UIControlStateNormal];
    [leftButton1 setImage:[UIImage imageNamed:@"leftBarButtonItem"] forState:UIControlStateSelected];
    [leftButton1 addTarget:self action:@selector(selectLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_imgView_default addSubview:leftButton1];

    [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.1];

//    BOOL isConnect = [Utilities connectedToNetwork];
//    if (isConnect) {
//        [Utilities showProcessingHud:self.view];// 2015.05.12
//    }

}


//刷新调用的方法
-(void)refreshView
{
    
}


-(void)setAlph{
        if (_alphaView.alpha == 0.0 ) {
            [UIView animateWithDuration:0.5 animations:^{
                _alphaView.alpha = 1.0;
            } completion:^(BOOL finished) {
            }];
        }else{
            [UIView animateWithDuration:0.5 animations:^{
                _alphaView.alpha = 0.0;
            } completion:^(BOOL finished) {
                
            }];
        }
    }

    

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];

//    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:0.100];
//    // 透明度设置为0.3
//    self.navigationController.navigationBar.alpha = 0.00;
//    // 设置为半透明
//    self.navigationController.navigationBar.translucent = YES;
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

-(void)selectLeftAction:(id)sender
{
    [self changeCircleHiddenStatus];
    
    // 取消所有的网络请求
    [network cancelCurrentRequest];

    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0){
      
        if ([_fromName isEqualToString:@"scan"]) {
        isScan = YES;
        }
    }
    
    _scrollerView.delegate = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}

- (void)changeCircleHiddenStatus {
    if (_changeCircleHiddenStatus) {
        /**
         * 屏蔽某人不看ta的师生圈
         * @author luke
         * @date 2016.12.01
         * @args
         *  v=3 ac=Circle op=block sid=5303 uid=49439 friend=1
         */

        /**
         * 解除对某些人的屏蔽,
         * friends=uid,... 多用户逗号分隔
         * @author luke
         * @date 2016.12.01
         * @args
         *  v=3 ac=Circle op=unblock sid=5303 uid=49439 friends=1,2,3.....
         */
        
        [Utilities showProcessingHud:self.view];
        
        NSString *op = @"";
        NSString *friendStr = @"friend";
        if (_circleHiddenStatus) {
            // 打开
            op = @"block";
        }else {
            // 关闭
            op = @"unblock";
            friendStr = @"friends";
        }

        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"Circle",@"ac",
                              @"3",@"v",
                              op, @"op",
                              _fuid, friendStr,
                              nil];
        
        [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
            NSDictionary *respDic = (NSDictionary*)responseObject;
            NSString *result = [respDic objectForKey:@"result"];
            
            if(true == [result intValue]) {

            }else {
                
            }
        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        }];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    network = [NetworkUtility alloc];
    network.delegate = self;
    


    infoDic = [[NSMutableDictionary alloc] init];
    profileIinfoArray = [[NSMutableArray alloc] init];
    childrenArray = [[NSMutableArray alloc]init];

    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;

    _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].applicationFrame.size.height+20 )];
    NSLog(@"height:%f",_scrollerView.frame.size.height);

    if (iPhone5)
    {
        _scrollerView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].applicationFrame.size.height - 44);
    }
    else
    {
        _scrollerView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].applicationFrame.size.height - 44);
    }
    //_scrollerView.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0];
    _scrollerView.scrollEnabled = YES;
    _scrollerView.delegate = self;
    [self.view addSubview:_scrollerView];

//    [_scrollerView addSubview:delBtn];

//    int sectionHeaderHeight = 30 * [profileIinfoArray count];
//    int rowHeight = 0;
//
//    for (int i=0; i<[profileIinfoArray count]; i++) {
//        NSDictionary *dic = [profileIinfoArray objectAtIndex:i];
//        int count = [[dic objectForKey:@"fields"] count];
//        
//        rowHeight = rowHeight + 50*count;
//    }
//    
//    _scrollerView.contentSize = CGSizeMake(320, _tableView.tableHeaderView.frame.size.height + sectionHeaderHeight + rowHeight + 30);

//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height +200) style:UITableViewStylePlain];
//    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
//    
//    
////    UIImageView *imgView_bg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].applicationFrame.size.width,[UIScreen mainScreen].applicationFrame.size.height - 44)];
////    [imgView_bg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
//    
//    //_tableView.backgroundView = imgView_bg;
//    _tableView.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0];
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    _tableView.scrollEnabled = NO;
//
//    [_scrollerView addSubview:_tableView];
//    
   
    if ([_fromName isEqualToString:@"scan"]) {
        
        [self refreshViewByCode:_infoDic];
        
    }else{
        
        if (![Utilities isConnected]) {
            
            UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
            [self.view addSubview:noNetworkV];
            return;
            
        }
        
        BOOL isConnect = [Utilities connectedToNetwork];
        if (isConnect) {
            [Utilities showProcessingHud:self.view];// 2015.05.12
        }

        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Friend", @"ac",
                              @"viewFriendProfile", @"op",
                              _fuid, @"fuid",
                              _fsid, @"school",
                              nil];
        
        [network sendHttpReq:HttpReq_ViewFriendProfile andData:data];
        
    }
    

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)doShowHeadView
{
    self.view.backgroundColor = [UIColor blackColor];

    headerView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 [UIScreen mainScreen].bounds.size.width,
                                                                 230)];

    
    // 背景图片
    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,230)];
    [imgView_bgImg setImage:[UIImage imageNamed:@"personalInfo/bg"]];
    [headerView addSubview:imgView_bgImg];

    imgView_head =[[UIImageView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-70)/2-2,100-2,70+4,70+4)];
    imgView_head.layer.masksToBounds = YES;
    imgView_head.layer.cornerRadius = imgView_head.frame.size.width/2;
    imgView_head.contentMode = UIViewContentModeScaleToFill;
    [imgView_head setImage:[UIImage imageNamed:@"personalInfo/headBG"]];
    [headerView addSubview:imgView_head];

    // 头像图片
    btn_thumb = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_thumb.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-70)/2,100,70,70);
    [btn_thumb addTarget:self action:@selector(touchImgHeadAction) forControlEvents:UIControlEventTouchDown];
    btn_thumb.layer.masksToBounds = YES;
    btn_thumb.layer.cornerRadius = 70/2;
    btn_thumb.contentMode = UIViewContentModeScaleToFill;
    [btn_thumb sd_setImageWithURL:[NSURL URLWithString:[infoDic objectForKey:@"avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    [btn_thumb sd_setImageWithURL:[NSURL URLWithString:[infoDic objectForKey:@"avatar"]] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];

    [headerView addSubview:btn_thumb];
    
    
    
    // 姓名
    CGSize size = [Utilities getStringHeight:[infoDic objectForKey:@"name"] andFont:[UIFont systemFontOfSize:16.0f] andSize:CGSizeMake(0, 20)];

    label_name = [[UILabel alloc] initWithFrame:CGRectMake(
                                                           ([UIScreen mainScreen].bounds.size.width-size.width)/2,
                                                           btn_thumb.frame.origin.y + btn_thumb.frame.size.height + 10,
                                                           size.width,
                                                           20)];
    label_name.textColor = [UIColor whiteColor];
    label_name.backgroundColor = [UIColor clearColor];
    label_name.font = [UIFont systemFontOfSize:16.0f];
    label_name.text = [infoDic objectForKey:@"name"];
    label_name.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:label_name];
    
    // 性别icon
    imgView_gender =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                 label_name.frame.origin.x + label_name.frame.size.width + 5,
                                                                 label_name.frame.origin.y+3,15,15)];
    if ([@"2"  isEqual: [infoDic objectForKey:@"sex"]]) {
        imgView_gender.image=[UIImage imageNamed:@"personalInfo/female"];
    }else {
        imgView_gender.image=[UIImage imageNamed:@"personalInfo/male"];
    }
    [headerView addSubview:imgView_gender];

    
    tableHeaderViewHeight = label_sign.frame.origin.y + label_sign.frame.size.height + 10;
    
    tableHeaderViewHeight = 500;
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height-1, [[UIScreen mainScreen] bounds].size.width, 1)];
    lineV.backgroundColor = [UIColor lightGrayColor];
    lineV.alpha = 0.5;
    [headerView addSubview:lineV];
    
//    // 下方按钮
//    btn_click = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn_click.frame = CGRectMake(30, [UIScreen mainScreen].applicationFrame.size.height - 120, 260, 40);
//
//    btn_click.titleLabel.textAlignment = NSTextAlignmentCenter;
//    
//    // 设置title自适应对齐
//    btn_click.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    
//    // 设置颜色和字体
//    [btn_click setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn_click setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    btn_click.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
//    [btn_click setBackgroundImage:[UIImage imageNamed:@"btn_common_2-d.png"] forState:UIControlStateNormal] ;
//    [btn_click setBackgroundImage:[UIImage imageNamed:@"btn_common_2_p.png"] forState:UIControlStateHighlighted] ;
//    
//    // 添加 action
//    [btn_click addTarget:self action:@selector(click_btnclick:) forControlEvents: UIControlEventTouchUpInside];
//    
//    if (false == [[infoDic objectForKey:@"friend"] intValue]) {
//        //设置title
//        [btn_click setTitle:@"加为好友" forState:UIControlStateNormal];
//        [btn_click setTitle:@"加为好友" forState:UIControlStateHighlighted];
//    }else {
//        //设置title
//        [btn_click setTitle:@"发消息" forState:UIControlStateNormal];
//        [btn_click setTitle:@"发消息" forState:UIControlStateHighlighted];
//    }
//
//    [_scrollerView addSubview:btn_click];
}

- (IBAction)click_btnclick:(id)sender
{

}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    NSArray *arr = [_itemsArr objectAtIndex:section];
    count = [arr count];

    return count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_itemsArr count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = [_itemsArr objectAtIndex:[indexPath section]];

    NSString *name = [[arr objectAtIndex:[indexPath row]] objectForKey:@"name"];
    if ([@"个性签名"  isEqual: name]) {
        if ([[[UIDevice currentDevice]systemVersion]floatValue] < 8.0) {
            return 30 + _spacenoteHeight - 19;
        }else {
            return 30 + _spacenoteHeight;
        }
    }else if ([@"亲子关系"  isEqual: name]) {
        if ([[[UIDevice currentDevice]systemVersion]floatValue] < 8.0) {
            return 30 + _parentHeight - 19;
        }else {
            return 30 + _parentHeight;
        }

    }else {
        return 50;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return 20;
    }else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (1 == section) {
        return 10;
    }else {
        return 10;
    }
}

- (void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch *)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    _changeCircleHiddenStatus = YES;
    if (isButtonOn) {
        // 打开
        _circleHiddenStatus = YES;
    }else {
        // 关闭
        _circleHiddenStatus = NO;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    
    FriendProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    if (cell == nil) {
        cell = [[FriendProfileTableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:CellTableIdentifier];
    }
    
    NSArray *arr = [_itemsArr objectAtIndex:[indexPath section]];
    
    NSString *name = [[arr objectAtIndex:[indexPath row]] objectForKey:@"name"];
    cell.label_name.text = [[arr objectAtIndex:[indexPath row]] objectForKey:@"name"];

    if ([@"不看Ta的师生圈" isEqualToString:name]) {
        cell.label_name.frame = CGRectMake(15, 10, 120, 30);
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        UISwitch *push = [[UISwitch alloc] init];
        
        // friend 0 未屏蔽， 1 屏蔽
        if (!_circleHiddenStatus) {
            push.on = NO;
        }else {
            push.on = YES;
        }

        [push addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = push;

    }else {
        cell.label_name.frame = CGRectMake(15, 10, 60, 30);

        // 为需要加indicator的项目添加上
        if ([@"0"  isEqual: [[arr objectAtIndex:[indexPath row]] objectForKey:@"indicator"]]) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [infoDic objectForKey:@"name"];
            
            NSString *childrenStr = @"";
            
            if ([@"本校身份"  isEqual: name]) {
                NSString *title = [infoDic objectForKey:@"title"];
                if ([@""  isEqual: title] || (nil == title)) {
                    title = @"无";
                }
                cell.label_detail.text = title;
            }else if ([@"所在班级"  isEqual: name]) {
                NSString *classname = [infoDic objectForKey:@"classname"];
                if ([@""  isEqual: classname] || (nil == classname)) {
                    classname = @"未加入";
                }
                cell.label_detail.text = classname;
            }else if ([@"所在学校"  isEqual: name]) {
                NSString *schoolname = [infoDic objectForKey:@"schoolname"];
                if ([@""  isEqual: schoolname] || (nil == schoolname)) {
                    schoolname = @"未加入";
                }
                cell.label_detail.text = schoolname;
            }else if ([@"个性签名"  isEqual: name]) {
                NSString *spacenote = [infoDic objectForKey:@"spacenote"];
                if ([@""  isEqual: spacenote] || (nil == spacenote)) {
                    spacenote = @"未设置";
                }
                cell.label_detail.text = spacenote;
            }else if ([@"本校职务"  isEqual: name] || [@"职务"  isEqual: name]) {
                NSString *title = [infoDic objectForKey:@"duty"];
                if ([@""  isEqual: title] || (nil == title)) {
                    title = @"未设置";
                }
                cell.label_detail.text = title;
            }else if ([@"任教学科"  isEqual: name]) {
                NSString *subject = [infoDic objectForKey:@"subject"];
                if ([@""  isEqual: subject] || (nil == subject)) {
                    subject = @"未设置";
                }
                cell.label_detail.text = subject;
            }else if ([@"亲子关系"  isEqual: name]) {
                NSArray *children = [infoDic objectForKey:@"children"];
                
                if (0 == [children count]) {
                    childrenStr = @"未绑定";
                }else {
                    for (NSDictionary *dic in children) {
                        if ([@""  isEqual: childrenStr]) {
                            childrenStr = [NSString stringWithFormat:@"%@", [dic objectForKey:@"name"]];
                        }else {
                            childrenStr = [NSString stringWithFormat:@"%@\n%@", childrenStr, [dic objectForKey:@"name"]];
                        }
                    }
                }
                
                cell.label_detail.text = childrenStr;
            }
            
            if ([@"个性签名"  isEqual: name]) {
                // 计算个性签名的高度
                NSString *spacenote = [infoDic objectForKey:@"spacenote"];
                CGSize size = [Utilities getStringHeight:spacenote andFont:[UIFont systemFontOfSize:15.0f] andSize:CGSizeMake(220, 0)];
                
                if ([[[UIDevice currentDevice]systemVersion]floatValue] < 8.0) {
                    size.height = size.height - 19;
                }
                
                cell.label_detail.frame = CGRectMake(
                                                     cell.label_name.frame.origin.x + cell.label_name.frame.size.width + 20,
                                                     cell.label_name.frame.origin.y, [UIScreen mainScreen].bounds.size.width-100, size.height + 12);
                
                cell.label_detail.lineBreakMode = NSLineBreakByWordWrapping;
                cell.label_detail.numberOfLines = 0;
            }
            
            if ([@"亲子关系"  isEqual: name]) {
                // 计算亲子关系的高度
                CGSize size = [Utilities getStringHeight:childrenStr andFont:[UIFont systemFontOfSize:15.0f] andSize:CGSizeMake(220, 0)];
                
                if ([[[UIDevice currentDevice]systemVersion]floatValue] < 8.0) {
                    size.height = size.height - 19;
                }
                
                cell.label_detail.frame = CGRectMake(
                                                     cell.label_name.frame.origin.x + cell.label_name.frame.size.width + 20,
                                                     cell.label_name.frame.origin.y, [UIScreen mainScreen].bounds.size.width-100, size.height + 12);
                
                cell.label_detail.lineBreakMode = NSLineBreakByWordWrapping;
                cell.label_detail.numberOfLines = 0;
            }
            
            //        cell.label_detail.frame = CGRectMake(
            //                                             cell.label_name.frame.origin.x + cell.label_name.frame.size.width + 20,
            //                                             cell.label_name.frame.origin.y, 320-80, 30);
            //        cell.label_detail.textColor = [UIColor blackColor];
            
        }else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            
            cell.label_detail.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-62, 8, 32, 32);
            cell.label_detail.textColor = [UIColor darkGrayColor];
            cell.label_detail.text = @"查看";
        }
    }
    
    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失

    NSArray *arr = [_itemsArr objectAtIndex:[indexPath section]];
    NSString *name = [[arr objectAtIndex:[indexPath row]] objectForKey:@"name"];
    
    if ([@"详细资料"  isEqual: name]) {
        PersonalProfileViewController *ppv = [[PersonalProfileViewController alloc]init];
        ppv.fromName = @"profile";
        ppv.listArray = [infoDic objectForKey:@"privacy"];
        ppv.isFriend = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"friend"]];
        [self.navigationController pushViewController:ppv animated:YES];
    }else if ([@"个人动态"  isEqual: name]) {
        MomentsViewController *momentsV = [[MomentsViewController alloc] init];
        momentsV.fuid = _fuid;
        
        NSString* uid= [[g_userInfo getUserDetailInfo] objectForKey:@"uid"];
        if ([_fuid isEqualToString: uid]) {
            momentsV.fromName = @"mine";
        }else {
            momentsV.fromName = @"other";
        }
        
        momentsV.titleName = @"个人动态";
        [self.navigationController pushViewController:momentsV animated:YES];
    }
    
    

    
    
#if 0
    if (indexPath.row == 0) {// 详细资料

        
//        SubUINavigationController *nav = (SubUINavigationController *)self.navigationController;
//        [nav setAlph];

        
        [self setAlph];
//        PersonalProfileViewController *ppv = [[PersonalProfileViewController alloc]init];
//        ppv.fromName = @"profile";
//        ppv.listArray = [infoDic objectForKey:@"privacy"];
//        ppv.isFriend = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"friend"]];
//        [self.navigationController pushViewController:ppv animated:YES];
        
    }else if (indexPath.row == 1){// 个人动态
        
        MomentsViewController *momentsV = [[MomentsViewController alloc] init];
        momentsV.fuid = _fuid;

        NSString* uid= [[g_userInfo getUserDetailInfo] objectForKey:@"uid"];
        if ([_fuid isEqualToString: uid]) {
            momentsV.fromName = @"mine";
        }else {
            momentsV.fromName = @"other";
        }

        momentsV.titleName = @"个人动态";
        [self.navigationController pushViewController:momentsV animated:YES];
        
    }else{// 子女情况
        
        PersonalProfileViewController *ppv = [[PersonalProfileViewController alloc]init];
        ppv.fromName = @"parenthood";
        ppv.listArray = [infoDic objectForKey:@"children"];
        [self.navigationController pushViewController:ppv animated:YES];

    }
#endif
}

-(void)clickButton:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    
    if (btn.tag == 0) {
        
        if ([@"scan" isEqualToString:_fromName]) {
            // 亲子关系绑定事件
            // 989a21
            
            NSString *bind = [infoDic objectForKey:@"bind"];
            if([bind intValue] == 1){
            
            }else{
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      REQ_URL, @"url",
                                      @"Parenthood", @"ac",
                                      @"2",@"v",
                                      @"pair", @"op",
                                      _code, @"code",
                                      nil];
                
                [network sendHttpReq:HttpReq_BindParenthood andData:data];
            }
            
        }else{
        
            // 发消息 或者 加好友
            
            if (false == [[infoDic objectForKey:@"friend"] intValue]) {
                // 加好友
                if ([@"2"  isEqual: [infoDic objectForKey:@"authority"]]) {
                    // 需要验证
                    FriendAddReqViewController *friendAddViewCtrl = [[FriendAddReqViewController alloc] init];
                    friendAddViewCtrl.uid = [infoDic objectForKey:@"uid"];
                    friendAddViewCtrl.name = [infoDic objectForKey:@"name"];
                    [self.navigationController pushViewController:friendAddViewCtrl animated:YES];
                    
                }else if([@"3"  isEqual: [infoDic objectForKey:@"authority"]]) {
                    // 拒绝添加好友
                    [Utilities showTextHud:@"对方拒绝任何人的添加好友请求。" descView:self.view];
                }else if([@"1"  isEqual: [infoDic objectForKey:@"authority"]]) {
                    // 任何人都可以添加
                    [ReportObject event:ID_ADD_FRIEND];//2015.06.24
                    [Utilities showProcessingHud:self.view];//2015.05.12
                    // 发送添加好友请求
                    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          REQ_URL, @"url",
                                          @"Friend", @"ac",
                                          @"add", @"op",
                                          [infoDic objectForKey:@"uid"], @"fuid",
                                          @"0", @"gid",
                                          nil, @"note",
                                          nil];
                    
                    [network sendHttpReq:HttpReq_FriendAdd andData:data];
                }
            }else {
                // 聊天
                UserObject *user = [[UserObject alloc]init];
                
                user.user_id = [[infoDic objectForKey:@"uid"] longLongValue];
                user.name = [infoDic objectForKey:@"name"];
                user.headimgurl = [infoDic objectForKey:@"avatar"];
                
                [user updateToDB];
                
                // 更改聊天列表的title
                NSString *updateListSql =[NSString stringWithFormat: @"update msgList set title = '%@' where user_id = %lli", user.name, user.user_id];
                [[DBDao getDaoInstance] executeSql:updateListSql];
                
                MsgDetailsViewController *chatDeatilController = [[MsgDetailsViewController alloc] init];
                chatDeatilController.user = user;
                chatDeatilController.frontName = @"user";
                [chatDeatilController getChatDetailData];
                [self.navigationController pushViewController:chatDeatilController animated:YES];
            }
        }

    }else{
        // 删除好友
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"是否要删除好友？"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"确定",nil];
        alert.tag = 888;
        [alert show];
    }
}

-(void)selectButton:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    
    if ([btn.titleLabel.text isEqualToString:@"绑定亲子关系"]) {
        
        if ([@"scan" isEqualToString:_fromName]) {
            // 亲子关系绑定事件
            // 989a21
            
            NSString *bind = [infoDic objectForKey:@"bind"];
            if([bind intValue] == 1){
                
            }else{
                [Utilities showProcessingHud:self.view];
                
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      REQ_URL, @"url",
                                      @"Parenthood", @"ac",
                                      @"2",@"v",
                                      @"pair", @"op",
                                      _code, @"code",
                                      nil];
                
                [network sendHttpReq:HttpReq_BindParenthood andData:data];
            }
            
        }
        
    }else if ([btn.titleLabel.text isEqualToString:@"加为好友"]){
        
        if (false == [[infoDic objectForKey:@"friend"] intValue]) {
            // 加好友
            if ([@"2"  isEqual: [infoDic objectForKey:@"authority"]]) {
                // 需要验证
                FriendAddReqViewController *friendAddViewCtrl = [[FriendAddReqViewController alloc] init];
                friendAddViewCtrl.uid = [infoDic objectForKey:@"uid"];
                friendAddViewCtrl.name = [infoDic objectForKey:@"name"];
                [self.navigationController pushViewController:friendAddViewCtrl animated:YES];
            }else if([@"3"  isEqual: [infoDic objectForKey:@"authority"]]) {
                // 拒绝添加好友
                [Utilities showTextHud:@"对方拒绝任何人的添加好友请求。" descView:self.view];
            }else if([@"1"  isEqual: [infoDic objectForKey:@"authority"]]) {
                // 任何人都可以添加
                
                [Utilities showProcessingHud:self.view];//2015.05.12
                // 发送添加好友请求
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      REQ_URL, @"url",
                                      @"Friend", @"ac",
                                      @"add", @"op",
                                      [infoDic objectForKey:@"uid"], @"fuid",
                                      @"0", @"gid",
                                      nil, @"note",
                                      nil];
                
                [network sendHttpReq:HttpReq_FriendAdd andData:data];
            }
        }
    }else if ([btn.titleLabel.text isEqualToString:@"发消息"]){
        
        // 聊天
        UserObject *user = [[UserObject alloc]init];
        
        user.user_id = [[infoDic objectForKey:@"uid"] longLongValue];
        user.name = [infoDic objectForKey:@"name"];
        user.headimgurl = [infoDic objectForKey:@"avatar"];
        
        [user updateToDB];
        
        // 更改聊天列表的title
        NSString *updateListSql =[NSString stringWithFormat: @"update msgList set title = '%@' where user_id = %lli", user.name, user.user_id];
        [[DBDao getDaoInstance] executeSql:updateListSql];
        
        MsgDetailsViewController *chatDeatilController = [[MsgDetailsViewController alloc] init];
        chatDeatilController.user = user;
        chatDeatilController.frontName = @"user";
        [chatDeatilController getChatDetailData];
        [self.navigationController pushViewController:chatDeatilController animated:YES];

        
    }else{
        // 删除好友
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"是否要删除好友？"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"确定",nil];
        alert.tag = 888;
        [alert show];
    }
}

// 查看头像大图
-(void)touchImgHeadAction
{
    NSDictionary *message_info;
    message_info = [g_userInfo getUserDetailInfo];
    
    // 数据部分
    if (nil == message_info) {
        message_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDetailInfo"];
    }
    
//    NSString* uid = [message_info objectForKey:@"uid"];
//    Utilities *util = [Utilities alloc];
//    NSString* head_url = [util getAvatarFromUid:[NSString stringWithFormat:@"%@", uid] andType:@"2"];
//    NSString *imgUrl = head_url;
    //    UIImageView *imageView = [[UIImageView alloc]init];
    //    imageView.backgroundColor = [UIColor clearColor];
    //    if(IS_IPHONE_5){
    //        imageView.image = [UIImage imageNamed:@"placeholderImage_large.png"];
    //    }else{
    //        imageView.image = [UIImage imageNamed:@"placeholderImage_small.png"];
    //    }
    // 1.封装图片数据
    //设置所有的图片。photos是一个包含所有图片的数组。
    NSString *tempUrl = [infoDic objectForKey:@"avatar"];
    NSString *headUrl = [NSString stringWithFormat:@"%@&original=1",tempUrl];
    
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.save = NO;
    photo.url = [NSURL URLWithString:headUrl]; // 图片路径
    photo.srcImageView = btn_thumb.imageView; // 来源于哪个UIImageView
    [photos addObject:photo];
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    [Utilities dismissProcessingHud:self.view];// 2015.05.12
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    //NSLog(@"resultJSON:%@",resultJSON);
    if([@"FriendAction.viewFriendProfile" isEqualToString:[resultJSON objectForKey:@"protocol"]]) {
        if(true == [result intValue]) {
            delBtn.hidden = NO;
            NSDictionary *message_info = [resultJSON objectForKey:@"message"];
            NSLog(@"messageInfo:%@",message_info);
            
            [infoDic setValue:[Utilities replaceNull:[message_info objectForKey:@"avatar"]] forKey:@"avatar"];
            [infoDic setValue:[Utilities replaceNull:[message_info objectForKey:@"name"]] forKey:@"name"];
            [infoDic setValue:[Utilities replaceNull:[message_info objectForKey:@"sex"]] forKey:@"sex"];
            [infoDic setValue:[Utilities replaceNull:[message_info objectForKey:@"friend"]] forKey:@"friend"];
            [infoDic setValue:[Utilities replaceNull:[message_info objectForKey:@"title"]] forKey:@"title"];
            [infoDic setValue:[Utilities replaceNull:[message_info objectForKey:@"uid"]] forKey:@"uid"];
            [infoDic setValue:[Utilities replaceNull:[message_info objectForKey:@"authority"]] forKey:@"authority"];
            [infoDic setValue:[Utilities replaceNull:[message_info objectForKey:@"spacenote"]] forKey:@"spacenote"];
            [infoDic setValue:[message_info objectForKey:@"privacy"] forKey:@"privacy"];
            [infoDic setValue:[Utilities replaceNull:[message_info objectForKey:@"classname"]] forKey:@"classname"];
            [infoDic setValue:[message_info objectForKey:@"children"] forKey:@"children"];
            [infoDic setValue:[Utilities replaceNull:[message_info objectForKey:@"school_course"]] forKey:@"school_course"];

            //---add by kate 2015.06.12-----------------------------------------------------------
            [infoDic setValue:[Utilities replaceNull:[message_info objectForKey:@"school_job"]] forKey:@"duty"];// 职务
            [infoDic setValue:[Utilities replaceNull:[message_info objectForKey:@"school_course"]] forKey:@"subject"];// 学科
            [infoDic setValue:[Utilities replaceNull:[NSString stringWithFormat:@"%@",[message_info objectForKey:@"grade"]]] forKey:@"grade"];// 判断是否是本校身份 -1 非本校成员 0 学生 2 督学 6 家长 7 教师 9 管理员
            //-------------------------------------------------------------------------------------
            
//#if BUREAU_OF_EDUCATION
            [infoDic setValue:[Utilities replaceNull:[message_info objectForKey:@"schoolname"]] forKey:@"schoolname"];
//#else
//#endif

            
            NSDictionary *circle = [message_info objectForKey:@"circle"];
            _circleHiddenStatus = [[circle objectForKey:@"friend"] integerValue];
            
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].applicationFrame.size.width, 0) style:UITableViewStyleGrouped];
            [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
            
            
            //    UIImageView *imgView_bg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].applicationFrame.size.width,[UIScreen mainScreen].applicationFrame.size.height - 44)];
            //    [imgView_bg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
            
            //_tableView.backgroundView = imgView_bg;
            //_tableView.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0];
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.scrollEnabled = NO;
            _tableView.tableFooterView = [[UIView alloc] init];
            [_scrollerView addSubview:_tableView];
            
            _btn_name = [UIButton buttonWithType:UIButtonTypeCustom];
            _btn_name.titleLabel.font = [UIFont systemFontOfSize:17.0];
            [_btn_name setTintColor:[UIColor whiteColor]];
            [_btn_name setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal] ;
            [_btn_name setBackgroundImage:[UIImage imageNamed:@"btn_common__1_p.png"] forState:UIControlStateHighlighted] ;
            if (IS_IPHONE_4) {
                
                _btn_name.frame = CGRectMake(15, _scrollerView.frame.size.height - 40- 15 - 15 - 40 + 55, [UIScreen mainScreen].bounds.size.width-30.0, 40.0);
                
            }else{
                _btn_name.frame = CGRectMake(15, _scrollerView.frame.size.height - 40- 15 - 15 - 40 + 60, [UIScreen mainScreen].bounds.size.width-30.0, 40.0);
            }
            
            _btn_name.hidden = YES;
            [_btn_name addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
            
            delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            delBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
            [delBtn setTintColor:[UIColor whiteColor]];
            [delBtn setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal] ;
            [delBtn setBackgroundImage:[UIImage imageNamed:@"btn_common__1_p.png"] forState:UIControlStateHighlighted] ;//发送聊天消息
            
            if (IS_IPHONE_4) {
                delBtn.frame = CGRectMake(15, _scrollerView.frame.size.height - 40- 15+55, [UIScreen mainScreen].bounds.size.width-30.0, 40.0);//删除好友
            }else{
                delBtn.frame = CGRectMake(15, _scrollerView.frame.size.height - 40- 15, [UIScreen mainScreen].bounds.size.width-30.0, 40.0);//删除好友
            }
            
            
            [delBtn addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
            delBtn.hidden = YES;
            
            [_scrollerView addSubview:_btn_name];
            
            NSString *idName1 = @"";
            //#if BUREAU_OF_EDUCATION
            if (!_fsid) {
                idName1 = @"职务";
            }else {
                idName1 = @"本校职务";
            }
            // tableview中的元素
            NSDictionary *bxzw = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"icon_wdewm_", @"icon",
                                  @"0", @"indicator",
                                  idName1, @"name",
                                  nil];
            

         
            
            NSDictionary *rjxk = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"icon_wdxx.png", @"icon",
                                  @"任教学科", @"name",
                                  @"0", @"indicator",
                                  nil];
            
            NSDictionary *gxqm = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"icon_wddt.png", @"icon",
                                  @"个性签名", @"name",
                                  @"0", @"indicator",
                                  nil];
            
            NSDictionary *xxzl = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"icon_zhjys.png", @"icon",
                                  @"详细资料", @"name",
                                  @"1", @"indicator",
                                  nil];
            
            NSDictionary *grdt = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"icon_zhjys.png", @"icon",
                                  @"个人动态", @"name",
                                  @"1", @"indicator",
                                  nil];
            NSString *idName = @"";
//#if BUREAU_OF_EDUCATION
            if (!_fsid) {
                idName = @"本校身份";
            }else {
                idName = @"所在学校";
            }
//#else
//            idName = @"本校身份";
            
//#endif
            NSDictionary *bxsf = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"icon_qzgx.png", @"icon",
                                  idName, @"name",
                                  @"0", @"indicator",
                                  nil];
            
//            NSDictionary *qzgx = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                  @"icon_yhbz.png", @"icon",
//                                  @"亲子关系", @"name",
//                                  @"0", @"indicator",
//                                  nil];
            
            NSDictionary *szbj = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"icon_yhbz.png", @"icon",
                                  @"所在班级", @"name",
                                  @"0", @"indicator",
                                  nil];
            
//            NSString *title = [infoDic objectForKey:@"title"];
            NSString *grade = [infoDic objectForKey:@"grade"];

            NSDictionary *user = [g_userInfo getUserDetailInfo];
            NSString* usertype= [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
            
            BOOL isShowChildren = YES;

            if (_fsid) {
                NSArray *section1 = [NSArray arrayWithObjects:bxsf, gxqm, nil];
                NSMutableArray *section2 = [NSMutableArray arrayWithObjects:xxzl, nil];//2015.12.23
                
                _itemsArr = [NSMutableArray arrayWithObjects:section1, section2, nil];
            }else {
                
                if ([@"2"  isEqual: grade]) {
                    // 督学
                    NSArray *section1 = [NSArray arrayWithObjects:bxsf, gxqm, nil];
#if 0
                    NSArray *section2 = [NSArray arrayWithObjects:xxzl, grdt, nil];
#endif
                    NSMutableArray *section2 = [NSMutableArray arrayWithObjects:xxzl, nil];//2015.12.23
                    
                    _itemsArr = [NSMutableArray arrayWithObjects:section1, section2, nil];
                }else if ([@"7"  isEqual: grade] || [@"9"  isEqual: grade]){
                    // 管理员，老师
                    // 本校职务
                    NSString *duty = [infoDic objectForKey:@"duty"];
                    if (nil == duty) {
                        duty = @"";
                    }
                    
                    // 任教学科
                    NSString *school_course = [infoDic objectForKey:@"school_course"];
                    if (nil == school_course) {
                        school_course = @"";
                    }
                    
                    // 先判断亲子关系
                    NSArray *children = [infoDic objectForKey:@"children"];
                    
                    if (0 != [children count]) {
                        if ((![@""  isEqual: duty]) || (![@""  isEqual: school_course])) {
                            NSArray *section1 = [NSArray arrayWithObjects:bxzw, rjxk, gxqm, nil];
                            
#if 0
                            NSArray *section2 = [NSArray arrayWithObjects:xxzl, grdt, nil];
#endif
                            NSMutableArray *section2 = [NSMutableArray arrayWithObjects:xxzl, nil];//2015.12.23
                            
                            _itemsArr = [NSMutableArray arrayWithObjects:section1, section2, nil];
                        }else{
                            NSArray *section1 = [NSArray arrayWithObjects:bxsf, gxqm, nil];
#if 0
                            NSArray *section2 = [NSArray arrayWithObjects:xxzl, grdt, nil];
#endif
                            NSMutableArray *section2 = [NSMutableArray arrayWithObjects:xxzl, nil];//2015.12.23
                            
                            _itemsArr = [NSMutableArray arrayWithObjects:section1, section2, nil];
                        }
                    }else {
                        if ((![@""  isEqual: duty]) || (![@""  isEqual: school_course])) {
                            NSArray *section1 = [NSArray arrayWithObjects:bxzw, rjxk, gxqm, nil];
#if 0
                            NSArray *section2 = [NSArray arrayWithObjects:xxzl, grdt, nil];
#endif
                            NSMutableArray *section2 = [NSMutableArray arrayWithObjects:xxzl, nil];//2015.12.23
                            
                            _itemsArr = [NSMutableArray arrayWithObjects:section1, section2, nil];
                        }else{
                            NSArray *section1 = [NSArray arrayWithObjects:bxsf, gxqm, nil];
#if 0
                            NSArray *section2 = [NSArray arrayWithObjects:xxzl, grdt, nil];
#endif
                            NSMutableArray *section2 = [NSMutableArray arrayWithObjects:xxzl, nil];//2015.12.23
                            
                            _itemsArr = [NSMutableArray arrayWithObjects:section1, section2, nil];
                        }
                    }
                }else if ([@"6"  isEqual: grade]){
                    // 家长
                    NSArray *section1;
                    NSMutableArray *section2;
                    
                    // 看的人如果是教师身份，就显示亲子关系
                    if (([@"7"  isEqual: usertype]) || [_fuid isEqual: [Utilities getUniqueUid]] || [@"9"  isEqual: usertype] || [@"2"  isEqual: usertype]) {
                        section1 = [NSArray arrayWithObjects:bxsf, gxqm, nil];
#if 0
                        section2 = [NSArray arrayWithObjects:xxzl, grdt, nil];
#endif
                        section2 = [NSMutableArray arrayWithObjects:xxzl, nil];//2015.12.23
                        
                    }else {
                        section1 = [NSArray arrayWithObjects:bxsf, gxqm, nil];
#if 0
                        section2 = [NSArray arrayWithObjects:xxzl, grdt, nil];
#endif
                        section2 = [NSMutableArray arrayWithObjects:xxzl, nil];//2015.12.23
                        
                        isShowChildren = NO;
                    }
                    
                    _itemsArr = [NSMutableArray arrayWithObjects:section1, section2, nil];
                }else if ([@"0"  isEqual: grade]){
                    // 学生
                    NSArray *section1;
                    NSMutableArray *section2;
                    
                    // 看的人如果是教师身份，就显示亲子关系
                    if (([@"7"  isEqual: usertype]) || [_fuid isEqual: [Utilities getUniqueUid]] || [@"9"  isEqual: usertype]) {
                        NSArray *section1 = [NSArray arrayWithObjects:bxsf, szbj, gxqm, nil];
#if 0
                        NSArray *section2 = [NSArray arrayWithObjects:xxzl, grdt, nil];
#endif
                        NSMutableArray *section2 = [NSMutableArray arrayWithObjects:xxzl, nil];//2015.12.23
                        
                        _itemsArr = [NSMutableArray arrayWithObjects:section1, section2, nil];
                    }else {
                        section1 = [NSArray arrayWithObjects:bxsf, gxqm, nil];
#if 0
                        section2 = [NSArray arrayWithObjects:xxzl, grdt, nil];
#endif
                        section2 = [NSMutableArray arrayWithObjects:xxzl, nil];//2015.12.23
                        
                        _itemsArr = [NSMutableArray arrayWithObjects:section1, section2, nil];
                        
                        isShowChildren = NO;
                    }
                }else {
                    // other
                    NSArray *section1;
                    NSMutableArray *section2;
                    
                    section1 = [NSArray arrayWithObjects:bxsf, gxqm, nil];
#if 0
                    section2 = [NSArray arrayWithObjects:xxzl, grdt, nil];
#endif
                    section2 = [NSMutableArray arrayWithObjects:xxzl, nil];//2015.12.23
                    
                    _itemsArr = [NSMutableArray arrayWithObjects:section1, section2, nil];
                    
                    isShowChildren = NO;
                }

            }

            // 如果看的人不是学生并且不是家长，则显示我的动态
//            if ((![@"0"  isEqual: usertype]) && (![@"6"  isEqual: usertype])) {
//                [[_itemsArr objectAtIndex:1] addObject:grdt];
//            }

//#if BUREAU_OF_EDUCATION
            if (!_fsid) {
                [[_itemsArr objectAtIndex:1] addObject:grdt];
            }
//#else
//            [[_itemsArr objectAtIndex:1] addObject:grdt];
//            
//#endif

            if (![_fuid isEqualToString:[Utilities getUniqueUid]]) {
                NSDictionary *pbssq = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       @"icon_zhjys.png", @"icon",
                                       @"不看Ta的师生圈", @"name",
                                       @"0", @"indicator",
                                       nil];
                NSArray *section3 = [NSArray arrayWithObjects:pbssq, nil];
                
//#if BUREAU_OF_EDUCATION
                if (!_fsid) {
                    [_itemsArr addObject:section3];
                }
//#else
//                [_itemsArr addObject:section3];
//#endif
            }

            
            //NSLog(@"privacy:%@",[message_info objectForKey:@"privacy"]);
//-------------update by kate 2014.12.22--------------------------------
//            NSArray *privacy = [message_info objectForKey:@"privacy"];
//            [profileIinfoArray setArray:privacy];
            
//---------------------------------------------------------------------
            
//             NSDictionary *user = [g_userInfo getUserDetailInfo];
//             NSString* usertype = [user objectForKey:@"role_id"];
            
            // 现在接口 0 学生 6 家长 7 老师 9 校园管理员 2督学
//            NSDictionary *user = [g_userInfo getUserDetailInfo];
//            NSString* usertype= [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];

            if ([usertype intValue] == 7 || [usertype intValue] == 9 || [usertype intValue] == 2) {
                if ([(NSArray *)[message_info objectForKey:@"children"] count] >0) {
                    
                    isBinded = YES;
                    [infoDic setValue:[message_info objectForKey:@"children"] forKey:@"children"];
                    NSArray *children = [message_info objectForKey:@"children"];
                    [childrenArray setArray:children];
                    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
                    for (int i=0; i<[childrenArray count]; i++) {
                        
                        NSMutableDictionary *childInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                       @"button", @"type",
                                                       @"", @"value",
                                                       [[childrenArray objectAtIndex:i] objectForKey:@"name"],@"title",
                                                       @"0", @"friend",
                                                       nil];
                        
                        [tempArray addObject:childInfo];

                    }
                    
                    
                    NSMutableDictionary *firstSel = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                    @"亲子关系", @"title",
                                                    tempArray, @"fields",
                                                    @"button", @"type",@"icon_znqk.png",@"imageName",
                                                    nil];
                    
                    // 添加到数组最后
                    //[profileIinfoArray insertObject:firstSel atIndex:0];
                    [profileIinfoArray addObject:firstSel];//update by kate 2014.12.22
                    
                }

            }
            NSString *spacenote = [infoDic objectForKey:@"spacenote"];
            CGSize sizeSpacenote = [Utilities getStringHeight:spacenote andFont:[UIFont systemFontOfSize:15.0f] andSize:CGSizeMake(220, 0)];
            
            _spacenoteHeight = sizeSpacenote.height;
            
            NSString *childrenStr = @"";
            NSArray *children = [infoDic objectForKey:@"children"];
            
            for (NSDictionary *dic in children) {
                if ([@""  isEqual: childrenStr]) {
                    childrenStr = [NSString stringWithFormat:@"%@", [dic objectForKey:@"name"]];
                }else {
                    childrenStr = [NSString stringWithFormat:@"%@\n%@", childrenStr, [dic objectForKey:@"name"]];
                }
            }
            CGSize sizeChildren = [Utilities getStringHeight:childrenStr andFont:[UIFont systemFontOfSize:15.0f] andSize:CGSizeMake(220, 0)];
            
//            if ([@""  isEqual: childrenStr]) {
//                sizeChildren = CGSizeMake(0, 0);
//            }
            
            _parentHeight = sizeChildren.height;
            
            NSInteger section1Cnt = [(NSArray *)[_itemsArr objectAtIndex:0] count];
            NSInteger section1Cn1 = [(NSArray *)[_itemsArr objectAtIndex:1] count];

            NSInteger total = (section1Cnt + section1Cn1)*50 + 250;
            
            
            
            // 自定义一个array项目
            if (![_fuid isEqual: [Utilities getUniqueUid]]) {
                if (false == [[infoDic objectForKey:@"friend"] intValue]) {
                    // 添加好友btn
                    _btn_addFriendAndSendMsg = [UIButton buttonWithType:UIButtonTypeCustom];
                    _btn_addFriendAndSendMsg.titleLabel.font = [UIFont systemFontOfSize:17.0];
                    [_btn_addFriendAndSendMsg setTintColor:[UIColor whiteColor]];
                    [_btn_addFriendAndSendMsg setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal] ;
                    [_btn_addFriendAndSendMsg setBackgroundImage:[UIImage imageNamed:@"btn_common__1_p.png"] forState:UIControlStateHighlighted] ;
                    
                    [_btn_addFriendAndSendMsg setTitle:@"加为好友" forState:UIControlStateNormal];
                    
                    if (isShowChildren) {
                        if (IS_IPHONE_4) {
                            _btn_addFriendAndSendMsg.frame = CGRectMake(15, total + sizeSpacenote.height + sizeChildren.height, [UIScreen mainScreen].bounds.size.width-30.0, 40.0);
                        }else{
                            _btn_addFriendAndSendMsg.frame = CGRectMake(15, total + sizeSpacenote.height + sizeChildren.height, [UIScreen mainScreen].bounds.size.width-30.0, 40.0);
                        }
                    }else {
                        if (IS_IPHONE_4) {
                            _btn_addFriendAndSendMsg.frame = CGRectMake(15, total + sizeSpacenote.height + sizeChildren.height, [UIScreen mainScreen].bounds.size.width-30.0, 40.0);
                        }else{
                            _btn_addFriendAndSendMsg.frame = CGRectMake(15, total + sizeSpacenote.height + sizeChildren.height, [UIScreen mainScreen].bounds.size.width-30.0, 40.0);
                        }
                    }
                    
                    [_btn_addFriendAndSendMsg addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];

                    //[_scrollerView addSubview:_btn_addFriendAndSendMsg];// 因为没有好友概念 不再显示此按钮 春晖确认 2016.07.11

                    _scrollerView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, _btn_addFriendAndSendMsg.frame.origin.y + 40 + 20 + 35);
                    
                    if (IS_IPHONE_4) {
                        _scrollerView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, _btn_addFriendAndSendMsg.frame.origin.y + 40 + 20 );
                    }

                    _btn_deleteFriend.hidden = YES;
                    
                    
#if 0
                    btnName = @"加为好友";
                    
                    // 计算个性签名的高度
                    NSString *spacenote = [infoDic objectForKey:@"spacenote"];
                    CGSize size = [Utilities getStringHeight:spacenote andFont:[UIFont systemFontOfSize:15.0f] andSize:CGSizeMake(220, 0)];

                    delBtn.frame = CGRectMake(15, 564 + size.height, [UIScreen mainScreen].bounds.size.width-30.0, 40.0);//发消息

                    [delBtn setTitle:btnName forState:UIControlStateNormal];
                    
#endif
                }else {
                    // 发消息btn
                    _btn_addFriendAndSendMsg = [UIButton buttonWithType:UIButtonTypeCustom];
                    _btn_addFriendAndSendMsg.titleLabel.font = [UIFont systemFontOfSize:17.0];
                    [_btn_addFriendAndSendMsg setTintColor:[UIColor whiteColor]];
                    [_btn_addFriendAndSendMsg setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal] ;
                    [_btn_addFriendAndSendMsg setBackgroundImage:[UIImage imageNamed:@"btn_common__1_p.png"] forState:UIControlStateHighlighted] ;
                    
                    [_btn_addFriendAndSendMsg setTitle:@"发消息" forState:UIControlStateNormal];
                    
                    if (isShowChildren) {
                        if (IS_IPHONE_4) {
                            _btn_addFriendAndSendMsg.frame = CGRectMake(15, total + sizeSpacenote.height + sizeChildren.height, ([UIScreen mainScreen].bounds.size.width-45.0)/2, 40.0);
                        }else{
                            _btn_addFriendAndSendMsg.frame = CGRectMake(15, total + sizeSpacenote.height + sizeChildren.height, ([UIScreen mainScreen].bounds.size.width-45.0)/2, 40.0);
                        }
                    }else {
                        if (IS_IPHONE_4) {
                            _btn_addFriendAndSendMsg.frame = CGRectMake(15, total + sizeSpacenote.height + sizeChildren.height, ([UIScreen mainScreen].bounds.size.width-45.0)/2, 40.0);
                        }else{
                            _btn_addFriendAndSendMsg.frame = CGRectMake(15, total + sizeSpacenote.height + sizeChildren.height, ([UIScreen mainScreen].bounds.size.width-45.0)/2, 40.0);
                        }
                    }
                    
                    [_btn_addFriendAndSendMsg addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
                    
                    //[_scrollerView addSubview:_btn_addFriendAndSendMsg];// 因为没有好友概念 不再显示此按钮 春晖确认 2016.07.11
                    
                    
                    _btn_deleteFriend = [UIButton buttonWithType:UIButtonTypeCustom];
                    _btn_deleteFriend.titleLabel.font = [UIFont systemFontOfSize:17.0];
                    [_btn_deleteFriend setTintColor:[UIColor whiteColor]];
                    [_btn_deleteFriend setBackgroundImage:[UIImage imageNamed:@"personalInfo/personal_btn_delete"] forState:UIControlStateNormal] ;
                    [_btn_deleteFriend setBackgroundImage:[UIImage imageNamed:@"personalInfo/personal_btn_delete"] forState:UIControlStateHighlighted] ;
                    
                    [_btn_deleteFriend setTitle:@"删除好友" forState:UIControlStateNormal];
                    
                    if (isShowChildren) {
                        if (IS_IPHONE_4) {
                            _btn_deleteFriend.frame = CGRectMake(15 + ([UIScreen mainScreen].bounds.size.width-45.0)/2 + 15, total + sizeSpacenote.height + sizeChildren.height, ([UIScreen mainScreen].bounds.size.width-45.0)/2, 40.0);
                        }else{
                            _btn_deleteFriend.frame = CGRectMake(15 + ([UIScreen mainScreen].bounds.size.width-45.0)/2 + 15, total + sizeSpacenote.height + sizeChildren.height, ([UIScreen mainScreen].bounds.size.width-45.0)/2, 40.0);
                        }
                    }else {
                        if (IS_IPHONE_4) {
                            _btn_deleteFriend.frame = CGRectMake(15 + ([UIScreen mainScreen].bounds.size.width-45.0)/2 + 15, total + sizeSpacenote.height + sizeChildren.height, ([UIScreen mainScreen].bounds.size.width-45.0)/2, 40.0);
                        }else{
                            _btn_deleteFriend.frame = CGRectMake(15 + ([UIScreen mainScreen].bounds.size.width-45.0)/2 + 15, total + sizeSpacenote.height + sizeChildren.height, ([UIScreen mainScreen].bounds.size.width-45.0)/2, 40.0);
                        }
                    }
                    
                    [_btn_deleteFriend addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
                    
                    //[_scrollerView addSubview:_btn_deleteFriend];//因为没有好友概念 不再显示此按钮 2016.09.26 春晖确认

                    
                    _scrollerView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, _btn_addFriendAndSendMsg.frame.origin.y + 40 + 20 + 35);
                    
                    if (IS_IPHONE_4) {
                        _scrollerView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, _btn_addFriendAndSendMsg.frame.origin.y + 40 + 20);
                    }

                    
                    
                    
                    
                    
#if 0
                    if (IS_IPHONE_4) {
                    
                    }else{
                        
                        
                        
                         _btn_name.frame = CGRectMake(15, _scrollerView.frame.size.height - 40- 15 - 15 - 40 + 8 + 20, [UIScreen mainScreen].bounds.size.width-30.0, 40.0);//发消息
                         delBtn.frame = CGRectMake(15, _scrollerView.frame.size.height - 40- 15+5, [UIScreen mainScreen].bounds.size.width-30.0, 40.0);//删除好友
                    }
                    
                    btnName = @"发消息";
                    _btn_name.hidden = NO;
                    [_btn_name setTitle:btnName forState:UIControlStateNormal];
                    [delBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [delBtn setTitle:@"删除好友" forState:UIControlStateNormal];
                    [delBtn setBackgroundImage:[UIImage imageNamed:@"bg_delFriend.png"] forState:UIControlStateNormal];
#endif
                    
                }

            }else {
                _btn_name.hidden = YES;
                delBtn.hidden = YES;

                _btn_addFriendAndSendMsg.hidden = YES;
                _btn_deleteFriend.hidden = YES;

                _scrollerView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, total + sizeSpacenote.height + sizeChildren.height + 35);
                
                if (IS_IPHONE_4) {
                    _scrollerView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, total + sizeSpacenote.height + sizeChildren.height);
                }
            }

            [self doShowHeadView];

            NSUInteger sectionHeaderHeight = 30 * [profileIinfoArray count];
            NSUInteger rowHeight = 0;
            NSUInteger totalHeight = 0;
            
            for (int i=0; i<[profileIinfoArray count]; i++) {
                NSDictionary *dic = [profileIinfoArray objectAtIndex:i];
                NSUInteger count = [(NSArray *)[dic objectForKey:@"fields"] count];
                
                rowHeight = rowHeight + 70*count;
            }
            totalHeight =  tableHeaderViewHeight + sectionHeaderHeight + rowHeight;

           //_tableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, totalHeight);
//            _tableView.frame = CGRectMake(0, -20, [UIScreen mainScreen].applicationFrame.size.width, tableHeaderViewHeight+211);
            
            _tableView.frame = CGRectMake(0, -20, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height+44+20+240);

            _tableView.tableHeaderView = headerView;

            [_tableView reloadData];
            
            [_imgView_default removeFromSuperview];
            
            
            
            _btn_addFriendAndSendMsg.hidden = YES;
            _btn_deleteFriend.hidden = YES;
            _btn_name.hidden = YES;
            delBtn.hidden = YES;

            
        }
        else
        {
            NSString* message_info = [resultJSON objectForKey:@"message"];
            [Utilities showTextHud:message_info descView:self.view];
        }
    }else if([@"FriendAction.add" isEqualToString:[resultJSON objectForKey:@"protocol"]]) {
        NSString* message_info = [resultJSON objectForKey:@"message"];

        // 不需要验证的用户，添加好友
        if(true == [result intValue])
        {
            // 成功
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:message_info
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil,nil];
            alert.tag = 122;
            [alert show];
        }else {
            // 失败
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:message_info
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil,nil];
            [alert show];
        }
    }else if([@"FriendAction.del" isEqualToString:[resultJSON objectForKey:@"protocol"]]) {
        NSString* message_info = [resultJSON objectForKey:@"message"];
        
        // 删除成功
        if(true == [result intValue])
        {
            // 成功
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"删除好友成功。"
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil,nil];
            alert.tag = 777;
            [alert show];
        }else {
            // 失败
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:message_info
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil,nil];
            [alert show];
        }
    }else if ([@"FriendAction.viewByCode" isEqualToString:[resultJSON objectForKey:@"protocol"]]){
        // 通过二维码查看个人资料
        if(true == [result intValue]) {
            
//            delBtn.hidden = NO;
            _btn_addFriendAndSendMsg.hidden = NO;
            
            [profileIinfoArray removeAllObjects];
            
            NSDictionary *message_info = [resultJSON objectForKey:@"message"];
            
            [infoDic setValue:[message_info objectForKey:@"avatar"] forKey:@"avatar"];
            [infoDic setValue:[message_info objectForKey:@"name"] forKey:@"name"];
            [infoDic setValue:[message_info objectForKey:@"sex"] forKey:@"sex"];
            [infoDic setValue:[message_info objectForKey:@"friend"] forKey:@"friend"];
            [infoDic setValue:[message_info objectForKey:@"title"] forKey:@"title"];
            [infoDic setValue:[message_info objectForKey:@"uid"] forKey:@"uid"];
            [infoDic setValue:[message_info objectForKey:@"authority"] forKey:@"authority"];
            [infoDic setValue:[message_info objectForKey:@"spacenote"] forKey:@"spacenote"];
            
            [infoDic setValue:[message_info objectForKey:@"privacy"] forKey:@"privacy"];
//------------update by kate 2014.12.22-------------------------------------
//            NSArray *privacy = [message_info objectForKey:@"privacy"];
//            [profileIinfoArray setArray:privacy];
            
//-----------------------------------------------------------------
            
//            [delBtn setTitle:btnName forState:UIControlStateNormal];
            
            [_btn_addFriendAndSendMsg setTitle:@"绑定亲子关系" forState:UIControlStateNormal];

            
            NSString *spacenote = [infoDic objectForKey:@"spacenote"];
            CGSize sizeSpacenote = [Utilities getStringHeight:spacenote andFont:[UIFont systemFontOfSize:15.0f] andSize:CGSizeMake(220, 0)];
            
            NSString *childrenStr = @"";
            NSArray *children = [infoDic objectForKey:@"children"];
            
            for (NSDictionary *dic in children) {
                if ([@""  isEqual: childrenStr]) {
                    childrenStr = [NSString stringWithFormat:@"%@", [dic objectForKey:@"name"]];
                }else {
                    childrenStr = [NSString stringWithFormat:@"%@\n%@", childrenStr, [dic objectForKey:@"name"]];
                }
            }
            CGSize sizeChildren = [Utilities getStringHeight:childrenStr andFont:[UIFont systemFontOfSize:15.0f] andSize:CGSizeMake(220, 0)];
            
            if ([@""  isEqual: childrenStr]) {
                sizeChildren = CGSizeMake(0, 0);
            }

            
            if (IS_IPHONE_4) {
                _btn_addFriendAndSendMsg.frame = CGRectMake(15, 500 + sizeSpacenote.height + sizeChildren.height, [UIScreen mainScreen].bounds.size.width-30.0, 40.0);
            }else{
                _btn_addFriendAndSendMsg.frame = CGRectMake(15, 500 + sizeSpacenote.height + sizeChildren.height, [UIScreen mainScreen].bounds.size.width-30.0, 40.0);
            }

           /* NSMutableDictionary *button = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           @"button", @"type",
                                           btnName, @"title",
                                           @"", @"value",
                                           @"0", @"friend",
                                           nil];
            
            NSArray *array = [NSArray arrayWithObjects:
                              button,nil];
            
            NSMutableDictionary *lastSel = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                            @"聊天或者加好友", @"title",
                                            array, @"fields",
                                            @"button", @"type",
                                            nil];
            
            // 添加到数组最后
            [profileIinfoArray addObject:lastSel];*/
            
            [self doShowHeadView];
            
            NSUInteger sectionHeaderHeight = 30 * [profileIinfoArray count];
            NSUInteger rowHeight = 0;
            NSUInteger totalHeight = 0;
            
            for (int i=0; i<[profileIinfoArray count]; i++) {
                NSDictionary *dic = [profileIinfoArray objectAtIndex:i];
                NSUInteger count = [(NSArray *)[dic objectForKey:@"fields"] count];
                
                rowHeight = rowHeight + 70*count;
            }
            totalHeight =  tableHeaderViewHeight + sectionHeaderHeight + rowHeight;
            
            //_tableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, totalHeight);
            _tableView.frame = CGRectMake(0, -20, [UIScreen mainScreen].applicationFrame.size.width, tableHeaderViewHeight+211);
            _tableView.tableHeaderView = headerView;
            
            [_tableView reloadData];
            
            
            
            _scrollerView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, _tableView.tableHeaderView.frame.size.height + sectionHeaderHeight + rowHeight + 30);
            if (IS_IPHONE_4) {
                 _scrollerView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, _tableView.tableHeaderView.frame.size.height + 30 *2 + 70*3 + 55);
            }
            

        }else{
            
            NSString* message_info = [resultJSON objectForKey:@"message"];
            [Utilities showTextHud:message_info descView:self.view];
        }
        
    }else{
        // 父母绑定孩子接口
        [Utilities dismissProcessingHud:self.view];
        
        if(true == [result intValue]) {
            
//            ParenthoodListForParentTableViewController *plftV = [[ParenthoodListForParentTableViewController alloc]init];
//            [self.navigationController pushViewController:plftV animated:YES];
            
             [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshParentBindList" object:nil];
            
             [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];

        }else{
            
            NSString* message_info = [resultJSON objectForKey:@"message"];
            [Utilities showTextHud:message_info descView:self.view];
            
        }
        
    }
}

-(void)reciveHttpDataError:(NSError*)err
{
   
    [Utilities dismissProcessingHud:self.view];//2015.05.12
//    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
//                                                   message:@"网络连接错误，请稍候再试"
//                                                  delegate:nil
//                                         cancelButtonTitle:@"确定"
//                                         otherButtonTitles:nil];
//    [alert show];
}

//---add by kate 2014.11.27----------------------------
-(void)refreshViewByCode:(NSDictionary*)infoDictionary{
    
    NSDictionary *message_info = infoDictionary;
    
    [infoDic setValue:[message_info objectForKey:@"avatar"] forKey:@"avatar"];
    [infoDic setValue:[message_info objectForKey:@"name"] forKey:@"name"];
    [infoDic setValue:[message_info objectForKey:@"sex"] forKey:@"sex"];
    [infoDic setValue:[message_info objectForKey:@"friend"] forKey:@"friend"];
    [infoDic setValue:[message_info objectForKey:@"title"] forKey:@"title"];
    [infoDic setValue:[message_info objectForKey:@"uid"] forKey:@"uid"];
    [infoDic setValue:[message_info objectForKey:@"authority"] forKey:@"authority"];
    [infoDic setValue:[message_info objectForKey:@"spacenote"] forKey:@"spacenote"];
    [infoDic setValue:[message_info objectForKey:@"bind"] forKey:@"bind"];
    [infoDic setValue:[message_info objectForKey:@"privacy"] forKey:@"privacy"];
    [infoDic setValue:[message_info objectForKey:@"classname"] forKey:@"classname"];//2015.09.08
    NSArray *privacy = [message_info objectForKey:@"privacy"];
    [profileIinfoArray setArray:privacy];
    
//    NSLog(@"infoDic:%@",infoDic);
//    NSLog(@"profileIinfoArray:%@",profileIinfoArray);
    
    NSString *bind = [infoDic objectForKey:@"bind"];
    NSLog(@"delBtn.frame:%f",delBtn.frame.origin.y);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].applicationFrame.size.width, 0) style:UITableViewStyleGrouped];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    
    //    UIImageView *imgView_bg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].applicationFrame.size.width,[UIScreen mainScreen].applicationFrame.size.height - 44)];
    //    [imgView_bg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    
    //_tableView.backgroundView = imgView_bg;
    //_tableView.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.tableFooterView = [[UIView alloc] init];
    [_scrollerView addSubview:_tableView];

    
    NSString *spacenote = [infoDic objectForKey:@"spacenote"];
    CGSize sizeSpacenote = [Utilities getStringHeight:spacenote andFont:[UIFont systemFontOfSize:15.0f] andSize:CGSizeMake(220, 0)];
    
    _spacenoteHeight = sizeSpacenote.height;
    
    NSString *childrenStr = @"";
    NSArray *children = [infoDic objectForKey:@"children"];
    
    for (NSDictionary *dic in children) {
        if ([@""  isEqual: childrenStr]) {
            childrenStr = [NSString stringWithFormat:@"%@", [dic objectForKey:@"name"]];
        }else {
            childrenStr = [NSString stringWithFormat:@"%@\n%@", childrenStr, [dic objectForKey:@"name"]];
        }
    }
    CGSize sizeChildren = [Utilities getStringHeight:childrenStr andFont:[UIFont systemFontOfSize:15.0f] andSize:CGSizeMake(220, 0)];
    
    if ([@""  isEqual: childrenStr]) {
        sizeChildren = CGSizeMake(0, 0);
    }
    
    _btn_addFriendAndSendMsg = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn_addFriendAndSendMsg.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [_btn_addFriendAndSendMsg setTintColor:[UIColor whiteColor]];
    [_btn_addFriendAndSendMsg setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal] ;
    [_btn_addFriendAndSendMsg setBackgroundImage:[UIImage imageNamed:@"btn_common__1_p.png"] forState:UIControlStateHighlighted] ;

    //[_scrollerView addSubview:_btn_addFriendAndSendMsg];// 因为没有好友概念 不再显示此按钮 春晖确认 2016.07.11
    
    [_btn_addFriendAndSendMsg addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];

    _btn_addFriendAndSendMsg.hidden = NO;
    
    
    if (IS_IPHONE_4) {
        _btn_addFriendAndSendMsg.frame = CGRectMake(15, 500 + sizeSpacenote.height + sizeChildren.height, [UIScreen mainScreen].bounds.size.width-30.0, 40.0);
    }else{
        _btn_addFriendAndSendMsg.frame = CGRectMake(15, 500 + sizeSpacenote.height + sizeChildren.height, [UIScreen mainScreen].bounds.size.width-30.0, 40.0);
    }

    
    if([bind intValue] == 1){
        btnName = @"已绑定亲子关系";
//        delBtn.userInteractionEnabled = NO;//不可点击
        
        _btn_addFriendAndSendMsg.userInteractionEnabled = NO;//不可点击

        [_btn_addFriendAndSendMsg setBackgroundImage:[UIImage imageNamed:@"bg_delFriend.png"] forState:UIControlStateNormal];
    }else{
         btnName = @"绑定亲子关系";
    }
    
    [_btn_addFriendAndSendMsg setTitle:btnName forState:UIControlStateNormal];

//    [delBtn setTitle:btnName forState:UIControlStateNormal];
   /* NSMutableDictionary *button = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   @"button", @"type",
                                   btnName, @"title",
                                   @"", @"value",
                                   @"0", @"friend",
                                   nil];
    
    NSArray *array = [NSArray arrayWithObjects:
                      button,nil];
    
    NSMutableDictionary *lastSel = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    @"聊天或者加好友", @"title",
                                    array, @"fields",
                                    @"button", @"type",
                                    nil];
    
    // 添加到数组最后
    [profileIinfoArray addObject:lastSel];*/
    
    [self doShowHeadView];
    
    NSString *idName1 = @"";
    //#if BUREAU_OF_EDUCATION
    if (!_fsid) {
        idName1 = @"职务";
    }else {
        idName1 = @"本校职务";
    }
    
    NSDictionary *bxzw = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"icon_wdewm_", @"icon",
                          @"0", @"indicator",
                          idName1, @"name",
                          nil];
//#if BUREAU_OF_EDUCATION
//    // tableview中的元素
//    
//    NSDictionary *bxzw = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          @"icon_wdewm_", @"icon",
//                          @"0", @"indicator",
//                          idName1, @"name",
//                          nil];
//#else
//    
//    NSDictionary *bxzw = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          @"icon_wdewm_", @"icon",
//                          @"0", @"indicator",
//                          @"本校职务", @"name",
//                          nil];
//    
//#endif
    
    
    
    NSDictionary *rjxk = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"icon_wdxx.png", @"icon",
                          @"任教学科", @"name",
                          @"0", @"indicator",
                          nil];
    
    NSDictionary *gxqm = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"icon_wddt.png", @"icon",
                          @"个性签名", @"name",
                          @"0", @"indicator",
                          nil];
    
    NSDictionary *xxzl = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"icon_zhjys.png", @"icon",
                          @"详细资料", @"name",
                          @"1", @"indicator",
                          nil];
    
    NSDictionary *grdt = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"icon_zhjys.png", @"icon",
                          @"个人动态", @"name",
                          @"1", @"indicator",
                          nil];
    
    NSDictionary *bxsf = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"icon_qzgx.png", @"icon",
                          @"本校身份", @"name",
                          @"0", @"indicator",
                          nil];
    
    NSDictionary *qzgx = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"icon_yhbz.png", @"icon",
                          @"亲子关系", @"name",
                          @"0", @"indicator",
                          nil];
    
    NSDictionary *szbj = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"icon_yhbz.png", @"icon",
                          @"所在班级", @"name",
                          @"0", @"indicator",
                          nil];
    
    NSString *title = [infoDic objectForKey:@"title"];
    
    BOOL isShowChildren = YES;
    
    if([@"学生"  isEqual: title]) {
        // 学生
        NSArray *section1 = [NSArray arrayWithObjects:bxsf, szbj, gxqm, nil];
        NSArray *section2 = [NSArray arrayWithObjects:xxzl, grdt, nil];
        
        _itemsArr = [NSMutableArray arrayWithObjects:section1, section2, nil];
    }else if ([@"家长"  isEqual: title]) {
        // 家长
        // 现在接口 0 学生 6 家长 7 老师 9 校园管理员 2督学
        NSDictionary *user = [g_userInfo getUserDetailInfo];
        NSString* usertype= [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
        
        NSArray *section1;
        NSArray *section2;
        
        // 看的人如果是教师身份，就显示亲子关系
        if (([@"7"  isEqual: usertype]) || [_fuid isEqual: [Utilities getUniqueUid]]) {
            section1 = [NSArray arrayWithObjects:bxsf, qzgx, gxqm, nil];
            section2 = [NSArray arrayWithObjects:xxzl, grdt, nil];
        }else {
            section1 = [NSArray arrayWithObjects:bxsf, gxqm, nil];
            section2 = [NSArray arrayWithObjects:xxzl, grdt, nil];
            
            isShowChildren = NO;
        }
        
        _itemsArr = [NSMutableArray arrayWithObjects:section1, section2, nil];
    }else if ([@"老师"  isEqual: title] || [@"督学"  isEqual: title] || [@"管理员"  isEqual: title]) {
        // 老师，校园管理员，督学
        NSString *title = [infoDic objectForKey:@"title"];
        
        if ((nil == title) || ([@""  isEqual: title])) {
            NSArray *section1 = [NSArray arrayWithObjects:bxsf, rjxk, gxqm, nil];
            NSArray *section2 = [NSArray arrayWithObjects:xxzl, grdt, nil];
            
            _itemsArr = [NSMutableArray arrayWithObjects:section1, section2, nil];
        }else {
            NSArray *section1 = [NSArray arrayWithObjects:bxzw, rjxk, gxqm, nil];
            NSArray *section2 = [NSArray arrayWithObjects:xxzl, grdt, nil];
            
            _itemsArr = [NSMutableArray arrayWithObjects:section1, section2, nil];
        }
    }

    NSUInteger sectionHeaderHeight = 30 * [profileIinfoArray count];
    NSUInteger rowHeight = 0;
    NSUInteger totalHeight = 0;
    
    for (int i=0; i<[profileIinfoArray count]; i++) {
        NSDictionary *dic = [profileIinfoArray objectAtIndex:i];
        NSUInteger count = [(NSArray *)[dic objectForKey:@"fields"] count];
        
        rowHeight = rowHeight + 70*count;
    }
    totalHeight =  tableHeaderViewHeight + sectionHeaderHeight + rowHeight;
    

//    _tableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, totalHeight);
     _tableView.frame = CGRectMake(0, -20, [UIScreen mainScreen].applicationFrame.size.width, tableHeaderViewHeight+211);
    _tableView.tableHeaderView = headerView;
    
    [_tableView reloadData];
    
    [_imgView_default removeFromSuperview];

    _scrollerView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, _btn_addFriendAndSendMsg.frame.origin.y + 40 + 20);
    
    if (IS_IPHONE_4) {
        _scrollerView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, _btn_addFriendAndSendMsg.frame.origin.y + 40 + 20 );
    }

//    _scrollerView.contentSize = CGSizeMake(320, _tableView.tableHeaderView.frame.size.height + sectionHeaderHeight + rowHeight + 30);
//    if (IS_IPHONE_4) {
//         _scrollerView.contentSize = CGSizeMake(320, _tableView.tableHeaderView.frame.size.height + 30 *2 + 70*3 + 55);
//    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    [self.navigationController popViewControllerAnimated:YES];
    if (alertView.tag == 122) {
        // 更改最下面选项的内容
//        [profileIinfoArray removeLastObject];
        
        [Utilities showProcessingHud:self.view];// 2015.05.12
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Friend", @"ac",
                              @"viewFriendProfile", @"op",
                              _fuid, @"fuid",
                              nil];
        
        [network sendHttpReq:HttpReq_ViewFriendProfile andData:data];

//        NSMutableDictionary *button1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                        @"button", @"type",
//                                        @"发消息", @"title",
//                                        @"", @"value",
//                                        @"0", @"friend",
//                                        nil];
//        
//        NSArray *array1 = [NSArray arrayWithObjects:
//                           button1,nil];
//        
//        NSMutableDictionary *lastSel1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                         @"聊天或者加好友", @"title",
//                                         array1, @"fields",
//                                         @"button", @"type",
//                                         nil];
//        [profileIinfoArray addObject:lastSel1];
//        
//        [_tableView reloadData];
    }else if (alertView.tag == 777) {
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Friend", @"ac",
                              @"viewFriendProfile", @"op",
                              _fuid, @"fuid",
                              nil];
        
        [network sendHttpReq:HttpReq_ViewFriendProfile andData:data];
    }else if (alertView.tag == 888) {
        // 删除好友
        if (buttonIndex == 1) {
            
            [ReportObject event:ID_DEL_FRIEND];//2015.06.24
            
            [Utilities showProcessingHud:self.view];// 2015.05.12
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Friend", @"ac",
                                  @"del", @"op",
                                  _fuid, @"fuid",
                                  nil];
            
            [network sendHttpReq:HttpReq_FriendDelete andData:data];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    NSLog(@"%f", scrollView.contentOffset.y);
    
    if (30 <= scrollView.contentOffset.y) {
        [UIView animateWithDuration:0.3 animations:^{
            _alphaView.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            _alphaView.alpha = 0.0;
        } completion:^(BOOL finished) {
            
        }];
    }
    
    

}



//    NSInteger currentIndex = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
//    
//    _currentIndex = currentIndex;
//    _numberBar.text = [NSString stringWithFormat:@"%d/%d",_currentIndex+1,[_assetsArray count]];
    
    

@end
