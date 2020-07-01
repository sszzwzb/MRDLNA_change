//
//  MsgPicView.m
//  ShenMaPassenger
//
//  Created by kakashi on 14-2-24.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import "MsgPicView.h"
#import <QuartzCore/QuartzCore.h>
#import "PublicConstant.h"
#import "Utilities.h"


@implementation MsgPicView

@synthesize bgView;
@synthesize showImgView;
@synthesize bgViewRcv, bgViewSend;
@synthesize entityForpic;
@synthesize bgImgRcv;
@synthesize bgImgSend;
@synthesize coverView;
@synthesize entityForGroup;
@synthesize entityForMix;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.bgImgRcv = [UIImage imageNamed:@"friend/bg_recive_nor"];
        //self.bgImgSend = [UIImage imageNamed:@"friend/bg_sent_nor"];
        
        //self.bgImgRcv = nil;
        //self.bgImgSend = nil;
        
        //添加图片背景
//        bgViewRcv = [[UIImage imageNamed:@"friend/bg_recive_nor.png"] retain];
//        bgViewSend = [[UIImage imageNamed:@"friend/bg_sent_nor.png"] retain];
        
        bgViewRcv = [[UIImage imageNamed:@"ReceiveBubble.png"] retain];//update 2015.07.16
        bgViewSend = [[UIImage imageNamed:@"SendBubble.png"] retain];
        
//        showImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 4.0, 90.0, 120.0)];
//        showImgView.backgroundColor = [UIColor clearColor];
//        showImgView.layer.cornerRadius = 7;     
//        showImgView.layer.shouldRasterize = YES;
//        showImgView.layer.masksToBounds = YES;
        //showImgView.image = [UIImage imageNamed:@"reciveDefaultImg.png"];
        
        showImgView = [[HJShapedImageView alloc] initWithFrame:CGRectMake(5.0, 4.0, 90.0, 120.0)];//update 2015.07.16
        
        bgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        bgView.backgroundColor = [UIColor clearColor];
        bgView.userInteractionEnabled = YES;
        
//        coverView = [[UIView alloc] initWithFrame:CGRectZero];
//        coverView.backgroundColor = [UIColor grayColor];
//        coverView.alpha = 0.6f;
//        coverView.layer.cornerRadius = 6;
//        coverView.layer.shouldRasterize = YES;
//        coverView.layer.masksToBounds = YES;
        
        coverView = [[HJShapedImageView alloc] initWithFrame:CGRectMake(5.0, 4.0, 90.0, 120.0)];//update 2015.07.17
        coverView.hidden = YES;
        [bgView addSubview:showImgView];
        [self addSubview:bgView];
    }
    return self;
}

- (void)dealloc 
{
    if(bgViewRcv){
        [bgViewRcv release];
        bgViewRcv = nil;    
    } 
    
    if(bgViewSend){
        [bgViewSend release];
        bgViewSend = nil;    
    } 
    
    if(showImgView){
        [showImgView release];
        showImgView = nil;    
    }

    if(bgView){
        [bgView release]; 
        bgView = nil;
    }
    
    self.bgImgRcv = nil;
    self.bgImgSend = nil;
    self.coverView = nil;
    
    [super dealloc];
}

- (void)getZoomPic
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_TOUCH_IMAGE
                                                        object:entityForpic];
}

// add 2015.06.01
-(void)getZoomPicForGroup{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_TOUCH_IMAGE_GROUP
                                                        object:entityForGroup];
}

-(void)getZoomPicForMix{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_TOUCH_IMAGE_MIX
                                                        object:entityForMix];

}

