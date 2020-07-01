//
//  MomentsTableViewCell.m
//  MicroSchool
//
//  Created by jojo on 14/12/15.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "MomentsTableViewCell.h"
// 屏幕高度
#define HEIGHT [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation MomentsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSString *emojiFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/faceImages/expression/emotionImage.plist"];
        _emojiDic = [[NSDictionary alloc] initWithContentsOfFile:emojiFilePath];

        // 内容label
        _textParser = [[MarkupParser alloc] init];
        _ohAttributeLabel = [[TSAttributedLabel alloc] initWithFrame:CGRectZero];
        _ohAttributeLabel.backgroundColor = [UIColor clearColor];
        _ohAttributeLabel.dataDetectorTypes = MLDataDetectorTypeURL;
        [self.contentView addSubview:_ohAttributeLabel];

        TSTapGestureRecognizer *singleTouch = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(webLink_click:)];
        singleTouch.delegate = self;
        [_ohAttributeLabel addGestureRecognizer:singleTouch];

//        UILongPressGestureRecognizer *longPress =
//        [[UILongPressGestureRecognizer alloc] initWithTarget:self
//                                                      action:@selector(contentLongPress_click:)];
//        
//        //代理
//        longPress.delegate = self;
//        longPress.minimumPressDuration = 1.0;
//        //将长按手势添加到需要实现长按操作的视图里
//        [_ohAttributeLabel addGestureRecognizer:longPress];
        
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu:)];
        longPressRecognizer.delegate = self;
        [longPressRecognizer setMinimumPressDuration:1.0];
        [_ohAttributeLabel addGestureRecognizer:longPressRecognizer];

        // 评论label1
        _textParser0 = [[MarkupParser alloc] init];

        _ohAttLabel_comment1 = [[TSAttributedLabel alloc] initWithFrame:CGRectZero];
        _ohAttLabel_comment1.backgroundColor = [UIColor clearColor];
        _ohAttLabel_comment1.userInteractionEnabled = YES;
        _ohAttLabel_comment1.dataDetectorTypes = MLDataDetectorTypeNone;
        [self.contentView addSubview:_ohAttLabel_comment1];
        
        UILongPressGestureRecognizer *longPressRecognizer1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showMenuComment1:)];
        longPressRecognizer1.delegate = self;
        [longPressRecognizer1 setMinimumPressDuration:1.0];
        [_ohAttLabel_comment1 addGestureRecognizer:longPressRecognizer1];

        // 评论label2
        _textParser1 = [[MarkupParser alloc] init];

        _ohAttLabel_comment2 = [[TSAttributedLabel alloc] initWithFrame:CGRectZero];
        _ohAttLabel_comment2.backgroundColor = [UIColor clearColor];
        _ohAttLabel_comment2.userInteractionEnabled = YES;
        _ohAttLabel_comment2.dataDetectorTypes = MLDataDetectorTypeNone;
        [self.contentView addSubview:_ohAttLabel_comment2];
        
        UILongPressGestureRecognizer *longPressRecognizer2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showMenuComment2:)];
        longPressRecognizer2.delegate = self;
        [longPressRecognizer2 setMinimumPressDuration:1.0];
        [_ohAttLabel_comment2 addGestureRecognizer:longPressRecognizer2];

        // 评论label3
        _textParser2 = [[MarkupParser alloc] init];

        _ohAttLabel_comment3 = [[TSAttributedLabel alloc] initWithFrame:CGRectZero];
        _ohAttLabel_comment3.backgroundColor = [UIColor clearColor];
        _ohAttLabel_comment3.userInteractionEnabled = YES;
        _ohAttLabel_comment3.dataDetectorTypes = MLDataDetectorTypeNone;
        [self.contentView addSubview:_ohAttLabel_comment3];
        
        UILongPressGestureRecognizer *longPressRecognizer3 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showMenuComment3:)];
        longPressRecognizer3.delegate = self;
        [longPressRecognizer3 setMinimumPressDuration:1.0];
        [_ohAttLabel_comment3 addGestureRecognizer:longPressRecognizer3];

        _imgView_commentLine1 =[[UIImageView alloc]initWithFrame:CGRectZero];
        _imgView_commentLine1.image=[UIImage imageNamed:@"knowledge/tm.png"];
        _imgView_commentLine1.hidden = YES;
        [self.contentView addSubview:_imgView_commentLine1];
        
        _imgView_commentLine2 =[[UIImageView alloc]initWithFrame:CGRectZero];
        _imgView_commentLine2.image=[UIImage imageNamed:@"knowledge/tm.png"];
        _imgView_commentLine2.hidden = YES;
        [self.contentView addSubview:_imgView_commentLine2];
        
        // 分享链接
        _sharedLink =[[MomentsSharedLink alloc]initWithFrame:CGRectZero];
        _sharedLink.userInteractionEnabled = YES;
        _sharedLink.hidden = YES;
        TSTapGestureRecognizer *myTapGestureShardedLink = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(sharedLink_click:)];
        myTapGestureShardedLink.infoStr = @"99";
        [_sharedLink addGestureRecognizer:myTapGestureShardedLink];
        
