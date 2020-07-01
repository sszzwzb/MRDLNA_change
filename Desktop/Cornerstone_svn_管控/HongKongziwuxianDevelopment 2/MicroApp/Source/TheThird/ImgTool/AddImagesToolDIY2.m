//
//  AddImagesToolDIY2.m
//  MicroSchool
//
//  Created by Kate's macmini on 16/2/1.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "AddImagesToolDIY2.h"
#import "AddImageUtilities.h"


#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>


#import "OnlyEditToEditViewController.h"
#import "OnlyEditPerToReEditViewController.h"

@interface AddImagesToolDIY2 () <UIImagePickerControllerDelegate,UIAlertViewDelegate,CTAssetsPickerControllerDelegate,UIActionSheetDelegate,FullImageViewControllerDelegate,UINavigationControllerDelegate>
{
    
    OnlyEditToEditTableViewCellImgAndText2 *button_photoMask0;
    UIImagePickerController *imagePickerController;
    NSInteger pressButtonTag;
    NSMutableArray *pics;
    NSInteger cameraNum;
    NSInteger photoNum;
    NSMutableArray *buttonArray;
    NSMutableArray *deleteFlagArray;
    NSMutableArray *imageWithIdArray;
    CGFloat imgWidth;
    
}
@end

@implementation AddImagesToolDIY2
@synthesize controller,buttonArray,imageWithIdArray,deleteFlagArray;

