//
//  OnlyEditPerViewController.m
//  MicroApp
//
//  Created by kaiyi on 2018/10/8.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "OnlyEditPerViewController.h"

#import "OnlyEditPerTableViewCell.h"
#import "OnlyEditPerButDownView.h"
#import "OnlyEditPerSQLModel.h"


#import "OnlyEditToEditViewController.h"
#import "OnlyEditCompleteDetailViewController.h"
#import "OnlyEditPerToReEditViewController.h"


static NSString * showOnlyEditPerTableViewCell = @"cell";

@interface OnlyEditPerViewController () <UITableViewDelegate,UITableViewDataSource,OnlyEditPerButDownViewDelegate,OnlyEditPerTableViewCellDelegate,HttpReqCallbackDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) OnlyEditPerSQLModel *upLoad_model;  //  当前上传的model

@end

@implementation OnlyEditPerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // Custom initialization
    network = [AFNNetworkUtility alloc];
    network.delegate = self;
    
    
    _dataArr = [NSMutableArray array];
    _upLoad_model = [OnlyEditPerSQLModel new];
    
    
    [self up_tableView];
    
    
    _page = 0;
    [self up_data];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewData) name:@"OnlyEditPerViewController_reloadData" object:nil];
    
    [self MJRefreshNormal];
    
}

