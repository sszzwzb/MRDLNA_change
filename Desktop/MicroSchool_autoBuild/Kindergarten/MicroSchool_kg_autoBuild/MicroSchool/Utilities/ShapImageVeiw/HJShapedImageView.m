//
//  ShapedImageView.m
//  ShapedImageView
//
//  Created by Sword on 11/16/14.
//  Copyright (c) 2014 Sword. All rights reserved.
//

#import "HJShapedImageView.h"

@interface HJShapedImageView()
{
    CALayer      *_contentLayer;
//    CAShapeLayer *_maskLayer;
}
@end

@implementation HJShapedImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        
//        _receiveOrSend = 1;
//        [self setup:_receiveOrSend];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    NSLog(@"_receiveOrSend:%d",_receiveOrSend);
    
    [self setup:_receiveOrSend];

}


- (void)setup:(NSInteger)reciveOrSend
{
    //construct your path
    //CGMutablePathRef path = CGPathCreateMutable();
    //CGPoint origin = self.bounds.origin;
    //CGFloat radius = CGRectGetWidth(self.bounds) / 2;
    //CGPathMoveToPoint(path, NULL, origin.x, origin.y + 2 *radius);
    //CGPathMoveToPoint(path, NULL, origin.x, origin.y + radius);
    //
    //CGPathAddArcToPoint(path, NULL, origin.x, origin.y, origin.x + radius, origin.y, radius);
    //CGPathAddArcToPoint(path, NULL, origin.x + 2 * radius, origin.y, origin.x + 2 * radius, origin.y + radius, radius);
    //CGPathAddArcToPoint(path, NULL, origin.x + 2 * radius, origin.y + 2 * radius, origin.x + radius, origin.y + 2  * radius, radius);
    //CGPathAddLineToPoint(path, NULL, origin.x, origin.y + 2 * radius);
    //
    
    [_contentLayer removeFromSuperlayer];
    CAShapeLayer *_maskLayer = [CAShapeLayer layer];
    _maskLayer.fillColor = [UIColor blackColor].CGColor;
    _maskLayer.strokeColor = [UIColor clearColor].CGColor;
    _maskLayer.frame = self.bounds;
    _maskLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
    _maskLayer.contentsScale = [UIScreen mainScreen].scale;                 //非常关键设置自动拉伸的效果且不变形

    if (reciveOrSend) {
      _maskLayer.contents = (id)[UIImage imageNamed:@"SendBubble.png"].CGImage;
    }else{
      _maskLayer.contents = (id)[UIImage imageNamed:@"ReceiveBubble.png"].CGImage;
    }
    
    _contentLayer = [CALayer layer];
    _contentLayer.mask = _maskLayer;
    _contentLayer.frame = self.bounds;
   
    [self.layer addSublayer:_contentLayer];
    
}

- (void)setImage:(UIImage *)image
{
    _contentLayer.contents = (id)image.CGImage;
}

@end
