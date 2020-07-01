//
//  AddImagesTool.m
//  MicroSchool
//
//  Created by Kate's macmini on 16/2/1.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "AddImagesTool.h"
#import "Utilities.h"
#import "SubmitHWViewController.h"
#import "HomeworkDetailUploadViewController.h"
#import "RecipeUploadViewController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

@implementation AddImagesTool
@synthesize controller,buttonArray,imageWithIdArray,deleteFlagArray;

//- (id)initWithFrame:(CGRect)rect imgArray:(NSMutableArray*)array withViewController:(id)_controller
//{
//    self = [super init];
//    
//    if (self) {
//        
//        if (array == nil || [array count] == 0) {
//            
//            self.frame = rect;
//            // 加图片button
//            button_photoMask0 = [UIButton buttonWithType:UIButtonTypeCustom];
//            button_photoMask0.tag = 1;
//            //[buttonArray addObject:button_photoMask0];
//            button_photoMask0.frame = CGRectMake(0,
//                                                 0,
//                                                 70,
//                                                 70);
//            [button_photoMask0 setImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal];
//            [button_photoMask0 setImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted];
//            [button_photoMask0 addTarget:self action:@selector(create_btnclick:) forControlEvents: UIControlEventTouchUpInside];
//            [self addSubview:button_photoMask0];
//            
//            buttonArray = [[NSMutableArray alloc] init];
//            
//        }else{
//            
//            //To do:重置frame
//            buttonArray = [[NSMutableArray alloc] init];
//            
//            
//        }
//        
//        self.controller = _controller;
//        
//    }
//    
//    return self;
//}

