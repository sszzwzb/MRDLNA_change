//
//  TSPopupView.m
//  MicroSchool
//
//  Created by CheungStephen on 7/15/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "TSPopupView.h"

#import "MMSheetView.h"
#import "Utilities.h"

@implementation TSPopupView

+ (instancetype)sharedClient {
    static TSPopupView *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    
    return _shared;
}

- (void)doShowPopupView:(NSString *)title items:(NSArray *)items view:(UIView *)view{
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    
    NSMutableArray *MMSheetViewItemArray = [[NSMutableArray alloc] init];
    for (id obj in items) {
        TSPopupItem *item = (TSPopupItem *)obj;
        
        MMPopupItem *itemMM = MMItemMake(item.title, (MMItemType)item.type, item.handler);
        [MMSheetViewItemArray addObject:itemMM];
    }
 
    MMSheetViewConfig *config = [MMSheetViewConfig globalConfig];
    config.defaultTextCancel = @"取消";
    
    config.buttonHeight = [Utilities transformationHeight:50];
    config.innerMargin = [Utilities transformationHeight:24];

    config.titleFontSize = 13;
    
    config.titleColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    config.itemHighlightColor = [UIColor colorWithRed:226/255.0 green:87/255.0 blue:76/255.0 alpha:1.0];
    config.splitColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    config.itemPressedColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:0.9];

    config.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.98];
    
    MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:title
                                                          items:MMSheetViewItemArray];
    sheetView.attachedView.mm_dimBackgroundBlurEnabled = NO;
    sheetView.attachedView = view;

    [sheetView show];
}

-(BOOL)dismissAllKeyBoardInView:(UIView *)view
{
    if([view isFirstResponder])
    {
        [view resignFirstResponder];
        return YES;
    }
    for(UIView *subView in view.subviews)
    {
        if([self dismissAllKeyBoardInView:subView])
        {
            return YES;
        }
    }
    return NO;
}

- (void)doShowPopupView:(NSString *)title items:(NSArray *)items {
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        for (UIView* view in window.subviews) {
            [self dismissAllKeyBoardInView:view];
        }
    }
    
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    
    NSMutableArray *MMSheetViewItemArray = [[NSMutableArray alloc] init];
    for (id obj in items) {
        TSPopupItem *item = (TSPopupItem *)obj;
        
        MMPopupItem *itemMM = MMItemMake(item.title, (MMItemType)item.type, item.handler);
        [MMSheetViewItemArray addObject:itemMM];
    }
    
    MMSheetViewConfig *config = [MMSheetViewConfig globalConfig];
    config.defaultTextCancel = @"取消";
    
    config.buttonHeight = [Utilities transformationHeight:50];
    config.innerMargin = [Utilities transformationHeight:24];
    
    config.titleFontSize = 13;
    
    config.titleColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    config.itemHighlightColor = [UIColor colorWithRed:226/255.0 green:87/255.0 blue:76/255.0 alpha:1.0];
    config.splitColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    config.itemPressedColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:0.9];
    
    config.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.98];
    
    MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:title
                                                          items:MMSheetViewItemArray];
    sheetView.attachedView.mm_dimBackgroundBlurEnabled = NO;
    
    [sheetView show];
}

@end