//        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(sharedLink_longClick:)];
//        longPressGesture.minimumPressDuration=0.2;//默认0.5秒
//        [_sharedLink addGestureRecognizer:longPressGesture];
        
        [self.contentView addSubview:_sharedLink];

        // Initialization code
        // 头像
        _btn_thumb = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_thumb.frame = CGRectMake(
                                     10,
                                     4,
                                     40,
                                     40);
        [_btn_thumb addTarget:self action:@selector(thumb_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        _btn_thumb.layer.masksToBounds = YES;
        _btn_thumb.layer.cornerRadius = 40/2;
        _btn_thumb.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:_btn_thumb];
        
        // 头像下方绿色点
        _imgView_leftlittilPoint =[[UIImageView alloc] initWithFrame:CGRectMake(
                                                                               18,
                                                                               44,
                                                                               34,
                                                                               34)] ;
        _imgView_leftlittilPoint.contentMode = UIViewContentModeScaleToFill;
        [_imgView_leftlittilPoint setImage:[UIImage imageNamed:@"tlq_lvdian@2x.png"]];
        [self.contentView addSubview:_imgView_leftlittilPoint];

        // 左边竖线
        _imgView_leftLine =[[UIImageView alloc]
                           initWithFrame:CGRectMake(15,
                                                    0,
                                                    1,
                                                    25)] ;
        [_imgView_leftLine setImage:[UIImage imageNamed:@"tlq_lvxian.png"]];
        _imgView_leftLine.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:_imgView_leftLine];

        // 名字
        _label_username = [[TSTouchLabel alloc] initWithFrame:CGRectMake(
                                                                    _btn_thumb.frame.origin.x + _btn_thumb.frame.size.width + 5,
                                                                    _btn_thumb.frame.origin.y + 3,
                                                                    200,
                                                                    15)];
        _label_username.lineBreakMode = NSLineBreakByWordWrapping;
        _label_username.font = [UIFont systemFontOfSize:14.0f];
        _label_username.numberOfLines = 0;
        _label_username.backgroundColor = [UIColor clearColor];
        _label_username.lineBreakMode = NSLineBreakByTruncatingTail;
        _label_username.userInteractionEnabled = YES;
        _label_username.textColor = [[UIColor alloc] initWithRed:54/255.0f green:182/255.0f blue:169/255.0f alpha:1.0];
        [self.contentView addSubview:_label_username];
        
        // 标签
        _tagImageView =[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-120,
                                                                        5,
                                                                        110,
                                                                        62)];
        _tagImageView.contentMode = UIViewContentModeScaleToFill;
        _tagImageView.userInteractionEnabled = NO;
        [self.contentView addSubview:_tagImageView];

        // 日期
        _label_dateline = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                    _label_username.frame.origin.x,
                                                                    _label_username.frame.origin.y + _label_username.frame.size.height +5,
                                                                    120,
                                                                    20)];
        _label_dateline.lineBreakMode = NSLineBreakByWordWrapping;
        _label_dateline.font = [UIFont systemFontOfSize:12.0f];
        _label_dateline.numberOfLines = 0;
        _label_dateline.textColor = [UIColor grayColor];
        _label_dateline.backgroundColor = [UIColor clearColor];
        _label_dateline.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_label_dateline];
                
        self.contentView.userInteractionEnabled = YES;
        
        //---add by kate bug fix-------------------
        // 将此类放在cell里，之前点击自定义ohAttributeLabel重新画出了不同的东西是因为四个_ohAttributeLabel共用了同一个textParser，不可共用

        //-----------------------------------------

        // 查看更多btn
        _btn_more = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_more.frame = CGRectMake(_label_dateline.frame.origin.x,
                                     100, 30, 20);

        [_btn_more setTitleColor:[[UIColor alloc] initWithRed:54/255.0f green:182/255.0f blue:169/255.0f alpha:1.0] forState:UIControlStateNormal];
        [_btn_more setTitleColor:[[UIColor alloc] initWithRed:54/255.0f green:182/255.0f blue:169/255.0f alpha:1.0] forState:UIControlStateHighlighted];
        _btn_more.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        
        [_btn_more setBackgroundImage:[UIImage imageNamed:@"loading_gray.png"] forState:UIControlStateHighlighted] ;
        [_btn_more addTarget:self action:@selector(more_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        
        [_btn_more setTitle:@"查看全部" forState:UIControlStateNormal];
        [_btn_more setTitle:@"查看全部" forState:UIControlStateHighlighted];
        _btn_more.hidden = YES;
        [self.contentView addSubview:_btn_more];

        // 查看详情btn
        _btn_detail = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_detail.frame = CGRectZero;
        
        [_btn_detail setTitleColor:[[UIColor alloc] initWithRed:54/255.0f green:182/255.0f blue:169/255.0f alpha:1.0] forState:UIControlStateNormal];
        [_btn_detail setTitleColor:[[UIColor alloc] initWithRed:54/255.0f green:182/255.0f blue:169/255.0f alpha:1.0] forState:UIControlStateHighlighted];
        _btn_detail.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        
        [_btn_detail setBackgroundImage:[UIImage imageNamed:@"loading_gray.png"] forState:UIControlStateHighlighted] ;
        [_btn_detail addTarget:self action:@selector(detail_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        
        [_btn_detail setTitle:@"查看详情" forState:UIControlStateNormal];
        [_btn_detail setTitle:@"查看详情" forState:UIControlStateHighlighted];
        [self.contentView addSubview:_btn_detail];

        // 查看详情img
        _imgView_detail =[[UIImageView alloc]initWithFrame:CGRectZero];
        _imgView_detail.contentMode = UIViewContentModeScaleToFill;
        [_imgView_detail setImage:[UIImage imageNamed:@"moments/icon_ckxq.png"]];
        _imgView_detail.userInteractionEnabled = NO;
        [self.contentView addSubview:_imgView_detail];

        // 图片缩略图
        _tsTouchImg_img1 =[[TSTouchImageView alloc]initWithFrame:CGRectZero];
        _tsTouchImg_img1.contentMode = UIViewContentModeScaleAspectFill;
        _tsTouchImg_img1.clipsToBounds = YES;
        _tsTouchImg_img1.userInteractionEnabled = YES;
        _tsTouchImg_img1.layer.masksToBounds = YES;
        _tsTouchImg_img1.layer.cornerRadius = 5;
        TSTapGestureRecognizer *myTapGesture1 = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(img_btnclick:)];
        myTapGesture1.infoStr = @"0";
        [_tsTouchImg_img1 addGestureRecognizer:myTapGesture1];
        [self.contentView addSubview:_tsTouchImg_img1];
        
        _tsTouchImg_img2 =[[TSTouchImageView alloc]initWithFrame:CGRectZero];
        _tsTouchImg_img2.contentMode = UIViewContentModeScaleAspectFill;
        _tsTouchImg_img2.clipsToBounds = YES;
        _tsTouchImg_img2.userInteractionEnabled = YES;
        _tsTouchImg_img2.layer.masksToBounds = YES;
        _tsTouchImg_img2.layer.cornerRadius = 5;
        TSTapGestureRecognizer *myTapGesture2 = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(img_btnclick:)];
        myTapGesture2.infoStr = @"1";
        [_tsTouchImg_img2 addGestureRecognizer:myTapGesture2];
        [self.contentView addSubview:_tsTouchImg_img2];
        
        _tsTouchImg_img3 =[[TSTouchImageView alloc]initWithFrame:CGRectZero];
        _tsTouchImg_img3.contentMode = UIViewContentModeScaleAspectFill;
        _tsTouchImg_img3.clipsToBounds = YES;
        _tsTouchImg_img3.userInteractionEnabled = YES;
        _tsTouchImg_img3.layer.masksToBounds = YES;
        _tsTouchImg_img3.layer.cornerRadius = 5;
        TSTapGestureRecognizer *myTapGesture3 = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(img_btnclick:)];
        myTapGesture3.infoStr = @"2";
        [_tsTouchImg_img3 addGestureRecognizer:myTapGesture3];
        [self.contentView addSubview:_tsTouchImg_img3];

        _tsTouchImg_img4 =[[TSTouchImageView alloc]initWithFrame:CGRectZero];
        _tsTouchImg_img4.contentMode = UIViewContentModeScaleAspectFill;
        _tsTouchImg_img4.clipsToBounds = YES;
        _tsTouchImg_img4.userInteractionEnabled = YES;
        _tsTouchImg_img4.layer.masksToBounds = YES;
        _tsTouchImg_img4.layer.cornerRadius = 5;
        TSTapGestureRecognizer *myTapGesture4 = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(img_btnclick:)];
        myTapGesture4.infoStr = @"3";
        [_tsTouchImg_img4 addGestureRecognizer:myTapGesture4];
        [self.contentView addSubview:_tsTouchImg_img4];

        _tsTouchImg_img5 =[[TSTouchImageView alloc]initWithFrame:CGRectZero];
        _tsTouchImg_img5.contentMode = UIViewContentModeScaleAspectFill;
        _tsTouchImg_img5.clipsToBounds = YES;
        _tsTouchImg_img5.userInteractionEnabled = YES;
        _tsTouchImg_img5.layer.masksToBounds = YES;
        _tsTouchImg_img5.layer.cornerRadius = 5;
        TSTapGestureRecognizer *myTapGesture5 = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(img_btnclick:)];
        myTapGesture5.infoStr = @"4";
        [_tsTouchImg_img5 addGestureRecognizer:myTapGesture5];
        [self.contentView addSubview:_tsTouchImg_img5];
        
        _tsTouchImg_img6 =[[TSTouchImageView alloc]initWithFrame:CGRectZero];
        _tsTouchImg_img6.contentMode = UIViewContentModeScaleAspectFill;
        _tsTouchImg_img6.clipsToBounds = YES;
        _tsTouchImg_img6.userInteractionEnabled = YES;
        _tsTouchImg_img6.layer.masksToBounds = YES;
        _tsTouchImg_img6.layer.cornerRadius = 5;
        TSTapGestureRecognizer *myTapGesture6 = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(img_btnclick:)];
        myTapGesture6.infoStr = @"5";
        [_tsTouchImg_img6 addGestureRecognizer:myTapGesture6];
        [self.contentView addSubview:_tsTouchImg_img6];
        
        _tsTouchImg_img7 =[[TSTouchImageView alloc]initWithFrame:CGRectZero];
        _tsTouchImg_img7.contentMode = UIViewContentModeScaleAspectFill;
        _tsTouchImg_img7.clipsToBounds = YES;
        _tsTouchImg_img7.userInteractionEnabled = YES;
        _tsTouchImg_img7.layer.masksToBounds = YES;
        _tsTouchImg_img7.layer.cornerRadius = 5;
        TSTapGestureRecognizer *myTapGesture7 = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(img_btnclick:)];
        myTapGesture7.infoStr = @"6";
        [_tsTouchImg_img7 addGestureRecognizer:myTapGesture7];
        [self.contentView addSubview:_tsTouchImg_img7];
        
        _tsTouchImg_img8 =[[TSTouchImageView alloc]initWithFrame:CGRectZero];
        _tsTouchImg_img8.contentMode = UIViewContentModeScaleAspectFill;
        _tsTouchImg_img8.clipsToBounds = YES;
        _tsTouchImg_img8.userInteractionEnabled = YES;
        _tsTouchImg_img8.layer.masksToBounds = YES;
        _tsTouchImg_img8.layer.cornerRadius = 5;
        TSTapGestureRecognizer *myTapGesture8 = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(img_btnclick:)];
        myTapGesture8.infoStr = @"7";
        [_tsTouchImg_img8 addGestureRecognizer:myTapGesture8];
        [self.contentView addSubview:_tsTouchImg_img8];
        
        _tsTouchImg_img9 =[[TSTouchImageView alloc]initWithFrame:CGRectZero];
        _tsTouchImg_img9.contentMode = UIViewContentModeScaleAspectFill;
        _tsTouchImg_img9.clipsToBounds = YES;
        _tsTouchImg_img9.userInteractionEnabled = YES;
        _tsTouchImg_img9.layer.masksToBounds = YES;
        _tsTouchImg_img9.layer.cornerRadius = 5;
        TSTapGestureRecognizer *myTapGesture9 = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(img_btnclick:)];
        myTapGesture9.infoStr = @"8";
        [_tsTouchImg_img9 addGestureRecognizer:myTapGesture9];
        [self.contentView addSubview:_tsTouchImg_img9];
        
        _ary_imgThumb = [[NSMutableArray alloc] init];
        [_ary_imgThumb addObject:_tsTouchImg_img1];
        [_ary_imgThumb addObject:_tsTouchImg_img2];
        [_ary_imgThumb addObject:_tsTouchImg_img3];
        [_ary_imgThumb addObject:_tsTouchImg_img4];
        [_ary_imgThumb addObject:_tsTouchImg_img5];
        [_ary_imgThumb addObject:_tsTouchImg_img6];
        [_ary_imgThumb addObject:_tsTouchImg_img7];
        [_ary_imgThumb addObject:_tsTouchImg_img8];
        [_ary_imgThumb addObject:_tsTouchImg_img9];

        // 赞btn
        _btn_like = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_like.frame = CGRectZero;
        _btn_like.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _btn_like.contentEdgeInsets = UIEdgeInsetsMake(0,3, 0, 0);

        [_btn_like setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_btn_like setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        _btn_like.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        
//        [_btn_like setBackgroundImage:[UIImage imageNamed:@"loading_gray.png"] forState:UIControlStateHighlighted] ;
        [_btn_like addTarget:self action:@selector(like_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        [self.contentView addSubview:_btn_like];

        // 赞前面的icon
        _btn_likeIcon =[[UIImageView alloc]initWithFrame:CGRectZero];
        _btn_likeIcon.contentMode = UIViewContentModeScaleToFill;
        _btn_likeIcon.hidden = YES;
        [_btn_likeIcon setImage:[UIImage imageNamed:@"moments/icon_moments_z_d.png"]];
        [self.contentView addSubview:_btn_likeIcon];

        // 评论btn
        _btn_comment = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_comment.frame = CGRectZero;
        _btn_comment.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _btn_comment.contentEdgeInsets = UIEdgeInsetsMake(0,3, 0, 0);
        [_btn_comment setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_btn_comment setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];

        _btn_comment.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        
//        [_btn_comment setBackgroundImage:[UIImage imageNamed:@"loading_gray.png"] forState:UIControlStateHighlighted] ;
        [_btn_comment addTarget:self action:@selector(commentClick_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        [self.contentView addSubview:_btn_comment];

        // 评论前面的icon
        _btn_commentIcon =[[UIImageView alloc]initWithFrame:CGRectZero];
        _btn_commentIcon.contentMode = UIViewContentModeScaleToFill;
        [_btn_commentIcon setImage:[UIImage imageNamed:@"moments/icon_moments_pl.png"]];
        [self.contentView addSubview:_btn_commentIcon];

        // 添加到我的足迹btn
        _btn_addToPath = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_addToPath.frame = CGRectZero;
        _btn_addToPath.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _btn_addToPath.contentEdgeInsets = UIEdgeInsetsMake(0,3, 0, 0);
        [_btn_addToPath setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_btn_addToPath setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//        [_btn_addToPath setTitle:@"添加至成长足迹" forState:UIControlStateNormal];
//        [_btn_addToPath setTitle:@"添加至成长足迹" forState:UIControlStateHighlighted];
        _btn_addToPath.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        
//        [_btn_addToPath setBackgroundImage:[UIImage imageNamed:@"loading_gray.png"] forState:UIControlStateHighlighted] ;
        [_btn_addToPath addTarget:self action:@selector(addToPahtClick_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        [self.contentView addSubview:_btn_addToPath];
        
        // 添加到我的足迹前面的icon
        _btn_pathIcon =[[UIImageView alloc]initWithFrame:CGRectZero];
        _btn_pathIcon.contentMode = UIViewContentModeScaleToFill;
        [_btn_pathIcon setImage:[UIImage imageNamed:@"moments/moments_addToPath.png"]];
        [self.contentView addSubview:_btn_pathIcon];

        _bgGrayView = [[UIView alloc] init];
        _bgGrayView.layer.masksToBounds = YES;
        _bgGrayView.layer.cornerRadius = 5;
        [self.contentView addSubview:_bgGrayView];

        
        _lovesStrLabel = [[UILabel alloc] init];
        _lovesStrLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _lovesStrLabel.font = [UIFont systemFontOfSize:13.0f];
        _lovesStrLabel.numberOfLines = 0;
        _lovesStrLabel.textColor = [[UIColor alloc] initWithRed:54/255.0f green:182/255.0f blue:169/255.0f alpha:1.0];
        _lovesStrLabel.backgroundColor = [UIColor clearColor];
        _lovesStrLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_lovesStrLabel];

        
        _lovesStrImageView =[[UIImageView alloc]initWithFrame:CGRectZero];
        _lovesStrImageView.contentMode = UIViewContentModeScaleToFill;
        [_lovesStrImageView setImage:[UIImage imageNamed:@"moments/momentsLikeIcon"]];
        _lovesStrImageView.hidden = YES;
        [self.contentView addSubview:_lovesStrImageView];

        // 喜欢的人
        _imgView_likeBg =[[UIImageView alloc]initWithFrame:CGRectZero];
        _imgView_likeBg.contentMode = UIViewContentModeScaleToFill;
        [_imgView_likeBg setImage:[UIImage imageNamed:@"tlq_history.png"]];
        _imgView_likeBg.userInteractionEnabled = NO;
        _imgView_likeBg.hidden = YES;
        [self.contentView addSubview:_imgView_likeBg];
        
        // 喜欢的人上面的5个头像
        _imgView_headImg1 =[[UIImageView alloc]initWithFrame:CGRectZero];
        _imgView_headImg1.contentMode = UIViewContentModeScaleToFill;
        _imgView_headImg1.layer.masksToBounds = YES;
        _imgView_headImg1.layer.cornerRadius = 35/2;
        _imgView_headImg1.userInteractionEnabled = NO;
        _imgView_headImg1.hidden = YES;
        [self.contentView addSubview:_imgView_headImg1];
        
        _imgView_headImg2 =[[UIImageView alloc]initWithFrame:CGRectZero];
        _imgView_headImg2.contentMode = UIViewContentModeScaleToFill;
        _imgView_headImg2.layer.masksToBounds = YES;
        _imgView_headImg2.layer.cornerRadius = 35/2;
        _imgView_headImg2.userInteractionEnabled = NO;
        _imgView_headImg2.hidden = YES;
        [self.contentView addSubview:_imgView_headImg2];
        
        _imgView_headImg3 =[[UIImageView alloc]initWithFrame:CGRectZero];
        _imgView_headImg3.contentMode = UIViewContentModeScaleToFill;
        _imgView_headImg3.layer.masksToBounds = YES;
        _imgView_headImg3.layer.cornerRadius = 35/2;
        _imgView_headImg3.userInteractionEnabled = NO;
        _imgView_headImg3.hidden = YES;
        [self.contentView addSubview:_imgView_headImg3];
        
        _imgView_headImg4 =[[UIImageView alloc]initWithFrame:CGRectZero];
        _imgView_headImg4.contentMode = UIViewContentModeScaleToFill;
        _imgView_headImg4.layer.masksToBounds = YES;
        _imgView_headImg4.layer.cornerRadius = 35/2;
        _imgView_headImg4.userInteractionEnabled = NO;
        _imgView_headImg4.hidden = YES;
        [self.contentView addSubview:_imgView_headImg4];
        
        _imgView_headImg5 =[[UIImageView alloc]initWithFrame:CGRectZero];
        _imgView_headImg5.contentMode = UIViewContentModeScaleToFill;
        _imgView_headImg5.layer.masksToBounds = YES;
        _imgView_headImg5.layer.cornerRadius = 35/2;
        _imgView_headImg5.userInteractionEnabled = NO;
        _imgView_headImg5.hidden = YES;
        [self.contentView addSubview:_imgView_headImg5];
        
        _label_likeCount = [[UILabel alloc] initWithFrame:CGRectZero];
        _label_likeCount.lineBreakMode = NSLineBreakByWordWrapping;
        _label_likeCount.font = [UIFont systemFontOfSize:13.0f];
        _label_likeCount.numberOfLines = 0;
        _label_likeCount.textColor = [UIColor blackColor];
        _label_likeCount.backgroundColor = [UIColor clearColor];
        _label_likeCount.lineBreakMode = NSLineBreakByTruncatingTail;
        _label_likeCount.userInteractionEnabled = NO;
        _label_likeCount.hidden = YES;
        [self.contentView addSubview:_label_likeCount];
        
        _btn_likeNum = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_likeNum.frame = CGRectZero;
        [_btn_likeNum addTarget:self action:@selector(likeNum_btnclick:) forControlEvents:UIControlEventTouchUpInside];
        _btn_likeNum.contentMode = UIViewContentModeScaleToFill;
        _btn_likeNum.hidden = YES;
        [self.contentView addSubview:_btn_likeNum];

        _tsLabel_delete =[[TSTouchLabel alloc]initWithFrame:CGRectMake(_label_dateline.frame.origin.x + _label_dateline.frame.size.width, _label_dateline.frame.origin.y+2, 26, 16)];
        _tsLabel_delete.text = @"删除";
        _tsLabel_delete.touchType = @"touchMomentsListDelete";
        _tsLabel_delete.userInteractionEnabled = YES;
        _tsLabel_delete.hidden = YES;
        _tsLabel_delete.font = [UIFont systemFontOfSize:12.0f];
        _tsLabel_delete.textColor = [[UIColor alloc] initWithRed:54/255.0f green:182/255.0f blue:169/255.0f alpha:1.0];
        [self.contentView addSubview:_tsLabel_delete];

        _img_cell0Img =[[UIImageView alloc]initWithFrame:CGRectZero];
        _img_cell0Img.image=[UIImage imageNamed:@"time_head.png"];
        _img_cell0Img.hidden = YES;
        [self.contentView addSubview:_img_cell0Img];

        // 最下方的线
        _imgView_line =[[UIImageView alloc]initWithFrame:CGRectZero];
        _imgView_line.image=[UIImage imageNamed:@"knowledge/tm.png"];
        [self.contentView addSubview:_imgView_line];
        
        _imgView_loves =[[UIImageView alloc]initWithFrame:CGRectZero];
        _imgView_loves.image=[UIImage imageNamed:@"knowledge/tm.png"];
        [self.contentView addSubview:_imgView_loves];

        // 评论列表
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.dataSource = self;
//        [_tableView.backgroundView setBackgroundView:nil];
        _tableView.backgroundView = nil;
//        _tableView.backgroundColor = [[UIColor alloc] initWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1.0];
//        _tableView.backgroundView = nil;
//        _tableView.backgroundView = nil;
        _tableView.backgroundColor = [UIColor clearColor];

        _tableView.userInteractionEnabled = YES;

        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.contentView addSubview:_tableView];
//        [self.contentView insertSubview:_tableView atIndex:2];
       
        _videoMarkImgV = [[UIImageView alloc] init];
        
        _videoMarkImgV.frame = CGRectMake(([Utilities convertPixsH:240.0] - 60.0)/2.0+_tsTouchImg_img1.frame.origin.x, ([Utilities convertPixsH:180.0]-60.0)/2.0+_tsTouchImg_img1.frame.origin.y, 60.0, 60.0);
        
        _videoMarkImgV.image = [UIImage imageNamed:@"videoMarkBig.png"];
        
        [self.contentView addSubview:_videoMarkImgV];
            
        
    }
    return self;
}

- (void)reload {
    [_tableView reloadData];
}

- (void)test {
    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)img_btnclick:(id)sender
{
    TSTapGestureRecognizer *tsTap = (TSTapGestureRecognizer *)sender;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         tsTap.infoStr, @"tag",
                         _cellNum, @"cellNum",
                         nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_momentsClickImgList" object:self userInfo:dic];
}

- (IBAction)sharedLink_click:(id)sender
{
    TSTapGestureRecognizer *tsTap = (TSTapGestureRecognizer *)sender;
    
    _sharedLinkDic = [NSDictionary dictionaryWithObjectsAndKeys:
                         tsTap.infoStr, @"tag",
                         _cellNum, @"cellNum",
                         nil];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_MOMENTS_CLICKSHAREDLINK object:self userInfo:_sharedLinkDic];

    _sharedLink.imgViewBG.frame = CGRectMake(0, 0, _sharedLink.frame.size.width, _sharedLink.frame.size.height);
    _sharedLink.imgViewBG.image=[UIImage imageNamed:@"moments/touch_bgImg.png"];
    [_sharedLink.viewForBaselineLayout addSubview:_sharedLink.imgViewBG];

    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];

}

- (IBAction)contentLongPress_click:(id)sender
{
//    [self showMenu:(UIGestureRecognizer *)];
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                         _cellNum, @"cellNum",
//                         nil];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_MOMENTS_CLICKWEBLINK object:self userInfo:dic];
}

- (IBAction)webLink_click:(id)sender
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                      _cellNum, @"cellNum",
                      nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_MOMENTS_CLICKWEBLINK object:self userInfo:dic];
}

