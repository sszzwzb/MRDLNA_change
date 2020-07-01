//
//  ChangeLanguage.h
//  DoubleLanguage
//
//  Created by kaiyi on 2019/1/15.
//  Copyright © 2019年 kaiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChangeLanguage : NSObject

+(NSBundle *)bundle;//获取当前资源文件   [NSBundle mainBundle]  系统方法

+(void)initUserLanguage;//初始化语言文件

+(NSString *)userLanguage;//获取应用当前语言

+(void)setUserlanguage:(NSString *)language;//设置当前语言


@end

NS_ASSUME_NONNULL_END
