//
//  TSTouchLabel.m
//  MicroSchool
//
//  Created by jojo on 15/1/4.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "TSTouchLabel.h"
#import "Toast+UIView.h"//2015.09.15

@implementation TSTouchLabel

@synthesize pasteboardStr;

- (id) initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if (self != nil) {
        _imgViewMsg =[[UIImageView alloc]initWithFrame:CGRectZero];
        
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
    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    
    NSLog(@"x=%f, y=%f", pt.x, pt.y);
    
    _imgViewMsg.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _imgViewMsg.image=[UIImage imageNamed:@"moments/touch_bgImg.png"];
    
    [self.viewForBaselineLayout addSubview:_imgViewMsg];
    
    // we're using activeLink to draw a highlight in -drawRect:
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    
    if ([@"touchMomentsNameToProfile"  isEqual: _touchType]) {
        
        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.3];
        
    }else if ([@"touchMomentsListDelete"  isEqual: _touchType] || [@"touchMomentsListRemove" isEqual:_touchType]) {
        
        // touchMomentsListRemove 足迹移除 2015.12.30
        
        [_imgViewMsg removeFromSuperview];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             _tid, @"tid",
                             _cellNum, @"cellNum",
                             nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_momentsClickRemovePost" object:self userInfo:dic];
    }else if ([@"touchMomentsListBlock"  isEqual: _touchType]) {
        [_imgViewMsg removeFromSuperview];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             _tid, @"tid",
                             _cellNum, @"cellNum",
                             nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_MOMENTS_CLICKBLOCK object:self userInfo:dic];
    }else if ([@"touchNewsCommentDelete"  isEqual: _touchType]) {
        [_imgViewMsg removeFromSuperview];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             _tid, @"cid",
                             _cellNum, @"cellNum",
                             nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_NEWS_DELETE_COMMENT object:self userInfo:dic];
    }else if ([@"touchDiscussAndNewsCommentCopy" isEqual:_touchType]){
        
        [_imgViewMsg removeFromSuperview];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:self.pasteboardStr];
        [self.superview makeToast:@"复制成功"
                         duration:1
                         position:@"bottom"
                            title:nil];
    }
    
    [self setNeedsDisplay];
}

-(void)testFinishedLoadData{
    [_imgViewMsg removeFromSuperview];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         _uid, @"uid",
                         nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_momentsClickName1" object:self userInfo:dic];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [_imgViewMsg removeFromSuperview];
    
    [self setNeedsDisplay];
}

@end
