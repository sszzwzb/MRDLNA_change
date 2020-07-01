//
//  ScoreMainViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/10/8.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "ScoreMainViewController.h"
#import "SingleSubjectListViewController.h"
#import "TotalSubjectsViewController.h"
#import "ChartListViewController.h"

@interface ScoreMainViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UILabel *scoreName;
@property (strong, nonatomic) IBOutlet UILabel *totalScore;
@property (strong, nonatomic) IBOutlet UILabel *dateLine;
@property (strong, nonatomic) IBOutlet UILabel *classRank;
@property (strong, nonatomic) IBOutlet UILabel *schoolRank;
@property (strong, nonatomic) IBOutlet UILabel *classAverage;
@property (strong, nonatomic) IBOutlet UILabel *schoolAverage;
@property (strong, nonatomic) IBOutlet UILabel *classHighest;
@property (strong, nonatomic) IBOutlet UILabel *schoolHighest;
@property (strong, nonatomic) IBOutlet UIImageView *classRankImgV;
@property (strong, nonatomic) IBOutlet UIImageView *schoolRankImgV;
@property (strong, nonatomic) IBOutlet UIView *subjectView;
@end

@implementation ScoreMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@"成绩主页"];
    
    [ReportObject event:ID_OPEN_SCORE_MAIN];
    
    winSize = [[UIScreen mainScreen] bounds].size;
    
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
        [self.view addSubview:noNetworkV];
        return;
    }
    
    _tableView.tableHeaderView = _headerView;
    
    _tableView.hidden = YES;
    [Utilities showProcessingHud:self.view];
    [self getData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    return 1;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 15;
    }else{
        return 5;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
        
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
            
            if (indexPath.row == 0) {
                cell.textLabel.text = @"成绩记录";
                cell.imageView.image = [UIImage imageNamed:@"cjjl.png"];
            }
        }else if (indexPath.section == 1){
            if (indexPath.row == 0) {
                cell.textLabel.text = @"图表分析";
                cell.imageView.image = [UIImage imageNamed:@"tbfx.png"];
            }
        }
        return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    if (indexPath.section == 0) {// 成绩记录
        
        TotalSubjectsViewController *totalSVC = [[TotalSubjectsViewController alloc] init];
        totalSVC.cId = _cId;
        totalSVC.number = _number;
        [self.navigationController pushViewController:totalSVC animated:YES];
        
    }else if (indexPath.section == 1){// 图表分析
        [ReportObject event:ID_OPEN_SCORE_CHART];

        ChartListViewController *chartLVC = [[ChartListViewController alloc] init];
        chartLVC.cId = _cId;
        [self.navigationController pushViewController:chartLVC animated:YES];
        
    }
    
}

/**
 * 成绩详情&成绩首页
 * @author luke
 * @date 2015.10.08
 * @args
 *  v=2, ac=GrowingSpace, op=exam, sid=, uid=, cid= , exam=考试ID[成绩首页＝0,最新考试], page=, size=
 *
 */