#if 0
- (IBAction)sharedLink_longClick:(id)sender
 
#endif

-(void)testFinishedLoadData{

    [_sharedLink.imgViewBG removeFromSuperview];

    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_MOMENTS_CLICKSHAREDLINK object:self userInfo:_sharedLinkDic];

}

- (IBAction)remove_btnclick:(id)sender
{
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                         _cellUid, @"uid",
//                         nil];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_fromMoments2ProfileView" object:self userInfo:dic];
}

- (IBAction)thumb_btnclick:(id)sender
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         _cellUid, @"uid",
                         nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_fromMoments2ProfileView" object:self userInfo:dic];
}

- (IBAction)more_btnclick:(id)sender
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         _cellNum, @"cellNum",
                         nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_momentsMore" object:self userInfo:dic];
}

- (IBAction)like_btnclick:(id)sender
{
    NSLog(@"like_btnclick");
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         _cellTid, @"tid",
                         _cellNum, @"cellNum",
                         _cellLove, @"cellLove",
                         nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_momentsLike" object:self userInfo:dic];
}

- (IBAction)addToPahtClick_btnclick:(id)sender
{
    NSLog(@"addToPahtClick_btnclick");
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         _cellTid, @"tid",
                         _cellNum, @"cellNum",
                         _cellLove, @"cellLove",
                         nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_momentsClickAddToPath" object:self userInfo:dic];
}

