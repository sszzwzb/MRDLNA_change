//
//  EduinspectorDetailViewController.h
//  MicroSchool
//
//  Created by jojo on 14-9-1.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "UIImageView+WebCache.h"

@interface EduinspectorDetailViewController : BaseViewController<HttpReqCallbackDelegate, UIScrollViewDelegate>
{
    NSMutableDictionary *infoDic;
    
    UIScrollView *_scrollerView;
}

@property (nonatomic, retain) NSString *insUid;

@end
