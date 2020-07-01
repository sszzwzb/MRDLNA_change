//
//  OutsideReimbursementViewController.m
//  MicroApp
//
//  Created by kaiyi on 2018/10/13.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "OutsideReimbursementEditViewController.h"

#import "OutsideReimbursementEditTableViewCell.h"
#import "OnlyEditToEditTableHeaderView.h"
#import "OnlyEditPerSQLModel.h"

#import "AddImagesTool.h"
#import "AddImageUtilities.h"

#import "OnlyEditPerButDownView.h"



static NSString *HeaderIdentifier = @"header";
static NSString * showOutsideReimbursementEditTableViewCell = @"cell";

@interface OutsideReimbursementEditViewController () <UITableViewDelegate,UITableViewDataSource,OnlyEditToEditTableHeaderViewDelegate,HttpReqCallbackDelegate,OutsideReimbursementEditTableViewCellDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArrForSection0;  //   飞机航次数据
@property (nonatomic,strong) NSString *dataArrForSection0ToJsonStr;  //  本地数据保存 数组，json 格式
@property (nonatomic,strong) NSMutableArray *dataArrForPlaneType;  //   飞机机型


@property (nonatomic,strong) NSString *selectDateStr;  //  选择好的时间
@property (nonatomic,strong) NSString *selectAirPlaneType;  //  选择好的飞机类型
@property (nonatomic,strong) NSString *selectAirPlaneTypeInfoID;

@property (nonatomic,strong) OnlyEditPerSQLModel *selectDateForSection0Model;  //  选择好的航次


@property (nonatomic,strong) AddImagesTool *imgTool0;

@property (nonatomic,strong) NSMutableDictionary *imgsDic0;

@property (nonatomic,strong) NSMutableDictionary *imgsDic0PathName;   //  没有具体位置的图片名称

@property (nonatomic,strong) NSMutableDictionary *imgsTextDic0;   //   上传的图片名称为 key


@property (nonatomic,strong) NSString *content;  //  备注
@property (nonatomic,strong) NSString *focus;  //  价格，油量

@end

@implementation OutsideReimbursementEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_type == 0) {
        [self setCustomizeTitle:@"新建外采报销"];
        _type = 0;
    } else if (_type == 1) {
        [self setCustomizeTitle:@"新建剩余油量"];
        _type = 1;
    }
    [self setCustomizeLeftButton];
    
    [self setCustomizeRightButtonWithName:@"提交" color:[UIColor whiteColor]];
    
    
    
    // Custom initialization
    network = [AFNNetworkUtility alloc];
    network.delegate = self;
    
    
    _dataArrForSection0 = [NSMutableArray array];
    _dataArrForSection0ToJsonStr = [NSString string];
    _dataArrForPlaneType = [NSMutableArray array];
    _selectDateStr = [NSString string];
    _selectAirPlaneType = [NSString string];
    _selectAirPlaneTypeInfoID = [NSString string];
    _selectDateForSection0Model = [OnlyEditPerSQLModel new];
    _imgsDic0 = [NSMutableDictionary dictionary];
    _imgsDic0PathName = [NSMutableDictionary dictionary];
    _imgsTextDic0 = [NSMutableDictionary dictionary];
    _content = [NSString string];
    _focus = [NSString string];
    
    
    
    [self up_tableView];
    
    
    //  飞机机型
    [self up_dataForPlaneType];
    
    
    CGFloat imgWidth = (KScreenWidth-90 - 20)/3;
    
    
    NSInteger mostImgCount = 9;
    if (_type == 0) {
        mostImgCount = 16;
    } else if (_type == 1) {
        mostImgCount = 9;
    }
    
    _imgTool0 = [[AddImagesTool alloc] initWithFrame:CGRectMake(13, 30 + 6, [UIScreen mainScreen].bounds.size.width, imgWidth)];
    _imgTool0.tag = 1060;
    [_imgTool0 drawAddImagesTool:nil withViewController:self mostImgCount:mostImgCount];
    _imgTool0.backgroundColor = [UIColor whiteColor];
    
   
    
    
    
}

