//
//  PayViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/10/8.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "PayViewController.h"
#import "SingleWebViewController.h"
#import "GrowthNotValidateViewController.h"
#import "Utilities.h"

@interface PayViewController ()
@property (strong, nonatomic) IBOutlet UIButton *payBtn;
- (IBAction)payAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *noItemLabel;
@property (strong, nonatomic) IBOutlet UILabel *historyDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *openDataLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *isOpenLabel;
@property (strong, nonatomic) IBOutlet UILabel *linePayTitleLabel;
- (IBAction)clickIntroduce:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *baseView;
@property (strong, nonatomic) IBOutlet UILabel *payWayLabel;
@property (strong, nonatomic) IBOutlet UIImageView *isNormalImgV;
- (IBAction)gotoServiceRule:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *checkImgV;
- (IBAction)checkAction:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *discountLabel;
@property (strong, nonatomic) IBOutlet UIView *discountV;
@property (strong, nonatomic) IBOutlet UIView *serviceV;
@property (strong, nonatomic) IBOutlet UIView *timeBaseV;
@property (strong, nonatomic) IBOutlet UIView *titleV;
@property (strong, nonatomic) IBOutlet UIView *linkV;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollV;

@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@"开通状态"];
    
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
        [self.view addSubview:noNetworkV];
        return;
    }
    
    _isBackFromSafari = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    payUrlStr = [[NSString alloc] init];
    urlStr = [[NSString alloc] init];
    itemsArray = [[NSMutableArray alloc] init];
    
    _baseView.layer.masksToBounds = YES;
    _baseView.layer.cornerRadius = 3.0;
    
    [_payBtn setBackgroundImage:[UIImage imageNamed:@"btn_pay_normal.png"] forState:UIControlStateNormal];
    [_payBtn setBackgroundImage:[UIImage imageNamed:@"btn_pay_press.png"] forState:UIControlStateHighlighted];
    
    [_checkImgV setImage:[UIImage imageNamed:@"checkImg_press.png"]];
    
    selected = 0;
    
    self.view.hidden = YES;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _timeBaseV.layer.cornerRadius = 2.0;
    _timeBaseV.layer.masksToBounds = YES;
    
    [Utilities showProcessingHud:self.view];
    [self getData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    if ([_fromName isEqualToString:@"publishB"]){//跳回发布页或者跳回动态列表
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-1-2] animated:YES];
        
    }else if ([_fromName isEqualToString:@"class"]){
     
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        
    }else{
         [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#if 0
/**
 * 支付历史数据
 * @author luke
 * @date 2015.10.12
 * @args
 *  v=2, ac=GrowingSpace, op=bills, sid=, cid=, uid=
 */
-(void)getData{
    
//    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          REQ_URL, @"url",
//                          @"GrowingSpace",@"ac",
//                          @"2",@"v",
//                          @"bills", @"op",
//                          _cId,@"cid",
//                          nil];
    
    
    // 新接口 v=2, ac=GrowingSpace, op=status, sid=, cid=, uid=
    /*
     message =     {
     content = "\U6b63\U5e38";
     amount = 10.00;
     dateline =         {
         end = 234234242;
         expired = 123123123;
         start = 123213123;
     };
     status = 1;
         url =         {
         help = "http://www.baidu.com";
         pay = "http://www.baidu.com";
        };
     };
     protocol = "GrowingSpaceAction.status";
     result = 1;
     }
     */
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"GrowingSpace",@"ac",
                              @"2",@"v",
                              @"status", @"op",
                              _cId,@"cid",
                              nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            //_isBackFromSafari = NO;
            self.view.hidden = NO;
            NSLog(@"支付页返回:%@",respDic);
            
            NSDictionary *messageDic = [respDic objectForKey:@"message"];
            
            NSString *content = [messageDic objectForKey:@"content"];
            NSString *amount = [NSString stringWithFormat:@"%@",[messageDic objectForKey:@"amount"]];
            NSString *status = [messageDic objectForKey:@"status"];
            NSDictionary *urlDic = [messageDic objectForKey:@"url"];
            NSDictionary *dicDate = [messageDic objectForKey:@"dateline"];
            NSString *expiredStr = [NSString stringWithFormat:@"%@",[dicDate objectForKey:@"expired"]];
            NSString *begin_dateStr = [NSString stringWithFormat:@"%@",[dicDate objectForKey:@"start"]];
            NSString *end_dateStr = [NSString stringWithFormat:@"%@",[dicDate objectForKey:@"end"]];
            
            NSString *discount = [NSString stringWithFormat:@"%@",[messageDic objectForKey:@"discount"]];
            
            if ([_fromName isEqualToString:@"publish"] || [_fromName isEqualToString:@"publishB"]) {
                
                if (_isBackFromSafari) {
                    
                    if ([status integerValue] == 1 || [status integerValue] == 2) {
                        
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadPublishGrowingStatus" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadGrowingPathStatus" object:nil];
                    
                        //付费成功
                        UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        alerV.tag = 222;
                        [alerV show];
                        
                    }
                }
                
                _isBackFromSafari = NO;
                
            }else{
                if ([_isTrial integerValue] == 0) {
                    
                    if (!payStatus) {
                        payStatus = status;
                    }
                    
                    if (_isBackFromSafari) {
                        
                        if (payStatus) {
                            
                            if ([payStatus integerValue] == 0 && [status integerValue] == 1) {
                                
                                [self gotoGrowthSpace:status];
                            }
                            
                        }
                        
                    }
                    
                    _isBackFromSafari = NO;
                    
                }else{
                    
                    _isBackFromSafari = NO;
                    
                }
            }
            
            // 开通空间0:未开通,1付费已开通,2试用已开通，3试用到期，4付费到期
            if ([status integerValue] == 3 || [status integerValue] == 4 || [status integerValue] == 0) {
                _isNormalImgV.image = [UIImage imageNamed:@"arrearage.png"];
            }else{
                _isNormalImgV.image = [UIImage imageNamed:@"normal.png"];
            }
            
            _isOpenLabel.text = content;
            
            NSString *expiredDate = [[Utilities alloc] linuxDateToString:expiredStr andFormat:@"%@.%@.%@" andType:DateFormat_YMD];
            NSString *startDate = [[Utilities alloc] linuxDateToString:begin_dateStr andFormat:@"%@.%@.%@" andType:DateFormat_YMD];
            NSString *endDate = [[Utilities alloc] linuxDateToString:end_dateStr andFormat:@"%@.%@.%@" andType:DateFormat_YMD];
            
            urlStr = [urlDic objectForKey:@"help"];
            payUrlStr = [urlDic objectForKey:@"pay"];
            serviceUrlStr = [urlDic objectForKey:@"discount"];
            
            if ([status integerValue]!=0) {
                _historyDateLabel.text = [NSString stringWithFormat:@"有效期至%@",expiredDate];
            }
            
            NSString *tempStr = [NSString stringWithFormat:@"现在续费%@元，您将获得成长空间",amount];
            NSMutableAttributedString *returnStr = [[NSMutableAttributedString alloc] initWithString:tempStr];
            [returnStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:230.0/255.0 green:24.0/255.0 blue:24.0/255.0 alpha:1] range:NSMakeRange(4,[amount length])];//颜色
            _moneyLabel.attributedText = returnStr;
            
            NSString *tempDateStr = [NSString stringWithFormat:@"%@至%@的使用权",startDate,endDate];
            NSMutableAttributedString *returnDateStr = [[NSMutableAttributedString alloc] initWithString:tempDateStr];
            [returnDateStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:252.0/255.0 green:176.0/255.0 blue:34.0/255.0 alpha:1] range:NSMakeRange(0,[startDate length])];//颜色
            [returnDateStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:252.0/255.0 green:176.0/255.0 blue:34.0/255.0 alpha:1] range:NSMakeRange(11,[endDate length])];//颜色
            _openDataLabel.attributedText = returnDateStr;
            
            if ([discount length] >0) {
                
                _discountLabel.text = discount;
                
            }else{
                
                _discountV.hidden = YES;
                _serviceV.frame = CGRectMake(_serviceV.frame.origin.x, _openDataLabel.frame.origin.y
                                             +_openDataLabel.frame.size.height + 15.0, _serviceV.frame.size.width, _serviceV.frame.size.height);
                _payBtn.frame = CGRectMake(_payBtn.frame.origin.x, _serviceV.frame.origin.y+_serviceV.frame.size.height + 15.0, _payBtn.frame.size.width, _payBtn.frame.size.height);
                
            }
            
            
            /*
             NSDictionary *spaceDic = [messageDic objectForKey:@"space"];
             NSArray *historyArray = [messageDic objectForKey:@"bills"];
           
            if ([historyArray count] > 0) {
                
                NSDictionary *historyDic = [historyArray objectAtIndex:0];
                NSString *dateStr = [NSString stringWithFormat:@"%@",[historyDic objectForKey:@"create_date"]];
                NSString *methodStr = [NSString stringWithFormat:@"%@",[historyDic objectForKey:@"method"]];
                NSString *amount = [NSString stringWithFormat:@"%@",[historyDic objectForKey:@"amount"]];
                //NSString *interval = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[historyDic objectForKey:@"interval"]]];
                NSString *begin_dateStr = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[historyDic objectForKey:@"begin_date"]]];
                NSString *end_dateStr = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[historyDic objectForKey:@"end_date"]]];
                NSString *begin_date = [[Utilities alloc] linuxDateToString:begin_dateStr andFormat:@"%@.%@.%@" andType:DateFormat_YMD];
               // NSString *end_date = [[Utilities alloc] linuxDateToString:end_dateStr andFormat:@"%@.%@.%@" andType:DateFormat_YMD];
                 NSString *end_date = [[Utilities alloc] linuxDateToString:end_dateStr andFormat:@"%@年%@月%@日" andType:DateFormat_YMD];
                
                NSString *date = [[Utilities alloc] linuxDateToString:dateStr andFormat:@"%@.%@.%@ %@:%@" andType:DateFormat_YMDHM];
                
                _moneyLabel.text = [NSString stringWithFormat:@"￥%@",amount];
                //_openDataLabel.text = [NSString stringWithFormat:@"开通日期：%@-%@",begin_date,end_date];
                _openDataLabel.text = [NSString stringWithFormat:@"有效期至：%@",end_date];//2015.10.19 zamir邮件发出修改文案
                _historyDateLabel.text = date;
                _payWayLabel.text = methodStr;
                
            }else{
                
                _payWayLabel.hidden = YES;
                _moneyLabel.hidden = YES;
                _openDataLabel.hidden = YES;
                _historyDateLabel.hidden = YES;
                _noItemLabel.text = @"暂无付费记录";
            }*/
           
            
        }else{
            [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
            
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        
    }];

}
#endif

