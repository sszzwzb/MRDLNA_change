//
//  DiscussDetailCell.h
//  MicroSchool
//
//  Created by jojo on 13-12-23.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIHTTPRequest.h"
#import "Utilities.h"

// audio
#import "GlobalSingletonRecordAudio.h"

#import "UIButton+WebCache.h"
//#import "UIImageView+WebCache.h"
#import "MarkupParser.h"// add by kate
#import "OHAttributedLabel.h"

#import "TSTouchLabel.h"
#import <MLLabel/MLLinkLabel.h> // 2015.09.18
#import <MLLabel/NSString+MLExpression.h>// 2015.09.18
#import <MLLabel/NSAttributedString+MLExpression.h>// 2015.09.18

@interface DiscussDetailCell : UITableViewCell<GlobalSingletonRecordAudioDelegate>
{
    UILabel *label_subject;
    
    UILabel *label_replynum;
    
    UIImageView *image_time;
    
    UIImageView *image_reply;
    
    UIWebView *webview;
    
    NSString *rowNum;
    
    NSData *curAudio;
    NSData * isRecording;
    
}

@property (nonatomic, retain) UILabel *label_message;
@property (nonatomic, retain) UILabel *label_username;
@property (nonatomic, retain) UILabel *label_dateline;

@property (copy, nonatomic) NSString *pid;
@property (copy, nonatomic) NSString *uid;

@property (copy, nonatomic) NSString *ext;
@property (copy, nonatomic) NSString *pic;
@property (copy, nonatomic) NSString *cellNum;

//@property (nonatomic, retain) UIImageView *imgView_thumb;
@property (nonatomic, retain) UIImageView *imgView_line;
@property (nonatomic, retain) UIImageView *imgView_leftLine;

@property (nonatomic, retain) UIImageView *imgView_leftlittilPoint;
@property (nonatomic, retain) UIImageView *imgView_leftlittilMiddlePoint;

@property (nonatomic, retain) UILabel *label_leftNum;

// audio
@property (nonatomic, retain) UIButton *playRecordButton;
@property (nonatomic, retain) UIImageView *animationImageView;
@property (nonatomic, retain) UIImageView *playImageView;

// image
@property (nonatomic, retain) UIButton *imageButton;

@property (nonatomic, retain) UIButton *btn_thumb;

@property (nonatomic, retain) UIImageView *imgView_reply;


//@property (nonatomic, retain) UIView *view;
@property(nonatomic,retain)MarkupParser *textParser;// add by kate
//@property (nonatomic, retain) OHAttributedLabel *label;
@property (nonatomic, strong) MLLinkLabel *label;//2015.09.18
@property (nonatomic, retain) UILabel *citeLabel;// 引用label add by kate 2015.04.01

// 删除label
@property (nonatomic, retain) TSTouchLabel *tsLabel_delete;
// 复制button
@property (nonatomic, retain) TSTouchLabel *button_copy;//2015.09.14
@property (nonatomic, retain) NSString *pasteboardStr;//2015.09.15

-(void)setMLLabelText:(NSString*)attributedStr;// 2015.09.18
+ (CGSize)heightForEmojiText:(NSString*)emojiText;// 2015.09.18
@end
