//
//  FullImageCell.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/6/15.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "FullImageCell.h"

@implementation FullImageCell
@synthesize scrollViewForPic;

- (void)awakeFromNib {
    // Initialization code
    
    scrollViewForPic = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, [[UIScreen mainScreen] bounds].size.height)];
    [scrollViewForPic setBackgroundColor:[UIColor blackColor]];
    [scrollViewForPic setDelegate:self];
    [scrollViewForPic setMaximumZoomScale:2.0];
    [scrollViewForPic setZoomScale:[scrollViewForPic minimumZoomScale]];
    scrollViewForPic.showsVerticalScrollIndicator = NO;
    scrollViewForPic.showsHorizontalScrollIndicator = NO;
    //scrollViewForPic.exclusiveTouch = YES;
    scrollViewForPic.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    
    _imageView = [[UIImageView alloc] init];
    [scrollViewForPic addSubview:_imageView];
    
    [self.contentView addSubview:scrollViewForPic];

}

#pragma mark -zoom

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)aScrollView
{
    CGFloat offsetX = (scrollViewForPic.bounds.size.width > scrollViewForPic.contentSize.width)?
    (scrollViewForPic.bounds.size.width - scrollViewForPic.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollViewForPic.bounds.size.height > scrollViewForPic.contentSize.height)?
    (scrollViewForPic.bounds.size.height - scrollViewForPic.contentSize.height) * 0.5 : 0.0;
    _imageView.center = CGPointMake(scrollViewForPic.contentSize.width * 0.5 + offsetX,
                                   scrollViewForPic.contentSize.height * 0.5 + offsetY);
    
    
    
    
}



@end
