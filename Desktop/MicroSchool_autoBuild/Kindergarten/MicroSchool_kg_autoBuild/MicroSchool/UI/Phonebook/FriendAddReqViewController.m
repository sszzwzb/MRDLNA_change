//
//  FriendAddReqViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-4-26.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "FriendAddReqViewController.h"

@interface FriendAddReqViewController ()

@end

@implementation FriendAddReqViewController

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
    
    [super setCustomizeTitle:@"发送好友请求"];
    [super setCustomizeLeftButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender
{
    // 取消所有的网络请求
    [network cancelCurrentRequest];
    
    // 退回到上个画面
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[ UIScreen mainScreen] .applicationFrame] ;
    self.view = view;
    
    [self doShowUserInfo];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
  
    [Utilities dismissProcessingHud:self.view];// 2015.05.12
    [self enableLeftAndRightKey];
    
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if(HttpReq_Profile == type)
    {
        if(true == [result intValue])
        {
            NSDictionary* message_info = [resultJSON objectForKey:@"message"];
            
            _spacenote = [message_info objectForKey:@"spacenote"];
            _avatar = [message_info objectForKey:@"avatar"];
            _school = [message_info objectForKey:@"class"];
            self.title = [message_info objectForKey:@"title"];
            
            [self doShowUserInfo];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"发送请求错误，请稍候再试"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        NSString* message_info = [resultJSON objectForKey:@"message"];
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:message_info
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

-(void)reciveHttpDataError:(NSError*)err
{
    
    [Utilities dismissProcessingHud:self.view];// 2015.05.12
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                   message:@"网络连接错误，请稍候再试"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){//键盘划过处理
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
 
    }
}

-(void)doShowUserInfo
{
    // 背景图片
    //    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,[UIScreen mainScreen].applicationFrame.size.height)];
    //    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    //    [self.view addSubview:imgView_bgImg];
    
    // 设置背景scrollView
    _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH , [UIScreen mainScreen].applicationFrame.size.height - 44)];
    _scrollerView.contentSize = CGSizeMake(WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44);
    _scrollerView.scrollEnabled = YES;
    _scrollerView.delegate = self;
    _scrollerView.bounces = YES;
    _scrollerView.alwaysBounceHorizontal = NO;
    _scrollerView.alwaysBounceVertical = YES;
    _scrollerView.directionalLockEnabled = YES;
    [self.view addSubview:_scrollerView];
    
    //    // 头像图片
    //    imgView =[[UIImageView alloc]initWithFrame:CGRectMake(20,20,60,60)];
    //    imgView.layer.masksToBounds = YES;
    //    imgView.layer.cornerRadius = 60/2;
    //    imgView.contentMode = UIViewContentModeScaleToFill;
    //    [imgView sd_setImageWithURL:[NSURL URLWithString:_avatar] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    //    [_scrollerView addSubview:imgView];
    //
    //    // 姓名
    //    label_name = [[UILabel alloc] initWithFrame:CGRectMake(90, 40, 280, 20)];
    //    label_name.textColor = [UIColor blackColor];
    //    label_name.backgroundColor = [UIColor clearColor];
    //    label_name.font = [UIFont boldSystemFontOfSize:14.0f];
    //    label_name.text = [[_name stringByAppendingString:@"|"] stringByAppendingString:self.title];
    //    [_scrollerView addSubview:label_name];
    //
    //    // 个性签名
    //    label_sign = [[UILabel alloc] initWithFrame:CGRectMake(label_name.frame.origin.x,
    //                                                           label_name.frame.origin.y +label_name.frame.size.height - 5,
    //                                                           260, 20)];
    //    label_sign.textColor = [UIColor grayColor];
    //    label_sign.font = [UIFont systemFontOfSize:12.0f];
    //    label_sign.backgroundColor = [UIColor clearColor];
    //    label_sign.lineBreakMode = NSLineBreakByTruncatingTail;
    //    if ([@""  isEqual: _spacenote]) {
    //        label_sign.text = @"";
    //    } else {
    //        label_sign.text = _spacenote;
    //        label_name.frame = CGRectMake(90, 40-10, 280, 20);
    //    }
    //    [_scrollerView addSubview:label_sign];
    
    //------update by kate 2014.12.01--------------------------------------------------
    // 背景图
    /*
     CGFloat top = 20; // 顶端盖高度
     CGFloat bottom = 20; // 底端盖高度
     CGFloat left = 100; // 左端盖宽度
     CGFloat right = 20; // 右端盖宽度
     
     UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
     
     // 指定为拉伸模式，伸缩后重新赋值
     UIImage *image_d = [UIImage imageNamed:@"friend/bg_add_friend"];
     image_d = [image_d resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
     
     UIImageView *imgView_thumb =[[UIImageView alloc]initWithFrame:CGRectMake(imgView.frame.origin.x,
     imgView.frame.origin.y + imgView.frame.size.height + 20,
     280,80)];
     imgView_thumb.contentMode = UIViewContentModeScaleToFill;
     imgView_thumb.image = image_d;
     [_scrollerView addSubview:imgView_thumb];
     
     _textFieldNote = [[UITextField alloc] initWithFrame: CGRectMake(
     imgView_thumb.frame.origin.x + 10,
     imgView_thumb.frame.origin.y + 15,
     300, 25)];
     _textFieldNote.clearsOnBeginEditing = NO;//鼠标点上时，不清空
     _textFieldNote.borderStyle = UITextBorderStyleNone;
     _textFieldNote.backgroundColor = [UIColor clearColor];
     //_textFieldNote.placeholder = @"请输入请求内容";
     _textFieldNote.font = [UIFont systemFontOfSize:14.0f];
     _textFieldNote.textColor = [UIColor blackColor];
     _textFieldNote.textAlignment = NSTextAlignmentLeft;
     _textFieldNote.keyboardType=UIKeyboardTypeDefault;
     _textFieldNote.returnKeyType =UIReturnKeyDone;
     
     [_textFieldNote setDelegate: self];
     [_textFieldNote performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.01];
     
     [_scrollerView addSubview: _textFieldNote];
     
     // 输入框下方的那个线
     UIImageView *imgView_line1 =[[UIImageView alloc]initWithFrame:CGRectMake(_textFieldNote.frame.origin.x,
     _textFieldNote.frame.origin.y + _textFieldNote.frame.size.height + 2,
     265,
     2)];
     [imgView_line1 setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
     [_scrollerView addSubview:imgView_line1];
     
     // 发送添加好友请求button
     button_sendReq = [UIButton buttonWithType:UIButtonTypeCustom];
     button_sendReq.frame = CGRectMake(
     imgView_thumb.frame.origin.x + imgView_thumb.frame.size.width - 10 - 60,
     imgView_line1.frame.origin.y + imgView_line1.frame.size.height + 5,
     //                                      imgView_thumb.frame.origin.y + imgView_thumb.frame.size.height - 10 - 25,
     60, 25);
     button_sendReq.titleLabel.textAlignment = NSTextAlignmentCenter;
     button_sendReq.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
     
     [button_sendReq setBackgroundImage:[UIImage imageNamed:@"knowledge/btn_common_d.png"] forState:UIControlStateNormal];
     [button_sendReq setBackgroundImage:[UIImage imageNamed:@"knowledge/btn_common_p.png"] forState:UIControlStateHighlighted];
     
     button_sendReq.titleLabel.font = [UIFont boldSystemFontOfSize:9.0f];
     [button_sendReq setTitle:@"发送" forState:UIControlStateNormal];
     [button_sendReq setTitle:@"发送" forState:UIControlStateHighlighted];
     
     [button_sendReq addTarget:self action:@selector(addFriendReq_btnclick:) forControlEvents: UIControlEventTouchUpInside];
     
     [_scrollerView addSubview:button_sendReq];
     
     [_textFieldNote becomeFirstResponder];*/
    
    UIImageView *imgView_line1 =[[UIImageView alloc]initWithFrame:CGRectMake(imgView.frame.origin.x,
                                                                             imgView.frame.origin.y + imgView.frame.size.height + 12,
                                                                             [[UIScreen mainScreen] bounds].size.width-(imgView.frame.origin.x * 2),
                                                                             1)];
    [imgView_line1 setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
    
    
    
    //    [_scrollerView addSubview:imgView_line1];
    
    
    //--------------------------------------------------------
    // 输入框背景图
    UIImageView *imgView_input = [[UIImageView alloc]initWithFrame:CGRectMake(9,20,[[UIScreen mainScreen] bounds].size.width-18,132)];
    imgView_input.image=[UIImage imageNamed:@"bg_apply.png"];
    [_scrollerView addSubview:imgView_input];
    
    button_sendReq = [UIButton buttonWithType:UIButtonTypeCustom];
    button_sendReq.frame = CGRectMake(
                                      15,
                                      imgView_input.frame.origin.y + imgView_input.frame.size.height + 20,
                                      290, 40);
    button_sendReq.titleLabel.textAlignment = NSTextAlignmentCenter;
    button_sendReq.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [button_sendReq setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal];
    [button_sendReq setBackgroundImage:[UIImage imageNamed:@"btn_common__1_p.png"] forState:UIControlStateHighlighted];
    
    //button_sendReq.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button_sendReq setTitle:@"发送" forState:UIControlStateNormal];
    [button_sendReq setTitle:@"发送" forState:UIControlStateHighlighted];
    [button_sendReq setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[button_sendReq setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [button_sendReq addTarget:self action:@selector(addFriendReq_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    
    [_scrollerView addSubview:button_sendReq];
    
    
    
    //初始化
    text_content = [[UITextView alloc] initWithFrame:CGRectMake(imgView_input.frame.origin.x + 3,
                                                                imgView_input.frame.origin.y + 3,
                                                                imgView_input.frame.size.width - 6,
                                                                imgView_input.frame.size.height - 5)];
    text_content.backgroundColor = [UIColor clearColor];
    
    text_content.text = @"";
    
    //是否可以滚动
    text_content.scrollEnabled = NO;
    
    text_content.textColor = [UIColor blackColor];
    
    //设置代理 需在interface中声明UITextViewDelegate
    text_content.delegate = self;
    
    //字体大小
    text_content.font = [UIFont fontWithName:@"Arial" size:15.0f];
    
    //获得焦点
    [text_content becomeFirstResponder];
    text_content.returnKeyType = UIReturnKeyDone;//返回键的类型
    
    [_scrollerView addSubview:text_content];
    
    
    if(iPhone4){
        
        _scrollerView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height+20);
    }
    
    //--------------------------------------------------------------------
    
    
}

-(void)addFriendReq_btnclick:(NSNotification *)notification
{
    [ReportObject event:ID_ADD_FRIEND];//2015.06.24
    [Utilities showProcessingHud:self.view];//2015.05.12
    // 发送添加好友请求
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Friend", @"ac",
                          @"add", @"op",
                          _uid, @"fuid",
                          @"0", @"gid",
                          text_content.text, @"note",// update by kate 2014.12.01
                          nil];
    
    [network sendHttpReq:HttpReq_FriendAdd andData:data];
    
    [_textFieldNote resignFirstResponder];
}

//---update by kate 2014.12.01-------------------------------------------------------------
/*- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
 //这里默认是最多输入20位
 
 if (range.location >= 17)
 return NO; // return NO to not change text
 return YES;
 }*/

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [text_content resignFirstResponder];
        return NO;
    }
    if (range.location >= 20)
        return NO; // return NO to not change text
    return YES;
}
//---------------------------------------------------------------------------------------------
@end
