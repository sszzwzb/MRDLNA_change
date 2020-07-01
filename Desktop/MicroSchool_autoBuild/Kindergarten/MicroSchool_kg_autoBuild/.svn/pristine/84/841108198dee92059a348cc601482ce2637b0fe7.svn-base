//
//  SchoolEventDetailViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-5.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "SchoolEventDetailViewController.h"
#import "SingleWebViewController.h"

@interface SchoolEventDetailViewController ()

@end

@implementation SchoolEventDetailViewController

@synthesize eid;

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
    [super setCustomizeTitle:@"校园活动"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinSchoolEvent:) name:@"Weixiao_joinSchoolEvent" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToFileView:) name:@"Weixiao_gotoFileView" object:nil];
   

}

- (void)viewWillAppear:(BOOL)animated
{
    [super hideLeftAndRightLine];
    [super setCustomizeLeftButton];
}

-(void)goToFileView:(NSNotification *)notification
{
    NSURL *url = [[notification userInfo] objectForKey:@"requestURL"];
#if 0
    FileViewerViewController *fileViewer = [[FileViewerViewController alloc] init];
    fileViewer.requestURL = url;
    fileViewer.titlea = @"内容";
#endif
    
    // 2015.09.23
    SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
    fileViewer.webType = SWFile;
    fileViewer.url = url;
    fileViewer.titleName = @"内容";
    
    [self.navigationController pushViewController:fileViewer animated:YES];
}

