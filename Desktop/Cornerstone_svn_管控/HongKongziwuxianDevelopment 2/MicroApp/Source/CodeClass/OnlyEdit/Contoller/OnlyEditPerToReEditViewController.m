//
//  OnlyEditPerToReEditViewController.m
//  MicroApp
//
//  Created by kaiyi on 2018/10/22.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "OnlyEditPerToReEditViewController.h"

#import "OnlyEditToEditTableViewCell.h"
#import "OnlyEditPerSQLModel.h"

#import "AddImagesToolDIY2.h"
#import "AddImageUtilities.h"

static NSString * showOnlyEditToEditTableViewCell = @"cell";

@interface OnlyEditPerToReEditViewController () <UITableViewDelegate,UITableViewDataSource,HttpReqCallbackDelegate,OnlyEditToEditTableViewCellDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *headerView;


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

@implementation OnlyEditPerToReEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setCustomizeTitle:@"已完成修改"];
    [self setCustomizeLeftButton];
    [self setCustomizeRightButtonWithName:@"修改" color:[UIColor whiteColor]];
    
    
    
    // Custom initialization
    network = [AFNNetworkUtility alloc];
    network.delegate = self;
    
    
    
    
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
    
    
    [self up_data];
    
    [self removeFile];
    
}

-(void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectRightAction:(id)sender
{
    
    //  发布
    if ([[Utilities replaceNull:_selectModel.departureDate] isEqualToString:@""]) {
        [Utilities showTextHud:@"请选择日期" descView:self.view];
    } else if ([[Utilities replaceNull:_selectModel.orderName] isEqualToString:@""]) {
        [Utilities showTextHud:@"请选择航班" descView:self.view];
    } else if ([[Utilities replaceArrNull:_imgTool0.assetsAndImgs] count] == 0) {
        [Utilities showTextHud:@"请上传起飞凭证图片" descView:self.view];
    } else if ([[Utilities replaceArrNull:_imgTool1.assetsAndImgs] count] == 0) {
        [Utilities showTextHud:@"请上传降落凭证图片" descView:self.view];
    } else {
        [self.navigationItem.rightBarButtonItems objectAtIndex:1].enabled = NO;
        
        [self upload_data];
    }
    
}

-(void)upload_data
{
    
    NSLog(@"保存的数据 \n \n  %@  %@  %@ ",[Utilities replaceNull:_selectModel.airplaneType] , [Utilities replaceNull:_selectModel.orderName] , [Utilities replaceNull:_selectModel.departureDate]);
    
    
    
    [Utilities showProcessingHud:self.view];
    
    
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
    
    
    [Utilities dismissProcessingHud:self.view];
    
    
    [self upload_dataWithModel:_selectModel];
    
}


-(void)up_data
{
    
    UILabel *labTitle = [[UILabel alloc]initWithFrame:
                         CGRectMake(20, 15, KScreenWidth - 40, 32)];
    [_headerView addSubview:labTitle];
    labTitle.textColor = color_black;
    labTitle.font = FONT(16.f);
    labTitle.attributedText = [self attributedTextWithTitle0:@"航班" title1:[Utilities replaceNull:_selectModel.airplaneType] title2:[Utilities replaceNull:_selectModel.orderName]];
    
    
    UILabel *labDate = [[UILabel alloc]initWithFrame:
                        CGRectMake(20, CGRectGetMaxY(labTitle.frame) + 10, KScreenWidth - 40, 32)];
    [_headerView addSubview:labDate];
    labDate.textColor = color_black;
    labDate.font = FONT(16.f);
    labDate.attributedText = [self attributedTextWithTitle0:@"时间" title1:[Utilities replaceNull:_selectModel.departureDate]];
    
    
    NSArray *PicUrlArr = [Utilities JsonStrtoArrayOrNSDictionary:[Utilities replaceNull:_selectModel.PicUrl]];
    
    
    NSMutableArray *imgArr0 = [NSMutableArray array];
    NSMutableArray *imgArr1 = [NSMutableArray array];
    NSMutableArray *imgArr2 = [NSMutableArray array];
    for (NSDictionary *dic in PicUrlArr) {
        if ([dic[@"type"] isEqualToString:@"1"]) {
            [imgArr0 addObject:@{
                                 @"image":@"NO",
                                 @"imageUrl":dic[@"xnpicurl"],
                                 @"imageId":dic[@"InfoID"],
                                 @"imgaText":dic[@"PicRemark"]
                                 }];
        }
        if ([dic[@"type"] isEqualToString:@"2"]) {
            [imgArr1 addObject:@{
                                 @"image":@"NO",
                                 @"imageUrl":dic[@"xnpicurl"],
                                 @"imageId":dic[@"InfoID"],
                                 @"imgaText":dic[@"PicRemark"]
                                 }];
        }
        if ([dic[@"type"] isEqualToString:@"3"]) {
            [imgArr2 addObject:@{
                                 @"image":@"NO",
                                 @"imageUrl":dic[@"xnpicurl"],
                                 @"imageId":dic[@"InfoID"],
                                 @"imgaText":dic[@"PicRemark"]
                                 }];
        }
    }
    
    
    [_imgTool0 drawAddImagesToolDIY2:imgArr0 withViewController:self];
    [_imgTool1 drawAddImagesToolDIY2:imgArr1 withViewController:self];
    [_imgTool2 drawAddImagesToolDIY2:imgArr2 withViewController:self];
    
    
    
    
    [_tableView reloadData];
    
}

-(NSAttributedString *)attributedTextWithTitle0:(NSString *)title0 title1:(NSString *)title1 title2:(NSString *)title2{
    NSString *string = [NSString stringWithFormat:@"%@:  %@  %@",title0 , title1 , title2];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    
    [str addAttribute:NSForegroundColorAttributeName
                value:color_blue
                range:NSMakeRange([title0 length] + 3,[title1 length])];
    
    
    return str;
}

-(NSAttributedString *)attributedTextWithTitle0:(NSString *)title0 title1:(NSString *)title1 {
    NSString *string = [NSString stringWithFormat:@"%@:  %@",title0 , title1 ];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    
    [str addAttribute:NSForegroundColorAttributeName
                value:color_gray2
                range:NSMakeRange([title0 length] + 3,[title1 length])];
    
    
    return str;
}

//  删除文件夹
-(void)removeFile
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //指定新建文件夹路径
    NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"OnlyEditPerToReEditViewController"];//@"PublishPerViewController"
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager removeItemAtPath:imageDocPath error:nil];
}

