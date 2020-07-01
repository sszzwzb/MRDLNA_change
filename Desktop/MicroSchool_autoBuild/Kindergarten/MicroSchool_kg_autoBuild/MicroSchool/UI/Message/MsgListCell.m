//
//  MsgListCell.m
//  ShenMaPassenger
//
//  Created by kakashi on 14-2-24.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import "MsgListCell.h"
#import "PublicConstant.h"
#import "UIHeadImage.h"
#import "DBDao.h"
#import "Utilities.h"
#import "FRNetPoolUtils.h"

@implementation MsgListCell

@synthesize nameLabel;
@synthesize timeLabel;
@synthesize headImageView;
@synthesize unReadCnt;
@synthesize unReadLabel;
@synthesize detailLabel;
@synthesize chatListObject;
@synthesize mixChatListObject;
@synthesize unReadBadgeView;
@synthesize sendFailed;
@synthesize groupChatListObject;
@synthesize headImageViewForGroup;
@synthesize botherImgV;// 2015.06.10
@synthesize isAtLabel;// 2016.07.05

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(67+10, 5, 170-10, 35)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.tag = 223;
        [self.contentView addSubview:nameLabel];
        //[nameLabel release];
        
        //        sendFailed = [[UIImageView alloc] initWithFrame:CGRectMake(67, 40, 12, 13)];
        //        sendFailed.image = [UIImage imageNamed:@"icon_status_error.png"];
        sendFailed = [[UIImageView alloc] initWithFrame:CGRectMake(67, 39, 15, 15)];
        sendFailed.image = [UIImage imageNamed:@"SendFailTip.png"];//update 2015.07.17
        [self.contentView addSubview:sendFailed];
        //[sendFailed release];
        
        //新增提醒的人显示 2016.07.05
        isAtLabel = [[UILabel alloc] initWithFrame:CGRectMake(67+10, 34,75.0, 26)];
        isAtLabel.backgroundColor = [UIColor clearColor];
        isAtLabel.font = [UIFont systemFontOfSize:16.0];
        isAtLabel.textColor = [UIColor colorWithRed:226.0/255.0 green:87.0/255.0 blue:76.0/255.0 alpha:1];
        isAtLabel.text = @"[有人@我]";
        isAtLabel.hidden = YES;
        [self.contentView addSubview:isAtLabel];
        
        detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, 34, [[UIScreen mainScreen] bounds].size.width - 67 - 10, 26)];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.font = [UIFont systemFontOfSize:13.0];
        detailLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:detailLabel];
        //[detailLabel release];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 40.0-5, 10, 40, 18)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont systemFontOfSize:11];
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:timeLabel];
        //[timeLabel release];
        
        headImageViewForGroup = [[UIImageView alloc] initWithFrame:CGRectMake(6+4, (HEIGHT_CHATLIST_CELL - HEIGHT_HEAD_CELL_IMAGE)/2, WIDTH_HEAD_CELL_IMAGE, HEIGHT_HEAD_CELL_IMAGE)];
        headImageViewForGroup.layer.masksToBounds = YES;
        headImageViewForGroup.layer.cornerRadius = headImageViewForGroup.frame.size.height/2.0;//2016.07.11
        
        //headImageViewForGroup.image = [UIImage imageNamed:@"loading_gray.png"];
        
        headImageView = [[UIHeadImage alloc] initWithFrame:CGRectMake(6+4, (HEIGHT_CHATLIST_CELL - HEIGHT_HEAD_CELL_IMAGE)/2, WIDTH_HEAD_CELL_IMAGE, HEIGHT_HEAD_CELL_IMAGE)];
        //headImageView.userInteractionEnabled = YES;
        
        // 通讯录为圆形头像
        headImageView.image = [UIImage imageNamed:@"icon_avatar_big.png"];
        headImageView.layer.masksToBounds = YES;
        headImageView.layer.cornerRadius = headImageView.frame.size.height/2.0;
        
        [self.contentView addSubview:headImageViewForGroup];
        [self.contentView addSubview:headImageView];
        //[headImageView release];
        
        CGRect frame = headImageView.frame;
        UIImage *unReadImage = [UIImage imageNamed:@"icon_new.png"];
        unReadBadgeView = [[UIImageView alloc] initWithImage:[unReadImage stretchableImageWithLeftCapWidth:9.5 topCapHeight:9.5]];
        unReadBadgeView.frame = CGRectMake(frame.origin.x + WIDTH_HEAD_CELL_IMAGE - 14, frame.origin.y - 2, 19, 19);
        [self.contentView addSubview:unReadBadgeView];
        //[unReadBadgeView release];
        
        unReadLabel = [[UILabel alloc] initWithFrame:unReadBadgeView.frame];
        unReadLabel.backgroundColor = [UIColor clearColor];
        unReadLabel.textColor = [UIColor whiteColor];
        unReadLabel.textAlignment = NSTextAlignmentCenter;
        unReadLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:unReadLabel];
        //[unReadLabel release];
        
        // 免打扰图片
        botherImgV = [[UIImageView alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-19.0 -5, 66.0 - 19.0-5.0, 19.0, 19.0)];
        [self.contentView addSubview:botherImgV];
        
    }
    return self;
}

/*- (void)dealloc
{
    self.nameLabel = nil;
    self.detailLabel = nil;
    self.timeLabel = nil;
    self.headImageView = nil;
    self.chatListObject = nil;
    self.unReadBadgeView = nil;
    self.unReadLabel = nil;
    self.sendFailed = nil;
    
    [super dealloc];
}*/

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setName:(NSString *)nameStr{
    
    nameLabel.frame = CGRectMake(67+10, 5, 170-10, 35);
    [nameLabel setText:nameStr];
    [nameLabel setNeedsDisplay];
}

- (void)setDetail:(NSString *)detailText
{
    if (self.sendFailed.hidden && self.isAtLabel.hidden) {
         detailLabel.frame = CGRectMake(67+10, 34, [UIScreen mainScreen].bounds.size.width *0.78125 -5-15-10, 26);
    }else if(!self.sendFailed.hidden && self.isAtLabel.hidden){
         sendFailed.frame = CGRectMake(67+10, 39, 15, 15);
         detailLabel.frame = CGRectMake(67+15+10+3, 34, [UIScreen mainScreen].bounds.size.width *0.78125-15-10-5, 26);
    }else if (self.sendFailed.hidden && !self.isAtLabel.hidden){
         detailLabel.frame = CGRectMake(67+80+10, 34, [UIScreen mainScreen].bounds.size.width *0.78125-5-15-10-80, 26);
    }else if (!self.sendFailed.hidden && !self.isAtLabel.hidden){
        detailLabel.frame = CGRectMake(67+80+15+10, 34, [UIScreen mainScreen].bounds.size.width *0.78125-5-15-10-80-15, 26);
        sendFailed.frame = CGRectMake(67+7+80, 39, 15, 15);
    }
   
    [detailLabel setText:detailText];
    [detailLabel setNeedsDisplay];
}

// 设置时间，根据time长度调整title的长度
- (void)setTime:(NSString *)time
{
    self.timeLabel.text = time;
    
    if ([time length] > 5) {
        timeLabel.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - 85.0 - 10.0, 10, 80+5, 18);
    } else {
        timeLabel.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - 45.0 - 10.0, 10, 40+5, 18);
    }
}

- (void)setHeadImage:(long long)user_id
{
    //设置用户头像
    [headImageView setMember:user_id];
}

@end