-(void)joinSchoolEvent:(NSNotification *)notification
{
    [Utilities showProcessingHud:self.view];
    
    // update 2015.06.23 用新接口
    /**
     * 报名参加活动
     * @author luke
     * @date
     *  2015.04.21
     * @args
     *  op=enroll, sid=, uid=, eid=
     */
    
    NSString *isJoin;
    if ([@"1"  isEqual: joinStr]) {
        isJoin = @"quit";
    } else {
        //isJoin = @"join";
        isJoin = @"enroll";
    }
    
//    // 获取当前用户的uid
//    NSDictionary *user = [g_userInfo getUserDetailInfo];
//    NSString* name= [user objectForKey:@"name"];

//    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          AC_CP_SCHOOLEVENT, @"url",
//                          self.eid, @"id",
//                          name, @"username",
//                          isJoin, @"op",
//                          nil];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL,@"url",
                          @"Event",@"ac",
                          @"2",@"v",
                          self.eid, @"eid",
                          isJoin, @"op",
                          nil];
    
    [network sendHttpReq:HttpReq_SchoolEventJoin andData:data];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    //self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, [UIScreen mainScreen].applicationFrame.size.height)];
    
    if (iPhone5)
    {
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height-49)];

        //self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    }
    else
    {
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height-49)];
    }
    
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
        [self.view addSubview:noNetworkV];
        return;
        
    }

    // 先转菊花
    [Utilities showProcessingHud:self.view];
    
    // 缩略图
    imgView_thumb =[[UIImageView alloc]initWithFrame:CGRectMake(10,15,130,100)];
    imgView_thumb.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:imgView_thumb];
    
    // 活动是否结束图片
    imgView_status =[[UIImageView alloc]initWithFrame:CGRectMake(10,
                                                                 15,
                                                                 50,
                                                                 50)];
    
    imgView_status.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:imgView_status];

    // 标题
    label_title = [[UILabel alloc] initWithFrame:CGRectMake(
                                                    imgView_thumb.frame.origin.x + imgView_thumb.frame.size.width + 8,
                                                    imgView_thumb.frame.origin.y - 4,
                                                    WIDTH - imgView_thumb.frame.origin.x - imgView_thumb.frame.size.width - 5,
                                                    40)];
    //设置title自适应对齐
    label_title.lineBreakMode = NSLineBreakByWordWrapping;
    label_title.font = [UIFont systemFontOfSize:15.0f];
    label_title.numberOfLines = 2;
    label_title.lineBreakMode = NSLineBreakByTruncatingTail;

    label_title.textColor = [UIColor blackColor];
    [self.view addSubview:label_title];

    // category图片
    imgView_category =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                label_title.frame.origin.x,
                                                label_title.frame.origin.y + label_title.frame.size.height + 5,
                                                11,
                                                11)];
    
    imgView_category.image=[UIImage imageNamed:@"icon_event_detail_category.png"];
    imgView_category.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:imgView_category];

    // category
    label_category = [[UILabel alloc] initWithFrame:CGRectMake(
                                                imgView_category.frame.origin.x + imgView_category.frame.size.width + 5,
                                                imgView_category.frame.origin.y,
                                                label_title.frame.size.width,
                                                12)];
    
    label_category.font = [UIFont systemFontOfSize:12.0f];
    label_category.textColor = [UIColor grayColor];
    label_category.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label_category];

    // time图片
    imgView_time =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                   imgView_category.frame.origin.x,
                                                                   imgView_category.frame.origin.y + imgView_category.frame.size.height + 7,
                                                                   11,
                                                                   11)];
    
    imgView_time.image=[UIImage imageNamed:@"icon_event_start_time.png"];
    imgView_time.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:imgView_time];

    // time
    label_time = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               imgView_time.frame.origin.x + imgView_time.frame.size.width + 5,
                                                               imgView_time.frame.origin.y,
                                                               label_title.frame.size.width,
                                                               12)];
    
    label_time.font = [UIFont systemFontOfSize:12.0f];
    label_time.textColor = [UIColor grayColor];
    label_time.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label_time];

    // location图片
    imgView_location =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                               imgView_time.frame.origin.x,
                                                               imgView_time.frame.origin.y + imgView_time.frame.size.height + 7,
                                                               11,
                                                               11)];
    
    imgView_location.image=[UIImage imageNamed:@"icon_event_list_location.png"];
    imgView_location.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:imgView_location];

    // location
    label_location = [[UILabel alloc] initWithFrame:CGRectMake(
                                                           imgView_location.frame.origin.x + imgView_location.frame.size.width + 5,
                                                           imgView_location.frame.origin.y,
                                                           label_title.frame.size.width,
                                                           12)];
    
    label_location.font = [UIFont systemFontOfSize:12.0f];
    label_location.textColor = [UIColor grayColor];
    label_location.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label_location];

    [self performSelector:@selector(doGetEventDetail) withObject:nil afterDelay:0.3];
    
    schEventDetailTabbar = [[SchoolEventDetailTabBarController alloc]init];
    //schEventDetailTabbar.tabBar.frame = CGRectMake(0,0,320,44);
    
    eventDetail = [[EventDetailViewController alloc] init];
    eventMember = [[EventMemberViewController alloc] init];
    eventPhoto = [[EventPhotoViewController alloc] init];
    eventTopic = [[EventTopicViewController alloc] init];
    
    NSArray *viewControllers = [NSArray arrayWithObjects:eventDetail,eventMember,eventPhoto,eventTopic, nil];
    [schEventDetailTabbar setViewControllers:viewControllers];
    
    [self.view addSubview:schEventDetailTabbar.view];
}

-(void) doGetEventDetail
{
    [Utilities showProcessingHud:self.view];
    /**2015.06.23
     * 学校活动详情
     * @author luke
     * @date
     * @args
     *  op=event, sid=, uid=, eid=活动ID, width=屏幕宽度
     */

//    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          AC_SCHOOLEVENT, @"url",
//                          self.eid, @"eid",
//                          nil];
    
//    NSString *width = [NSString stringWithFormat:@"%f",[UIScreen mainScreen].bounds.size.width];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                    REQ_URL, @"url",
                                                    @"Event",@"ac",
                                                    @"2",@"v",
                                                    @"event",@"op",
                                                    self.eid, @"eid",
                                                    @"290",@"width",
                                                    nil];
    
    [network sendHttpReq:HttpReq_SchoolEventDetail andData:data];
    
    
}