/**
 * 空间支付条目
 * @author luke
 * @date 2016.01.07
 * @args
 *  v=2, ac=GrowingSpace, op=items, sid=, uid=, cid=
 */
-(void)getData{
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"GrowingSpace",@"ac",
                          @"2",@"v",
                          @"items", @"op",
                          _cId,@"cid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            //_isBackFromSafari = NO;
            self.view.hidden = NO;
            NSLog(@"支付页返回:%@",respDic);
            
            NSDictionary *messageDic = [respDic objectForKey:@"message"];
            
            NSString *content = [messageDic objectForKey:@"content"];
            NSString *amount = [NSString stringWithFormat:@"%@",[messageDic objectForKey:@"amount"]];
            NSString *status = [messageDic objectForKey:@"status"];
            NSDictionary *urlDic = [messageDic objectForKey:@"url"];
            NSDictionary *dicDate = [messageDic objectForKey:@"dateline"];
            NSString *expiredStr = [NSString stringWithFormat:@"%@",[dicDate objectForKey:@"expired"]];
            NSString *begin_dateStr = [NSString stringWithFormat:@"%@",[dicDate objectForKey:@"start"]];
            NSString *end_dateStr = [NSString stringWithFormat:@"%@",[dicDate objectForKey:@"end"]];
            
            NSString *discount = [NSString stringWithFormat:@"%@",[messageDic objectForKey:@"discount"]];
            
            if ([_fromName isEqualToString:@"publish"] || [_fromName isEqualToString:@"publishB"]) {
                
                if ([_isTrial integerValue] == 0) {
                    
                    if (!payStatus) {
                        payStatus = status;
                    }
                    
                    if (_isBackFromSafari) {
                        
                        if (payStatus) {
                            
                            if ([payStatus integerValue] == 0 && [status integerValue] == 1) {
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadGrowingPathStatus" object:nil];
                                
                                //付费成功
                                UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                alerV.tag = 222;
                                [alerV show];
                                
                            }else if ([payStatus integerValue] == 3 && [status integerValue] == 1){
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadGrowingPathStatus" object:nil];
                                
                                //付费成功
                                UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                alerV.tag = 222;
                                [alerV show];
                                
                            }else if ([payStatus integerValue] == 4  && [status integerValue] == 1){
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadGrowingPathStatus" object:nil];
                                
                                //付费成功
                                UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                alerV.tag = 222;
                                [alerV show];
                                
                            }
                            
                        }
                        
                    }
                    
                    _isBackFromSafari = NO;
                    
                }else{
                   
                    if (_isBackFromSafari) {
                        
                        if ([status integerValue] == 1 || [status integerValue] == 2) {
                            
                            //                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadPublishGrowingStatus" object:nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadGrowingPathStatus" object:nil];
                            
                            //付费成功
                            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            alerV.tag = 222;
                            [alerV show];
                            
                        }
                    }
                    
                    _isBackFromSafari = NO;
                }
                
            }else{
                if ([_isTrial integerValue] == 0) {
                    
                    if (!payStatus) {
                        payStatus = status;
                    }
                    
                    if (_isBackFromSafari) {
                        
                        if (payStatus) {
                            
                            if ([payStatus integerValue] == 0 && [status integerValue] == 1) {
                                
                                [self gotoGrowthSpace:status];
                            }
                            
                        }
                        
                    }
                    
                    _isBackFromSafari = NO;
                    
                }else{
                    
                    _isBackFromSafari = NO;
                    
                }
            }
            
            // 开通空间0:未开通,1付费已开通,2试用已开通，3试用到期，4付费到期
            if ([status integerValue] == 3 || [status integerValue] == 4 || [status integerValue] == 0) {
                _isNormalImgV.image = [UIImage imageNamed:@"arrearage.png"];
            }else{
                _isNormalImgV.image = [UIImage imageNamed:@"normal.png"];
            }
            
            _isOpenLabel.text = content;
            
            NSString *expiredDate = [[Utilities alloc] linuxDateToString:expiredStr andFormat:@"%@.%@.%@" andType:DateFormat_YMD];
            
            /*NSString *startDate = [[Utilities alloc] linuxDateToString:begin_dateStr andFormat:@"%@.%@.%@" andType:DateFormat_YMD];
            NSString *endDate = [[Utilities alloc] linuxDateToString:end_dateStr andFormat:@"%@.%@.%@" andType:DateFormat_YMD];*/
            
            urlStr = [urlDic objectForKey:@"help"];
            //payUrlStr = [urlDic objectForKey:@"pay"];
            serviceUrlStr = [urlDic objectForKey:@"discount"];
            
            if ([status integerValue]!=0) {
                _historyDateLabel.text = [NSString stringWithFormat:@"有效期至%@",expiredDate];
            }
            
            /*NSString *tempStr = [NSString stringWithFormat:@"现在续费%@元，您将获得成长空间",amount];
            NSMutableAttributedString *returnStr = [[NSMutableAttributedString alloc] initWithString:tempStr];
            [returnStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:230.0/255.0 green:24.0/255.0 blue:24.0/255.0 alpha:1] range:NSMakeRange(4,[amount length])];//颜色
            _moneyLabel.attributedText = returnStr;*/
            
            NSDictionary *spaceDic = [messageDic objectForKey:@"space"];
            
            _moneyLabel.text = [spaceDic objectForKey:@"title"];
            
            /*NSString *tempDateStr = [NSString stringWithFormat:@"%@至%@的使用权",startDate,endDate];
            NSMutableAttributedString *returnDateStr = [[NSMutableAttributedString alloc] initWithString:tempDateStr];
            [returnDateStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:252.0/255.0 green:176.0/255.0 blue:34.0/255.0 alpha:1] range:NSMakeRange(0,[startDate length])];//颜色
            [returnDateStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:252.0/255.0 green:176.0/255.0 blue:34.0/255.0 alpha:1] range:NSMakeRange(11,[endDate length])];//颜色
            _openDataLabel.attributedText = returnDateStr;*/
            
            
            
            NSString *timeDiscount = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[spaceDic objectForKey:@"discount"]]];
            _openDataLabel.text = timeDiscount;

            if ([timeDiscount length] == 0) {
                _timeBaseV.hidden = YES;
            }
            
            itemsArray = [messageDic objectForKey:@"items"];
            
            NSArray *subviewsArray = [_discountV subviews];
            for (int i=0; i<[subviewsArray count]; i++) {
                [[subviewsArray objectAtIndex:i] removeFromSuperview];
            }
            
            if ([itemsArray count] >0) {
                // to do : add button to DiscountV
                for (int i=0; i<[itemsArray count]; i++) {
                    
                    NSDictionary *itemDic = [itemsArray objectAtIndex:i];
                    NSString *amount = [itemDic objectForKey:@"amount"];
                    NSString *discount = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[itemDic objectForKey:@"discount"]]];
                    NSString *title = [itemDic objectForKey:@"title"];
                    NSString *month = [NSString stringWithFormat:@"%@",[itemDic objectForKey:@"month"]];
                    
                    NSString *tempDateStr = [NSString stringWithFormat:@"%@%@",month,title];
                    
                    NSMutableAttributedString *titleMonth = [[NSMutableAttributedString alloc] initWithString:tempDateStr];
                    [titleMonth addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:153.0/255.0 blue:51.0/255.0 alpha:1] range:NSMakeRange(0,[month length])];//颜色
                    [titleMonth addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] range:NSMakeRange([month length],[title length])];//颜色
                    
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake(4.0, i*35+i*10.0, 302, 35);
                    btn.tag = i+400;
                    
                    CGSize sizeTitle = [Utilities getStringHeight:tempDateStr andFont:[UIFont systemFontOfSize:15.0] andSize:CGSizeMake(0, 35.0)];
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,sizeTitle.width, 35.0)];
                    label.attributedText = titleMonth;
                    label.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
                    label.font = [UIFont systemFontOfSize:15.0];
                   
                    CGSize sizeTitleDiscount = [Utilities getStringHeight:discount andFont:[UIFont systemFontOfSize:12.0] andSize:CGSizeMake(0, 14.0)];
                    
                    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(label.frame.origin.x+label.frame.size.width+5.0, (35.0-14.0)/2.0, sizeTitleDiscount.width+16.0, 14.0)];
                    imgV.image = [UIImage imageNamed:@"discount_month.png"];
                    
                    UIImageView *fireImgV = [[UIImageView alloc] initWithFrame:CGRectMake(3.0, (14.0-11.0)/2.0, 11.0, 11.0)];
                    fireImgV.image = [UIImage imageNamed:@"discount_fire.png"];
                    
                   
                    UILabel *labelMonth = [[UILabel alloc] initWithFrame:CGRectMake(fireImgV.frame.origin.x+11.0, 0,sizeTitleDiscount.width, 14.0)];
                    labelMonth.font = [UIFont systemFontOfSize:12.0];
                    labelMonth.text = discount;
                    labelMonth.textColor = [UIColor colorWithRed:245.0/255.0 green:84.0/255.0 blue:84.0/255.0 alpha:1];
                    
                    [imgV addSubview:fireImgV];
                    [imgV addSubview:labelMonth];
                    
                    [btn setBackgroundImage:[UIImage imageNamed:@"btn_discount_Normal.png"] forState:UIControlStateNormal];

                    // UIControlStateSelected ｜ UIControlStateHighlighted 和 UIControlStateSelected 是两种不同的状态, 在isSelected状态时再点击按钮就变成了UIControlStateSelected ｜ UIControlStateHighlighted的状态
                    [btn setBackgroundImage:[UIImage imageNamed:@"btn_discount_Press.png"] forState:UIControlStateSelected];
                    [btn setBackgroundImage:[UIImage imageNamed:@"btn_discount_Press.png"] forState:UIControlStateSelected|UIControlStateHighlighted];
                    
                    [btn addSubview:label];
                    
                    if ([discount length] > 0) {
                        
                        [btn addSubview:imgV];
                    }
                   
                    CGSize sizeTitleAmount = [Utilities getStringHeight:[NSString stringWithFormat:@"￥%@",amount] andFont:[UIFont systemFontOfSize:15.0] andSize:CGSizeMake(0, 35.0)];
                    UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width-sizeTitleAmount.width-5.0, 0, sizeTitleAmount.width, 35.0)];
                    amountLabel.text = [NSString stringWithFormat:@"￥%@",amount];
                    amountLabel.font = [UIFont systemFontOfSize:15.0];
                    amountLabel.textColor = [UIColor colorWithRed:245.0/255.0 green:84.0/255.0 blue:84.0/255.0 alpha:1];
                    [btn addSubview:amountLabel];
                    
                    [btn addTarget:self action:@selector(clickDiscountBtn:) forControlEvents:UIControlEventTouchDown];
                    
                    if (i == selected) {
                        btn.selected = YES;
                        payUrlStr = [itemDic objectForKey:@"url"];
                    }
                    
                    [_discountV addSubview:btn];
                }
                
                _discountV.frame = CGRectMake(0, _titleV.frame.origin.y+_titleV.frame.size.height, _discountV.frame.size.width, [itemsArray count]*35+([itemsArray count]-1)*10 +5);
                _serviceV.frame = CGRectMake(_serviceV.frame.origin.x, _discountV.frame.origin.y
                                             +_discountV.frame.size.height + 5.0, _serviceV.frame.size.width, _serviceV.frame.size.height);
                _payBtn.frame = CGRectMake(_payBtn.frame.origin.x, _serviceV.frame.origin.y+_serviceV.frame.size.height, _payBtn.frame.size.width, _payBtn.frame.size.height);
                
                if (iPhone4) {
                    
                    _linkV.frame = CGRectMake(_linkV.frame.origin.x, _payBtn.frame.origin.y+_payBtn.frame.size.height+5, _linkV.frame.size.width, _linkV.frame.size.height);
                    
                    _scrollV.contentSize = CGSizeMake(self.view.frame.size.width, _scrollV.frame.size.height + _linkV.frame.size.height + 40);
                }
                
              
                
            }else{
                
                _titleV.hidden = YES;
                _discountV.hidden = YES;
                _serviceV.frame = CGRectMake(_serviceV.frame.origin.x, _openDataLabel.frame.origin.y
                                             +_openDataLabel.frame.size.height + 15.0, _serviceV.frame.size.width, _serviceV.frame.size.height);
                _payBtn.frame = CGRectMake(_payBtn.frame.origin.x, _serviceV.frame.origin.y+_serviceV.frame.size.height + 15.0, _payBtn.frame.size.width, _payBtn.frame.size.height);
                
            }
            
        }else{
            [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
            
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        
    }];
    
}

