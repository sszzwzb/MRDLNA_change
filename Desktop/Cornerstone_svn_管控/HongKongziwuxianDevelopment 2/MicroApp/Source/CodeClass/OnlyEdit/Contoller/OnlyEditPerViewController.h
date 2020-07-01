//
//  OnlyEditPerViewController.h
//  MicroApp
//
//  Created by kaiyi on 2018/10/8.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OnlyEditPerViewController : BaseViewController

@property (nonatomic,strong) NSString *type;  //   工作任务0  待上传1  已完成2

@end

NS_ASSUME_NONNULL_END
