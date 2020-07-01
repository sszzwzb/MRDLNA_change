//
//  MsgTextView.m
//  ShenMaPassenger
//
//  Created by kakashi on 14-2-24.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import "MsgTextView.h"
#import "PublicConstant.h"
#import <Foundation/Foundation.h>
#import "Utilities.h"
#import "OHAttributedLabel.h"
#import "MarkupParser.h"
#import "SCGIFImageView.h"
#import "RegexKitLite.h"
#import "NSAttributedString+Attributes.h"

#define SHOW_SIMPLE_TIPS(m) [[[UIAlertView alloc] initWithTitle:@"" message:(m) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];

@implementation MsgTextView

@synthesize bgView;
@synthesize bgViewRcv, bgViewSend;
@synthesize currentLabel;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
//        bgViewRcv = [[UIImage imageNamed:@"friend/bg_recive_nor"] retain];
//        bgViewSend = [[UIImage imageNamed:@"friend/bg_sent_nor"] retain];
        bgViewRcv = [UIImage imageNamed:@"ReceiveBubble.png"];
        bgViewSend = [UIImage imageNamed:@"SendBubble.png"];
        
        //-------2015.08.07--------------------------------------------------------------
        /*textParser = [[MarkupParser alloc] init];
        currentLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        currentLabel.backgroundColor = [UIColor clearColor];*/
       //--------------------------------------------------------------------------------
        
        bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, currentLabel.frame.size.width + 25, currentLabel.frame.size.height + 20)];
        bgView.backgroundColor = [UIColor clearColor];
        bgView.userInteractionEnabled = YES;
        
        [bgView addSubview:self.label];//add 2015.08.03
        //[bgView addSubview:self.emojiLabel];//add 2015.08.01
        //[bgView addSubview:currentLabel];
        [self addSubview:bgView];
        
        //--------update by kate--------------------------------------------------------------------------
        /*label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont fontWithName:@"Helvetica" size:16];
        label.backgroundColor = [UIColor clearColor];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        [bgView addSubview:label];*/
        
        NSString *emojiFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/faceImages/expression/emotionImage.plist"];
        _emojiDic = [[NSDictionary alloc] initWithContentsOfFile:emojiFilePath];
//        
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu:)];
        longPressRecognizer.delegate = self;
        [longPressRecognizer setMinimumPressDuration:1.0];
        [self addGestureRecognizer:longPressRecognizer];
        
        UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchMe:)];
        singleTouch.delegate = self;
        [self addGestureRecognizer:singleTouch];
        
        //-----------------------------------------------------------------------------------------------
    }
    return self;
}


/*//----2015.08.03 MLEmojiLabel-----------------------------------------------------------------------------
#pragma mark - getter
- (MLEmojiLabel *)emojiLabel
{
    if (!_emojiLabel) {
        
        _emojiLabel = [MLEmojiLabel new];
        _emojiLabel.numberOfLines = 0;
        _emojiLabel.font = [UIFont systemFontOfSize:14.0f];
        _emojiLabel.delegate = self;
        _emojiLabel.backgroundColor = [UIColor clearColor];
        _emojiLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _emojiLabel.textColor = [UIColor blackColor];
        _emojiLabel.textInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        
        _emojiLabel.isNeedAtAndPoundSign = YES;
        _emojiLabel.disableEmoji = NO;
        
        _emojiLabel.lineSpacing = 3.0f;
        
        _emojiLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
        
        _emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        _emojiLabel.customEmojiPlistName = @"/faceImages/expression/emotionImage.plist";
        
    }
    return _emojiLabel;
}


#pragma mark - setter
- (void)setEmojiText:(NSString *)emojiText
{
    [self.emojiLabel setText:emojiText];
}


#pragma mark - height
+ (CGSize)heightForEmojiText:(NSString*)emojiText
{
    static MLEmojiLabel *protypeLabel = nil;
    if (!protypeLabel) {
        
        protypeLabel = [MLEmojiLabel new];
        protypeLabel.numberOfLines = 0;
        protypeLabel.font = [UIFont systemFontOfSize:15.0f];//2015.08.01
        protypeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        protypeLabel.textInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        protypeLabel.isNeedAtAndPoundSign = YES;
        protypeLabel.disableEmoji = NO;
        protypeLabel.lineSpacing = 3.0f;
        
        protypeLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
        
        protypeLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        protypeLabel.customEmojiPlistName = @"/faceImages/expression/emotionImage.plist";
    }
    
    [protypeLabel setText:emojiText];
    
//    float height = [protypeLabel preferredSizeWithMaxWidth:200.0].height+5.0f*2;
//    
//    NSLog(@"height:%f",height);
    
    CGSize size = [protypeLabel preferredSizeWithMaxWidth:200.0];
    
    return size;
}

//#pragma mark - layout
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    self.emojiLabel.frame = CGRectMake(10.0f, 5.0f, 200.0, self.superview.frame.size.height-5.0f*2);
//}

#pragma mark - delegate
- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
        case MLEmojiLabelLinkTypeURL:
            NSLog(@"点击了链接%@",link);
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            NSLog(@"点击了电话%@",link);
            break;
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
            NSLog(@"点击了用户%@",link);
            break;
        case MLEmojiLabelLinkTypePoundSign:
            NSLog(@"点击了话题%@",link);
            break;
        default:
            NSLog(@"点击了不知道啥%@",link);
            break;
    }
    
}


//----------------------------------------------------------------------------------------------*/

