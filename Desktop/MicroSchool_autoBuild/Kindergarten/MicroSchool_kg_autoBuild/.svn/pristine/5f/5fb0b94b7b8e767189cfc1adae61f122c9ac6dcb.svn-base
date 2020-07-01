//
//  HomeworkDetailUploadViewController.m
//  MicroSchool
//
//  上传作业
//  Created by CheungStephen on 2/8/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "HomeworkDetailUploadViewController.h"

@interface HomeworkDetailUploadViewController ()

@end

@implementation HomeworkDetailUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super setCustomizeTitle:@""];
    
    [super setCustomizeLeftButtonWithName:@"取消"];
    [super setCustomizeRightButtonWithName:@"发送"];
    
    _imageArray = [[NSMutableDictionary alloc] init];//本地存储作业内容图片字典

    network = [NetworkUtility alloc];
    network.delegate = self;

    [self showSelectImageView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)selectLeftAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectRightAction:(id)sender {
    // 上传作业
    [self saveButtonImageToFile];

    if (0 != [_imageArray count]) {
        [Utilities showProcessingHud:self.view];
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Homework", @"ac",
                              @"3",@"v",
                              @"upload", @"op",
                              _cid, @"cid",
                              _tid, @"tid",
                              _imageArray, @"imageArray",
                              nil];
        
        [network sendHttpReq:HttpReq_HomeworkStudentUpload andData:data];
    }
}

- (void)showSelectImageView {
    _imageToolForHomework = [AddImagesTool new];
    [self.view addSubview:_imageToolForHomework];
    
    [_imageToolForHomework mas_makeConstraints:^(MASConstraintMaker *make) {
        // y与_textFieldHeight的y相同
        make.top.equalTo(self.view).with.offset(12.0);
        
        // x距离_labelHeight右边最长处5
        make.left.equalTo(self.view).with.offset(12.0);
    
        //        // _textFieldHeight的大小
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width-24.0, 70.0));
        
    }];
    
    NSDictionary *dic_homework = [[NSDictionary alloc] initWithObjectsAndKeys:_imageToolForHomework,@"tool",nil,@"array",nil];
    [self performSelector:@selector(drawAddImagesTool:) withObject:dic_homework afterDelay:0.1];
}

-(void)drawAddImagesTool:(NSDictionary*)dic{
    
    AddImagesTool *tool = [dic objectForKey:@"tool"];
    NSMutableArray *array = [dic objectForKey:@"array"];
    
    [tool drawAddImagesTool:array withViewController:self];
}

-(void)updateSize:(UIView*)view{
    
    if (view == _imageToolForHomework) {
        
        [_imageToolForHomework mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(_imageToolForHomework.frame.size.width,_imageToolForHomework.frame.size.height));
        }];
    }
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
        
        if (_imageToolForHomework.buttonArray.count > 1) {
            
            UIImage *image = nil;
            
            if ([_imageToolForHomework.assetsAndImgs count] > [_imageToolForHomework.imageWithIdArray count]) {
                
                int start = [_imageToolForHomework.imageWithIdArray count];//大于imageWithIdArray数量的图片是新增的
                for (int i = start; i<[_imageToolForHomework.assetsAndImgs count]; i++) {
                    
                    NSString *imgPath = [imageDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"imageEdit%d.png",(i+1)]];
                    
                    if ([[_imageToolForHomework.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
                        
                        ALAsset *asset = [_imageToolForHomework.assetsAndImgs objectAtIndex:i];// update 2015.04.13
                        //获取资源图片的详细资源信息
                        ALAssetRepresentation* representation = [asset defaultRepresentation];
                        //获取资源图片的高清图
                        //[representation fullResolutionImage];
                        //获取资源图片的全屏图
                        //[representation fullScreenImage];
                        
                        image = [UIImage imageWithCGImage:[representation fullScreenImage]];
                        
                    }else{
                        image = [_imageToolForHomework.assetsAndImgs objectAtIndex:i];
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
                    
                    [_imageArray setValue:imgPath forKey:[@"png" stringByAppendingString:[NSString stringWithFormat:@"%d",i]]];
                }
            }
            
            
        }
        
        for (int i=0; i<[_imageToolForHomework.deleteFlagArray count]; i++) {
            
            NSString *deleteIdStr = [_imageToolForHomework.deleteFlagArray objectAtIndex:i];
            
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
        [network cancelCurrentRequest];
        [Utilities showTextHud:@"上传成功" descView:self.view];
        
        [self.navigationController popViewControllerAnimated:YES];

        [self performSelector:@selector(postNoty) withObject:nil afterDelay:0.2];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHomeworkDetailViewState" object:nil];
    }else {
        [Utilities showTextHud:@"上传失败" descView:self.view];
    }
}

-(void)reciveHttpDataError:(NSError*)err{
    
    [Utilities dismissProcessingHud:self.view];
    
    if (![Utilities isConnected]) {
        [Utilities showAlert:@"错误" message:@"网络连接错误，请稍候再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
    }
}

- (void)postNoty {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadHomeworkDetailView" object:nil];

}

@end
