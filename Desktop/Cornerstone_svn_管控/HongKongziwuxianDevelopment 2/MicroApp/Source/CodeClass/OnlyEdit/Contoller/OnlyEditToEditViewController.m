//
//  OnlyEditToEditViewController.m
//  MicroApp
//
//  Created by kaiyi on 2018/10/9.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "OnlyEditToEditViewController.h"

#import "OnlyEditToEditTableViewCell.h"
#import "OnlyEditToEditTableHeaderView.h"
#import "OnlyEditPerSQLModel.h"

#import "AddImagesToolDIY2.h"
#import "AddImageUtilities.h"

#import "OnlyEditPerButDownView.h"


static NSString *HeaderIdentifier = @"header";
static NSString * showOnlyEditToEditTableViewCell = @"cell";

@interface OnlyEditToEditViewController () <UITableViewDelegate,UITableViewDataSource,OnlyEditToEditTableHeaderViewDelegate,HttpReqCallbackDelegate,OnlyEditToEditTableViewCellDelegate,OnlyEditPerButDownViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArrForSection0;  //   飞机航次数据
@property (nonatomic,strong) NSString *dataArrForSection0ToJsonStr;  //  本地数据保存 数组，json 格式
@property (nonatomic,strong) NSMutableArray *dataArrForPlaneType;  //   飞机机型


@property (nonatomic,strong) NSString *selectDateStr;  //  选择好的时间
@property (nonatomic,strong) NSString *selectAirPlaneType;  //  选择好的飞机类型

@property (nonatomic,strong) OnlyEditPerSQLModel *selectDateForSection0Model;  //  选择好的航次


@property (nonatomic,strong) AddImagesToolDIY2 *imgTool0;
@property (nonatomic,strong) AddImagesToolDIY2 *imgTool1;
@property (nonatomic,strong) AddImagesToolDIY2 *imgTool2;

@property (nonatomic,strong) NSMutableDictionary *imgsDic0;
@property (nonatomic,strong) NSMutableDictionary *imgsDic1;
@property (nonatomic,strong) NSMutableDictionary *imgsDic2;

@property (nonatomic,strong) NSMutableDictionary *imgsDic0PathName;   //  没有具体位置的图片名称
@property (nonatomic,strong) NSMutableDictionary *imgsDic1PathName;
@property (nonatomic,strong) NSMutableDictionary *imgsDic2PathName;

@property (nonatomic,strong) NSMutableDictionary *imgsTextDic0;   //   上传的图片名称为 key
@property (nonatomic,strong) NSMutableDictionary *imgsTextDic1;
@property (nonatomic,strong) NSMutableDictionary *imgsTextDic2;

@end