-(void)showMenu:(UIGestureRecognizer*)gestureRecognizer{
    
    if (self.entityForpic!=nil) {
        [self becomeFirstResponder];
        
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [menuController setMenuVisible:NO];
        
        UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(menu2Delete:)];
        UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(menu2Transpond:)];
        
        [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1,menuItem2,nil]];
        [menuController setTargetRect:gestureRecognizer.view.frame inView:self.superview];
        [menuController setMenuVisible:YES animated:YES];
        
        [menuItem1 release];
        [menuItem2 release];
    }else if (self.entityForGroup!=nil){
        
        [self becomeFirstResponder];
        
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [menuController setMenuVisible:NO];
        
        UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(menu2Delete:)];
        //UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(menu2Transpond:)];
        
        [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1,nil]];
        [menuController setTargetRect:gestureRecognizer.view.frame inView:self.superview];
        [menuController setMenuVisible:YES animated:YES];
        
        [menuItem1 release];
        //[menuItem2 release];
    }else if (self.entityForMix!=nil){
        
         [self becomeFirstResponder];
        if (self.entityForMix.groupid == 0) {//单聊
            
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            [menuController setMenuVisible:NO];
            
            UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(menu2Delete:)];
            UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(menu2Transpond:)];
            
            //[menuController setMenuItems:[NSArray arrayWithObjects:menuItem1,menuItem2,nil]];
             [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1,nil]];
            [menuController setTargetRect:gestureRecognizer.view.frame inView:self.superview];
            [menuController setMenuVisible:YES animated:YES];
            
            [menuItem1 release];
            [menuItem2 release];
            
        }else{//群聊
           
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            [menuController setMenuVisible:NO];
            
            UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(menu2Delete:)];
            //UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(menu2Transpond:)];
            
            [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1,nil]];
            [menuController setTargetRect:gestureRecognizer.view.frame inView:self.superview];
            [menuController setMenuVisible:YES animated:YES];
            
            [menuItem1 release];

            
        }
        
        
    }
    
   
}

// 删除
-(void)menu2Delete:(UIMenuController *)menuController{
    
    //发通知删除一条cell
    if (self.entityForpic!=nil) {
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_DELETE_MSG object:entityForpic];
    }else if (self.entityForGroup!=nil){
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_DELETE_MSG_GROUP object:entityForGroup];
    }else if (self.entityForMix!=nil){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_DELETE_MSG_MIX object:entityForMix];
    }
   
}

// 转发
-(void)menu2Transpond:(UIMenuController *)menuController{

    if (self.entityForMix!=nil) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_TANSPOND_MSG object:entityForMix];
        
    }else{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_TANSPOND_MSG object:entityForpic];
    }
    

}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(menu2Delete:) || action == @selector(menu2Transpond:)){
        return YES;
    }else{
        return NO;
    }
}

