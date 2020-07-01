//
//  QHCamError.h
//  QHCamSDK
//
//  Created by chengbao on 16/4/4.
//  Copyright © 2016年 qihoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QHCamError : NSObject

@property(nonatomic, assign) int code;
@property(nonatomic, copy) NSString *msg;

@end