// 从safari回到此页 后台进前台
- (void)becomeActive:(NSNotification *)notification {
    
    if (_isBackFromSafari) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSpace" object:nil];
        
        [self getData];
        
    }
}

// 点击一条优惠
-(void)clickDiscountBtn:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    NSInteger index = btn.tag - 400;
    
    for (int i=0; i<[itemsArray count]; i++) {
        
        if (index == i) {
            
            btn.selected = YES;
            selected = i;
            
        }else{
            
            UIButton *itemBtn = [_discountV viewWithTag:i+400];
            itemBtn.selected = NO;
        }
        
    }
    
    
    if ([itemsArray count] > 0) {
        
        payUrlStr = [[itemsArray objectAtIndex:index] objectForKey:@"url"];
    }
}

//// 检查支付是否成功接口
//-(void)checkIsSuccess{
//    
//    // _isBackFromSafari = NO;
//    // 刷新支付历史
//    // [self getData];
//    // 刷新空间主页
//    //[[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSpace" object:nil];
//    
//    //成功文言 “支付成功” 失败文言 “支付失败,请重新尝试”
//
//}

// 支付
- (IBAction)payAction:(id)sender {
    
    if (![@""  isEqual: payUrlStr]) {
        [ReportObject event:ID_CLICK_PAY];
        
        _isBackFromSafari = YES;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:payUrlStr]];
    }else{
        
        [Utilities showAlert:@"提示" message:@"支付链接异常" cancelButtonTitle:@"确定" otherButtonTitle:nil];
    }
    
}