//---add 2015.08.03 MLLabel----------------------------------------------------------------------------
#pragma mark - getter
- (MLLinkLabel *)label
{
    if (!_label) {
        
        _label = [MLLinkLabel new];
        //_label.textColor = [UIColor blackColor];
        _label.backgroundColor = [UIColor clearColor];
        
        _label.font = [UIFont systemFontOfSize:16.0f];
        
        _label.numberOfLines = 0;
        _label.textInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        _label.dataDetectorTypes = MLDataDetectorTypeURL;// 链接 电话 邮箱等显示 可自定义
        
        _label.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor]};
        _label.activeLinkTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor],NSBackgroundColorAttributeName:kDefaultActiveLinkBackgroundColorForMLLinkLabel};
        
//        [_label setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
//            NSString *tips = [NSString stringWithFormat:@"Click\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",link.linkType,linkText,link.linkValue];
//            SHOW_SIMPLE_TIPS(tips);
//
//            
//        }];
//        
//
//        [_label setDidLongPressLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
//            NSString *tips = [NSString stringWithFormat:@"LongPress\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",link.linkType,linkText,link.linkValue];
//            SHOW_SIMPLE_TIPS(tips);
//            
//        }];
        
    }
    return _label;
}

#pragma mark - height
static MLLinkLabel * kProtypeLabel() {
    
    static MLLinkLabel *_protypeLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _protypeLabel = [MLLinkLabel new];
        _protypeLabel.font = [UIFont systemFontOfSize:16.0f];
        
        _protypeLabel.numberOfLines = 0;
        _protypeLabel.textInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    });
    return _protypeLabel;
}

+ (CGSize)heightForEmojiText:(NSString*)emojiText
{
    MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"/faceImages/expression/emotionImage.plist" bundleName:@"Expression"];//plistName bundleName 需要修改
    
    NSAttributedString *expressionText = [emojiText expressionAttributedStringWithExpression:exp];
    
    MLLinkLabel *label = kProtypeLabel();
    label.attributedText = expressionText;
    
    CGSize size = [label preferredSizeWithMaxWidth:250.0];//update 2015.08.12
    
    return size;
}

//#pragma mark - gesture delegate
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//// //       return ![self.label linkAtPoint:[touch locationInView:self.label]];
//    //如果此手势在外层的外层view的话，不方便直接定位到label的话，可以使用这种方式。
//    CGPoint location = [touch locationInView:gestureRecognizer.view];
//    UIView *view = [gestureRecognizer.view hitTest:location withEvent:nil];
//    if ([view isKindOfClass:[MLLinkLabel class]]) {
//            if ([((MLLinkLabel*)view) linkAtPoint:[touch locationInView:view]]) {
//                return NO;
//            }
//    }
//    
//    return YES;
//}
//----------------------------------------------------------------------------------------------------------

- (void)dealloc 
{
    if (bgViewRcv) {
        //[bgViewRcv release];
        bgViewRcv = nil;
    }
    
    if (bgViewSend) {
        //[bgViewSend release];
        bgViewSend = nil;
    }
    
    /*if (label) {
        [label release];
        label = nil;
    }*/
    
    if (currentLabel) {
        //[currentLabel release];
        currentLabel = nil;
    }
    
    if (bgView) {
        //[bgView release];
        bgView = nil;
    }
    
    //[super dealloc];
}

