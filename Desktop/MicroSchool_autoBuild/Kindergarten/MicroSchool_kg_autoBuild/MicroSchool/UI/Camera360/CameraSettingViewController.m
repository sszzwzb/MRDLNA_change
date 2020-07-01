//
//  CameraSettingViewController.m
//  MicroSchool
//
//  Created by Kate on 2016/10/24.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "CameraSettingViewController.h"
#import "TSPickerView.h"

@interface CameraSettingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CameraSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 屏幕上方灰色条
    UIView *_topDarkGreyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    
    // 灰色背景
    UIImageView *darkGrey = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,_topDarkGreyView.frame.size.width, _topDarkGreyView.frame.size.height)];
    darkGrey.image = [UIImage imageNamed:@"Camera360/camera360_bg_darkGrey.png"];
    [_topDarkGreyView addSubview:darkGrey];
    
    // 返回button
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    leftButton.frame = CGRectMake(0, 25, 33, 33);
    [leftButton setImage:[UIImage imageNamed:@"leftBarButtonItem"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"leftBarButtonItem"] forState:UIControlStateSelected];
    [leftButton addTarget:self action:@selector(selectLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topDarkGreyView addSubview:leftButton];
    
    // 班级摄像头名称
    UILabel *_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(
                                                            10,
                                                            32,
                                                            [UIScreen mainScreen].applicationFrame.size.height,
                                                            20)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleLabel.text = @"管理摄像头";
    [_topDarkGreyView addSubview:_titleLabel];
    
    [self.view addSubview:_topDarkGreyView];

    
//    [self setCustomizeTitle:@"管理摄像头"];
//    [self setCustomizeLeftButton];
    
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [self showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
        [self.view addSubview:noNetworkV];
        return;
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 69.0+15.0)];
    headerView.backgroundColor = [UIColor whiteColor];
    classNameLabel = [[UILabel alloc] init];
    classNameLabel.font = [UIFont systemFontOfSize:16.0];
    classNameLabel.textColor = TS_COLOR_FONT_TITLE_RGB51;
    classNameLabel.text = @"";
    classNameLabel.numberOfLines = 0;
    classNameLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:classNameLabel];
    [classNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(headerView).with.offset(0);
        make.left.equalTo(headerView).with.offset(12.0);
        //因为上一页是强制横屏 这页实际上也是横屏 只不过转了90度 取出的屏幕宽度得反着取
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].height - 12.0*2 - 50.0 -10.0, 69.0));
       
    }];
    
    push = [[UISwitch alloc] init];
    push.on = YES;
    push.onTintColor = [UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1];
    [push addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [headerView addSubview:push];
    [push mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(headerView).with.offset((69.0-30.0)/2.0);
        make.left.equalTo(classNameLabel.mas_right).with.offset(5.0);
        make.size.mas_equalTo(CGSizeMake(50.0, 30.0));
        
    }];
    
    UIView *sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = TS_COLOR_BACKGROUND_GREY_RGB;
    [headerView addSubview:sectionView];
    [sectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(headerView.mas_bottom).with.offset(-15);
        make.left.equalTo(headerView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(headerView.frame.size.width, 15.0));
        
    }];
    
    
    _tableView.tableHeaderView = headerView;
    _tableView.backgroundColor = TS_COLOR_BACKGROUND_GREY_RGB;
    
    //listArray = [[NSMutableArray alloc] init];
    //    NSDictionary *cellDic0 = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"check",@"星期一",@"date",@"9:00-17:00",@"time",@"9:00",@"start",@"17:00",@"end", nil];
    //    NSDictionary *cellDic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"check",@"星期二",@"date",@"9:00-17:00",@"time", @"9:00",@"start",@"17:00",@"end",nil];
    //    NSDictionary *cellDic2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"check",@"星期三",@"date",@"9:00-17:00",@"time", @"9:00",@"start",@"17:00",@"end",nil];
    //    NSDictionary *cellDic3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"check",@"星期四",@"date",@"9:00-17:00",@"time", @"9:00",@"start",@"17:00",@"end",nil];
    //    NSDictionary *cellDic4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"check",@"星期五",@"date",@"9:00-17:00",@"time", @"9:00",@"start",@"17:00",@"end",nil];
    //    NSDictionary *cellDic5 = [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"check",@"星期六",@"date",@"9:00-17:00",@"time", @"9:00",@"start",@"17:00",@"end",nil];
    //    NSDictionary *cellDic6 = [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"check",@"星期日",@"date",@"9:00-17:00",@"time", @"9:00",@"start",@"17:00",@"end",nil];
    //    [listArray addObject:cellDic0];
    //    [listArray addObject:cellDic1];
    //    [listArray addObject:cellDic2];
    //    [listArray addObject:cellDic3];
    //    [listArray addObject:cellDic4];
    //    [listArray addObject:cellDic5];
    //    [listArray addObject:cellDic6];
    
    sectionCount = 1;
    
    _tableView.hidden = YES;
    [self getData];
    
}

//支持旋转
-(BOOL)shouldAutorotate{
    return NO;
}
//
//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

