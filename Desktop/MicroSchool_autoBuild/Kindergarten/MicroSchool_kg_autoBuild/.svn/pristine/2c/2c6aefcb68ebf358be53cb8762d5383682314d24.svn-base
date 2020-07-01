//
//  ActCmdOpenViewController.m
//  MicroSchool
//
//  Created by jojo on 14/11/17.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "ActCmdOpenViewController.h"

@interface ActCmdOpenViewController ()

@end

@implementation ActCmdOpenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super setCustomizeTitle:@"我的消息"];
    [self setCustomizeLeftButton];
    
    network = [NetworkUtility alloc];
    network.delegate = self;
    
    // bg scrollView
    _scrollViewBg = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320 , [UIScreen mainScreen].applicationFrame.size.height - 44)];
    _scrollViewBg.contentSize = CGSizeMake(320, [UIScreen mainScreen].applicationFrame.size.height - 44);
    _scrollViewBg.scrollEnabled = YES;
    _scrollViewBg.delegate = self;
    _scrollViewBg.backgroundColor = [[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0];
    [self.view addSubview:_scrollViewBg];
    
    // 头像
    _imageView_img =[[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 70, 70)];
    _imageView_img.contentMode = UIViewContentModeScaleToFill;
    _imageView_img.layer.masksToBounds = YES;
    _imageView_img.layer.cornerRadius = 70/2;
    [_imageView_img sd_setImageWithURL:[NSURL URLWithString:[_action_msg objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    [_scrollViewBg addSubview:_imageView_img];
    
    // 名字
    _label_name = [[UILabel alloc] initWithFrame:CGRectMake(
                                                            _imageView_img.frame.origin.x + _imageView_img.frame.size.width + 10,
                                                            _imageView_img.frame.origin.y+2, 160, 20)];
    _label_name.lineBreakMode = NSLineBreakByWordWrapping;
    _label_name.font = [UIFont systemFontOfSize:15.0f];
    _label_name.textColor = [UIColor blackColor];
    _label_name.backgroundColor = [UIColor clearColor];
    _label_name.text = [_action_msg objectForKey:@"username"];
    [_scrollViewBg addSubview:_label_name];
    
    // 内容
    _label_title = [[UILabel alloc] initWithFrame:CGRectMake(
                                                             _label_name.frame.origin.x,
                                                             _label_name.frame.origin.y + _label_name.frame.size.height + 5,
                                                             210, 20)];
    _label_title.lineBreakMode = NSLineBreakByTruncatingTail;
    _label_title.font = [UIFont systemFontOfSize:14.0f];
    _label_title.textColor = [UIColor blackColor];
    _label_title.backgroundColor = [UIColor clearColor];
    _label_title.text = [NSString stringWithFormat:@"%@", [_action_msg objectForKey:@"title"]];
    [_scrollViewBg addSubview:_label_title];
    
    // 时间
    _label_time = [[UILabel alloc] initWithFrame:CGRectMake(
                                                            _label_title.frame.origin.x,
                                                            _label_title.frame.origin.y + _label_title.frame.size.height + 5,
                                                            160, 20)];
    _label_time.lineBreakMode = NSLineBreakByWordWrapping;
    _label_time.font = [UIFont systemFontOfSize:14.0f];
    _label_time.textColor = [UIColor lightGrayColor];
    _label_time.backgroundColor = [UIColor clearColor];
    Utilities *util = [Utilities alloc];
    _label_time.text = [util linuxDateToString:[_action_msg objectForKey:@"dateline"] andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
    [_scrollViewBg addSubview:_label_time];
    
    // 头像下方的线
    UIImageView *imgView_line1 =[[UIImageView alloc]initWithFrame:CGRectMake(20,
                                                                             _imageView_img.frame.origin.y + _imageView_img.frame.size.height + 10,
                                                                             280,1)];
    [imgView_line1 setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
    [_scrollViewBg addSubview:imgView_line1];
    
    // 请求内容
    _label_msg = [[UILabel alloc] initWithFrame:CGRectMake(imgView_line1.frame.origin.x,
                                                           imgView_line1.frame.origin.y + imgView_line1.frame.size.height + 10, 280 , 20)];
    _label_msg.lineBreakMode = NSLineBreakByWordWrapping;
    _label_msg.font = [UIFont systemFontOfSize:16.0f];
    _label_msg.textColor = [UIColor blackColor];
    _label_msg.numberOfLines = 0;
    _label_msg.backgroundColor = [UIColor clearColor];
    
    NSString *msg = [NSString stringWithFormat:@"%@", [_action_msg objectForKey:@"message"]];
    
    if ([@""  isEqual: msg]) {
        msg = @"申请说明: (未填写)";
        
        NSMutableAttributedString *pstr = [[NSMutableAttributedString alloc] initWithString:msg];
        [pstr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,4)];
        [pstr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(6,5)];
        [pstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(0, 4)];
        [pstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(6,5)];
        
        [_label_msg setAttributedText:pstr];
    }else {
        _label_msg.text = [NSString stringWithFormat:@"申请说明: %@", [_action_msg objectForKey:@"message"]];
    }
    
    CGSize strSize = [Utilities getStringHeight:[_action_msg objectForKey:@"title"] andFont:[UIFont systemFontOfSize:16] andSize:CGSizeMake(280, 0)];
    
    _label_msg.frame = CGRectMake(imgView_line1.frame.origin.x,
                                  imgView_line1.frame.origin.y + imgView_line1.frame.size.height + 10, 280 , strSize.height + 40);
    
    [_scrollViewBg addSubview:_label_msg];
    
    UILabel *label_id;
    
    NSLog(@"%f",label_id.frame.size.height);
    
    if ([@"apply_teacher"  isEqual: _actType]) {
        // 教师审核时候的有效证件
        label_id = [[UILabel alloc] initWithFrame:CGRectMake(_label_msg.frame.origin.x,
                                                             _label_msg.frame.origin.y + _label_msg.frame.size.height + 30, 300 , 20)];
        label_id.lineBreakMode = NSLineBreakByWordWrapping;
        label_id.font = [UIFont systemFontOfSize:16.0f];
        label_id.textColor = [UIColor blackColor];
        label_id.numberOfLines = 0;
        label_id.backgroundColor = [UIColor clearColor];
        label_id.text = @"有效证件";
        
        NSString *msg = [NSString stringWithFormat:@"%@", [_action_msg objectForKey:@"pic"]];
        
        if ([@""  isEqual: msg]) {
            msg = @"有效证件: (未填写)";
            
            NSMutableAttributedString *pstr = [[NSMutableAttributedString alloc] initWithString:msg];
            [pstr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,4)];
            [pstr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(6,5)];
            [pstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(0, 4)];
            [pstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(6,5)];
            
            [label_id setAttributedText:pstr];
        }else {
            label_id.text = @"有效证件:";
            
            _imgView_teacher =[[UIImageView alloc]initWithFrame:CGRectMake(label_id.frame.origin.x,
                                                                           label_id.frame.origin.y + label_id.frame.size.height + 20, 150, 150)];
            _imgView_teacher.contentMode = UIViewContentModeScaleAspectFit;
            [_imgView_teacher sd_setImageWithURL:[NSURL URLWithString:[_action_msg objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            [_scrollViewBg addSubview:_imgView_teacher];
            
            UIButton *touchImgHeadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            touchImgHeadBtn.frame = _imgView_teacher.frame;
            [touchImgHeadBtn addTarget:self action:@selector(touchImgHeadAction) forControlEvents:UIControlEventTouchUpInside];
            touchImgHeadBtn.backgroundColor = [UIColor clearColor];
            [_scrollViewBg addSubview:touchImgHeadBtn];
        }
        
        [_scrollViewBg addSubview:label_id];
    }
    
    
    // btn action
    NSArray *btnArr = [_action_msg objectForKey:@"actions"];
    //    NSDictionary *a = [btnArr objectAtIndex:0];
    //    NSString *b = [a objectForKey:@"title"];
    
    
    int startHeight = _label_msg.frame.size.height + 30 + label_id.frame.size.height + _imgView_teacher.frame.size.height + 30;
    int height = startHeight;
    
    for (int i=0; i<[btnArr count]; i++) {
        //    }
        //    if (0 != [btnArr count]) {
        UIButton *btn_act1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_act1.frame = CGRectMake(10, _label_msg.frame.origin.y + startHeight + 10+i + 40*i + 10*i, 300, 40);
        
        btn_act1.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn_act1.tag = i;
        
        // 设置title自适应对齐
        btn_act1.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        // 设置颜色和字体
        [btn_act1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_act1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        btn_act1.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        [btn_act1 setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal] ;
        [btn_act1 setBackgroundImage:[UIImage imageNamed:@"btn_common__1_p.png"] forState:UIControlStateHighlighted] ;
        
        
        
        
        // 设置颜色和字体
        //        [btn_act1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        [btn_act1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        //        btn_act1.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        //        [btn_act1 setBackgroundImage:[UIImage imageNamed:@"btn_common_2-d.png"] forState:UIControlStateNormal] ;
        //        [btn_act1 setBackgroundImage:[UIImage imageNamed:@"btn_common_2_p.png"] forState:UIControlStateHighlighted] ;
        
        // 添加 action
        [btn_act1 addTarget:self action:@selector(actCmd_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        
        //设置title
        [btn_act1 setTitle:[[btnArr objectAtIndex:i] objectForKey:@"title"] forState:UIControlStateNormal];
        [btn_act1 setTitle:[[btnArr objectAtIndex:i] objectForKey:@"title"] forState:UIControlStateHighlighted];
        
        height = btn_act1.frame.origin.y + btn_act1.frame.size.height + 20;
        
        [_scrollViewBg addSubview:btn_act1];
    }
    
    _scrollViewBg.contentSize = CGSizeMake(320, height+1);
    
    
    //    NSString *a = [_action_msg objectForKey:@"title"];
    //    int b;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(void)touchImgHeadAction{
    
    NSDictionary *message_info;
    message_info = [g_userInfo getUserDetailInfo];
    
    // 数据部分
    if (nil == message_info) {
        message_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDetailInfo"];
    }
    
    //    NSString* uid = [message_info objectForKey:@"uid"];
    //    Utilities *util = [Utilities alloc];
    //NSString* head_url = [util getAvatarFromUid:[NSString stringWithFormat:@"%@", uid] andType:@"2"];
    //    NSString *head_url = [message_info objectForKey:@"avatar"];
    NSString *imgUrl =   [_action_msg objectForKey:@"pic"];
    
    // 1.封装图片数据
    //设置所有的图片。photos是一个包含所有图片的数组。
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.save = NO;
    photo.url = [NSURL URLWithString:imgUrl]; // 图片路径
    photo.srcImageView = _imgView_teacher; // 来源于哪个UIImageView
    [photos addObject:photo];
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)selectLeftAction:(id)sender
{
    // 取消所有的网络请求
    [network cancelCurrentRequest];
    
    // 退回到上个画面
    [self.navigationController popViewControllerAnimated:YES];
}

// 同意/拒绝
- (IBAction)actCmd_btnclick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    NSArray *btnArr = [_action_msg objectForKey:@"actions"];
    NSDictionary *dic = [btnArr objectAtIndex:btn.tag];
    
    NSDictionary *act = [dic objectForKey:@"params"];
    
    self.actDiction = [[NSDictionary alloc] initWithDictionary:act];
    
    if ([@"friend"  isEqual: _actType]) {
        // 好友请求
        if (btn.tag == 1) {// 拒绝 add by kate
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"请输入拒绝理由"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
            alert.tag = 201;
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            reasonTF = [alert textFieldAtIndex:0];
            reasonTF.delegate = self;
            reasonTF.placeholder = @"请输入最多30个字";
            reasonTF.returnKeyType = UIReturnKeyDone;
            [alert show];
            
        }else{// 同意
            
            [Utilities showProcessingHud:self.view];
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  [act objectForKey:@"v"], @"v",
                                  [act objectForKey:@"ac"], @"ac",
                                  [act objectForKey:@"op"], @"op",
                                  [act objectForKey:@"uid"], @"uid",
                                  [act objectForKey:@"fuid"], @"fuid",
                                  [act objectForKey:@"mid"], @"mid",
                                  [act objectForKey:@"sid"], @"sid",
                                  nil];
            
            [network sendHttpReq:HttpReq_FriendAddAccept andData:data];
        }
        
    }else if ([@"apply_class"  isEqual: _actType]) {
        // 班级请求
        _btn_tag = btn.tag;
        
        if (btn.tag == 1) {// 拒绝 add by kate
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"请输入拒绝理由"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
            alert.tag = 201;
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            reasonTF = [alert textFieldAtIndex:0];
            reasonTF.delegate = self;
            reasonTF.placeholder = @"请输入最多30个字";
            reasonTF.returnKeyType = UIReturnKeyDone;
            [alert show];
            
        }else{// 同意
            
            [Utilities showProcessingHud:self.view];
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  [act objectForKey:@"v"], @"v",
                                  [act objectForKey:@"ac"], @"ac",
                                  [act objectForKey:@"op"], @"op",
                                  [act objectForKey:@"uid"], @"uid",
                                  [act objectForKey:@"mid"], @"mid",
                                  [act objectForKey:@"sid"], @"sid",
                                  [act objectForKey:@"appId"], @"appId",
                                  [act objectForKey:@"agree"], @"agree",
                                  nil];
            
            [network sendHttpReq:HttpReq_JoinClass andData:data];
            
        }
        
    }else if ([@"apply_teacher"  isEqual: _actType]) {
        // 教师申请
        _btn_tag = btn.tag;
        
        if (btn.tag == 1) {// 拒绝 add by kate
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"请输入拒绝理由"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
            alert.tag = 201;
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            reasonTF = [alert textFieldAtIndex:0];
            reasonTF.delegate = self;
            reasonTF.placeholder = @"请输入最多30个字";
            reasonTF.returnKeyType = UIReturnKeyDone;
            [alert show];
        }else{
            // 同意
            [Utilities showProcessingHud:self.view];
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  [act objectForKey:@"v"], @"v",
                                  [act objectForKey:@"ac"], @"ac",
                                  [act objectForKey:@"uid"], @"uid",
                                  [act objectForKey:@"mid"], @"mid",
                                  [act objectForKey:@"aid"], @"aid",
                                  [act objectForKey:@"op"], @"op",
                                  [act objectForKey:@"sid"], @"sid",
                                  nil];
            
            [self doApply_teacher:data];
        }
    }
}

// add by kate 拒绝
-(void)rejectAction:(NSDictionary*)act{
    if ([@"friend"  isEqual: _actType]) {
        [Utilities showProcessingHud:self.view];
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              [act objectForKey:@"v"], @"v",
                              [act objectForKey:@"ac"], @"ac",
                              [act objectForKey:@"op"], @"op",
                              [act objectForKey:@"uid"], @"uid",
                              [act objectForKey:@"fuid"], @"fuid",
                              [act objectForKey:@"mid"], @"mid",
                              [act objectForKey:@"sid"], @"sid",
                              reasonTF.text,@"reason",
                              nil];
        
        [network sendHttpReq:HttpReq_FriendAddAccept andData:data];
        
    }else if ([@"apply_class"  isEqual: _actType]){
        [Utilities showProcessingHud:self.view];
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              [act objectForKey:@"v"], @"v",
                              [act objectForKey:@"ac"], @"ac",
                              [act objectForKey:@"op"], @"op",
                              [act objectForKey:@"uid"], @"uid",
                              [act objectForKey:@"mid"], @"mid",
                              [act objectForKey:@"sid"], @"sid",
                              [act objectForKey:@"appId"], @"appId",
                              [act objectForKey:@"agree"], @"agree",
                              reasonTF.text,@"reason",
                              nil];
        
        [network sendHttpReq:HttpReq_JoinClass andData:data];
    }else if ([@"apply_teacher"  isEqual: _actType]) {
        [Utilities showProcessingHud:self.view];
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              [act objectForKey:@"v"], @"v",
                              [act objectForKey:@"ac"], @"ac",
                              [act objectForKey:@"uid"], @"uid",
                              [act objectForKey:@"mid"], @"mid",
                              [act objectForKey:@"aid"], @"aid",
                              [act objectForKey:@"op"], @"op",
                              [act objectForKey:@"sid"], @"sid",
                              reasonTF.text,@"reason",
                              nil];
        
        [self doApply_teacher:data];
    }
}

- (void)doApply_teacher:(NSDictionary *)data
{
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        NSString *msg = [respDic objectForKey:@"message"];
        
        if(true == [result intValue]) {
            NSDictionary *dic;
            if ([data objectForKey:@"reason"] == NULL) {
                dic = [NSDictionary dictionaryWithObjectsAndKeys:
                       _mid, @"mid",
                       @"apply_teacher", @"msg",
                       [NSString stringWithFormat:@"%d",_btn_tag], @"yn",
                       @"", @"reason",
                       nil];

            }else{
            
                dic = [NSDictionary dictionaryWithObjectsAndKeys:
                       _mid, @"mid",
                       @"apply_teacher", @"msg",
                       [NSString stringWithFormat:@"%d",_btn_tag], @"yn",
                       [data objectForKey:@"reason"], @"reason",
                       nil];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"test111" object:self userInfo:dic];
            
            [Utilities showSuccessedHud:msg descView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"获取信息错误，请稍候再试"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    [Utilities dismissProcessingHud:self.view];
    
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    NSString *protocol = [resultJSON objectForKey:@"protocol"];
    
    if ([@"FriendAction.accept" isEqual: protocol]) {
        // 好友添加 同意
        NSString *msg = [resultJSON objectForKey:@"message"];
        
        if(true == [result intValue])
        {
            // 通知前列表画面更新数据
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 _mid, @"mid",
                                 @"FriendAction.accept", @"msg",
                                 nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"test111" object:self userInfo:dic];
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:msg
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
            
            [ReportObject event:ID_CHECK_SYSTEM_MESSAGE_BTN];//2015.06.25
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:msg
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }else if([@"FriendAction.reject" isEqual: protocol]) {
        // 好友添加 拒绝
        NSString *msg = [resultJSON objectForKey:@"message"];
        
        if(true == [result intValue])
        {
            // 通知前列表画面更新数据
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 _mid, @"mid",
                                 @"FriendAction.reject", @"msg",
                                 nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"test111" object:self userInfo:dic];
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:msg
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
            [ReportObject event:ID_CHECK_SYSTEM_MESSAGE_BTN];//2015.06.25
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:msg
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }else if([@"ClassAction.audit" isEqual: protocol]) {
        // 是否同意加入班级 0为同意，1为拒绝 yn
        NSString *msg = [resultJSON objectForKey:@"message"];
        
        if(true == [result intValue])
        {
            // 通知前列表画面更新数据
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 _mid, @"mid",
                                 @"ClassAction.audit", @"msg",
                                 [NSString stringWithFormat:@"%d",_btn_tag], @"yn",
                                 nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"test111" object:self userInfo:dic];
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:msg
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
            [ReportObject event:ID_CHECK_SYSTEM_MESSAGE_BTN];//2015.06.25
            
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:msg
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 201) {
        
        if (buttonIndex == 1) {
            
            [self rejectAction:self.actDiction];
            
        }
        
        
    }else{
        
        // 取消所有的网络请求
        [network cancelCurrentRequest];
        
        // 退回到上个画面
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{  // return NO to not change text
    
    if (range.location > 30) {
        return NO;
    }
    
    return YES;
    
}


@end
