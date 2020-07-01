//
//  BroadcastModel.m
//  MicroSchool
//
//  Created by jojo on 15/2/3.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "BroadcastModel.h"

@implementation BroadcastModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"protocol":@"protocol",
             //             @"message":@"message",
             //             @"result":@"result",
             
             @"fileSize":@"message.fileSize",
             @"title":@"message.title",
             @"background":@"message.background",
             @"broadcaster":@"message.broadcaster",
             @"radio":@"message.radio",
             @"dateline":@"message.dateline",
             @"viewnum":@"message.viewnum",
             @"limit":@"message.limit",
             @"nid":@"message.nid",
             @"commentnum":@"message.commentnum",
             };
}

- (void)setNilValueForKey:(NSString *)key
{
    // For NSInteger/CGFloat/BOOL
    [self setValue:@0 forKey:key];
}

//+ (NSValueTransformer *)viewnumJSONTransformer{
//    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *string) {
//        return @([string integerValue]);
//    } reverseBlock:^id(NSNumber *number) {
//        return [number stringValue];
//    }];
//}

+ (NSValueTransformer *)fileSizeJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id inObj) {
        if (inObj == nil || inObj == [NSNull null]) {
            return [NSString stringWithFormat:@""];
        } else {
            return inObj;
        }
    }];
}


//+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
//    if ([key isEqualToString:@"fileSize"]) {
//        return [NSValueTransformer valueTransformerForName:XYDateValueTransformerName];
//    }
//    return nil;
//}


//- (void)setNilValueForKey:(NSString *)key{
//    if ([key isEqualToString:@"fileSize"]) {
//        self.fileSize = @"";
//    }
//    else{
//        [super setNilValueForKey:key];
//    }
//}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error
{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    
    // Store a value that needs to be determined locally upon initialization.
    //     _retrievedAt = [NSDate date];
    
    return self;
}

@end