-(void)getData{
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"GrowingSpace",@"ac",
                          @"2",@"v",
                          @"exam", @"op",
                          _cId,@"cid",
                          @"0",@"exam",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            NSLog(@"成绩主页:%@",respDic);
            
            NSDictionary *examDic = [[respDic objectForKey:@"message"] objectForKey:@"exam"];
            if ([examDic count] > 0) {
                
                //NSDictionary *profile = [examDic objectForKey:@"profile"];
                //NSString *lastIdStr = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[profile objectForKey:@"id"]]];
                //[Utilities updateSpaceRedPoints:_cId last:lastIdStr mid:@"10006"];//2015.12.18 在成绩主页更新红点 志伟确认 update 2016.03.01
                
                
                _tableView.hidden = NO;
                
                [noDataView removeFromSuperview];
                
                _classRankImgV = [[UIImageView alloc] initWithFrame:CGRectMake(111.0, 93.0, 10.0, 10.0)];
                [_headerView addSubview:_classRankImgV];
                
                _schoolRankImgV = [[UIImageView alloc] initWithFrame:CGRectMake(275.0, 93.0, 10.0, 10.0)];
                [_headerView addSubview:_schoolRankImgV];
                
                _scoreName.text = [[examDic objectForKey:@"profile"] objectForKey:@"name"];
               
                
                NSString *score = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[examDic objectForKey:@"profile"] objectForKey:@"score"]]];
                if ([score length] == 0) {
                    score = @"--";
                }else if ([score integerValue] == -1){
                    score = @"--";
                }
                 _totalScore.text = score;
                
                
                NSString *dateStr = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[examDic objectForKey:@"profile"] objectForKey:@"dateline"]]];
                NSString *date = [[Utilities alloc] linuxDateToString:dateStr andFormat:@"%@-%@-%@" andType:DateFormat_YMD];
                _dateLine.text = [NSString stringWithFormat:@"更新时间：%@",date];
                
                NSDictionary *classRank = [[examDic objectForKey:@"clazz"] objectForKey:@"rank"];
                NSString *classUpOrDown = [classRank objectForKey:@"ord"];// lt 下降，gt 上升, eq 不变
                if ([classUpOrDown isEqualToString:@"gt"]) {//上升
                    _classRankImgV.image = [UIImage imageNamed:@"scoreUp.png"];
                }else if([classUpOrDown isEqualToString:@"lt"]){//下降
                    _classRankImgV.image = [UIImage imageNamed:@"scoreDown.png"];
                }else{
                    _classRankImgV.image = [UIImage imageNamed:@"eq.png"];
                }
                _classRank.text = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[classRank objectForKey:@"val"]]];
                if ([_classRank.text integerValue] == 0) {
                    _classRank.text = @"--";
                }
                
                NSString *scoreClassAverage = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[examDic objectForKey:@"clazz"] objectForKey:@"avg"]]];
                if ([scoreClassAverage length] == 0) {
                    scoreClassAverage = @"--";
                }else if ([scoreClassAverage integerValue] == -1){
                    scoreClassAverage = @"--";
                }
                
                 _classAverage.text = scoreClassAverage;
                
                NSString *scoreClassHighest = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[examDic objectForKey:@"clazz"] objectForKey:@"max"]]];
                if ([scoreClassHighest length] == 0) {
                    scoreClassHighest = @"--";
                }else if ([scoreClassHighest integerValue] == -1){
                    scoreClassHighest = @"--";
                }
                _classHighest.text = scoreClassHighest;
                
                
                if ([_classRank.text length] == 0 || [_classRank.text integerValue] == 0) {
                    _classRankImgV.image = nil;
                }
                
                NSDictionary *schoolRank = [[examDic objectForKey:@"school"] objectForKey:@"rank"];
                NSString *schoolUpOrDown = [schoolRank objectForKey:@"ord"];// lt 下降，gt 上升, eq 不变
                if ([schoolUpOrDown isEqualToString:@"gt"]) {//上升
                    _schoolRankImgV.image = [UIImage imageNamed:@"scoreUp.png"];
                }else if([schoolUpOrDown isEqualToString:@"lt"]){//下降
                    _schoolRankImgV.image = [UIImage imageNamed:@"scoreDown.png"];
                }else{
                    _schoolRankImgV.image = [UIImage imageNamed:@"eq.png"];;
                }
                
                _schoolRank.text = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[schoolRank objectForKey:@"val"]]];
                
                NSString *scoreSchoolAverage = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[examDic objectForKey:@"school"]  objectForKey:@"avg"]]];
                if ([scoreSchoolAverage length] == 0) {
                    scoreSchoolAverage = @"--";
                }else if ([scoreSchoolAverage integerValue] == -1){
                    scoreSchoolAverage = @"--";
                }
                
                 _schoolAverage.text = scoreSchoolAverage;
                
                NSString *scoreschoolHighest = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[examDic objectForKey:@"school"]  objectForKey:@"max"]]];
                if ([scoreschoolHighest length] == 0) {
                    scoreschoolHighest = @"--";
                }else if ([scoreschoolHighest integerValue] == -1){
                    scoreschoolHighest = @"--";
                }
                
                _schoolHighest.text = scoreschoolHighest;
                
                
                if ([_schoolRank.text length] == 0 || [_schoolRank.text integerValue] == 0) {
                    _schoolRankImgV.image = nil;
                    _schoolRank.text = @"--";
                    _schoolAverage.text = @"--";//2015.12.28名次为--的时候，分数也显示-- 吴宁确认
                    _schoolHighest.text = @"--";//2015.12.28名次为--的时候，分数也显示-- 吴宁确认
                }
                
                
                _classRankImgV.frame = CGRectMake(_classRank.frame.origin.x+[_classRank.text length]*8.0+5.0, _classRankImgV.frame.origin.y, _classRankImgV.frame.size.width, _classRankImgV.frame.size.height);
            
                _schoolRankImgV.frame = CGRectMake(_schoolRank.frame.origin.x+[_schoolRank.text length]*8.0+5.0, _schoolRankImgV.frame.origin.y, _schoolRankImgV.frame.size.width, _schoolRankImgV.frame.size.height);
              
                NSLog(@"_schoolRankImgV.frame.x:%f y:%f",_schoolRankImgV.frame.origin.x,_schoolRankImgV.frame.origin.y);
                courses = [[NSMutableArray alloc]initWithArray:[examDic objectForKey:@"courses"] copyItems:YES];
                
                //if ([courses count] > 0) {
                    
                    [self performSelectorOnMainThread:@selector(addMoudelView) withObject:nil waitUntilDone:NO];
                    
                //}
                
                [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
                
                [self isNeedShowMasking];

            }else{
              
                CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44);
                noDataView = [Utilities showNodataView:@"暂无相关数据" msg2:@"" andRect:rect];
                [self.view addSubview:noDataView];
            }
            
        }else{
            [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
            
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        
    }];
}

-(void)reload{
    
    [_tableView reloadData];
}