-(void)selectLeftAction:(id)sender
{
    [network cancelCurrentRequest];

    [Utilities dismissProcessingHud:self.view];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    //NSLog(@"resultJSON:%@",resultJSON);
    NSString *result = [resultJSON objectForKey:@"result"];
    
    [Utilities dismissProcessingHud:self.view];

    if([@"EventAction.enroll"  isEqual: [resultJSON objectForKey:@"protocol"]] || [@"EventAction.quit"  isEqual: [resultJSON objectForKey:@"protocol"]])
    {
        if(true == [result intValue])
        {
            NSString *message_info = [resultJSON objectForKey:@"message"];
            [self.view makeToast:message_info
                        duration:0.5
                        position:@"bottom"
                           title:nil];
            
            if ([@"EventAction.enroll"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
                //参加活动
                [ReportObject event:ID_JOIN_EVENT];//2015.06.23
                
            }else{
                //退出活动
                [ReportObject event:ID_QUIT_EVENT];//2015.06.23
            }

            [self doGetEventDetail];
        }
        else
        {
            NSString *message_info = [resultJSON objectForKey:@"message"];
            [self.view makeToast:message_info
                        duration:0.5
                        position:@"bottom"
                           title:nil];
        }
    }
    else
    {
        if(true == [result intValue])
        {
            [Utilities dismissProcessingHud:self.view];
            
            NSDictionary* message_info = [resultJSON objectForKey:@"message"];
            
            self->label_title.text = [message_info objectForKey:@"title"];
            
            NSString * mtagtype = [message_info objectForKey:@"mtagtype"];
            NSString* starttime= [message_info objectForKey:@"starttime"];
            NSString* endtime= [message_info objectForKey:@"endtime"];
            NSString* location= [message_info objectForKey:@"location"];
            NSString* status= [message_info objectForKey:@"status"];
            NSString* membernum= [message_info objectForKey:@"membernum"];
            NSString* joined= [NSString stringWithFormat:@"%@", [message_info objectForKey:@"joined"]] ;
            
            Utilities *util = [Utilities alloc];
            
            NSString *startStr = [NSString stringWithFormat: @"%@",
                                  [util linuxDateToString:starttime andFormat:@"%@/%@ %@:%@" andType:DateFormat_MDHM]];
            
            NSString *endStr = [NSString stringWithFormat: @"%@",
                                [util linuxDateToString:endtime andFormat:@"%@/%@ %@:%@" andType:DateFormat_MDHM]];
            
            NSString *timeStr = [[startStr stringByAppendingString:@"-"] stringByAppendingString:endStr];
            
            self->label_time.text = timeStr;
            self->label_location.text = location;
            
            if ([@"class"  isEqual: mtagtype]) {
                self->label_category.text = @"班级";;
            }
            else if ([@"league"  isEqual: mtagtype]) {
                self->label_category.text = @"社团";;
            }
            else {
                self->label_category.text = @"校园";
            }
            
            // 活动是否结束图片
            if (1 == status.integerValue)
            {
                [self->imgView_status setImage:[UIImage imageNamed:@"icon_event_list_event_over.png"]];
            }
            else if (0 == status.integerValue)
            {
                [self->imgView_status setImage:[UIImage imageNamed:@"icon_event_list_event_going.png"]];
            }
            
            [self->imgView_thumb sd_setImageWithURL:[NSURL URLWithString:[message_info objectForKey:@"poster"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            
            [self->eventDetail setDetailMsg:[message_info objectForKey:@"detail"] andPics:[message_info objectForKey:@"pics"]];
            [self->eventDetail getJoined:joined andStatus:status andNum:membernum];
            
            [self->eventMember getMember:self.eid andJoined:joined andStatus:status andNum:membernum];
            [self->eventPhoto getPhoto:self.eid andJoined:joined andStatus:status andNum:membernum];
            joinStr = joined;
            statusStr = status;
            [self->eventTopic getTopic:self.eid andJoined:joined andStatus:status andNum:membernum];

            //[self performSelector:@selector(eventTopic) withObject:nil afterDelay:0.3];
        }
        else
        {
            [Utilities dismissProcessingHud:self.view];
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"获取信息失败，请稍候再试"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void)eventTopic
{
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

- (IBAction)buttonJoin:(id)sender
{
    NSLog(@"lakjflkjsd");
}

@end
