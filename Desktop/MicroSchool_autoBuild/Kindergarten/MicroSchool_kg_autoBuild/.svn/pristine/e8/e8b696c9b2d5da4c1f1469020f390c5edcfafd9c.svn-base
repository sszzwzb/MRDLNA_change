//
//  DiscussDetailCell.m
//  MicroSchool
//
//  Created by jojo on 13-12-23.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "DiscussDetailCell.h"


@implementation DiscussDetailCell

@synthesize pid;
@synthesize uid;

@synthesize pic;
@synthesize cellNum;

@synthesize imgView_line;
@synthesize imgView_leftLine;

@synthesize imgView_leftlittilPoint;
@synthesize imgView_leftlittilMiddlePoint;

@synthesize label_leftNum;

@synthesize playRecordButton;
@synthesize animationImageView;
@synthesize playImageView;

@synthesize imageButton;

@synthesize btn_thumb;
@synthesize textParser;// add by kate
@synthesize label;//add by kate
@synthesize citeLabel;//add by kate
@synthesize button_copy;//2015.09.14

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //        GlobalSingletonRecordAudio* g_recordAudio = GlobalSingletonRecordAudio.sharedGlobalSingleton;
        //
        //        recordAudio = g_recordAudio;
        //        recordAudio.delegate = self;
        
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playAudioInCellCB:) name:@"Weixiao_playAudioInCellCB" object:nil];
        
        citeLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 4, 3, 3)];
        citeLabel.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:239.0/255.0 blue:243.0/255.0 alpha:1];
        [self.contentView addSubview:citeLabel];
        
        /*----update 2015.09.18--------------------------------------------------------------
         label = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(1,4,3,3)];
         label.backgroundColor = [UIColor clearColor];
         label.font = [UIFont systemFontOfSize:16.0f];
         
         [self.contentView addSubview:label];*/
        
        //---add by kate------------------------------------
        textParser = [[MarkupParser alloc] init];
        //--------------------------------------------------
        
        //显示内容的label
        label = [[MLLinkLabel alloc] initWithFrame:CGRectMake(1, 4, 3, 3)];
        label.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.numberOfLines = 0;
        label.textInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        label.dataDetectorTypes = MLDataDetectorTypeURL;// 链接 电话 邮箱等显示 可自定义
        label.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor]};
        label.activeLinkTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor],NSBackgroundColorAttributeName:kDefaultActiveLinkBackgroundColorForMLLinkLabel};
        [self.contentView addSubview:label];
        //-------------------------------------------------------------------------------------
        
        // 头像下方绿色点
        imgView_leftlittilPoint =[[UIImageView alloc] initWithFrame:CGRectMake(
                                                                               18,
                                                                               40,
                                                                               34,
                                                                               34)] ;
        imgView_leftlittilPoint.contentMode = UIViewContentModeScaleToFill;
        [imgView_leftlittilPoint setImage:[UIImage imageNamed:@"tlq_lvdian.png"]];
        //[self.contentView addSubview:imgView_leftlittilPoint];
        
        // 缩略图
        btn_thumb = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_thumb.frame = CGRectMake(
                                     10,
                                     10,
                                     30,
                                     30);//y 坐标 从0调整成10
        [btn_thumb addTarget:self action:@selector(thumb_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        btn_thumb.layer.masksToBounds = YES;
        btn_thumb.layer.cornerRadius = 30/2;
        btn_thumb.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:btn_thumb];
        
        // 名字
        _label_username = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                    btn_thumb.frame.origin.x + btn_thumb.frame.size.width + 5,
                                                                    btn_thumb.frame.origin.y,
                                                                    200,
                                                                    15)];
        _label_username.lineBreakMode = NSLineBreakByWordWrapping;
        _label_username.font = [UIFont systemFontOfSize:14.0f];
        _label_username.numberOfLines = 0;
        _label_username.backgroundColor = [UIColor clearColor];
        _label_username.lineBreakMode = NSLineBreakByTruncatingTail;
        _label_username.textColor = [[UIColor alloc] initWithRed:102.0/255.0f green:102.0/255.0f blue:102.0/255.0f alpha:1.0];
        [self.contentView addSubview:_label_username];
        
        // 日期
        _label_dateline = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                    _label_username.frame.origin.x,
                                                                    _label_username.frame.origin.y + _label_username.frame.size.height,
                                                                    120,
                                                                    20)];
        _label_dateline.lineBreakMode = NSLineBreakByWordWrapping;
        _label_dateline.font = [UIFont systemFontOfSize:12.0f];
        _label_dateline.numberOfLines = 0;
        _label_dateline.textColor = [UIColor grayColor];
        _label_dateline.backgroundColor = [UIColor clearColor];
        _label_dateline.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_label_dateline];
        
        
        _tsLabel_delete =[[TSTouchLabel alloc]initWithFrame:CGRectMake(_label_dateline.frame.origin.x + _label_dateline.frame.size.width, _label_dateline.frame.origin.y+2, 26, 16)];
        _tsLabel_delete.text = @"屏蔽";
        _tsLabel_delete.touchType = @"touchNewsCommentDelete";
        _tsLabel_delete.userInteractionEnabled = YES;
        _tsLabel_delete.hidden = YES;
        _tsLabel_delete.font = [UIFont systemFontOfSize:12.0f];
        _tsLabel_delete.textColor =  [[UIColor alloc] initWithRed:54.0/255.0f green:182.0/255.0f blue:169.0/255.0f alpha:1.0];
        [self.contentView addSubview:_tsLabel_delete];
        
        // 复制 2015.09.14-------------------------------------------------------------------------------------------
        button_copy =[[TSTouchLabel alloc]initWithFrame:CGRectMake(_label_dateline.frame.origin.x + _label_dateline.frame.size.width, _label_dateline.frame.origin.y+2, 26, 16)];
        button_copy.text = @"复制";
        button_copy.touchType = @"touchDiscussAndNewsCommentCopy";
        button_copy.userInteractionEnabled = YES;
        button_copy.hidden = YES;
        button_copy.font = [UIFont systemFontOfSize:12.0f];
        button_copy.textColor = [[UIColor alloc] initWithRed:54.0/255.0f green:182.0/255.0f blue:169.0/255.0f alpha:1.0];
        [self.contentView addSubview:button_copy];        //-----------------------------------------------------------------------------------------------------------
        
        // 楼层图片
        _imgView_reply =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                     280,
                                                                     _label_username.frame.origin.y + 5,
                                                                     28,
                                                                     15)];
        _imgView_reply.image=[UIImage imageNamed:@"tlq_louceng.png"];
        _imgView_reply.contentMode = UIViewContentModeScaleToFill;
        _imgView_reply.hidden = YES;
        [self.contentView addSubview:_imgView_reply];
        
        // 楼层数
        label_leftNum = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                  _imgView_reply.frame.origin.x + 5,
                                                                  _imgView_reply.frame.origin.y,
                                                                  15,
                                                                  15)];
        label_leftNum.lineBreakMode = NSLineBreakByWordWrapping;
        label_leftNum.font = [UIFont systemFontOfSize:9.0f];
        label_leftNum.numberOfLines = 0;
        label_leftNum.textColor = [UIColor grayColor];
        label_leftNum.backgroundColor = [UIColor clearColor];
        label_leftNum.lineBreakMode = NSLineBreakByTruncatingTail;
        label_leftNum.textAlignment = NSTextAlignmentCenter;
        label_leftNum.hidden = YES;
        [self.contentView addSubview:label_leftNum];
        
        // 内容
        _label_message = [[UILabel alloc] initWithFrame:CGRectZero];
        _label_message.lineBreakMode = NSLineBreakByWordWrapping;
        _label_message.font = [UIFont systemFontOfSize:11.0f];
        _label_message.numberOfLines = 0;
        _label_message.opaque = NO; // 选中Opaque表示视图后面的任何内容都不应该绘制
        _label_message.textColor = [UIColor blackColor];
        _label_message.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label_message];
        
        // 最下方的线
        imgView_line =[[UIImageView alloc]initWithFrame:CGRectZero];
        imgView_line.image=[UIImage imageNamed:@"knowledge/tm.png"];
        [self.contentView addSubview:imgView_line];
        
        
        
        //        imgView_thumb =[[UIImageView alloc]initWithFrame:CGRectMake(
        //                                                                    40,
        //                                                                    10,
        //                                                                    40,
        //                                                                    40)];
        //        imgView_thumb.contentMode = UIViewContentModeScaleToFill;
        //        imgView_thumb.layer.masksToBounds = YES;
        //        imgView_thumb.layer.cornerRadius = 20.0f;
        //        [self.contentView addSubview:imgView_thumb];
        
        
        
        
        
        // 播放button
        playRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        playRecordButton.frame = CGRectMake(50,
                                            70,
                                            60,
                                            28);
        [playRecordButton setBackgroundImage:[UIImage imageNamed:@"amr/bg_ptt_receive_nore.png"]
                                    forState:UIControlStateNormal];
        [playRecordButton setBackgroundImage:[UIImage imageNamed:@"amr/bg_ptt_receive_nore.png"]
                                    forState:UIControlStateHighlighted];
        
        [playRecordButton addTarget:self action:@selector(play_btnclick:) forControlEvents:UIControlEventTouchDown];
        [playRecordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [playRecordButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        playRecordButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        [playRecordButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        
        if ([@"amr"  isEqual: _ext]) {
            playRecordButton.hidden = NO;
        } else {
            playRecordButton.hidden = YES;
        }
        
        [self.contentView addSubview:playRecordButton];
        
        // 播放按钮上得播放三角
        playImageView = [[UIImageView alloc]init];
        playImageView.frame = CGRectMake(playRecordButton.frame.origin.x + (playRecordButton.frame.size.width/2 - 10)/2 + playRecordButton.frame.size.width/2 - 5,
                                         playRecordButton.frame.origin.y + (playRecordButton.frame.size.height - 10)/2, 10, 10);
        playImageView.image = [UIImage imageNamed:@"amr/icon_media_play.png"];
        playImageView.hidden = YES;
        [self.contentView addSubview:playImageView];
        
        // 播放中的音量动画
        animationImageView = [[UIImageView alloc]init];
        animationImageView.frame = CGRectMake(playRecordButton.frame.origin.x + (playRecordButton.frame.size.width/2 - 10)/2 + playRecordButton.frame.size.width/2,
                                              playRecordButton.frame.origin.y + (playRecordButton.frame.size.height - 10)/2, 10, 10);
        //将序列帧数组赋给UIImageView的animationImages属性
        animationImageView.animationImages = [NSArray arrayWithObjects:
                                              [UIImage imageNamed:@"amr/icon_send_horn_bbs.png"],
                                              [UIImage imageNamed:@"amr/icon_send_horn01_bbs.png"],
                                              [UIImage imageNamed:@"amr/icon_send_horn02_bbs.png"],
                                              [UIImage imageNamed:@"amr/icon_send_horn03_bbs.png"],nil];
        //设置动画时间
        animationImageView.animationDuration = 0.75;
        //设置动画次数 0 表示无限
        animationImageView.animationRepeatCount = 0;
        [self.contentView addSubview:animationImageView];
        
        // 播放button
        imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        imageButton.frame = CGRectMake(50,
                                       80,
                                       90,
                                       90);
        
        imageButton.adjustsImageWhenHighlighted = NO;
        //        [imageButton setBackgroundImage:[UIImage imageNamed:@"amr/bg_ptt_receive_nore.png"]
        //                                    forState:UIControlStateNormal];
        //        [imageButton setBackgroundImage:[UIImage imageNamed:@"amr/bg_ptt_receive_nore.png"]
        //                                    forState:UIControlStateHighlighted];
        
        [imageButton addTarget:self action:@selector(imageClicked_btnclick:) forControlEvents:UIControlEventTouchDown];
        
        if ([@"png"  isEqual: _ext]) {
            imageButton.hidden = NO;
        } else {
            imageButton.hidden = YES;
        }
        
        [self.contentView addSubview:imageButton];
        
        // 左边竖线
        imgView_leftLine =[[UIImageView alloc]
                           initWithFrame:CGRectMake(15,
                                                    0,
                                                    1,
                                                    25)] ;
        imgView_leftLine.contentMode = UIViewContentModeScaleToFill;
        //[self.contentView addSubview:imgView_leftLine];
        
        // 左边中间小圆点
        imgView_leftlittilMiddlePoint =[[UIImageView alloc]
                                        initWithFrame:CGRectMake(15,
                                                                 15,
                                                                 1,
                                                                 25)] ;
        imgView_leftlittilMiddlePoint.contentMode = UIViewContentModeScaleToFill;
        //[self.contentView addSubview:imgView_leftlittilMiddlePoint];
        
        //        _view = [[UIView alloc] init];
        //        _view.tag = 201;
        //        [self.contentView addSubview:_view];
        //        [self bringSubviewToFront:_view];
        
        
    }
    return self;
}

- (IBAction)thumb_btnclick:(id)sender
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         uid, @"uid",
                         nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_fromDiscussDetailView2ProfileView" object:self userInfo:dic];
}

