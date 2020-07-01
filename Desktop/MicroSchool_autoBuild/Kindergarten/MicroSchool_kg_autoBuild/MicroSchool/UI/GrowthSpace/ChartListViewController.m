//
//  ChartListViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/10/9.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "ChartListViewController.h"
#import "SubjectFilterViewController.h"
#import "ChartListTableViewCell.h"
#import "TableViewCell.h"

@interface ChartListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChartListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@"综合成绩走势"];
    
    if ([@"health" isEqualToString:_fromName] || [@"healthBar" isEqualToString:_fromName]) {
       [self setCustomizeTitle:_titleName];
    }else{
       [self setCustomizeRightButton:@"icon_sxbj.png"];
    }
    
    _tableView.hidden = YES;
    
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
        [self.view addSubview:noNetworkV];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:@"updateChartList"
                                               object:nil];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"subjectIdForFilter"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [Utilities showProcessingHud:self.view];
    [self getData:@"0"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectRightAction:(id)sender{
    
    SubjectFilterViewController *subFVC = [[SubjectFilterViewController alloc] init];
    [self.navigationController pushViewController:subFVC animated:YES];
    
}

-(void)refresh{
    
    NSString *subjectName = [[NSUserDefaults standardUserDefaults] objectForKey:@"subjectNameForFilter"];
    [self setCustomizeTitle:[NSString stringWithFormat:@"%@成绩走势",subjectName]];
    
    NSString *subjectID = [[NSUserDefaults standardUserDefaults] objectForKey:@"subjectIdForFilter"];
    
    [self getData:subjectID];
    
}

/**
 * 图表汇总
 * @author luke
 * @date 2015.10.09
 * @args
 *  v=2, ac=GrowingSpace, op=scoreCharts, sid=, uid=, cid=, course=
 */
-(void)getData:(NSString*)subjectId{
    
    NSDictionary *data;
    
    if ([@"health" isEqualToString:_fromName]) {//身体记录走势
        
        data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Physical",@"ac",
                              @"2",@"v",
                              @"conditionTendencyChart", @"op",
                              _cId,@"cid",
                              nil];
    }else if ([@"healthBar" isEqualToString:_fromName]){
        /**
         * 身体对比图
         * @author luke
         * @date 2015.11.30
         * @args
         *  v=2, ac=Physical, op=conditionCompareChart, sid=, cid=, uid=
         */
        data = [[NSDictionary alloc] initWithObjectsAndKeys:
                REQ_URL, @"url",
                @"Physical",@"ac",
                @"2",@"v",
                @"conditionCompareChart", @"op",
                _cId,@"cid",
                nil];
        
    }
    else{//成绩走势
        
        data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"GrowingSpace",@"ac",
                              @"2",@"v",
                              @"scoreCharts", @"op",
                              _cId,@"cid",
                              subjectId,@"course",
                              nil];
    }
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            NSLog(@"图表列表:%@",respDic);
            
            _tableView.hidden = NO;
            
            NSMutableArray *array = [respDic objectForKey:@"message"];
            
            if ([array count] >0) {
                
                [noDataView removeFromSuperview];
                listArray = [[NSMutableArray alloc] initWithArray:array copyItems:YES];
                
            }else{
               
                CGRect rect = CGRectMake(0, 49, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - 49);
                noDataView = [Utilities showNodataView:@"暂无相关数据" msg2:@"" andRect:rect];
                [self.view addSubview:noDataView];
                
            }
            
        }else{
            [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
            
        }
        
        
        [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        
    }];
}

-(void)reload{
    
    [_tableView reloadData];
}