-(void)addMoudelView{
    
    int x = 0;//横
    int j = 0;//竖
    
    float lastY = 0;
    
    for (int i=0; i<[courses count]; i++) {
        
        NSString *score = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[courses objectAtIndex:i] objectForKey:@"score"]]];
        if ([score length] == 0) {
             score = @"--";
        }else if ([score integerValue] == -1){
            score = @"--";
        }
       
        NSString *name = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[courses objectAtIndex:i] objectForKey:@"name"]]];
 
        UILabel *labelScore = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 106.0, 21.0)];
        labelScore.textColor = [UIColor colorWithRed:255.0/255.0 green:153.0/255.0 blue:51.0/255.0 alpha:1];
        labelScore.textAlignment = NSTextAlignmentCenter;
        labelScore.font = [UIFont systemFontOfSize:26.0];
        
        UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(0, 75.0-21.0-10.0, 106.0, 21.0)];
        labelName.textAlignment = NSTextAlignmentCenter;
        labelName.font = [UIFont systemFontOfSize:17.0];
        labelName.textColor = [UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 106.0, 75.0);
        button.tag = 410+i;
        [button addTarget:self action:@selector(moudelSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        
//        UIView *moudelView = [[UIView alloc]init];
//        moudelView.frame = CGRectMake(x*106.0, 75.0*j, 106.0, 75.0);
//        moudelView.tag = 110+i;
//       
//        labelName.text = name;
//        labelScore.text = score;
//        
//        [moudelView addSubview:labelScore];
//        [moudelView addSubview:labelName];
//        [moudelView addSubview:button];
//        
//        [_subjectView addSubview:moudelView];
//        
//        x++;
        
        if ((i!=0) && (i%3 == 0)) {
            
            j++;
            x = 0;
        }
        
        UIView *moudelView = [[UIView alloc]init];
        moudelView.frame = CGRectMake(x*106.0, 75.0*j, 106.0, 75.0);
        moudelView.tag = 110+i;
        
        labelName.text = name;
        labelScore.text = score;
        
        [moudelView addSubview:labelScore];
        [moudelView addSubview:labelName];
        [moudelView addSubview:button];
        
        //NSLog(@"i:%d x:%f y:%f",i,moudelView.frame.origin.x,moudelView.frame.origin.y);
        
        [_subjectView addSubview:moudelView];
        
        x++;
        
        lastY = j*75.0 + 75.0;
        
        // 横竖线
        UIView *rowV = [[UIView alloc] initWithFrame:CGRectMake(0, j*75.0, winSize.width, 1.0)];
        rowV.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:241.0/255.0 alpha:1];
        [_subjectView addSubview:rowV];
        
        UIView *columnV = [[UIView alloc] initWithFrame:CGRectMake(x*106.0,75.0*j ,1.0, 75.0)];
        columnV.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:241.0/255.0 alpha:1];
        
        if (x!=3) {
           [_subjectView addSubview:columnV];
        }
        
        
    }
    
    _subjectView.frame = CGRectMake(0.0, _subjectView.frame.origin.y, winSize.width, lastY);
    _headerView.frame = CGRectMake(0.0, _headerView.frame.origin.y, winSize.width, _subjectView.frame.origin.y+_subjectView.frame.size.height);
    
    _tableView.tableHeaderView = _headerView;
    
}

-(void)moudelSelect:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    int i = btn.tag - 410;
    
    NSString *subjectId = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[courses objectAtIndex:i] objectForKey:@"id"]]];
    NSString *titleName = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[courses objectAtIndex:i] objectForKey:@"name"]]];
    
    [ReportObject event:ID_OPEN_SINGLE_SCORE];

    SingleSubjectListViewController *singleSLV = [[SingleSubjectListViewController alloc]init];
    singleSLV.titleName = titleName;
    singleSLV.subjectId = subjectId;
    singleSLV.cId = _cId;
    [self.navigationController pushViewController:singleSLV animated:YES];
    
}

- (void)isNeedShowMasking{
    NSString *mask = [[NSUserDefaults standardUserDefaults] objectForKey:@"growthStudentScoreMasking"];
    
    if (nil == mask) {
                [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"growthStudentScoreMasking"];
                [[NSUserDefaults standardUserDefaults]synchronize];
        
        if (iPhone4) {
            [self showMaskingView:CGRectMake(100, 344, 100, 40) image:[UIImage imageNamed:@"Masking/growthStudentScoreFor4"]];
        }else {
            [self showMaskingView:CGRectMake(110, 344, 100, 40) image:[UIImage imageNamed:@"Masking/growthStudentScore"]];
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
    //    buttonMasking.backgroundColor = [UIColor redColor];
    [buttonMasking addTarget:self action:@selector(dismissMaskingView:) forControlEvents: UIControlEventTouchUpInside];
    [_viewMasking addSubview:buttonMasking];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_viewMasking];
}

- (IBAction)dismissMaskingView:(id)sender {
    _viewMasking.hidden = YES;
}

@end
