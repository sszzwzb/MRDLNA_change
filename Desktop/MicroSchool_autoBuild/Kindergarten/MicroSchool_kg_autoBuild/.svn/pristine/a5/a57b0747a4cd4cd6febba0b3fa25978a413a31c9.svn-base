//
//  TSAttributedLabel.m
//  MicroSchool
//
//  Created by jojo on 15/9/21.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "TSAttributedLabel.h"

@implementation TSAttributedLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if (self != nil) {
        _imgViewName1 =[[UIImageView alloc]initWithFrame:CGRectZero];
        _imgViewName2 =[[UIImageView alloc]initWithFrame:CGRectZero];
        _imgViewMsg =[[UIImageView alloc]initWithFrame:CGRectZero];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
#if 1
    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    
    NSLog(@"x=%f, y=%f", pt.x, pt.y);
    NSLog(@"name1start=%d, name1end=%d", _name1Start, _name1End);
    NSLog(@"name2start=%d, name2end=%d", _name2Start, _name2End);
    
    if (_nameY >0) {
        
        if (![@"no"  isEqual: _isShowShadow]) {
            if ((pt.x<=_name1End) && (pt.x>=_name1Start) && (pt.y <= _nameY)) {
                _imgViewName1.frame = CGRectMake(0, 0, _name1End, 26);
                _imgViewName1.image=[UIImage imageNamed:@"knowledge/tm.png"];
                
                [self.viewForBaselineLayout addSubview:_imgViewName1];
            }else if ((pt.x<=_name2End) && (pt.x>=_name2Start) && (pt.y <= _nameY)) {
                _imgViewName2.frame = CGRectMake(_name2Start, 0, _name2Size, 26);
                _imgViewName2.image=[UIImage imageNamed:@"knowledge/tm.png"];
                
                [self.viewForBaselineLayout addSubview:_imgViewName2];
            }else {
                _imgViewMsg.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                _imgViewMsg.image=[UIImage imageNamed:@"knowledge/tm.png"];
                
                [self.viewForBaselineLayout addSubview:_imgViewMsg];
            }
        }
    }else{
        if (![@"no"  isEqual: _isShowShadow]) {
            if ((pt.x<=_name1End) && (pt.x>=_name1Start) && (pt.y <= 17)) {
                _imgViewName1.frame = CGRectMake(0, 0, _name1End, 15);
                _imgViewName1.image=[UIImage imageNamed:@"knowledge/tm.png"];
                
                [self.viewForBaselineLayout addSubview:_imgViewName1];
            }else if ((pt.x<=_name2End) && (pt.x>=_name2Start) && (pt.y <= 17)) {
                _imgViewName2.frame = CGRectMake(_name2Start, 0, _name2Size, 15);
                _imgViewName2.image=[UIImage imageNamed:@"knowledge/tm.png"];
                
                [self.viewForBaselineLayout addSubview:_imgViewName2];
            }else {
                _imgViewMsg.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                _imgViewMsg.image=[UIImage imageNamed:@"knowledge/tm.png"];
                
                [self.viewForBaselineLayout addSubview:_imgViewMsg];
            }
        }
    }
    
    
//    activeLink = [self linkAtPoint:pt];
//    touchStartPoint = pt;
    
    // we're using activeLink to draw a highlight in -drawRect:
    [self setNeedsDisplay];
#endif
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [_imgViewName1 removeFromSuperview];
    [_imgViewName2 removeFromSuperview];
    [_imgViewMsg removeFromSuperview];
    
    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    
    if (_nameY > 0) {
        
        if (![@"no"  isEqual: _isShowShadow]) {
            if ((pt.x<=_name1End) && (pt.x>=_name1Start) && (pt.y <= _nameY)) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     _name1Uid, @"uid",
                                     nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_momentsClickName1" object:self userInfo:dic];
                [_delegate_TS clickName:dic];//2015.12.14 kate
                
            }else if ((pt.x<=_name2End) && (pt.x>=_name2Start) && (pt.y <= _nameY)) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     _name2Uid, @"uid",
                                     nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_momentsClickName1" object:self userInfo:dic];
                [_delegate_TS clickName:dic];//2015.12.14 kate
                
            }else {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     _msgPid, @"pid",
                                     _msgUid, @"uid",
                                     _msgPos, @"msgPos",
                                     _cellNum, @"cellNum",
                                     _msgTid, @"tid",
                                     nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_momentsClickRemoveComment" object:self userInfo:dic];
                
                [_delegate_TS clickLabel:dic];// 2015.12.14 kate
            }
            
        }

        
    }else{
        if (![@"no"  isEqual: _isShowShadow]) {
            if ((pt.x<=_name1End) && (pt.x>=_name1Start) && (pt.y <= 17)) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     _name1Uid, @"uid",
                                     nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_momentsClickName1" object:self userInfo:dic];
                [_delegate_TS clickName:dic];//2015.12.14 kate
                
            }else if ((pt.x<=_name2End) && (pt.x>=_name2Start) && (pt.y <= 17)) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     _name2Uid, @"uid",
                                     nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_momentsClickName1" object:self userInfo:dic];
                [_delegate_TS clickName:dic];//2015.12.14 kate
                
            }else {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     _msgPid, @"pid",
                                     _msgUid, @"uid",
                                     _msgPos, @"msgPos",
                                     _cellNum, @"cellNum",
                                     _msgTid, @"tid",
                                     nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_momentsClickRemoveComment" object:self userInfo:dic];
                
                [_delegate_TS clickLabel:dic];// 2015.12.14 kate
            }
            
        }
 
    }
    
    
    
//    NSTextCheckingResult *linkAtTouchesEnded = [self linkAtPoint:pt];
//    
//    BOOL closeToStart = (fabs(touchStartPoint.x - pt.x) < 10 && fabs(touchStartPoint.y - pt.y) < 10);
//    
//    // we can check on equality of the ranges themselfes since the data detectors create new results
//    if (activeLink && (NSEqualRanges(activeLink.range,linkAtTouchesEnded.range) || closeToStart)) {
//        BOOL openLink = (self.delegate && [self.delegate respondsToSelector:@selector(attributedLabel:shouldFollowLink:)])
//        ? [self.delegate attributedLabel:self shouldFollowLink:activeLink] : YES;
//        if (openLink) [[UIApplication sharedApplication] openURL:activeLink.URL];
//    }
//    
//    //[activeLink release];
//    activeLink = nil;
//    [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    // [activeLink release];
    [_imgViewName1 removeFromSuperview];
    [_imgViewName2 removeFromSuperview];
    [_imgViewMsg removeFromSuperview];
    
//    activeLink = nil;
    [self setNeedsDisplay];
}

@end
