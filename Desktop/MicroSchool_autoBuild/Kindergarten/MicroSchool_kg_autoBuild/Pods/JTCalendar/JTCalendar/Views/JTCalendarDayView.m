//
//  JTCalendarDayView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarDayView.h"

#import "JTCalendarManager.h"

@implementation JTCalendarDayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    self.clipsToBounds = YES;
    
    _circleRatio = .6;
    _dotRatio = 1. / 7.;
    
    {
        _dotView = [UIView new];
        [self addSubview:_dotView];
        
        //        _dotView.backgroundColor = [UIColor redColor];
        _dotView.hidden = YES;
        
        [_dotView addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Attendance/checkin_check"]]];
        
        //        _dotView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        //        _dotView.layer.shouldRasterize = YES;
    }
    
    
    {
        _circleView = [UIView new];
        [self addSubview:_circleView];
        
        
        
        _circleView.backgroundColor = [UIColor colorWithRed:0x33/256. green:0xB3/256. blue:0xEC/256. alpha:.5];
        _circleView.hidden = YES;
        
        _circleView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _circleView.layer.shouldRasterize = YES;
    }
    {
        _earlyLeaveView = [UIView new];
        [self addSubview:_earlyLeaveView];
        
        
        //        CGRect frameRect = CGRectMake(20, 90, self.window.frame.size.width-40, self.window.frame.size.height-180);
        //        _earlyLeaveView.frame = frameRect;
        _earlyLeaveView.layer.borderWidth = 1;
        _earlyLeaveView.layer.borderColor = [[UIColor colorWithRed:227/255.0 green:110/255.0 blue:15/255.0 alpha:1.0] CGColor];
        
        
        //        _earlyLeaveView.backgroundColor = [UIColor colorWithRed:0x33/256. green:0xB3/256. blue:0xEC/256. alpha:.5];
        _earlyLeaveView.hidden = YES;
        
        _earlyLeaveView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _earlyLeaveView.layer.shouldRasterize = YES;
        
    }
    

    

    
    

    
    {
        _textLabel = [UILabel new];
        [self addSubview:_textLabel];
        
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    
    {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouch)];
        
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:gesture];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _textLabel.frame = self.bounds;
    
    CGFloat sizeCircle = MIN(self.frame.size.width, self.frame.size.height);
    CGFloat sizeDot = sizeCircle;
    
    sizeCircle = sizeCircle * _circleRatio;
    sizeDot = sizeDot * _dotRatio;
    
    sizeCircle = roundf(sizeCircle);
    sizeDot = roundf(sizeDot);
    
    _circleView.frame = CGRectMake(0, 0, sizeCircle, sizeCircle);
    _circleView.center = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2.);
    _circleView.layer.cornerRadius = sizeCircle / 2.;
    
    
//    _dotView.center = CGPointMake(self.frame.size.width / 2., (self.frame.size.height / 2.) +sizeDot * 2.5);
//    _dotView.layer.cornerRadius = sizeDot / 2.;
    
    _earlyLeaveView.frame = CGRectMake(0, 0, sizeCircle, sizeCircle);
    _earlyLeaveView.center = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2.);
    _earlyLeaveView.layer.cornerRadius = sizeCircle / 2.;
    
    _dotView.frame = CGRectMake((self.frame.size.width-12)/2, _circleView.frame.size.height+6.5, 12, 12);

}

- (void)setDate:(NSDate *)date
{
    NSAssert(date != nil, @"date cannot be nil");
    NSAssert(_manager != nil, @"manager cannot be nil");
    
    self->_date = date;
    [self reload];
}

- (void)reload
{    
    static NSDateFormatter *dateFormatter = nil;
    if(!dateFormatter){
        dateFormatter = [_manager.dateHelper createDateFormatter];
    }
    [dateFormatter setDateFormat:self.dayFormat];

    _textLabel.text = [ dateFormatter stringFromDate:_date];       
    [_manager.delegateManager prepareDayView:self];
}

- (void)didTouch
{
    [_manager.delegateManager didTouchDayView:self];
}

- (NSString *)dayFormat
{
    return self.manager.settings.zeroPaddedDayFormat ? @"d" : @"d";
}

@end