//点我了解什么是成长空间 进入wap页
- (IBAction)clickIntroduce:(id)sender {
    
    SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    fileViewer.webType = SWLoadURl;
    fileViewer.url = url;
    fileViewer.isShowSubmenu = @"0";
    [self.navigationController pushViewController:fileViewer animated:YES];
}

// 知校服务条款
- (IBAction)gotoServiceRule:(id)sender {

    SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
    
    NSURL *url = [NSURL URLWithString:serviceUrlStr];
    fileViewer.webType = SWLoadURl;
    fileViewer.url = url;
    fileViewer.isShowSubmenu = @"0";
    [self.navigationController pushViewController:fileViewer animated:YES];

}


- (IBAction)checkAction:(id)sender {
    
    if ([Utilities image:_checkImgV.image equalsTo:[UIImage imageNamed:@"checkImg_press.png"]]) {
        
         [_checkImgV setImage:[UIImage imageNamed:@"checkImg_normal.png"]];
        [_payBtn setBackgroundImage:[UIImage imageNamed:@"btn_pay_unclick.png"] forState:UIControlStateNormal];
        [_payBtn setBackgroundImage:[UIImage imageNamed:@"btn_pay_unclick.png"] forState:UIControlStateHighlighted];
        _payBtn.userInteractionEnabled = NO;

    }else if ([Utilities image:_checkImgV.image equalsTo:[UIImage imageNamed:@"checkImg_normal.png"]]){
        [_checkImgV setImage:[UIImage imageNamed:@"checkImg_press.png"]];
        [_payBtn setBackgroundImage:[UIImage imageNamed:@"btn_pay_normal.png"] forState:UIControlStateNormal];
        [_payBtn setBackgroundImage:[UIImage imageNamed:@"btn_pay_press.png"] forState:UIControlStateHighlighted];
        _payBtn.userInteractionEnabled = NO;

        
    }
   
    
}

// 去成长空间
-(void)gotoGrowthSpace:(NSString*)status{
    
    GrowthNotValidateViewController *growVC = [[GrowthNotValidateViewController alloc] init];
    growVC.cId = _cId;
    growVC.urlStr = _urlStr;
    growVC.spaceStatus = status;
    growVC.redPointDic = _redPointDic;
    [self.navigationController pushViewController:growVC animated:YES];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0){
    
    if(alertView.tag == 222){
        
        [self performSelector:@selector(test) withObject:nil afterDelay:0.5];

//        [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadPublishGrowingStatus" object:nil];

        if ([_fromName isEqualToString:@"publishB"]){//跳回发布页或者跳回动态列表
            
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-1-2] animated:YES];
            
        }else{
             [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

- (void)test
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadPublishGrowingStatus" object:nil];
}


@end