/* 注释 2015.08.07
- (void)updateWithChatDetailObject:(ChatDetailObject *)entity
{
    // 普通的txt
    NSString *inputText = entity.msg_content;
    NSLog(@"inputText:%@",inputText);

    [textParser.images removeAllObjects];

    NSMutableArray *httpArr = [self addHttpArr:inputText];
//    NSMutableArray *phoneNumArr = [self addPhoneNumArr:inputText];
    
    NSString *displayStr = [self transformString:inputText];

    NSMutableAttributedString *attString = [textParser attrStringFromMarkup:displayStr];
    
    NSLog(@"attString:%@",attString);
    
    attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
    [attString setFont:[UIFont systemFontOfSize:16]];
    
    [currentLabel resetAttributedText];
    
    //NSLog(@"images:%@",textParser.images);
    NSLog(@"attString:%@",attString);
    [currentLabel setAttString:attString withImages:textParser.images];
    
     NSString *string = attString.string;
    
//    if ([phoneNumArr count]) {
//        for (NSString *phoneNum in phoneNumArr) {
//            [currentLabel addCustomLink:[NSURL URLWithString:phoneNum] inRange:[string rangeOfString:phoneNum]];
//        }
//    }
    
    if ([httpArr count]) {
        for (NSString *httpStr in httpArr) {
            [currentLabel addCustomLink:[NSURL URLWithString:httpStr] inRange:[string rangeOfString:httpStr]];
        }
    }
    
    CGRect labelRect = CGRectMake(0, 0, 200, 200);
    labelRect.size.width = [currentLabel sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].width;
    labelRect.size.height = [currentLabel sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].height;
    currentLabel.frame = labelRect;
    currentLabel.userInteractionEnabled = YES;
    currentLabel.onlyCatchTouchesOnLinks = NO;
    currentLabel.underlineLinks = YES;//链接是否带下划线
    self.entity = entity;
 

      NSLog(@"currentLabel.frame.size.height:%f",currentLabel.frame.size.height);
    
     // update 2015.07.17
    //[bgView setFrame:CGRectMake(0, 0, currentLabel.frame.size.width + 35, currentLabel.frame.size.height + 17)];
    [bgView setFrame:CGRectMake(0, 2.5, currentLabel.frame.size.width + 20, currentLabel.frame.size.height + 17)];
    
    if (entity.is_recieved == MSG_IO_FLG_RECEIVE) {
        // 接收的消息
        //bgView.image = [bgViewRcv stretchableImageWithLeftCapWidth:10 topCapHeight:35];
        bgView.image = [bgViewRcv resizableImageWithCapInsets:UIEdgeInsetsMake(bgViewRcv.size.height/2.0,bgViewRcv.size.width/2.0, bgViewRcv.size.height/2.0, bgViewRcv.size.width/2.0)];
        //currentLabel.frame = CGRectMake(28, 8, currentLabel.frame.size.width, currentLabel.frame.size.height);
        currentLabel.frame = CGRectMake(10, 8, currentLabel.frame.size.width, currentLabel.frame.size.height);
        //self.frame = CGRectMake(LEFT_DISTANCE_CHAT_HEAD-10, 0, bgView.frame.size.width, bgView.frame.size.height);
        self.frame = CGRectMake(LEFT_DISTANCE_CHAT_HEAD, 0, bgView.frame.size.width, bgView.frame.size.height);

    } else if (entity.is_recieved == MSG_IO_FLG_SEND) {
        // 发送的消息
        //bgView.image = [bgViewSend stretchableImageWithLeftCapWidth:6 topCapHeight:35];
         bgView.image = [bgViewSend resizableImageWithCapInsets:UIEdgeInsetsMake(bgViewSend.size.height/2.0,bgViewSend.size.width/2.0, bgViewSend.size.height/2.0, bgViewSend.size.width/2.0)];
        // update 2015.07.17
//        currentLabel.frame = CGRectMake(13-7, 8, currentLabel.frame.size.width, currentLabel.frame.size.height);
//        self.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - bgView.frame.size.width - RIGHT_DISTANCE_CHAT_HEAD+10, 0, bgView.frame.size.width, bgView.frame.size.height);
        currentLabel.frame = CGRectMake(10, 8, currentLabel.frame.size.width, currentLabel.frame.size.height);
        self.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - bgView.frame.size.width - RIGHT_DISTANCE_CHAT_HEAD, 0, bgView.frame.size.width, bgView.frame.size.height);
    }
    
}*/

//---add 2015.06.01-----------------------------------------------
/*- (void)updateWithChatDetailObjectForGroup:(GroupChatDetailObject *)entity{
   
    // 普通的txt
    NSString *inputText = entity.msg_content;
    // ----------------------------------------------------------------------
    [textParser.images removeAllObjects];
    
    NSMutableArray *httpArr = [self addHttpArr:inputText];
    //    NSMutableArray *phoneNumArr = [self addPhoneNumArr:inputText];
    
    NSString *displayStr = [self transformString:inputText];
    
    NSMutableAttributedString* attString = [textParser attrStringFromMarkup:displayStr];
    
    attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
    [attString setFont:[UIFont systemFontOfSize:16]];
    
    [currentLabel resetAttributedText];
    
    [currentLabel setAttString:attString withImages:textParser.images];
    
    NSString *string = attString.string;
    
    if ([httpArr count]) {
        for (NSString *httpStr in httpArr) {
            [currentLabel addCustomLink:[NSURL URLWithString:httpStr] inRange:[string rangeOfString:httpStr]];
        }
    }
    
    CGRect labelRect = CGRectMake(0, 0, 200, 200);
    labelRect.size.width = [currentLabel sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].width;
    labelRect.size.height = [currentLabel sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].height;
    currentLabel.frame = labelRect;
    currentLabel.userInteractionEnabled = YES;
    currentLabel.onlyCatchTouchesOnLinks = NO;
    currentLabel.underlineLinks = YES;//链接是否带下划线
    self.entityForGroup = entity;
 
    
//    [bgView setFrame:CGRectMake(0, 0, currentLabel.frame.size.width + 35, currentLabel.frame.size.height + 17)];
    [bgView setFrame:CGRectMake(0, 2.5, currentLabel.frame.size.width + 20, currentLabel.frame.size.height + 17)];
        
    if (entity.is_recieved == MSG_IO_FLG_RECEIVE) {
        // 接收的消息
        //bgView.image = [bgViewRcv stretchableImageWithLeftCapWidth:10 topCapHeight:35];
        bgView.image = [bgViewRcv resizableImageWithCapInsets:UIEdgeInsetsMake(bgViewRcv.size.height/2.0,bgViewRcv.size.width/2.0, bgViewRcv.size.height/2.0, bgViewRcv.size.width/2.0)];
//        currentLabel.frame = CGRectMake(28, 8, currentLabel.frame.size.width, currentLabel.frame.size.height);
        currentLabel.frame = CGRectMake(10, 8, currentLabel.frame.size.width, currentLabel.frame.size.height);
       
        if ([entity.userName length] > 0) {
             [bgView setFrame:CGRectMake(0, 2.5+15.0, currentLabel.frame.size.width + 20, currentLabel.frame.size.height + 17)];
        }
        
        self.frame = CGRectMake(LEFT_DISTANCE_CHAT_HEAD, 0, bgView.frame.size.width, bgView.frame.size.height);
        
        
    } else if (entity.is_recieved == MSG_IO_FLG_SEND) {
        // 发送的消息
       
        bgView.image = [bgViewSend resizableImageWithCapInsets:UIEdgeInsetsMake(bgViewSend.size.height/2.0,bgViewSend.size.width/2.0, bgViewSend.size.height/2.0, bgViewSend.size.width/2.0)];
        //currentLabel.frame = CGRectMake(13-7, 8, currentLabel.frame.size.width, currentLabel.frame.size.height);
        currentLabel.frame = CGRectMake(10, 8, currentLabel.frame.size.width, currentLabel.frame.size.height);
        self.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - bgView.frame.size.width - RIGHT_DISTANCE_CHAT_HEAD, 0, bgView.frame.size.width, bgView.frame.size.height);
    }

}*/

