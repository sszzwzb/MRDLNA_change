//
//  MomentsTableViewCell.h
//  MicroSchool
//
//  Created by jojo on 14/12/15.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "OHAttributedLabel.h"
//#import "NSAttributedString+Attributes.h"

#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#import "MarkupParser.h"// add by kate

#import "TSTouchLabel.h"
#import "TSTouchImageView.h"
#import "TSTapGestureRecognizer.h"

#import "Utilities.h"
#import "MomentsSharedLink.h"

#import "TSAttributedLabel.h"

#import "MomentsDetailTableViewCell.h"

#import "MarkupParser.h"
#import "SCGIFImageView.h"
#import "RegexKitLite.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"


//#import <MLLabel/MLLinkLabel.h> // 2015.09.18
//#import <MLLabel/NSString+MLExpression.h>// 2015.09.18
//#import <MLLabel/NSAttributedString+MLExpression.h>// 2015.09.18



@interface MomentsTableViewCell : UITableViewCell<UITableViewDelegate, UITableViewDataSource>
{
    MarkupParser* textParser1;
    OHAttributedLabel *currentLabel;

}

// 当前点击的那个cell的uid
@property (copy, nonatomic) NSString *cellUid;

// 当前点击的那个cell的tid
@property (copy, nonatomic) NSString *cellTid;

// 当前点击的那个cell的pid
@property (copy, nonatomic) NSString *cellPid;

// 当前点击的那个cell是否被赞过
@property (copy, nonatomic) NSString *cellLove;

// 头像
@property (nonatomic, retain) UIButton *btn_thumb;

// 头像下方绿色点
@property (nonatomic, retain) UIImageView *imgView_leftlittilPoint;

// 左边竖线
@property (nonatomic, retain) UIImageView *imgView_leftLine;

// 最下方的线
@property (nonatomic, retain) UIImageView *imgView_line;
@property (nonatomic, retain) UIImageView *imgView_loves;

// 名字
@property (nonatomic, retain) TSTouchLabel *label_username;

// 内容
@property (nonatomic, retain) UILabel *label_message;

// 日期
@property (nonatomic, retain) UILabel *label_dateline;

// 查看更多btn
@property (nonatomic, retain) UIButton *btn_more;

// 查看详情btn
@property (nonatomic, retain) UIButton *btn_detail;
@property (nonatomic, retain) UIImageView *imgView_detail;

// 当前点击的那个cell
@property (copy, nonatomic) NSString *cellNum;

// 9张图片
@property (nonatomic, retain) TSTouchImageView *tsTouchImg_img1;
@property (nonatomic, retain) TSTouchImageView *tsTouchImg_img2;
@property (nonatomic, retain) TSTouchImageView *tsTouchImg_img3;
@property (nonatomic, retain) TSTouchImageView *tsTouchImg_img4;
@property (nonatomic, retain) TSTouchImageView *tsTouchImg_img5;
@property (nonatomic, retain) TSTouchImageView *tsTouchImg_img6;
@property (nonatomic, retain) TSTouchImageView *tsTouchImg_img7;
@property (nonatomic, retain) TSTouchImageView *tsTouchImg_img8;
@property (nonatomic, retain) TSTouchImageView *tsTouchImg_img9;
@property (nonatomic, retain) NSMutableArray *ary_imgThumb;
@property (nonatomic, retain) UIImageView *videoMarkImgV;

// 内容label
@property (nonatomic, retain) TSAttributedLabel *ohAttributeLabel;
@property (nonatomic, retain) MarkupParser* textParser;// add by kate bug fix
@property (nonatomic, retain) MarkupParser* textParser0;// add by kate bug fix
@property (nonatomic, retain) MarkupParser* textParser1;// add by kate bug fix
@property (nonatomic, retain) MarkupParser* textParser2;// add by kate bug fix

// 赞btn
@property (nonatomic, retain) UIButton *btn_like;
@property (nonatomic, retain) UIImageView *btn_likeIcon;

// 评论btn
@property (nonatomic, retain) UIButton *btn_comment;
@property (nonatomic, retain) UIImageView *btn_commentIcon;

// 添加到我的足迹btn
@property (nonatomic, retain) UIButton *btn_addToPath;
@property (nonatomic, retain) UIImageView *btn_pathIcon;

// 喜欢的人
@property (nonatomic, retain) UIButton *btn_likeNum;
@property (nonatomic, retain) UIImageView *imgView_likeBg;
@property (nonatomic, retain) UIImageView *imgView_headImg1;
@property (nonatomic, retain) UIImageView *imgView_headImg2;
@property (nonatomic, retain) UIImageView *imgView_headImg3;
@property (nonatomic, retain) UIImageView *imgView_headImg4;
@property (nonatomic, retain) UIImageView *imgView_headImg5;
@property (nonatomic, retain) UILabel *label_likeCount;

// 评论label1
@property (nonatomic, retain) TSAttributedLabel *ohAttLabel_comment1;
@property (nonatomic, retain) UIImageView *imgView_commentLine1;

// 评论label2
@property (nonatomic, retain) TSAttributedLabel *ohAttLabel_comment2;
@property (nonatomic, retain) UIImageView *imgView_commentLine2;

// 评论label3
@property (nonatomic, retain) TSAttributedLabel *ohAttLabel_comment3;

// 我的动态cell0上面的图标
@property (nonatomic, retain) UIImageView *img_cell0Img;

// 删除label
@property (nonatomic, retain) TSTouchLabel *tsLabel_delete;

// 分享链接
@property (nonatomic, retain) MomentsSharedLink *sharedLink;
@property (nonatomic, retain) NSDictionary *sharedLinkDic;

// 标签图片
@property (nonatomic, retain) UIImageView *tagImageView;

-(void)setMLLabelText:(NSString*)attributedStr;// 2015.09.18

-(void)setMLLabelCmt1Text:(NSString*)attributedStr;// 2015.09.18
-(void)setMLLabelCmt2Text:(NSString*)attributedStr;// 2015.09.18
-(void)setMLLabelCmt3Text:(NSString*)attributedStr;// 2015.09.18

-(void)setMLLabelCmt1Texta:(NSAttributedString*)attributedStr;
-(void)setMLLabelCmt3Texta:(NSString*)attributedStr and:(NSDictionary *)dic;

+ (CGSize)heightForEmojiText:(NSString*)emojiText;// 2015.09.18

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSMutableArray *arrInCell;
@property (nonatomic, retain) NSMutableArray *arrInCellHeight;

@property (nonatomic, retain) NSDictionary *emojiDic;


@property (nonatomic, retain) UIView *bgGrayView;

@property (nonatomic, retain) UILabel *lovesStrLabel;
@property (nonatomic, retain) UIImageView *lovesStrImageView;

- (void)test;

@end