- (void)drawAddImagesTool:(NSMutableArray*)array withViewController:(id)_controller
{
    if (self) {
        
        self.controller = _controller;
        
        if (array == nil || [array count] == 0) {
            
            // 加图片button
            button_photoMask0 = [UIButton buttonWithType:UIButtonTypeCustom];
            button_photoMask0.tag = 1;
            //[buttonArray addObject:button_photoMask0];
            button_photoMask0.frame = CGRectMake(0,
                                                 0,
                                                 70,
                                                 70);
            [button_photoMask0 setImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal];
            [button_photoMask0 setImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted];
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
                if ([dic objectForKey:@"image"]) {//容错 可能为nil导致crash
                    [self.assetsAndImgs addObject:[dic objectForKey:@"image"]];
                }
                
            }
            imageWithIdArray = array;
            //[self.assetsAndImgs addObjectsFromArray:array];
            
            UIImage *img = nil;
            
            for (int i=0; i<[self.assetsAndImgs count]; i++) {
                
                UIButton *button_photoMask = [UIButton buttonWithType:UIButtonTypeCustom];
                [button_photoMask setImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal] ;
                [button_photoMask setImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted];
                [buttonArray addObject:button_photoMask];
                
                if ([[self.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
                    
                    ALAsset *asset = [self.assetsAndImgs objectAtIndex:i];
                    img = [UIImage imageWithCGImage:asset.thumbnail];
                    
                }else{
                    img = [self.assetsAndImgs objectAtIndex:i];
                }
                
                [[buttonArray objectAtIndex:i] setImage:img forState:UIControlStateNormal] ;
                [[buttonArray objectAtIndex:i] setImage:img forState:UIControlStateHighlighted];
                
                NSLog(@"tag0:%ld",(long)button_photoMask.tag);
            }
            
            
            UIButton *button_photoMask = [UIButton buttonWithType:UIButtonTypeCustom];
            [button_photoMask setImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal] ;
            [button_photoMask setImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted] ;
            //button_photoMask.tag = [self.assets count]+1;
            NSLog(@"tag:%ld",(long)button_photoMask.tag);
            [buttonArray addObject:button_photoMask];
            
            [self showImageButtonArray];
            
        }
        
    }
    //deletePhoto_Tool
}

// 点击+号添加图片
-(void)create_btnclick:(id)sender{
    
    sender_btn = sender;
    
    UIButton *button = (UIButton *)sender;
    pressButtonTag = button.tag;
    
    UIImage *img = [UIImage imageNamed:@"addImg_press.png"];
    
    if (![Utilities image:button.imageView.image equalsTo:img]) {
        
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
        
        //NSInteger pos = [Utilities findStringPositionInArray:pics andImg:image];
        NSInteger pos = pressButtonTag - 1;
        
//        去viewController页处理
        if ([self.controller isKindOfClass:[SubmitHWViewController class]]) {
            
            [((SubmitHWViewController *)self.controller).text_content resignFirstResponder];
            [((SubmitHWViewController *)self.controller).text_answer resignFirstResponder];
            [((SubmitHWViewController *)self.controller).text_time resignFirstResponder];
            [((SubmitHWViewController *)self.controller).text_title resignFirstResponder];
            
            FullImageViewController *fullImageViewController = [[FullImageViewController alloc] init];
            fullImageViewController.delegate = self;
            fullImageViewController.viewType = @"AddImagesTool";
            fullImageViewController.assetsArray = self.assetsAndImgs;
            fullImageViewController.currentIndex = pos;
            [((SubmitHWViewController *)self.controller).navigationController pushViewController:fullImageViewController animated:YES];
        }else if ([self.controller isKindOfClass:[HomeworkDetailUploadViewController class]]) {
            FullImageViewController *fullImageViewController = [[FullImageViewController alloc] init];
            fullImageViewController.delegate = self;
            fullImageViewController.viewType = @"AddImagesTool";
            fullImageViewController.assetsArray = self.assetsAndImgs;
            fullImageViewController.currentIndex = pos;
            [((SubmitHWViewController *)self.controller).navigationController pushViewController:fullImageViewController animated:YES];
        }else if ([self.controller isKindOfClass:[RecipeUploadViewController class]]) {
            FullImageViewController *fullImageViewController = [[FullImageViewController alloc] init];
            fullImageViewController.delegate = self;
            fullImageViewController.viewType = @"AddImagesTool";
            fullImageViewController.assetsArray = self.assetsAndImgs;
            fullImageViewController.currentIndex = pos;
            [((SubmitHWViewController *)self.controller).navigationController pushViewController:fullImageViewController animated:YES];
        }
    } else {
        
        if (!self.assetsAndImgs) {
            self.assetsAndImgs = [[NSMutableArray alloc]init];
        }
        
        if (!alertSheet) {
            alertSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        }
        [alertSheet showInView:self];
        
        if ([self.controller isKindOfClass:[SubmitHWViewController class]]) {
            [((SubmitHWViewController *)self.controller).text_content resignFirstResponder];
            [((SubmitHWViewController *)self.controller).text_answer resignFirstResponder];
            [((SubmitHWViewController *)self.controller).text_time resignFirstResponder];
            [((SubmitHWViewController *)self.controller).text_title resignFirstResponder];
        }
//        else if ([self.controller isKindOfClass:[RecipeUploadViewController class]]) {
//            [((RecipeUploadViewController *)self.controller).text_content resignFirstResponder];
//            [((RecipeUploadViewController *)self.controller).text_answer resignFirstResponder];
//            [((RecipeUploadViewController *)self.controller).text_time resignFirstResponder];
//            [((RecipeUploadViewController *)self.controller).text_title resignFirstResponder];
//        }
        
    }
}

// 删除照片
-(void)getDeleteIndex:(NSString*)currentIndex
{
    // done: 在查看大图页点击删除走回这个方法,将index传回来
    //NSString *currentIndex = (NSString*)[notification object];
    pressButtonTag = [currentIndex integerValue]+1;
    
    // 是否删除图片
    for (int i = pressButtonTag; i< [buttonArray count]; i++) {
        // 把点击的button之后的每个button的图片设置为这个button后面button的图片 草
        [(UIButton*)[buttonArray objectAtIndex:i-1] setImage:((UIButton*)[buttonArray objectAtIndex:i]).imageView.image forState:UIControlStateNormal] ;
        [(UIButton*)[buttonArray objectAtIndex:i-1] setImage:((UIButton*)[buttonArray objectAtIndex:i]).imageView.image forState:UIControlStateHighlighted] ;
    }
    
    // 把最后面的一个button从父view中移除
    [(UIButton*)[buttonArray objectAtIndex:([buttonArray count]-1)] removeFromSuperview];
    //NSLog(@"viewWithTag:%d",pressButtonTag);
    UIButton *button = (UIButton*)[self viewWithTag:pressButtonTag];
    //NSLog(@"lastTag:%d",button.tag);
    if (button) {
        NSLog(@"Y");
    }else{
        NSLog(@"N");
    }
    [button removeFromSuperview];
    // 移除array最后的button
    [buttonArray removeLastObject];
    
    
    //NSLog(@"delete count:%d",[buttonArray count]);
    
    // 设置显示加号的button的图片
    [(UIButton*)[buttonArray objectAtIndex:([buttonArray count]-1)] setImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal];
    [(UIButton*)[buttonArray objectAtIndex:([buttonArray count]-1)] setImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted];
    
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
        //------------------------------------------------------------------------------
        
    }
    
//    [photoSelectButton setBackgroundImage:[UIImage imageNamed:@"addImage.png"] forState:UIControlStateNormal] ;
//    [photoSelectButton setBackgroundImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted] ;

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
        
        
        //if (!picker) {
        CTAssetsPickerController  *picker = [[CTAssetsPickerController alloc] init];
        //}
        
        picker.assetsFilter         = [ALAssetsFilter allPhotos];
        picker.showsCancelButton    = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);
        picker.delegate             = self;
        picker.selectedAssets       = [NSMutableArray arrayWithArray:self.assets];
        
        
        // iPad
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//        {
//            self.popover = [[UIPopoverController alloc] initWithContentViewController:picker];
//            self.popover.delegate = self;
//            
//            [self.popover presentPopoverFromBarButtonItem:sender_btn
//                                 permittedArrowDirections:UIPopoverArrowDirectionAny
//                                                 animated:YES];
//        }
//        else
        {
            [self.controller presentViewController:picker animated:YES completion:nil];
        }
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
        [button_photoMask setImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal] ;
        [button_photoMask setImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted] ;
        //button_photoMask.tag = i+1;
        [buttonArray addObject:button_photoMask];
        
        if ([[self.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
            
            ALAsset *asset = [self.assetsAndImgs objectAtIndex:i];
            img = [UIImage imageWithCGImage:asset.thumbnail];
            
        }else{
            img = [self.assetsAndImgs objectAtIndex:i];
        }
        
        [[buttonArray objectAtIndex:i] setImage:img forState:UIControlStateNormal] ;
        [[buttonArray objectAtIndex:i] setImage:img forState:UIControlStateHighlighted];
        
        NSLog(@"tag0:%ld",(long)button_photoMask.tag);
    }
    
    
    UIButton *button_photoMask = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_photoMask setImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal] ;
    [button_photoMask setImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted] ;
    //button_photoMask.tag = [self.assets count]+1;
    NSLog(@"tag:%ld",(long)button_photoMask.tag);
    [buttonArray addObject:button_photoMask];
    
    [self showImageButtonArray];
    
    //[text_content becomeFirstResponder];
    //--------------------------------------------------
    
    
}

