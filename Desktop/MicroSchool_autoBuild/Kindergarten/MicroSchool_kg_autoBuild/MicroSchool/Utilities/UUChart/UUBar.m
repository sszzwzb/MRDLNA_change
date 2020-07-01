//
//  UUBar.m
//  UUChartDemo
//
//  update by Kate on 15-12-3.
//  Copyright (c) 2015年 etaishuo. All rights reserved.
//

#import "UUBar.h"
#import "UUColor.h"

@implementation UUBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		_chartLine = [CAShapeLayer layer];//用于画各种形状
		_chartLine.lineCap = kCALineCapSquare;
		//_chartLine.fillColor   = [[UIColor whiteColor] CGColor];
        _chartLine.fillColor   = [[UIColor clearColor] CGColor];//该表背景色
		_chartLine.lineWidth   = self.frame.size.width;
		_chartLine.strokeEnd   = 0.0;
		self.clipsToBounds = YES;
        _gradientLayer = [CAGradientLayer layer];//用于画渐变
        _gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:211.0 / 255.0 green:242.0 / 255.0 blue:239.0 / 255.0 alpha:1.0].CGColor ,
                                 (__bridge id)[UIColor colorWithRed:97.0 / 255.0 green:192.0 / 255.0 blue:197.0 / 255.0 alpha:1.0].CGColor];
        // startPoint endPoint 用于控制左右渐变还是上下渐变
        _gradientLayer.startPoint = CGPointMake(0.0,0.0);//左上
        _gradientLayer.endPoint = CGPointMake(0.0,1.0);//右上
        //[_gradientLayer setMask:_chartLine];
		[self.layer addSublayer:_chartLine];
        [self.layer insertSublayer:_gradientLayer atIndex:0];
        //[_chartLine insertSublayer:_gradientLayer atIndex:0];
        //[_chartLine addSublayer:_gradientLayer];
    }
    return self;
}

-(void)setGrade:(float)grade
{
    if (grade==0)
    return;
    
	_grade = grade;
    
     UIBezierPath *progressline = [UIBezierPath bezierPath];
    
    [progressline moveToPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height+30)];
	[progressline addLineToPoint:CGPointMake(self.frame.size.width/2.0, (1 - grade) * self.frame.size.height+15)];
    [progressline setLineWidth:1.0];
    [progressline setLineCapStyle:kCGLineCapSquare];
    
	_chartLine.path = progressline.CGPath;
    
    CGFloat chartCavanHeight = self.frame.size.height;

	if (_barColor) {
		//_chartLine.strokeColor = [_barColor CGColor];
        _chartLine.strokeColor = [[UIColor clearColor] CGColor];

	}else{
		_chartLine.strokeColor = [UUGreen CGColor];
	}
    
    _gradientLayer.frame = CGRectMake(self.frame.size.width/3.0 - 5, (1 - grade) * chartCavanHeight, self.frame.size.width/2.0, grade*chartCavanHeight+15);
//    [_gradientLayer setMask:_chartLine];
//    [self.layer insertSublayer:_gradientLayer atIndex:0];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.5;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses = NO;
    [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];

    
    _chartLine.strokeEnd = 2.0;
    
}

- (void)drawRect:(CGRect)rect
{
	//Draw BG
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
	CGContextFillRect(context, rect);
    
    /*NSArray *colors = [NSArray arrayWithObjects:
                       
                       [UIColor colorWithRed:211.0 / 255.0 green:242.0 / 255.0 blue:239.0 / 255.0 alpha:1.0],
                       
                       [UIColor colorWithRed:97.0 / 255.0 green:192.0 / 255.0 blue:197.0 / 255.0 alpha:1.0],
                       
                       nil];
    
    [self _drawGradientColor:context
     
                        rect:rect
     
                     options:kCGGradientDrawsAfterEndLocation
     
                      colors:colors];
    
    CGContextStrokePath(context);// 描线,即绘制形状
    
    CGContextFillPath(context);// 填充形状内的颜色
    */
    
}

/**
 * 绘制背景色渐变的矩形，p_colors渐变颜色设置，集合中存储UIColor对象（创建Color时一定用三原色来创建）
 **/

- (void)_drawGradientColor:(CGContextRef)p_context rect:(CGRect)p_clipRect
options:(CGGradientDrawingOptions)p_options
colors:(NSArray *)p_colors {
    
    CGContextSaveGState(p_context);// 保持住现在的context
    
    CGContextClipToRect(p_context, p_clipRect);// 截取对应的context
    
    int colorCount = p_colors.count;
    
    int numOfComponents = 4;
    
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    
    CGFloat colorComponents[colorCount * numOfComponents];
    
    for (int i = 0; i < colorCount; i++) {
        
        UIColor *color = p_colors[i];
        
        CGColorRef temcolorRef = color.CGColor;
        
        const CGFloat *components = CGColorGetComponents(temcolorRef);
        
        for (int j = 0; j < numOfComponents; ++j) {
            
            colorComponents[i * numOfComponents + j] = components[j];
            
        }
        
    }
    
    CGGradientRef gradient =  CGGradientCreateWithColorComponents(rgb, colorComponents, NULL, colorCount);
    
    CGColorSpaceRelease(rgb);
    
    CGPoint startPoint = p_clipRect.origin;
    
    CGPoint endPoint = CGPointMake(CGRectGetMinX(p_clipRect), CGRectGetMaxY(p_clipRect));
    
    CGContextDrawLinearGradient(p_context, gradient, startPoint, endPoint, p_options);
    
    CGGradientRelease(gradient);
    
    CGContextRestoreGState(p_context);// 恢复到之前的context
    
}


@end