/*
// 2015.08.01 MLEmojiLabel
- (void)updateWithChatDetailObjectForGroup:(GroupChatDetailObject *)entity{
    
    // 普通的txt
   // NSString *inputText = entity.msg_content;
    self.entityForGroup = entity;
    [self.emojiLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self setEmojiText:entity.msg_content];
    
    float height = entity.size.height+5.0f*2;
    self.emojiLabel.frame = CGRectMake(0.0f, 0.0, entity.size.width, height);
    //self.emojiLabel.frame = CGRectMake(10.0f, 8.0f, 200.0, self.superview.frame.size.height-5.0f*2);
    
    NSLog(@"emojiLabelHeight:%f", self.superview.frame.size.height-5.0f*2);
    
    [bgView setFrame:CGRectMake(0, 2.5, _emojiLabel.frame.size.width, _emojiLabel.frame.size.height)];
    
    if (entity.is_recieved == MSG_IO_FLG_RECEIVE) {
        // 接收的消息
        //bgView.image = [bgViewRcv stretchableImageWithLeftCapWidth:10 topCapHeight:35];
        bgView.image = [bgViewRcv resizableImageWithCapInsets:UIEdgeInsetsMake(bgViewRcv.size.height/2.0,bgViewRcv.size.width/2.0, bgViewRcv.size.height/2.0, bgViewRcv.size.width/2.0)];
        
        if ([entity.userName length] > 0) {
            [bgView setFrame:CGRectMake(0, 2.5+15.0, _emojiLabel.frame.size.width, _emojiLabel.frame.size.height)];
        }
        
        self.frame = CGRectMake(LEFT_DISTANCE_CHAT_HEAD, 0, bgView.frame.size.width, bgView.frame.size.height);
        
    } else if (entity.is_recieved == MSG_IO_FLG_SEND) {
        // 发送的消息
        
        bgView.image = [bgViewSend resizableImageWithCapInsets:UIEdgeInsetsMake(bgViewSend.size.height/2.0,bgViewSend.size.width/2.0, bgViewSend.size.height/2.0, bgViewSend.size.width/2.0)];
        self.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - bgView.frame.size.width - RIGHT_DISTANCE_CHAT_HEAD, 0, bgView.frame.size.width, bgView.frame.size.height);
    }
    
}

//----------------------------------------------------------------*/

-(void)setMLLabelText:(NSString*)attributedStr{
    
    MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"/faceImages/expression/emotionImage.plist" bundleName:@"Expression"];//plistName bundleName 需要修改
    
    self.label.attributedText = [attributedStr expressionAttributedStringWithExpression:exp];

}

// MLLabel 2015.08.07
- (void)updateWithChatDetailObject:(ChatDetailObject *)entity
{
    // 普通的txt
    //NSString *inputText = entity.msg_content;
    self.entity = entity;
    [self setMLLabelText:entity.msg_content];
    
    float height = entity.size.height+5.0f*2;
    self.label.frame = CGRectMake(0.0f, 0.0, entity.size.width, height);

    [bgView setFrame:CGRectMake(0, 2.5, _label.frame.size.width, _label.frame.size.height)];
    
    if (entity.is_recieved == MSG_IO_FLG_RECEIVE) {
        
        // 接收的消息
        bgView.image = [bgViewRcv resizableImageWithCapInsets:UIEdgeInsetsMake(bgViewRcv.size.height/2.0,bgViewRcv.size.width/2.0, bgViewRcv.size.height/2.0, bgViewRcv.size.width/2.0)];
      
        self.frame = CGRectMake(LEFT_DISTANCE_CHAT_HEAD, 0, bgView.frame.size.width, bgView.frame.size.height);
        
    } else if (entity.is_recieved == MSG_IO_FLG_SEND) {
        
        // 发送的消息
        bgView.image = [bgViewSend resizableImageWithCapInsets:UIEdgeInsetsMake(bgViewSend.size.height/2.0,bgViewSend.size.width/2.0, bgViewSend.size.height/2.0, bgViewSend.size.width/2.0)];
        self.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - bgView.frame.size.width - RIGHT_DISTANCE_CHAT_HEAD, 0, bgView.frame.size.width, bgView.frame.size.height);
    }
    
}

