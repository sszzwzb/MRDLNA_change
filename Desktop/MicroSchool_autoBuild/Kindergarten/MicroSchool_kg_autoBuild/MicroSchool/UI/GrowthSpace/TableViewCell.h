//
//  TableViewCell.h
//  UUChartView
//
//  Created by shake on 15/1/4.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell


@property (nonatomic,assign) float yMin;
@property (nonatomic,assign) float yMax;
@property (nonatomic, strong) NSMutableArray *pointArrayValue;
@property (nonatomic, strong) NSMutableArray *xTitles;
@property (strong, nonatomic) IBOutlet UILabel *noDataLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bgImgV;
@property (strong, nonatomic) IBOutlet UILabel *titleLeftLabel;
@property (strong, nonatomic) IBOutlet UILabel *unitLabel;
@property (assign, nonatomic) NSInteger type;//图标类型 成绩/身体/对比柱状图
@property (strong, nonatomic) IBOutlet UIView *lineV;
- (void)configUI:(NSIndexPath *)indexPath;

@end
