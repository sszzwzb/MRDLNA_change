//
//  MomentsDetailObject.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/5/15.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MomentsDetailObject : NSObject{
    
    NSString *uid;
    
}

#pragma mark -
#pragma mark 属性
//DB中的字段
//动态id
@property(nonatomic,strong)NSString *momentId;
//动态类型-发现动态or我的动态
@property(nonatomic,strong)NSString *momentType;
//json串
@property(nonatomic,strong)NSString *jsonStr;

@property(nonatomic,strong)NSString *page;


#pragma mark -
#pragma mark DB相关方法

- (BOOL)updateToDB;

@end