// 更新聊天画面
- (void)updateWithChatDetailObject:(ChatDetailObject *)entity
{
    self.entityForpic = entity;
    
    NSString *imagePath = @"";
    
    // 此路径保存缩略图
    NSString *thumbImageDir = [Utilities getChatPicThumbDir:entityForpic.user_id];// updaet by kate 2015.03.27
    NSString *thumbImagePath = [NSString stringWithFormat:@"%@/%lli_thumb%@", thumbImageDir, entityForpic.msg_id,FILE_JPG_EXTENSION];
    
    //大图路径
    NSString *originalImageDir = [Utilities getChatPicOriginalDir:entityForpic.user_id];
    NSString *originalImagePath = [NSString stringWithFormat:@"%@/%lli_original%@", originalImageDir, entityForpic.msg_id, FILE_JPG_EXTENSION];
    
    UIImage *pic = nil;

    if (entityForpic.is_recieved == MSG_IO_FLG_RECEIVE){
        
        imagePath = thumbImagePath;
       
    }else{
        
        NSData *fileData =[NSData dataWithContentsOfFile:originalImagePath];
        NSData *fileData2 = [NSData dataWithContentsOfFile:thumbImagePath];//兼容2.6老版本已经存在手机里的图片
        
        if (fileData) {
            imagePath = originalImagePath;
        }else if (fileData2){
            imagePath = thumbImagePath;
        }
      
        
        pic = [UIImage imageWithContentsOfFile:imagePath];
        
        if (!pic) {
            imagePath = thumbImagePath;
        }
        
    }
    
        pic = [UIImage imageWithContentsOfFile:imagePath];//update 2015.07.09
        if (!pic) {
            //pic = [UIImage imageNamed:@"reciveDefaultImg.png"];//update 2015.07.16
            if (entity.msg_state == MSG_RECEIVED_SUCCESS) {
                pic = [UIImage imageNamed:@"reciveDefaultImg.png"];//update 2015.07.16
            }else{
                pic = [UIImage imageNamed:@"reciveNoMsgImg.png"];
                
            }
        }
        
        //entityForpic.imgCellLabel = pic;
//    }

    CGSize imageSize = [self getPicSizeWithImage:pic];
    CGRect imageRect = CGRectMake(5, 4, imageSize.width, imageSize.height);
    
    if (entity.is_recieved == MSG_IO_FLG_RECEIVE){
        
        showImgView.receiveOrSend = 0;
        imageRect = CGRectMake(0, 4, imageSize.width, imageSize.height);
        
    }else{
        showImgView.receiveOrSend = 1;
    }
    
    if (entity.msg_state == MSG_RECEIVING) {
        
    }else{
        showImgView.frame = imageRect;
    }
    showImgView.image = pic;
//    bgView.frame = CGRectMake(0, 0, imageSize.width + 15, imageSize.height + 9);
    bgView.frame = CGRectMake(0, 0, imageSize.width+5, imageSize.height+9);//2015.07.16
    
    if (entityForpic.is_recieved == MSG_IO_FLG_RECEIVE) {
        
//        bgView.image = [bgImgRcv stretchableImageWithLeftCapWidth:10 topCapHeight:35];
//        self.frame = CGRectMake(LEFT_DISTANCE_CHAT_HEAD-10, 0, bgView.frame.size.width, bgView.frame.size.height);
//        imageRect = CGRectMake(10, 4, imageSize.width, imageSize.height);
//        showImgView.frame = imageRect;
        
        self.frame = CGRectMake(LEFT_DISTANCE_CHAT_HEAD, 0, bgView.frame.size.width, bgView.frame.size.height);
        
    } else if (entityForpic.is_recieved == MSG_IO_FLG_SEND) {
        
//        bgView.image = [bgImgSend stretchableImageWithLeftCapWidth:6 topCapHeight:35];
//        self.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - bgView.frame.size.width - RIGHT_DISTANCE_CHAT_HEAD+10, 0, bgView.frame.size.width, bgView.frame.size.height);
        
        self.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - bgView.frame.size.width - RIGHT_DISTANCE_CHAT_HEAD, 0, bgView.frame.size.width, bgView.frame.size.height);
        
        //if (entityForpic.msg_state == MSG_SENDING || entityForpic.msg_state == MSG_SEND_FAIL) {
        if (entityForpic.msg_state == MSG_SENDING){
            
            coverView.receiveOrSend = 1;
            if (imageRect.size.width > 118.0) {
                coverView.frame = CGRectMake(imageRect.origin.x, imageRect.origin.y,imageRect.size.width+3 , imageRect.size.height+3);
            }else{
                coverView.frame = showImgView.frame;
            }
            
            coverView.image = [UIImage imageNamed:@"BubbleMask.png"];//update 2015.07.17
            coverView.hidden = NO;
            [bgView addSubview:coverView];
        } else {
            coverView.hidden = YES;
        }
    }
    
    //添加点击图片手势
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getZoomPic)];
    [bgView addGestureRecognizer:singleTouch];
    [singleTouch release];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu:)];
    [longPressRecognizer setMinimumPressDuration:1.0];
    [self addGestureRecognizer:longPressRecognizer];
}

