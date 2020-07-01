//
//  PreviewDataSource.h
//  MicroSchool
//
//  Created by jojo on 14-9-22.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>


@interface PreviewDataSource : NSObject<QLPreviewControllerDataSource> {
//    NSString *path;
}

@property (nonatomic, assign) NSString *path;

@end
