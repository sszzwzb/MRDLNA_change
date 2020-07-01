//
//  MyPointsViewController.m
//  MicroSchool
//  我的积分
//  Created by Kate's macmini on 15/8/4.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "MyPointsViewController.h"
#import "CXAlertView.h"
#import "SingleWebViewController.h"

@interface MyPointsViewController ()
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UILabel *todayLabel;
@property (strong, nonatomic) IBOutlet UILabel *limitLabel;

@property (strong, nonatomic) IBOutlet UIImageView *progressImgV;
@property (strong, nonatomic) IBOutlet UIImageView *progressOffImgv;

@property (weak, nonatomic) IBOutlet UILabel *sumLabel;


- (IBAction)showPointsIntroduce:(id)sender;

@end

@implementation MyPointsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setCustomizeTitle:_titleName];
    [self setCustomizeLeftButton];
    
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
        [self.view addSubview:noNetworkV];
        return;
    }
    
    listArray = [[NSMutableArray alloc] init];
    progressImg = [UIImage imageNamed:@"progress_on.png"];
    
    
    /*if ([_dic count] > 0) {
        
        _totalLabel.text = [NSString stringWithFormat:@"%@",[[_dic objectForKey:@"total"] objectForKey:@"credit"]];
        _todayLabel.text = [NSString stringWithFormat:@"%@",[[_dic objectForKey:@"today"] objectForKey:@"credit"]];
        _limitLabel.text = [NSString stringWithFormat:@"%@",[[_dic objectForKey:@"limit"] objectForKey:@"credit"]];
        [progressView setProgress:[_todayLabel.text floatValue]/[_totalLabel.text floatValue]];
        [Utilities showProcessingHud:self.view];
        [self getPointsRuleList];
        
    }else{*/
        //获取数据
        [Utilities showProcessingHud:self.view];
        _tableView.hidden = YES;
        [self getPoints];
    //}
   
    _sumLabel.adjustsFontSizeToFitWidth = YES;//根据长度自动变化字体大小
    _totalLabel.adjustsFontSizeToFitWidth = YES;
    
    _tableView.tableHeaderView = _headerView;
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MyTabBarController setTabBarHidden:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCount = 0;
    if (0 == section) {
        rowCount = 1;
    }else if(1 == section) {
        rowCount = [listArray count]+1;
    }
    
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *GroupedTableIdentifier = @"reuseIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    
    if (indexPath.section == 0) {
        
        cell.textLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        cell.textLabel.text = @"积分商城";
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1];
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"jfsc.png"];
        
    }else if(indexPath.section == 1){
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if (indexPath.row == 0) {
            cell.textLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
            cell.textLabel.text = @"积分任务";
            cell.imageView.image = [UIImage imageNamed:@"jfrw.png"];
            cell.detailTextLabel.text = @"";
        }else{
            
            cell.imageView.image = nil;
            cell.textLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
            cell.detailTextLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
            
            NSUInteger index = indexPath.row -1;
            
            NSString *ruleName = [[listArray objectAtIndex:index] objectForKey:@"rulename"];
            NSString *times = [NSString stringWithFormat:@"(每日最多%@次)",[[listArray objectAtIndex:index] objectForKey:@"rewardnum"]];
            NSString *credit = [NSString stringWithFormat:@"%@积分/次",[[listArray objectAtIndex:index] objectForKey:@"credit"]];
            //rewardnum 每日最多几次 credit 每次多少积分
            NSString *str = [NSString stringWithFormat:@"%@%@",ruleName,times];
            
            NSMutableAttributedString *returnStr = [[NSMutableAttributedString alloc] initWithString:str];
            
            NSUInteger start = 0;
            NSUInteger rangeLength = 0;
            
            start = [ruleName length];
            rangeLength = [times length];
            
            [returnStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1] range:NSMakeRange(start,rangeLength)];//颜色
            [returnStr addAttribute:NSFontAttributeName
                                      value:[UIFont systemFontOfSize:15.0]
                                      range:NSMakeRange(start,rangeLength)];//字体
            
            
            
            
            cell.textLabel.attributedText = returnStr;
            cell.detailTextLabel.text = credit;
            
        }
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    if (indexPath.section == 0){
        //NSLog(@"shopUrl:%@",shopUrl);
    
    if (shopUrl!=nil && [shopUrl length]>0) {
        
        NSString *url = [Utilities appendUrlParams:shopUrl];
#if 0
        SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
        fileViewer.fromName = @"MyPoints";
        fileViewer.requestURL = url;
        fileViewer.titleName = @"";
        fileViewer.isShowSubmenu = @"0";
#endif
        // 2015.09.23
        SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
        fileViewer.requestURL = url;
        fileViewer.titleName = @"";
        fileViewer.isShowSubmenu = @"0";
        [self.navigationController pushViewController:fileViewer animated:YES];
        
        //积分商城近期开放，敬请期待。
        [ReportObject event:ID_POINT_SHOP];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"积分商城近期开放，敬请期待。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
}
    

}

