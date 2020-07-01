//
//  AddImagesTool.h
//  MicroSchool
//
//  Created by Kate's macmini on 16/2/1.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTAssetsPickerController.h"
#import "FullImageViewController.h"

@interface AddImagesTool : UIView<UIImagePickerControllerDelegate,UIAlertViewDelegate,CTAssetsPickerControllerDelegate,UIActionSheetDelegate,FullImageViewControllerDelegate,UINavigationControllerDelegate>{
    
    UIButton *button_photoMask0;
    id sender_btn;
    UIActionSheet *alertSheet;
    UIImagePickerController *imagePickerController;
    NSInteger pressButtonTag;
    NSMutableArray *pics;
    int cameraNum;
    int photoNum;
    NSMutableArray *buttonArray;
    NSMutableArray *deleteFlagArray;
    NSMutableArray *imageWithIdArray;

}
@property(nonatomic, assign) id controller;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSMutableArray *assetsAndImgs;
@property (nonatomic,strong)  NSMutableArray *buttonArray;
//- (id)initWithFrame:(CGRect)rect imgArray:(NSMutableArray*)array withViewController:(id)_controller;
- (void)drawAddImagesTool:(NSMutableArray*)array withViewController:(id)_controller;
@property(nonatomic,strong)NSMutableArray *imageWithIdArray;
@property(nonatomic,strong)NSMutableArray *deleteFlagArray;
@end
