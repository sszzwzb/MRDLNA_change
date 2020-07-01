//
//  ChartListTableViewCell.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/10/9.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "ChartListTableViewCell.h"

@interface ChartListTableViewCell ()<UUChartDataSource>
{
    NSIndexPath *path;
    UUChart *chartView;
}

@end

@implementation ChartListTableViewCell
@synthesize titleLabel;


- (void)configUI:(NSIndexPath *)indexPath
{
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
        
    path = indexPath;
    
   
    chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(0, 50.0, [UIScreen mainScreen].bounds.size.width, 120)
                                                  withSource:self
                                                   withStyle:_type==2?UUChartBarStyle:UUChartLineStyle];

    
    
    chartView.backgroundColor = [UIColor clearColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(7.0, chartView.frame.size.height - 15.0, 308.0, 1.0)];
    //lineView.tag = 222+indexPath.row;
    
    if (_type == 1) {
        
        lineView.backgroundColor =  [UIColor colorWithRed:144.0/255.0 green:232.0/255.0 blue:213.0/255.0 alpha:1];
        _noDataLabel.textColor = [UIColor colorWithRed:144.0/255.0 green:232.0/255.0 blue:213.0/255.0 alpha:1];

    }else if (_type == 2){
        
        lineView.frame = CGRectMake(7.0, chartView.frame.size.height - 15.0 - 6.0, 308.0, 1.0);
        lineView.backgroundColor =  [UIColor colorWithRed:144.0/255.0 green:232.0/255.0 blue:213.0/255.0 alpha:1];
        _noDataLabel.textColor = [UIColor colorWithRed:144.0/255.0 green:232.0/255.0 blue:213.0/255.0 alpha:1];
    }
    else{
        lineView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:198.0/255.0 blue:128.0/255.0 alpha:1];
    }
    
    
    [chartView addSubview:lineView];
    [chartView showInView:self.contentView];
    
}

- (NSArray *)getXTitles:(int)num
{
//    NSMutableArray *xTitles = [NSMutableArray array];
//    for (int i=0; i<num; i++) {
//        NSString * str = [NSString stringWithFormat:@"%d月",i+1];
//        [xTitles addObject:str];
//    }
//    
//    return xTitles;
    
    return _xTitles;
}

#pragma mark - @required
//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart
{
    
    if (path.section==0) {
        /*switch (path.row) {
            case 0:
//                return [self getXTitles:5];
                return [self getXTitles:[_xTitles count]];
            case 1:
                //return [self getXTitles:11];
                //return [self getXTitles:12];
                return [self getXTitles:[_xTitles count]];
            case 2:
               // return [self getXTitles:7];
               // return [self getXTitles:12];
                return [self getXTitles:[_xTitles count]];
//            case 3:
//                return [self getXTitles:7];
            default:
                break;
        }*/
        return [self getXTitles:[_xTitles count]];
        
    }else{
        switch (path.row) {
            case 0:
                return [self getXTitles:11];
            case 1:
                return [self getXTitles:7];
            default:
                break;
        }
    }
    return [self getXTitles:20];
}
//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
//    NSArray *ary = @[@"22",@"44",@"15",@"40",@"42"];
//    NSArray *ary1 = @[@"22",@"54",@"15",@"30",@"42",@"77",@"43"];
//    NSArray *ary2 = @[@"76",@"34",@"54",@"23",@"16",@"32",@"17"];
    NSArray *ary = @[@"30",@"16",@"20",@"16",@"22",@"16",@"32",@"12",@"40",@"42",@"60",@"50"];
    NSArray *ary1 = @[@"220",@"440",@"150",@"400",@"420",@"220",@"440",@"150",@"400",@"420",@"600",@"400"];
    NSArray *ary2 = @[@"220",@"440",@"150",@"400",@"420",@"220",@"440",@"150",@"400",@"420",@"1000",@"800"];
    NSArray *ary3 = @[@"3",@"12",@"25",@"55",@"52"];
    //NSArray *ary4 = @[@"80",@"85.5",@"90"];
    NSArray *ary4 = @[@"22",@"44",@"15"];
    
    if (path.section==0) {
        /*switch (path.row) {
            case 0:
                //return @[ary];
//                NSLog(@"_pointArrayValue:%@",_pointArrayValue);
                return @[_pointArrayValue];
            case 1:
//                return @[ary4];
                //return @[ary1];
                 return @[_pointArrayValue];
            case 2:
                //return @[ary1,ary2];
                //return @[ary2];
                 return @[_pointArrayValue];
            default:
                return @[ary1,ary2,ary3];
        }*/
        return @[_pointArrayValue];
        
    }else{
        if (path.row) {
            return @[ary1,ary2];
        }else{
            return @[ary4];
        }
    }
}

#pragma mark - @optional
//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
//    return @[UUGreen,UURed,UUBrown];
    return @[UUWhite,UUWhite,UUWhite];
}
//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
//    if (path.section==0 && (path.row==0|path.row==1)) {
//        return CGRangeMake(60, 10);
//        
//    }
//    if (path.section==1 && path.row==0) {
//        return CGRangeMake(60, 10);
//    }
    
    if (_type == 1) {//身体
        return CGRangeMake(_yMax, _yMin);
    }else if (_type == 2){
       return CGRangeMake(_yMax, _yMin);
    }
    else{//成绩
        if (path.section == 0 && path.row == 0) {
            //return CGRangeMake(0, 100);
            return CGRangeMake(_yMin, _yMax);
        }
        if (path.section == 0 && path.row == 1) {
            //return CGRangeMake(0, 2000);
            return CGRangeMake(_yMin, _yMax);
        }
        if (path.row==2) {
            //        return CGRangeMake(100, 0);
            //return CGRangeMake(1500, 0);
            return CGRangeMake(_yMax, _yMin);
        }
    }
   
    return CGRangeZero;
}

#pragma mark 折线图专享功能

//标记数值区域
- (CGRange)UUChartMarkRangeInLineChart:(UUChart *)chart
{
//    if (path.row==2) {
//       return CGRangeMake(25, 75);
//    }
    return CGRangeZero;
}

//判断显示横线条
- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

//判断显示最大最小值
- (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index
{
//    return path.row==2;
    return YES;
}


@end
