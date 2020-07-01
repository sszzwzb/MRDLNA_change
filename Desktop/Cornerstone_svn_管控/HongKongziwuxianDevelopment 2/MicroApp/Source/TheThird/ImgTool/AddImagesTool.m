//
//  AddImagesTool.m
//  MicroSchool
//
//  Created by Kate's macmini on 16/2/1.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "AddImagesTool.h"
#import "AddImageUtilities.h"


#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>


#import "TSPopupItem.h"


#import "OutsideReimbursementEditViewController.h"

@interface AddImagesTool () <UIImagePickerControllerDelegate,UIAlertViewDelegate,CTAssetsPickerControllerDelegate,UIActionSheetDelegate,FullImageViewControllerDelegate,UINavigationControllerDelegate>
{
    
    UIButton *button_photoMask0;
    UIImagePickerController *imagePickerController;
    NSInteger pressButtonTag;
    NSMutableArray *pics;
    NSInteger cameraNum;
    NSInteger photoNum;
    NSMutableArray *buttonArray;
    NSMutableArray *deleteFlagArray;
    NSMutableArray *imageWithIdArray;
    CGFloat imgWidth;
    
    NSInteger mostImgCount;   //  最多几个图片
    
}
@end

@implementation AddImagesTool
@synthesize controller,buttonArray,imageWithIdArray,deleteFlagArray;

