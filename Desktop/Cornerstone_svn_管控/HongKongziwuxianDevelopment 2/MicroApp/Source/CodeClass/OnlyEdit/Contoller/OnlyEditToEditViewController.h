//
//  OnlyEditToEditViewController.h
//  MicroApp
//
//  Created by kaiyi on 2018/10/9.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "BaseViewController.h"

@class OnlyEditPerSQLModel;

typedef NS_ENUM(NSInteger, OnlyEditToEdittypeEnum) {
    isNewEdit = 0,  //  新建
    isCanEdit,  //   可以编辑的
    isReadOnly,  //   只读的
};


NS_ASSUME_NONNULL_BEGIN

@interface OnlyEditToEditViewController : BaseViewController

@property (nonatomic,assign) OnlyEditToEdittypeEnum type;
@property (nonatomic,strong) OnlyEditPerSQLModel *selectModel;  //  选择的Cell  可编辑的

-(void)updateSize:(UIView*)view;
-(void)dismissAllKeyBoardInView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
