//
//  AddImagesToolDIY2.h
//  MicroSchool
//
//  Created by Kate's macmini on 16/2/1.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTAssetsPickerController.h"
#import "FullImageViewController.h"

@interface AddImagesToolDIY2 : UIView


@property(nonatomic, assign) id controller;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSMutableArray *assetsAndImgs;
@property (nonatomic,strong)  NSMutableArray *buttonArray;


- (void)drawAddImagesToolDIY2:(NSMutableArray*)array withViewController:(id)_controller;
@property(nonatomic,strong)NSMutableArray *imageWithIdArray;
@property(nonatomic,strong)NSMutableArray *deleteFlagArray;

@end







@interface OnlyEditToEditTableViewCellImgAndText2 : UIButton

@property (nonatomic,strong) NSString *textContent;  //  备注
-(void)setHiddenFortextContentBut:(BOOL)hidden;  //   备注按键，显示，隐藏

@end


#import "PlaceholderTextView.h"

@interface OnlyEditToEditTableHeaderAlertView2 : UIView

typedef void (^getSelectText) (NSString *dicSelectText);
@property (nonatomic,strong) getSelectText getSelectText;

@property (nonatomic,strong) NSString *curText;

@end
