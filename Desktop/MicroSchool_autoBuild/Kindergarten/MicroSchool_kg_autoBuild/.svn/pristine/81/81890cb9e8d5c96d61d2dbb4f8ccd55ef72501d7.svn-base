//
//  UUBarChart.m
//  UUChartDemo
//
//  update by Kate on 15-12-3.
//  Copyright (c) 2015年 etaishuo. All rights reserved.
//

#import "UUBarChart.h"
#import "UUChartLabel.h"
#import "UUBar.h"

@interface UUBarChart ()
{
    UIScrollView *myScrollView;
}
@end

@implementation UUBarChart {
    NSHashTable *_chartLabelsForX;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        //myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(UUYLabelwidth, 0, frame.size.width-UUYLabelwidth, frame.size.height)];
        myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:myScrollView];
    }
    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
}

-(void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
    NSInteger min = 1000000000;
    for (NSArray * ary in yLabels) {
        for (NSString *valueString in ary) {
            NSInteger value = [valueString integerValue];
            if (value > max) {
                max = value;
            }
            if (value < min) {
                min = value;
            }
        }
    }
    if (max < 5) {
        max = 5;
    }
    if (self.showRange) {
        _yValueMin = (int)min;
    }else{
        _yValueMin = 0;
    }
    _yValueMax = (int)max;
    
    if (_chooseRange.max!=_chooseRange.min) {
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    }

    float level = (_yValueMax-_yValueMin) /4.0;
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
    CGFloat levelHeight = chartCavanHeight /4.0;
    
    //隐藏纵坐标title
//    for (int i=0; i<5; i++) {
//        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight-i*levelHeight+5, UUYLabelwidth, UULabelHeight)];
//		label.text = [NSString stringWithFormat:@"%.1f",level * i+_yValueMin];
//		[self addSubview:label];
//    }
	
}

-(void)setXLabels:(NSArray *)xLabels
{
    if( !_chartLabelsForX ){
        _chartLabelsForX = [NSHashTable weakObjectsHashTable];
    }
    
    _xLabels = xLabels;
    NSInteger num;
    if (xLabels.count>=8) {
        num = 8;
    }else if (xLabels.count<=4){
        num = 4;
    }else{
        num = xLabels.count;
    }
    _xLabelWidth = myScrollView.frame.size.width/num;
    
    for (int i=0; i<xLabels.count; i++) {
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake((i *  _xLabelWidth )+UUYLabelwidth, self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight)];//横坐标修改，使其居中
        label.text = xLabels[i];
        [myScrollView addSubview:label];
        
        [_chartLabelsForX addObject:label];
    }
    
    float max = (([xLabels count]-1)*_xLabelWidth + chartMargin)+_xLabelWidth;
    if (myScrollView.frame.size.width < max-10) {
        myScrollView.contentSize = CGSizeMake(max, self.frame.size.height);
    }
}

-(void)setColors:(NSArray *)colors
{
	_colors = colors;
}

- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}

-(void)strokeChart
{
    
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
	
    for (int i=0; i<_yValues.count; i++) {
        if (i==2)
            return;
        NSArray *childAry = _yValues[i];
        for (int j=0; j<childAry.count; j++) {
            NSString *valueString = childAry[j];
            float value = [valueString floatValue];
            float grade = ((float)value-_yValueMin) / ((float)_yValueMax-_yValueMin);
        
            float width = _xLabelWidth * (_yValues.count==1?0.8:0.45);
            
            UUBar *bar = [[UUBar alloc] initWithFrame:CGRectMake((j+(_yValues.count==1?0.1:0.05))*_xLabelWidth +i*_xLabelWidth * 0.47 + UUYLabelwidth, UULabelHeight, _xLabelWidth * (_yValues.count==1?0.8:0.45), chartCavanHeight)];//修改横坐标，使其居中
            bar.backgroundColor = [UIColor clearColor];
            bar.barColor = [_colors objectAtIndex:i];
            bar.grade = grade;
            [myScrollView addSubview:bar];
            
            // Done: 自己在柱子上边加个label显示value
            // 保留小数点后2位 有效数字
            float f = value;
            NSString* str = @"";
            
            if (fmodf(f, 1)==0) {
                
                str = [NSString stringWithFormat:@"%.0f",f];
                
            } else if (fmodf(f*10, 1)==0) {
                
                str = [NSString stringWithFormat:@"%.1f",f];
                
            } else {
                
                str = [NSString stringWithFormat:@"%.2f",f];
            }
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(bar.frame.origin.x + width/3.0 -5.0, (1 - grade) * chartCavanHeight, width/2.0, 10.0)];
            label.font = [UIFont systemFontOfSize:9.0];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor whiteColor];
            label.text = str;
            
            [myScrollView addSubview:label];
            
        }
    }
}

- (NSArray *)chartLabelsForX
{
    return [_chartLabelsForX allObjects];
}

@end