- (IBAction)play_btnclick:(id)sender
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         cellNum, @"cellNum", @"1", @"isPlayStatus",nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_playAudioInCell" object:self userInfo:dic];
    
    // temp
    //    if ([animationImageView isAnimating]) {
    //        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
    //                             cellNum, @"cellNum", @"2", @"isPlayStatus",nil];
    //
    //        [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_playAudioInCell" object:self userInfo:dic];
    //        [animationImageView stopAnimating];
    //        playImageView.hidden = NO;
    //        NSLog(@"2222");
    //
    //
    //    } else {
    //        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
    //                             cellNum, @"cellNum", @"1", @"isPlayStatus",nil];
    //
    //        [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_playAudioInCell" object:self userInfo:dic];
    //        [animationImageView startAnimating];
    //        playImageView.hidden = YES;
    //
    //        NSLog(@"1111");
    //
    //
    //    }
    
    //    NSString *amrDocPath = [Utilities getFilePath:PathType_AmrPath];
    //    if (nil != amrDocPath) {
    //        NSString *imagePathCell = [amrDocPath stringByAppendingPathComponent:cellNum];
    //
    //        NSData *fileData = [NSData dataWithContentsOfFile:imagePathCell];
    //
    //        GlobalSingletonRecordAudio* g_recordAudio = GlobalSingletonRecordAudio.sharedGlobalSingleton;
    //        g_recordAudio.delegate = self;
    //
    //        //NSLog(@"path %@",imagePathCell);
    //
    //        if(fileData.length>0){
    //            [g_recordAudio play:fileData];
    //        }
    //    }
}

