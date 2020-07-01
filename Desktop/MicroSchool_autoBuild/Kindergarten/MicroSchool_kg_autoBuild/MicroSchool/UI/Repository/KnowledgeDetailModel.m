//
//  KnowledgeDetailModel.m
//  MicroSchool
//
//  Created by jojo on 15/2/15.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "KnowledgeDetailModel.h"

@implementation KnowledgeDetailModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"protocol":@"protocol",
             @"result":@"result",
             
             @"kid":@"message.item.kid",
             @"uid":@"message.item.uid",
             @"name":@"message.item.name",
             @"title":@"message.item.title",
             @"avatar":@"message.item.avatar",
             @"dateline":@"message.item.dateline",
             @"subscribed":@"message.item.subscribed",
             @"free":@"message.item.free",
             @"payment":@"message.item.payment",
             @"school":@"message.item.school",
             @"content":@"message.item.content",
             @"good":@"message.item.good",
             @"bad":@"message.item.bad",
             @"pics":@"message.item.pics",

             @"review_good_count":@"message.review_good_count",
             @"review_bad_count":@"message.review_bad_count",
             @"comment_count":@"message.comment_count",
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

+ (NSValueTransformer *)itemTitleJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id inObj) {
        if (inObj == nil || inObj == [NSNull null]) {
            return [NSString stringWithFormat:@""];
        } else {
            return inObj;
        }
    }];
}

+ (NSValueTransformer *)itemDescriptionJSONTransformer {
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
