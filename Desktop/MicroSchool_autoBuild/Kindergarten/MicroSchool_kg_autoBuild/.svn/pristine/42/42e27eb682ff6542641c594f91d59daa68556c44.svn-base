//
//  HealthViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/11/26.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "HealthViewController.h"
#import "PhysicalRecordTableViewCell.h"
#import "TestReportTableViewCell.h"
#import <CoreText/CoreText.h>
#import "HealthDetailViewController.h"
#import "ChartListViewController.h"
#import "TestReportDetailViewController.h"


@interface HealthViewController ()
@property (strong, nonatomic) IBOutlet UIButton *addItemBtn;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation HealthViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:_titleName];
    
    [ReportObject event:ID_OPEN_BODY_MAIN];
    
    _tableView.hidden = YES;
    
    if (![Utilities isConnected]) {//2015.12.07
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
        [self.view addSubview:noNetworkV];
        return;
    }
    
    _addItemBtn.tag = 122;
    [_addItemBtn setBackgroundImage:[UIImage imageNamed:@"addItem_normal_health.png"] forState:UIControlStateNormal];
    [_addItemBtn setBackgroundImage:[UIImage imageNamed:@"addItem_press_health.png"] forState:UIControlStateHighlighted];
    [_addItemBtn setTitleColor:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1] forState:UIControlStateNormal];
     [_addItemBtn setTitleColor:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1] forState:UIControlStateHighlighted];
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"+ 添加记录"];
    
    [title addAttribute:(NSString *)kCTFontAttributeName
                              value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)[UIFont systemFontOfSize:21].fontName,21,NULL))
                              range:NSMakeRange(0,1)];//字体
    [title addAttribute:(NSString *)kCTFontAttributeName
                  value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)[UIFont systemFontOfSize:15.0].fontName,
                                                                   15.0,
                                                                   NULL))
                  range:NSMakeRange(1,4)];//字体
    
     [title addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1] range:NSMakeRange(0,6)];//颜色
    
    
    [_addItemBtn setAttributedTitle:title forState:UIControlStateNormal];
    [_addItemBtn setAttributedTitle:title forState:UIControlStateHighlighted];
    
    _addItemBtn.frame = CGRectMake(10.0, 7.0, _addItemBtn.frame.size.width, _addItemBtn.frame.size.height);
    
    [_addItemBtn addTarget:self action:@selector(gotoAddItem) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadData)
                                                 name:@"reloadHealthView"
                                               object:nil];

    
    [self getData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)reload{
    
    [_tableView reloadData];
}

-(void)getData{
    
    [Utilities showProcessingHud:self.view];
    [self loadData];
}

/**
 * 体育评测首页接口
 * @author luke
 * @date 2015.11.17
 * @args
 *  v=2, ac=Physical, op=index, sid=, uid=, cid=
 */
-(void)loadData{
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Physical",@"ac",
                          @"2",@"v",
                          @"index", @"op",
                          _cid, @"cid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        //NSLog(@"respDic:%@",respDic);
        
        if ([result integerValue] == 1) {
            
            _tableView.hidden = NO;
            
            if (!dic) {
                 dic = [[NSDictionary alloc] init];
            }
            
            dic = [respDic objectForKey:@"message"];
            
            NSDictionary *scoreDic = [dic objectForKey:@"score"];
            NSString *lastIdStr = [NSString stringWithFormat:@"%@",[scoreDic objectForKey:@"pid"]];
            
            //[Utilities updateClassRedPoints:_cId last:lastIdStr mid:_mid];//2015.11.13
            /*
             const SPACE_PHYSICAL_SCORE = 10005; //成长空间：体测成绩
             const SPACE_EXAM_SCORE = 10006; //成长空间：考试成绩
             */
            //[Utilities updateSpaceRedPoints:_cid last:lastIdStr mid:@"10005"];//2015.12.17 update 2016.03.01
            
            [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
            
            [self isNeedShowMasking];
        }else{
            
            NSString *msg = [NSString stringWithFormat:@"%@",[respDic objectForKey:@"message"]];
            
            [Utilities showFailedHud:msg descView:self.view];
            
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        
    }];

}


