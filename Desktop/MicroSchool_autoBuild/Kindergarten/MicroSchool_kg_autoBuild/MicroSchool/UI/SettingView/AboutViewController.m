//
//  AboutViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-7.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "AboutViewController.h"
#import "CXAlertView.h"

@interface AboutViewController ()
@property(nonatomic,retain)NSString *updateUrl;
@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        network = [NetworkUtility alloc];
        network.delegate = self;
        
        _featueImgView = [[UIImageView alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [super setCustomizeTitle:@"关于知校"];
    [super setCustomizeLeftButton];
    
    _updateUrl = [[NSString alloc]init];
    [self checkNewVersion];// add by kate 2015.02.16
    
    [ReportObject event:ID_OPEN_ABOUT];//2015.06.25
    
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [_tableView reloadData];
    NSString *isNewVersion = [[NSUserDefaults standardUserDefaults] objectForKey:IS_NEW_VERSION_2_6_SHOW_FEATURE];
    
    if (nil != isNewVersion) {
       [_featueImgView removeFromSuperview];
    }
}

-(void)checkNewVersion{
    
    isFirst = 0;
    
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Version",@"ac",
                          @"2",@"v",
                          @"check", @"op",
                          @"2", @"os",
                          currentVersion, @"name",
                          nil];
    
    [network sendHttpReq:HttpReq_Version andData:data];
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    
    // 背景图片
    UIImageView *imgView_bgImg =[UIImageView new];
    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    [self.view addSubview:imgView_bgImg];
    [imgView_bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(WIDTH,HEIGHT));
    }];
    
    // 设置背景scrollView
    UIScrollView* scrollerView = [UIScrollView new];
    scrollerView.contentSize = CGSizeMake(WIDTH, HEIGHT - 44);
    scrollerView.scrollEnabled = YES;
    scrollerView.delegate = self;
    scrollerView.bounces = YES;
    scrollerView.alwaysBounceHorizontal = NO;
    scrollerView.alwaysBounceVertical = YES;
    scrollerView.directionalLockEnabled = YES;
    [self.view addSubview:scrollerView];
    [scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(WIDTH,HEIGHT-44));
    }];
    
    // icon
    UIImageView *image_head_bg =[UIImageView new];
    image_head_bg.image=[UIImage imageNamed:@"newLogo.png"];
    image_head_bg.contentMode = UIViewContentModeScaleToFill;
    [scrollerView addSubview:image_head_bg];
    [image_head_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollerView.mas_top).with.offset(25);
        make.left.equalTo(scrollerView.mas_left).with.offset((WIDTH-60)/2);
        make.size.mas_equalTo(CGSizeMake(60,60));
    }];

    UILabel *label_username = [UILabel new];
    label_username.text = G_VERSION;
    //label_username.lineBreakMode = NSLineBreakByWordWrapping;
    label_username.font = [UIFont systemFontOfSize:18.0f];
    label_username.numberOfLines = 0;
    label_username.textColor = [UIColor blackColor];
    label_username.backgroundColor = [UIColor clearColor];
    label_username.lineBreakMode = NSLineBreakByTruncatingTail;
    label_username.textAlignment = NSTextAlignmentCenter;
    [scrollerView addSubview:label_username];
    [label_username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(image_head_bg.mas_bottom).with.offset(10);
        make.left.equalTo(scrollerView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(WIDTH,30));
    }];
    
    _tableView = [UITableView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    [scrollerView addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label_username.mas_bottom).with.offset(10);
        make.left.equalTo(scrollerView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(WIDTH,HEIGHT-44));
    }];

    // copyright 1
    UILabel *label_copyright1 = [UILabel new];
    label_copyright1.text = G_COPYRIGHT1;
    label_copyright1.font = [UIFont systemFontOfSize:12.0f];
    label_copyright1.numberOfLines = 0;
    label_copyright1.textColor = [UIColor blackColor];
    label_copyright1.backgroundColor = [UIColor clearColor];
    label_copyright1.lineBreakMode = NSLineBreakByTruncatingTail;
    label_copyright1.textAlignment = NSTextAlignmentCenter;
    [scrollerView addSubview:label_copyright1];
    [label_copyright1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).with.offset(-120);
        make.left.equalTo(scrollerView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(WIDTH,14));
    }];

    // copyright 2
    UILabel *label_copyright2 =[UILabel new];
    label_copyright2.text = G_COPYRIGHT2;
    //label_username.lineBreakMode = NSLineBreakByWordWrapping;
    label_copyright2.font = [UIFont systemFontOfSize:12.0f];
    label_copyright2.numberOfLines = 0;
    label_copyright2.textColor = [UIColor blackColor];
    label_copyright2.backgroundColor = [UIColor clearColor];
    label_copyright2.lineBreakMode = NSLineBreakByTruncatingTail;
    label_copyright2.textAlignment = NSTextAlignmentCenter;
    [scrollerView addSubview:label_copyright2];
    [label_copyright2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label_copyright1.mas_bottom).with.offset(15);
        make.left.equalTo(scrollerView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(WIDTH,14));
    }];

    // copyright 3
    UILabel *label_copyright3 =[UILabel new];
    label_copyright3.text = G_COPYRIGHT3;
    //label_username.lineBreakMode = NSLineBreakByWordWrapping;
    label_copyright3.font = [UIFont systemFontOfSize:12.0f];
    label_copyright3.numberOfLines = 0;
    label_copyright3.textColor = [UIColor blackColor];
    label_copyright3.backgroundColor = [UIColor clearColor];
    label_copyright3.lineBreakMode = NSLineBreakByTruncatingTail;
    label_copyright3.textAlignment = NSTextAlignmentCenter;
    [scrollerView addSubview:label_copyright3];
    [label_copyright3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label_copyright2.mas_bottom).with.offset(5);
        make.left.equalTo(scrollerView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(WIDTH,14));
    }];
    
    if(iPhone4){
        scrollerView.contentSize = CGSizeMake(WIDTH, HEIGHT+50);
        [label_copyright1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom).with.offset(-80);
            make.left.equalTo(scrollerView.mas_left).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(WIDTH,14));
        }];
    }
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    if (G_CERVERSION == 99) {
        
        return 2;
     
    }else{
        return 4;
    }
  
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定行的高度
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    
    if (G_CERVERSION == 99) {
        
       if (0 == [indexPath section] && 0 == [indexPath row]){
            cell.textLabel.text = @"使用协议";
        }else if (0 == [indexPath section] && 1 == [indexPath row]){
            cell.textLabel.text = @"版权说明";
        }else{
            return nil;
        }
    }else{
        if (0 == [indexPath section] && 0 == [indexPath row]) {
            cell.textLabel.text = @"检查新版本";
            
            NSString *isNewVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"zhixiao_isNewVersion"];
            
            if ([@"1"  isEqual: isNewVersion]) {
                UIImageView *imgView = [[UIImageView alloc]init];
                imgView.frame = CGRectMake(112, (41 - 18)/2+2, 32, 20);
                imgView.image = [UIImage imageNamed:@"icon_forNew.png"];
                
                [cell addSubview:imgView];
            }

        }else if (0 == [indexPath section] && 1 == [indexPath row]){
            
            //更新日志去掉new标记 2.9.4迭代2需求 2016.2.18
//            NSString *isNewVersion = [[NSUserDefaults standardUserDefaults] objectForKey:IS_NEW_VERSION_2_6_SHOW_FEATURE];
//            
//            if (nil == isNewVersion) {
//                _featueImgView.frame = CGRectMake(97, (44 - 18)/2+2, 32, 20);
//                _featueImgView.image = [UIImage imageNamed:@"icon_forNew.png"];
//                
//                [cell addSubview:_featueImgView];
//            }else {
//                [_featueImgView removeFromSuperview];
//            }

            cell.textLabel.text = @"更新日志";
        }else if (0 == [indexPath section] && 2 == [indexPath row]){
            cell.textLabel.text = @"使用协议";
        }else if (0 == [indexPath section] && 3 == [indexPath row]){
            cell.textLabel.text = @"版权说明";
        }else{
            return nil;
        }
    }
    
    //设置textLabel的背景色为空
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}

