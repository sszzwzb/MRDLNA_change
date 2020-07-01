//
//  RecipeUploadViewController.m
//  MicroSchool
//
//  Created by CheungStephen on 3/23/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "RecipeUploadViewController.h"

@interface RecipeUploadViewController ()

@end

@implementation RecipeUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setCustomizeLeftButton];
    [super setCustomizeTitle:_titleName];
    [super setCustomizeRightButtonWithName:@"发布"];
    
    _networkUtility = [[NetworkUtility alloc] init];
    _networkUtility.delegate = self;

    _imageArray = [[NSMutableDictionary alloc] init];//本地存储作业内容图片字典

    [self doShowContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectRightAction:(id)sender {
    /**
     * 上传菜谱图片
     * @author luke
     * @date 2016.03.14
     * @args
     *  v=3 ac=Kindergarten op=addRecipePics sid= cid= uid= app= rid=菜谱ID png0...png9, ids=1,2(删除图片的ID)
     */
    
    NSString *app = [Utilities getAppVersion];
    [self saveButtonImageToFile];
    
    
    if (0 == [_imageArray count]) {
        if (nil == _qngs) {
            TSAlertView *alert = [[TSAlertView alloc] initWithTitle:@"提示" message:@"请上传图片。"];
            [alert addBtnTitle:@"确定" action:^{
            }];
            
            [alert showAlertWithSender:self];
        }else {
            [Utilities showProcessingHud:self.view];
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Kindergarten", @"ac",
                                  @"3",@"v",
                                  @"addRecipePics", @"op",
                                  @"0", @"cid",
                                  [_recipeDic objectForKey:@"id"], @"rid",
                                  _imageArray, @"imageArray",
                                  _qngs,@"ids",
                                  app, @"app",
                                  nil];
            
            [_networkUtility sendHttpReq:HttpReq_RecipeUpload andData:data];
        }
    }else {
        [Utilities showProcessingHud:self.view];
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Kindergarten", @"ac",
                              @"3",@"v",
                              @"addRecipePics", @"op",
                              @"0", @"cid",
                              [_recipeDic objectForKey:@"id"], @"rid",
                              _imageArray, @"imageArray",
                              _qngs,@"ids",
                              app, @"app",
                              nil];
        
        [_networkUtility sendHttpReq:HttpReq_RecipeUpload andData:data];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#if 9
- (void)doShowContent {
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];

    _scrollerView = [UIScrollView new];
    _scrollerView.scrollEnabled = YES;
    _scrollerView.delegate = self;
    [self.view addSubview:_scrollerView];
    
    [_scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width, [Utilities getScreenSize].height - 64));
    }];
    
    _viewWhiteBg = [UIView new];
    _viewWhiteBg.backgroundColor = [UIColor clearColor];
    [_scrollerView addSubview:_viewWhiteBg];
    
    // 这里设置了背景白色view的edges与scrollView的一致，这样就不需要再次计算这个白色view的size了
    // 这样做可以避免同时两个view依赖于scrollView的contentSize来计算自己的size。
    // 如果有两个view同时依赖于scrollView算高度的话，就会出现其中一个view无法计算正确地高度，并且会有很多警告。
    [_viewWhiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollerView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.width.equalTo(_scrollerView);
    }];

    _contentWhiteBGView = [UIView new];
    _contentWhiteBGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_contentWhiteBGView];

    _imageWhiteBGView = [UIView new];
    _imageWhiteBGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_imageWhiteBGView];
    
    _iconImageView = [UIImageView new];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_iconImageView];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset([Utilities convertPixsH:10]);
        make.left.equalTo(self.view.mas_left).with.offset([Utilities convertPixsW:10]);
        
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    
    NSString *iconName = @"";
    if ([@"0"  isEqual: [_recipeDic objectForKey:@"type"]]) {
        iconName = @"SchoolHomePics/schoolHomeRepicesIcon0";
    }else if ([@"1"  isEqual: [_recipeDic objectForKey:@"type"]]) {
        iconName = @"SchoolHomePics/schoolHomeRepicesIcon1";
    }else if ([@"2"  isEqual: [_recipeDic objectForKey:@"type"]]) {
        iconName = @"SchoolHomePics/schoolHomeRepicesIcon2";
    }else if ([@"3"  isEqual: [_recipeDic objectForKey:@"type"]]) {
        iconName = @"SchoolHomePics/schoolHomeRepicesIcon3";
    }else if ([@"4"  isEqual: [_recipeDic objectForKey:@"type"]]) {
        iconName = @"SchoolHomePics/schoolHomeRepicesIcon4";
    }
    
    [_iconImageView setImage:[UIImage imageNamed:iconName]];

    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [[UIColor alloc] initWithRed:54/255.0f green:182/255.0f blue:169/255.0f alpha:1.0];
    _titleLabel.text = [_recipeDic objectForKey:@"title"];
    [self.view addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset([Utilities convertPixsH:10]);
        make.left.equalTo(_iconImageView.mas_right).with.offset([Utilities convertPixsW:10]);
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-10-10-17-10, 17));
    }];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:14.0f];
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel.numberOfLines = 0;
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.textColor = [[UIColor alloc] initWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
    _contentLabel.text = [_recipeDic objectForKey:@"content"];
    [self.view addSubview:_contentLabel];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).with.offset([Utilities convertPixsH:10]);
        make.left.equalTo(_iconImageView.mas_right).with.offset([Utilities convertPixsW:10]);
        make.right.equalTo(self.view.mas_right).with.offset(-[Utilities convertPixsW:10]);
    }];

    CGSize titleSize = [_titleLabel sizeThatFits:CGSizeMake([Utilities getScreenSizeWithoutBar].width-10-10-17-10, 0)];
    CGSize contentSize = [_contentLabel sizeThatFits:CGSizeMake([Utilities getScreenSizeWithoutBar].width-10-10-17-10, 0)];

    [_contentWhiteBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset([Utilities convertPixsH:0]);
        make.left.equalTo(self.view.mas_left).with.offset([Utilities convertPixsW:0]);
        
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, [Utilities convertPixsH:10]*3 + titleSize.height+contentSize.height));
    }];

    _imageTool = [AddImagesTool new];
    _imageTool.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_imageTool];
    
    [_imageTool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentWhiteBGView.mas_bottom).with.offset([Utilities convertPixsH:30]);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, 70.0));
    }];
    
    NSMutableArray *imageAry = [[NSMutableArray alloc] init];
    NSArray *recipeAry = [_recipeDic objectForKey:@"pics"];

    for (int i=0; i<[recipeAry count]; i++) {
        NSDictionary *picDic = [recipeAry objectAtIndex:i];
        
        UIImage *picImage = nil;
        NSString *key = [picDic objectForKey:@"url"];
        picImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:key];
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             picImage, @"image",
                             [NSString stringWithFormat:@"%@", [picDic objectForKey:@"id"]], @"imageId",
                             nil];
        
        [imageAry addObject:dic];
    }

    NSDictionary *dic_homework = [[NSDictionary alloc] initWithObjectsAndKeys:_imageTool, @"tool", imageAry, @"array",nil];
    
    [self performSelector:@selector(drawAddImagesTool:) withObject:dic_homework afterDelay:0.2];
