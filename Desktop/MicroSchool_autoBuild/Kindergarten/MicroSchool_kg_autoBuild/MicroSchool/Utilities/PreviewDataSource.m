//
//  PreviewDataSource.m
//  MicroSchool
//
//  Created by jojo on 14-9-22.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "PreviewDataSource.h"

#import "PreviewDataSource.h"


@implementation PreviewDataSource

@synthesize path;


- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return 1;
}


//- (id <QLPreviewItem>)previewController: (QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
//{
//    
//    return [NSURL fileURLWithPath:path];
//}

- (id <QLPreviewItem>)previewController: (QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    // Break the path into its components (filename and extension)
//    NSArray *fileComponents = [[arrayOfDocuments objectAtIndex: index] componentsSeparatedByString:@"."];
    
    // Use the filename (index 0) and the extension (index 1) to get path
//    NSString *path = [[NSBundle mainBundle] pathForResource:[fileComponents objectAtIndex:0] ofType:[fileComponents objectAtIndex:1]];
    //这个代码就体现了灵活性，你也可以写成 ofType .pdf
    NSString *a = path;
    
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    NSURL *url1 = [NSURL fileURLWithPath:path];
    NSURL *url2 = [[NSURL alloc]initWithString:[path stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    
    
    
    return [NSURL fileURLWithPath:[NSString stringWithFormat:@"/Users/jojo/Library/Application Support/iPhone Simulator/7.1/Applications/48E08EB7-F243-4385-B583-FAF3D02A38C7/Documents/WeixiaoFile/xxxx"]];;
    
}

- (void)dealloc {
//    [path release];
//    [super dealloc];
}

@end