-(void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)selectRightAction:(id)sender
{
    NSLog(@"上传");
    [self dismissAllKeyBoardInView:self.view];  //  去掉键盘
    
    NSString *msgStr = [NSString string];
    if (_type == 0) {
        msgStr = @"输入报销价格";
    } else {
        msgStr = @"输入剩余油量";
    }
    
    
    if ([[Utilities replaceNull:_selectDateStr] isEqualToString:@""]) {
        [Utilities showTextHud:@"请选择日期" descView:self.view];
    } else if ([[Utilities replaceNull:_selectDateForSection0Model.orderName] isEqualToString:@""]) {
        [Utilities showTextHud:@"请选择航班" descView:self.view];
    } else if ([[Utilities replaceNull:_focus] isEqualToString:@""]) {
        [Utilities showTextHud:msgStr descView:self.view];
    } else {
        [self upLoadToData];
    }
}

-(void)upLoadToData
{
    NSLog(@"保存的数据 \n \n  %@  %@",_selectDateStr , _selectAirPlaneType);
    
    _selectDateForSection0Model.selectForCell = @"YES";
    NSLog(@"保存的数据 \n \n  %@  %@  %@  %@",_selectDateForSection0Model.orderName , _selectDateForSection0Model.airplaneType , _selectDateForSection0Model.departureDate , _selectDateForSection0Model.selectForCell);
    
    NSLog(@"保存的数据 \n \n  %@ ",_dataArrForSection0ToJsonStr);
    
    
    [_imgsDic0 removeAllObjects];
    [_imgsDic0PathName removeAllObjects];
    [_imgsTextDic0 removeAllObjects];
    
    [self saveButtonImageToFileWith:_imgTool0];
    
    
    
    NSLog(@"保存的数据三组图片 \n \n  %@ \n %@ \n",_imgsDic0 , _imgsTextDic0);
    
    if (_type == 0) {
        [self uplaod_dataForOutsideReimbursement];
    } else
    {
        [self uplaod_dataForOil];
    }
}


