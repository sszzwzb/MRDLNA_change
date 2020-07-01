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

@interface AddImagesTool : UIView


@property(nonatomic, assign) id controller;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSMutableArray *assetsAndImgs;
@property (nonatomic,strong)  NSMutableArray *buttonArray;


- (void)drawAddImagesTool:(NSMutableArray*)array withViewController:(id)_controller mostImgCount:(NSInteger)mostImgCountInt;
@property(nonatomic,strong)NSMutableArray *imageWithIdArray;
@property(nonatomic,strong)NSMutableArray *deleteFlagArray;

@end
