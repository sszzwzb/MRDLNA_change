//
//  OnlyEditToEditTableHeaderAlertView.h
//  MicroApp
//
//  Created by kaiyi on 2018/10/9.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OnlyEditPerSQLModel;

NS_ASSUME_NONNULL_BEGIN

@interface OnlyEditToEditTableHeaderAlertView : UIView

@property (nonatomic,strong) OnlyEditPerSQLModel *curentModel;  //  当前选择的mmodel

@property (nonatomic,strong) NSArray *dataArr;

-(void)reloadData;

typedef void (^getSelectairplaneType) (OnlyEditPerSQLModel *model);
@property (nonatomic,strong) getSelectairplaneType getSelectairplaneType;

-(void)selectSelectairplaneType:(getSelectairplaneType)getSelectairplaneType;

@end

NS_ASSUME_NONNULL_END



@interface OnlyEditToEditTableHeaderAlertViewButton : UIButton

@end