//    [self performSelector:@selector(updateCForContentView) withObject:nil afterDelay:0.3];

    [_imageWhiteBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentWhiteBGView.mas_bottom).with.offset([Utilities convertPixsH:20]);
        make.left.equalTo(self.view.mas_left).with.offset(0);
    }];

}

-(void)drawAddImagesTool:(NSDictionary*)dic{
    
    AddImagesTool *tool = [dic objectForKey:@"tool"];
    NSMutableArray *array = [dic objectForKey:@"array"];
    
    [tool drawAddImagesTool:array withViewController:self];
}

-(void)updateCForContentView{
    
    CGSize a = _imageTool.frame.size;
    
    [_imageWhiteBGView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width,_imageTool.frame.size.height+22.0));
    }];
    
    
}

-(void)updateSize:(UIView*)view{
    
//    if (view == _imageToolForHomework) {
    
//    }
    
    [_imageWhiteBGView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width,_imageTool.frame.size.height+26.0));
    }];

    [_imageTool mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(_imageTool.frame.size.width,_imageTool.frame.size.height+22));
    }];

}

-(void)saveButtonImageToFile{
    
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //指定新建文件夹路径
    NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"WeixiaoHomeworkImageFile"];
    //创建ImageFile文件夹
    [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    if (1){
        
        if (_imageTool.buttonArray.count > 1) {
            
            UIImage *image = nil;
            
            if ([_imageTool.assetsAndImgs count] > [_imageTool.imageWithIdArray count]) {
                
                int start = [_imageTool.imageWithIdArray count];//大于imageWithIdArray数量的图片是新增的
                for (int i = start; i<[_imageTool.assetsAndImgs count]; i++) {
                    
                    NSString *imgPath = [imageDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"imageEdit%d.png",(i+1)]];
                    
                    if ([[_imageTool.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
                        
                        ALAsset *asset = [_imageTool.assetsAndImgs objectAtIndex:i];// update 2015.04.13
                        //获取资源图片的详细资源信息
                        ALAssetRepresentation* representation = [asset defaultRepresentation];
                        //获取资源图片的高清图
                        //[representation fullResolutionImage];
                        //获取资源图片的全屏图
                        //[representation fullScreenImage];
                        
                        image = [UIImage imageWithCGImage:[representation fullScreenImage]];
                        
                    }else{
                        image = [_imageTool.assetsAndImgs objectAtIndex:i];
                        UIImage *tempImage = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:image.imageOrientation];
                        image = [Utilities fixOrientation:tempImage];
                        
                    }
                    
                    UIImage *scaledImage;
                    UIImage *updateImage;
                    
                    // 如果宽度超过480，则按照比例进行缩放，把宽度固定在480
                    if (image.size.width >= 480) {
                        float scaleRate = 480/image.size.width;
                        
                        float w = 480;
                        float h = image.size.height * scaleRate;
                        
                        scaledImage = [Utilities imageWithImageSimple:image scaledToSize:CGSizeMake(w, h)];
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
                    
                    [_imageArray setValue:imgPath forKey:[@"png" stringByAppendingString:[NSString stringWithFormat:@"%d",i-start]]];
                }
            }
            
            
        }
        
        for (int i=0; i<[_imageTool.deleteFlagArray count]; i++) {
            
            NSString *deleteIdStr = [_imageTool.deleteFlagArray objectAtIndex:i];
            
            if (i == 0) {
                _qngs = deleteIdStr;
                
            }else{
                _qngs = [NSString stringWithFormat:@"%@,%@",_qngs,deleteIdStr];
            }
        }
        
        NSLog(@"qngs:%@",_qngs);
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
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    NSError *error;
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    NSLog(@"resultJSON:%@",resultJSON);
    
    [Utilities dismissProcessingHud:self.view];
    
    if(true == [result intValue]) {
        // 取消所有的网络请求
        [_networkUtility cancelCurrentRequest];
        [Utilities showTextHud:@"上传成功" descView:self.view];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"schoolHomeRefleshContentView" object:self userInfo:nil];
    }else {
        [Utilities showTextHud:@"上传失败" descView:self.view];
    }
}

-(void)reciveHttpDataError:(NSError*)err{
    
    [Utilities dismissProcessingHud:self.view];
    
    [Utilities showAlert:@"错误" message:@"网络连接错误，请稍候再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];

//    if (![Utilities isConnected]) {
//        [Utilities showAlert:@"错误" message:@"网络连接错误，请稍候再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
//    }
}

#endif
@end
