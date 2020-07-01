//
//  MsgDetailCell.m
//  ShenMaPassenger
//
//  Created by kakashi on 14-2-24.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import "MsgDetailCell.h"
#import "ImageResourceLoader.h"
#import "PublicConstant.h"
#import "Utilities.h"

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:a]
#define timeFontSMS   [UIFont systemFontOfSize:12] //时间的字体

@implementation MsgDetailCell

@synthesize entity;
@synthesize entityForMix;
@synthesize customDelegate;
@synthesize chatView;
@synthesize textView;
@synthesize picView;
@synthesize audioView;
@synthesize timeLabel;
@synthesize isNewEntity;
@synthesize msgType;
@synthesize sendStateBtn;
@synthesize msgID;
@synthesize sendProgress;
@synthesize headBgView;

@synthesize fromName;
@synthesize systemView;// 2015.05.29
@synthesize entityForGroup;
@synthesize nameLabel;// 2015.07.17


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;		
		self.backgroundColor = [UIColor clearColor];
		self.contentView.backgroundColor = [UIColor clearColor];
		self.clipsToBounds = NO;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.sendStateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sendStateBtn.frame = CGRectZero;
        self.sendStateBtn.tag = TAG_STATE_BUTTON;
        self.sendStateBtn.backgroundColor = [UIColor clearColor];
        
		// time
		CGRect timeRect = CGRectMake((self.bounds.size.width - TIME_WIDTH)/2 , 0, TIME_WIDTH, TIME_HEIGHT);
		UILabel *timeLabelTmp = [[UILabel alloc] initWithFrame:timeRect];
        self.timeLabel = timeLabelTmp;
		timeLabelTmp.textColor = RGBACOLOR(140, 145, 158,1);
		timeLabelTmp.backgroundColor = [UIColor clearColor];
		timeLabelTmp.font = [UIFont systemFontOfSize:11];
        timeLabelTmp.text = @"20120425";
		[self.contentView addSubview:timeLabelTmp];
        //[timeLabelTmp release];
        
        // name add 2015.07.17-----------------------------------------------------------------------------------
        CGRect nameRect = CGRectMake(LEFT_DISTANCE_CHAT_HEAD , TIME_HEIGHT, TIME_WIDTH, TIME_HEIGHT);
        UILabel *nameLabelTmp = [[UILabel alloc] initWithFrame:nameRect];
        self.nameLabel = nameLabelTmp;
        nameLabelTmp.textColor = RGBACOLOR(140, 145, 158,1);
        nameLabelTmp.backgroundColor = [UIColor clearColor];
        nameLabelTmp.font = [UIFont systemFontOfSize:11];
        nameLabelTmp.text = @"";
        nameLabelTmp.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:nameLabelTmp];
        //[nameLabelTmp release];
        //-------------------------------------------------------------------------------------------------------
        
        headBgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_chat_myphoto"]];
        headBgView.userInteractionEnabled = YES;
		
		// content
		self.msgType = [reuseIdentifier intValue];
        
        //statImgRead = [[UIImage imageNamed:@"icon_status_read.png"] retain];
        statImgRead = [UIImage imageNamed:@"icon_status_read.png"];