#pragma mark -
#pragma mark 多图片上传第一步，把图片保存在本地   时间戳 和 imgTool.tag  区分
-(void)saveButtonImageToFileWith:(AddImagesTool *)imgTool{
    
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //指定新建文件夹路径
    NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"OutsideReimbursementEditViewController"];//@"PublishPerViewController"
    //创建ImageFile文件夹
    [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    if(imgTool.buttonArray.count > 1){
        
        UIImage *image = nil;
        
        for (int i=0; i<[imgTool.assetsAndImgs count]; i++) {
            
            NSString *imgPath = [imageDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image%d.png",(i+1)]];
            
            if ([[imgTool.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
                
                ALAsset *asset = [imgTool.assetsAndImgs objectAtIndex:i];// update 2015.04.13
                //获取资源图片的详细资源信息
                ALAssetRepresentation* representation = [asset defaultRepresentation];
                //获取资源图片的高清图
                //[representation fullResolutionImage];
                //获取资源图片的全屏图
                //[representation fullScreenImage];
                
                image = [UIImage imageWithCGImage:[representation fullScreenImage]];
                
            }else{
                image = [imgTool.assetsAndImgs objectAtIndex:i];
                UIImage *tempImage = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:image.imageOrientation];
                image = [AddImageUtilities fixOrientation:tempImage];
                
            }
            
            UIImage *scaledImage;
            UIImage *updateImage;
            
            // 如果宽度超过480，则按照比例进行缩放，把宽度固定在480
            if (image.size.width >= 480) {
                float scaleRate = 480/image.size.width;
                
                float w = 480;
                float h = image.size.height * scaleRate;
                
                scaledImage = [AddImageUtilities imageWithImageSimple:image scaledToSize:CGSizeMake(w, h)];
            }
            
            if (scaledImage != Nil) {
                updateImage = scaledImage;
            } else {
                updateImage = image;
            }
            
            NSData *data;
            data = UIImageJPEGRepresentation(image, 0.5);
            
            UIImage *img = [UIImage imageWithData:data];
            
            [[NSFileManager defaultManager] createFileAtPath:imgPath contents:[self imageToNsdata:img] attributes:nil];
            
            [_imgsDic0 setValue:imgPath forKey:[NSString stringWithFormat:@"%d",i]];
        }
    }
}

-(NSData *)imageToNsdata:(UIImage*)img
{
    //以下是保存文件到沙盒路径下
    //把图片转成NSData类型的数据来保存文件
    NSData *data;
    
    return data = UIImageJPEGRepresentation(img, 0.3);
    
}


#pragma mark -
#pragma mark UITableViewDelegate
-(void)up_tableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KScreenTabBarIndicatorHeight - KScreenNavigationBarHeight ) style:(UITableViewStyleGrouped)];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_tableView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
    }
    
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    
    [_tableView registerClass:[OutsideReimbursementEditTableViewCell class] forCellReuseIdentifier: showOutsideReimbursementEditTableViewCell];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [OutsideReimbursementEditTableViewCell cellHeithWithIndexPath:indexPath imgToolHeight:_imgTool0.frame.size.height + 12 + 30];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (section == 0)?[OnlyEditToEditTableHeaderView haederHeight] : 0.01;;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [_dataArrForSection0 count];
    }
    return 3;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    OnlyEditToEditTableHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier: HeaderIdentifier];
    if (headerView == nil) {
        headerView = [[OnlyEditToEditTableHeaderView alloc] initWithReuseIdentifier:HeaderIdentifier];
    }
    headerView.delegate = self;
    headerView.hidden = (section == 0)?NO : YES;
    headerView.curTableView = _tableView;
    
    headerView.dataArr = [_dataArrForPlaneType count] > 0 ? _dataArrForPlaneType : @[];
    headerView.selectDateStr = _selectDateStr;
    headerView.selectAirPlaneType = _selectAirPlaneType;
    [headerView reloadData];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *viewnil = [UIView new];
    viewnil.hidden = YES;
    return viewnil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OutsideReimbursementEditTableViewCell *cell = (OutsideReimbursementEditTableViewCell *)[tableView dequeueReusableCellWithIdentifier: showOutsideReimbursementEditTableViewCell forIndexPath:indexPath];
    
    if ([_dataArrForSection0 count] > 0 && indexPath.section == 0) {
        cell.model = _dataArrForSection0[indexPath.row];
    }
    
    cell.delegate = self;
    
    cell.indexPath = indexPath;
    [cell reloadDataWithType:_type];
    
    if (![cell viewWithTag:1060] && indexPath.row == 2 && indexPath.section == 1) {
        [cell addSubview:_imgTool0];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ///  取消按键效果  按中后会返回成没有安过的效果
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSLog(@"我点击了  %ld   %ld",(long)indexPath.section,(long)indexPath.row);
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - OnlyEditToEditTableHeaderViewDelegate
//  选择日期
-(void)selectHeaderDate:(NSString *)date
{
    NSLog(@"选择好的日期 = %@",date);
    _selectDateStr = date;
    [self up_dataForGetOrderList];
}

//  选择机型
-(void)selectHeaderType:(NSString *)type InfoId:(NSString *)indoId
{
    NSLog(@"选择好的机型 = %@", type);
    _selectAirPlaneType = type;
    _selectAirPlaneTypeInfoID = indoId;
    [self up_dataForGetOrderList];
}


#pragma mark - OnlyEditToEditTableViewCellDelegate
-(void)selectCellForSection0WithModel:(OnlyEditPerSQLModel *)model row:(NSInteger)row
{
    _selectDateForSection0Model = model;
    
    for (OnlyEditPerSQLModel *modelTest in _dataArrForSection0) {
        if ([modelTest.selectForCell isEqualToString:@"userInteractionEnabled_NO"]) {
            modelTest.selectForCell = @"userInteractionEnabled_NO";
        } else {
            modelTest.selectForCell = @"NO";
        }
    }
    OnlyEditPerSQLModel *modelTest = _dataArrForSection0[row];
    modelTest.selectForCell = @"YES";
    
    
    //  指定刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

-(void)TextOutWithDic:(NSDictionary *)textdic
{
    if ([textdic[@"type"] isEqualToString:@"textField"]) {
        _focus = textdic[@"text"];
    }
    
    if ([textdic[@"type"] isEqualToString:@"textView"]) {
        _content = textdic[@"text"];
    }
}


#pragma mark - 图片调用
-(void)updateSize:(UIView*)view{
    
    if (view == _imgTool0) {
        
        //刷新单行数据
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:1];   //   图片的位置
        NSArray *indexArray = [NSArray  arrayWithObject:indexPath];
        [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    
//    //  指定刷新
//    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

-(void)dismissAllKeyBoardInView:(UIView *)view
{
    [self.view endEditing:YES];
}




-(void)up_dataForGetOrderList
{
    if (![[Utilities replaceNull:_selectDateStr] isEqualToString:@""]) {
        /**
         
         飞机确定航班显示
         http://app.meridianjet.vip/login.svc/GetOrderList
         
         上传参数：
         /// <param name="DateStr">日期（2018-10-02）</param>
         /// <param name="AirPlane">飞机型号</param>
         
         */
        
        [Utilities showProcessingHud:self.view];
        
        NSDictionary *data = @{
                               @"url":REQ_URL,
                               @"url_stringByAppendingString":@"login.svc/GetOrderList",
                               
                               @"UserName":[UtilitiesData getLoginUserName],
                               @"DateStr":_selectDateStr,
                               @"AirPlane":_selectAirPlaneType  /// InfoID
                               };
        
        [network sendHttpReq:HttpReq_GetOrderList andData:data];
    }
}

-(void)up_dataForPlaneType
{
    /**
     
     飞机机型
     http://app.meridianjet.vip/login.svc/GetPlaneListS
     
     上传参数：
     app  移动端应用版本号（每个接口都传）    1.0.0
     appId   区分移动端应用名称（每个接口都传）    香港子午线：0    子午线上传数据：1
     
     */
    
    //    [Utilities showProcessingHud:self.view];
    
    
    NSDictionary *data = @{
                           @"url":REQ_URL,
                           @"url_stringByAppendingString":@"login.svc/GetPlaneListS",
                           };
    
    [network sendHttpReq:HttpReq_GetPlaneListS andData:data];
}

-(void)uplaod_dataForOutsideReimbursement
{
    //  外采报销
    /**
     http://app.meridianjet.vip/FileUploadTS.ashx 外采上传
     /// <param name="subsidiesamount">补助金额</param>
     /// <param name="airplanetype">机型ID</param>
     /// <param name="orderid">航段ID</param>
     /// <param name="username">当前用户名</param>
     /// <param name="memo">备注</param>
     /// <param name="PicType">图片后缀</param>
     */
    
    [Utilities showProcessingHud:self.view];
    
    NSMutableArray *imgArrTest = [NSMutableArray array];
    for (int i = 0 ; i < [_imgsDic0 count]; i++) {
        [imgArrTest addObject:_imgsDic0[[NSString stringWithFormat:@"%d",i]]];
    }
    
    NSDictionary *data = @{
                           @"url":REQ_URL,
                           @"url_stringByAppendingString":@"FileUploadTS.ashx",
                           
                           @"subsidiesamount":[Utilities replaceNull:_focus],
                           @"airplanetype":[Utilities replaceNull:_selectAirPlaneTypeInfoID],
                           @"orderid":[Utilities replaceNull:_selectDateForSection0Model.InfoID],
                           @"username":[UtilitiesData getLoginUserName],
                           @"memo":[Utilities replaceNull:_content],

                           @"PicType":@"png",
                           @"imgsArr":imgArrTest
                           };
    
    [network sendHttpReq:HttpReq_FileUploadTS_ashx andData:data];
    
}

-(void)uplaod_dataForOil
{
    //  剩余油量
    /**
     http://app.meridianjet.vip/FileUploadOil.ashx 外采上传
     /// <param name="orderID">航段Infoid</param>
     /// <param name="Remark">备注</param>
     /// <param name="PicType">png</param>
     /// <param name="UserName">当前用户名</param>
     /// <param name="oilnum">油量</param>
     */
    
    [Utilities showProcessingHud:self.view];
    
    NSMutableArray *imgArrTest = [NSMutableArray array];
    for (int i = 0 ; i < [_imgsDic0 count]; i++) {
        [imgArrTest addObject:_imgsDic0[[NSString stringWithFormat:@"%d",i]]];
    }
    
    NSDictionary *data = @{
                           @"url":REQ_URL,
                           @"url_stringByAppendingString":@"FileUploadOil.ashx",
                           
                           @"oilnum":[Utilities replaceNull:_focus],
                           @"airplanetype":[Utilities replaceNull:_selectAirPlaneTypeInfoID],
                           @"orderID":[Utilities replaceNull:_selectDateForSection0Model.InfoID],
                           @"username":[UtilitiesData getLoginUserName],
                           @"Remark":[Utilities replaceNull:_content],
                           
                           @"PicType":@"png",
                           @"imgsArr":imgArrTest
                           };
    
    [network sendHttpReq:HttpReq_FileUploadOil_ashx andData:data];
}


#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(id)data andType:(HttpReqType)type
{
    NSDictionary *resultJSON = data;
    
    NSLog(@"OutsideReimbursementEditViewController  HttpReqType  %d\n  Data    %@",type,resultJSON);
    
    //   飞机机型
    if (type == HttpReq_GetPlaneListS) {
        
        [Utilities dismissProcessingHud:self.view];
        
        if ([resultJSON[@"Result"] boolValue]) {
            
            NSString *MessageStr = [Utilities replaceNull:resultJSON[@"Message"]];
            
            NSArray *MessageArr = [Utilities replaceArrNull:[Utilities JsonStrtoArrayOrNSDictionary:MessageStr]];
            
            [_dataArrForPlaneType removeAllObjects];
            for (NSDictionary *dic in MessageArr) {
                OnlyEditPerSQLModel *model = [OnlyEditPerSQLModel new];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArrForPlaneType addObject:model];
            }
            [_tableView reloadData];
            
        } else {
            [Utilities showTextHud:[resultJSON objectForKey:@"Message"] descView:self.view];
        }
        
    }
    
    
    
    //   飞机航班
    if (type == HttpReq_GetOrderList) {
        
        [Utilities dismissProcessingHud:self.view];
        
        if ([resultJSON[@"Result"] boolValue]) {
            
            _dataArrForSection0ToJsonStr = [Utilities replaceNull:resultJSON[@"Message"]];
            
            NSArray *MessageArr = [Utilities replaceArrNull:[Utilities JsonStrtoArrayOrNSDictionary:_dataArrForSection0ToJsonStr]];
            
            [_dataArrForSection0 removeAllObjects];
            for (NSDictionary *dic in MessageArr) {
                OnlyEditPerSQLModel *model = [OnlyEditPerSQLModel new];
                [model setValuesForKeysWithDictionary:dic];
                model.selectForCell = @"NO";
                if ([dic[@"OILCount"] integerValue] > 0 && _type == 1) {  // 剩余油量  不能点击
                    model.selectForCell = @"userInteractionEnabled_NO";
                }
                if ([dic[@"TSCount"] integerValue] > 0 && _type == 0) {  //  外采报销  不能点击
                    model.selectForCell = @"userInteractionEnabled_NO";
                }
                [_dataArrForSection0 addObject:model];
            }
            
            
            //  指定刷新
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            
        } else {
            [_dataArrForSection0 removeAllObjects];
            //  指定刷新
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [Utilities showTextHud:[resultJSON objectForKey:@"Message"] descView:self.view];
        }
        
    }
    
    
    
    //   外采报销上传完成
    if (type == HttpReq_FileUploadTS_ashx) {
        
        [Utilities dismissProcessingHud:self.view];
        
        if ([resultJSON[@"Result"] boolValue]) {
            
            [Utilities showTextHud:[resultJSON objectForKey:@"Message"] descView:self.view];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OutsideReimbursementListViewController_reloadData" object:self userInfo:nil];
            
            [self performSelector:@selector(selectLeftAction:) withObject:nil afterDelay:1.f];
            
        } else {
            [Utilities showTextHud:[resultJSON objectForKey:@"Message"] descView:self.view];
        }
        
    }
    
    //   剩余油量上传完成
    if (type == HttpReq_FileUploadOil_ashx) {
        
        [Utilities dismissProcessingHud:self.view];
        
        if ([resultJSON[@"Result"] boolValue]) {
            
            [Utilities showTextHud:[resultJSON objectForKey:@"Message"] descView:self.view];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OutsideReimbursementListViewController_reloadData" object:self userInfo:nil];
            
            [self performSelector:@selector(selectLeftAction:) withObject:nil afterDelay:1.f];
            
        } else {
            [Utilities showTextHud:[resultJSON objectForKey:@"Message"] descView:self.view];
        }
        
    }
    
    
}

-(void)reciveHttpDataError:(NSError*)err
{
    [Utilities dismissProcessingHud:self.view];
    {
//        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
//        [self.view addSubview:noNetworkV];
        [Utilities showTextHud:TEXT_NONETWORK descView:self.view];
    }
}



@end