#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    /*if ([@"healthBar" isEqualToString:_fromName]) {
        
        static NSString *cellIdentifier = @"TableViewCell";

        TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"TableViewCell" owner:nil options:nil] firstObject];
        }
        
        NSString *yMin;
        NSString *yMax;
        NSDictionary *dataDic = [listArray objectAtIndex:indexPath.row];;
        
            yMax = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"max"]];
        
            cell.bgImgV.image = [UIImage imageNamed:@"ChartLineBg_health.png"];
            cell.lineV.backgroundColor = [UIColor colorWithRed:144.0/255.0 green:232.0/255.0 blue:213.0/255.0 alpha:1];
            yMin = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"min"]];
            
            NSString *title = [dataDic objectForKey:@"title"];
            NSString *unit = [dataDic objectForKey:@"unit"];
            cell.titleLeftLabel.text = title;
            cell.unitLabel.text = unit;
            
            yMin = @"0";
        
        NSMutableArray *xTitles = [[NSMutableArray alloc] init];
        NSMutableArray *pointArrayValue = [[NSMutableArray alloc] init];
        
        NSArray *xDataArray = [dataDic objectForKey:@"data"];
        
        if ([xDataArray count] == 0) {
            cell.noDataLabel.hidden = NO;
        }else{
            cell.noDataLabel.hidden = YES;
        }
        
        for (int i=0; i<[xDataArray count]; i++) {
            
            NSString * str = [NSString stringWithFormat:@"%@",[[xDataArray objectAtIndex:i] objectForKey:@"x"]];
            [xTitles addObject:str];
            
            NSString * value = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[xDataArray objectAtIndex:i] objectForKey:@"y"]]];
            if ([value length] >0) {
                [pointArrayValue addObject:value];
            }
            
        }
        
        cell.yMin = [yMin floatValue];
        cell.yMax = [yMax floatValue];
        cell.xTitles = xTitles;
        cell.pointArrayValue = pointArrayValue;
        
        [cell configUI:indexPath];
        return cell;
        
    }else*/
    {
        static NSString *cellIdentifier = @"ChartListTableViewCell";
        
        ChartListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ChartListTableViewCell" owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSString *yMin;
        NSString *yMax;
        NSDictionary *dataDic = [listArray objectAtIndex:indexPath.row];;
        
        if ([@"health" isEqualToString:_fromName] || [@"healthBar" isEqualToString:_fromName]){//身体记录线形图
            
            if ([@"health" isEqualToString:_fromName]) {
                cell.type = 1;
                yMax = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"max"]];
            }else{
                cell.type = 2;
                yMax = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"max"]];
                
            }
            
            cell.bgImgV.image = [UIImage imageNamed:@"ChartLineBg_health.png"];
            cell.lineV.backgroundColor = [UIColor colorWithRed:144.0/255.0 green:232.0/255.0 blue:213.0/255.0 alpha:1];
            yMin = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"min"]];
            
            NSString *title = [dataDic objectForKey:@"title"];
            NSString *unit = [dataDic objectForKey:@"unit"];
            cell.titleLeftLabel.text = title;
            cell.unitLabel.text = unit;
            
            yMin = @"0";
            
        }else{
            
            NSDictionary *option = [[listArray objectAtIndex:indexPath.row] objectForKey:@"options"];
            cell.titleLabel.text = [option objectForKey:@"title"];
            dataDic = [listArray objectAtIndex:indexPath.row];
            yMin = [[[dataDic objectForKey:@"options"] objectForKey:@"y"] objectForKey:@"min"];
            yMax = [[[dataDic objectForKey:@"options"] objectForKey:@"y"] objectForKey:@"max"];
            
            if (indexPath.row == 0 || indexPath.row == 1) {
                
                yMin = @"0";
            }
            
        }
        
        NSMutableArray *xTitles = [[NSMutableArray alloc] init];
        NSMutableArray *pointArrayValue = [[NSMutableArray alloc] init];
        
        NSArray *xDataArray = [dataDic objectForKey:@"data"];
        
        if ([xDataArray count] == 0) {
            cell.noDataLabel.hidden = NO;
        }else{
            cell.noDataLabel.hidden = YES;
        }
        
        for (int i=0; i<[xDataArray count]; i++) {
            
            NSString * str = [NSString stringWithFormat:@"%@",[[xDataArray objectAtIndex:i] objectForKey:@"x"]];
            [xTitles addObject:str];
            
            NSString * value = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[xDataArray objectAtIndex:i] objectForKey:@"y"]]];
            if ([value length] >0) {
                [pointArrayValue addObject:value];
            }
            
        }
        
        cell.yMin = [yMin floatValue];
        cell.yMax = [yMax floatValue];
        cell.xTitles = xTitles;
        cell.pointArrayValue = pointArrayValue;
        
        [cell configUI:indexPath];
        
        return cell;
        
    }
    
    
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失

}



@end
