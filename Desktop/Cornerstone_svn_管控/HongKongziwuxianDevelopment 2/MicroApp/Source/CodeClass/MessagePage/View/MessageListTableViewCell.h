//
//  MessageListTableViewCell.h
//  MicroApp
//
//  Created by kaiyi on 2018/9/21.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessageListTableViewCellDelegate <NSObject>

-(void)tableViewCellDidSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MessageListTableViewCell : UITableViewCell

@property (nonatomic,strong) id <MessageListTableViewCellDelegate> delegate;


@property (nonatomic,strong) NSIndexPath *indexPath;

-(void)reloadData;
+(CGFloat)cellHeight;

@end
