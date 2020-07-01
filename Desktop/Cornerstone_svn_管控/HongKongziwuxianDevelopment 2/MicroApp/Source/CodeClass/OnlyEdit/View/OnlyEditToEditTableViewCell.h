//
//  OnlyEditToEditTableViewCell.h
//  MicroApp
//
//  Created by kaiyi on 2018/10/9.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OnlyEditToEditViewController;
@class OnlyEditPerSQLModel;



@protocol OnlyEditToEditTableViewCellDelegate <NSObject>

-(void)selectCellForSection0WithModel:(OnlyEditPerSQLModel *)model row:(NSInteger)row;  //  航班选择状态

@end

NS_ASSUME_NONNULL_BEGIN

@interface OnlyEditToEditTableViewCell : UITableViewCell

@property (nonatomic,strong) id <OnlyEditToEditTableViewCellDelegate> delegate;

@property (nonatomic,strong) OnlyEditPerSQLModel *model;

@property (nonatomic,strong) NSIndexPath *indexPath;
-(void)reloadData;
+(CGFloat)cellHeithWithSection:(NSInteger)section imgToolHeight:(CGFloat)imgToolHeight;

@end

NS_ASSUME_NONNULL_END



@protocol OnlyEditToEditTableViewCellImgAndTextDelegate <NSObject>

-(void)selectImgButAndTextBut:(NSInteger)tag;

@end

@interface OnlyEditToEditTableViewCellImgAndText : UIView

@property (nonatomic,strong) UIButton *butImg;  //   图片
@property (nonatomic,strong) NSString *textContent;  //  备注

-(void)setImgStr:(NSString *)imgStr isHidden:(BOOL)isHidden isAdd:(BOOL)isAdd;

@property (nonatomic,strong) id <OnlyEditToEditTableViewCellImgAndTextDelegate> butDelegate;

@end
