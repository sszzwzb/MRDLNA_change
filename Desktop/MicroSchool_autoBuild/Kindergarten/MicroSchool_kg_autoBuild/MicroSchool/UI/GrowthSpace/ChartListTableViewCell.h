//
//  ChartListTableViewCell.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/10/9.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUChart.h"

@interface ChartListTableViewCell : UITableViewCell{
    
   // NSMutableArray *array;
}
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
//@property (nonatomic, strong) NSDictionary *dataDic;
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
