//
//  KnowledgePayItemViewController.m
//  MicroSchool
//
//  Created by jojo on 15/2/12.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "KnowledgePayItemViewController.h"

@interface KnowledgePayItemViewController ()

@end

@implementation KnowledgePayItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super setCustomizeTitle:@"订购知识点"];
    [super setCustomizeLeftButton];

    network = [NetworkUtility alloc];
    network.delegate = self;
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    
    NSDictionary *data;
    data = [[NSDictionary alloc] initWithObjectsAndKeys:
            REQ_URL, @"url",
            @"WikiShop",@"ac",
            @"2",@"v",
            @"item", @"op",
            _tid,@"tid",
            nil];
    
    [network sendHttpReq:HttpReq_KnowledgeWikiShopItem andData:data];
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

- (void)selectLeftAction:(id)sender
{
    // 取消所有的网络请求
    [network cancelCurrentRequest];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
}

- (void)initContent
{
    // 背景scrollview
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width , [UIScreen mainScreen].applicationFrame.size.height - 44)];
    _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height - 44);
    _scrollView.scrollEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.bounces = YES;
    _scrollView.alwaysBounceHorizontal = NO;
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.directionalLockEnabled = YES;
    [self.view addSubview:_scrollView];
    
    // 标题
    CGSize msgSize;
    if (![@""  isEqual: _model.itemTitle]) {
        msgSize = [Utilities getStringHeight:_model.itemTitle andFont:[UIFont systemFontOfSize:19]  andSize:CGSizeMake([UIScreen mainScreen].applicationFrame.size.width, 0)];
    }

    _label_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, [UIScreen mainScreen].applicationFrame.size.width, msgSize.height)];
    _label_title.text = _model.itemTitle;
    _label_title.lineBreakMode = NSLineBreakByWordWrapping;
    _label_title.numberOfLines = 0;
    _label_title.font = [UIFont systemFontOfSize:19.0f];
    _label_title.textAlignment = NSTextAlignmentCenter;
    _label_title.backgroundColor = [UIColor clearColor];
    _label_title.textColor = [UIColor blackColor];
    [_scrollView addSubview:_label_title];
    
    // 内容
    if (![@""  isEqual: _model.itemDescription]) {
        msgSize = [Utilities getStringHeight:_model.itemDescription andFont:[UIFont systemFontOfSize:15]  andSize:CGSizeMake([UIScreen mainScreen].applicationFrame.size.width, 0)];
    }
    
    _label_description = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                   _label_title.frame.origin.y + _label_title.frame.size.height + 15,
                                                                   [UIScreen mainScreen].applicationFrame.size.width,
                                                                   msgSize.height)];
    _label_description.text = _model.itemDescription;
    _label_description.lineBreakMode = NSLineBreakByWordWrapping;
    _label_description.numberOfLines = 0;
    _label_description.font = [UIFont systemFontOfSize:15.0f];
    _label_description.textAlignment = NSTextAlignmentCenter;
    _label_description.backgroundColor = [UIColor clearColor];
    _label_description.textColor = [UIColor blackColor];
    [_scrollView addSubview:_label_description];

    // 订阅种类
    for (int i=0; i<[_model.items count]; i++) {
        // 蓝色边框img
        TSTouchImageView *imgView =[[TSTouchImageView alloc]initWithFrame:CGRectMake(
                                                                       ([UIScreen mainScreen].applicationFrame.size.width - 235)/2,
                                                                       _label_description.frame.origin.y + _label_description.frame.size.height + 20 + i*(122),
                                                                       235,
                                                                       102)];
        
        // 设置为可点击，并且把位置传过去
        TSTapGestureRecognizer *myTapGesture = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(img_btnclick:)];
        myTapGesture.infoStr = [NSString stringWithFormat:@"%d", i];
        
        [imgView addGestureRecognizer:myTapGesture];
        imgView.isShowBgImg = NO;
        imgView.userInteractionEnabled = YES;
        imgView.contentMode = UIViewContentModeScaleToFill;
        imgView.tag = i;
        [imgView setImage:[UIImage imageNamed:@"icon_knowledge_blue.png"]];
        [_scrollView addSubview:imgView];
        
        // 订阅内容
        UILabel *label_content = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                           imgView.frame.origin.x + 15,
                                                                       imgView.frame.origin.y + 20,
                                                                       imgView.frame.size.width - 30,
                                                                       20)];
        label_content.text = [[_model.items objectAtIndex:i] objectForKey:@"title"];
        label_content.lineBreakMode = NSLineBreakByTruncatingTail;
        label_content.font = [UIFont systemFontOfSize:17.0f];
        label_content.textAlignment = NSTextAlignmentCenter;
        label_content.backgroundColor = [UIColor clearColor];
        label_content.textColor = [UIColor colorWithRed:26/255.0 green:127/255.0 blue:207/255.0 alpha:1];
        [_scrollView addSubview:label_content];

        // 红色价格img
        UIImageView *imgView_price =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                           imgView.frame.origin.x + 35,
                                                                           label_content.frame.origin.y + label_content.frame.size.height + 10,
                                                                           62,
                                                                           40)];
        imgView_price.contentMode = UIViewContentModeScaleToFill;
        [imgView_price setImage:[UIImage imageNamed:@"icon_knowledge_red.png"]];
        [_scrollView addSubview:imgView_price];

        // 全价，半价
        UILabel *label_discount = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                           imgView_price.frame.origin.x + 12,
                                                                           imgView_price.frame.origin.y + 10,
                                                                           imgView_price.frame.size.width - 25,
                                                                           20)];
        label_discount.text = [[_model.items objectAtIndex:i] objectForKey:@"discount"];
        label_discount.lineBreakMode = NSLineBreakByTruncatingTail;
        label_discount.font = [UIFont boldSystemFontOfSize:15.0f];
        label_discount.textAlignment = NSTextAlignmentCenter;
        label_discount.backgroundColor = [UIColor clearColor];
        label_discount.textColor = [UIColor colorWithRed:251/255.0 green:110/255.0 blue:82/255.0 alpha:1];
        [_scrollView addSubview:label_discount];

        // 价格
        UILabel *label_price = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                            imgView_price.frame.origin.x + imgView_price.frame.size.width + 10,
                                                                            label_discount.frame.origin.y-1,
                                                                            150,
                                                                            20)];
        label_price.text = [[_model.items objectAtIndex:i] objectForKey:@"price"];
        label_price.lineBreakMode = NSLineBreakByTruncatingTail;
        label_price.font = [UIFont systemFontOfSize:18.0f];
        label_price.textAlignment = NSTextAlignmentLeft;
        label_price.backgroundColor = [UIColor clearColor];
        label_price.textColor = [UIColor colorWithRed:251/255.0 green:110/255.0 blue:82/255.0 alpha:1];
        [_scrollView addSubview:label_price];

        _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].applicationFrame.size.width, imgView.frame.origin.y + imgView.frame.size.height + 30);
    }
}

- (IBAction)img_btnclick:(id)sender
{
    TSTapGestureRecognizer *tsTap = (TSTapGestureRecognizer *)sender;

    NSString *iid = [[_model.items objectAtIndex:[tsTap.infoStr integerValue]] objectForKey:@"iid"];
    NSLog(@"iid is %@.",iid);
    
    KnowledgeOrderItemViewController *knowledgeOrderItem = [[KnowledgeOrderItemViewController alloc] init];
    knowledgeOrderItem.tid = _tid;
    knowledgeOrderItem.iid = iid;
    [self.navigationController pushViewController:knowledgeOrderItem animated:YES];
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data
                                                               options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if ([@"WikiShopAction.item"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
       
        [Utilities dismissProcessingHud:self.view];// 2015.05.12
        
        if(true == [result intValue])
        {
            //将JSON数据和Model的属性进行绑定
            _model = [MTLJSONAdapter modelOfClass:[KnowledgePayItemModel class]
                               fromJSONDictionary:resultJSON
                                            error:&error];
            
            [self initContent];
            
        }else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"获取订购知识点错误，请稍后再试"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)reciveHttpDataError:(NSError*)err
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