//---add 2015.06.01----------------------------------------------------------------
- (void)updateWithChatDetailObjectForGroup:(GroupChatDetailObject *)entity{
    
    self.entityForGroup = entity;
    
    NSString *imagePath = @"";
    
    // 此路径保存缩略图
    NSString *thumbImageDir = [Utilities getChatPicThumbDir:entity.user_id];
    NSString *thumbImagePath = [NSString stringWithFormat:@"%@/%lli_thumb%@", thumbImageDir, entity.msg_id,FILE_JPG_EXTENSION];
    
    if (entity.is_recieved == MSG_IO_FLG_RECEIVE) {
        
        imagePath = thumbImagePath;
        
    }else{
        
        //大图路径
        NSString *originalImageDir = [Utilities getChatPicOriginalDir:entity.user_id];
        NSString *originalImagePath = [NSString stringWithFormat:@"%@/%lli_original%@", originalImageDir, entity.msg_id, FILE_JPG_EXTENSION];
        
        NSData *fileData =[NSData dataWithContentsOfFile:originalImagePath];
        NSData *fileData2 = [NSData dataWithContentsOfFile:thumbImagePath];//兼容2.6老版本已经存在手机里的图片
        
        if (fileData) {
            imagePath = originalImagePath;
        }else if(fileData2){
            imagePath = thumbImagePath;
        }
    }
   
    UIImage *pic = [UIImage imageWithContentsOfFile:imagePath];
    if (!pic) {
        
         NSLog(@"imagePath:%@",imagePath);
        
        if (entity.msg_state == MSG_RECEIVED_SUCCESS) {
            pic = [UIImage imageNamed:@"reciveDefaultImg.png"];//update 2015.07.16
        }else{
            
           
            pic = [UIImage imageNamed:@"reciveNoMsgImg.png"];

        }
        
  }
    
    CGSize imageSize = [self getPicSizeWithImage:pic];
    CGRect imageRect = CGRectMake(5, 4, imageSize.width, imageSize.height);
    
    if (entity.is_recieved == MSG_IO_FLG_RECEIVE){
        
        showImgView.receiveOrSend = 0;
        imageRect = CGRectMake(0, 4, imageSize.width, imageSize.height);

    }else{
        showImgView.receiveOrSend = 1;
    }
    
    if (entity.msg_state == MSG_RECEIVING) {
     
    }else{
        showImgView.frame = imageRect;
    }
    showImgView.image = pic;
    
    //bgView.frame = CGRectMake(0, 0, imageSize.width + 15, imageSize.height + 9);
    bgView.frame = CGRectMake(0, 0, imageSize.width+5, imageSize.height+9);//2015.07.16

    if (entity.is_recieved == MSG_IO_FLG_RECEIVE) {
        
        //bgView.image = [bgImgRcv stretchableImageWithLeftCapWidth:10 topCapHeight:35];
        
        if ([entity.userName length] > 0) {//update 2015.07.20
        
           bgView.frame = CGRectMake(0, 15.0, imageSize.width+5, imageSize.height+9);
            
        }
        
        self.frame = CGRectMake(LEFT_DISTANCE_CHAT_HEAD, 0, bgView.frame.size.width, bgView.frame.size.height);

        
    } else if (entity.is_recieved == MSG_IO_FLG_SEND) {
        
       //bgView.image = [bgImgSend stretchableImageWithLeftCapWidth:6 topCapHeight:35];
        
        self.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - bgView.frame.size.width - RIGHT_DISTANCE_CHAT_HEAD, 0, bgView.frame.size.width, bgView.frame.size.height);
        
//        if (entity.msg_state == MSG_SENDING || entity.msg_state == MSG_SEND_FAIL) {
          if (entity.msg_state == MSG_SENDING) {//update 2015.07.17

            coverView.receiveOrSend = 1;
            
            if (imageRect.size.width > 118.0) {
                coverView.frame = CGRectMake(imageRect.origin.x, imageRect.origin.y,imageRect.size.width+3 , imageRect.size.height+3);
            }else{
                 coverView.frame = showImgView.frame;
            }
            
            coverView.image = [UIImage imageNamed:@"BubbleMask.png"];//update 2015.07.17
            coverView.hidden = NO;
            [bgView addSubview:coverView];
        } else {
            coverView.hidden = YES;
        }
    }
    
    //添加点击图片手势
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getZoomPicForGroup)];
    [bgView addGestureRecognizer:singleTouch];
    [singleTouch release];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu:)];
    [longPressRecognizer setMinimumPressDuration:1.0];
    [self addGestureRecognizer:longPressRecognizer];
    
}
//---------------------------------------------------------------------------------

