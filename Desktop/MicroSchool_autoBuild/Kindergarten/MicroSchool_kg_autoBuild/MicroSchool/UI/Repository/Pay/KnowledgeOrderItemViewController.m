//
//  KnowledgeOrderItemViewController.m
//  MicroSchool
//
//  Created by jojo on 15/2/12.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "KnowledgeOrderItemViewController.h"

@interface KnowledgeOrderItemViewController ()

@end

@implementation KnowledgeOrderItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super setCustomizeTitle:@"付费订单"];
    [super setCustomizeLeftButton];
    
    network = [NetworkUtility alloc];
    network.delegate = self;
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    
    _isBackFromSafari = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];

    NSDictionary *data;
    data = [[NSDictionary alloc] initWithObjectsAndKeys:
            REQ_URL, @"url",
            @"WikiShop",@"ac",
            @"2",@"v",
            @"order", @"op",
            _tid,@"tid",
            _iid,@"iid",
            nil];
    
    [network sendHttpReq:HttpReq_KnowledgeWikiShopOrder andData:data];
}

- (void)becomeActive:(NSNotification *)notification {
    if (_isBackFromSafari) {
//        progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        progressHud.labelText = @"更新中...";
         [Utilities showProcessingHud:self.view];// 2015.05.12
        
        NSDictionary *data;
        data = [[NSDictionary alloc] initWithObjectsAndKeys:
                REQ_URL, @"url",
                @"WikiShop",@"ac",
                @"2",@"v",
                @"check", @"op",
                _model.orderOid,@"oid",
                nil];
        
        [network sendHttpReq:HttpReq_KnowledgeWikiShopCheck andData:data];
    }
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
#if 0
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width , [UIScreen mainScreen].applicationFrame.size.height - 44)];
    _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height - 44);
    _scrollView.scrollEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.bounces = YES;
    _scrollView.alwaysBounceHorizontal = NO;
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.directionalLockEnabled = YES;
    [self.view addSubview:_scrollView];
#endif
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"付费信息";
    }else if(section == 1){
        return @"支付方式";
    }
    
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else if(section == 1){
        return [_model.payment count];
    }else if(section == 2){
        return 1;
    }
    
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (2 == [indexPath section] && 0 == [indexPath row]) {
        static NSString *CellTableIdentifier1 = @"CellTableIdentifier1";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier1];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellTableIdentifier1];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        
         cell.textLabel.font = [UIFont systemFontOfSize:17.0];
         cell.detailTextLabel.font = [UIFont systemFontOfSize:17.0];
        cell.textLabel.text = @"支付";
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor colorWithRed:75/255.0 green:170/255.0 blue:252/255.0 alpha:1];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        return cell;
    }else {
        static NSString *CellTableIdentifier = @"CellTableIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleValue1
                    reuseIdentifier:CellTableIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
         cell.detailTextLabel.font = [UIFont systemFontOfSize:17.0];
         cell.textLabel.font = [UIFont systemFontOfSize:17.0];
        if (0 == [indexPath section] && 0 == [indexPath row]){
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"项目";
            cell.detailTextLabel.text = _model.orderItem;
        }else if (0 == [indexPath section] && 1 == [indexPath row]) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"价格";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", _model.orderPrice];
        }else if (1 == [indexPath section] && 0 == [indexPath row]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            _payType = [[_model.payment objectAtIndex:0] objectForKey:@"name"];
            cell.textLabel.text = [[_model.payment objectAtIndex:0] objectForKey:@"name"];
        }else if (1 == [indexPath section] && 1 == [indexPath row]) {
            cell.textLabel.text = [[_model.payment objectAtIndex:1] objectForKey:@"name"];
        }else if (1 == [indexPath section] && 2 == [indexPath row]) {
            cell.textLabel.text = [[_model.payment objectAtIndex:2] objectForKey:@"name"];
        }
        
        return cell;
    }
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    if ((0 != [indexPath section]) && (2 != [indexPath section])) {
        NSArray *array = [tableView visibleCells];
        for (UITableViewCell *cell in array) {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        [[tableView cellForRowAtIndexPath:indexPath]setAccessoryType:UITableViewCellAccessoryCheckmark];
        
        _payType = [[_model.payment objectAtIndex:[indexPath row]] objectForKey:@"name"];
        
    }
    
    if (2 == [indexPath section] && 0 == [indexPath row]) {
        // 支付
        NSLog(@"%@", _payType);
        
        NSString *payUrl = [[_model.payment objectAtIndex:[indexPath row]] objectForKey:@"url"];
        
        if (![@""  isEqual: payUrl]) {
            _isBackFromSafari = YES;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:payUrl]];
        }
    }
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data
                                                               options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if ([@"WikiShopAction.order"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
        
        [Utilities dismissProcessingHud:self.view];// 2015.05.12
        if(true == [result intValue])
        {
            //将JSON数据和Model的属性进行绑定
            _model = [MTLJSONAdapter modelOfClass:[KnowledgeOrderItemModel class]
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
    }else if ([@"WikiShopAction.check"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
        
        [Utilities dismissProcessingHud:self.view];
        NSDictionary *dic = [resultJSON objectForKey:@"message"];
        NSDictionary *order = [dic objectForKey:@"order"];

        if(true == [result intValue])
        {
            if(true == [[order objectForKey:@"status"] intValue]) {
                
                [ReportObject event:ID_ORDER_WIKI];//2015.06.24
                
                _isBackFromSafari = NO;
                
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"支付成功"
                                                               message:[NSString stringWithFormat:@"您刚刚购买了价格为(%@)的(%@)，并支付成功。", [order objectForKey:@"price"],[order objectForKey:@"item"]]
                                                              delegate:self
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
                [alert show];
            }else {
                // 0 未付款
                // 1 付款中
                // 2 已付款
                NSString *pay_status = [order objectForKey:@"pay_status"];
                
                if ([@"0"  isEqual: pay_status] || [@"1"  isEqual: pay_status]) {
                    // 用户正在付款中，不需要显示支付失败
                }else {
                    _isBackFromSafari = NO;

                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"失败"
                                                                   message:@"支付遇到问题，请稍后再试。"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil];
                    [alert show];
                }
            }
        }else {
            NSString *message = [resultJSON objectForKey:@"message"];

            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"失败"
                                                           message:@"支付遇到问题，请稍后再试。"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)reciveHttpDataError:(NSError*)err
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshKnowledgeHome" object:nil];

    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]
                                          animated:YES];
}

@end