- (IBAction)imageClicked_btnclick:(id)sender
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         cellNum, @"cellNum",nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_imageClickedInTCell" object:self userInfo:dic];
}

-(void)GlobalSingletonRecordStatus:(int)status
{
    // 播放状态cb
    // 0-播放中 1-播放完成 2-播放错误
    if (0 == status) {
        //        [playRecordButton setTitle:@"" forState:UIControlStateNormal];
        //        [playRecordButton setTitle:@"" forState:UIControlStateSelected];
        
        playImageView.hidden = YES;
        
        [animationImageView startAnimating];
    } else if (1 == status) {
        playImageView.hidden = NO;
        
        // temp
        if ([animationImageView isAnimating]) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 cellNum, @"cellNum", @"2", @"isPlayStatus",nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_playAudioInCell" object:self userInfo:dic];
            
            //            [animationImageView stopAnimating];
        } else {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 cellNum, @"cellNum", @"1", @"isPlayStatus",nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_playAudioInCell" object:self userInfo:dic];
            
            //            [animationImageView startAnimating];
        }
        
        //        [animationImageView stopAnimating];
    } else if (2 == status) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"播放失败，请重试"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setCellNum:(NSString *)n {
    if(![n isEqualToString:cellNum]) {
        cellNum = [n copy];
        rowNum = cellNum;
    }
}

// 2015.09.18
-(void)setMLLabelText:(NSString*)attributedStr{
    
    MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"/faceImages/expression/emotionImage.plist" bundleName:@"Expression"];//plistName bundleName 需要修改
    
    self.label.attributedText = [attributedStr expressionAttributedStringWithExpression:exp];
    
}
// 2015.09.18
+(CGSize)heightForEmojiText:(NSString*)emojiText
{
    MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"/faceImages/expression/emotionImage.plist" bundleName:@"Expression"];//plistName bundleName 需要修改
    
    NSAttributedString *expressionText = [emojiText expressionAttributedStringWithExpression:exp];
    
    MLLinkLabel *label = kProtypeLabel();
    label.attributedText = expressionText;
    
    CGSize size = [label preferredSizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width - 60.0];//update 2015.08.12
    
    return size;
}
// 2015.09.18
#pragma mark - height
static MLLinkLabel * kProtypeLabel() {
    
    static MLLinkLabel *_protypeLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _protypeLabel = [MLLinkLabel new];
        _protypeLabel.font = [UIFont systemFontOfSize:14.0f];
        _protypeLabel.numberOfLines = 0;
        _protypeLabel.textInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        
        
    });
    return _protypeLabel;
}

@end