//一开始的方向  很重要
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView*)showNoNetworkView:(NSString*)msg msg2:(NSString*)msg2 andRect:(CGRect)rect{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64.0, rect.size.height, rect.size.width)];
    view.backgroundColor = [UIColor whiteColor];
    float start = (rect.size.width - 110.0)/3.0;
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake((rect.size.height- 110.0)/2.0, start, 110.0, 110.0)];
    imgV.image = [UIImage imageNamed:@"icon_noNetworkImg.png"];
    [view addSubview:imgV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imgV.frame.origin.y+imgV.frame.size.height+5, rect.size.height, 20)];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = msg;
    label.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    label.font = [UIFont systemFontOfSize:15.0];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, label.frame.origin.y+label.frame.size.height, rect.size.height, 20)];
    label2.numberOfLines = 2;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = msg2;
    label2.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    label2.font = [UIFont systemFontOfSize:15.0];
    
    [view addSubview:label];
    [view addSubview:label2];
    
    return view;
}

-(void)selectLeftAction:(id)sender{
    
    [self submit];
    [self dismissViewControllerAnimated:YES completion:nil];

//    [self.navigationController popViewControllerAnimated:YES];
}

-(void)reloadTableView{
    
    [_tableView reloadData];
}

-(void)getData{
    
    /**
     * 摄像头详情
     *  weekdate: 0 (for Sunday) through 6 (for Saturday)
     * @author luke
     * @date 2016.10.24
     * @args
     *  v=3 ac=Camera op=view sid= uid= cid= camera=
     *
     */
    [Utilities showProcessingHud:self.view];
    //_cameraId = @"1";//测试代码
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Camera",@"ac",
                          @"3",@"v",
                          @"view", @"op",
                          _cId,@"cid",
                          _cameraId,@"camera",
                          nil];
    
    NSLog(@"data:%@",data);
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        NSLog(@"respDic:%@",respDic);
        
        [Utilities dismissProcessingHud:self.view];
        
        if ([result integerValue] == 1){
            
            _tableView.hidden = NO;
            NSDictionary *dic = [respDic objectForKey:@"message"];
            listArray = [[NSMutableArray alloc]initWithArray:[dic objectForKey:@"settings"] copyItems:YES];
            classNameLabel.text = [dic objectForKey:@"title"];
            
            NSInteger status = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]] integerValue];
            if (status == 1) {
                push.on = YES;
            }else{
                push.on = NO;
            }
            
            [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
            
        }else{
            
            [Utilities showFailedHud:[NSString stringWithFormat:@"%@",[respDic objectForKey:@"message"]] descView:self.view];
            
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        
    }];
    
}

-(void)submit{
    
    /**
     * 更新摄像头信息
     * @author luke
     * @date 2016 .10.26
     * @args
     *  v=3 ac=Camera op=update sid= cid= uid= camera=摄像头ID status=状态(开关: 0关闭 1打开) settings=weekday,status,start_time,end_time;...
     *  weekday 0 (for Sunday) through 6 (for Saturday)
     */
    
    //[Utilities showProcessingHud:self.view];
    //_cameraId = @"1";//测试代码
    NSString *status = @"0";
    if (push.isOn) {
        status = @"1";
    }
    
    if ([listArray count] == 0 && [tempArray count] > 0) {
        
        for (int i=0; i<[tempArray count]; i++) {
            
            [listArray addObject:[tempArray objectAtIndex:i]];
            
        }
    }
    
    NSString *settings = @"";
    for (int i=0; i<[listArray count]; i++) {
        
        NSDictionary *dic = [listArray objectAtIndex:i];
        NSString *weekday = [dic objectForKey:@"weekdate"];
        NSString *status = [dic objectForKey:@"status"];
        NSString *start_time = [dic objectForKey:@"start_time"];
        NSString *end_time = [dic objectForKey:@"end_time"];
        
        NSString *item = [NSString stringWithFormat:@"%@,%@,%@,%@",weekday,status,start_time,end_time];
    
        if (i == 0) {
           
            settings = item;
            
        }else{
            
            settings = [NSString stringWithFormat:@"%@;%@",settings,item];
        }
        
    }
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Camera",@"ac",
                          @"3",@"v",
                          @"update", @"op",
                          _cId,@"cid",
                          _cameraId,@"camera",
                          status,@"status",
                          settings,@"settings",
                          nil];
    
    NSLog(@"data:%@",data);
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        NSLog(@"respDic:%@",respDic);
        
        //[Utilities dismissProcessingHud:self.view];
        
        if ([result integerValue] == 1){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refleshCameraListInfo" object:nil];
            
        }else{
            
            //[Utilities showFailedHud:[NSString stringWithFormat:@"%@",[respDic objectForKey:@"message"]] descView:self.view];
            
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        
    }];
    
    
}