/// MLLabel 2015.08.03
- (void)updateWithChatDetailObjectForGroup:(GroupChatDetailObject *)entity{
    
    // 普通的txt
    // NSString *inputText = entity.msg_content;
    self.entityForGroup = entity;
    [self setMLLabelText:entity.msg_content];
    
    float height = entity.size.height+5.0f*2;
    self.label.frame = CGRectMake(0.0f, 0.0, entity.size.width, height);
    //self.emojiLabel.frame = CGRectMake(10.0f, 8.0f, 200.0, self.superview.frame.size.height-5.0f*2);

    
    [bgView setFrame:CGRectMake(0, 2.5, _label.frame.size.width, _label.frame.size.height)];
    
    if (entity.is_recieved == MSG_IO_FLG_RECEIVE) {
        // 接收的消息
        //bgView.image = [bgViewRcv stretchableImageWithLeftCapWidth:10 topCapHeight:35];
        bgView.image = [bgViewRcv resizableImageWithCapInsets:UIEdgeInsetsMake(bgViewRcv.size.height/2.0,bgViewRcv.size.width/2.0, bgViewRcv.size.height/2.0, bgViewRcv.size.width/2.0)];
        
        if ([entity.userName length] > 0) {
            [bgView setFrame:CGRectMake(0, 2.5+15.0, _label.frame.size.width, _label.frame.size.height)];
        }
        
        self.frame = CGRectMake(LEFT_DISTANCE_CHAT_HEAD, 0, bgView.frame.size.width, bgView.frame.size.height);
        
    } else if (entity.is_recieved == MSG_IO_FLG_SEND) {
        // 发送的消息
        
        bgView.image = [bgViewSend resizableImageWithCapInsets:UIEdgeInsetsMake(bgViewSend.size.height/2.0,bgViewSend.size.width/2.0, bgViewSend.size.height/2.0, bgViewSend.size.width/2.0)];
        self.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - bgView.frame.size.width - RIGHT_DISTANCE_CHAT_HEAD, 0, bgView.frame.size.width, bgView.frame.size.height);
    }
    
}

//2016.01.19
- (void)updateWithChatDetailObjectForMix:(MixChatDetailObject *)entity{
    
    // 普通的txt
    // NSString *inputText = entity.msg_content;
    self.entityForMix = entity;
    if ([entity.msg_content hasPrefix:@"http:////"]||[entity.msg_content hasPrefix:@"https:////"]) {
        entity.msg_content = [self sqliteEscape:entity.msg_content];
    }
    [self setMLLabelText:entity.msg_content];
    
    //float height = entity.size.height+5.0f*2;
    float height = entity.size.height+3.0f;//文字部分高度修改
    self.label.frame = CGRectMake(0.0f, 0.0, entity.size.width, height);
    //self.emojiLabel.frame = CGRectMake(10.0f, 8.0f, 200.0, self.superview.frame.size.height-5.0f*2);
    
    
    [bgView setFrame:CGRectMake(0, 2.5, _label.frame.size.width, _label.frame.size.height)];
    
    if (entity.is_recieved == MSG_IO_FLG_RECEIVE) {
        // 接收的消息
        _label.textColor = [UIColor blackColor];
        
        //bgView.image = [bgViewRcv stretchableImageWithLeftCapWidth:10 topCapHeight:35];
        bgView.image = [bgViewRcv resizableImageWithCapInsets:UIEdgeInsetsMake(bgViewRcv.size.height/2.0,bgViewRcv.size.width/2.0, bgViewRcv.size.height/2.0, bgViewRcv.size.width/2.0)];
        if (entity.groupid != 0) {//群聊
            if ([entity.userName length] > 0) {
                [bgView setFrame:CGRectMake(0, 2.5+15.0, _label.frame.size.width, _label.frame.size.height)];
            }
        }
        
        self.frame = CGRectMake(LEFT_DISTANCE_CHAT_HEAD, 0, bgView.frame.size.width, bgView.frame.size.height);
        
    } else if (entity.is_recieved == MSG_IO_FLG_SEND) {
        // 发送的消息
        _label.textColor = [UIColor whiteColor];
        bgView.image = [bgViewSend resizableImageWithCapInsets:UIEdgeInsetsMake(bgViewSend.size.height/2.0,bgViewSend.size.width/2.0, bgViewSend.size.height/2.0, bgViewSend.size.width/2.0)];
        self.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - bgView.frame.size.width - RIGHT_DISTANCE_CHAT_HEAD, 0, bgView.frame.size.width, bgView.frame.size.height);
    }
    
}
//-------------------------------------------------------------------

