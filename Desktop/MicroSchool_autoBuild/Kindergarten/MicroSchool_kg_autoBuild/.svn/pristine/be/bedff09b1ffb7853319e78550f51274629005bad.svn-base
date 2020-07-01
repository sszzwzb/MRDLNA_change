//
//  JTCalendarDelegateManager.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarDelegateManager.h"

#import "JTCalendarManager.h"

#import "JTCalendarPageView.h"
#import "JTCalendarWeekDayView.h"
#import "JTCalendarWeekView.h"
#import "JTCalendarDayView.h"


@implementation JTCalendarDelegateManager

#pragma mark - Menu view

- (UIView *)buildMenuItemView
{
    if(_manager.delegate && [_manager.delegate respondsToSelector:@selector(calendarBuildMenuItemView:)]){
        return [_manager.delegate calendarBuildMenuItemView:self.manager];
    }
    
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.userInteractionEnabled = YES;
    label.textColor = [UIColor whiteColor];
    
    UIView *bgBlack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, 50)];
    [bgBlack addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_img.png"]]];
    [label addSubview:bgBlack];
    
    // 上一个月
    UIButton *backwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backwardButton.frame = CGRectMake(70, 13, 15, 15);
    [backwardButton setBackgroundImage:[UIImage imageNamed:@"Attendance/checkin_leftArrow"] forState:UIControlStateNormal] ;
    [backwardButton setBackgroundImage:[UIImage imageNamed:@"Attendance/checkin_leftArrow"] forState:UIControlStateHighlighted] ;
    [backwardButton addTarget:self action:@selector(goBackwardJTCalendar:) forControlEvents: UIControlEventTouchUpInside];
    [bgBlack addSubview:backwardButton];
    
    // 下一个月
    UIButton *forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forwardButton.frame = CGRectMake([UIScreen mainScreen].applicationFrame.size.width-85, 13, 15, 15);
    [forwardButton setBackgroundImage:[UIImage imageNamed:@"Attendance/checkin_rightArrow"] forState:UIControlStateNormal] ;
    [forwardButton setBackgroundImage:[UIImage imageNamed:@"Attendance/checkin_rightArrow"] forState:UIControlStateHighlighted] ;
    
    [forwardButton addTarget:self action:@selector(goForwardJTCalendar:) forControlEvents: UIControlEventTouchUpInside];
    [bgBlack addSubview:forwardButton];

    
    
    return label;
}

- (IBAction)goBackwardJTCalendar:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goBackwardJTCalendar" object:nil];
}

- (IBAction)goForwardJTCalendar:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goForwardJTCalendar" object:nil];
}

- (void)prepareMenuItemView:(UIView *)menuItemView date:(NSDate *)date
{
    if(_manager.delegate && [_manager.delegate respondsToSelector:@selector(calendar:prepareMenuItemView:date:)]){
        [_manager.delegate calendar:self.manager prepareMenuItemView:menuItemView date:date];
        return;
    }
    
    NSString *text = nil;
    
    if(date){
        NSCalendar *calendar = _manager.dateHelper.calendar;
        NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
        NSInteger currentMonthIndex = comps.month;
        
        static NSDateFormatter *dateFormatter = nil;
        if(!dateFormatter){
            dateFormatter = [_manager.dateHelper createDateFormatter];
        }

        dateFormatter.timeZone = _manager.dateHelper.calendar.timeZone;
        dateFormatter.locale = _manager.dateHelper.calendar.locale;
        
        while(currentMonthIndex <= 0){
            currentMonthIndex += 12;
        }
        
        text = [[dateFormatter standaloneMonthSymbols][currentMonthIndex - 1] capitalizedString];
        
        NSInteger month = comps.month;

        
        NSInteger year = comps.year;
        text = [NSString stringWithFormat:@"%ld年%ld月", (long)year, (long)month];
        
        
    }
    
    
    
    [(UILabel *)menuItemView setText:text];
}

#pragma mark - Content view

- (UIView<JTCalendarPage> *)buildPageView
{
    if(_manager.delegate && [_manager.delegate respondsToSelector:@selector(calendarBuildPageView:)]){
        return [_manager.delegate calendarBuildPageView:self.manager];
    }
    
    return [JTCalendarPageView new];
}

- (BOOL)canDisplayPageWithDate:(NSDate *)date
{
    if(_manager.delegate && [_manager.delegate respondsToSelector:@selector(calendar:canDisplayPageWithDate:)]){
        return [_manager.delegate calendar:self.manager canDisplayPageWithDate:date];
    }
    
    return YES;
}

- (NSDate *)dateForPreviousPageWithCurrentDate:(NSDate *)currentDate
{
    NSAssert(currentDate != nil, @"currentDate cannot be nil");
    
    if(_manager.delegate && [_manager.delegate respondsToSelector:@selector(calendar:dateForPreviousPageWithCurrentDate:)]){
        return [_manager.delegate calendar:self.manager dateForPreviousPageWithCurrentDate:currentDate];
    }
    
    if(_manager.settings.weekModeEnabled){
        return [_manager.dateHelper addToDate:currentDate weeks:-1];
    }
    else{
        return [_manager.dateHelper addToDate:currentDate months:-1];
    }
}

- (NSDate *)dateForNextPageWithCurrentDate:(NSDate *)currentDate
{
    NSAssert(currentDate != nil, @"currentDate cannot be nil");
    
    if(_manager.delegate && [_manager.delegate respondsToSelector:@selector(calendar:dateForNextPageWithCurrentDate:)]){
        return [_manager.delegate calendar:self.manager dateForNextPageWithCurrentDate:currentDate];
    }
    
    if(_manager.settings.weekModeEnabled){
        return [_manager.dateHelper addToDate:currentDate weeks:1];
    }
    else{
        return [_manager.dateHelper addToDate:currentDate months:1];
    }
}

#pragma mark - Page view

- (UIView<JTCalendarWeekDay> *)buildWeekDayView
{
    if(_manager.delegate && [_manager.delegate respondsToSelector:@selector(calendarBuildWeekDayView:)]){
        return [_manager.delegate calendarBuildWeekDayView:self.manager];
    }
    
    return [JTCalendarWeekDayView new];
}

- (UIView<JTCalendarWeek> *)buildWeekView
{
    if(_manager.delegate && [_manager.delegate respondsToSelector:@selector(calendarBuildWeekView:)]){
        return [_manager.delegate calendarBuildWeekView:self.manager];
    }
    
    return [JTCalendarWeekView new];
}

#pragma mark - Week view

- (UIView<JTCalendarDay> *)buildDayView
{
    if(_manager.delegate && [_manager.delegate respondsToSelector:@selector(calendarBuildDayView:)]){
        return [_manager.delegate calendarBuildDayView:self.manager];
    }
    
    return [JTCalendarDayView new];
}

#pragma mark - Day view

- (void)prepareDayView:(UIView<JTCalendarDay> *)dayView
{
    if(_manager.delegate && [_manager.delegate respondsToSelector:@selector(calendar:prepareDayView:)]){
        [_manager.delegate calendar:self.manager prepareDayView:dayView];
    }
}

- (void)didTouchDayView:(UIView<JTCalendarDay> *)dayView
{
    if(_manager.delegate && [_manager.delegate respondsToSelector:@selector(calendar:didTouchDayView:)]){
        [_manager.delegate calendar:self.manager didTouchDayView:dayView];
    }
}

@end
