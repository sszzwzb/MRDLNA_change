//
//  TSLabel.m
//  MicroSchool
//
//  Created by CheungStephen on 7/5/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "TSLabel.h"

@implementation TSLabel

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
    
    _imgViewMsg.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _imgViewMsg.image=[UIImage imageNamed:@"moments/touch_bgImg.png"];
    
    [self.viewForBaselineLayout addSubview:_imgViewMsg];
    
    // we're using activeLink to draw a highlight in -drawRect:
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    
    
//    UITouch* touch = [touches anyObject];

    
    //    CGPoint pt = [touch locationInView:self];
    
//    if ([@"touchMomentsNameToProfile"  isEqual: _touchType]) {
//        
//        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.3];
//        
//    }else if ([@"touchMomentsListDelete"  isEqual: _touchType] || [@"touchMomentsListRemove" isEqual:_touchType]) {
//        
//        // touchMomentsListRemove 足迹移除 2015.12.30
//        
//        [_imgViewMsg removeFromSuperview];
//        
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                             _tid, @"tid",
//                             _cellNum, @"cellNum",
//                             nil];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_momentsClickRemovePost" object:self userInfo:dic];
    
    [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [_imgViewMsg removeFromSuperview];
    
    [self setNeedsDisplay];
}

@end