- (void)drawAddImagesTool:(NSMutableArray*)array withViewController:(id)_controller mostImgCount:(NSInteger)mostImgCountInt;
{
    if (self) {
        
        self.controller = _controller;
        
        imgWidth = ([UIScreen mainScreen].bounds.size.width - 24.0 - 15.0)/4.0;
        
        mostImgCount = mostImgCountInt;
        
        if (array == nil || [array count] == 0) {
            
            // 加图片button
            button_photoMask0 = [UIButton buttonWithType:UIButtonTypeCustom];
            button_photoMask0.tag = 1;
            
            button_photoMask0.frame = CGRectMake(0,
                                                 0,
                                                 imgWidth,
                                                 imgWidth);
            
            
            [button_photoMask0 setBackgroundImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal];
            [button_photoMask0 setBackgroundImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted];
            
            
            [button_photoMask0 addTarget:self action:@selector(create_btnclick:) forControlEvents: UIControlEventTouchUpInside];
            
            [self addSubview:button_photoMask0];
            
            buttonArray = [[NSMutableArray alloc] init];
            
        }else{
            
            buttonArray = [[NSMutableArray alloc] init];
            deleteFlagArray = [[NSMutableArray alloc] init];
            photoNum = [array count];
            
            if (!self.assetsAndImgs) {
                self.assetsAndImgs = [[NSMutableArray alloc]init];
            }
            
            for (int i=0; i<[array count]; i++) {
                
                NSDictionary *dic = [array objectAtIndex:i];
                
                [self.assetsAndImgs addObject:[dic objectForKey:@"image"]];
                
                
            }
            imageWithIdArray = array;
            
            UIImage *img = nil;
            
            for (int i=0; i<[self.assetsAndImgs count]; i++) {
                
                UIButton *button_photoMask = [UIButton buttonWithType:UIButtonTypeCustom];
                [button_photoMask setBackgroundImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal] ;
                [button_photoMask setBackgroundImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted] ;
                [buttonArray addObject:button_photoMask];
                
                if ([[self.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
                    
                    ALAsset *asset = [self.assetsAndImgs objectAtIndex:i];
                    img = [UIImage imageWithCGImage:asset.thumbnail];
                    
                }else{
                    img = [self.assetsAndImgs objectAtIndex:i];
                }
                
                [[buttonArray objectAtIndex:i] setBackgroundImage:img forState:UIControlStateNormal] ;
                [[buttonArray objectAtIndex:i] setBackgroundImage:img forState:UIControlStateHighlighted];
                
                NSLog(@"tag0:%ld",(long)button_photoMask.tag);
            }
            
            
            UIButton *button_photoMask = [UIButton buttonWithType:UIButtonTypeCustom];
            
            
            [button_photoMask setBackgroundImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal] ;
            [button_photoMask setBackgroundImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted] ;
            
            //button_photoMask.tag = [self.assets count]+1;
            NSLog(@"tag:%ld",(long)button_photoMask.tag);
            [buttonArray addObject:button_photoMask];
            
            [self showImageButtonArray];
            
            
        }
        
    }else{
        NSLog(@"cnm");
    }
    //deletePhoto_Tool
}

// 点击+号添加图片
-(void)create_btnclick:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    pressButtonTag = button.tag;
    
    UIImage *img = [UIImage imageNamed:@"addImg_press.png"];
    
    //if (![Utilities image:button.imageView.image equalsTo:img]) {
    if (![AddImageUtilities image:button.currentBackgroundImage equalsTo:img]) {
        
        pics = [[NSMutableArray alloc] init];
        for (int i =0; i<[self.assetsAndImgs count]; i++) {
            
            if ([[self.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
                
                ALAsset *asset = [self.assetsAndImgs objectAtIndex:i];
                ALAssetRepresentation* representation = [asset defaultRepresentation];
                UIImage *image = [UIImage imageWithCGImage:[representation fullScreenImage]];
                [pics addObject:image];
            }else{
                
                UIImage *image = [self.assetsAndImgs objectAtIndex:i];
                [pics addObject:image];
            }
        }
        
        
        UIImage *image = nil;
        if ([[self.assetsAndImgs objectAtIndex:pressButtonTag-1] isKindOfClass:ALAsset.class]) {
            
            ALAsset *asset = [self.assetsAndImgs objectAtIndex:pressButtonTag-1];
            ALAssetRepresentation* representation = [asset defaultRepresentation];
            image = [UIImage imageWithCGImage:[representation fullScreenImage]];
            
        }else{
            
            image = [self.assetsAndImgs objectAtIndex:pressButtonTag-1];
        }
        
        NSInteger pos = pressButtonTag - 1;
        
        if ([self.controller isKindOfClass:[OutsideReimbursementEditViewController class]]) {
            FullImageViewController *fullImageViewController = [[FullImageViewController alloc] init];
            fullImageViewController.delegate = self;
            fullImageViewController.viewType = @"AddImagesTool";
            fullImageViewController.assetsArray = self.assetsAndImgs;
            fullImageViewController.currentIndex = pos;
            fullImageViewController.hidesBottomBarWhenPushed = YES;
            [((OutsideReimbursementEditViewController *)self.controller).navigationController pushViewController:fullImageViewController animated:YES];
        }
        
        
    } else{
        if (!self.assetsAndImgs) {
            self.assetsAndImgs = [[NSMutableArray alloc]init];
        }
        
        TSPopupItemHandler handlerTest = ^(NSInteger index, NSString *btnTitle){
            
            if (index == 0) {
                
                [self openCamera];
                
            }else if (index == 1){
                
                [self openPhoto];
                
            }
            
        };
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        sheet.tag = 400;
        sheet.actionSheetStyle = UIActionSheetStyleDefault;
        [sheet showInView:self];
        
        
        
        
        if ([self.controller isKindOfClass:[OutsideReimbursementEditViewController class]]){
            [((OutsideReimbursementEditViewController *)self.controller) dismissAllKeyBoardInView:((OutsideReimbursementEditViewController *)self.controller).view];
        }
        
    }
}

// 删除照片
-(void)getDeleteIndex:(NSString*)currentIndex
{
    
    // done: 在查看大图页点击删除走回这个方法,将index传回来
    pressButtonTag = [currentIndex integerValue]+1;
    
    // 是否删除图片
    for (int i = pressButtonTag; i< [buttonArray count]; i++) {
        // 把点击的button之后的每个button的图片设置为这个button后面button的图片
        [(UIButton*)[buttonArray objectAtIndex:i-1] setBackgroundImage:((UIButton*)[buttonArray objectAtIndex:i]).currentBackgroundImage forState:UIControlStateNormal] ;
        [(UIButton*)[buttonArray objectAtIndex:i-1] setBackgroundImage:((UIButton*)[buttonArray objectAtIndex:i]).currentBackgroundImage forState:UIControlStateHighlighted] ;
    }
    
    // 把最后面的一个button从父view中移除
    [(UIButton*)[buttonArray objectAtIndex:([buttonArray count]-1)] removeFromSuperview];
    
    UIButton *button = (UIButton*)[self viewWithTag:pressButtonTag];
    
    if (button) {
        NSLog(@"Y");
    }else{
        NSLog(@"N");
    }
    [button removeFromSuperview];
    // 移除array最后的button
    [buttonArray removeLastObject];
    
    // 设置显示加号的button的图片
    [(UIButton*)[buttonArray objectAtIndex:([buttonArray count]-1)] setBackgroundImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal] ;
    [(UIButton*)[buttonArray objectAtIndex:([buttonArray count]-1)] setBackgroundImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted] ;
    
    //-----update by kate 2014.10.09-------------
    // 重新按顺序显示array中所有button
    
    [self showImageButtonArray];
    if ([buttonArray count] == 1) {
        
        [self.assets removeAllObjects];
        [self.assetsAndImgs removeAllObjects];//--update 2015.04.13------
        cameraNum = 0;
        photoNum = 0;
        
        //---2016.02.03-------------------------------------------------------------
        for (int i=0; i<[imageWithIdArray count]; i++) {//好像不太对呢
            
            NSDictionary *dic = [imageWithIdArray objectAtIndex:i];
            NSString *imageIdStr = [dic objectForKey:@"imageId"];
            [deleteFlagArray addObject:imageIdStr];
        }
        [imageWithIdArray removeAllObjects];
        //---------------------------------------------------------------------------
        
    }else{
        
        //[self.assets removeObjectAtIndex:pressButtonTag-1];//如果是asset类型，这里需要知道在self.assets中的index
        if ([[self.assetsAndImgs objectAtIndex:pressButtonTag -1] isKindOfClass:ALAsset.class]) {
            
            photoNum --;
            
        }else{
            cameraNum--;
            
        }
        [self.assetsAndImgs removeObjectAtIndex:pressButtonTag -1];
        
        //---2016.02.03-------------------------------------------------------------
        if ([imageWithIdArray count] > 0) {//好像不太对呢
            
            if (pressButtonTag <= [imageWithIdArray count]) {
                
                NSDictionary *dic = [imageWithIdArray objectAtIndex:pressButtonTag-1];
                NSString *imageIdStr = [dic objectForKey:@"imageId"];
                
                [deleteFlagArray addObject:imageIdStr];
                
                [imageWithIdArray removeObjectAtIndex:pressButtonTag-1];
                
            }
            
        }
        
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        //CFShow(infoDictionary);
        // app名称
        NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            if ([[AVCaptureDevice class] respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
                AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (authorizationStatus == AVAuthorizationStatusRestricted
                    || authorizationStatus == AVAuthorizationStatusDenied) {
                    
                    // 没有权限
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                        message:[NSString stringWithFormat:@"请打开相机开关(设置 > 隐私 > 相机 > %@)",appName]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    return;
                }
            }
            
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            pickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
            pickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            pickerController.delegate = self;
            
            [controller presentViewController:pickerController animated:YES completion:nil];
        }
        else {
            // throw exception
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                            message:@"The Device not support Camera"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }else if (buttonIndex == 1){
        //从手机相册选择
        if (!self.assets)
            self.assets = [[NSMutableArray alloc] init];
        
        [self.assets removeAllObjects];
        
        if (photoNum > 0) {
            
        }else{
            
            photoNum = 0;
            
            for (int i=0; i<[self.assetsAndImgs count]; i++) {
                
                if ([[self.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
                    photoNum ++;
                    
                }
                
            }
            
        }
        
        
        CTAssetsPickerController  *picker = [[CTAssetsPickerController alloc] init];
        
        picker.assetsFilter         = [ALAssetsFilter allPhotos];
        picker.showsCancelButton    = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);
        picker.delegate             = self;
        picker.selectedAssets       = [NSMutableArray arrayWithArray:self.assets];
        
        
        [self.controller presentViewController:picker animated:YES completion:nil];
    }
}

/// 从手机相册选择
-(void)openPhoto{
    
    if (!self.assets)
        self.assets = [[NSMutableArray alloc] init];
    
    [self.assets removeAllObjects];
    
    if (photoNum > 0) {
        
    }else{
        
        photoNum = 0;
        
        for (int i=0; i<[self.assetsAndImgs count]; i++) {
            
            if ([[self.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
                photoNum ++;
                
            }
            
        }
        
    }
    
    
    CTAssetsPickerController  *picker = [[CTAssetsPickerController alloc] init];
    
    picker.assetsFilter         = [ALAssetsFilter allPhotos];
    picker.showsCancelButton    = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);
    picker.delegate             = self;
    picker.selectedAssets       = [NSMutableArray arrayWithArray:self.assets];
    
   
    [self.controller presentViewController:picker animated:YES completion:nil];
    
}

/// 拍照
-(void)openCamera{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //CFShow(infoDictionary);
    // app名称
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        if ([[AVCaptureDevice class] respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
            AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authorizationStatus == AVAuthorizationStatusRestricted
                || authorizationStatus == AVAuthorizationStatusDenied) {
                
                // 没有权限
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:[NSString stringWithFormat:@"请打开相机开关(设置 > 隐私 > 相机 > %@)",appName]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
                return;
            }
        }
        
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        pickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        pickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        pickerController.delegate = self;
        
        [controller presentViewController:pickerController animated:YES completion:nil];
    }
    else {
        // throw exception
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"The Device not support Camera"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Assets Picker Delegate

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    self.assets = [NSMutableArray arrayWithArray:assets];
    
    for (int i=0; i<[self.assets count]; i++) {
        [self.assetsAndImgs addObject:[self.assets objectAtIndex:i]];
    }
    
    for (int i=0; i<[buttonArray count]; i++) {
        [(UIButton*)[buttonArray objectAtIndex:i] removeFromSuperview];
    }
    [buttonArray removeAllObjects];
    [button_photoMask0 removeFromSuperview];
    
    UIImage *img = nil;
    
    for (int i=0; i<[self.assetsAndImgs count]; i++) {
        
        UIButton *button_photoMask = [UIButton buttonWithType:UIButtonTypeCustom];
        [button_photoMask setBackgroundImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal] ;
        [button_photoMask setBackgroundImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted] ;
        
        [buttonArray addObject:button_photoMask];
        
        if ([[self.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
            
            ALAsset *asset = [self.assetsAndImgs objectAtIndex:i];
            img = [UIImage imageWithCGImage:asset.thumbnail];
            
        }else{
            img = [self.assetsAndImgs objectAtIndex:i];
        }
        
        [[buttonArray objectAtIndex:i] setBackgroundImage:img forState:UIControlStateNormal] ;
        [[buttonArray objectAtIndex:i] setBackgroundImage:img forState:UIControlStateHighlighted];
        
        NSLog(@"tag0:%ld",(long)button_photoMask.tag);
    }
    
    
    UIButton *button_photoMask = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button_photoMask setBackgroundImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal] ;
    [button_photoMask setBackgroundImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted] ;
    
    NSLog(@"tag:%ld",(long)button_photoMask.tag);
    [buttonArray addObject:button_photoMask];
    
    [self showImageButtonArray];
    
    //[text_content becomeFirstResponder];
    //--------------------------------------------------
    
    
}

- (void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker{
    
    if (photoNum > [self.assets count]) {
        
        photoNum = [self.assets count];
    }
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldEnableAsset:(ALAsset *)asset
{
    // Enable video clips if they are at least 5s
    if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
    {
        NSTimeInterval duration = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
        return lround(duration) >= 5;
    }
    else
    {
        return YES;
    }
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset
{
    BOOL selectPhoto = NO;
    
    if (!asset.defaultRepresentation)
    {
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"提示"
                                   message:@"您的资源尚未下载到您的设备"
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"OK", nil];
        
        [alertView show];
    }
    else
    {
        NSInteger maxPicNum = 0;
        
        maxPicNum = mostImgCount;  //  9宫格
        
        if ((photoNum+cameraNum) >= maxPicNum){// update 2015.04.13
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:[NSString stringWithFormat:@"最多只能选择%ld张照片",(unsigned long)picker.selectedAssets.count]
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
            
            [alertView show];
            
            
            
            selectPhoto = NO;
            
        }else{
            
            photoNum ++;
            selectPhoto = YES;
        }
    }
    
    return (selectPhoto && asset.defaultRepresentation != nil);// update 2015.04.13
}


- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldDeselectAsset:(ALAsset *)asset{
    
    photoNum -- ;
    return YES;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
    
    //NSLog(@"拍照成功后放入图片数组");
    [self.assetsAndImgs addObject:image];
    
    for (int i=0; i<[buttonArray count]; i++) {
        [(UIButton*)[buttonArray objectAtIndex:i] removeFromSuperview];
    }
    [buttonArray removeAllObjects];
    [button_photoMask0 removeFromSuperview];
    
    UIImage *img = nil;
    
    for (int i=0; i<[self.assetsAndImgs count]; i++) {
        
        UIButton *button_photoMask = [UIButton buttonWithType:UIButtonTypeCustom];
        [button_photoMask setBackgroundImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal] ;
        [button_photoMask setBackgroundImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted] ;
        [buttonArray addObject:button_photoMask];
        
        if ([[self.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
            
            ALAsset *asset = [self.assetsAndImgs objectAtIndex:i];
            img = [UIImage imageWithCGImage:asset.thumbnail];
            
        }else{
            img = [self.assetsAndImgs objectAtIndex:i];
        }
        
        [[buttonArray objectAtIndex:i] setBackgroundImage:img forState:UIControlStateNormal] ;
        [[buttonArray objectAtIndex:i] setBackgroundImage:img forState:UIControlStateHighlighted];
        
        NSLog(@"tag0:%ld",(long)button_photoMask.tag);
    }
    
    
    UIButton *button_photoMask = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_photoMask setBackgroundImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal] ;
    [button_photoMask setBackgroundImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted] ;
    
    NSLog(@"tag:%ld",(long)button_photoMask.tag);
    [buttonArray addObject:button_photoMask];
    
    [self showImageButtonArray];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    cameraNum++;
    
}

-(void)showImageButtonArray
{
    NSLog(@"show array count:%lu",(unsigned long)[buttonArray count]);
    for (int i=0; i<[buttonArray count]; i++) {
        
        ((UIButton*)[buttonArray objectAtIndex:i]).tag = i+1;
        NSLog(@"["@"%d"@"].tag="@"%ld",i,(long)((UIButton*)[buttonArray objectAtIndex:i]).tag);
        [((UIButton*)[buttonArray objectAtIndex:i]) addTarget:self action:@selector(create_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        
        [self addSubview:((UIButton*)[buttonArray objectAtIndex:i])];
        
        
        //  9宫格
        if (i < mostImgCount) {
            ((UIButton*)[buttonArray objectAtIndex:i]).frame = CGRectMake((imgWidth+5)*(i%4),
                                                                          (imgWidth+5)*(i/4),
                                                                          imgWidth,
                                                                          imgWidth);
            
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, [UIScreen mainScreen].bounds.size.width,
                                    (imgWidth + 5)*( (((i+1)%4)>0?1:0) + (i+1)/4 ));
        }
        
    }
    

    
    
    if ([self.controller isKindOfClass:[OutsideReimbursementEditViewController class]]) {
        [((OutsideReimbursementEditViewController *)self.controller) updateSize:self];
    }
    
    
}

@end
