//
//  EventPhotoViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-12-5.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NetworkUtility.h"
#import "BaseViewController.h"
#import "UIImageView+WebCache.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

#import "EventPhotoCell.h"

@interface EventPhotoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, EGORefreshTableDelegate, HttpReqCallbackDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    BOOL _reloading;
    
    UITableView *_tableView;
    
    NSMutableArray* photoArray;
    
    NSString *startNum;
    NSString *endNum;
    
    NetworkUtility* networkDetail;
    
    UIButton *button;
}

@property (retain, nonatomic) NSString *eid;

-(void) getPhoto:(NSString*) eidValue andJoined:(NSString *) jonied andStatus:(NSString*) status andNum:(NSString*) num;

@end