#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if (section == 1) {
        return 2;
    }else{
        return 5;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0){
        return 80;
    }else if (indexPath.section == 1 && indexPath.row == 0){
        return 80;
    }else{
        return 50;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    static NSString *GroupedTableIdentifier1 = @"PhysicalRecordTableViewCell";
    static NSString *GroupedTableIdentifier2 = @"TestReportTableViewCell";

    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        PhysicalRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier1];
        if(cell == nil) {
            
            UINib *nib = [UINib nibWithNibName:@"PhysicalRecordTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:GroupedTableIdentifier1];
            cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier1];
        }
        
        
        NSDictionary *conditionDic = [dic objectForKey:@"condition"];
        if ([conditionDic count] == 0) {
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType =  UITableViewCellAccessoryNone;
            cell.dateLabel.hidden = YES;
            cell.heightTitleLabel.hidden = YES;
            cell.weightTitleLabel.hidden = YES;
            cell.visionTitleLabel.hidden = YES;
            cell.leftEyeTitleLabel.hidden = YES;
            cell.rightEyeTitleLabel.hidden = YES;
            cell.noDataLabel.text = @"暂无数据";
            
        }else{
            
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
            
            cell.dateLabel.hidden = NO;
            cell.heightTitleLabel.hidden = NO;
            cell.weightTitleLabel.hidden = NO;
            cell.visionTitleLabel.hidden = NO;
            cell.leftEyeTitleLabel.hidden = NO;
            cell.rightEyeTitleLabel.hidden = NO;
            cell.noDataLabel.text = @"";
            
            NSString *dateStr = [NSString stringWithFormat:@"%@",[conditionDic objectForKey:@"dateline"]];
            NSString *height = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[conditionDic objectForKey:@"height"]]];
            NSString *weight = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[conditionDic objectForKey:@"weight"]]];
            NSDictionary *visionDic =  [conditionDic objectForKey:@"vision"];
            
            if (visionDic) {
                NSString *left = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[visionDic objectForKey:@"left"]]];
                NSString *right = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[visionDic objectForKey:@"right"]]];
                cell.leftEyeLabel.text = left;
                cell.rightEyeLabel.text = right;
            }
            
            cell.dateLabel.text = [[Utilities alloc] linuxDateToString:dateStr andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
            cell.heightLabel.text = height;
            cell.weightLabel.text = weight;
        }
        
        return cell;
        
    }else if (indexPath.section == 1 && indexPath.row == 0){
        
        TestReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier2];
        if(cell == nil) {
            
            UINib *nib = [UINib nibWithNibName:@"TestReportTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:GroupedTableIdentifier2];
            cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier2];
        }
        
        NSDictionary *scoreDic = [dic objectForKey:@"score"];
        if ([scoreDic count] == 0) {
 
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType =  UITableViewCellAccessoryNone;
            cell.rankTitleLabel.hidden = YES;
            cell.noDataLabel.text = @"暂无数据";
            
        }else{
            
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;

            cell.rankTitleLabel.hidden = NO;
            cell.noDataLabel.hidden = YES;
            
            NSString *title = [NSString stringWithFormat:@"%@",[scoreDic objectForKey:@"title"]];
            NSString *dateStr = [NSString stringWithFormat:@"%@",[scoreDic objectForKey:@"dateline"]];
            NSDictionary *rankDic = [scoreDic objectForKey:@"rank"];
            
            if (rankDic) {
                
                NSString *grade = [NSString stringWithFormat:@"%@",[rankDic objectForKey:@"grade"]];
                
                if ([grade integerValue] == 0) {
                   
                    cell.RankLabel.text = @"--";
                    cell.RankLabel.textColor = [UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1];
                    
                }else{
                    NSString *tempStr = [NSString stringWithFormat:@"第%@名",grade];
                    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:tempStr];
                    [title addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1] range:NSMakeRange(1,[grade length])];//颜色
                    cell.RankLabel.attributedText = title;
 
                }
                
            }
            
            NSString *score = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[scoreDic objectForKey:@"score"]]];
            cell.dateLabel.text = title;
            NSString *updateDate = [[Utilities alloc] linuxDateToString:dateStr andFormat:@"%@-%@-%@" andType:DateFormat_YMD];
            cell.updateDateLabel.text = [NSString stringWithFormat:@"更新时间：%@",updateDate];
            cell.scoreLabel.text = score;
        }
        
        return cell;
        
    }else{
        
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
            
            if (indexPath.row == 4) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType =  UITableViewCellAccessoryNone;

                if (![cell viewWithTag:122]) {
                    [cell addSubview:_addItemBtn];
                }
            }else{
              
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    if (indexPath.row == 1) {
                        cell.textLabel.text = @"历史记录";
                        cell.imageView.image = [UIImage imageNamed:@"history_health.png"];
                    }else if (indexPath.row == 2){
                        cell.textLabel.text= @"记录走势图";
                        cell.imageView.image = [UIImage imageNamed:@"chart_health.png"];
                    }else if (indexPath.row == 3){
                        cell.textLabel.text = @"最新记录对比图";
                        cell.imageView.image = [UIImage imageNamed:@"newList_health.png"];
                    }
                cell.textLabel.font = [UIFont systemFontOfSize:15.0];
                cell.textLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
            }
            
        }else if (indexPath.section == 1){
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            if (indexPath.row == 1) {
                cell.textLabel.text = @"历史记录";
                cell.imageView.image = [UIImage imageNamed:@"history_health.png"];
            }
            cell.textLabel.font = [UIFont systemFontOfSize:15.0];
            cell.textLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
            
        }
        return cell;
    }
    
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    NSDictionary *conditionDic = [dic objectForKey:@"condition"];
    NSString *pid = [NSString stringWithFormat:@"%@",[conditionDic objectForKey:@"pid"]];
    NSDictionary *scoreDic = [dic objectForKey:@"score"];
    NSString *reportPid = [NSString stringWithFormat:@"%@",[scoreDic objectForKey:@"pid"]];

    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {//身体详情

            if ([conditionDic count] > 0) {
                
                HealthDetailViewController *healthDetailV = [[HealthDetailViewController alloc] init];
                healthDetailV.cid = _cid;
                healthDetailV.pid = pid;
                healthDetailV.nunmber = _number;
                [self.navigationController pushViewController:healthDetailV animated:YES];

            }
            
            
        }else if (indexPath.row == 1){
            // 身体历史记录
            HealthHistoryViewController *vc = [[HealthHistoryViewController alloc] init];
            vc.titleName = @"身体记录";
            vc.cid = _cid;
            vc.viewType = @"conditions";
            vc.number = _number;
            [self.navigationController pushViewController:vc animated:YES];

        }else if (indexPath.row == 2){//记录走势图
            [ReportObject event:ID_OPEN_BODY_CHART];
            
            ChartListViewController *chartListV = [[ChartListViewController alloc] init];
            chartListV.fromName = @"health";
            chartListV.titleName = @"身体记录走势图";
            chartListV.cId = _cid;
            [self.navigationController  pushViewController:chartListV animated:YES];
            
        }else{//柱状图
            [ReportObject event:ID_OPEN_BODY_COMPARE];

            ChartListViewController *chartListV = [[ChartListViewController alloc] init];
            chartListV.fromName = @"healthBar";
            chartListV.titleName = @"最新记录对比图";
            chartListV.cId = _cid;
            [self.navigationController  pushViewController:chartListV animated:YES];

        }
        
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {//体测详情
            
            if ([scoreDic count] > 0) {
            
                TestReportDetailViewController *testReportDeV = [[TestReportDetailViewController alloc] init];
                testReportDeV.cid = _cid;
                testReportDeV.pid = reportPid;
                testReportDeV.nunmber = _number;
                [self.navigationController pushViewController:testReportDeV animated:YES];
                
            }
            
        }else if (indexPath.row == 1){
            // 体测历史记录
            HealthHistoryViewController *vc = [[HealthHistoryViewController alloc] init];
            vc.titleName = @"评测记录";
            vc.cid = _cid;
            vc.viewType = @"scores";
            vc.number = _number;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

//去添加记录页
-(void)gotoAddItem{
#if 9
    HealthSubmitViewController *vc = [[HealthSubmitViewController alloc] init];
    vc.cid = _cid;
    vc.viewType = @"submitHealth";
    [self.navigationController  pushViewController:vc animated:YES];
#endif
}

//group style的tableview设置section间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 32.0;
    }else{
        return 16.0;
    } // 第一行是第二行的2倍关系
    
}
//group style的tableview设置section间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 16.0;// footer的section也要重新设置 这样才能保证间距一致

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, 32.0)];
    customView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    headerLabel.font = [UIFont systemFontOfSize:16.0];
    headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 32.0);
    
    if (section == 0) {
        headerLabel.text =  @"身体记录";
        [customView addSubview:headerLabel];
        return customView;
    }else{
        return nil;
    }
    
    
}

