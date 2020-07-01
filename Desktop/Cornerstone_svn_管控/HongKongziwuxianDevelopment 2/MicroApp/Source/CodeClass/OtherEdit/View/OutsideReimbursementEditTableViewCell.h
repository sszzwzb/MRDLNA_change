//
//  OutsideReimbursementEditTableViewCell.h
//  MicroApp
//
//  Created by kaiyi on 2018/10/14.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OnlyEditPerSQLModel;


@protocol OutsideReimbursementEditTableViewCellDelegate <NSObject>

-(void)selectCellForSection0WithModel:(OnlyEditPerSQLModel *)model row:(NSInteger)row;  //  航班选择状态
-(void)TextOutWithDic:(NSDictionary *)textdic;

@end

NS_ASSUME_NONNULL_BEGIN

@interface OutsideReimbursementEditTableViewCell : UITableViewCell

@property (nonatomic,strong) id <OutsideReimbursementEditTableViewCellDelegate> delegate;

@property (nonatomic,strong) OnlyEditPerSQLModel *model;

@property (nonatomic,strong) NSIndexPath *indexPath;
-(void)reloadDataWithType:(NSInteger)tag;
+(CGFloat)cellHeithWithIndexPath:(NSIndexPath *)indexPath imgToolHeight:(CGFloat)imgToolHeight;

@end

NS_ASSUME_NONNULL_END
