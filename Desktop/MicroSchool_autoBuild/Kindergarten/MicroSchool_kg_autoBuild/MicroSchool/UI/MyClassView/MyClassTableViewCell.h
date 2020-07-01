//
//  MyClassTableViewCell.h
//  MicroSchool
//
//  Created by jojo on 14-1-14.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol myClassCellDelegate <NSObject>
@optional
- (void)operateClassCallback:(NSMutableArray*)cellArray;//对班级进行加减操作
@end

@interface MyClassTableViewCell : UITableViewCell
{
    UILabel *label_className;
    id<myClassCellDelegate> delegate;
    UIButton *operateBtn;// 加减班级按钮
}

@property (copy, nonatomic) NSString *className;
@property (copy, nonatomic) UIImageView *imgView_thumb;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,assign) NSInteger isJoined;
@property (nonatomic,assign) NSString *classID;
@property (nonatomic,retain) id<myClassCellDelegate> delegate;
@property (nonatomic,assign) NSInteger flag;//判断是那个列表
@end