- (IBAction)comment_btnclick:(id)sender
{
//    NSLog(@"comment_btnclick");
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                         _cellTid, @"tid",
//                         _cellNum, @"cellNum",
//                         nil];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_momentsComment" object:self userInfo:dic];
}

- (IBAction)detail_btnclick:(id)sender
{
    NSLog(@"detail_btnclick");
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         _cellNum, @"cellNum",
                         _cellTid, @"tid",
                         nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_momentsDetail" object:self userInfo:dic];
}

// 赞的人列表
- (IBAction)likeNum_btnclick:(id)sender
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         _cellNum, @"cellNum",
                         nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_momentsToLikerList" object:self userInfo:dic];// update by kate
}

- (IBAction)commentClick_btnclick:(id)sender
{
    // 点击评论btn
    NSLog(@"commentClick_btnclick");

//    UIButton *btn = (UIButton *)sender;
//    NSLog(@"%d", btn.tag);
//    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         _cellNum, @"cellNum",
                         _cellTid, @"cellTid",
                         nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_momentsComment" object:self userInfo:dic];
}

-(void)showMenuComment2:(UIGestureRecognizer*)gestureRecognizer{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        [self becomeFirstResponder];
        
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [menuController setMenuVisible:NO];
        
        if ([self.ohAttLabel_comment2.msgUid isEqual: [Utilities getUniqueUid]]) {
            UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuCopyComment2:)];
            UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(menuDeleteComment2:)];
            
            [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1, menuItem2, nil]];
            
        }else {
            UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuCopyComment2:)];
            [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1, nil]];
        }
        
        [menuController setTargetRect:gestureRecognizer.view.frame inView:self];
        [menuController setMenuVisible:YES animated:YES];
    }
}