@implementation OnlyEditToEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if (_type == isNewEdit) {
        [self setCustomizeTitle:@"新建任务"];
    } else if (_type == isCanEdit) {
        [self setCustomizeTitle:@"编辑任务"];
    } else if (_type == isReadOnly) {
        [self setCustomizeTitle:@"查看任务"];
    }
    [self setCustomizeLeftButton];
    
    
    // Custom initialization
    network = [AFNNetworkUtility alloc];
    network.delegate = self;
    
    
    _dataArrForSection0 = [NSMutableArray array];
    _dataArrForSection0ToJsonStr = [NSString string];
    _dataArrForPlaneType = [NSMutableArray array];
    _selectDateStr = [NSString string];
    _selectAirPlaneType = [NSString string];
    _selectDateForSection0Model = [OnlyEditPerSQLModel new];
    _imgsDic0 = [NSMutableDictionary dictionary];
    _imgsDic1 = [NSMutableDictionary dictionary];
    _imgsDic2 = [NSMutableDictionary dictionary];
    _imgsDic0PathName = [NSMutableDictionary dictionary];
    _imgsDic1PathName = [NSMutableDictionary dictionary];
    _imgsDic2PathName = [NSMutableDictionary dictionary];
    _imgsTextDic0 = [NSMutableDictionary dictionary];
    _imgsTextDic1 = [NSMutableDictionary dictionary];
    _imgsTextDic2 = [NSMutableDictionary dictionary];
    
    
    [self up_tableView];
    
    [self up_downButView];
    
    //  飞机机型
    [self up_dataForPlaneType];
    
    
    CGFloat imgWidth = (KScreenWidth-90 - 20)/3;
    
    _imgTool0 = [[AddImagesToolDIY2 alloc] initWithFrame:CGRectMake(80, 20, [UIScreen mainScreen].bounds.size.width, imgWidth + 30)];
    _imgTool0.tag = 1060;
    [_imgTool0 drawAddImagesToolDIY2:nil withViewController:self];
    _imgTool0.backgroundColor = [UIColor whiteColor];
    
    _imgTool1 = [[AddImagesToolDIY2 alloc] initWithFrame:CGRectMake(80, 20, [UIScreen mainScreen].bounds.size.width, imgWidth + 30)];
    _imgTool1.tag = 1061;
    [_imgTool1 drawAddImagesToolDIY2:nil withViewController:self];
    _imgTool1.backgroundColor = [UIColor whiteColor];
    
    _imgTool2 = [[AddImagesToolDIY2 alloc] initWithFrame:CGRectMake(80, 20, [UIScreen mainScreen].bounds.size.width, imgWidth + 30)];
    _imgTool2.tag = 1062;
    [_imgTool2 drawAddImagesToolDIY2:nil withViewController:self];
    _imgTool2.backgroundColor = [UIColor whiteColor];
    
    
    
    
    if (_type == isCanEdit) {
        
        //  可编辑的
        _selectDateStr = _selectModel.selectDateStr;
        _selectAirPlaneType = _selectModel.selectAirPlaneType;
        _selectDateForSection0Model.orderName =  _selectModel.selectDateForSection0Model_orderName;
        _selectDateForSection0Model.airplaneType =  _selectModel.selectDateForSection0Model_airplaneType;
        _selectDateForSection0Model.departureDate =  _selectModel.selectDateForSection0Model_departureDate;
        _selectDateForSection0Model.selectAirPlaneTypeInfoId = _selectModel.selectAirPlaneTypeInfoId;
        
        //  DB 请求下来的网络数据
        NSArray *MessageArr = [Utilities replaceArrNull:[Utilities JsonStrtoArrayOrNSDictionary:_selectModel.dataArrForSection0ToJsonStr]];
        
        //   如果有网络，再走一次网络数据
        if ([Utilities isConnected]) {
            _selectDateStr = _selectModel.selectDateStr;
            [self up_dataForGetOrderList];
        }
        
        [_dataArrForSection0 removeAllObjects];
        for (NSDictionary *dic in MessageArr) {
            OnlyEditPerSQLModel *model = [OnlyEditPerSQLModel new];
            [model setValuesForKeysWithDictionary:dic];
            if ([model.orderName isEqualToString:_selectModel.selectDateForSection0Model_orderName]) {
                model.selectForCell = @"YES";
            } else {
                if ([dic[@"PZCount"] integerValue] > 0) {  //   不能点击
                    model.selectForCell = @"userInteractionEnabled_NO";
                } else {
                    model.selectForCell = @"NO";
                }
            }
            [_dataArrForSection0 addObject:model];
        }
        
        
        //  本地图片
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [path objectAtIndex:0];
        //指定新建文件夹路径
        NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"OnlyEditToEditViewController/"];
        
        NSDictionary *ImgDic0 = [Utilities JsonStrtoArrayOrNSDictionary:_selectModel.imgsDic0PathName];
        NSDictionary *ImgDic1 = [Utilities JsonStrtoArrayOrNSDictionary:_selectModel.imgsDic1PathName];
        NSDictionary *ImgDic2 = [Utilities JsonStrtoArrayOrNSDictionary:_selectModel.imgsDic2PathName];
        
        NSDictionary *dicText0 = [Utilities JsonStrtoArrayOrNSDictionary:_selectModel.imgsTextDic0];
        NSDictionary *dicText1 = [Utilities JsonStrtoArrayOrNSDictionary:_selectModel.imgsTextDic1];
        NSDictionary *dicText2 = [Utilities JsonStrtoArrayOrNSDictionary:_selectModel.imgsTextDic2];
        
        NSMutableArray *ImgsArr0 = [NSMutableArray array];
        NSMutableArray *ImgsArr1 = [NSMutableArray array];
        NSMutableArray *ImgsArr2 = [NSMutableArray array];
        
        if ([ImgDic0 count] > 0) {
            for (int i = 0; i < [ImgDic0 count]; i++) {
                [ImgsArr0 addObject:@{
                                      @"image":[UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",imageDocPath , ImgDic0[[NSString stringWithFormat:@"%d",i]]]],
                                      @"imageId":ImgDic0[[NSString stringWithFormat:@"%d",i]],
                                      @"imgaText":[Utilities replaceNull:dicText0[ImgDic0[[NSString stringWithFormat:@"%d",i]]]]
                                      }];
            }
        }
        
        if ([ImgDic1 count] > 0) {
            for (int i = 0; i < [ImgDic1 count]; i++) {
                [ImgsArr1 addObject:@{
                                      @"image":[UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",imageDocPath , ImgDic1[[NSString stringWithFormat:@"%d",i]]]],
                                      @"imageId":ImgDic1[[NSString stringWithFormat:@"%d",i]],
                                      @"imgaText":[Utilities replaceNull:dicText1[ImgDic1[[NSString stringWithFormat:@"%d",i]]]]
                                      }];
            }
        }
        
        if ([ImgDic2 count] > 0) {
            for (int i = 0; i < [ImgDic2 count]; i++) {
                [ImgsArr2 addObject:@{
                                      @"image":[UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",imageDocPath , ImgDic2[[NSString stringWithFormat:@"%d",i]]]],
                                      @"imageId":ImgDic2[[NSString stringWithFormat:@"%d",i]],
                                      @"imgaText":[Utilities replaceNull:dicText2[ImgDic2[[NSString stringWithFormat:@"%d",i]]]]
                                      }];
            }
        }
        
        [_imgTool0 drawAddImagesToolDIY2:ImgsArr0 withViewController:self];
        [_imgTool1 drawAddImagesToolDIY2:ImgsArr1 withViewController:self];
        [_imgTool2 drawAddImagesToolDIY2:ImgsArr2 withViewController:self];
        
        
        [_tableView reloadData];
    }
    
}

-(void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - OnlyEditPerButDownViewDelegate
-(void)selectButDownViewWithTag:(NSInteger)tag
{
    if (tag == 0) {   // 保存完成1   保存草稿0
        [self saveToDBWithTag:tag];
    } else {
        if ([[Utilities replaceNull:_selectDateStr] isEqualToString:@""]) {
            [Utilities showTextHud:@"请选择日期" descView:self.view];
        } else if ([[Utilities replaceNull:_selectDateForSection0Model.orderName] isEqualToString:@""]) {
            [Utilities showTextHud:@"请选择航班" descView:self.view];
        } else if ([[Utilities replaceArrNull:_imgTool0.assetsAndImgs] count] == 0) {
            [Utilities showTextHud:@"请上传起飞凭证图片" descView:self.view];
        } else if ([[Utilities replaceArrNull:_imgTool1.assetsAndImgs] count] == 0) {
            [Utilities showTextHud:@"请上传降落凭证图片" descView:self.view];
        } else {
            [self saveToDBWithTag:tag];
        }
    }
}


-(void)saveToDBWithTag:(NSInteger)tag
{
    [Utilities showProcessingHud:self.view];
    
    
    NSLog(@"保存的数据 \n \n  %@  %@",_selectDateStr , _selectAirPlaneType);
    
    _selectDateForSection0Model.selectForCell = @"YES";
    NSLog(@"保存的数据 \n \n  %@  %@  %@  %@",_selectDateForSection0Model.orderName , _selectDateForSection0Model.airplaneType , _selectDateForSection0Model.departureDate , _selectDateForSection0Model.selectForCell);
    
    NSLog(@"保存的数据 \n \n  %@ ",_dataArrForSection0ToJsonStr);
    
    
    [_imgsDic0 removeAllObjects];
    [_imgsDic1 removeAllObjects];
    [_imgsDic2 removeAllObjects];
    [_imgsDic0PathName removeAllObjects];
    [_imgsDic1PathName removeAllObjects];
    [_imgsDic2PathName removeAllObjects];
    [_imgsTextDic0 removeAllObjects];
    [_imgsTextDic1 removeAllObjects];
    [_imgsTextDic2 removeAllObjects];
    
    [self saveButtonImageToFileWith:_imgTool0];
    [self saveButtonImageToFileWith:_imgTool1];
    [self saveButtonImageToFileWith:_imgTool2];
    
 
    
    NSLog(@"保存的数据三组图片 \n \n  %@ \n %@ \n",_imgsDic0 , _imgsTextDic0);
    NSLog(@"保存的数据三组图片 \n \n  %@ \n %@ \n",_imgsDic1 , _imgsTextDic1);
    NSLog(@"保存的数据三组图片 \n \n  %@ \n %@ \n",_imgsDic2 , _imgsTextDic2);
    
    
    NSString *saveState = [NSString string];
    if (tag == 0) {
        saveState = @"0";  // 草稿0   待上传1
    } else {
        saveState = @"1";
    }
    
    
    if (_type == isNewEdit) {
        //  新建的
        NSLog(@"新建保存");
        
        [OnlyEditPerSQLModel insertDataWithselectDateStr:_selectDateStr
                                      selectAirPlaneType:_selectAirPlaneType
                    selectDateForSection0Model_orderName:_selectDateForSection0Model.orderName
                 selectDateForSection0Model_airplaneType:_selectDateForSection0Model.airplaneType
                selectDateForSection0Model_departureDate:_selectDateForSection0Model.departureDate
                selectDateForSection0Model_selectForCell:_selectDateForSection0Model.selectForCell
                             dataArrForSection0ToJsonStr:_dataArrForSection0ToJsonStr
                                        imgsDic0PathName:[Utilities objectToJsonWithObject:[NSDictionary dictionaryWithDictionary:_imgsDic0PathName]]
                                        imgsDic1PathName:[Utilities objectToJsonWithObject:[NSDictionary dictionaryWithDictionary:_imgsDic1PathName]]
                                        imgsDic2PathName:[Utilities objectToJsonWithObject:[NSDictionary dictionaryWithDictionary:_imgsDic2PathName]]
                                            imgsTextDic0:[Utilities objectToJsonWithObject:[NSDictionary dictionaryWithDictionary:_imgsTextDic0]]
                                            imgsTextDic1:[Utilities objectToJsonWithObject:[NSDictionary dictionaryWithDictionary:_imgsTextDic1]]
                                            imgsTextDic2:[Utilities objectToJsonWithObject:[NSDictionary dictionaryWithDictionary:_imgsTextDic2]]
                                               saveState:saveState
                                selectAirPlaneTypeInfoId:[Utilities replaceNull:_selectDateForSection0Model.InfoID]];
    } else {
        NSLog(@"修改保存保存 pk = %d",_selectDateForSection0Model.primaryKey);
        [OnlyEditPerSQLModel upDataWithselectDateStr:[Utilities replaceNull:_selectDateStr]
                                  selectAirPlaneType:[Utilities replaceNull:_selectAirPlaneType]
                selectDateForSection0Model_orderName:[Utilities replaceNull:_selectDateForSection0Model.orderName]
             selectDateForSection0Model_airplaneType:[Utilities replaceNull:_selectDateForSection0Model.airplaneType]
            selectDateForSection0Model_departureDate:[Utilities replaceNull:_selectDateForSection0Model.departureDate]
            selectDateForSection0Model_selectForCell:[Utilities replaceNull:_selectDateForSection0Model.selectForCell]
                         dataArrForSection0ToJsonStr:[Utilities replaceNull:_dataArrForSection0ToJsonStr]
                                    imgsDic0PathName:[Utilities objectToJsonWithObject:[NSDictionary dictionaryWithDictionary:_imgsDic0PathName]]
                                    imgsDic1PathName:[Utilities objectToJsonWithObject:[NSDictionary dictionaryWithDictionary:_imgsDic1PathName]]
                                    imgsDic2PathName:[Utilities objectToJsonWithObject:[NSDictionary dictionaryWithDictionary:_imgsDic2PathName]]
                                        imgsTextDic0:[Utilities objectToJsonWithObject:[NSDictionary dictionaryWithDictionary:_imgsTextDic0]]
                                        imgsTextDic1:[Utilities objectToJsonWithObject:[NSDictionary dictionaryWithDictionary:_imgsTextDic1]]
                                        imgsTextDic2:[Utilities objectToJsonWithObject:[NSDictionary dictionaryWithDictionary:_imgsTextDic2]]
                                           saveState:saveState
                            selectAirPlaneTypeInfoId:[Utilities replaceNull:_selectDateForSection0Model.InfoID]?[Utilities replaceNull:_selectDateForSection0Model.selectAirPlaneTypeInfoId]:[Utilities replaceNull:_selectDateForSection0Model.InfoID]
                                          primaryKey:_selectModel.pk];
    }
    
    
    
    
    [Utilities dismissProcessingHud:self.view];
    
    [Utilities showTextHud:@"保存成功" descView:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OnlyEditPerViewController_reloadData" object:self userInfo:nil];
    
    [self selectLeftAction:nil];
    
}


#pragma mark -
#pragma mark 多图片上传第一步，把图片保存在本地   时间戳 和 imgTool.tag  区分
-(void)saveButtonImageToFileWith:(AddImagesToolDIY2 *)imgTool{
    
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //指定新建文件夹路径
    NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"OnlyEditToEditViewController"];//@"PublishPerViewController"
    //创建ImageFile文件夹
    [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    if(imgTool.buttonArray.count > 1){
        
        UIImage *image = nil;
        
        for (int i=0; i<[imgTool.assetsAndImgs count]; i++) {
            
            NSInteger tag = 0;
            if ([imgTool isEqual:_imgTool0]) {
                tag = 1;
            } else if ([imgTool isEqual:_imgTool1]) {
                tag = 2;
            } else if ([imgTool isEqual:_imgTool2]) {
                tag = 3;
            }
            
            
            NSString *imgNameForKey = [NSString stringWithFormat:@"%@image%d%dpng%ld.png",[Utilities getCurrentTimeStampStr] , imgTool.tag, i , tag];
            NSString *imgPath = [imageDocPath stringByAppendingPathComponent:imgNameForKey];
            
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
            data = UIImageJPEGRepresentation(image, 0.3);
            
            UIImage *img = [UIImage imageWithData:data];
            
            [[NSFileManager defaultManager] createFileAtPath:imgPath contents:[self imageToNsdata:img] attributes:nil];
            
            
            //  图片命名
            if ([_imgTool0 isEqual:imgTool]) {
                [_imgsDic0 setValue:imgPath forKey:[@"png" stringByAppendingString:[NSString stringWithFormat:@"%d",i]]];
                
                [_imgsDic0PathName setObject:imgNameForKey forKey:[NSString stringWithFormat:@"%d",i]];
                
                OnlyEditToEditTableViewCellImgAndText2 *but = [_imgTool0 viewWithTag:i + 1];
                [_imgsTextDic0 setObject:[Utilities replaceNull:but.textContent] forKey:imgNameForKey];
                
            }
            if ([_imgTool1 isEqual:imgTool]) {
                [_imgsDic1 setValue:imgPath forKey:[@"png" stringByAppendingString:[NSString stringWithFormat:@"%d",i]]];
                
                [_imgsDic1PathName setObject:imgNameForKey forKey:[NSString stringWithFormat:@"%d",i]];
                
                OnlyEditToEditTableViewCellImgAndText2 *but = [_imgTool1 viewWithTag:i + 1];
                [_imgsTextDic1 setObject:[Utilities replaceNull:but.textContent] forKey:imgNameForKey];
            }
            if ([_imgTool2 isEqual:imgTool]) {
                [_imgsDic2 setValue:imgPath forKey:[@"png" stringByAppendingString:[NSString stringWithFormat:@"%d",i]]];
                
                [_imgsDic2PathName setObject:imgNameForKey forKey:[NSString stringWithFormat:@"%d",i]];
                
                OnlyEditToEditTableViewCellImgAndText2 *but = [_imgTool2 viewWithTag:i + 1];
                [_imgsTextDic2 setObject:[Utilities replaceNull:but.textContent] forKey:imgNameForKey];
            }
            
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
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KScreenTabBarIndicatorHeight - KScreenNavigationBarHeight - 49) style:(UITableViewStyleGrouped)];
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
    
    [_tableView registerClass:[OnlyEditToEditTableViewCell class] forCellReuseIdentifier: showOnlyEditToEditTableViewCell];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat imgToolHeight = 0;
    if (indexPath.row == 0) {
        imgToolHeight = _imgTool0.frame.size.height;
    }
    if (indexPath.row == 1) {
        imgToolHeight = _imgTool1.frame.size.height;
    }
    if (indexPath.row == 2) {
        imgToolHeight = _imgTool2.frame.size.height;
    }
    
    return [OnlyEditToEditTableViewCell cellHeithWithSection:indexPath.section imgToolHeight:imgToolHeight];
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
    OnlyEditToEditTableViewCell *cell = (OnlyEditToEditTableViewCell *)[tableView dequeueReusableCellWithIdentifier: showOnlyEditToEditTableViewCell forIndexPath:indexPath];
    
    if ([_dataArrForSection0 count] > 0 && indexPath.section == 0) {
        cell.model = _dataArrForSection0[indexPath.row];
    }
    
    cell.delegate = self;
    
    cell.indexPath = indexPath;
    [cell reloadData];
    
    if (![cell viewWithTag:1060] && indexPath.row == 0 && indexPath.section == 1) {
        [cell addSubview:_imgTool0];
    }
    if (![cell viewWithTag:1061] && indexPath.row == 1 && indexPath.section == 1) {
        [cell addSubview:_imgTool1];
    }
    if (![cell viewWithTag:1062] && indexPath.row == 2 && indexPath.section == 1) {
        [cell addSubview:_imgTool2];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ///  取消按键效果  按中后会返回成没有安过的效果
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSLog(@"我点击了  %ld   %ld",(long)indexPath.section,(long)indexPath.row);
    
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
    NSLog(@"选择好的机型 = %@ ", type);
    _selectAirPlaneType = type;
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
    
    _selectDateForSection0Model.selectAirPlaneTypeInfoId = model.InfoID;
    _selectDateForSection0Model.InfoID = model.InfoID;
    
    //  指定刷新
//    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
//    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [_tableView reloadData];
    
}


#pragma mark - 图片调用
-(void)updateSize:(UIView*)view{
    
//    if (view == imgTool) {
    
//        //刷新单行数据
//        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];   //   图片的位置
//
//        NSArray *indexArray = [NSArray  arrayWithObject:indexPath];
//
//        [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    
//    }
    
    //  指定刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

-(void)dismissAllKeyBoardInView:(UIView *)view
{
    [self.view endEditing:YES];
}


-(void)up_downButView
{
    OnlyEditPerButDownView *downView = [[OnlyEditPerButDownView alloc]initWithFrame:
                                        CGRectMake(0, KScreenHeight - KScreenTabBarHeight - KScreenNavigationBarHeight, KScreenWidth, 49)];
    downView.typeInt = 1;
    downView.delegate = self;
    [self.view addSubview:downView];
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
                               @"AirPlane":_selectAirPlaneType
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


#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(id)data andType:(HttpReqType)type
{
    NSDictionary *resultJSON = data;
    
    NSLog(@"OnlyEditToEditViewController  HttpReqType  %d\n  Data    %@",type,resultJSON);
    
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
                if ([dic[@"PZCount"] integerValue] > 0) {  //   不能点击
                    model.selectForCell = @"userInteractionEnabled_NO";
                }
                
               
                if ([[Utilities replaceNull:model.InfoID] isEqualToString:[Utilities replaceNull:_selectModel.selectAirPlaneTypeInfoId]]) {
                    //  存在点击的和请求的model一样 的 数据
                    model.selectForCell = @"YES";
                    
                } else {
                    //  用户如果本地创建了草稿的话，不能继续新建
                    if ([OnlyEditPerSQLModel executeDataiIsHaveForModel:model]) {
                        model.selectForCell = @"userInteractionEnabled_NO";
                    }
                }
                
                [_dataArrForSection0 addObject:model];
            }
            
            
            //  指定刷新
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//            [_tableView reloadData];
            
        } else {
            [_dataArrForSection0 removeAllObjects];
            //  指定刷新
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//            [_tableView reloadData];
            
            [Utilities showTextHud:[resultJSON objectForKey:@"Message"] descView:self.view];
        }
        
    }
    
}

-(void)reciveHttpDataError:(NSError*)err
{
    [Utilities dismissProcessingHud:self.view];
    {
        [Utilities showTextHud:TEXT_NONETWORK descView:self.view];
//        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
//        [self.view addSubview:noNetworkV];
    }
}





@end
