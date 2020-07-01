//
//  TableViewCell.m
//  UUChartView
//
//  Created by shake on 15/1/4.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "TableViewCell.h"
#import "UUChart.h"

@interface TableViewCell ()<UUChartDataSource>
{
    NSIndexPath *path;
    UUChart *chartView;
}
@end

@implementation TableViewCell

- (void)configUI:(NSIndexPath *)indexPath
{
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    
    path = indexPath;

    chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 120)
                                              withSource:self
                                               withStyle:UUChartBarStyle];
    chartView.backgroundColor = [UIColor clearColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(7.0, chartView.frame.size.height - 15.0 - 6.0, 308.0, 1.0)];
    lineView.backgroundColor =  [UIColor colorWithRed:144.0/255.0 green:232.0/255.0 blue:213.0/255.0 alpha:1];
    [chartView addSubview:lineView];
    [chartView showInView:self.contentView];
}

- (NSArray *)getXTitles:(int)num
{
//    NSMutableArray *xTitles = [NSMutableArray array];
//    for (int i=0; i<num; i++) {
//        NSString * str = [NSString stringWithFormat:@"R-%d",i];
//        [xTitles addObject:str];
//    }
//    return xTitles;
    
    return _xTitles;
}

#pragma mark - @required
//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart
{

    if (path.section==0) {
        
        return [self getXTitles:3];
        
    }else{
        switch (path.row) {
            case 0:
                //return [self getXTitles:11];
                return [self getXTitles:3];
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
    NSArray *ary = @[@"22",@"44",@"15",@"40",@"42"];
    NSArray *ary1 = @[@"22",@"54",@"15",@"30",@"42",@"77",@"43"];
    NSArray *ary2 = @[@"76",@"34",@"54",@"23",@"16",@"32",@"17"];
    NSArray *ary3 = @[@"3",@"12",@"25",@"55",@"52"];
    //NSArray *ary4 = @[@"23",@"42",@"25",@"15",@"30",@"42",@"32",@"40",@"42",@"25",@"33"];
    NSArray *ary4 = @[@"80",@"85.5",@"91"];
    //NSArray *ary4 = @[@"22",@"44",@"15"];
    if (path.section==0) {
//        switch (path.row) {
//            case 0:
//                return @[ary];
//            case 1:
//                return @[ary4];
//            case 2:
//                return @[ary1,ary2];
//            default:
//                return @[ary1,ary2,ary3];
//        }
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
    return @[UUWhite,UURed,UUYellow];
}
//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
//    if (path.section==0 && (path.row==0|path.row==1)) {
//        return CGRangeMake(110, 0);
//    }
//    if (path.section==1 && path.row==0) {
//        //return CGRangeMake(60, 10);
//        return CGRangeMake(110, 0);
//    }
//    if (path.row==2) {
//        return CGRangeMake(100, 0);
//    }
    
    return CGRangeMake(_yMax+10.0, _yMin);
    //return CGRangeZero;
}

#pragma mark 折线图专享功能

//标记数值区域
- (CGRange)UUChartMarkRangeInLineChart:(UUChart *)chart
{
//    if (path.row==2) {
//        return CGRangeMake(25, 75);
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
    //return path.row==2;
    return YES;
}
@end