//---添加复制功能菜单---------------------------------------------------
-(void)showMenu:(UILongPressGestureRecognizer *)gestureRecognizer{
   
    if (self.entity!=nil) {
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            //NSLog(@"UIGestureRecognizerStateBegan");
            
            [self becomeFirstResponder];
            
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            [menuController setMenuVisible:NO];
            
            UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menu1Copy:)];
            UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(menu2Transpond:)];
            UIMenuItem *menuItem3 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(menu3Delete:)];
            
            if ([_fromName isEqualToString:@"feedback"]) {//update 2015.07.03
                 [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1,nil]];
            }else{
                 [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1,menuItem2,menuItem3,nil]];
               

            }
            
            [menuController setTargetRect:gestureRecognizer.view.frame inView:self.superview];
            [menuController setMenuVisible:YES animated:YES];
            
        }
    }else if (self.entityForGroup!=nil){// add 2015.06.01
        
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            //NSLog(@"UIGestureRecognizerStateBegan");
            
            [self becomeFirstResponder];
            
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            [menuController setMenuVisible:NO];
            
            UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menu1Copy:)];
            //UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(menu2Transpond:)];
            UIMenuItem *menuItem3 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(menu3Delete:)];
            [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1,menuItem3,nil]];
            [menuController setTargetRect:gestureRecognizer.view.frame inView:self.superview];
            [menuController setMenuVisible:YES animated:YES];
            
        }
        
        
    }else if (self.entityForMix!=nil){
        
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            
            [self becomeFirstResponder];
            
            if (self.entityForMix.groupid == 0) {//单聊
                
                UIMenuController *menuController = [UIMenuController sharedMenuController];
                [menuController setMenuVisible:NO];
                
                UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menu1Copy:)];
                UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(menu2Transpond:)];
                UIMenuItem *menuItem3 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(menu3Delete:)];
                
                //[menuController setMenuItems:[NSArray arrayWithObjects:menuItem1,menuItem2,menuItem3,nil]];
                 [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1,menuItem3,nil]];
                
                [menuController setTargetRect:gestureRecognizer.view.frame inView:self.superview];
                [menuController setMenuVisible:YES animated:YES];
                
            }else{//群聊
               
                UIMenuController *menuController = [UIMenuController sharedMenuController];
                [menuController setMenuVisible:NO];
                
                UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menu1Copy:)];
                //UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(menu2Transpond:)];
                UIMenuItem *menuItem3 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(menu3Delete:)];
                [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1,menuItem3,nil]];
                [menuController setTargetRect:gestureRecognizer.view.frame inView:self.superview];
                [menuController setMenuVisible:YES animated:YES];
                
            }
            
        }
        
    }
    
}

// 复制
-(void)menu1Copy:(UIMenuController *)menuController{
    
    if (self.entity!=nil) {
        NSString* o_text = self.entity.msg_content;
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:o_text];
    }else if (self.entityForGroup!=nil){// add 2015.06.01
        NSString* o_text = self.entityForGroup.msg_content;
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:o_text];
    }else if (self.entityForMix!=nil){
        NSString* o_text = self.entityForMix.msg_content;
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:o_text];
    }
    
}

// 删除
-(void)menu3Delete:(UIMenuController *)menuController{
    
    //发通知删除一条cell
    if (self.entity!=nil) {
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_DELETE_MSG object:self.entity];
    }else if (self.entityForGroup!=nil){//add 2015.06.01
        //Done:发送消息给群聊天详情页告知删除一条消息
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_DELETE_MSG_GROUP object:self.entityForGroup];
    }else if (self.entityForMix!=nil){
        
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_DELETE_MSG_MIX object:self.entityForMix];
    }
   
}

// 转发
-(void)menu2Transpond:(UIMenuController *)menuController{
    
    if (self.entity!=nil) {
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_TANSPOND_MSG object:self.entity];
    }else if (self.entityForGroup!=nil){//add 2015.06.01
        //To do:扩展用，现在群聊天先不做转发，发送消息给群聊天详情页告知删除一条消息
    }else if (self.entityForMix!=nil){
        
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_TANSPOND_MSG object:self.entityForMix];
    }
   
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(menu1Copy:) || action == @selector(menu2Transpond:) || action == @selector(menu3Delete:)){
        return YES;
    }else{
        return NO;
    }
}

/*// 单击打开链接或电话号码
-(void)touchMe:(id)sender{
    
    activeLink = [currentLabel linkAtPoint:pt];
    touchStartPoint = pt;
    
    NSTextCheckingResult *linkAtTouchesEnded = [currentLabel linkAtPoint:pt];
    
    BOOL closeToStart = (abs(touchStartPoint.x - pt.x) < 10 && abs(touchStartPoint.y - pt.y) < 10);
    
    // we can check on equality of the ranges themselfes since the data detectors create new results
    if (activeLink && (NSEqualRanges(activeLink.range,linkAtTouchesEnded.range) || closeToStart)) {
        BOOL openLink = (currentLabel.delegate && [currentLabel.delegate respondsToSelector:@selector(attributedLabel:shouldFollowLink:)])
        ? [currentLabel.delegate attributedLabel:currentLabel shouldFollowLink:activeLink] : YES;
        if (openLink){
           
            if ([[UIApplication sharedApplication]canOpenURL:activeLink.URL]) {
                
                // Safari打开
                //[[UIApplication sharedApplication]openURL:activeLink.URL];
                
                //内部WebView打开 2015.05.15
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenUrlByWebView" object:activeLink.URL];
             }
             
        }
    }
    
    //[activeLink release];
    activeLink = nil;

}*/

// 单击打开链接或电话号码
-(void)touchMe:(id)sender{
    
    link = [_label linkAtPoint:pt];
    
    if (link) {
       
        if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:link.linkValue]]) {
            
            // Safari打开
            //[[UIApplication sharedApplication]openURL:activeLink.URL];
            
            //内部WebView打开 2015.05.15
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenUrlByWebView" object:[NSURL URLWithString:link.linkValue]];
        }
    
    }
    link = nil;
    
}


#pragma mark UIGestureRecognizerDelegate methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    pt = [touch locationInView:self];
    return YES;
    