/*- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, 35.0)];
    customView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    headerLabel.font = [UIFont systemFontOfSize:16.0];
    headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 33.0);
    
    if (section == 0){
        headerLabel.text = @"体测报告";
        [customView addSubview:headerLabel];
        return customView;
    }else{
        
        return nil;
    }
    
}*/

//- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    
//    if (section == 0) {
//        return @"身体记录";
//    }else{
//        return @"体测报告";
//    }
//}

- (void)isNeedShowMasking{
    NSString *mask = [[NSUserDefaults standardUserDefaults] objectForKey:@"growthStudentPhysicalMasking"];
    
    if (nil == mask) {
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"growthStudentPhysicalMasking"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        if (iPhone4) {
            [self showMaskingView:CGRectMake(110, 394, 100, 40) image:[UIImage imageNamed:@"Masking/growthStudntPhysicalFor4"]];
        }else {
            [self showMaskingView:CGRectMake(110, 394, 100, 40) image:[UIImage imageNamed:@"Masking/growthStudntPhysical"]];
        }
    }
}

- (void)showMaskingView:(CGRect )rect image:(UIImage *)img{
    _viewMasking = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UIImageView *imageViewMasking = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [imageViewMasking setImage:img];
    [_viewMasking addSubview:imageViewMasking];
    
    UIButton *buttonMasking = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonMasking.frame = rect;
//        buttonMasking.backgroundColor = [UIColor redColor];
    [buttonMasking addTarget:self action:@selector(dismissMaskingView:) forControlEvents: UIControlEventTouchUpInside];
    [_viewMasking addSubview:buttonMasking];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_viewMasking];
}

- (IBAction)dismissMaskingView:(id)sender {
    _viewMasking.hidden = YES;
}

@end