//        statImgUnread = [[UIImage imageNamed:@"icon_status_error.png"] retain];
        //statImgUnread = [[UIImage imageNamed:@"SendFailTip.png"] retain];//update 2015.07.17
        statImgUnread = [UIImage imageNamed:@"SendFailTip.png"];
        
        imgReviceFail = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_recive_failed"]];
        
        sendProgress = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        sendProgress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        
        selfHeadImage = [[UIHeadImage alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        [selfHeadImage setRound:0];
        selfHeadImage.userInteractionEnabled = YES;
        selfHeadImage.delegate = self;
        selfHeadImage.exclusiveTouch = YES;
        
        userHeadImage = [[UIHeadImage alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        [userHeadImage setRound:0];
        userHeadImage.userInteractionEnabled = YES;
        userHeadImage.delegate = self;
        userHeadImage.exclusiveTouch = YES;
        
        textView = [[MsgTextView alloc] init];
        picView = [[MsgPicView alloc] init];
        audioView = [[MsgAudioView alloc] init];
        systemView = [[MsgSystemView alloc]init];// 2015.05.30
        
    }
    return self;
}

- (void)dealloc 
{
    //[entity release];
    entity = nil;
    
    //[sendStateBtn release];
    sendStateBtn = nil;
    
    [sendProgress stopAnimating];
    //[sendProgress release];
    sendProgress = nil;
    
    self.textView = nil;
    self.picView = nil;
    self.audioView = nil;
    self.systemView = nil;//add 2015.05.30
    self.timeLabel = nil;
    self.nameLabel = nil;// add 2015.07.17
    
    //[headBgView release];
    headBgView = nil;
    
    //[statImgRead release];
    statImgRead = nil;
    
    //[statImgUnread release];
    statImgUnread = nil;
    
    //[imgReviceFail release];
    imgReviceFail = nil;
    
   // [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)updataCell:(ChatDetailObject *)newEntity updateState:(BOOL)updateState
{
    self.entity = newEntity;
    self.msgID = newEntity.msg_id;
    
    //NSString *thumbImagePath = entity.msg_file;//
    //NSLog(@"thumbImagePath:%@",thumbImagePath);
    
    if (!updateState) {
        [[self.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        switch (self.msgType) {
            case CELL_TYPE_TEXT:
                [self updataTextView:newEntity];
                break;
            case CELL_TYPE_PIC:
                [self updataPicView:newEntity];
                break;
            case CELL_TYPE_AUDIO:
                [self updataAudioView:newEntity];
                break;
            default:
                break;
        }
    }
    
    [self.chatView setNeedsLayout];
    
    [self.contentView addSubview:self.timeLabel];
    
    [selfHeadImage removeFromSuperview];
    [userHeadImage removeFromSuperview];
    
    //修改聊天界面第一个pop距离navbar的位置
    CGRect popRect = self.chatView.frame;
    self.chatView.frame = CGRectMake(popRect.origin.x, TIME_HEIGHT, popRect.size.width, popRect.size.height);

    timeLabel.frame = CGRectMake((WIDTH - TIME_WIDTH)/2, 3, TIME_WIDTH, TIME_HEIGHT);
    timeLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:headBgView];
    
    if (newEntity.is_recieved == MSG_IO_FLG_RECEIVE){
        
        CGRect headFrame = CGRectMake(3, 2.5, 35, 35);
        
//        if (newEntity.msg_type == MSG_TYPE_TEXT) {// update 2015.07.17
//            
//            headFrame = CGRectMake(3, self.textView.bgView.frame.size.height-35-5, 35, 35);
//            
//        }
        //CGRect headFrame = CGRectMake(3, self.textView.bgView.frame.size.height-35-5, 35, 35);
        
        userHeadImage.frame = headFrame;
        CGRect headBgFrame = CGRectMake(5, 23, 41, 41);
        headBgView.frame = headBgFrame;
        headBgView.image = [UIImage imageNamed:@"bg_chat_myphoto"];
        //timeLabel.frame = CGRectMake(47, 3, TIME_WIDTH, TIME_HEIGHT);
        //timeLabel.textAlignment = NSTextAlignmentLeft;
        [headBgView addSubview:userHeadImage];
    } else {
        
        CGRect headFrame = CGRectMake(3, 2.5, 35, 35);
//        if (newEntity.msg_type == MSG_TYPE_TEXT) {//update 2015.07.17
//            headFrame = CGRectMake(3, self.textView.bgView.frame.size.height-35-5, 35, 35);
//            
//        }
        //CGRect headFrame = CGRectMake(3, self.textView.bgView.frame.size.height-35-5, 35, 35);
        
        selfHeadImage.frame = headFrame;
        CGRect headBgFrame = CGRectMake([UIScreen mainScreen].bounds.size.width- 5 - 41.0,23, 41, 41);
        headBgView.frame = headBgFrame;
        headBgView.image = [UIImage imageNamed:@"bg_chat_myphoto"];
        //timeLabel.frame = CGRectMake(109, 3, TIME_WIDTH, TIME_HEIGHT);
        //timeLabel.textAlignment = NSTextAlignmentRight;
        [headBgView addSubview:selfHeadImage];
    }
    
    if (entity.is_recieved == MSG_IO_FLG_RECEIVE) {
        CGRect chatViewFrame = self.chatView.frame;
        if (MSG_RECEIVED_FAIL == entity.msg_state) {
            CGRect stateFrame = CGRectMake(chatViewFrame.origin.x + chatViewFrame.size.width + 10, chatViewFrame.origin.y + chatViewFrame.size.height / 2 - 5, 12, 13);
            imgReviceFail.frame = stateFrame;
            [self.contentView addSubview:imgReviceFail];
        }
    } else if (entity.is_recieved == MSG_IO_FLG_SEND) {
        
        CGRect chatViewFrame = self.chatView.frame;
        CGRect stateFrame = CGRectMake(chatViewFrame.origin.x - 47, chatViewFrame.origin.y + chatViewFrame.size.height / 2 - 27, 57, 57);
        CGRect progressFrame = CGRectMake(chatViewFrame.origin.x - 27, chatViewFrame.origin.y + chatViewFrame.size.height / 2, 10, 10);
        sendStateBtn.frame = stateFrame;
        sendStateBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        sendStateBtn.accessibilityFrame = CGRectMake(stateFrame.origin.x , chatViewFrame.origin.y - 15, stateFrame.size.width , chatViewFrame.size.height);
        sendProgress.frame = progressFrame;
        if (MSG_SEND_SUCCESS == entity.msg_state) {
            [sendStateBtn setImage:statImgRead forState:UIControlStateNormal];
            [self.contentView addSubview:sendStateBtn];
        } else if (MSG_SEND_FAIL == entity.msg_state) {
            [sendStateBtn setImage:statImgUnread forState:UIControlStateNormal];
            [self.contentView addSubview:sendStateBtn];
        } else if (MSG_SENDING == entity.msg_state) {
            if (CELL_TYPE_TEXT == self.msgType) {
                sendProgress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
                [sendProgress startAnimating];
                [self.contentView addSubview:sendProgress];
            } else if (CELL_TYPE_PIC == self.msgType) {
                progressFrame = CGRectMake(chatViewFrame.origin.x + chatViewFrame.size.width / 2 - 8, chatViewFrame.origin.y + chatViewFrame.size.height / 2 - 8, 10, 10);
                sendProgress.frame = progressFrame;
                sendProgress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
                [sendProgress startAnimating];
                [self.contentView addSubview:sendProgress];
            }
        }
    }
}

//---add 2015.05.29
- (void)updataCellForGroup:(GroupChatDetailObject *)newEntity updateState:(BOOL)updateState
{
    self.entityForGroup = newEntity;
    self.msgID = newEntity.msg_id;
    
//    NSString *thumbImagePath = entity.msg_file;//
//    NSLog(@"thumbImagePath:%@",thumbImagePath);
    
    if (!updateState) {
        [[self.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        switch (self.msgType) {
            case CELL_TYPE_TEXT:
                [self updataTextViewForGroup:newEntity];
                break;
            case CELL_TYPE_PIC:
                [self updataPicViewForGroup:newEntity];
                break;
            case CELL_TYPE_AUDIO:
                [self updataAudioViewForGroup:newEntity];
                break;
            case 3://To do:更新系统消息的view,要写一个新的
                [self updataSystemViewForGroup:newEntity];
                break;
            case 4://To do:更新系统消息的view,要写一个新的
                 [self updataSystemViewForGroup:newEntity];
                break;
            case 5://To do:更新系统消息的view,要写一个新的
                 [self updataSystemViewForGroup:newEntity];
                break;
            default:
                break;
        }
    }
    
    [self.chatView setNeedsLayout];
    
    [self.contentView addSubview:self.timeLabel];
    
    // 2015.07.17
    if (self.msgType == CELL_TYPE_TEXT || self.msgType == CELL_TYPE_PIC || self.msgType == CELL_TYPE_AUDIO) {
         [self.contentView addSubview:self.nameLabel];
    }
    
    
    [selfHeadImage removeFromSuperview];
    [userHeadImage removeFromSuperview];
    
    //修改聊天界面第一个pop距离navbar的位置
    CGRect popRect = self.chatView.frame;
    self.chatView.frame = CGRectMake(popRect.origin.x, TIME_HEIGHT, popRect.size.width, popRect.size.height);
    
    timeLabel.frame = CGRectMake((WIDTH - TIME_WIDTH)/2, 3, TIME_WIDTH, TIME_HEIGHT);
    timeLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:headBgView];
    
    if (newEntity.is_recieved == MSG_IO_FLG_RECEIVE){
        
//        CGRect headFrame = CGRectMake(3, 2.5, 35, 35);
//        if (newEntity.msg_type == MSG_TYPE_TEXT) {//update 2015.07.17
//            
//            headFrame = CGRectMake(3, self.textView.bgView.frame.size.height-35-5, 35, 35);
//            
//        }
        
        CGRect headFrame = CGRectMake(3, 2.5, 35, 35);
        
        userHeadImage.frame = headFrame;
        CGRect headBgFrame = CGRectMake(5, 23, 41, 41);
        headBgView.frame = headBgFrame;
        headBgView.image = [UIImage imageNamed:@"bg_chat_myphoto"];
        //timeLabel.frame = CGRectMake(47, 3, TIME_WIDTH, TIME_HEIGHT);
        //timeLabel.textAlignment = NSTextAlignmentLeft;
        [headBgView addSubview:userHeadImage];
    } else {
        
        CGRect headFrame = CGRectMake(3, 2.5, 35, 35);
//        if (newEntity.msg_type == MSG_TYPE_TEXT) {//update 2015.07.17
//            headFrame = CGRectMake(3, self.textView.bgView.frame.size.height-35-5, 35, 35);
//           
//        }
       
        
        selfHeadImage.frame = headFrame;
        CGRect headBgFrame = CGRectMake([UIScreen mainScreen].bounds.size.width- 5 - 41.0,23, 41, 41);
        headBgView.frame = headBgFrame;
        headBgView.image = [UIImage imageNamed:@"bg_chat_myphoto"];
        //timeLabel.frame = CGRectMake(109, 3, TIME_WIDTH, TIME_HEIGHT);
        //timeLabel.textAlignment = NSTextAlignmentRight;
        [headBgView addSubview:selfHeadImage];
    }
    
    if (newEntity.is_recieved == MSG_IO_FLG_RECEIVE) {
        CGRect chatViewFrame = self.chatView.frame;
        if (MSG_RECEIVED_FAIL == entity.msg_state) {
            CGRect stateFrame = CGRectMake(chatViewFrame.origin.x + chatViewFrame.size.width + 10, chatViewFrame.origin.y + chatViewFrame.size.height / 2 - 5, 12, 13);
            imgReviceFail.frame = stateFrame;
            [self.contentView addSubview:imgReviceFail];
        }
    } else if (newEntity.is_recieved == MSG_IO_FLG_SEND) {
        
        CGRect chatViewFrame = self.chatView.frame;
        CGRect stateFrame = CGRectMake(chatViewFrame.origin.x - 47, chatViewFrame.origin.y + chatViewFrame.size.height / 2 - 27, 57, 57);
        CGRect progressFrame = CGRectMake(chatViewFrame.origin.x - 27, chatViewFrame.origin.y + chatViewFrame.size.height / 2 - 5, 10, 10);
        
        if (newEntity.msg_type == 2) {
            stateFrame = CGRectMake(chatViewFrame.origin.x - 47, chatViewFrame.origin.y + chatViewFrame.size.height / 2 - 20, 57, 57);
        }
        
        sendStateBtn.frame = stateFrame;
        sendStateBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        sendStateBtn.accessibilityFrame = CGRectMake(stateFrame.origin.x , chatViewFrame.origin.y - 15, stateFrame.size.width , chatViewFrame.size.height);
        sendProgress.frame = progressFrame;
        if (MSG_SEND_SUCCESS == newEntity.msg_state) {
            [sendStateBtn setImage:statImgRead forState:UIControlStateNormal];
            [self.contentView addSubview:sendStateBtn];
        } else if (MSG_SEND_FAIL == newEntity.msg_state) {
            [sendStateBtn setImage:statImgUnread forState:UIControlStateNormal];
            [self.contentView addSubview:sendStateBtn];
        } else if (MSG_SENDING == newEntity.msg_state) {
            if (CELL_TYPE_TEXT == self.msgType) {
                sendProgress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
                [sendProgress startAnimating];
                [self.contentView addSubview:sendProgress];
            } else if (CELL_TYPE_PIC == self.msgType) {
                progressFrame = CGRectMake(chatViewFrame.origin.x + chatViewFrame.size.width / 2 - 8, chatViewFrame.origin.y + chatViewFrame.size.height / 2 - 8, 10, 10);
                sendProgress.frame = progressFrame;
                sendProgress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
                [sendProgress startAnimating];
                [self.contentView addSubview:sendProgress];
            }
        }
    }
}

// 2016.01.19
- (void)updataCellForMix:(MixChatDetailObject *)newEntity updateState:(BOOL)updateState
{
    self.entityForMix = newEntity;
    self.msgID = newEntity.msg_id;
    
    //    NSString *thumbImagePath = entity.msg_file;//
    //    NSLog(@"thumbImagePath:%@",thumbImagePath);
    
    if (!updateState) {
        [[self.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        switch (self.msgType) {
            case CELL_TYPE_TEXT:
                [self updataTextViewForMix:newEntity];
                break;
            case CELL_TYPE_PIC:
                [self updataPicViewForMix:newEntity];
                break;
            case CELL_TYPE_AUDIO:
                [self updataAudioViewForMix:newEntity];
                break;
            case 3://To do:更新系统消息的view,要写一个新的
                [self updataSystemViewForMix:newEntity];
                break;
            case 4://To do:更新系统消息的view,要写一个新的
                [self updataSystemViewForMix:newEntity];
                break;
            case 5://To do:更新系统消息的view,要写一个新的
                [self updataSystemViewForMix:newEntity];
                break;
            default:
                break;
        }
    }
    
    [self.chatView setNeedsLayout];
    
    [self.contentView addSubview:self.timeLabel];
    
    // 2015.07.17
    if (self.msgType == CELL_TYPE_TEXT || self.msgType == CELL_TYPE_PIC || self.msgType == CELL_TYPE_AUDIO) {
        [self.contentView addSubview:self.nameLabel];
    }
    
    
    [selfHeadImage removeFromSuperview];
    [userHeadImage removeFromSuperview];
    
    //修改聊天界面第一个pop距离navbar的位置
    CGRect popRect = self.chatView.frame;
    self.chatView.frame = CGRectMake(popRect.origin.x, TIME_HEIGHT, popRect.size.width, popRect.size.height);
    
    timeLabel.frame = CGRectMake((WIDTH - TIME_WIDTH)/2, 3, TIME_WIDTH, TIME_HEIGHT);
    timeLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:headBgView];
    
    if (newEntity.is_recieved == MSG_IO_FLG_RECEIVE){
        
        //        CGRect headFrame = CGRectMake(3, 2.5, 35, 35);
        //        if (newEntity.msg_type == MSG_TYPE_TEXT) {//update 2015.07.17
        //
        //            headFrame = CGRectMake(3, self.textView.bgView.frame.size.height-35-5, 35, 35);
        //
        //        }
        
        CGRect headFrame = CGRectMake(3, 2.5, 35, 35);
        
        userHeadImage.frame = headFrame;
        CGRect headBgFrame = CGRectMake(5, 23, 41, 41);
        headBgView.frame = headBgFrame;
        headBgView.image = [UIImage imageNamed:@"bg_chat_myphoto"];
        //timeLabel.frame = CGRectMake(47, 3, TIME_WIDTH, TIME_HEIGHT);
        //timeLabel.textAlignment = NSTextAlignmentLeft;
        [headBgView addSubview:userHeadImage];
    } else {
        
        CGRect headFrame = CGRectMake(3, 2.5, 35, 35);
        //        if (newEntity.msg_type == MSG_TYPE_TEXT) {//update 2015.07.17
        //            headFrame = CGRectMake(3, self.textView.bgView.frame.size.height-35-5, 35, 35);
        //
        //        }
        
        
        selfHeadImage.frame = headFrame;
        CGRect headBgFrame = CGRectMake([UIScreen mainScreen].bounds.size.width- 5 - 41.0,23, 41, 41);
        headBgView.frame = headBgFrame;
        headBgView.image = [UIImage imageNamed:@"bg_chat_myphoto"];
        //timeLabel.frame = CGRectMake(109, 3, TIME_WIDTH, TIME_HEIGHT);
        //timeLabel.textAlignment = NSTextAlignmentRight;
        [headBgView addSubview:selfHeadImage];
    }
    
    if (newEntity.is_recieved == MSG_IO_FLG_RECEIVE) {
        CGRect chatViewFrame = self.chatView.frame;
        if (MSG_RECEIVED_FAIL == entity.msg_state) {
            CGRect stateFrame = CGRectMake(chatViewFrame.origin.x + chatViewFrame.size.width + 10, chatViewFrame.origin.y + chatViewFrame.size.height / 2 - 5, 12, 13);
            imgReviceFail.frame = stateFrame;
            [self.contentView addSubview:imgReviceFail];
        }
    } else if (newEntity.is_recieved == MSG_IO_FLG_SEND) {
        
        CGRect chatViewFrame = self.chatView.frame;
        CGRect stateFrame = CGRectMake(chatViewFrame.origin.x - 47, chatViewFrame.origin.y + chatViewFrame.size.height / 2 - 27, 57, 57);
        CGRect progressFrame = CGRectMake(chatViewFrame.origin.x - 27, chatViewFrame.origin.y + chatViewFrame.size.height / 2 - 5, 10, 10);
        
        if (newEntity.msg_type == 2) {
            stateFrame = CGRectMake(chatViewFrame.origin.x - 47, chatViewFrame.origin.y + chatViewFrame.size.height / 2 - 20, 57, 57);
        }
        
        sendStateBtn.frame = stateFrame;
        sendStateBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        sendStateBtn.accessibilityFrame = CGRectMake(stateFrame.origin.x , chatViewFrame.origin.y - 15, stateFrame.size.width , chatViewFrame.size.height);
        sendProgress.frame = progressFrame;
        if (MSG_SEND_SUCCESS == newEntity.msg_state) {
            [sendStateBtn setImage:statImgRead forState:UIControlStateNormal];
            [self.contentView addSubview:sendStateBtn];
        } else if (MSG_SEND_FAIL == newEntity.msg_state) {
            [sendStateBtn setImage:statImgUnread forState:UIControlStateNormal];
            [self.contentView addSubview:sendStateBtn];
        } else if (MSG_SENDING == newEntity.msg_state) {
            if (CELL_TYPE_TEXT == self.msgType) {
                
                sendProgress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
                [sendProgress startAnimating];
                [self.contentView addSubview:sendProgress];
                
            } else if (CELL_TYPE_PIC == self.msgType) {
                
                progressFrame = CGRectMake(chatViewFrame.origin.x + chatViewFrame.size.width / 2 - 8, chatViewFrame.origin.y + chatViewFrame.size.height / 2 - 8, 10, 10);
                sendProgress.frame = progressFrame;
                sendProgress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
                [sendProgress startAnimating];
                [self.contentView addSubview:sendProgress];
                
            }else if (CELL_TYPE_AUDIO == self.msgType){
                
                sendProgress.frame = sendStateBtn.frame;
                sendStateBtn.hidden = YES;
                sendProgress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
                [sendProgress startAnimating];
                [self.contentView addSubview:sendProgress];
                
            }
        }
    }
}

- (void)updataTextView:(ChatDetailObject *)newEntity
{
    [self.contentView addSubview:textView];
    textView.fromName = fromName;//2015.07.03
    [(MsgTextView *)textView updateWithChatDetailObject:newEntity];
    self.chatView = textView;
}

- (void)updataPicView:(ChatDetailObject *)newEntity
{
    NSString *thumbImagePath = entity.msg_file;//
    NSLog(@"thumbImagePath:%@",thumbImagePath);
    [self.contentView addSubview:picView];
    [(MsgPicView *)picView updateWithChatDetailObject:newEntity];
    self.chatView = picView;
}

- (void)updataAudioView:(ChatDetailObject *)newEntity
{
    audioView.index = self.index;
    [self.contentView addSubview:audioView];
    [(MsgAudioView *)audioView updateWithChatDetailObject:newEntity];
    self.chatView = audioView;
}

//---add 2015.05.29-------------------------------------------
- (void)updataTextViewForGroup:(GroupChatDetailObject *)newEntity
{
    [self.contentView addSubview:textView];
    [(MsgTextView *)textView updateWithChatDetailObjectForGroup:newEntity];
    self.chatView = textView;
    selfHeadImage.hidden = NO;
    userHeadImage.hidden = NO;
}

- (void)updataPicViewForGroup:(GroupChatDetailObject *)newEntity
{
    
    [self.contentView addSubview:picView];
    [(MsgPicView *)picView updateWithChatDetailObjectForGroup:newEntity];
    self.chatView = picView;
    selfHeadImage.hidden = NO;
    userHeadImage.hidden = NO;
}

- (void)updataAudioViewForGroup:(GroupChatDetailObject *)newEntity
{
    audioView.index = self.index;
    [self.contentView addSubview:audioView];
    [(MsgAudioView *)audioView updateWithChatDetailObjectForGroup:newEntity];
    self.chatView = audioView;
    selfHeadImage.hidden = NO;
    userHeadImage.hidden = NO;
}

- (void)updataSystemViewForGroup:(GroupChatDetailObject *)newEntity
{
    [self.contentView addSubview:systemView];
    [(MsgSystemView *)systemView updateWithChatDetailObjectForGroup:newEntity];
    self.chatView = systemView;
    selfHeadImage.hidden = YES;
    userHeadImage.hidden = YES;
}
//----------------------------------------------------------------------------

//---add 2016.01.19-------------------------------------------
- (void)updataTextViewForMix:(MixChatDetailObject *)newEntity
{
    [self.contentView addSubview:textView];
    [(MsgTextView *)textView updateWithChatDetailObjectForMix:newEntity];
    self.chatView = textView;
    selfHeadImage.hidden = NO;
    userHeadImage.hidden = NO;
}

- (void)updataPicViewForMix:(MixChatDetailObject *)newEntity
{
    
    [self.contentView addSubview:picView];
    [(MsgPicView *)picView updateWithChatDetailObjectForMix:newEntity];
    self.chatView = picView;
    selfHeadImage.hidden = NO;
    userHeadImage.hidden = NO;
}

- (void)updataAudioViewForMix:(MixChatDetailObject *)newEntity
{
    audioView.index = self.index;
    [self.contentView addSubview:audioView];
    [(MsgAudioView *)audioView updateWithChatDetailObjectForMix:newEntity];
    self.chatView = audioView;
    selfHeadImage.hidden = NO;
    userHeadImage.hidden = NO;
}

- (void)updataSystemViewForMix:(MixChatDetailObject *)newEntity
{
    [self.contentView addSubview:systemView];
    [(MsgSystemView *)systemView updateWithChatDetailObjectForMix:newEntity];
    self.chatView = systemView;
    selfHeadImage.hidden = YES;
    userHeadImage.hidden = YES;
}
//----------------------------------------------------------------------------

/*//设置用户头像
- (void)setSelfHeadImage:(long long)user_id
{
    //设置用户头像
    [selfHeadImage setMember:user_id];
    [selfHeadImage setNeedsDisplay];
}*/

/*---update by kate 2014.11.14---------------------------------------------------------
 //设置别人的头像
- (void)setUserHeadImage:(long long)user_id
{
    //设置用户头像
    [userHeadImage setMember:user_id];
    [self circleImage:userHeadImage];
    [userHeadImage setNeedsDisplay];
}*/

- (void)setUserHeadImage:(NSString*)userHeadUrl
{

    [userHeadImage sd_setImageWithURL:[NSURL URLWithString:userHeadUrl] placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];
    [self circleImage:userHeadImage];
    [userHeadImage setNeedsDisplay];

}
//-------------------------------------------------------------------------------------------

// 意见反馈页管理员头像设置
-(void)setAdminHeadImage{
    
    userHeadImage.image = [UIImage imageNamed:@"newLogo.png"];
    [self circleImage:userHeadImage];

}

/*----update by kate 2014.11.14--------------------------------------------------------
 //设置用户头像
- (void)setSelfHeadImage:(NSString*)user_id
{
    //设置用户头像
    //[selfHeadImage setMember:user uid:user_id];
    
    Utilities *util = [[Utilities alloc]init];
    NSString* head_url = [util getAvatarFromUid:[NSString stringWithFormat:@"%@", user_id] andType:@"1"];
    [selfHeadImage sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    
    [self circleImage:selfHeadImage];
    
    [selfHeadImage setNeedsDisplay];
}*/

//设置用户头像
- (void)setSelfHeadImage:(NSString*)head_url
{
    //设置用户头像
    //[selfHeadImage setMember:user uid:user_id];
    
    //Utilities *util = [[Utilities alloc]init];
    //NSString* head_url = [util getAvatarFromUid:[NSString stringWithFormat:@"%@", user_id] andType:@"1"];
    [selfHeadImage sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];
    
    [self circleImage:selfHeadImage];
    [selfHeadImage setNeedsDisplay];
}
//----------------------------------------------------------------------------------------

//设置别人的头像
/*- (void)setUserHeadImage:(UserObject*)user uid:(long long)user_id
{
    //设置用户头像
    [userHeadImage setMember:user uid:user_id];
    [userHeadImage setNeedsDisplay];
}*/

// 点击聊天画面中用户的头像进入用户的详细信息画面
- (void)doTapAction
{
    BOOL isSelf;
    
    // update 2015.06.01
    if (self.entity!=nil) {
        if (entity.is_recieved == MSG_IO_FLG_RECEIVE) {
            isSelf = NO;
        } else {
            isSelf = YES;
        }
        
        if (isSelf) {
            //
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_TOUCH_SELF_HEAD_IMAGE object:nil];
        } else {
            //
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_TOUCH_USER_HEAD_IMAGE object:nil];
        }
    }else if(self.entityForGroup!=nil){
        
        //NSLog(@"ecieved:%ld",(long)entityForGroup.is_recieved);
        
        if (entityForGroup.is_recieved == MSG_IO_FLG_RECEIVE) {
            isSelf = NO;
        } else {
            isSelf = YES;
        }
        
        if (isSelf) {
            //
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_TOUCH_SELF_HEAD_IMAGE object:nil];
        } else {
            //
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_TOUCH_USER_HEAD_IMAGE_GROUP object:entityForGroup];
        }
        
    }else if(self.entityForMix!=nil){
        
        //NSLog(@"ecieved:%ld",(long)entityForGroup.is_recieved);
        
        if (entityForMix.is_recieved == MSG_IO_FLG_RECEIVE) {
            isSelf = NO;
        } else {
            isSelf = YES;
        }
        
        if (isSelf) {
            //
            
        } else {
            //
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_TOUCH_USER_HEAD_IMAGE_MIX object:entityForMix];
        }
        
    }

    
}

// 长按聊天画面中用户的头像at某人
- (void)doPressLongAction
{
    BOOL isSelf;
    
    if(self.entityForMix!=nil){
        
        //NSLog(@"ecieved:%ld",(long)entityForGroup.is_recieved);
        if (entityForMix.is_recieved == MSG_IO_FLG_RECEIVE) {
            isSelf = NO;
        } else {
            isSelf = YES;
        }
        
        if (isSelf) {
            
        } else {
            
            NSString *uid = [NSString stringWithFormat:@"%lld",entityForMix.user_id];
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:uid,@"uid",entityForMix.userName,@"name", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_PRESSLONG_USER_HEAD_IMAGE_MIX object:dic];
            
        }
        
    }
    
}

#pragma mark UIGestureRecognizerDelegate methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

#pragma mark UIHeadImageDelegate
- (void)touchImage
{
    if([fromName isEqualToString:@"feedback"]){
        
    }else{
       [self doTapAction];
    }
    
}

-(void)touchLongImage{
    
    [self doPressLongAction];
}


// 圆形头像
-(void)circleImage:(UIImageView*)imageV{
    
    imageV.layer.masksToBounds = YES;
    imageV.layer.cornerRadius = imageV.frame.size.height/2.0;
    
}

@end
