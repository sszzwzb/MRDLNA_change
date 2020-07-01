//
//  MsgDetailCell.h
//  ShenMaPassenger
//
//  Created by kakashi on 14-2-24.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatDetailObject.h"
#import "MsgTextView.h"
#import "MsgPicView.h"
#import "MsgAudioView.h"
#import "UIHeadImage.h"
#import "UserObject.h"
#import "GroupChatDetailObject.h"// add 2015.05.29
#import "MsgSystemView.h"// add 2015.05.29
#import "MixChatDetailObject.h"//add 2016.01.19

@protocol QXChatDetailCellProtocol;

@interface MsgDetailCell : UITableViewCell <HeadImageDelegate>
{
    ChatDetailObject *entity;
    GroupChatDetailObject *entityForGroup;// add 2015.05.29
    //id<QXChatDetailCellProtocol>customDelegate;//update 2015.07.25
	UILabel *timeLabel;
    //具体的显示内容view
	//UIView *chatView;//update 2015.07.25
    //用户头像，点击显示详细信息
    UIHeadImage *selfHeadImage;
    UIHeadImage *userHeadImage;
    UIImageView *headBgView;
    NSInteger msgType;
    UIButton *sendStateBtn;
    long long msgID;
    UIImage *statImgRead;
    UIImage *statImgUnread;
    UIImageView *imgReviceFail;
    UIActivityIndicatorView *sendProgress;
    UILabel *nameLabel;//群聊显示发送者名字的label
    
}
@property (nonatomic, retain) ChatDetailObject *entity;
@property (nonatomic, retain) GroupChatDetailObject *entityForGroup;// add 2015.05.29
@property (nonatomic, retain) MixChatDetailObject *entityForMix;// add 2016.01.19
@property (nonatomic, assign) id<QXChatDetailCellProtocol>customDelegate; 
@property (nonatomic, assign) UIView *chatView; 
@property (nonatomic, retain) MsgTextView *textView; 
@property (nonatomic, retain) MsgPicView *picView;
@property (nonatomic, retain) MsgAudioView *audioView;
@property (nonatomic, retain) MsgSystemView *systemView;// add 2015.05.29
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, assign) BOOL isNewEntity;
@property (nonatomic, assign) NSInteger msgType;
@property (nonatomic, retain) UIImageView*headBgView;
@property (nonatomic, retain) UIButton *sendStateBtn;
@property (nonatomic, assign) long long msgID;
@property (nonatomic, retain) UIActivityIndicatorView *sendProgress;
@property (nonatomic, retain) NSString *index;

@property (nonatomic, retain) NSString *fromName;
@property (nonatomic, retain) UILabel *nameLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)updataCell:(ChatDetailObject *)entity updateState:(BOOL)updateState;
- (void)updataCellForGroup:(GroupChatDetailObject *)newEntity updateState:(BOOL)updateState;//add 2015.05.29
- (void)updataCellForMix:(MixChatDetailObject *)newEntity updateState:(BOOL)updateState;//2016.01.19
- (void)updataTextView:(ChatDetailObject *)newEntity;
- (void)updataPicView:(ChatDetailObject *)newEntity;
- (void)doTapAction;
//- (void)setSelfHeadImage:(long long)user_id;
//- (void)setUserHeadImage:(long long)user_id;
- (void)setUserHeadImage:(NSString*)userHeadUrl;
- (void)setSelfHeadImage:(NSString*)user_id;
//- (void)setUserHeadImage:(UserObject*)user uid:(long long)user_id;
-(void)setAdminHeadImage;// 2014.11.03

- (void)updataTextViewForGroup:(GroupChatDetailObject *)newEntity;// add 2015.05.29
- (void)updataPicViewForGroup:(GroupChatDetailObject *)newEntity;// add 2015.05.29
- (void)updataAudioViewForGroup:(GroupChatDetailObject *)newEntity;// add 2015.05.29


@end

@protocol QXChatDetailCellProtocol<NSObject>
- (void)didHeadClick:(ChatDetailObject *)newEntity;
@end