-(void)menuDeleteComment2:(UIMenuController *)menuController{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         _ohAttLabel_comment2.msgPid, @"pid",
                         _ohAttLabel_comment2.msgUid, @"uid",
                         _ohAttLabel_comment2.msgPos, @"msgPos",
                         _ohAttLabel_comment2.cellNum, @"cellNum",
                         _ohAttLabel_comment2.msgTid, @"tid",
                         nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_momentsClickRemoveComment" object:self userInfo:dic];
}

-(void)menuCopyComment2:(UIMenuController *)menuController{
    NSString *content = _ohAttLabel_comment2.msgComment;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:content];
}


-(void)showMenuComment3:(UIGestureRecognizer*)gestureRecognizer{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        [self becomeFirstResponder];
        
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [menuController setMenuVisible:NO];
        
        if ([self.ohAttLabel_comment3.msgUid isEqual: [Utilities getUniqueUid]]) {
            UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuCopyComment3:)];
            UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(menuDeleteComment3:)];
            
            [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1, menuItem2, nil]];
            
        }else {
            UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuCopyComment3:)];
            [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1, nil]];
        }
        
        [menuController setTargetRect:gestureRecognizer.view.frame inView:self];
        [menuController setMenuVisible:YES animated:YES];
    }
}

-(void)menuDeleteComment3:(UIMenuController *)menuController{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         _ohAttLabel_comment3.msgPid, @"pid",
                         _ohAttLabel_comment3.msgUid, @"uid",
                         _ohAttLabel_comment3.msgPos, @"msgPos",
                         _ohAttLabel_comment3.cellNum, @"cellNum",
                         _ohAttLabel_comment3.msgTid, @"tid",
                         nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_momentsClickRemoveComment" object:self userInfo:dic];
}

