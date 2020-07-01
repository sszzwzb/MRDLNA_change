//
//  OnlyEditPerTableViewCell.h
//  MicroApp
//
//  Created by kaiyi on 2018/10/8.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OnlyEditPerSQLModel;


@protocol OnlyEditPerTableViewCellDelegate <NSObject>

-(void)selectCellButtonWithType:(NSString *)type didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end



NS_ASSUME_NONNULL_BEGIN

@interface OnlyEditPerTableViewCell : UITableViewCell

@property (nonatomic,strong) id <OnlyEditPerTableViewCellDelegate> delegate;

@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) NSString *type;  //   工作任务0  待上传1  已完成2
@property (nonatomic,strong) OnlyEditPerSQLModel *model;
-(void)reloadData;
+(CGFloat)cellheight;


@end

NS_ASSUME_NONNULL_END


@interface OnlyEditPerTableViewCellIconView : UIView

-(void)setTitle:(NSString *)title imgPathUrl:(NSString *)imgPathUrl numStr:(NSString *)numStr;

@end
