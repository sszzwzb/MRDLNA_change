//
//  ReadStatusObject.h
//  MicroSchool
//
//  Created by CheungStephen on 2/20/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GlobalSingletonUserInfo.h"
#import "ReadStatusDBDao.h"

@interface ReadStatusObject : NSObject

@property (nonatomic, assign) NSString *uid;
@property (nonatomic, assign) NSString *readId;

// 0为未读，1为已读
// 为了扩展而采用的字符串方式进行存储，未来可以存储更多状态。
@property (nonatomic, assign) NSString *status;

- (BOOL)updateToDB;
- (BOOL)isExistInDB;

@end
