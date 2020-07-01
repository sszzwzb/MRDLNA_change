//
//  MsgZoomImageViewController.h
//  ShenMaSale
//
//  Created by kakashi on 14-1-16.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatDetailObject.h"
#import "BaseViewController.h"

@interface MsgZoomImageViewController : BaseViewController <UIScrollViewDelegate>
{
    BOOL _shouldGetPic;
    UIImage *picImage;
    UIScrollView *scrollViewForPic;
    UIImageView *imageView;
    NSString *imagePath; // 本地图片路径
    ChatDetailObject *nowChat;
    
    CGFloat maxHeight;
}

@property (nonatomic, retain) UIImage *picImage;
@property (nonatomic, assign) BOOL _shouldGetPic;
@property (nonatomic, retain) UIScrollView *scrollViewForPic;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) ChatDetailObject *nowChat;
@property (nonatomic, retain) NSString *imagePath;

@end

