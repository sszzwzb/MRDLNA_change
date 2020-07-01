//
//  OnlyEditPerToReEditViewController.h
//  MicroApp
//
//  Created by kaiyi on 2018/10/22.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "BaseViewController.h"

@class OnlyEditPerSQLModel;

NS_ASSUME_NONNULL_BEGIN

@interface OnlyEditPerToReEditViewController : BaseViewController

@property (nonatomic,strong) OnlyEditPerSQLModel *selectModel;  //  选择的Cell  可编辑的

-(void)updateSize:(UIView*)view;
-(void)dismissAllKeyBoardInView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