- (void)drawAddImagesToolDIY2:(NSMutableArray*)array withViewController:(id)_controller
{
    if (self) {
        
        self.controller = _controller;
        
        imgWidth = ([UIScreen mainScreen].bounds.size.width - 24.0 - 15.0)/4.0;
        
        if (array == nil || [array count] == 0) {
            
            // 加图片button
            button_photoMask0 = [[OnlyEditToEditTableViewCellImgAndText2 alloc]init];
            button_photoMask0.tag = 0;
            
            button_photoMask0.frame = CGRectMake(0,
                                                 0,
                                                 imgWidth,
                                                 imgWidth + 30);
            
            
            [button_photoMask0 setImage:[UIImage imageNamed:@"ImgAdd"] forState:UIControlStateNormal];
            [button_photoMask0 setImage:[UIImage imageNamed:@"ImgAdd"] forState:UIControlStateHighlighted];
            [button_photoMask0 setHiddenFortextContentBut:YES];
            
            
            [button_photoMask0 addTarget:self action:@selector(create_btnclick:) forControlEvents: UIControlEventTouchUpInside];
            
            [self addSubview:button_photoMask0];
            
            buttonArray = [[NSMutableArray alloc] init];
            
        }else{
            
            if (array[0][@"imageUrl"]) {
                //  网络图片
                
                buttonArray = [[NSMutableArray alloc] init];
                deleteFlagArray = [[NSMutableArray alloc] init];
                photoNum = [array count];
                
                if (!self.assetsAndImgs) {
                    self.assetsAndImgs = [[NSMutableArray alloc]init];
                }
                
                NSMutableArray *assetsAndImgsText = [NSMutableArray array];
                for (int i=0; i<[array count]; i++) {
                    
                    NSDictionary *dic = [array objectAtIndex:i];
                    
//                    [self.assetsAndImgs addObject:[dic objectForKey:@"image"]];
                    [assetsAndImgsText addObject:[Utilities replaceNull:[dic objectForKey:@"imgaText"]]];
                }
                imageWithIdArray = array;
                
                UIImage *img = nil;
                
                for (int i=0; i<[array count]; i++) {
                    
                    OnlyEditToEditTableViewCellImgAndText2 *button_photoMask = [[OnlyEditToEditTableViewCellImgAndText2 alloc]init];
                    [button_photoMask setImage:[UIImage imageNamed:@"ImgAdd"] forState:UIControlStateNormal] ;
                    [button_photoMask setImage:[UIImage imageNamed:@"ImgAdd"] forState:UIControlStateHighlighted] ;
                    [button_photoMask setHiddenFortextContentBut:YES];
                    [buttonArray addObject:button_photoMask];
                    
                    
                    OnlyEditToEditTableViewCellImgAndText2 *butTest = (OnlyEditToEditTableViewCellImgAndText2 *)[buttonArray objectAtIndex:i];
                    
                    [butTest sd_setImageWithURL:[NSURL URLWithString:array[i][@"imageUrl"]] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"loading"]];
                    [butTest sd_setImageWithURL:[NSURL URLWithString:array[i][@"imageUrl"]] forState:(UIControlStateHighlighted) placeholderImage:[UIImage imageNamed:@"loading"]];
                    
                    
                    butTest.textContent = [Utilities replaceNull:[assetsAndImgsText objectAtIndex:i]];
                    [butTest setHiddenFortextContentBut:NO];
                    
                    
                    [self.assetsAndImgs addObject:array[i][@"imageUrl"]];
                    
                    NSLog(@"tag0:%ld",(long)button_photoMask.tag);
                }
                
                
                OnlyEditToEditTableViewCellImgAndText2 *button_photoMask = [[OnlyEditToEditTableViewCellImgAndText2 alloc]init];
                
                
                [button_photoMask setImage:[UIImage imageNamed:@"ImgAdd"] forState:UIControlStateNormal] ;
                [button_photoMask setImage:[UIImage imageNamed:@"ImgAdd"] forState:UIControlStateHighlighted] ;
                [button_photoMask setHiddenFortextContentBut:YES];
                button_photoMask.tag = 0;
                
                
                //button_photoMask.tag = [self.assets count]+1;
                NSLog(@"tag:%ld",(long)button_photoMask.tag);
                [buttonArray addObject:button_photoMask];
                
                [self showImageButtonArray];
                
            } else {
                
                //  本地图片
                
                buttonArray = [[NSMutableArray alloc] init];
                deleteFlagArray = [[NSMutableArray alloc] init];
                photoNum = [array count];
                
                if (!self.assetsAndImgs) {
                    self.assetsAndImgs = [[NSMutableArray alloc]init];
                }
                
                NSMutableArray *assetsAndImgsText = [NSMutableArray array];
                for (int i=0; i<[array count]; i++) {
                    
                    NSDictionary *dic = [array objectAtIndex:i];
                    
                    [self.assetsAndImgs addObject:[dic objectForKey:@"image"]];
                    [assetsAndImgsText addObject:[Utilities replaceNull:[dic objectForKey:@"imgaText"]]];
                }
                imageWithIdArray = array;
                
                
                for (int i=0; i<[self.assetsAndImgs count]; i++) {
                    
                    UIImage *img = nil;
                    NSString *imgUrl = nil;
                    
                    OnlyEditToEditTableViewCellImgAndText2 *button_photoMask = [[OnlyEditToEditTableViewCellImgAndText2 alloc]init];
                    [button_photoMask setImage:[UIImage imageNamed:@"ImgAdd"] forState:UIControlStateNormal] ;
                    [button_photoMask setImage:[UIImage imageNamed:@"ImgAdd"] forState:UIControlStateHighlighted] ;
                    [button_photoMask setHiddenFortextContentBut:YES];
                    [buttonArray addObject:button_photoMask];
                    
                    if ([[self.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
                        
                        ALAsset *asset = [self.assetsAndImgs objectAtIndex:i];
                        img = [UIImage imageWithCGImage:asset.thumbnail];
                        
                    }else if ([[self.assetsAndImgs objectAtIndex:i] isKindOfClass:UIImage.class]) {
                        img = [self.assetsAndImgs objectAtIndex:i];
                    }else{
                        imgUrl = [self.assetsAndImgs objectAtIndex:i];
                    }
                    
                    OnlyEditToEditTableViewCellImgAndText2 *butTest = (OnlyEditToEditTableViewCellImgAndText2 *)[buttonArray objectAtIndex:i];
                    if (imgUrl) {
                        [butTest sd_setImageWithURL:[NSURL URLWithString:imgUrl] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"loading"]];
                        [butTest sd_setImageWithURL:[NSURL URLWithString:imgUrl] forState:(UIControlStateHighlighted) placeholderImage:[UIImage imageNamed:@"loading"]];
                    } else {
                        [butTest setImage:img forState:UIControlStateNormal] ;
                        [butTest setImage:img forState:UIControlStateHighlighted];
                    }
                    
                    butTest.textContent = [Utilities replaceNull:[assetsAndImgsText objectAtIndex:i]];
                    [butTest setHiddenFortextContentBut:NO];
                    
                    NSLog(@"tag0:%ld",(long)button_photoMask.tag);
                }
                
                
                OnlyEditToEditTableViewCellImgAndText2 *button_photoMask = [[OnlyEditToEditTableViewCellImgAndText2 alloc]init];
                
                
                [button_photoMask setImage:[UIImage imageNamed:@"ImgAdd"] forState:UIControlStateNormal] ;
                [button_photoMask setImage:[UIImage imageNamed:@"ImgAdd"] forState:UIControlStateHighlighted] ;
                [button_photoMask setHiddenFortextContentBut:YES];
                button_photoMask.tag = 0;
                
                //button_photoMask.tag = [self.assets count]+1;
                NSLog(@"tag:%ld",(long)button_photoMask.tag);
                [buttonArray addObject:button_photoMask];
                
                [self showImageButtonArray];
            }
            
            
            
            
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
    
    UIImage *img = [UIImage imageNamed:@"ImgAdd"];
    
    //if (![Utilities image:button.imageView.image equalsTo:img]) {
    if (![AddImageUtilities image:button.currentImage equalsTo:img]) {
        
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
        
        
        
        
        if ([self.controller isKindOfClass:[OnlyEditToEditViewController class]]) {
            FullImageViewController *fullImageViewController = [[FullImageViewController alloc] init];
            fullImageViewController.delegate = self;
            fullImageViewController.viewType = @"AddImagesTool";
            fullImageViewController.assetsArray = self.assetsAndImgs;
            fullImageViewController.currentIndex = pos;
            [((OnlyEditToEditViewController *)self.controller).navigationController pushViewController:fullImageViewController animated:YES];
        }
        
        if ([self.controller isKindOfClass:[OnlyEditPerToReEditViewController class]]) {
            FullImageViewController *fullImageViewController = [[FullImageViewController alloc] init];
            fullImageViewController.delegate = self;
            fullImageViewController.viewType = @"AddImagesTool";
            fullImageViewController.assetsArray = self.assetsAndImgs;
            fullImageViewController.currentIndex = pos;
            [((OnlyEditPerToReEditViewController *)self.controller).navigationController pushViewController:fullImageViewController animated:YES];
        }
        
        
        
    } else{
        if (!self.assetsAndImgs) {
            self.assetsAndImgs = [[NSMutableArray alloc]init];
        }

        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        sheet.tag = 400;
        sheet.actionSheetStyle = UIActionSheetStyleDefault;
        [sheet showInView:self];
        
        
       
        
        if ([self.controller isKindOfClass:[OnlyEditToEditViewController class]]){
            [((OnlyEditToEditViewController *)self.controller) dismissAllKeyBoardInView:((OnlyEditToEditViewController *)self.controller).view];
        }
        if ([self.controller isKindOfClass:[OnlyEditPerToReEditViewController class]]){
            [((OnlyEditPerToReEditViewController *)self.controller) dismissAllKeyBoardInView:((OnlyEditPerToReEditViewController *)self.controller).view];
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
        
        OnlyEditToEditTableViewCellImgAndText2 *butTest = (OnlyEditToEditTableViewCellImgAndText2 *)[buttonArray objectAtIndex:i-1];
        OnlyEditToEditTableViewCellImgAndText2 *butTest1 = (OnlyEditToEditTableViewCellImgAndText2 *)[buttonArray objectAtIndex:i];
        
        [(UIButton*)butTest setImage:((UIButton*)butTest1).currentImage forState:UIControlStateNormal] ;
        [(UIButton*)butTest setImage:((UIButton*)butTest1).currentImage forState:UIControlStateHighlighted] ;
        [butTest setHiddenFortextContentBut:NO];

        butTest.textContent = butTest1.textContent;
    }
    
    // 把最后面的一个button从父view中移除
    [(UIButton*)[buttonArray objectAtIndex:([buttonArray count]-1)] removeFromSuperview];
    
    OnlyEditToEditTableViewCellImgAndText2 *button = (OnlyEditToEditTableViewCellImgAndText2*)[self viewWithTag:pressButtonTag];
    

    
    if (button) {
        NSLog(@"Y");
    }else{
        NSLog(@"N");
    }
    [button removeFromSuperview];
    // 移除array最后的button
    [buttonArray removeLastObject];
    
    // 设置显示加号的button的图片
    OnlyEditToEditTableViewCellImgAndText2 *butTest = (OnlyEditToEditTableViewCellImgAndText2 *)[buttonArray objectAtIndex:([buttonArray count]-1)];
    [(UIButton*)butTest setImage:[UIImage imageNamed:@"ImgAdd"] forState:UIControlStateNormal] ;
    [(UIButton*)butTest setImage:[UIImage imageNamed:@"ImgAdd"] forState:UIControlStateHighlighted] ;
    [butTest setHiddenFortextContentBut:YES];
    
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
    //  选择相册
    if (actionSheet.tag == 400) {
        if (buttonIndex == 0) {
            
            [self openCamera];
            
        }else if (buttonIndex == 1){
            
            [self openPhoto];
            
        }
    } else {
        
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
    
    NSMutableArray *assetsAndImgsText = [NSMutableArray array];
    for (int i=0; i<[buttonArray count]; i++) {
        OnlyEditToEditTableViewCellImgAndText2 *butTest = (OnlyEditToEditTableViewCellImgAndText2 *)[buttonArray objectAtIndex:i];
        [assetsAndImgsText addObject:[Utilities replaceNull:butTest.textContent]];
        [(UIButton*)[buttonArray objectAtIndex:i] removeFromSuperview];
    }
    [buttonArray removeAllObjects];
    [button_photoMask0 removeFromSuperview];
    
    
    
    for (int i=0; i<[self.assetsAndImgs count]; i++) {
        
        UIImage *img = nil;
        NSString *imgUrl = nil;
        
        OnlyEditToEditTableViewCellImgAndText2 *button_photoMask = [[OnlyEditToEditTableViewCellImgAndText2 alloc]init];
        [button_photoMask setImage:[UIImage imageNamed:@"ImgAdd"] forState:UIControlStateNormal] ;
        [button_photoMask setImage:[UIImage imageNamed:@"ImgAdd"] forState:UIControlStateHighlighted] ;
        [button_photoMask setHiddenFortextContentBut:YES];
        
        [buttonArray addObject:button_photoMask];
        
        if ([[self.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
            
            ALAsset *asset = [self.assetsAndImgs objectAtIndex:i];
            img = [UIImage imageWithCGImage:asset.thumbnail];
            
        }else if ([[self.assetsAndImgs objectAtIndex:i] isKindOfClass:UIImage.class]) {
            img = [self.assetsAndImgs objectAtIndex:i];
        }else{
            imgUrl = [self.assetsAndImgs objectAtIndex:i];
        }
        
        OnlyEditToEditTableViewCellImgAndText2 *butTest = (OnlyEditToEditTableViewCellImgAndText2 *)[buttonArray objectAtIndex:i];
        if (imgUrl) {
            [butTest sd_setImageWithURL:[NSURL URLWithString:imgUrl] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"loading"]];
            [butTest sd_setImageWithURL:[NSURL URLWithString:imgUrl] forState:(UIControlStateHighlighted) placeholderImage:[UIImage imageNamed:@"loading"]];
        } else {
            [butTest setImage:img forState:UIControlStateNormal] ;
            [butTest setImage:img forState:UIControlStateHighlighted];
        }
        [button_photoMask setHiddenFortextContentBut:NO];
        
        if ([[Utilities replaceArrNull:assetsAndImgsText] count] > 0) {
            if ([[Utilities replaceArrNull:assetsAndImgsText] count] - 1 >= i) {
                butTest.textContent = [Utilities replaceNull:assetsAndImgsText[i]];
            }
        }
        
        NSLog(@"tag0:%ld",(long)button_photoMask.tag);
    }
    
    //  新加  不做frame
    OnlyEditToEditTableViewCellImgAndText2 *button_photoMask = [[OnlyEditToEditTableViewCellImgAndText2 alloc]init];
    
    [button_photoMask setImage:[UIImage imageNamed:@"ImgAdd"] forState:UIControlStateNormal] ;
    [button_photoMask setImage:[UIImage imageNamed:@"ImgAdd"] forState:UIControlStateHighlighted] ;
    [button_photoMask setHiddenFortextContentBut:YES];
    
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
        
        maxPicNum = 9;
        
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
    
    NSMutableArray *assetsAndImgsText = [NSMutableArray array];
    for (int i=0; i<[buttonArray count]; i++) {
        OnlyEditToEditTableViewCellImgAndText2 *butTest = (OnlyEditToEditTableViewCellImgAndText2 *)[buttonArray objectAtIndex:i];
        [assetsAndImgsText addObject:[Utilities replaceNull:butTest.textContent]];
        [(UIButton*)[buttonArray objectAtIndex:i] removeFromSuperview];
    }
    [buttonArray removeAllObjects];
    [button_photoMask0 removeFromSuperview];
    
    
    
    for (int i=0; i<[self.assetsAndImgs count]; i++) {
        
        UIImage *img = nil;
        NSString *imgUrl = nil;
        
        OnlyEditToEditTableViewCellImgAndText2 *button_photoMask = [[OnlyEditToEditTableViewCellImgAndText2 alloc]init];
        [button_photoMask setImage:[UIImage imageNamed:@"ImgAdd"] forState:UIControlStateNormal] ;
        [button_photoMask setImage:[UIImage imageNamed:@"ImgAdd"] forState:UIControlStateHighlighted] ;
        [button_photoMask setHiddenFortextContentBut:YES];
        [buttonArray addObject:button_photoMask];
        
        
        if ([[self.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
            
            ALAsset *asset = [self.assetsAndImgs objectAtIndex:i];
            img = [UIImage imageWithCGImage:asset.thumbnail];
            
        }else if ([[self.assetsAndImgs objectAtIndex:i] isKindOfClass:UIImage.class]) {
            img = [self.assetsAndImgs objectAtIndex:i];
        }else{
            imgUrl = [self.assetsAndImgs objectAtIndex:i];
        }
        
        OnlyEditToEditTableViewCellImgAndText2 *butTest = (OnlyEditToEditTableViewCellImgAndText2 *)[buttonArray objectAtIndex:i];
        if (imgUrl) {
            [butTest sd_setImageWithURL:[NSURL URLWithString:imgUrl] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"loading"]];
            [butTest sd_setImageWithURL:[NSURL URLWithString:imgUrl] forState:(UIControlStateHighlighted) placeholderImage:[UIImage imageNamed:@"loading"]];
        } else {
            [butTest setImage:img forState:UIControlStateNormal] ;
            [butTest setImage:img forState:UIControlStateHighlighted];
        }
        [button_photoMask setHiddenFortextContentBut:NO];
        
        if ([[Utilities replaceArrNull:assetsAndImgsText] count] > 0) {
            if ([[Utilities replaceArrNull:assetsAndImgsText] count] - 1 >= i) {
                butTest.textContent = [Utilities replaceNull:assetsAndImgsText[i]];
            }
        }
        
        NSLog(@"tag0:%ld",(long)button_photoMask.tag);
    }
    
    
    OnlyEditToEditTableViewCellImgAndText2 *button_photoMask = [[OnlyEditToEditTableViewCellImgAndText2 alloc]init];
    [button_photoMask setImage:[UIImage imageNamed:@"ImgAdd"] forState:UIControlStateNormal] ;
    [button_photoMask setImage:[UIImage imageNamed:@"ImgAdd"] forState:UIControlStateHighlighted] ;
    [button_photoMask setHiddenFortextContentBut:YES];
    
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
        
        OnlyEditToEditTableViewCellImgAndText2 *butTest = (OnlyEditToEditTableViewCellImgAndText2 *)[buttonArray objectAtIndex:i];
        
        ((UIButton*)butTest).tag = i+1;
        NSLog(@"["@"%d"@"].tag="@"%ld",i,(long)((UIButton*)[buttonArray objectAtIndex:i]).tag);
        
        
        [((UIButton*)butTest) addTarget:self action:@selector(create_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        
        [self addSubview:((UIButton*)[buttonArray objectAtIndex:i])];
        
        
        if (i<3) {
            
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, [UIScreen mainScreen].bounds.size.width, imgWidth + 30);
            
            ((UIButton*)[buttonArray objectAtIndex:i]).frame = CGRectMake(5*(i)+imgWidth*i,
                                                                          0,
                                                                          imgWidth,
                                                                          imgWidth + 30);
            
        }
        else if (i>=3 && i<6) {
            
//            if ([buttonArray count] != i+1) {  //  直接显示的数据，如果超过3个以后不能继续创建
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, [UIScreen mainScreen].bounds.size.width, (imgWidth+30)*2+5 + 15);
                
                ((UIButton*)[buttonArray objectAtIndex:i]).frame = CGRectMake(5*(i-3)+imgWidth*(i-3),
                                                                              0+imgWidth + 30 + 15,
                                                                              imgWidth,
                                                                              imgWidth + 30);
//            }
        }
        else if (i>=6 && i <9) {

//            if ([buttonArray count] != i+1) {
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, [UIScreen mainScreen].bounds.size.width, (imgWidth+30)*3+5*2 + 30);
                
                ((UIButton*)[buttonArray objectAtIndex:i]).frame = CGRectMake(5*(i-6)+imgWidth*(i-6),
                                                                              0+imgWidth + 30+imgWidth + 30 + 30,  //cao
                                                                              imgWidth,
                                                                              imgWidth + 30);
            }
//        }
    }
    

    
    
    
    if ([self.controller isKindOfClass:[OnlyEditToEditViewController class]]) {
        [((OnlyEditToEditViewController *)self.controller) updateSize:self];
    }
    if ([self.controller isKindOfClass:[OnlyEditPerToReEditViewController class]]) {
        [((OnlyEditPerToReEditViewController *)self.controller) updateSize:self];
    }
    
    
   
    
}

@end





@interface OnlyEditToEditTableViewCellImgAndText2 ()

@property (nonatomic,strong) UIButton *butDownNote;
@property (nonatomic,strong) UIButton *butAdd;

@end

@implementation OnlyEditToEditTableViewCellImgAndText2

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self up_view];
    }
    return self;
}

-(void)up_view
{
    self.backgroundColor = [UIColor whiteColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.imageView.backgroundColor = [UIColor clearColor];
    
    CGFloat imgWidth = ([UIScreen mainScreen].bounds.size.width - 24.0 - 15.0)/4.0;
    
    
    //   查看备注图片
    _butDownNote = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:_butDownNote];
    _butDownNote.frame = CGRectMake(10, imgWidth + 12, imgWidth - 20, 18);
    _butDownNote.layer.cornerRadius = CGRectGetHeight(_butDownNote.frame)/2;
    _butDownNote.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _butDownNote.layer.borderWidth = 0.8f;
    [_butDownNote setTitle:@"添加备注" forState:(UIControlStateNormal)];
    [_butDownNote setTitle:@"查看备注" forState:(UIControlStateSelected)];
    _butDownNote.titleLabel.font = FONT(11.f);
    [_butDownNote setTitleColor:color_black forState:(UIControlStateNormal)];
    [_butDownNote setTitleColor:color_black forState:(UIControlStateSelected)];
    _butDownNote.tag = 501;
    [_butDownNote addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    _butDownNote.hidden = YES;
    
}


-(void)buttonAction:(UIButton *)button
{
    if (button.tag == 501) {
        NSLog(@"点击备注");
        
        [self upAlertView];
        
    }
}



-(void)setTextContent:(NSString *)textContent
{
    _textContent = textContent;
    
    if ([[Utilities replaceNull:_textContent] isEqualToString:@""]) {
        _butDownNote.selected = NO;
        _butDownNote.backgroundColor = [UIColor whiteColor];
    } else {
        _butDownNote.selected = YES;
        _butDownNote.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, contentRect.size.width, contentRect.size.width);
}

-(void)setHiddenFortextContentBut:(BOOL)hidden
{
    _butDownNote.hidden = hidden;
    if (hidden) {
        _textContent = @"";
    }
}





-(void)upAlertView
{
    OnlyEditToEditTableHeaderAlertView2 *alertV = [[OnlyEditToEditTableHeaderAlertView2 alloc]init];
    
    alertV.curText = [Utilities replaceNull:_textContent];
    
    alertV.getSelectText = ^(NSString *dicSelectText) {
        _textContent = dicSelectText;
        
        if ([[Utilities replaceNull:_textContent] isEqualToString:@""]) {
            _butDownNote.selected = NO;
            _butDownNote.backgroundColor = [UIColor whiteColor];
        } else {
            _butDownNote.selected = YES;
            _butDownNote.backgroundColor = [UIColor groupTableViewBackgroundColor];
        }
    };
}



@end


@interface OnlyEditToEditTableHeaderAlertView2 () <UITextViewDelegate>

@property (nonatomic,strong) PlaceholderTextView *textV;

@end

@implementation OnlyEditToEditTableHeaderAlertView2

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self up_view];
    }
    return self;
}


