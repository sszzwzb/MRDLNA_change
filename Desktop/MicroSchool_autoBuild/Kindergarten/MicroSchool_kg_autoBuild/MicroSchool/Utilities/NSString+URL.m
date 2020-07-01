//
//  NSString+URL.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/4/22.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <Foundation/Foundation.h>
@implementation NSString (URL)

- (NSString *)URLEncodedString
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                            NULL,
                                            kCFStringEncodingUTF8));
    return encodedString;
}
@end