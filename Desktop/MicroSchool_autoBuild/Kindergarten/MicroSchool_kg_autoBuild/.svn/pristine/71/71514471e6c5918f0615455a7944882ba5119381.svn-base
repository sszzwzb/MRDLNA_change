//
//  TSTouchImageView.m
//  MicroSchool
//
//  Created by jojo on 15/1/8.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "TSTouchImageView.h"

@implementation TSTouchImageView

- (id) initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if (self != nil) {
        _imgViewBG = [[UIImageView alloc]initWithFrame:CGRectZero];
        _isShowBgImg = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    UITouch* touch = [touches anyObject];
//    CGPoint pt = [touch locationInView:self];
    
//    NSLog(@"x=%f, y=%f", pt.x, pt.y);
    if (_isShowBgImg) {
        _imgViewBG.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _imgViewBG.image=[UIImage imageNamed:@"moments/touch_bgImg.png"];
        
        [self.viewForBaselineLayout addSubview:_imgViewBG];
    }
    
    // we're using activeLink to draw a highlight in -drawRect:
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isShowBgImg) {
        [_imgViewBG removeFromSuperview];
    }

    [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isShowBgImg) {
        [_imgViewBG removeFromSuperview];
    }
    
    [self setNeedsDisplay];
}

@end