-(void)up_view
{
    
    _curText = [NSString string];
    
    //   整体的按键
    UIButton *pickerView_bg_gray = [UIButton buttonWithType:(UIButtonTypeSystem)];
    pickerView_bg_gray.frame = [UIScreen mainScreen].bounds;
    pickerView_bg_gray.backgroundColor = color_blackAlpha;
    //  取消
    [pickerView_bg_gray addTarget:self action:@selector(btnCancelAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:pickerView_bg_gray];
    
    
    
    
    //  白色弹窗
    UIView *rootViewBackGround = [[UIView alloc]initWithFrame:
                                  CGRectMake((KScreenWidth-280)/2, (KScreenHeight - 250)/2 - 90, 280 , 250)];
    [self addSubview:rootViewBackGround];
    rootViewBackGround.backgroundColor = [UIColor whiteColor];
    
    
    //   选择机型
    UILabel *labTitle = [[UILabel alloc]initWithFrame:
                         CGRectMake(0, 0, CGRectGetWidth(rootViewBackGround.frame), 50)];
    [rootViewBackGround addSubview:labTitle];
    labTitle.text = @"备注";
    labTitle.textAlignment = NSTextAlignmentCenter;
    labTitle.textColor = color_black;
    
    
    //  线
    UIImageView *viewXian = [[UIImageView alloc]initWithFrame:
                             CGRectMake(0, 50 - 0.5, KScreenWidth, 0.5)];
    [rootViewBackGround addSubview:viewXian];
    viewXian.image = [UIImage imageNamed:@"lineSystem"];
    
    
    
    //  关闭
    UIButton *butClose = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [rootViewBackGround addSubview:butClose];
    butClose.frame = CGRectMake(0, 0, 60, CGRectGetHeight(labTitle.frame));
    [butClose setTitle:@"关闭" forState:(UIControlStateNormal)];
    [butClose setTitleColor:color_black forState:(UIControlStateNormal)];
    butClose.titleLabel.font = FONT(14.f);
    [butClose addTarget:self action:@selector(btnCancelAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    
    _textV = [[PlaceholderTextView alloc]initWithFrame:
                   CGRectMake(0, 50, CGRectGetWidth(rootViewBackGround.frame), CGRectGetHeight(rootViewBackGround.frame) - 100)];
    [rootViewBackGround addSubview:_textV];
    _textV.backgroundColor = [UIColor whiteColor];
    _textV.delegate = self;
    _textV.font = FONT(15.f);
    _textV.placeHolderLabel.font = FONT(15.f);
    _textV.placeholder = @"请填写相关信息";
    [_textV becomeFirstResponder];
    
    
    //  确定
    UIButton *butOK = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [rootViewBackGround addSubview:butOK];
    butOK.frame = CGRectMake(20, CGRectGetMaxY(_textV.frame) + (50 - 32)/2, CGRectGetWidth(rootViewBackGround.frame) - 40, 32);
    butOK.layer.masksToBounds = YES;
    butOK.layer.cornerRadius = CGRectGetHeight(butOK.frame)/2;
    [butOK setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [butOK setTitle:@"确定" forState:(UIControlStateNormal)];
    [butOK addTarget:self action:@selector(btnSureAction) forControlEvents:(UIControlEventTouchUpInside)];
    [butOK setBackgroundImage:[UIImage imageNamed:@"nav14"] forState:(UIControlStateNormal)];
    
    
    //  线
    UIImageView *viewXian1 = [[UIImageView alloc]initWithFrame:
                              CGRectMake(0, CGRectGetHeight(rootViewBackGround.frame) - 50 - 0.5, KScreenWidth, 0.5)];
    [rootViewBackGround addSubview:viewXian1];
    viewXian1.image = [UIImage imageNamed:@"lineSystem"];
    
    [self showKyTypePicker];
    
}

-(void)setCurText:(NSString *)curText
{
    _textV.text = curText;
    _curText = curText;
}

-(void)btnCancelAction
{
    [self removeFromSuperview];
}

-(void)btnSureAction
{
    _curText = _textV.text;
    if (_getSelectText) {
        _getSelectText(_curText);
    }
    [self removeFromSuperview];
}

//    让这个界面为主
- (void)showKyTypePicker{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.center = [UIApplication sharedApplication].keyWindow.center;
    self.frame = [UIApplication sharedApplication].keyWindow.frame;
}

//   确认，或者退出的时候，清空这个页面
-(void)disMissTypePicker{
    [self removeFromSuperview];
}

@end
