//
//  KnowledgeOrderItemModel.h
//  MicroSchool
//
//  Created by jojo on 15/2/12.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "MTLModel.h"

#import "Mantle/Mantle.h"

@interface KnowledgeOrderItemModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *protocol;
@property (nonatomic, strong) NSNumber *result;

@property (nonatomic, strong) NSString *teacherName;
@property (nonatomic, strong) NSString *orderOid;
@property (nonatomic, strong) NSString *orderItem;
@property (nonatomic, strong) NSNumber *orderPrice;

// 付款方式
@property (nonatomic, retain) NSArray *payment;

@end