-(void)menuCopyComment3:(UIMenuController *)menuController{
    NSString *content = _ohAttLabel_comment3.msgComment;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:content];
}



-(void)showMenuComment1:(UIGestureRecognizer*)gestureRecognizer{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        [self becomeFirstResponder];
        
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [menuController setMenuVisible:NO];
        
        if ([self.ohAttLabel_comment1.msgUid isEqual: [Utilities getUniqueUid]]) {
            UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuCopyComment1:)];
            UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(menuDeleteComment1:)];
            
            [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1, menuItem2, nil]];

        }else {
            UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuCopyComment1:)];
            [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1, nil]];
        }
        
        [menuController setTargetRect:gestureRecognizer.view.frame inView:self];
        [menuController setMenuVisible:YES animated:YES];
    }
}

-(void)menuDeleteComment1:(UIMenuController *)menuController{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         _ohAttLabel_comment1.msgPid, @"pid",
                         _ohAttLabel_comment1.msgUid, @"uid",
                         _ohAttLabel_comment1.msgPos, @"msgPos",
                         _ohAttLabel_comment1.cellNum, @"cellNum",
                         _ohAttLabel_comment1.msgTid, @"tid",
                         nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_momentsClickRemoveComment" object:self userInfo:dic];
}

-(void)menuCopyComment1:(UIMenuController *)menuController{
    NSString *content = _ohAttLabel_comment1.msgComment;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:content];
}


//---添加复制功能菜单---------------------------------------------------
-(void)showMenu:(UIGestureRecognizer*)gestureRecognizer{
    
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            //NSLog(@"UIGestureRecognizerStateBegan");
            
            [self becomeFirstResponder];
            
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            [menuController setMenuVisible:NO];
            
            UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuCopy:)];
            [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1,nil]];
            [menuController setTargetRect:gestureRecognizer.view.frame inView:self];
            [menuController setMenuVisible:YES animated:YES];
            
        }
}

