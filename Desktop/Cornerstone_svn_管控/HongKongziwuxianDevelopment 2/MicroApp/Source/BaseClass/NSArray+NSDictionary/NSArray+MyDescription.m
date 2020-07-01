//
//  NSArray+MyDescription.m
//  test
//
//  Created by kaiyi on 15/10/19.
//  Copyright (c) 2015年 kaiyi. All rights reserved.
//

#import "NSArray+MyDescription.h"

@implementation NSArray (MyDescription)
- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *str = [NSMutableString stringWithFormat:@"count:%lu (\n", (unsigned long)self.count];
    
    for (id obj in self) {
        [str appendFormat:@"\t%@, \n", obj];
    }
    
    [str appendString:@")"];
    
    return str;
}

@end
