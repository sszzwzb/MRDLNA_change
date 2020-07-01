//
//  MomentsSharedLink.m
//  MicroSchool
//
//  Created by jojo on 15/4/20.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "MomentsSharedLink.h"

@implementation MomentsSharedLink

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
        _imgViewBG = [[UIImageView alloc]initWithFrame:CGRectZero];
        _isShowBgImg = YES;

        // 背景灰色
        _img_default = [[UIImageView alloc]initWithFrame:CGRectZero];
        _img_default.image=[UIImage imageNamed:@"tlq_history.png"];
        [self addSubview:_img_default];

        // 缩略图
        _img_snapshot =[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
        _img_snapshot.contentMode = UIViewContentModeScaleAspectFill;
        _img_snapshot.clipsToBounds = YES;
        [self addSubview:_img_snapshot];

        // 内容
        _label_content = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                    40,
                                                                    2,
                                                                    200,
                                                                    36)];
        _label_content.lineBreakMode = NSLineBreakByWordWrapping;
        _label_content.font = [UIFont systemFontOfSize:13.0f];
        _label_content.numberOfLines = 0;
        _label_content.textColor = [UIColor blackColor];
        _label_content.backgroundColor = [UIColor clearColor];
        [self addSubview:_label_content];
    }
    return self;
}

#if 9
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    
    NSLog(@"x=%f, y=%f", pt.x, pt.y);

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
    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];

    if (_isShowBgImg) {
        
        [_imgViewBG removeFromSuperview];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             _cellNum, @"cellNum",
                             nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_MOMENTS_CLICKSHAREDLINK object:self userInfo:dic];
        
//        [self performSelector:@selector(testFinishedLoadData11) withObject:nil afterDelay:0.3];

    }
    
    [self setNeedsDisplay];
}

-(void)testFinishedLoadData11{
    [_imgViewBG removeFromSuperview];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         _cellNum, @"cellNum",
                         nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_MOMENTS_CLICKSHAREDLINK object:self userInfo:dic];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isShowBgImg) {
        [_imgViewBG removeFromSuperview];
    }
    
    [self setNeedsDisplay];
}

#endif
@end
