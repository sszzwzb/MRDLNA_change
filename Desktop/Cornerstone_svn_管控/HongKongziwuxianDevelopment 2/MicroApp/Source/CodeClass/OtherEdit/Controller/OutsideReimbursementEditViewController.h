//
//  OutsideReimbursementViewController.h
//  MicroApp
//
//  Created by kaiyi on 2018/10/13.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OutsideReimbursementEditViewController : BaseViewController

@property (nonatomic,assign) NSInteger type;  //  外采报销0   剩余油量1

-(void)updateSize:(UIView*)view;
-(void)dismissAllKeyBoardInView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
