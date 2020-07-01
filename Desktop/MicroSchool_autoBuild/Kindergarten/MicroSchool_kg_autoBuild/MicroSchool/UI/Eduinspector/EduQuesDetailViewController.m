//
//  EduQuesDetailViewController.m
//  MicroSchool
//
//  Created by jojo on 14-9-1.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "EduQuesDetailViewController.h"

@interface EduQuesDetailViewController ()

@end

@implementation EduQuesDetailViewController

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
    // Do any additional setup after loading the view.
    [super setCustomizeTitle:@"督学问答"];
    [super setCustomizeLeftButton];
    
    _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH , [UIScreen mainScreen].applicationFrame.size.height - 44)];
    
    _scrollerView.contentSize = CGSizeMake(WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44);
    
    _scrollerView.scrollEnabled = YES;
    _scrollerView.delegate = self;
    _scrollerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollerView];

    // 问
    UILabel *que = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                    10,
                                                                    20,
                                                                    30,
                                                                    18)];
    //设置title自适应对齐
    que.font = [UIFont systemFontOfSize:15.0f];
    que.text = @"问：";
    que.textAlignment = NSTextAlignmentLeft;
    que.backgroundColor = [UIColor clearColor];
    que.textColor = [UIColor redColor];
    [_scrollerView addSubview:que];

    // 问内容
    UILabel *queCont = [[UILabel alloc] init];
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] < 8.0) {
    
        queCont.frame = CGRectMake(que.frame.origin.x + que.frame.size.width, 0, 260.0, 18.0);
        
    }else{
       queCont.frame = CGRectMake(que.frame.origin.x + que.frame.size.width, que.frame.origin.y, 260.0, 18.0);
    }
    
    //设置title自适应对齐
    queCont.lineBreakMode = NSLineBreakByWordWrapping;
    queCont.numberOfLines = 0;
    queCont.font = [UIFont systemFontOfSize:15.0f];
    queCont.text = [_quesDic objectForKey:@"message"];
    
    CGSize strSize = [Utilities getStringHeight:queCont.text andFont:[UIFont systemFontOfSize:15] andSize:CGSizeMake(260, 0)];
    
    queCont.frame = CGRectMake(que.frame.origin.x + que.frame.size.width,
                               que.frame.origin.y,
                               260,
                               strSize.height);
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] < 8.0) {
        
        queCont.frame = CGRectMake(que.frame.origin.x + que.frame.size.width,
                                   10,
                                   260,
                                   strSize.height);
        
    }else{
        queCont.frame = CGRectMake(que.frame.origin.x + que.frame.size.width,
                                   que.frame.origin.y,
                                   260,
                                   strSize.height);
    }

    queCont.textAlignment = NSTextAlignmentLeft;
    queCont.backgroundColor = [UIColor clearColor];
    queCont.textColor = [UIColor blackColor];
    [_scrollerView addSubview:queCont];

    // 问时间
    UILabel *queTime = [[UILabel alloc] initWithFrame:CGRectMake(
                                                             230,
                                                             queCont.frame.origin.y + queCont.frame.size.height + 10,
                                                             80,
                                                             15)];
    //设置title自适应对齐
    queTime.lineBreakMode = NSLineBreakByWordWrapping;
    queTime.font = [UIFont systemFontOfSize:13.0f];
    queTime.text = [[Utilities alloc] linuxDateToString:[_quesDic objectForKey:@"updatetime"] andFormat:@"%@-%@-%@" andType:DateFormat_YMDHM];
    queTime.textAlignment = NSTextAlignmentLeft;
    queTime.backgroundColor = [UIColor clearColor];
    queTime.textColor = [UIColor grayColor];
    [_scrollerView addSubview:queTime];
    
    UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lineSystem.png"]];
    line.frame = CGRectMake(que.frame.origin.x, queTime.frame.origin.y + queTime.frame.size.height+15.0, [UIScreen mainScreen].bounds.size.width - 20.0, 1.0);
    [_scrollerView addSubview:line];

    // 答
    UILabel *ans = [[UILabel alloc] initWithFrame:CGRectMake(
                                                             que.frame.origin.x,
                                                             queTime.frame.origin.y + queTime.frame.size.height + 30,
                                                             30,
                                                             18)];
    //设置title自适应对齐
    ans.font = [UIFont systemFontOfSize:15.0f];
    ans.text = @"答：";
    ans.textAlignment = NSTextAlignmentLeft;
    ans.backgroundColor = [UIColor clearColor];
    ans.textColor = [UIColor colorWithRed:75.0/255.0 green:170.0/255.0 blue:252.0/255.0 alpha:1];
    [_scrollerView addSubview:ans];

    // 答内容
    UILabel *ansCont = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                 ans.frame.origin.x + ans.frame.size.width,
                                                                 ans.frame.origin.y,
                                                                 260,
                                                                 18)];
    //设置title自适应对齐
    ansCont.lineBreakMode = NSLineBreakByWordWrapping;
    ansCont.numberOfLines = 0;
    ansCont.font = [UIFont systemFontOfSize:15.0f];
    ansCont.text = [_quesDic objectForKey:@"answer"];
    
    strSize = [Utilities getStringHeight:[_quesDic objectForKey:@"answer"] andFont:[UIFont systemFontOfSize:15] andSize:CGSizeMake(260, 0)];
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] < 8.0) {
        ansCont.frame = CGRectMake(ans.frame.origin.x + ans.frame.size.width,
                                   ans.frame.origin.y-10.0,
                                   260,
                                   strSize.height);
    }else{
        ansCont.frame = CGRectMake(ans.frame.origin.x + ans.frame.size.width,
                                   ans.frame.origin.y,
                                   260,
                                   strSize.height);
    }

    ansCont.textAlignment = NSTextAlignmentLeft;
    ansCont.backgroundColor = [UIColor clearColor];
    ansCont.textColor = [UIColor blackColor];
    [_scrollerView addSubview:ansCont];
    
    // 答时间
    UILabel *ansTime = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                 230,
                                                                 ansCont.frame.origin.y + ansCont.frame.size.height + 10,
                                                                 80,
                                                                 15)];
    //设置title自适应对齐
    ansTime.lineBreakMode = NSLineBreakByWordWrapping;
    ansTime.font = [UIFont systemFontOfSize:13.0f];
    ansTime.text = [[Utilities alloc] linuxDateToString:[_quesDic objectForKey:@"answertime"] andFormat:@"%@-%@-%@" andType:DateFormat_YMDHM];
    ansTime.textAlignment = NSTextAlignmentLeft;
    ansTime.backgroundColor = [UIColor clearColor];
    ansTime.textColor = [UIColor grayColor];
    [_scrollerView addSubview:ansTime];
    
    _scrollerView.contentSize = CGSizeMake(WIDTH,
                                           ansTime.frame.origin.y + ansTime.frame.size.height + 10);
    
    [ReportObject event:ID_OPEN_EDU_DETAIL];//2015.06.24
    
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

@end