-(void)switchAction:(id)sender{
    
    //push.on = !push.isOn;
    
    if (!push.isOn) {//关
        
        if ([listArray count] > 0) {
            
            tempArray = [[NSMutableArray alloc] initWithArray:listArray copyItems:YES];
            
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            for (int i=0; i<[listArray count]; i++) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPaths addObject: indexPath];
                
            }
            
            [listArray removeAllObjects];
            [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            
            
        }
        
    }else{//开
        
        if ([listArray count] > 0) {
            
             [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
            
        }else{
            
            [listArray addObjectsFromArray:tempArray];
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            for (int i=0; i<[listArray count]; i++) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPaths addObject: indexPath];
                
            }
            
            [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
       
        }
    }
    
    
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
    
    static NSString *GroupedTableIdentifier = @"CameraSetTableViewCell";
    CameraSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    if(cell == nil) {
        
        UINib *nib = [UINib nibWithNibName:@"CameraSetTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:GroupedTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.delegate = self;
    cell.index = indexPath.row;
    NSDictionary *dic = [listArray objectAtIndex:indexPath.row];
    NSString *checked = [dic objectForKey:@"status"];
    
    NSString *weekday = [self getWeek:[NSString stringWithFormat:@"%@",[dic objectForKey:@"weekdate"]]];
    NSString *time = [NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"start_time"],[dic objectForKey:@"end_time"]];
    
    cell.titleLabel.text = weekday;
    cell.timeLabel.text = time;
    
    if ([checked integerValue] == 1)
    {
        [cell.checkBtn setImage:[UIImage imageNamed:@"checkImg_press.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        [cell.checkBtn setImage:[UIImage imageNamed:@"rb_gander_d_01.png"] forState:UIControlStateNormal];
        
    }
    
    if (push.isOn) {
        cell.hidden = NO;
    }else{
        cell.hidden = YES;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (push.isOn) {
        
        NSDictionary *dic = [listArray objectAtIndex:indexPath.row];
        
        NSString *startTime = [dic objectForKey:@"start_time"];
        NSString *endTime = [dic objectForKey:@"end_time"];
        
        NSArray *startSplitResult = [startTime componentsSeparatedByString:@":"];
        NSArray *endSplitResult = [endTime componentsSeparatedByString:@":"];

        
        NSMutableArray *rowArray = [[NSMutableArray alloc] init];
        [rowArray addObject:[startSplitResult objectAtIndex:0]];
        [rowArray addObject:[startSplitResult objectAtIndex:1]];
        [rowArray addObject:[endSplitResult objectAtIndex:0]];
        [rowArray addObject:[endSplitResult objectAtIndex:1]];
        
        TSPickerView *pickerView = [[TSPickerView alloc] initWithpickerViewWithCenterTitle:@"" andCancel:@"取消" andSure:@"确定" rowArray:rowArray];
        
        [pickerView pickerVIewClickCancelBtnBlock:^{
            
            NSLog(@"取消");
            
        } sureBtClcik:^(NSString *leftString,NSString *leftString2,NSString *rightString,NSString *rightString2) {
            
            CameraSetTableViewCell *cstcell = [tableView cellForRowAtIndexPath:indexPath];
            
            NSString *startStr = [NSString stringWithFormat:@"%@:%@",leftString,leftString2];
            NSString *endStr = [NSString stringWithFormat:@"%@:%@",rightString,rightString2];
            NSString *timeStr = [NSString stringWithFormat:@"%@-%@",startStr,endStr];
            
            cstcell.timeLabel.text = timeStr;
            
            NSDictionary *newDic = [[NSDictionary alloc] initWithObjectsAndKeys:[dic objectForKey:@"status"],@"status",[dic objectForKey:@"weekdate"],@"weekdate",startStr,@"start_time",endStr,@"end_time",nil];
            [listArray replaceObjectAtIndex:indexPath.row withObject:newDic];
            
        }];
        
    }else{
        
        [Utilities showTextHud:@"摄像头未开启" descView:tableView];
    }
    
}

// 点击左侧选择框
-(void)clickCheck:(NSInteger)checked row:(NSInteger)index{
    
    NSDictionary *dic = [listArray objectAtIndex:index];
    
    NSString *check = [NSString stringWithFormat:@"%ld",(long)checked];
    NSDictionary *newDic = [[NSDictionary alloc] initWithObjectsAndKeys:check,@"status",[dic objectForKey:@"weekdate"],@"weekdate",[dic objectForKey:@"start_time"],@"start_time",[dic objectForKey:@"end_time"],@"end_time",nil];
    [listArray replaceObjectAtIndex:index withObject:newDic];
    
}

-(NSString*)getWeek:(NSString*)num{
    
    NSString *weekStr = @"";
    switch ([num integerValue]) {
        case 7:
            weekStr = @"星期日";
            break;
        case 1:
            weekStr = @"星期一";
            break;
        case 2:
            weekStr = @"星期二";
            break;
        case 3:
            weekStr = @"星期三";
            break;
        case 4:
            weekStr = @"星期四";
            break;
        case 5:
            weekStr = @"星期五";
            break;
        case 6:
            weekStr = @"星期六";
            break;
            
        default:
            break;
    }
    
    return weekStr;
}







@end