-(void)getPoints{
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Reward",@"ac",
                          @"2",@"v",
                          @"rewards", @"op",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        
        _tableView.hidden = NO;
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        NSLog(@"respDic:%@",respDic);
        
        if ([result integerValue] == 1) {
            
            NSDictionary *tempDic = [respDic objectForKey:@"message"];
            note = [[NSString alloc]init];
            note = [tempDic objectForKey:@"note"];//积分介绍
            shopUrl = [[NSString alloc]init];
            shopUrl = [tempDic objectForKey:@"url"];//积分商城url
            
            _dic = [tempDic objectForKey:@"reward"];
            //listArray = [tempDic objectForKey:@"rules"];
            NSMutableArray *tempArray = [tempDic objectForKey:@"rules"];
            for (int i=0; i<[tempArray count]; i++) {
                if ([[tempArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                    NSLog(@"");
                    [listArray addObject:[tempArray objectAtIndex:i]];
                }else{
                   //给后台做容错处理 数组中可能有“<null>”
                }
            }
            
            if ([_dic count] > 0) {
                
                NSString *myPoints = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[_dic objectForKey:@"total"] objectForKey:@"credit"]]];
                [[NSUserDefaults standardUserDefaults] setObject:myPoints forKey:@"MyPoints"];

                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyPoints" object:nil];
                
                _totalLabel.text = [NSString stringWithFormat:@"%@",[[_dic objectForKey:@"total"] objectForKey:@"credit"]];
                _sumLabel.text = [NSString stringWithFormat:@"%@",[[_dic objectForKey:@"sum"] objectForKey:@"credit"]];
                _todayLabel.text = [NSString stringWithFormat:@"%@",[[_dic objectForKey:@"today"] objectForKey:@"credit"]];
                _limitLabel.text = [NSString stringWithFormat:@" / %@",[[_dic objectForKey:@"limit"] objectForKey:@"credit"]];
                
                CGSize typeSize = [Utilities getLabelHeight:_todayLabel size:CGSizeMake(0, 21.0)];
                _todayLabel.frame = CGRectMake(_todayLabel.frame.origin.x, _todayLabel.frame.origin.y, typeSize.width, 21.0);
                _limitLabel.frame = CGRectMake(_todayLabel.frame.origin.x+_todayLabel.frame.size.width, _limitLabel.frame.origin.y, 50.0, 21.0);
                
                NSString *limitStr = [NSString stringWithFormat:@"%@",[[_dic objectForKey:@"limit"] objectForKey:@"credit"]];
                
                float percent = [_todayLabel.text floatValue]/[limitStr floatValue];
                if([_todayLabel.text floatValue] > [limitStr floatValue]){
                    
                    NSLog(@"_todayLabel.text floatValue:%f",[_todayLabel.text floatValue]);
                     NSLog(@"_limitLabel floatValue:%f",[_limitLabel.text floatValue]);
                    percent = 1.0;
                }
                CGRect frame = _progressImgV.frame;
                frame.size.width = percent * _progressOffImgv.frame.size.width;
                _progressImgV.frame = frame;
                
                _progressImgV.image = [progressImg resizableImageWithCapInsets:UIEdgeInsetsMake(progressImg.size.height/2.0,progressImg.size.width/2.0, progressImg.size.height/2.0, progressImg.size.width/2.0)];
                
                
            }
            
            [_tableView reloadData];
            
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 20;
    }else {
        return 10;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showPointsIntroduce:(id)sender {
    
    [ReportObject event:ID_POINT_INTRODUCE];
    
    CGSize size = [note sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(240,400) lineBreakMode:NSLineBreakByTruncatingTail];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -20,240, size.height)];
    
    textLabel.font = [UIFont systemFontOfSize:14.0];
    textLabel.textColor = [UIColor blackColor];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.lineBreakMode =NSLineBreakByWordWrapping;
    textLabel.numberOfLines =0;
    textLabel.textAlignment =NSTextAlignmentLeft;
    textLabel.text = note;
   
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"积分介绍" message:note preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc ] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        //iOS8下 UIAlertController 左对齐
        //----方法1 设置 AttributedString------------------------------------------------------------------
       /* NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc] initWithString:note];
        [messageText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [note length])];
        [messageText addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:14.0]
                          range:NSMakeRange(0,[note length])];//字体
        
        [alertController setValue:messageText forKey:@"attributedMessage"];*/
        //--------------------------------------------------------------------------------------------------
        
        //----方法2 遍历UIAlertController的subview找到message所属的Label---------------------------------------
        NSArray *viewArray = [[[[[[[[[[[[alertController view] subviews] firstObject] subviews] firstObject] subviews] firstObject] subviews] firstObject] subviews] firstObject] subviews];
        //UILabel *alertTitle = viewArray[0];
        UILabel *alertMessage = viewArray[1];
        alertMessage.textAlignment = NSTextAlignmentLeft;
        //----------------------------------------------------------------------------------------------------
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"积分介绍" message:note delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.delegate = self;
        
        [alert setValue:textLabel forKey:@"accessoryView"];
        
        alert.message =@"";
        [alert show];

    }
    
   
   }

@end
