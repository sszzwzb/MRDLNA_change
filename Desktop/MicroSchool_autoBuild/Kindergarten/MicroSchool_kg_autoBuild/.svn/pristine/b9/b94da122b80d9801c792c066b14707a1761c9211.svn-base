//
//  KnowledgeHotWikiModel.m
//  MicroSchool
//
//  Created by jojo on 15/2/9.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "KnowledgeHotWikiModel.h"

@implementation KnowledgeHotWikiModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"protocol":@"protocol",
             @"result":@"result",
             @"message":@"message",
             
             @"list":@"message.list",
             
             @"categories":@"message.filters.categories",
             @"courses":@"message.filters.courses",
             @"grades":@"message.filters.grades",

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