// 复制
-(void)menuCopy:(UIMenuController *)menuController{
    NSString *content = [_ohAttributeLabel.attributedText string];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:content];
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(menuCopy:) ||
        action == @selector(menuCopyComment1:) ||
        action == @selector(menuDeleteComment1:) ||
        action == @selector(menuCopyComment2:) ||
        action == @selector(menuDeleteComment2:) ||
        action == @selector(menuCopyComment3:) ||
        action == @selector(menuDeleteComment3:) )
    {
        return YES;
    }else{
        return NO;
    }
}

// 2015.09.18
-(void)setMLLabelText:(NSString*)attributedStr{
    
    MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"/faceImages/expression/emotionImage.plist" bundleName:@"Expression"];//plistName bundleName 需要修改
    
    self.ohAttributeLabel.attributedText = [attributedStr expressionAttributedStringWithExpression:exp];
}

-(void)setMLLabelCmt1Text:(NSString*)attributedStr{
    
    MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"/faceImages/expression/emotionImage.plist" bundleName:@"Expression"];//plistName bundleName 需要修改
    
    self.ohAttLabel_comment1.attributedText = [attributedStr expressionAttributedStringWithExpression:exp];
}

-(void)setMLLabelCmt1Texta:(NSAttributedString*)attributedStr{
    
    
    self.ohAttLabel_comment1.attributedText = attributedStr;
}

-(void)setMLLabelCmt2Text:(NSString*)attributedStr{
    
    MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"/faceImages/expression/emotionImage.plist" bundleName:@"Expression"];//plistName bundleName 需要修改
    
    self.ohAttLabel_comment2.attributedText = [attributedStr expressionAttributedStringWithExpression:exp];
}

-(void)setMLLabelCmt3Text:(NSString*)attributedStr{
    
    MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"/faceImages/expression/emotionImage.plist" bundleName:@"Expression"];//plistName bundleName 需要修改
    
    self.ohAttLabel_comment3.attributedText = [attributedStr expressionAttributedStringWithExpression:exp];
}

-(void)setMLLabelCmt3Texta:(NSString*)attributedStr and:(NSDictionary *)dic{
    
    MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"/faceImages/expression/emotionImage.plist" bundleName:@"Expression"];//plistName bundleName 需要修改

    NSAttributedString* attString = [attributedStr expressionAttributedStringWithExpression:exp];
    NSMutableAttributedString* mutableAttStr = [[NSMutableAttributedString alloc] initWithAttributedString:attString];
    
    [mutableAttStr addAttribute:NSForegroundColorAttributeName
                          value:[[UIColor alloc] initWithRed:27/255.0f green:128/255.0f blue:209/255.0f alpha:1.0]
                          range:NSMakeRange(0,[[dic objectForKey:@"commentName"] length])];
    
    if (![@""  isEqual: [dic objectForKey:@"commentToName"]]) {
        [mutableAttStr addAttribute:NSForegroundColorAttributeName
                              value:[[UIColor alloc] initWithRed:27/255.0f green:128/255.0f blue:209/255.0f alpha:1.0]
                              range:NSMakeRange([[dic objectForKey:@"commentName"] length]+2,[[dic objectForKey:@"commentToName"] length])];
    }else {
        [mutableAttStr addAttribute:NSForegroundColorAttributeName
                              value:[UIColor blackColor]
                              range:NSMakeRange([[dic objectForKey:@"commentName"] length],[[dic objectForKey:@"commentMsg"] length])];
    }
    
    self.ohAttLabel_comment3.attributedText = mutableAttStr;

    
//    self.ohAttLabel_comment3.attributedText = attributedStr;
}

// 2015.09.18
+(CGSize)heightForEmojiText:(NSString*)emojiText
{
    MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"/faceImages/expression/emotionImage.plist" bundleName:@"Expression"];//plistName bundleName 需要修改
    
    NSAttributedString *expressionText = [emojiText expressionAttributedStringWithExpression:exp];
    
    TSAttributedLabel *label = kProtypeLabel();
    label.attributedText = expressionText;
    
    CGSize size = [label preferredSizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width - 60.0];//update 2015.08.12
    
    return size;
}