//    BOOL touchB = ![self.emojiLabel containslinkAtPoint:[touch locationInView:self.emojiLabel]];
//    return touchB;
    
}
//-------------------------------------------------------------------------

- (float)getTextHeight:(ChatDetailObject *)entity
{
 /*   // 普通的txt
//    CGFloat contentHeight = [Utilities heightForText:entity.msg_content withFont:[UIFont fontWithName:@"Helvetica" size:16]  withWidth:200];
//    NSLog(@"msgId:%lld,Height:%f",entity.msg_id,self.frame.size.height);
    
    NSString *newString = [self textFromEmoji:entity.msg_content];
   //CGFloat contentHeight = [Utilities heightForText:newString withFont:[UIFont fontWithName:@"Helvetica" size:16]  withWidth:200];
    CGSize size = [Utilities getStringHeight:newString andFont:[UIFont systemFontOfSize:16] andSize:CGSizeMake(200, CGFLOAT_MAX)];
    CGFloat contentHeight = size.height;
    NSLog(@"newString:%@",newString);
    NSLog(@"contentHeight:%f",contentHeight);
    return contentHeight;*/
    
    // 普通的txt 文字数非常多的时候，用上面的方法计算高度是有问题的，改用以下方法 2015.07.24
    NSString * inputText = nil;
    inputText = entity.msg_content;

    NSString *displayStr = [self transformString:inputText];
    NSMutableAttributedString* attString = [textParser attrStringFromMarkup:displayStr];
    
    attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
    [attString setFont:[UIFont systemFontOfSize:16]];
    
    [currentLabel setAttString:attString withImages:textParser.images];
    
    CGRect labelRect = currentLabel.frame;
    labelRect.size.width = [currentLabel sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].width;
    labelRect.size.height = [currentLabel sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].height;
    
    CGFloat height = labelRect.size.height;

    return height;
    
}

// add 2015.05.30
- (float)getTextHeightForGroup:(GroupChatDetailObject *)entity
{
    /*NSString *newString = [self textFromEmoji:entity.msg_content];
    CGFloat contentHeight = [Utilities heightForText:newString withFont:[UIFont fontWithName:@"Helvetica" size:16]  withWidth:200];
    return contentHeight;*/
    
    // 普通的txt 文字数非常多的时候，用上面的方法计算高度是有问题的，改用以下方法 2015.07.24
    NSString * inputText = nil;
    inputText = entity.msg_content;
    
    NSString *displayStr = [self transformString:inputText];
    NSMutableAttributedString* attString = [textParser attrStringFromMarkup:displayStr];
    
    attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
    [attString setFont:[UIFont systemFontOfSize:16]];
    
    [currentLabel setAttString:attString withImages:textParser.images];
    
    CGRect labelRect = currentLabel.frame;
    labelRect.size.width = [currentLabel sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].width;
    labelRect.size.height = [currentLabel sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].height;
    
    CGFloat height = labelRect.size.height;
    
    return height;
    
}

// add 2016.01.19
- (float)getTextHeightForMix:(MixChatDetailObject *)entity
{
    /*NSString *newString = [self textFromEmoji:entity.msg_content];
     CGFloat contentHeight = [Utilities heightForText:newString withFont:[UIFont fontWithName:@"Helvetica" size:16]  withWidth:200];
     return contentHeight;*/
    
    // 普通的txt 文字数非常多的时候，用上面的方法计算高度是有问题的，改用以下方法 2015.07.24
    NSString * inputText = nil;
    inputText = entity.msg_content;
    
    NSString *displayStr = [self transformString:inputText];
    NSMutableAttributedString* attString = [textParser attrStringFromMarkup:displayStr];
    
    attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
    [attString setFont:[UIFont systemFontOfSize:16]];
    
    [currentLabel setAttString:attString withImages:textParser.images];
    
    CGRect labelRect = currentLabel.frame;
    labelRect.size.width = [currentLabel sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].width;
    labelRect.size.height = [currentLabel sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].height;
    
    CGFloat height = labelRect.size.height;
    
    return height;
    
}


// 解决发送聊天时内容带表情cell的高度不准确的问题，因为一个表情字符里面带多个字符，统一替换成一个字符
- (NSString *)textFromEmoji:(NSString *)originalStr
{
    //匹配表情，将表情转化为html格式
    NSString *text = originalStr;
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSArray *array_emoji = [text componentsMatchedByRegex:regex_emoji];
    if ([array_emoji count]) {
        for (NSString *str in array_emoji) {
            NSRange range = [text rangeOfString:str];
            NSString *i_transCharacter = [self.emojiDic objectForKey:str];
            if (i_transCharacter) {
                NSString *imageHtml = [NSString stringWithFormat:@"怒"];
                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:imageHtml];
            }
        }
    }
    //返回转义后的字符串
    return text;
}

//------add by kate 2014.04.22---------------------


/*图文混排的自定义Label*/
- (OHAttributedLabel*)creatLabelArr:(NSString*)text
{
    OHAttributedLabel *label = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
    [self creatAttributedLabel:text Label:label];
    [self drawImage:label];
    
    return label;
}

