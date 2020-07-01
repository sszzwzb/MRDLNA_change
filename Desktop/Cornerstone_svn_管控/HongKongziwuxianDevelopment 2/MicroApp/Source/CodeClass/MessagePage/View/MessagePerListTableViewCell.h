//
//  MessagePerListTableViewCell.h
//  MicroApp
//
//  Created by kaiyi on 2018/9/22.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessagePerListTableViewCellDelegate <NSObject>

-(void)tableViewCellDidSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MessagePerListTableViewCell : UITableViewCell

@property (nonatomic,strong) id <MessagePerListTableViewCellDelegate> delegate;


@property (nonatomic,strong) NSIndexPath *indexPath;

-(void)reloadData;
+(CGFloat)cellHeight;

@end
