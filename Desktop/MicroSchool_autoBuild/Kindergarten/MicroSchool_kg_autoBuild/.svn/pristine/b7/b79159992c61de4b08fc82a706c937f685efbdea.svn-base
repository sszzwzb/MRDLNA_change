//
//  EduinspectorDetailViewController.m
//  MicroSchool
//
//  Created by jojo on 14-9-1.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "EduinspectorDetailViewController.h"

@interface EduinspectorDetailViewController ()

@end

@implementation EduinspectorDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        
        network = [NetworkUtility alloc];
        network.delegate = self;
        
        infoDic =[[NSMutableDictionary alloc] init];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super setCustomizeTitle:@"责任督学"];
    [super setCustomizeLeftButton];
    
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    
    _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH , [UIScreen mainScreen].applicationFrame.size.height - 44)];
    
    _scrollerView.contentSize = CGSizeMake(WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44);
    
    _scrollerView.scrollEnabled = YES;
    _scrollerView.delegate = self;
    [self.view addSubview:_scrollerView];

    _scrollerView.backgroundColor = [[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0];
    
    // 获取督学button模块
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Eduinspector", @"ac",
                          @"profile", @"op",
                          _insUid, @"uid",
                          nil];
    
    [network sendHttpReq:HttpReq_EduinspectorProfile andData:data];
    
    [ReportObject event:ID_OPEN_EDU_PERSON];// 2015.06.24
}

-(void)selectLeftAction:(id)sender
{
    // 取消所有的网络请求
    [network cancelCurrentRequest];
    
    // 退回到上个画面
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
}

-(void)doShowInfo
{
    // 缩略图
    UIImageView *imgView_thumb =[[UIImageView alloc]initWithFrame:CGRectMake((WIDTH-120)/2,20,120,120)];
    imgView_thumb.contentMode = UIViewContentModeScaleToFill;
    [imgView_thumb sd_setImageWithURL:[NSURL URLWithString:[infoDic objectForKey:@"photo"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    [_scrollerView addSubview:imgView_thumb];

    // 督学头像下面的线
    UIImageView *imgView_line =[[UIImageView alloc]initWithFrame:CGRectMake(25,
                                                                            imgView_thumb.frame.origin.y + imgView_thumb.frame.size.height + 20,
                                                                            270,1)];
    [imgView_line setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
    [imgView_line setTag:999];
    [_scrollerView addSubview:imgView_line];

    // 姓名
    CGRect rc_name = CGRectMake(
                         imgView_line.frame.origin.x,
                         imgView_line.frame.origin.y + imgView_line.frame.size.height + 10,
                         200,
                         20);
    [self showLabelRect:rc_name andContent:[NSString stringWithFormat:@"姓名：%@", [infoDic objectForKey:@"name"]]];

    // 职务
    CGRect rc_zhiwu = CGRectMake(
                           rc_name.origin.x,
                           rc_name.origin.y + rc_name.size.height + 10 -5,
                           200,
                           20);
    [self showLabelRect:rc_zhiwu andContent:[NSString stringWithFormat:@"职务：%@", [infoDic objectForKey:@"job"]]];

    // 单位
    CGRect rc_danwei = CGRectMake(
                                 rc_zhiwu.origin.x,
                                 rc_zhiwu.origin.y + rc_zhiwu.size.height + 10 -5,
                                 250,
                                 20);
    [self showLabelRect:rc_danwei andContent:[NSString stringWithFormat:@"单位：%@", [infoDic objectForKey:@"company"]]];

    // 电话
    CGRect rc_phone = CGRectMake(
                                  rc_danwei.origin.x,
                                  rc_danwei.origin.y + rc_danwei.size.height + 10 -5,
                                  200,
                                  20);
    [self showLabelRect:rc_phone andContent:[NSString stringWithFormat:@"电话：%@", [infoDic objectForKey:@"tel"]]];

    // 邮箱
    CGRect rc_mail = CGRectMake(
                                 rc_phone.origin.x,
                                 rc_phone.origin.y + rc_phone.size.height + 10 -5,
                                 250,
                                 20);
    [self showLabelRect:rc_mail andContent:[NSString stringWithFormat:@"邮箱：%@", [infoDic objectForKey:@"email"]]];

    // 基本信息下面的线
    UIImageView *imgView_line1 =[[UIImageView alloc]initWithFrame:CGRectMake(25,
                                                                            rc_mail.origin.y + rc_mail.size.height + 10,
                                                                            270,1)];
    [imgView_line1 setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
    [imgView_line1 setTag:999];
    [_scrollerView addSubview:imgView_line1];

    // 基本职责
    CGRect rc_zz = CGRectMake(
                                imgView_line1.frame.origin.x,
                                imgView_line1.frame.origin.y + imgView_line1.frame.size.height + 10,
                                200,
                                15);
    [self showLabelRect:rc_zz andContent:@"基本职责"];

    // 基本职责内容
    CGSize strSize = [Utilities getStringHeight:[infoDic objectForKey:@"duty"] andFont:[UIFont systemFontOfSize:15] andSize:CGSizeMake(270, 0)];

    CGRect rc_duty = CGRectMake(
                                rc_zz.origin.x,
                                rc_zz.origin.y + rc_zz.size.height + 10,
                                270,
                                strSize.height);

    [self showLabelRect:rc_duty andContent:[NSString stringWithFormat:@"%@", [infoDic objectForKey:@"duty"]]];

    _scrollerView.contentSize = CGSizeMake(WIDTH,
                                           rc_duty.origin.y + rc_duty.size.height + 10);
}

-(void)showLabelRect:(CGRect )rect andContent:(NSString *)content
{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    //设置title自适应对齐
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:15.0f];
    label.text = content;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    [_scrollerView addSubview:label];
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    
    [Utilities dismissProcessingHud:self.view];// 2015.05.12
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    //NSString* message_info = [resultJSON objectForKey:@"message"];
    NSString *msg = [resultJSON objectForKey:@"message"];
    
    if(true == [result intValue])
    {
        infoDic = [resultJSON objectForKey:@"message"];
        
        [self doShowInfo];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
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

@end