#pragma mark -
#pragma mark UITableViewDelegate
-(void)up_tableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 49 - KScreenTabBarIndicatorHeight - KScreenNavigationBarHeight) style:(UITableViewStyleGrouped)];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_tableView];
    
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
    }
    
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    
    [_tableView registerClass:[OnlyEditPerTableViewCell class] forCellReuseIdentifier: showOnlyEditPerTableViewCell];
    
    
    
    if ([self.title isEqualToString:@"工作任务"]) {
        _tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 49 - KScreenTabBarHeight - KScreenNavigationBarHeight - 49);
        
        OnlyEditPerButDownView *but = [[OnlyEditPerButDownView alloc]initWithFrame:
                                       CGRectMake(0, KScreenHeight - KScreenTabBarHeight - 49 - 49 - KScreenNavigationBarHeight, KScreenWidth, 49)];
        but.typeInt = 0;
        [self.view addSubview:but];
        but.delegate = self;
    } else {
        _tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 49 - KScreenTabBarHeight - KScreenNavigationBarHeight);
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [OnlyEditPerTableViewCell cellheight];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewnil = [UIView new];
    viewnil.hidden = YES;
    return viewnil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *viewnil = [UIView new];
    viewnil.hidden = YES;
    return viewnil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OnlyEditPerTableViewCell *cell = (OnlyEditPerTableViewCell *)[tableView dequeueReusableCellWithIdentifier: showOnlyEditPerTableViewCell forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    if ([_dataArr count] > 0) {
        cell.type = _type;
        cell.model = _dataArr[indexPath.section];
        [cell reloadData];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ///  取消按键效果  按中后会返回成没有安过的效果
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSLog(@"我点击了  %ld   %ld",(long)indexPath.section,(long)indexPath.row);
    
   if ([_type isEqualToString:@"2"]) {
       NSLog(@"已完成，查看详情");
       
       OnlyEditCompleteDetailViewController *vc = [[OnlyEditCompleteDetailViewController alloc]init];
       vc.model = _dataArr[indexPath.section];
       vc.hidesBottomBarWhenPushed = YES;
       [self.navigationController pushViewController:vc animated:YES];
   }
}

#pragma mark - OnlyEditPerTableViewCellDelegate
-(void)selectCellButtonWithType:(NSString *)type didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OnlyEditPerSQLModel *model = _dataArr[indexPath.section];
    
    
    if ([_type isEqualToString:@"0"]) {
        
        OnlyEditToEditViewController *vc = [[OnlyEditToEditViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.type = isCanEdit;
        vc.selectModel = model;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([_type isEqualToString:@"1"]) {
        
        NSLog(@"上传");
        _upLoad_model = model;
        [self upload_dataWithModel:model];
    } else if ([_type isEqualToString:@"2"]) {
        NSLog(@"修改");
        OnlyEditPerToReEditViewController *vc = [[OnlyEditPerToReEditViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.selectModel = model;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

#pragma mark - OnlyEditPerButDownViewDelegate
-(void)selectButDownViewWithTag:(NSInteger)tag
{
    NSLog(@"新建");
    
    OnlyEditToEditViewController *vc = [[OnlyEditToEditViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.type = isNewEdit;
    [self.navigationController pushViewController:vc animated:YES];
}








#pragma mark - up_data
-(void)up_data
{
    if ([_type intValue] == 0 || [_type intValue] == 1) {
        [self up_data_DB];
    } else {
        
        //  上传成功接口
        [self up_dataForComplete];
        
    }
}


-(void)up_data_DB
{
    //  本地数据
    
    //   用ID查询
    [[OnlyEditPerSQLModel shareDB] executeData];
    
    
    NSLog(@"%@",[[OnlyEditPerSQLModel shareDB] executeDataForPage:_page saveState:_type]);
    
    
    NSArray *dataTestArr = [[OnlyEditPerSQLModel shareDB] executeDataForPage:_page saveState:_type];
    
    NSLog(@"一次显示的本地数据 = %@",dataTestArr);
    
    for (OnlyEditPerSQLModel *model in dataTestArr) {
        [_dataArr addObject:model];
    }
    
    
    [_tableView reloadData];
    
    
    [Utilities showNoListView:@"" msg2:@"" descView:_tableView isShow:([_dataArr count] == 0 ? YES : NO)];
    
    [self closeRefreshAll];
}



-(void)up_dataForComplete
{
    //  上传成功列表
    /**
     http://app.meridianjet.vip/login.svc/GetOrderFinList?UserName=zhangkaiyi&app=1.0.0&app_way=1&app_code=1&appId=1&OrderID=21012 外采上传
     */
    
    if (_page == 0) {
        [Utilities showProcessingHud:self.view];
    }
    
    NSDictionary *data = @{
                           @"url":REQ_URL,
                           @"url_stringByAppendingString":@"login.svc/GetOrderFinList",
                           
                           @"username":[UtilitiesData getLoginUserName],
                           @"num":[NSString stringWithFormat:@"%ld",_page],
                           @"Count":@"10"
                           };
    
    [network sendHttpReq:HttpReq_GetOrderFinList andData:data];
    
}


#pragma mark - 加载  2017.10.19  kaiyi
-(void) MJRefreshNormal
{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个getData）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getNewData];
    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.mj_header = header;
    
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreMessage)];
    
    // 设置了底部inset
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 忽略掉底部inset
    _tableView.mj_footer.ignoredScrollViewContentInsetBottom = 0;
    // 如果没有数据的时候，没有上拉加载
    _tableView.mj_footer.automaticallyHidden = YES;
    
    [self reRefreshFooterHidden];
    
    _tableView.mj_footer.hidden = _tableView.contentSize.height <= CGRectGetHeight(_tableView.mj_footer.scrollView.frame) ? YES : NO;
    
}

#pragma mark - 2017.10.17   数据不足一页的时候，不显示上拉加载
-(void)reRefreshFooterHidden
{
    [_tableView.mj_footer.scrollView setMj_reloadDataBlock:^(NSInteger totalDataCount)
     {
         [_tableView layoutIfNeeded];
         
         _tableView.mj_footer.hidden = _tableView.contentSize.height <= CGRectGetHeight(_tableView.mj_footer.scrollView.frame) ? YES : NO;
     }];
}

-(void)closeRefreshAll
{
    //  不知道为什么那么多结束加载，目前解决办法，全部取消，不做处理。
    //  UI 暂时不优化，等有人提交bug在做处理  2017.10.19
    [_tableView.mj_header endRefreshing];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [_tableView.mj_footer endRefreshing];
        
    });
    
    [self reRefreshFooterHidden];
}

-(void)getNewData
{
    [_dataArr removeAllObjects];
    _page = 0;
    [self up_data];
}

-(void)getMoreMessage
{
    _page++;
    [self up_data];
}




-(void)upload_dataWithModel:(OnlyEditPerSQLModel *)model
{
    
    /**
     
     上传数据
     http://app.meridianjet.vip/FileUpload.ashx
     
     上传参数：
     app  移动端应用版本号（每个接口都传）    1.0.0
     appId   区分移动端应用名称（每个接口都传）    香港子午线：0    子午线上传数据：1
     
     */
    
    [Utilities showProcessingHud:self.view];
    
    
    NSMutableArray *imgTextArrAll = [NSMutableArray array];
    
    NSDictionary *dicText0 = [Utilities JsonStrtoArrayOrNSDictionary:model.imgsTextDic0];
    NSDictionary *dicText1 = [Utilities JsonStrtoArrayOrNSDictionary:model.imgsTextDic1];
    NSDictionary *dicText2 = [Utilities JsonStrtoArrayOrNSDictionary:model.imgsTextDic2];
    
    
    for (NSString *key in [dicText0 allKeys]) {
        [imgTextArrAll addObject:@{
                                 @"FileKey":key,
                                 @"FileValue":dicText0[key]
                                 }];
    }
    for (NSString *key in [dicText1 allKeys]) {
        [imgTextArrAll addObject:@{
                                 @"FileKey":key,
                                 @"FileValue":dicText1[key]
                                 }];
    }
    for (NSString *key in [dicText2 allKeys]) {
        [imgTextArrAll addObject:@{
                                 @"FileKey":key,
                                 @"FileValue":dicText2[key]
                                 }];
    }
    
    
    NSString *Remark = [Utilities objectToJsonWithObject:imgTextArrAll];
    
    
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //指定新建文件夹路径
    NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"OnlyEditToEditViewController/"];
    
    NSDictionary *ImgDic0 = [Utilities JsonStrtoArrayOrNSDictionary:model.imgsDic0PathName];
    NSDictionary *ImgDic1 = [Utilities JsonStrtoArrayOrNSDictionary:model.imgsDic1PathName];
    NSDictionary *ImgDic2 = [Utilities JsonStrtoArrayOrNSDictionary:model.imgsDic2PathName];
    
    NSMutableArray *ImgsArr0 = [NSMutableArray array];
    NSMutableArray *ImgsArr1 = [NSMutableArray array];
    NSMutableArray *ImgsArr2 = [NSMutableArray array];
    
    if ([ImgDic0 count] > 0) {
        for (int i = 0; i < [ImgDic0 count]; i++) {
            [ImgsArr0 addObject:[NSString stringWithFormat:@"%@/%@",imageDocPath , ImgDic0[[NSString stringWithFormat:@"%d",i]]]];
        }
    }
    if ([ImgDic1 count] > 0) {
        for (int i = 0; i < [ImgDic1 count]; i++) {
            [ImgsArr1 addObject:[NSString stringWithFormat:@"%@/%@",imageDocPath , ImgDic1[[NSString stringWithFormat:@"%d",i]]]];
        }
    }
    if ([ImgDic2 count] > 0) {
        for (int i = 0; i < [ImgDic2 count]; i++) {
            [ImgsArr2 addObject:[NSString stringWithFormat:@"%@/%@",imageDocPath , ImgDic2[[NSString stringWithFormat:@"%d",i]]]];
        }
    }
    
    NSDictionary *data = @{
                           @"url":REQ_URL,
                           @"url_stringByAppendingString":@"FileUpload.ashx",
                           
                           @"orderID":model.selectAirPlaneTypeInfoId,
                           @"Remark":Remark,
                           @"UserName":[UtilitiesData getLoginUserName],
                           
                           @"imgsArr0":ImgsArr0,
                           @"imgsArr1":ImgsArr1,
                           @"imgsArr2":ImgsArr2,
                           @"PicType":@"png",
                           
                           @"UpLoadType":@"0"    //   0是新增  1是修改
                           };
    
    [network sendHttpReq:HttpReq_FileUpload_ashx andData:data];
}


#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(id)data andType:(HttpReqType)type
{
    NSDictionary *resultJSON = data;
    
    NSLog(@"OnlyEditPerViewController  HttpReqType  %d\n  Data    %@",type,resultJSON);
    
    //   飞机发布
    if (type == HttpReq_FileUpload_ashx) {
        
        [Utilities dismissProcessingHud:self.view];
        
        if ([resultJSON[@"Result"] boolValue]) {
            
            [OnlyEditPerSQLModel upDataWithselectDateStr:@""
                                      selectAirPlaneType:@""
                    selectDateForSection0Model_orderName:@""
                 selectDateForSection0Model_airplaneType:@""
                selectDateForSection0Model_departureDate:@""
                selectDateForSection0Model_selectForCell:@""
                             dataArrForSection0ToJsonStr:@""
                                        imgsDic0PathName:@""
                                        imgsDic1PathName:@""
                                        imgsDic2PathName:@""
                                            imgsTextDic0:@""
                                            imgsTextDic1:@""
                                            imgsTextDic2:@""
                                               saveState:@"2"   //  2 为成功状态
                                selectAirPlaneTypeInfoId:@""
                                              primaryKey:_upLoad_model.pk];
            
            [self getNewData];
           
            [Utilities showTextHud:[resultJSON objectForKey:@"Message"] descView:self.view];
            
        } else {
            [Utilities showTextHud:[resultJSON objectForKey:@"Message"] descView:self.view];
        }
        
    }
    
    
    
    //   起飞凭证中的完成列表
    if (type == HttpReq_GetOrderFinList) {
        
        [Utilities dismissProcessingHud:self.view];
        
        if ([resultJSON[@"Result"] boolValue]) {
            
            NSString *MessageStr = [Utilities replaceNull:resultJSON[@"Message"]];
            NSArray *MessageArr = [Utilities replaceArrNull:[Utilities JsonStrtoArrayOrNSDictionary:MessageStr]];
            
            if (_page == 0) {
                [_dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in MessageArr) {
                OnlyEditPerSQLModel *model = [OnlyEditPerSQLModel new];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArr addObject:model];
            }
            
            [_tableView reloadData];
            
            //  没有数据显示
            [Utilities showNoListView:@"" msg2:@"" descView:_tableView isShow:([_dataArr count] == 0 ? YES : NO)];
            
            [self closeRefreshAll];
            
        } else {
            [self closeRefreshAll];
            
            [Utilities showNoListView:@"" msg2:@"" descView:_tableView isShow:([_dataArr count] == 0 ? YES : NO)];
            
            [Utilities showTextHud:[resultJSON objectForKey:@"Message"] descView:self.view];
        }
        
    }
    
}

-(void)reciveHttpDataError:(NSError*)err
{
    [Utilities dismissProcessingHud:self.view];
    {
        [self closeRefreshAll];
        
//        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
//        [self.view addSubview:noNetworkV];
        [Utilities showTextHud:TEXT_NONETWORK descView:self.view];
    }
}




@end
