//
//  ScheduleDetailViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-1-14.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "ScheduleDetailViewController.h"
#import "SingleWebViewController.h"

@interface ScheduleDetailViewController ()

@end

@implementation ScheduleDetailViewController

@synthesize classid;

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
    [super setCustomizeTitle:_titleName];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super hideLeftAndRightLine];
    [super setCustomizeLeftButton];
}

-(void)selectRightAction:(id)sender
{
    if (nil != _hintUrl) {
        
#if 0
        FileViewerViewController *fileViewer = [[FileViewerViewController alloc] init];
        fileViewer.requestURL = [NSURL URLWithString:_hintUrl];
        fileViewer.titlea = @"内容";
#endif
        // 2015.09.23
        SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
        fileViewer.webType = SWFile;
        fileViewer.url = [NSURL URLWithString:_hintUrl];
        fileViewer.titleName = @"内容";
        
        [self.navigationController pushViewController:fileViewer animated:YES];
    }else {
        [Utilities showFailedHud:@"获取帮助页面错误，请联系管理员。" descView:self.view];
    }
}

-(void)selectLeftAction:(id)sender
{
    // 取消所有的网络请求
    [network cancelCurrentRequest];

//    // 跳转到上上级页面，setPersonalInfoViewController
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0]
//                                          animated:YES];
     [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[ UIScreen mainScreen] .applicationFrame] ;
    self.view = view;
    
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
        [self.view addSubview:noNetworkV];
        return;
        
    }
    
    [self performSelector:@selector(doGetSchedule) withObject:nil afterDelay:0.3];
    
    
    label_className = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                15,
                                                                10,
                                                                300,
                                                                30)];
    label_className.lineBreakMode = NSLineBreakByWordWrapping;
    label_className.font = [UIFont systemFontOfSize:17.0f];
    label_className.numberOfLines = 0;
    label_className.textColor = [UIColor blackColor];
    label_className.backgroundColor = [UIColor clearColor];
    label_className.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.view addSubview:label_className];

    _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44- 50)];
    
    if (iPhone5)
    {
        _scrollerView.contentSize = CGSizeMake(520, [UIScreen mainScreen].applicationFrame.size.height - 44- 50);
    }
    else
    {
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        {
            _scrollerView.contentSize = CGSizeMake(520, [UIScreen mainScreen].applicationFrame.size.height - 44 + 60);
        }
        else
        {
            _scrollerView.contentSize = CGSizeMake(520, [UIScreen mainScreen].applicationFrame.size.height - 44- 50);
        }
    }
    
    _scrollerView.scrollEnabled = YES;
    _scrollerView.delegate = self;
    _scrollerView.bounces = YES;
    _scrollerView.alwaysBounceHorizontal = NO;
    _scrollerView.alwaysBounceVertical = YES;
    _scrollerView.directionalLockEnabled = YES;
    [self.view addSubview:_scrollerView];
    
    // 画静态图片与静态label
#define CELL_WIDTH 60
#define CELL_HEIGHT 40
    for (int j=0; j<11; j++) {
        for (int i=0; i<8; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10+i*CELL_WIDTH,
                                                                                  10+j*CELL_HEIGHT,CELL_WIDTH,CELL_HEIGHT)];
            if ((j+1)%2) {
                [imageView setImage:[UIImage imageNamed:@"grey.png"]];
            } else {
                [imageView setImage:[UIImage imageNamed:@"white.png"]];
            }
            imageView.contentMode = UIViewContentModeScaleToFill;
            [_scrollerView addSubview:imageView];
            
            if (0 == j) {
                UILabel *label_weekly = [[UILabel alloc] initWithFrame:CGRectMake(10,10,60,20)];
                if (0 != i) {
                    NSString *weeklyStr;
                    if (1 == i) {
                        weeklyStr = @"周一";
                    } else if (2 == i) {
                        weeklyStr = @"周二";
                    } else if (3 == i) {
                        weeklyStr = @"周三";
                    } else if (4 == i) {
                        weeklyStr = @"周四";
                    } else if (5 == i) {
                        weeklyStr = @"周五";
                    } else if (6 == i) {
                        weeklyStr = @"周六";
                    } else if (7 == i) {
                        weeklyStr = @"周日";
                    }
                    
                    label_weekly.text = weeklyStr;
                }
                label_weekly.font = [UIFont systemFontOfSize:12.0f];
                label_weekly.textColor = [UIColor blackColor];
                label_weekly.backgroundColor = [UIColor clearColor];
                label_weekly.textAlignment = NSTextAlignmentCenter;
                
                [imageView addSubview:label_weekly];
            }
            
            if (0 == i) {
                UILabel *label_class = [[UILabel alloc] initWithFrame:CGRectMake(10,10,60,20)];
                if (0 != j) {
                    NSString *classStr;
                    if (1 == j) {
                        classStr = @"第1课";
                    } else if (2 == j) {
                        classStr = @"第2课";
                    } else if (3 == j) {
                        classStr = @"第3课";
                    } else if (4 == j) {
                        classStr = @"第4课";
                    } else if (5 == j) {
                        classStr = @"第5课";
                    } else if (6 == j) {
                        classStr = @"第6课";
                    } else if (7 == j) {
                        classStr = @"第7课";
                    } else if (8 == j) {
                        classStr = @"第8课";
                    } else if (9 == j) {
                        classStr = @"第9课";
                    } else if (10 == j) {
                        classStr = @"第10课";
                    }
                    label_class.text = classStr;
                }
                label_class.font = [UIFont systemFontOfSize:12.0f];
                label_class.textColor = [UIColor blackColor];
                label_class.backgroundColor = [UIColor clearColor];
                label_class.textAlignment = NSTextAlignmentCenter;
                
                [imageView addSubview:label_class];
            }
        }
    }
}