/*画表情,将表情的imageview加到自定义label上*/
- (void)drawImage:(OHAttributedLabel *)label
{
    for (NSArray *info in label.imageInfoArr) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[info objectAtIndex:0] ofType:nil];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
            //NSLog(@"存在");
        }else{
            //NSLog(@"不存在");
        }
        
        NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
        SCGIFImageView *imageView = [[SCGIFImageView alloc] initWithGIFData:data];
        //UIImage* image = [UIImage imageWithData:data];
		//UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectFromString([info objectAtIndex:2]);
        [label addSubview:imageView];//label内添加图片层
        [label bringSubviewToFront:imageView];
        
    }
}

#pragma mark - 正则匹配电话号码，网址链接，Email地址
- (NSMutableArray *)addHttpArr:(NSString *)text
{
    //匹配网址链接
    NSString *regex_http = @"(https?|ftp|file)+://[^\\s]*";
    NSArray *array_http = [text componentsMatchedByRegex:regex_http];
    NSMutableArray *httpArr = [NSMutableArray arrayWithArray:array_http];
    return httpArr;
}

- (NSMutableArray *)addPhoneNumArr:(NSString *)text
{
    //匹配电话号码
    NSString *regex_phonenum = @"\\d{3}-\\d{7}|\\d{3}-\\d{8}|\\d{4}-\\d{7}|\\d{4}-\\d{8}|1+[3458]+\\d{9}|\\d{8}|\\d{7}";
    NSArray *array_phonenum = [text componentsMatchedByRegex:regex_phonenum];
    NSMutableArray *phoneNumArr = [NSMutableArray arrayWithArray:array_phonenum];
    return phoneNumArr;
}

- (NSMutableArray *)addEmailArr:(NSString *)text
{
    //匹配Email地址
    NSString *regex_email = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*.\\w+([-.]\\w+)*";
    NSArray *array_email = [text componentsMatchedByRegex:regex_email];
    NSMutableArray *emailArr = [NSMutableArray arrayWithArray:array_email];
    return emailArr;
}

- (NSString *)transformString:(NSString *)originalStr
{
    //匹配表情，将表情转化为html格式
    NSString *text = originalStr;
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSArray *array_emoji = [text componentsMatchedByRegex:regex_emoji];
    if ([array_emoji count]) {
        for (NSString *str in array_emoji) {
            NSRange range = [text rangeOfString:str];
            NSString *i_transCharacter = [self.emojiDic objectForKey:str];
            if (i_transCharacter) {
                NSString *imageHtml = [NSString stringWithFormat:@"<img src='%@' width='16' height='16'>",i_transCharacter];
                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:imageHtml];
            }
        }
    }
    //返回转义后的字符串
    return text;
}

- (BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo
{
    NSString *requestString = [linkInfo.URL absoluteString];
    NSLog(@"%@",requestString);
    if ([[UIApplication sharedApplication]canOpenURL:linkInfo.URL]) {
        [[UIApplication sharedApplication]openURL:linkInfo.URL];
    }
    return NO;
}

/*Label过滤*/
- (void)creatAttributedLabel:(NSString *)o_text Label:(OHAttributedLabel *)label
{
    
    [label setNeedsDisplay];
    NSMutableArray *httpArr = [self addHttpArr:o_text];
    NSMutableArray *phoneNumArr = [self addPhoneNumArr:o_text];
   
    NSString *text = [self transformString:o_text];
    text = [NSString stringWithFormat:@"<font color='black' strokeColor='gray' face='Palatino-Roman'>%@",text];
    MarkupParser* p = [[MarkupParser alloc] init] ;
    NSMutableAttributedString* attString = [p attrStringFromMarkup: text];
    
    //    attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
    [attString setFont:[UIFont systemFontOfSize:16]];
    label.backgroundColor = [UIColor clearColor];
    [label setAttString:attString withImages:p.images];

    //NSLog(@"attString:%@",attString);
    NSString *string = attString.string;
    
    if ([phoneNumArr count]) {
        for (NSString *phoneNum in phoneNumArr) {
            [label addCustomLink:[NSURL URLWithString:phoneNum] inRange:[string rangeOfString:phoneNum]];
        }
    }
    
    if ([httpArr count]) {
        for (NSString *httpStr in httpArr) {
            [label addCustomLink:[NSURL URLWithString:httpStr] inRange:[string rangeOfString:httpStr]];
        }
    }
    
    label.delegate = self;
    CGRect labelRect = label.frame;
    labelRect.size.width = [label sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].width;
    labelRect.size.height = [label sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].height;
    label.frame = labelRect;
    label.onlyCatchTouchesOnLinks = NO;
    label.underlineLinks = YES;//链接是否带下划线
    [label.layer display];
    // 调用这个方法立即触发label的|drawTextInRect:|方法，
    // |setNeedsDisplay|方法有滞后，因为这个需要画面稳定后才调用|drawTextInRect:|方法
    // 这里我们创建的时候就需要调用|drawTextInRect:|方法，所以用|display|方法，这个我找了很久才发现的
}

-(NSString*)sqliteEscape:(NSString*)keyWord{
    
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    //    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"[" withString:@"/["];
    //    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"]" withString:@"/]"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"/%" withString:@"%"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"''" withString:@"'"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"/&" withString:@"&"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"/_" withString:@"_"];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"/(" withString:@"("];
    keyWord = [keyWord stringByReplacingOccurrencesOfString:@"/)" withString:@")"];
    
    return keyWord;
}


//-------------------------------------------------

@end