#pragma mark -
#pragma mark 多图片上传第一步，把图片保存在本地   时间戳 和 imgTool.tag  区分
-(void)saveButtonImageToFileWith:(AddImagesToolDIY2 *)imgTool{
    
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //指定新建文件夹路径
    NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"OnlyEditPerToReEditViewController"];//@"PublishPerViewController"
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
                
//                image = [imgTool.assetsAndImgs objectAtIndex:i];
                
                UIButton *but = (UIButton *)imgTool.buttonArray[i];
                image = but.currentImage;
                
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
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KScreenTabBarIndicatorHeight - KScreenNavigationBarHeight) style:(UITableViewStyleGrouped)];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_tableView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _headerView = [[UIView alloc]initWithFrame:
                   CGRectMake(0, 0, KScreenWidth, 100)];
    _headerView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = _headerView;
    
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
    return 0.01;;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (section == 0) ? 0 : 3;
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
    OnlyEditToEditTableViewCell *cell = (OnlyEditToEditTableViewCell *)[tableView dequeueReusableCellWithIdentifier: showOnlyEditToEditTableViewCell forIndexPath:indexPath];

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




#pragma mark - 图片调用
-(void)updateSize:(UIView*)view{
    
    //  指定刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

-(void)dismissAllKeyBoardInView:(UIView *)view
{
    [self.view endEditing:YES];
}







-(void)upload_dataWithModel:(OnlyEditPerSQLModel *)model
{
    
    /**
     
     上传数据
     http://app.meridianjet.vip/login.svc/GetPlaneListS
     
     上传参数：
     app  移动端应用版本号（每个接口都传）    1.0.0
     appId   区分移动端应用名称（每个接口都传）    香港子午线：0    子午线上传数据：1
     
     */
    
    [Utilities showProcessingHud:self.view];
    
    
    NSMutableArray *imgTextArrAll = [NSMutableArray array];
    
    NSDictionary *dicText0 = _imgsTextDic0;
    NSDictionary *dicText1 = _imgsTextDic1;
    NSDictionary *dicText2 = _imgsTextDic2;
    
    
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
    NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"OnlyEditPerToReEditViewController/"];
    
    NSDictionary *ImgDic0 = _imgsDic0PathName;
    NSDictionary *ImgDic1 = _imgsDic1PathName;
    NSDictionary *ImgDic2 = _imgsDic2PathName;
    
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
                           
                           @"orderID":[Utilities replaceNull:model.InfoID],
                           @"Remark":Remark,
                           @"UserName":[UtilitiesData getLoginUserName],
                           
                           @"imgsArr0":ImgsArr0,
                           @"imgsArr1":ImgsArr1,
                           @"imgsArr2":ImgsArr2,
                           @"PicType":@"png",
                           
                           @"UpLoadType":@"1"    //   0是新增  1是修改
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
        
        [self.navigationItem.rightBarButtonItems objectAtIndex:1].enabled = YES;
        
        [Utilities dismissProcessingHud:self.view];
        
        if ([resultJSON[@"Result"] boolValue]) {
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OnlyEditPerViewController_reloadData" object:self userInfo:nil];
            [Utilities showTextHud:[resultJSON objectForKey:@"Message"] descView:self.view];
            
            [self performSelector:@selector(selectLeftAction:) withObject:self afterDelay:1.f];
            
        } else {
            [Utilities showTextHud:[resultJSON objectForKey:@"Message"] descView:self.view];
        }
        
    }
    
}

-(void)reciveHttpDataError:(NSError*)err
{
    [self.navigationItem.rightBarButtonItems objectAtIndex:1].enabled = YES;
    [Utilities dismissProcessingHud:self.view];
    {
        [Utilities showTextHud:TEXT_NONETWORK descView:self.view];
//        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
//        [self.view addSubview:noNetworkV];
    }
}


@end