-(void)doGetSchedule
{
     [Utilities showProcessingHud:self.view];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Class", @"ac",
                          @"2", @"v",
                          @"classtable", @"op",
                          self->classid, @"classid",
                          @"1", @"term",
                          @"2013", @"year",
                          nil];
    
    [network sendHttpReq:HttpReq_Schedule andData:data];
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    [Utilities dismissProcessingHud:self.view];

    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    
    if(true == [result intValue])
    {
        [ReportObject event:ID_OPEN_CLASS_TABLE];//2015.06.24
        
        NSDictionary* message_info = [resultJSON objectForKey:@"message"];
        className = [message_info objectForKey:@"classname"];
        term = [NSString stringWithFormat:@"%@",[message_info objectForKey:@"term"]];

        // 判断是否需要显示帮助按钮
        NSString *hint = [message_info objectForKey:@"hint"];
        _hintUrl = [message_info objectForKey:@"hintUrl"];

        if (1 == hint.integerValue) {
            [self setCustomizeRightButton:@"icon_question_mark.png"];
        }
        
        NSDictionary* kcbvalue = [message_info objectForKey:@"kcbvalue"];
        
        if (0 != [kcbvalue count]) {
            //先得到里面所有的键值   objectEnumerator得到里面的对象  keyEnumerator得到里面的键值
            NSEnumerator * enumerator = [kcbvalue keyEnumerator];//把keyEnumerator替换为objectEnumerator即可得到value值（1）
            
            //定义一个不确定类型的对象
            NSString *object;
            //遍历输出
            while(object = [enumerator nextObject])
            {
                //NSLog(@"键值为：%@",object);
                
                //在这里我们得到的是键值，可以通过（1）得到，也可以通过这里得到的键值来得到它对应的value值
                //通过NSDictionary对象的objectForKey方法来得到
                //其实这里定义objectValue这个对象可以直接用NSObject，因为我们已经知道它的类型了，id在不知道类型的情况下使用
                id objectValue = [kcbvalue objectForKey:object];
                if(objectValue != nil)
                {
                    NSEnumerator * enumerator1 = [objectValue keyEnumerator];
                    
                    NSString *object1;
                    while(object1 = [enumerator1 nextObject])
                    {
                        //NSLog(@"键值1为：%@",object1);
                        
                        id objectValue1 = [objectValue objectForKey:object1];
                        
                        if(objectValue1 != nil)
                        {
                            NSString *subjectname = [objectValue1 objectForKey:@"subjectname"];
                            //NSLog(@"周%@ 第%@节是 %@",object,object1,subjectname);
                            
                            UILabel *label_subjectname = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                                                   object.intValue*CELL_WIDTH + 20,
                                                                                                   object1.intValue*CELL_HEIGHT + 20,
                                                                                                   60,20)];
                            label_subjectname.text = subjectname;
                            label_subjectname.font = [UIFont systemFontOfSize:12.0f];
                            label_subjectname.textColor = [UIColor blackColor];
                            label_subjectname.backgroundColor = [UIColor clearColor];
                            label_subjectname.textAlignment = NSTextAlignmentCenter;
                            
                            [_scrollerView addSubview:label_subjectname];
                            
//                            className = [objectValue1 objectForKey:@"classname"];
                            term = [NSString stringWithFormat:@"%@",[objectValue1 objectForKey:@"term"]];
                        }
                    }
                }
            }
            
            className = [@"班级：" stringByAppendingString:className];
            if ((nil == className) || (nil == term)) {
                label_className.text = @"班级错误";
            } else {
                if ([@"1"  isEqual: term]) {
                    className = [className stringByAppendingString:@" 上学期"];
                } else {
                    className = [className stringByAppendingString:@" 下学期"];
                }
                label_className.text = className;
            }
        }
        else
        {
            className = [@"班级：" stringByAppendingString:className];
            if ((nil == className) || (nil == term)) {
                label_className.text = @"班级错误";
            } else {
                if ([@"1"  isEqual: term]) {
                    className = [className stringByAppendingString:@" 上学期"];
                } else {
                    className = [className stringByAppendingString:@" 下学期"];
                }
                label_className.text = className;
            }
        }
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"获取课程表失败，请重试"
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
    
}

-(void)reciveHttpDataError:(NSError*)err
{
    [Utilities dismissProcessingHud:self.view];
    
//    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
//                                                   message:@"网络连接错误，请稍候再试"
//                                                  delegate:self
//                                         cancelButtonTitle:@"确定"
//                                         otherButtonTitles:nil];
//    [alert show];
   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0]
                                          animated:YES];
}

@end