- (void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker{
    
    //[text_content becomeFirstResponder];
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
    //if (picker.selectedAssets.count >= 9)
    //else if ((picker.selectedAssets.count + cameraNum) >= 9)// update 2015.04.13
    else
    {
        if ((photoNum+cameraNum) >= 9){// update 2015.04.13
            //Chenth  将(unsigned long)picker.selectedAssets.count] 改成了photoNum+cameraNum
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:[NSString stringWithFormat:@"最多只能选择%d张照片",photoNum+cameraNum]
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
    
    //return (picker.selectedAssets.count < 9 && asset.defaultRepresentation != nil);
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
        [button_photoMask setImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal] ;
        [button_photoMask setImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted] ;
        //button_photoMask.tag = i+1;
        [buttonArray addObject:button_photoMask];
        
        if ([[self.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
            
            ALAsset *asset = [self.assetsAndImgs objectAtIndex:i];
            img = [UIImage imageWithCGImage:asset.thumbnail];
            
        }else{
            img = [self.assetsAndImgs objectAtIndex:i];
        }
        
        [[buttonArray objectAtIndex:i] setImage:img forState:UIControlStateNormal] ;
        [[buttonArray objectAtIndex:i] setImage:img forState:UIControlStateHighlighted];
        
        NSLog(@"tag0:%ld",(long)button_photoMask.tag);
    }
    
    
    UIButton *button_photoMask = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_photoMask setImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal] ;
    [button_photoMask setImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted] ;
    //button_photoMask.tag = [self.assets count]+1;
    NSLog(@"tag:%ld",(long)button_photoMask.tag);
    [buttonArray addObject:button_photoMask];
    
    [self showImageButtonArray];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //[text_content becomeFirstResponder];
    
    cameraNum++;
    
}

-(void)showImageButtonArray
{
    NSLog(@"show array count:%lu",(unsigned long)[buttonArray count]);
    for (int i=0; i<[buttonArray count]; i++) {
        
        ((UIButton*)[buttonArray objectAtIndex:i]).tag = i+1;
        NSLog(@"["@"%d"@"].tag="@"%ld",i,(long)((UIButton*)[buttonArray objectAtIndex:i]).tag);
        [((UIButton*)[buttonArray objectAtIndex:i]) addTarget:self action:@selector(create_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        //[((UIButton*)[buttonArray objectAtIndex:i]) removeFromSuperview];
        //[self removeButtonWithTag:((UIButton*)[buttonArray objectAtIndex:i]).tag];
        [self addSubview:((UIButton*)[buttonArray objectAtIndex:i])];
        
        if (i<=3) {
            
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, WIDTH, 70.0);
            
            ((UIButton*)[buttonArray objectAtIndex:i]).frame = CGRectMake(5*(i)+70*i,
                                                                          0,
                                                                          70,
                                                                          70);
        } else if (i>3 && i<=7) {
            
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, WIDTH, 140.0);
            
            ((UIButton*)[buttonArray objectAtIndex:i]).frame = CGRectMake(5*(i-4)+70*(i-4),
                                                                          0+70+5,
                                                                          70,
                                                                          70);
        } else if (i>7 && i <9) {
            
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, WIDTH, 210.0);
            
            ((UIButton*)[buttonArray objectAtIndex:i]).frame = CGRectMake(5*(i-8)+70*(i-8),
                                                                          0+70+5+70+5,  //cao
                                                                          70,
                                                                          70);
        }
    }
    
    if ([self.controller isKindOfClass:[SubmitHWViewController class]]){
        
        [((SubmitHWViewController *)self.controller) updateSize:self];
    }else if ([self.controller isKindOfClass:[HomeworkDetailUploadViewController class]]) {
        [((HomeworkDetailUploadViewController *)self.controller) updateSize:self];
    }else if ([self.controller isKindOfClass:[RecipeUploadViewController class]]) {
        [((RecipeUploadViewController *)self.controller) updateSize:self];
    }
   
}

@end