// 2015.09.18
#pragma mark - height
static TSAttributedLabel * kProtypeLabel() {
    
    static TSAttributedLabel *_protypeLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _protypeLabel = [TSAttributedLabel new];
        _protypeLabel.font = [UIFont systemFontOfSize:14.0f];
        _protypeLabel.numberOfLines = 0;
        _protypeLabel.textInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        
        
    });
    return _protypeLabel;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrInCell count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[_arrInCellHeight objectAtIndex:indexPath.row] floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    
    NSDictionary *dic = [_arrInCell objectAtIndex:indexPath.row];
    
    MomentsDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    
    if (cell == nil) {
        cell = [[MomentsDetailTableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
//    cell.backgroundColor =[[UIColor alloc] initWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1.0];
    
//    UIView *b = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.origin.x + 16, 0, cell.frame.size.width, cell.frame.size.height)];
//    b.backgroundColor = [[UIColor alloc] initWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1.0];
//    [cell.contentView addSubview:b];
    
    cell.backgroundColor=[UIColor clearColor];
    
    
    NSString *displayStr1 = [dic objectForKey:@"message"];
    
    NSString *commentName = [Utilities replaceNull:[dic objectForKey:@"name"]];
    NSString *commentToName = [dic objectForKey:@"toName"];
    
    NSString *cmt;
    if ([@""  isEqual: commentToName]) {
        // 单独回复
        cmt = [NSString stringWithFormat:@"%@：%@",commentName, displayStr1];
    }else {
        // 回复的回复
        cmt = [NSString stringWithFormat:@"%@回复%@：%@",commentName, commentToName, displayStr1];
    }
    
    NSString *msg = [self transformString:cmt];
    
    // 为了准确计算高度，需要先把表情字符换算成一个汉字，然后计算高度
    NSString *testFormEmo = [self textFromEmoji:cmt];
    
    CGSize commentNameSize = [Utilities getStringHeight:commentName andFont:[UIFont systemFontOfSize:14] andSize:CGSizeMake(0, 16)];
    CGSize commentToNameSize = [Utilities getStringHeight:commentToName andFont:[UIFont systemFontOfSize:14] andSize:CGSizeMake(0, 16)];
    CGSize wholeNameSize = [Utilities getStringHeight:[NSString stringWithFormat:@"%@回复%@",commentName, commentToName] andFont:[UIFont systemFontOfSize:14] andSize:CGSizeMake(0, 16)];
    
    // 整条msg的size，先按照不足一行计算，如果超过一行，下面再计算一次
    //    CGSize msgSize = [Utilities getStringHeight:testFormEmo andFont:[UIFont systemFontOfSize:14] andSize:CGSizeMake(0, 16)];
    
    //    CGSize msgSize = [self getTextHeight:msg andFont:[UIFont systemFontOfSize:14] andSize:CGSizeMake(0, 16)];
    
    
    
    
    MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"/faceImages/expression/emotionImage.plist" bundleName:@"Expression"];//plistName bundleName 需要修改
    
    NSAttributedString *expressionText = [cmt expressionAttributedStringWithExpression:exp];
    
    TSAttributedLabel *label = kProtypeLabel();
    label.attributedText = expressionText;
    label.font = [UIFont systemFontOfSize:13.0f];
    
    CGSize msgSize = [label sizeThatFits:CGSizeMake(0, 16)];//update 2015.08.12
    
    
    
    
    // 增加名字点击事件
    cell.ohAttributeLabel.msgPid = [dic objectForKey:@"pid"];
    cell.ohAttributeLabel.msgUid = [dic objectForKey:@"uid"];
    cell.ohAttributeLabel.msgPos = [NSString stringWithFormat:@"%lu", indexPath.row];
    cell.ohAttributeLabel.cellNum = _cellNum;
    cell.ohAttributeLabel.msgTid = _cellTid;

    cell.ohAttributeLabel.hasName1 = 1;
    cell.ohAttributeLabel.name1Start = 0;
    cell.ohAttributeLabel.name1End = commentNameSize.width;
    cell.ohAttributeLabel.name1Uid = [dic objectForKey:@"uid"];
    
    cell.ohAttributeLabel.hasName2 = 1;
    cell.ohAttributeLabel.name2Start = wholeNameSize.width - commentToNameSize.width;
    cell.ohAttributeLabel.name2End = wholeNameSize.width;
    cell.ohAttributeLabel.name2Size = commentToNameSize.width;
    cell.ohAttributeLabel.name2Uid = [dic objectForKey:@"toUid"];
    
    cell.ohAttributeLabel.msgComment = displayStr1;
    
    // 增加对整条msg的点击事件
    if (msgSize.width > (320 - 20)) {
        // 超过一行的宽度，按照msg一行的宽度计算的高度set到label中
        //        CGSize msgSize1 = [Utilities getStringHeight:testFormEmo andFont:[UIFont systemFontOfSize:14] andSize:CGSizeMake(320 - 40, 0)];
        CGSize msgSize1 = [self getTextHeight:testFormEmo andFont:[UIFont systemFontOfSize:13] andSize:CGSizeMake(290, 0)];
        
        int ohAttributeLabelHeightaa = [[_arrInCellHeight objectAtIndex:indexPath.row] floatValue];

        cell.ohAttributeLabel.msgHeight = ohAttributeLabelHeightaa;
        cell.ohAttributeLabel.msgWidth = 290;
    }else {
        
        int ohAttributeLabelHeightaa = [[_arrInCellHeight objectAtIndex:indexPath.row] floatValue];

        cell.ohAttributeLabel.msgHeight = ohAttributeLabelHeightaa;
        cell.ohAttributeLabel.msgWidth = 290;
    }
    
    [cell.textParser.images removeAllObjects];
    
    NSAttributedString* attString = [cmt expressionAttributedStringWithExpression:exp];
    NSMutableAttributedString* mutableAttStr = [[NSMutableAttributedString alloc] initWithAttributedString:attString];
    
    [mutableAttStr addAttribute:NSForegroundColorAttributeName
                          value:[[UIColor alloc] initWithRed:54/255.0f green:182/255.0f blue:169/255.0f alpha:1.0]
                          range:NSMakeRange(0,[commentName length])];
    
    if (![@""  isEqual: commentToName]) {
        [mutableAttStr addAttribute:NSForegroundColorAttributeName
                              value:[[UIColor alloc] initWithRed:54/255.0f green:182/255.0f blue:169/255.0f alpha:1.0]
                              range:NSMakeRange([commentName length]+2,[commentToName length])];
    }

    cell.ohAttributeLabel.attributedText = mutableAttStr;
    cell.ohAttributeLabel.font = [UIFont systemFontOfSize:13.0f];
    cell.ohAttributeLabel.numberOfLines = 0;
    
    int ohAttributeLabelHeight = [[_arrInCellHeight objectAtIndex:indexPath.row] floatValue];
    cell.ohAttributeLabel.frame = CGRectMake(20,
                                             10,
                                             290,
                                             ohAttributeLabelHeight);
    
    cell.imgView_bottomLime.frame = CGRectMake(0,
                                               [[_arrInCellHeight objectAtIndex:indexPath.row] floatValue],
                                               WIDTH,
                                               1);

    cell.imgView_bottomLime.hidden = YES;

    // 最后一条下面的分割线隐藏掉
//    if (indexPath.row == ([_arrInCell count]-1)) {
//        cell.imgView_bottomLime.hidden = YES;
//    }else {
//        cell.imgView_bottomLime.hidden = NO;
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
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

- (CGSize)getTextHeight:(NSString *)str andFont:(UIFont *)font andSize:(CGSize)size
{
    /*// 普通的txt
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
    inputText = str;
    
    NSString *displayStr = [self transformString:inputText];
    NSMutableAttributedString* attString = [textParser1 attrStringFromMarkup:displayStr];
    
    attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
    [attString setFont:font];
    
    currentLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    currentLabel.backgroundColor = [UIColor clearColor];
    
    [currentLabel setAttString:attString withImages:textParser1.images];
    
    CGRect labelRect = currentLabel.frame;
    labelRect.size.width = [currentLabel sizeThatFits:CGSizeMake(size.width, size.height)].width;
    labelRect.size.height = [currentLabel sizeThatFits:CGSizeMake(size.width, size.height)].height;
    
    return labelRect.size;
    
}

@end
