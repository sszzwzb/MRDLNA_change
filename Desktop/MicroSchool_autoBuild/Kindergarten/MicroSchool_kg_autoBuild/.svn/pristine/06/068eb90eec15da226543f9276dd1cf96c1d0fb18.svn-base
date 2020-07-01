//
//  KnowledgeOrderItemModel.m
//  MicroSchool
//
//  Created by jojo on 15/2/12.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "KnowledgeOrderItemModel.h"

@implementation KnowledgeOrderItemModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"protocol":@"protocol",
             @"result":@"result",
             
             @"teacherName":@"message.teacher.name",
             
             @"orderOid":@"message.order.oid",
             @"orderItem":@"message.order.item",
             @"orderPrice":@"message.order.price",

             @"payment":@"message.payment",
             };
}

- (void)setNilValueForKey:(NSString *)key
{
    // For NSInteger/CGFloat/BOOL
    [self setValue:@0 forKey:key];
}

+ (NSValueTransformer *)teacherNameJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id inObj) {
        if (inObj == nil || inObj == [NSNull null]) {
            return [NSString stringWithFormat:@""];
        } else {
            return inObj;
        }
    }];
}

+ (NSValueTransformer *)orderOidJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id inObj) {
        if (inObj == nil || inObj == [NSNull null]) {
            return [NSString stringWithFormat:@""];
        } else {
            return inObj;
        }
    }];
}

+ (NSValueTransformer *)orderItemJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id inObj) {
        if (inObj == nil || inObj == [NSNull null]) {
            return [NSString stringWithFormat:@""];
        } else {
            return inObj;
        }
    }];
}

+ (NSValueTransformer *)orderPriceJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id inObj) {
        if (inObj == nil || inObj == [NSNull null]) {
            return [NSString stringWithFormat:@""];
        } else {
            return inObj;
        }
    }];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error
{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    
    // Store a value that needs to be determined locally upon initialization.
    //     _retrievedAt = [NSDate date];
    
    return self;
}

@end
