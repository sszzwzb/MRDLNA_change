//
//  ScrolledBanner.h
//  MicroSchool
//
//  Created by CheungStephen on 3/14/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Masonry.h"
#import "UIImageView+WebCache.h"

#import "Utilities.h"
#import "TSTouchImageView.h"
#import "TSTapGestureRecognizer.h"

@class ScrolledBanner;

@protocol ScrolledBannerDelegate <NSObject>

// 点击图片的index
-(void)ScrolledBannerSelectedImage:(ScrolledBanner *)v index:(NSInteger)index;

@end

@interface ScrolledBanner : UIView<UIScrollViewDelegate>

@property (nonatomic, assign) id<ScrolledBannerDelegate> delegate;

- (void)initImages:(NSArray *)imgArrar content:(NSString *)content rect:(CGRect)rect;

@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,retain) UIPageControl *pageControl;

@property(nonatomic,retain) NSString *widthStr;

@end
