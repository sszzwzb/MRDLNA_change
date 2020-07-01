//
//  OnlyEditToEditTableHeaderView.h
//  MicroApp
//
//  Created by kaiyi on 2018/10/9.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol OnlyEditToEditTableHeaderViewDelegate <NSObject>

-(void)selectHeaderDate:(NSString *)date;  //  选择日期
-(void)selectHeaderType:(NSString *)type InfoId:(NSString *)indoId;  //  选择机型

@end

NS_ASSUME_NONNULL_BEGIN

@interface OnlyEditToEditTableHeaderView : UITableViewHeaderFooterView

@property (nonatomic,strong) id <OnlyEditToEditTableHeaderViewDelegate> delegate;

@property (nonatomic,strong) UITableView *curTableView;

@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) NSString *selectDateStr;  //  选择好的日期
@property (nonatomic,strong) NSString *selectAirPlaneType;  //  选择好的飞机机型

-(void)reloadData;
+(CGFloat)haederHeight;

@end

NS_ASSUME_NONNULL_END


@interface OnlyEditToEditTableHeaderButton : UIButton

@end