// 2016.01.19-----------------------------------------------------------------------
- (void)updateWithChatDetailObjectForMix:(MixChatDetailObject *)entity{
    
    self.entityForMix = entity;
    
    long long uid = [[Utilities getUniqueUidWithoutQuit] longLongValue];
    
    long long key = entity.user_id;
//    if (entity.user_id == 0) {
//        key = uid;
//    }
    
    NSString *imagePath = @"";
    
    // 此路径保存缩略图
    NSString *thumbImageDir = [Utilities getChatPicThumbDir:key];
    NSString *thumbImagePath = [NSString stringWithFormat:@"%@/%lli_thumb%@", thumbImageDir, entity.msg_id,FILE_JPG_EXTENSION];
    
    if (entity.is_recieved == MSG_IO_FLG_RECEIVE) {
        
        imagePath = thumbImagePath;
        
    }else{
        
        //大图路径
        NSString *originalImageDir = [Utilities getChatPicOriginalDir:key];
        NSString *originalImagePath = [NSString stringWithFormat:@"%@/%lli_original%@", originalImageDir, entity.msg_id, FILE_JPG_EXTENSION];
        
        NSData *fileData =[NSData dataWithContentsOfFile:originalImagePath];
        NSData *fileData2 = [NSData dataWithContentsOfFile:thumbImagePath];//兼容2.6老版本已经存在手机里的图片
        
        if (fileData) {
            imagePath = originalImagePath;
        }else if(fileData2){
            imagePath = thumbImagePath;
        }
    }
    
    UIImage *pic = [UIImage imageWithContentsOfFile:imagePath];
    if (!pic) {
        
        NSLog(@"imagePath:%@",imagePath);
        
        if (entity.msg_state == MSG_RECEIVED_SUCCESS) {
            pic = [UIImage imageNamed:@"reciveDefaultImg.png"];//update 2015.07.16
        }else{
            pic = [UIImage imageNamed:@"reciveNoMsgImg.png"];
            
        }
        
    }
    
    CGSize imageSize = [self getPicSizeWithImage:pic];
    CGRect imageRect = CGRectMake(5, 4, imageSize.width, imageSize.height);
    
    if (entity.is_recieved == MSG_IO_FLG_RECEIVE){
        
        showImgView.receiveOrSend = 0;
        imageRect = CGRectMake(0, 4, imageSize.width, imageSize.height);
        
    }else{
        showImgView.receiveOrSend = 1;
    }
    
    if (entity.msg_state == MSG_RECEIVING) {
        
    }else{
        showImgView.frame = imageRect;
    }
    showImgView.image = pic;
    
    //bgView.frame = CGRectMake(0, 0, imageSize.width + 15, imageSize.height + 9);
    bgView.frame = CGRectMake(0, 0, imageSize.width+5, imageSize.height+9);//2015.07.16
    
    if (entity.is_recieved == MSG_IO_FLG_RECEIVE) {
        
        //bgView.image = [bgImgRcv stretchableImageWithLeftCapWidth:10 topCapHeight:35];
        
        if ([entity.userName length] > 0) {//update 2015.07.20
            
            bgView.frame = CGRectMake(0, 15.0, imageSize.width+5, imageSize.height+9);
            
        }
        
        self.frame = CGRectMake(LEFT_DISTANCE_CHAT_HEAD, 0, bgView.frame.size.width, bgView.frame.size.height);
        
        
    } else if (entity.is_recieved == MSG_IO_FLG_SEND) {
        
        //bgView.image = [bgImgSend stretchableImageWithLeftCapWidth:6 topCapHeight:35];
        
        self.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - bgView.frame.size.width - RIGHT_DISTANCE_CHAT_HEAD, 0, bgView.frame.size.width, bgView.frame.size.height);
        
        //        if (entity.msg_state == MSG_SENDING || entity.msg_state == MSG_SEND_FAIL) {
        if (entity.msg_state == MSG_SENDING) {//update 2015.07.17
            
            coverView.receiveOrSend = 1;
            
            if (imageRect.size.width > 118.0) {
                coverView.frame = CGRectMake(imageRect.origin.x, imageRect.origin.y,imageRect.size.width+3 , imageRect.size.height+3);
            }else{
                coverView.frame = showImgView.frame;
            }
            
            coverView.image = [UIImage imageNamed:@"BubbleMask.png"];//update 2015.07.17
            coverView.hidden = NO;
            [bgView addSubview:coverView];
        } else {
            coverView.hidden = YES;
        }
    }
    
    //添加点击图片手势
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getZoomPicForMix)];
    [bgView addGestureRecognizer:singleTouch];
    [singleTouch release];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu:)];
    [longPressRecognizer setMinimumPressDuration:1.0];
    [self addGestureRecognizer:longPressRecognizer];
}
//----------------------------------------------------------------------------------

// 取得图片的大小
- (CGSize)getPicSizeWithImage:(UIImage *)image
{
    CGFloat destW = 120;
	CGFloat destH = 120;
	CGFloat sourceW = image.size.width;
	CGFloat sourceH = image.size.height;
    
	CGSize imageSize;
	if ((sourceW <= destW)&&(sourceH <= destH)) { //图片小于显示区域，不进行缩小，直接显示
		destW = sourceW;
		destH = sourceH;
		imageSize = CGSizeMake(destW, destH);
	} else {
		CGFloat ratio1 = destW/sourceW;
		CGFloat ratio2 = destH/sourceH;
		CGFloat ratio;
		if (ratio1 <= ratio2) {
			ratio = ratio1;
			imageSize = CGSizeMake(destW, sourceH * ratio);
		} else {
			ratio = ratio2;
			imageSize = CGSizeMake(sourceW * ratio, destH);
		}
	}
    
    return imageSize;
}

@end
