//
//  RecordSightStartButton.m
//  VideoRecord
//
//  Created by CheungStephen on 4/12/16.
//  Copyright © 2016 guimingsu. All rights reserved.
//

#import "RecordSightStartButton.h"

@implementation RecordSightStartButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.frame = self.bounds;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:_circleLayer.position radius:frame.size.width/2 startAngle:-M_PI endAngle:M_PI clockwise:YES];
        _circleLayer.path = path.CGPath;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.lineWidth = 2;
        _circleLayer.strokeColor = [UIColor colorWithRed:54/255.0 green:182/255.0 blue:169/255.0 alpha:1.0].CGColor;
        [self.layer addSublayer:_circleLayer];
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, 20)];
        _label.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _label.textColor = [UIColor colorWithRed:54/255.0 green:182/255.0 blue:169/255.0 alpha:1.0];
        _label.text = @"按住拍";
        _label.textAlignment = NSTextAlignmentCenter;
        [_label setFont:[UIFont systemFontOfSize:20]];
        [self addSubview:_label];
    }
    return self;
}

-(void)disappearAnimation{
    CABasicAnimation *animation_scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation_scale.toValue = @1.5;
    CABasicAnimation *animation_opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation_opacity.toValue = @0;
    CAAnimationGroup *aniGroup = [CAAnimationGroup animation];
    aniGroup.duration = 0.2;
    aniGroup.animations = @[animation_scale,animation_opacity];
    aniGroup.fillMode = kCAFillModeForwards;
    aniGroup.removedOnCompletion = NO;
    [_circleLayer addAnimation:aniGroup forKey:@"start"];
    [_label.layer addAnimation:aniGroup forKey:@"start1"];
}

-(void)appearAnimation{
    CABasicAnimation *animation_scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation_scale.toValue = @1;
    CABasicAnimation *animation_opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation_opacity.toValue = @1;
    CAAnimationGroup *aniGroup = [CAAnimationGroup animation];
    aniGroup.duration = 0.2;
    aniGroup.animations = @[animation_scale,animation_opacity];
    aniGroup.fillMode = kCAFillModeForwards;
    aniGroup.removedOnCompletion = NO;
    [_circleLayer addAnimation:aniGroup forKey:@"reset"];
    [_label.layer addAnimation:aniGroup forKey:@"reset1"];
}

@end
