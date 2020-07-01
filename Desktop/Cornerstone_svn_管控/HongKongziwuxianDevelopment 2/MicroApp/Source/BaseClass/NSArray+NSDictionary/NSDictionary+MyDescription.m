//
//  NSDictionary+MyDescription.m
//  test
//
//  Created by kaiyi on 15/10/19.
//  Copyright (c) 2015年 kaiyi. All rights reserved.
//

#import "NSDictionary+MyDescription.h"

@implementation NSDictionary (MyDescription)
- (NSString *)descriptionWithLocale:(id)locale {
    
    NSArray *allKeys = [self allKeys];
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"{\t\n "];
    for (NSString *key in allKeys) {
        id value= self[key];
        [str appendFormat:@"\t \"%@\" = %@,\n",key, value];
    }
    [str appendString:@"}"];
    
    return str;
}
@end