//选中Cell响应事件【
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    if (G_CERVERSION == 99){
    
        if (0 == [indexPath section] && 0 == [indexPath row]) {
            CalltipsViewController *calltipsViewCtrl = [[CalltipsViewController alloc] init];
            [self.navigationController pushViewController:calltipsViewCtrl animated:YES];
            
        }else if (0 == [indexPath section] && 1 == [indexPath row]){
            ServerViewController *serverViewCtrl = [[ServerViewController alloc] init];
            [self.navigationController pushViewController:serverViewCtrl animated:YES];

        }
    
    }else{
        if (0 == [indexPath section] && 0 == [indexPath row]) {
            
            [ReportObject event:ID_CHECK_VERSION];//2015.06.25
            
            [Utilities showProcessingHud:self.view];
            
            NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Version",@"ac",
                                  @"2",@"v",
                                  @"check", @"op",
                                  @"2", @"os",
                                  currentVersion, @"name",
                                  nil];
            isFirst = 1;
            [network sendHttpReq:HttpReq_Version andData:data];
            
        }else if (0 == [indexPath section] && 1 == [indexPath row]){
            
            SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
            
            NSURL *url;
#if IS_TEST_SERVER
            url = [NSURL URLWithString:@"https://test.5xiaoyuan.cn/open/index.php/Home/UpdateLog/index"];
#else
            url = [NSURL URLWithString:@"http://www.5xiaoyuan.cn/open/index.php/Home/UpdateLog/index"];
#endif
            //fileViewer.fromName = @"message";
            fileViewer.webType = SWLoadURl;//2015.09.23
            fileViewer.url = url;
            fileViewer.isShowSubmenu = @"0";
            [self.navigationController pushViewController:fileViewer animated:YES];
            //2.9.4 迭代2需求 去掉更新日志的new 2016.02.18
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//            [userDefaults setObject:@"1" forKey:IS_NEW_VERSION_2_6_SHOW_FEATURE];
//            [userDefaults synchronize];
            
            [ReportObject event:ID_OPEN_UPDATE_LOG];//2015.06.25
            
        }else if (0 == [indexPath section] && 2 == [indexPath row]){
            CalltipsViewController *calltipsViewCtrl = [[CalltipsViewController alloc] init];
            [self.navigationController pushViewController:calltipsViewCtrl animated:YES];
        }else if (0 == [indexPath section] && 3 == [indexPath row]){
            ServerViewController *serverViewCtrl = [[ServerViewController alloc] init];
            [self.navigationController pushViewController:serverViewCtrl animated:YES];
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
    NSString* message_info1 = [resultJSON objectForKey:@"message"];
    NSDictionary* message_info = [resultJSON objectForKey:@"message"];
    NSLog(@"messageStr:%@",message_info1);
    NSString *code = [message_info objectForKey:@"code"];
    NSString *note= [message_info objectForKey:@"note"];
    NSString *uptype= [message_info objectForKey:@"type"];
    _updateUrl = [message_info objectForKey:@"url"];
    
//    {"protocol":"do_version","result":true,"message":{"os":2,"type":1,"code":1,"url":"http://116.255.225.145:9797/weixiao/weixiao1.0.0.14.apk"}}
    
     __block AboutViewController *blockSelf = self;
    
    if(true == [result intValue])
    {
        int currentVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] intValue];
        
        if ([code intValue] > currentVersion) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"zhixiao_isNewVersionPopupShow"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            if (1 == [uptype intValue]) {
                
            //------update by kate 2014.11.04---------------------------------------------------
                
//                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
//                                                               message:note
//                                                              delegate:self
//                                                     cancelButtonTitle:@"确定"
//                                                     otherButtonTitles:@"取消",nil];
//                alert.tag = 122;
//                [alert show];
                
                if(checkUpdateAlert == nil){
                    
                    if (isFirst == 1) {
                        
                        checkUpdateAlert = [[CXAlertView alloc]initWithTitle:@"版本更新" message:note cancelButtonTitle:nil];
                        [checkUpdateAlert addButtonWithTitle:@"暂不更新"
                                                        type:CXAlertViewButtonTypeDefault
                                                     handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                                         // Dismiss alertview
                                                         [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"zhixiao_isNewVersionPopupShow"];
                                                         [[NSUserDefaults standardUserDefaults] synchronize];
                                                         
                                                         [alertView dismiss];
                                                         
                                                         blockSelf->checkUpdateAlert = nil;
                                                     }];
                        
                        // This is a demo for changing content at realtime.
                        [checkUpdateAlert addButtonWithTitle:@"立即更新"
                                                        type:CXAlertViewButtonTypeCancel
                                                     handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                                         [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"zhixiao_isNewVersionPopupShow"];
                                                         [[NSUserDefaults standardUserDefaults] synchronize];
                                                         
                                                         NSURL *url = [[NSURL alloc]initWithString:blockSelf.updateUrl];
                                                         [[UIApplication sharedApplication ]openURL:url];
                                                         
                                                         [alertView dismiss];
                                                         
                                                         blockSelf->checkUpdateAlert = nil;
                                                         
                                                     }];
                        
                        [checkUpdateAlert show];
                    }
                    
                }
                
            //------------------------------------------------------------------------------------
                
            }else {
            //------update by kate 2014.11.04-----------------------------------------------------
                
//                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
//                                                               message:note
//                                                              delegate:self
//                                                     cancelButtonTitle:@"确定"
//                                                     otherButtonTitles:nil,nil];
//                alert.tag = 122;
//                [alert show];
                if(checkUpdateAlert == nil){
                    
                    if (isFirst == 1) {
                    
                        checkUpdateAlert = [[CXAlertView alloc]initWithTitle:@"版本更新" message:note cancelButtonTitle:nil];
                        // This is a demo for changing content at realtime.
                        [checkUpdateAlert addButtonWithTitle:@"立即更新"
                                                        type:CXAlertViewButtonTypeDefault
                                                     handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                                         [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"zhixiao_isNewVersionPopupShow"];
                                                         [[NSUserDefaults standardUserDefaults] synchronize];
                                                         
                                                         [alertView dismiss];
                                                         
                                                         NSURL *url = [[NSURL alloc]initWithString:blockSelf.updateUrl];
                                                         [[UIApplication sharedApplication ]openURL:url];
                                                         
                                                     }];
                        [checkUpdateAlert show];

                        
                    }
                    
                }
               
            //-----------------------------------------------------------------------------------

            }

        }else{
            
            if (isFirst == 1) {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                               message:@"目前已是最新版本"
                                                              delegate:self
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
                [alert show];
            }
            
        }
    }
    else
    {
        if (isFirst == 1) {
            // temporary
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"网络异常，请稍后再试"
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
       
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    [self.navigationController popViewControllerAnimated:YES];
    if (alertView.tag == 122) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"zhixiao_isNewVersionPopupShow"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        if (buttonIndex == 0) {
            NSURL *url = [[NSURL alloc]initWithString:self.updateUrl];
            [[UIApplication sharedApplication ]openURL:url];
        }else{
            
        }
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

@end
