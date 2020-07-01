//
//  MomentsDetailViewController.m
//  MicroSchool
//
//  Created by jojo on 14/12/29.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "MomentsDetailViewController.h"
#import "WhoCanViewController.h"
#import "MomentsDetailDBDao.h"
#import "MomentsDetailObject.h"
#import "FullImageViewController.h"
#import "SetPersonalViewController.h"
#import "GrowthNotValidateViewController.h"
#import "PayViewController.h"
#import "SightPlayerViewController.h"

@interface MomentsDetailViewController ()

@end

@implementation MomentsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([_fromName isEqualToString:@"footmark"]) {
        [super setCustomizeTitle:@"成长足迹"];
        // 获取成长空间状态，确认是否可以添加到我的足迹
        [self doGetGrowingPathStatus];
    }else if ([_fromName isEqualToString:@"classPhoto"]){
        
        [super setCustomizeTitle:@"详情"];
        // 获取成长空间状态，确认是否可以添加到我的足迹
        [self doGetGrowingPathStatus];
        
    }else{
       [super setCustomizeTitle:@"动态详情"];
    }
    
    [super setCustomizeLeftButton];

    network = [NetworkUtility alloc];
    network.delegate = self;
 
    textParser1 = [[MarkupParser alloc] init];

    dataDic = [[NSMutableDictionary alloc] init];
    commentsArr = [[NSMutableArray alloc] init];

    startNum = @"0";
    endNum = @"10";
    
    reflashFlag = 1;
    isCommentComment = NO;
    _isFirstClickReply = false;

    NSString *emojiFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/faceImages/expression/emotionImage.plist"];
    _emojiDic = [[NSDictionary alloc] initWithContentsOfFile:emojiFilePath];
    
    //-----add by kate---------------------------------------------------
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doGetGrowingPathStatus)
                                                 name:@"refreshGrowPathStatus"
                                               object:nil];//add by kate 2016.03.22

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPrivilege:) name:@"refreshPrivilegeForDetail" object:nil];
    
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    NSString *cid = [user objectForKey:@"role_cid"];
    
    
    NSString *role_id = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
    NSString *role_checked = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_checked"]];
    
    [self showCustomKeyBoard];
    
    NSString *schoolType = [[NSUserDefaults standardUserDefaults]objectForKey:@"schoolType"];
    
    /*2015.10.29 教育局改版
     if ([schoolType isEqualToString:@"bureau"]) {
        toolBar.hidden = NO;
    }else*/
    
    /*2015.10.29 志伟确认 发表评论不区分有效身份
     {
        //有效身份才可以发表动态评论
        if([@"7"  isEqual: role_id]) {
            
            if ([@"2"  isEqual: role_checked]) {//没有获得教师身份
                
                toolBar.hidden = YES;
                
            }else if([@"0"  isEqual: role_checked]){//没有审核通过的教师
                
                toolBar.hidden = YES;
                
            }else{
                toolBar.hidden = NO;
            }
        }else if ([@"0"  isEqual: role_id] || [@"6" isEqual:role_id]){
            
            if([@"0"  isEqual: [NSString stringWithFormat:@"%@",cid]]){//未加入班级的学生
                
                toolBar.hidden = YES;
                
            }else{
                toolBar.hidden = NO;
            }
            
        }else{
            
            toolBar.hidden = NO;
            
        }
    }*/

    

    // 手势识别
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    singleTouch.delegate = self;
    [self.view addGestureRecognizer:singleTouch];
    
    //-------------------------------------------------------------------
    
    _textParser = [[MarkupParser alloc] init];
    cellHeightArray = [[NSMutableArray alloc] init];

    _ohAttributeLabel = [[TSAttributedLabel alloc] initWithFrame:CGRectZero];
    //测试代码
    //_ohAttributeLabel.backgroundColor = [UIColor yellowColor];
    _btn_thumb = [UIButton buttonWithType:UIButtonTypeCustom];
    _label_username = [[TSTouchLabel alloc] initWithFrame:CGRectZero];
    _label_dateline = [[UILabel alloc] initWithFrame:CGRectZero];
    _btn_more = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // header
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                         0,
                                                         WIDTH,
                                                        200)];
    //测试代码
    //headerView.backgroundColor = [UIColor greenColor];

    // 图片缩略图
    _tsTouchImg_img1 =[[TSTouchImageView alloc]initWithFrame:CGRectZero];
    _tsTouchImg_img1.contentMode = UIViewContentModeScaleAspectFill;
    _tsTouchImg_img1.clipsToBounds = YES;
    _tsTouchImg_img1.userInteractionEnabled = YES;
    TSTapGestureRecognizer *myTapGesture1 = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(img_btnclick:)];
    myTapGesture1.infoStr = @"0";
    _tsTouchImg_img1.layer.masksToBounds = YES;
    _tsTouchImg_img1.layer.cornerRadius = 5;
    [_tsTouchImg_img1 addGestureRecognizer:myTapGesture1];
    [headerView addSubview:_tsTouchImg_img1];
    
    // 分享链接
    _sharedLink =[[MomentsSharedLink alloc]initWithFrame:CGRectZero];
    _sharedLink.userInteractionEnabled = YES;
    _sharedLink.hidden = YES;
    TSTapGestureRecognizer *myTapGestureShardedLink = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(sharedLink_click:)];
    myTapGestureShardedLink.infoStr = @"99";
    [_sharedLink addGestureRecognizer:myTapGestureShardedLink];
    [headerView addSubview:_sharedLink];

    _tsTouchImg_img2 =[[TSTouchImageView alloc]initWithFrame:CGRectZero];
    _tsTouchImg_img2.contentMode = UIViewContentModeScaleAspectFill;
    _tsTouchImg_img2.clipsToBounds = YES;
    _tsTouchImg_img2.userInteractionEnabled = YES;
    _tsTouchImg_img2.layer.masksToBounds = YES;
    _tsTouchImg_img2.layer.cornerRadius = 5;
    TSTapGestureRecognizer *myTapGesture2 = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(img_btnclick:)];
    myTapGesture2.infoStr = @"1";
    [_tsTouchImg_img2 addGestureRecognizer:myTapGesture2];
    [headerView addSubview:_tsTouchImg_img2];
    
    _tsTouchImg_img3 =[[TSTouchImageView alloc]initWithFrame:CGRectZero];
    _tsTouchImg_img3.contentMode = UIViewContentModeScaleAspectFill;
    _tsTouchImg_img3.clipsToBounds = YES;
    _tsTouchImg_img3.userInteractionEnabled = YES;
    _tsTouchImg_img3.layer.masksToBounds = YES;
    _tsTouchImg_img3.layer.cornerRadius = 5;

    TSTapGestureRecognizer *myTapGesture3 = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(img_btnclick:)];
    myTapGesture3.infoStr = @"2";
    [_tsTouchImg_img3 addGestureRecognizer:myTapGesture3];
    [headerView addSubview:_tsTouchImg_img3];
    
    _tsTouchImg_img4 =[[TSTouchImageView alloc]initWithFrame:CGRectZero];
    _tsTouchImg_img4.contentMode = UIViewContentModeScaleAspectFill;
    _tsTouchImg_img4.clipsToBounds = YES;
    _tsTouchImg_img4.userInteractionEnabled = YES;
    _tsTouchImg_img4.layer.masksToBounds = YES;
    _tsTouchImg_img4.layer.cornerRadius = 5;

    TSTapGestureRecognizer *myTapGesture4 = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(img_btnclick:)];
    myTapGesture4.infoStr = @"3";
    [_tsTouchImg_img4 addGestureRecognizer:myTapGesture4];
    [headerView addSubview:_tsTouchImg_img4];
    
    _tsTouchImg_img5 =[[TSTouchImageView alloc]initWithFrame:CGRectZero];
    _tsTouchImg_img5.contentMode = UIViewContentModeScaleAspectFill;
    _tsTouchImg_img5.clipsToBounds = YES;
    _tsTouchImg_img5.userInteractionEnabled = YES;
    _tsTouchImg_img5.layer.masksToBounds = YES;
    _tsTouchImg_img5.layer.cornerRadius = 5;
    TSTapGestureRecognizer *myTapGesture5 = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(img_btnclick:)];
    myTapGesture5.infoStr = @"4";
    [_tsTouchImg_img5 addGestureRecognizer:myTapGesture5];
    [headerView addSubview:_tsTouchImg_img5];
    
    _tsTouchImg_img6 =[[TSTouchImageView alloc]initWithFrame:CGRectZero];
    _tsTouchImg_img6.contentMode = UIViewContentModeScaleAspectFill;
    _tsTouchImg_img6.clipsToBounds = YES;
    _tsTouchImg_img6.userInteractionEnabled = YES;
    _tsTouchImg_img6.layer.masksToBounds = YES;
    _tsTouchImg_img6.layer.cornerRadius = 5;
    TSTapGestureRecognizer *myTapGesture6 = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(img_btnclick:)];
    myTapGesture6.infoStr = @"5";
    [_tsTouchImg_img6 addGestureRecognizer:myTapGesture6];
    [headerView addSubview:_tsTouchImg_img6];
    
    _tsTouchImg_img7 =[[TSTouchImageView alloc]initWithFrame:CGRectZero];
    _tsTouchImg_img7.contentMode = UIViewContentModeScaleAspectFill;
    _tsTouchImg_img7.clipsToBounds = YES;
    _tsTouchImg_img7.userInteractionEnabled = YES;
    _tsTouchImg_img7.layer.masksToBounds = YES;
    _tsTouchImg_img7.layer.cornerRadius = 5;
    TSTapGestureRecognizer *myTapGesture7 = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(img_btnclick:)];
    myTapGesture7.infoStr = @"6";
    [_tsTouchImg_img7 addGestureRecognizer:myTapGesture7];
    [headerView addSubview:_tsTouchImg_img7];
    
    _tsTouchImg_img8 =[[TSTouchImageView alloc]initWithFrame:CGRectZero];
    _tsTouchImg_img8.contentMode = UIViewContentModeScaleAspectFill;
    _tsTouchImg_img8.clipsToBounds = YES;
    _tsTouchImg_img8.userInteractionEnabled = YES;
    _tsTouchImg_img8.layer.masksToBounds = YES;
    _tsTouchImg_img8.layer.cornerRadius = 5;
    TSTapGestureRecognizer *myTapGesture8 = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(img_btnclick:)];
    myTapGesture8.infoStr = @"7";
    [_tsTouchImg_img8 addGestureRecognizer:myTapGesture8];
    [headerView addSubview:_tsTouchImg_img8];
    
    _tsTouchImg_img9 =[[TSTouchImageView alloc]initWithFrame:CGRectZero];
    _tsTouchImg_img9.contentMode = UIViewContentModeScaleAspectFill;
    _tsTouchImg_img9.clipsToBounds = YES;
    _tsTouchImg_img9.userInteractionEnabled = YES;
    _tsTouchImg_img9.layer.masksToBounds = YES;
    _tsTouchImg_img9.layer.cornerRadius = 5;
    TSTapGestureRecognizer *myTapGesture9 = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(img_btnclick:)];
    myTapGesture9.infoStr = @"8";
    [_tsTouchImg_img9 addGestureRecognizer:myTapGesture9];
    [headerView addSubview:_tsTouchImg_img9];
    
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
    
//    [_btn_like setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [_btn_like setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//    _btn_like.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    
//    [_btn_like setBackgroundImage:[UIImage imageNamed:@"loading_gray.png"] forState:UIControlStateHighlighted] ;
    [_btn_like addTarget:self action:@selector(like_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    [headerView addSubview:_btn_like];
    
    // 赞前面的icon
    _btn_likeIcon =[[UIImageView alloc]initWithFrame:CGRectZero];
    _btn_likeIcon.contentMode = UIViewContentModeScaleToFill;
    [_btn_likeIcon setImage:[UIImage imageNamed:@"moments/icon_moments_z_d.png"]];
    [headerView addSubview:_btn_likeIcon];

    // 评论btn
    _btn_comment = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn_comment.frame = CGRectZero;
    
//    [_btn_comment setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [_btn_comment setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//    _btn_comment.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    
//    [_btn_comment setBackgroundImage:[UIImage imageNamed:@"loading_gray.png"] forState:UIControlStateHighlighted] ;
    [_btn_comment addTarget:self action:@selector(commentClick_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    [headerView addSubview:_btn_comment];
    
    // 评论前面的icon
    _btn_commentIcon =[[UIImageView alloc]initWithFrame:CGRectZero];
    _btn_commentIcon.contentMode = UIViewContentModeScaleToFill;
    [_btn_commentIcon setImage:[UIImage imageNamed:@"moments/icon_moments_pl.png"]];
    [headerView addSubview:_btn_commentIcon];

    if ([_fromName isEqualToString:@"classPhoto"] || [_fromName isEqualToString:@"footmark"]) {
        // 添加到我的足迹btn
        _btn_addToPath = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_addToPath.frame = CGRectZero;
        //_btn_addToPath.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //_btn_addToPath.contentEdgeInsets = UIEdgeInsetsMake(0,3, 0, 0);
        [_btn_addToPath setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_btn_addToPath setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        //[_btn_addToPath setTitle:@"添加至成长足迹" forState:UIControlStateNormal];
        //[_btn_addToPath setTitle:@"添加至成长足迹" forState:UIControlStateHighlighted];
        _btn_addToPath.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        
        [_btn_addToPath setBackgroundImage:[UIImage imageNamed:@"ClassKin/collection_normal.png"] forState:UIControlStateNormal];
       
        [_btn_addToPath addTarget:self action:@selector(addToPahtClick_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        [headerView addSubview:_btn_addToPath];// 2016.01.08 又不要了
        
        // 添加到我的足迹前面的icon
        _btn_pathIcon =[[UIImageView alloc]initWithFrame:CGRectZero];
        _btn_pathIcon.contentMode = UIViewContentModeScaleToFill;
        [_btn_pathIcon setImage:[UIImage imageNamed:@"moments/moments_addToPath.png"]];
        //[headerView addSubview:_btn_pathIcon];// 2016.01.08 又不要了
    }

    
    
    _bgGrayView = [[UIView alloc] init];
    _bgGrayView.layer.masksToBounds = YES;
    _bgGrayView.layer.cornerRadius = 5;
    [headerView addSubview:_bgGrayView];

    _lovesStrLabel = [[UILabel alloc] init];
    _lovesStrLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _lovesStrLabel.font = [UIFont systemFontOfSize:13.0f];
    _lovesStrLabel.numberOfLines = 0;
    _lovesStrLabel.textColor = [[UIColor alloc] initWithRed:54/255.0f green:182/255.0f blue:169/255.0f alpha:1.0];
    _lovesStrLabel.backgroundColor = [UIColor clearColor];
    _lovesStrLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [headerView addSubview:_lovesStrLabel];

    _lovesStrImageView =[[UIImageView alloc]initWithFrame:CGRectZero];
    _lovesStrImageView.contentMode = UIViewContentModeScaleToFill;
    [_lovesStrImageView setImage:[UIImage imageNamed:@"moments/momentsLikeIcon"]];
    _lovesStrImageView.hidden = YES;
    [headerView addSubview:_lovesStrImageView];

    
    
    // 喜欢的人
    _imgView_likeBg =[[UIImageView alloc]initWithFrame:CGRectZero];
    _imgView_likeBg.contentMode = UIViewContentModeScaleToFill;
    [_imgView_likeBg setImage:[UIImage imageNamed:@"tlq_history.png"]];
    _imgView_likeBg.userInteractionEnabled = NO;
    _imgView_likeBg.hidden = YES;
    [headerView addSubview:_imgView_likeBg];
    
    // 喜欢的人上面的5个头像
    _imgView_headImg1 =[[UIImageView alloc]initWithFrame:CGRectZero];
    _imgView_headImg1.contentMode = UIViewContentModeScaleToFill;
    _imgView_headImg1.layer.masksToBounds = YES;
    _imgView_headImg1.layer.cornerRadius = 35/2;
    _imgView_headImg1.userInteractionEnabled = NO;
    _imgView_headImg1.hidden = YES;
    [headerView addSubview:_imgView_headImg1];
    
    _imgView_headImg2 =[[UIImageView alloc]initWithFrame:CGRectZero];
    _imgView_headImg2.contentMode = UIViewContentModeScaleToFill;
    _imgView_headImg2.layer.masksToBounds = YES;
    _imgView_headImg2.layer.cornerRadius = 35/2;
    _imgView_headImg2.userInteractionEnabled = NO;
    _imgView_headImg2.hidden = YES;
    [headerView addSubview:_imgView_headImg2];
    
    _imgView_headImg3 =[[UIImageView alloc]initWithFrame:CGRectZero];
    _imgView_headImg3.contentMode = UIViewContentModeScaleToFill;
    _imgView_headImg3.layer.masksToBounds = YES;
    _imgView_headImg3.layer.cornerRadius = 35/2;
    _imgView_headImg3.userInteractionEnabled = NO;
    _imgView_headImg3.hidden = YES;
    [headerView addSubview:_imgView_headImg3];
    
    _imgView_headImg4 =[[UIImageView alloc]initWithFrame:CGRectZero];
    _imgView_headImg4.contentMode = UIViewContentModeScaleToFill;
    _imgView_headImg4.layer.masksToBounds = YES;
    _imgView_headImg4.layer.cornerRadius = 35/2;
    _imgView_headImg4.userInteractionEnabled = NO;
    _imgView_headImg4.hidden = YES;
    [headerView addSubview:_imgView_headImg4];
    
    _imgView_headImg5 =[[UIImageView alloc]initWithFrame:CGRectZero];
    _imgView_headImg5.contentMode = UIViewContentModeScaleToFill;
    _imgView_headImg5.layer.masksToBounds = YES;
    _imgView_headImg5.layer.cornerRadius = 35/2;
    _imgView_headImg5.userInteractionEnabled = NO;
    _imgView_headImg5.hidden = YES;
    [headerView addSubview:_imgView_headImg5];
    
    _label_likeCount = [[UILabel alloc] initWithFrame:CGRectZero];
    _label_likeCount.lineBreakMode = NSLineBreakByWordWrapping;
    _label_likeCount.font = [UIFont systemFontOfSize:13.0f];
    _label_likeCount.numberOfLines = 0;
    _label_likeCount.textColor = [UIColor blackColor];
    _label_likeCount.backgroundColor = [UIColor clearColor];
    _label_likeCount.lineBreakMode = NSLineBreakByTruncatingTail;
    _label_likeCount.userInteractionEnabled = NO;
    _label_likeCount.hidden = YES;
    [headerView addSubview:_label_likeCount];
    
    _btn_likeNum = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn_likeNum.frame = CGRectZero;
    [_btn_likeNum addTarget:self action:@selector(gotoLikerList:) forControlEvents:UIControlEventTouchUpInside];
    _btn_likeNum.contentMode = UIViewContentModeScaleToFill;
    _btn_likeNum.hidden = YES;
    [headerView addSubview:_btn_likeNum];

    _tsLabel_delete =[[TSTouchLabel alloc]initWithFrame:CGRectMake(_label_dateline.frame.origin.x + _label_dateline.frame.size.width, _label_dateline.frame.origin.y+2, 26, 16)];
    _tsLabel_delete.text = @"删除";
    _tsLabel_delete.touchType = @"touchMomentsListDelete";
    _tsLabel_delete.userInteractionEnabled = YES;
    _tsLabel_delete.hidden = YES;
    _tsLabel_delete.font = [UIFont systemFontOfSize:12.0f];
    _tsLabel_delete.textColor = [UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1];
    [headerView addSubview:_tsLabel_delete];


    imageView = [[UIImageView alloc]init];
    imageView.backgroundColor = [UIColor clearColor];
    if(IS_IPHONE_5){
        imageView.image = [UIImage imageNamed:@"placeholderImage_large.png"];
    }else{
        imageView.image = [UIImage imageNamed:@"placeholderImage_small.png"];
    }
    
    DB_Dic = [[NSDictionary alloc] init];// 2015.05.15
    
}

-(void)doGetGrowingPathStatus
{
    /**
     * 成长空间模块状态，学校是否有成长空间，班级是否有血迹，个人是否缴费
     * @author luke
     * @date 2015.12.29
     * @args
     *   v=3, ac=GrowingPath, op=module, sid=, cid=, uid=
     */
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"GrowingPath",@"ac",
                          @"3",@"v",
                          @"module", @"op",
                          _cid, @"cid",
                          nil];
    
    //[Utilities showProcessingHud:self.view];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            NSDictionary *dic = [respDic objectForKey:@"message"];
            _growingPathStatusSchool = [NSString stringWithFormat:@"%@", [dic objectForKey:@"school"]];
            _growingPathStatusSpace = [NSString stringWithFormat:@"%@", [dic objectForKey:@"space"]];//空间状态
            _growingPathStatusNumber = [NSString stringWithFormat:@"%@", [dic objectForKey:@"number"]];//班级有学籍 本人是否绑定了学籍
            _growingPathStatusClass = [NSString stringWithFormat:@"%@", [dic objectForKey:@"classes"]];//班级是否有学籍
            NSString *usertype = [NSString stringWithFormat:@"%@",[[g_userInfo getUserDetailInfo] objectForKey:@"role_id"]];

            if (([@"0"  isEqual: usertype]) || ([@"6"  isEqual: usertype])){
                
                if ([@"0"  isEqual: _growingPathStatusClass]) {
                    _btn_addToPath.hidden = YES;
                }else{
                    _btn_addToPath.hidden = NO;
                }
                
            }else{
                
                _btn_addToPath.hidden = YES;

            }
            
            _growingPathStatusUrl = [NSString stringWithFormat:@"%@", [dic objectForKey:@"url"]];//点我了解什么是成长空间
            _trial = [NSString stringWithFormat:@"%@", [dic objectForKey:@"trial"]];//

        } else {
            _growingPathStatusSchool = nil;
            _growingPathStatusSpace = nil;
            _growingPathStatusNumber = nil;
            _growingPathStatusClass = nil;
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        NSLog(@"22");
    }];
}

- (void)doAddToPath
{
    /**
     * 学生家长将XX加入我的足迹
     * @author luke
     * @date 2015.12.20
     * @args
     *   v=3, ac=GrowingPath, op=import, sid=, cid=, uid=, number=,
     *   circle=动态ID
     */
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"GrowingPath",@"ac",
                          @"3",@"v",
                          @"import", @"op",
                          //                          _cid, @"cid",
                          _tid, @"circle",
                          nil];
    
    [Utilities showProcessingHud:self.view];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            [Utilities showTextHud:[respDic objectForKey:@"message"] descView:self.view];
            
            // 已经添加到我的足迹
//            [_btn_pathIcon setImage:[UIImage imageNamed:@"moments/moments_addToPathAdded.png"]];
            
//            [_btn_addToPath setTitle:@"已添加" forState:UIControlStateNormal];
//            [_btn_addToPath setTitle:@"已添加" forState:UIControlStateHighlighted];
//            
//            [_btn_addToPath setTitleColor:[[UIColor alloc] initWithRed:27/255.0f green:128/255.0f blue:209/255.0f alpha:1.0] forState:UIControlStateNormal];
//            [_btn_addToPath setTitleColor:[[UIColor alloc] initWithRed:27/255.0f green:128/255.0f blue:209/255.0f alpha:1.0] forState:UIControlStateHighlighted];
            
            NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]initWithDictionary:[dataDic objectForKey:@"growpath"]];
            [tempDic setObject:@"1" forKey:@"save"];
            [dataDic setObject:tempDic forKey:@"growpath"];
            [_btn_addToPath setBackgroundImage:[UIImage imageNamed:@"ClassKin/collection_press.png"] forState:UIControlStateNormal];
            
            //_btn_addToPath.userInteractionEnabled = NO;
            
        } else {
            [Utilities showTextHud:[respDic objectForKey:@"message"] descView:self.view];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
}

- (IBAction)addToPahtClick_btnclick:(id)sender
{
    if ([[dataDic objectForKey:@"growpath"] objectForKey:@"save"]) {
        
         NSString *save = [NSString stringWithFormat:@"%@",[[dataDic objectForKey:@"growpath"] objectForKey:@"save"]];
        
        if ([save integerValue] == 1) {
            /**
             * 移除成长足迹中导入的记录
             * @author luke
             * @date 2015.12.30
             * @args
             *  v=3, ac=GrowingPath, op=cancel, sid=, cid=, uid=, path=成长足迹ID
             */
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"GrowingPath",@"ac",
                                  @"3",@"v",
                                  @"cancel", @"op",
                                  _cid,@"cid",
                                  [[dataDic objectForKey:@"growpath"] objectForKey:@"id"],@"path",
                                  nil];
            
            
            [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
                
                [Utilities dismissProcessingHud:self.view];
                NSDictionary *respDic = (NSDictionary*)responseObject;
                NSString *result = [respDic objectForKey:@"result"];
                
                if ([result integerValue] == 1) {
                    
                    NSLog(@"移除足迹:%@",respDic);
                    if ([@"classPhoto" isEqualToString:_fromName]) {
                        
                        if (_path) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadFootmarkList" object:nil];
                        }
                        
                    }else if ([@"footmark" isEqualToString:_fromName]){
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadFootmarkList" object:nil];
                    }
//                    else{
//                        //reLoadClassNewPhoto
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadClassNewPhoto" object:nil];
//
//                    }
                    
                    //[self.navigationController popViewControllerAnimated:YES];
                     NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]initWithDictionary:[dataDic objectForKey:@"growpath"]];
                    [tempDic setObject:@"0" forKey:@"save"];
                     [dataDic setObject:tempDic forKey:@"growpath"];
                     [_btn_addToPath setBackgroundImage:[UIImage imageNamed:@"ClassKin/collection_normal.png"] forState:UIControlStateNormal];
                    [Utilities showTextHud:[respDic objectForKey:@"message"] descView:self.view];
                    
                }else{
                    
                    NSString *msg = (NSString*)[respDic objectForKey:@"message"];
                    [Utilities showAlert:@"错误" message:msg cancelButtonTitle:@"确定" otherButtonTitle:nil];
                    
                }
                
                
            } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                
                [Utilities dismissProcessingHud:self.view];
                [Utilities doHandleTSNetworkingErr:error descView:self.view];
                
            }];
            
        }else{
            
            if (nil != _growingPathStatusSchool) {
                //        if ([@"1"  isEqual: _growingPathStatusSchool]) {
                //            [self doAddToPath];
                //        }else {
                // 提示需要去绑定页面
                if ([@"0"  isEqual: _growingPathStatusNumber]){
                    // 学生并没有绑定成长空间，点击添加至个人成长弹出弹窗提示“绑定身份信息后方可添加至成长足迹”
                    TSAlertView *alert = [[TSAlertView alloc] initWithTitle:@"提示" message:@"绑定身份信息后方可添加至成长足迹"];
                    
                    [alert addBtnTitle:@"取消" action:^{
                        // nothing to do
                    }];
                    [alert addBtnTitle:@"绑定" action:^{
                        NSDictionary *user = [g_userInfo getUserDetailInfo];
                        NSString* usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
                        // 现在接口 0 学生 6 家长 7 老师 9 校园管理员
                        NSString *iden;
                        
                        switch ([usertype integerValue]) {
                            case 0:
                                iden = @"student";
                                break;
                            case 6:
                                iden = @"parent";
                                break;
                            case 7:
                                iden = @"teacher";
                                break;
                            case 9:
                                iden = @"admin";
                                break;
                                
                            default:
                                break;
                        }
                        
                        SetPersonalViewController *setPVC = [[SetPersonalViewController alloc] init];
                        setPVC.viewType = @"growthSpace";
                        setPVC.publish = 1;
                        setPVC.cId = _cid;
                        setPVC.iden = iden;
                        setPVC.growingPathStatusUrl = _growingPathStatusUrl;
                        [self.navigationController pushViewController:setPVC animated:YES];
                    }];
                    
                    [alert showAlertWithSender:self];
                }else{
                    // 学生绑定了成长空间
                    // 开通空间0:未开通,1付费已开通,2试用已开通，3试用到期，4付费到期
                    if ([@"0"  isEqual: _growingPathStatusSpace]) {
                        // 未开通
                        TSAlertView *alert = [[TSAlertView alloc] initWithTitle:@"提示" message:@"成长空间处于有效期内方可将动态添加至成长足迹。"];
                        
                        [alert addBtnTitle:@"取消" action:^{
                            // nothing to do
                            
                        }];
                        [alert addBtnTitle:@"去开通" action:^{
                            
                            if ([_growingPathStatusSpace integerValue] == 0 && [_trial integerValue] == 0) {//2015.12.21 不需要试用期直接到支付页
                                
                                PayViewController *pvc = [[PayViewController alloc] init];
                                pvc.fromName = @"publish";
                                pvc.cId = _cid;
                                pvc.spaceStatus = _growingPathStatusSpace;
                                pvc.isTrial = _trial;
                                [self.navigationController pushViewController:pvc animated:YES];
                                
                            }else{
                                
                                GrowthNotValidateViewController *growVC = [[GrowthNotValidateViewController alloc] init];
                                growVC.fromName = @"publish";
                                growVC.cId = _cid;
                                growVC.urlStr = _growingPathStatusUrl;
                                growVC.spaceStatus = _growingPathStatusSpace;
                                growVC.isBind = _growingPathStatusNumber;
                                //growVC.isTrial = trial;
                                [self.navigationController pushViewController:growVC animated:YES];
                            }
                        }];
                        
                        [alert showAlertWithSender:self];
                        
                    }else if (([@"3"  isEqual: _growingPathStatusSpace]) || ([@"4"  isEqual: _growingPathStatusSpace])) {
                        // 到期欠费了
                        TSAlertView *alert = [[TSAlertView alloc] initWithTitle:@"提示" message:@"成长空间处于有效期内方可将动态添加至成长足迹。"];
                        
                        [alert addBtnTitle:@"取消" action:^{
                            // nothing to do
                        }];
                        [alert addBtnTitle:@"立即续费" action:^{
                            
                            PayViewController *pvc = [[PayViewController alloc] init];
                            pvc.fromName = @"publish";
                            pvc.cId = _cid;
                            [self.navigationController pushViewController:pvc animated:YES];
                            
                        }];
                        
                        [alert showAlertWithSender:self];
                        
                    }else{
                        
                        [self doAddToPath];
                    }
                }
                
                //}
            }else {
                // 重新获取开通成长空间状态
                [self doGetGrowingPathStatus];
                
                // 延迟0.2秒后去设置
                [self performSelector:@selector(doAddToPath) withObject:nil afterDelay:0.2];
            }
        }
        
    }
  

}

- (IBAction)sharedLink_click:(id)sender
{
//    TSTapGestureRecognizer *tsTap = (TSTapGestureRecognizer *)sender;
//    
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                         tsTap.infoStr, @"tag",
//                         _cellNum, @"cellNum",
//                         nil];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_MOMENTS_CLICKSHAREDLINK object:self userInfo:dic];
    
    NSString *shareUrl = [dataDic objectForKey:@"shareUrl"];
    NSString *shareSnapshot = [dataDic objectForKey:@"shareSnapshot"];
    NSString *shareContent = [dataDic objectForKey:@"shareContent"];
#if 0
    SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
    fileViewer.requestURL = shareUrl;
    fileViewer.fromName = @"moments";
    fileViewer.currentHeadImgUrl = shareSnapshot;
    fileViewer.titleName = shareContent;
#endif
    
    // 2015.09.23
    SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
    fileViewer.webType = SWLoadRequest;
    fileViewer.requestURL = shareUrl;
    //fileViewer.fromName = @"moments";
    fileViewer.currentHeadImgUrl = shareSnapshot;
    fileViewer.titleName = shareContent;

    [self.navigationController pushViewController:fileViewer animated:YES];
}

-(void)commentClick_btnclick:(NSNotification *)notification
{
    
    if (toolBar.hidden == NO) {
        _replyTo = @"";
//        _replyTo = [NSString stringWithFormat:@"回复%@: ", [dataDic objectForKey:@"name"]];
        _isFirstClickReply = true;
        
        _replyToLabel.text = _replyTo;
        [_replyToLabel setHidden:NO];
        
        self->textView.text = @"";
        isCommentComment = NO;
        
        [textView becomeFirstResponder];
    }
    
}

- (IBAction)img_btnclick:(id)sender
{
    [textView resignFirstResponder];
    
    TSTapGestureRecognizer *tsTap = (TSTapGestureRecognizer *)sender;
    
    NSArray *picAry = [dataDic objectForKey:@"pics"];
#if 0
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    // 弹出相册时显示的第一张图片是点击的图片
    browser.currentPhotoIndex = [tsTap.infoStr integerValue];
    // 设置所有的图片。photos是一个包含所有图片的数组。
    
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[picAry count]];
    
    for (int i = 0; i<[picAry count]; i++) {
        // 拼字符串，去服务器获取原图
        NSString *pic_url = [NSString stringWithFormat:REQ_PIC_URL, @"WIFI", [[[dataDic objectForKey:@"pics"] objectAtIndex:i] objectForKey:@"pid"]];
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.save = NO;
        photo.url = [NSURL URLWithString:pic_url]; // 图片路径
        photo.srcImageView = imageView; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    browser.photos = photos;
    [browser show];
#endif
    
    NSString *type = [NSString stringWithFormat:@"%@",[[picAry objectAtIndex:0] objectForKey:@"type"]];
    NSString *picStr = [NSString stringWithFormat:@"%@",[[picAry objectAtIndex:0] objectForKey:@"pic"]];
    
    if (([picAry count] == 1) && ([type integerValue] == 1)) {
        
        SightPlayerViewController *vc = [[SightPlayerViewController alloc]init];
        vc.videoURL = [NSURL URLWithString:picStr];
        [self presentViewController:vc animated:YES completion:nil];
        
    }else{
        
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[picAry count]];
        for (int i = 0; i<[picAry count]; i++) {
            // 拼字符串，去服务器获取原图
            NSString *pic_url = [NSString stringWithFormat:REQ_PIC_URL, @"WIFI", [[[dataDic objectForKey:@"pics"] objectAtIndex:i] objectForKey:@"pid"]];
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.save = NO;
            photo.url = [NSURL URLWithString:pic_url]; // 图片路径
            photo.srcImageView = imageView; // 来源于哪个UIImageView
            [photos addObject:pic_url];
        }
        
        
        FullImageViewController *fullImgV = [[FullImageViewController alloc] init];
        fullImgV.delOrSave = 1;
        fullImgV.assetsArray = photos;
        fullImgV.currentIndex = [tsTap.infoStr integerValue];
        [self.navigationController pushViewController:fullImgV animated:YES];
        
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender
{
    // 取消所有的网络请求
    [network cancelCurrentRequest];
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 设置权限后刷新动态页的权限参数
-(void)refreshPrivilege:(NSNotification*)notify{
    
    NSString *privilege = (NSString*)[notify object];
    [dataDic setObject:privilege forKey:@"privilege"];
    
    NSMutableDictionary *dic  = (NSMutableDictionary*)[notify userInfo];
    NSMutableArray *array = [dic objectForKey:@"chooseClassList"];
    
    if(array!=nil){
        NSMutableArray *classList = [[NSMutableArray alloc]init];
        
        NSString *cids = @"";
        
        for(int i =0;i<[array count];i++){
            
            NSString *cName = [[array objectAtIndex:i] objectForKey:@"cName"];
            NSString *cid = [[array objectAtIndex:i] objectForKey:@"cid"];
            NSString *isChecked = [[array objectAtIndex:i]objectForKey:@"isChecked"];
            
            if([isChecked intValue] == 1){
                
                dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:cid,@"cid",cName,@"name",nil];
                [classList addObject:dic];
                
                if([cid intValue] == 0){
                    cids = cid;
                }else{
                    cids = [NSString stringWithFormat:@",%@",cid];
                }
                
            }
            
        }
        
        [dataDic setObject:classList forKey:@"classes"];
        [dataDic setObject:cids forKey:@"cids"];
    }
    
}

-(void)selectRightAction:(id)sender{
    
    if (!isRightButtonClicked) {
        viewMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height)];
        //UIView * mask = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        //mask.backgroundColor =[UIColor clearColor];
        //mask.opaque = NO;
        
        imageView_bgMask =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height-44)];
        [imageView_bgMask setBackgroundColor:[[UIColor alloc] initWithRed:93/255.0f green:106/255.0f blue:122/255.0f alpha:0.4]];
        imageView_bgMask.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissRightMenu:)];
        [imageView_bgMask addGestureRecognizer:singleTouch];
        
        //NSLog(@"%hhd",_isAdmin);
        
        {
            
            // 选项菜单
            imageView_rightMenu =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                              [UIScreen mainScreen].applicationFrame.size.width - 128 - 10,
                                                                              5,
                                                                              128,
                                                                              45)];
            imageView_rightMenu.contentMode = UIViewContentModeScaleToFill;
            [imageView_rightMenu setImage:[UIImage imageNamed:@"ClassKin/bg_contacts_one.png"]];
        }
        
        UIImage *buttonImg_d;
        UIImage *buttonImg_p;
        //以后菜单选项会增加
       /* // 搜索button
        button_search = [UIButton buttonWithType:UIButtonTypeCustom];
        button_search.frame = CGRectMake(
                                         imageView_rightMenu.frame.origin.x,
                                         imageView_rightMenu.frame.origin.y + 18,
                                         108,
                                         32);
        
        //CGSize tagSize = CGSizeMake(20, 20);
        
        buttonImg_d = [UIImage imageNamed:@"icon_bjzl_d.png"];
        buttonImg_p = [UIImage imageNamed:@"icon_bjzl_p.png"];
        
        [button_search setImage:buttonImg_d forState:UIControlStateNormal];
        [button_search setImage:buttonImg_p forState:UIControlStateHighlighted];
        
        [button_search setTitle:@"编辑资料" forState:UIControlStateNormal];
        [button_search setTitle:@"编辑资料" forState:UIControlStateHighlighted];
        
        button_search.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button_search setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 0, 0)];
        [button_search setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button_search setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        button_search.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        
        [button_search addTarget:self action:@selector(gotoEdit) forControlEvents: UIControlEventTouchUpInside];
        
        // 管理成员button
        button_multiSend = [UIButton buttonWithType:UIButtonTypeCustom];
        button_multiSend.frame = CGRectMake(
                                            button_search.frame.origin.x,
                                            button_search.frame.origin.y + button_search.frame.size.height,
                                            108,
                                            32);
        
        buttonImg_d = [UIImage imageNamed:@"icon_glcy_d.png"];
        buttonImg_p = [UIImage imageNamed:@"icon_glcy_p.png"];
        
        [button_multiSend setImage:buttonImg_d forState:UIControlStateNormal];
        [button_multiSend setImage:buttonImg_p forState:UIControlStateHighlighted];
        
        [button_multiSend setTitle:@"管理成员" forState:UIControlStateNormal];
        [button_multiSend setTitle:@"管理成员" forState:UIControlStateHighlighted];
        
        button_multiSend.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button_multiSend setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 0, 0)];
        [button_multiSend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button_multiSend setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        button_multiSend.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        
        [button_multiSend addTarget:self action:@selector(gotoMemberList) forControlEvents: UIControlEventTouchUpInside];
        
        // 管理员设置button
        button_setAdmin = [UIButton buttonWithType:UIButtonTypeCustom];
        button_setAdmin.frame = CGRectMake(
                                           button_multiSend.frame.origin.x,
                                           button_multiSend.frame.origin.y + button_multiSend.frame.size.height,
                                           120,
                                           32);
        
        buttonImg_d = [UIImage imageNamed:@"icon_szgly_d.png"];
        buttonImg_p = [UIImage imageNamed:@"icon_szgly_p.png"];
        
        [button_setAdmin setImage:buttonImg_d forState:UIControlStateNormal];
        [button_setAdmin setImage:buttonImg_p forState:UIControlStateHighlighted];
        
        [button_setAdmin setTitle:@"管理员设置" forState:UIControlStateNormal];
        [button_setAdmin setTitle:@"管理员设置" forState:UIControlStateHighlighted];
        
        button_setAdmin.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button_setAdmin setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 0, 0)];
        [button_setAdmin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button_setAdmin setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        button_setAdmin.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        
        [button_setAdmin addTarget:self action:@selector(gotoSetAdminMemberList) forControlEvents: UIControlEventTouchUpInside];*/
        
        // 添加朋友button
        button_addFriend = [UIButton buttonWithType:UIButtonTypeCustom];
   {
            
            button_addFriend.frame = CGRectMake(
                                                imageView_rightMenu.frame.origin.x,
                                                imageView_rightMenu.frame.origin.y + 10,
                                                108,
                                                32);
        }
        
//        buttonImg_d = [UIImage imageNamed:@"icon_tcbj_d.png"];
//        buttonImg_p = [UIImage imageNamed:@"icon_tcbj_p.png"];
        buttonImg_d = [UIImage imageNamed:@"icon_bjzl_d.png"];
        //buttonImg_p = [UIImage imageNamed:@"icon_bjzl_p.png"];
        buttonImg_p = [UIImage imageNamed:@"icon_bjzl_d.png"];
        
        [button_addFriend setImage:buttonImg_d forState:UIControlStateNormal];
        [button_addFriend setImage:buttonImg_p forState:UIControlStateHighlighted];
        
        [button_addFriend setTitle:@"设置权限" forState:UIControlStateNormal];
        [button_addFriend setTitle:@"设置权限" forState:UIControlStateHighlighted];
        
        button_addFriend.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button_addFriend setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 0, 0)];
        [button_addFriend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button_addFriend setTitleColor:[UIColor colorWithRed:174.0/255.0 green:221.0/255.0 blue:215.0/255.0 alpha:1] forState:UIControlStateHighlighted];
        button_addFriend.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        
        [button_addFriend addTarget:self action:@selector(setViewType:) forControlEvents: UIControlEventTouchUpInside];
        
        [imageView_bgMask addSubview:imageView_rightMenu];
        
       {
            
            [imageView_bgMask addSubview:button_addFriend];
        }
        
        [viewMask addSubview:imageView_bgMask];
        
        [self.view addSubview:viewMask];
        
        isRightButtonClicked = true;
    } else {
        
        [viewMask removeFromSuperview];
        
        isRightButtonClicked = false;
        
    }
}

// 对此条动态详情进行查看权限设置
-(void)setViewType:(id)sender{
    
    WhoCanViewController *wcc = [[WhoCanViewController alloc]init];
    wcc.fromName = @"setMyM";
    wcc.privilegeFromMyMoment = [Utilities getType:[dataDic objectForKey:@"privilege"]];//权限
    wcc.fmid = [dataDic objectForKey:@"id"];//动态id
    wcc.classList = [dataDic objectForKey:@"classes"];
    wcc.cidsFromDetail = [dataDic objectForKey:@"cids"];
    [self.navigationController pushViewController:wcc animated:YES];
    
    
}

-(void)dismissRightMenu:(id)sender{
    
    [viewMask removeFromSuperview];
    isRightButtonClicked = false;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showName1:) name:@"Weixiao_momentsClickName1" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickRemoveComment:) name:@"Weixiao_momentsClickRemoveComment" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickRemovePost:) name:@"Weixiao_momentsClickRemovePost" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickBlock:) name:NOTIFICATION_UI_MOMENTS_CLICKBLOCK object:nil];


}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self dismissRightMenu:nil];

    [textView resignFirstResponder];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Weixiao_momentsClickName1" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Weixiao_momentsClickRemoveComment" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Weixiao_momentsClickRemovePost" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_UI_MOMENTS_CLICKBLOCK object:nil];

}

-(void)clickBlock:(NSNotification *)notification
{
    NSLog(@"clickBlock");
    NSDictionary *dic = [notification userInfo];
    _deleteTid = [dic objectForKey:@"tid"];
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:@"屏蔽这条动态？"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"屏蔽",nil];
    alert.tag = 276;
    [alert show];
}

-(void)clickRemovePost:(NSNotification *)notification
{
    NSLog(@"clickRemovePost");
    NSDictionary *dic = [notification userInfo];
    _deleteTid = [dic objectForKey:@"tid"];
    
    NSString *msg = @"删除这条动态？";
    NSString *btnMsg = @"删除";
    
    if ([_fromName isEqualToString:@"footmark"]) {
        
        if ([_tsLabel_delete.touchType isEqualToString:@"touchMomentsListRemove"]) {
            msg = @"移除这条足迹？";
            btnMsg = @"移除";
        }
    }else if ([_fromName isEqualToString:@"classPhoto"]){
        
        msg = @"确定删除?";
        btnMsg = @"删除";
    }
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:msg
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:btnMsg,nil];
    alert.tag = 275;
    [alert show];
}

-(void)clickRemoveComment:(NSNotification *)notification
{
    NSLog(@"clickRemovePost");
    NSDictionary *dic = [notification userInfo];
    _deletePid = [dic objectForKey:@"pid"];
    NSString *tUid = [dic objectForKey:@"uid"];
    _deletePidPos = [dic objectForKey:@"msgPos"];
    _deleteCellNum = [dic objectForKey:@"cellNum"];
    _deleteTid = [dic objectForKey:@"tid"];

    NSString *uid = [[g_userInfo getUserDetailInfo]  objectForKey:@"uid"];
    
    if ([tUid isEqual: uid]) {
        // 如果是自己发的，提示是否删除
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"删除这条评论？"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"删除",nil];
        alert.tag = 274;
        [alert show];
    }else {
        // 如果是别人发的，评论别人的评论
        [textView becomeFirstResponder];
        
        NSDictionary *dic = [[[dataDic objectForKey:@"comments"] objectForKey:@"list"] objectAtIndex:_deletePidPos.integerValue];
        
//        textView.text = [NSString stringWithFormat:@"回复%@:", [dic objectForKey:@"name"]];
//        _isFirstClickReply = true;

        textView.text = @"";
        
        _replyTo = [NSString stringWithFormat:@"回复%@: ", [dic objectForKey:@"name"]];
        _isFirstClickReply = true;
        
        _replyToLabel.text = _replyTo;
        [_replyToLabel setHidden:NO];

        isCommentComment = YES;
    }
}

// 去赞的人列表
-(void)gotoLikerList:(NSNotification*)notify
{
    LikerListViewController *likeList = [[LikerListViewController alloc]init];
    likeList.tid = _tid;
    [self.navigationController pushViewController:likeList animated:YES];
}

-(void)showName1:(NSNotification *)notification
{
    NSLog(@"showDetail");
    NSDictionary *dic = [notification userInfo];
    
    FriendProfileViewController *fpvc = [[FriendProfileViewController alloc]init];
    fpvc.fuid = [dic objectForKey:@"uid"];
    [self.navigationController pushViewController:fpvc animated:YES];
}

-(void)like_btnclick:(NSNotification *)notification
{
    NSUInteger loved = [[dataDic objectForKey:@"loved"] integerValue];
    
    NSString *op = @"love";
    
    if (loved) {
        op = @"hate";
    }
    
    if ([@"classPhoto" isEqualToString:_fromName]) {
        
        NSString *op = @"loveClassTopic";
        
        if (loved) {
            op = @"hateClassTopic";
        }
        
        /**
         * 班级相册图片点赞
         * @author luke
         * @date 2016.03.17
         * @args
         *  v=3 ac=Kindergarten op=loveClassTopic sid= cid= uid= tid=主题ID
         */
        /**
         * 班级相册图片点赞取消
         * @author luke
         * @date 2016.03.17
         * @args
         *  v=3 ac=Kindergarten op=hateClassTopic sid= cid= uid= tid=主题ID
         */
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                              @"Kindergarten",@"ac",
                              @"3",@"v",
                              op, @"op",
                              _tid,@"tid",
                              _cid,@"cid",
                              nil];
        
        [network sendHttpReq:HttpReq_ClassNewPhotoLike andData:data];
        
    }else{
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                              @"Circle",@"ac",
                              @"2",@"v",
                              op, @"op",
                              _tid,@"tid",
                              nil];
        
       [network sendHttpReq:HttpReq_MomentsLike andData:data];
        
    }
    
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    
    [self performSelector:@selector(createHeaderView) withObject:nil afterDelay:0.1];
    //    [self createHeaderView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44 - 44) style:UITableViewStylePlain];// update frame by kate
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // 隐藏tableview分割线
    [self->_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view addSubview:_tableView];
}

//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝=
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view
-(void)createHeaderView
{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    [self->_tableView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
    
    // 因为在viewwillappare里面调用了 所以这里不调用
    // 发出两次请求会有问题
    
  
    //----离线缓存2015.05.15--------------------------
    BOOL isConnect = [Utilities connectedToNetwork];
    page = 0;
    if (isConnect) {
        [Utilities showProcessingHud:self.view];// 2015.05.12
        
        //最新相册列表进入 2016.03.19
        if ([@"classPhoto" isEqualToString:_fromName]) {
            
            /**
             * 班级相册图片详情
             *
             * @author luke
             * @date 2016.03.14
             * @args
             *  v=3 ac=Kindergarten op=classTopic sid= cid= uid= tid=主题ID app= page= size=
             */
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Kindergarten",@"ac",
                                  @"classTopic", @"op",
                                  @"3",@"v",
                                  _tid,@"tid",
                                  nil];
            [network sendHttpReq:HttpReq_ClassNewPhotoDetail andData:data];
            
        }else{
           
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Circle",@"ac",
                                  @"view", @"op",
                                  @"3",@"v",
                                  _tid,@"tid",
                                  nil];
            
            [network sendHttpReq:HttpReq_MomentsDetail andData:data];
            
        }
        
    }else{// DB操作
        
        [self getDataFromDB:@"1"];//不区分是校园动态详情or我的动态详情
    }
    //-----------------------------------------------
    
    
    
   
}

-(void)testFinishedLoadData{
    
    [self finishReloadingData];
//    [self setFooterView];
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
    
    //  model should call this when its done loading
    _reloading = NO;
    
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_tableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_tableView];
//        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
    // if the footerView is nil, then create it, reset the position of the footer
    
    CGFloat height = MAX(self->_tableView.bounds.size.height, self->_tableView.contentSize.height);
    if (_refreshFooterView && [_refreshFooterView superview])
    {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self->_tableView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
    {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.view.frame.size.width, self->_tableView.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self->_tableView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView)
    {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

-(void)removeFooterView
{
    if (_refreshFooterView && [_refreshFooterView superview])
    {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
    
    //  should be calling your tableviews data source model to reload
    _reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader)
    {
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.1];
    }else if(aRefreshPos == EGORefreshFooter)
    {
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:0.1];
    }
    
    // overide, the actual loading data operation is done in the subclass
}

//刷新调用的方法
-(void)refreshView
{
    if (reflashFlag == 1) {
        NSLog(@"刷新完成");
        
        startNum = @"0";
        endNum = @"10";
        
        if ([@"classPhoto" isEqualToString:_fromName]) {
            
            /**
             * 班级相册图片详情
             *
             * @author luke
             * @date 2016.03.14
             * @args
             *  v=3 ac=Kindergarten op=classTopic sid= cid= uid= tid=主题ID app= page= size=
             */
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Kindergarten",@"ac",
                                  @"classTopic", @"op",
                                  @"3",@"v",
                                  _tid,@"tid",
                                  nil];
            [network sendHttpReq:HttpReq_ClassNewPhotoDetail andData:data];
            
        }else{

            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Circle",@"ac",
                                  @"view", @"op",
                                  @"3",@"v",
                                  _tid,@"tid",
                                  nil];
            
            [network sendHttpReq:HttpReq_MomentsDetail andData:data];
            
        }
    }
}
//加载调用的方法
-(void)getNextPageView
{
    if (reflashFlag == 1) {
        
        //----离线缓存2015.05.14--------------------------
        BOOL isConnect = [Utilities connectedToNetwork];
        //----------------------------------------------
        
        if (isConnect) {
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Circle",@"ac",
                                  @"view", @"op",
                                  @"3",@"v",
                                  _tid,@"tid",
                                  nil];
            
            [network sendHttpReq:HttpReq_MomentsDetail andData:data];
        }else{
            page++;
            [self getDataFromDB:@"1"];
        }
        
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_reloading == NO) {
        if (_refreshHeaderView)
        {
            [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
        }
        
        if (_refreshFooterView)
        {
            [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_reloading == NO) {
        if (_refreshHeaderView)
        {
            [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
        }
        
        if (_refreshFooterView)
        {
            [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
        }
    }
}

#pragma mark -
#pragma mark EGORefreshTableDelegate Methods
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    if (_reloading == NO) {
        [self beginToReloadData:aRefreshPos];
    }
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
    return _reloading; // should return if data source model is reloading
}

// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
    return [NSDate date]; // should return date data source was last changed
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSArray *)[[dataDic objectForKey:@"comments"] objectForKey:@"list"] count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[cellHeightArray objectAtIndex:[indexPath row]] integerValue] + 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    
    NSUInteger row = [indexPath row];
    NSDictionary *dic = [[[dataDic objectForKey:@"comments"] objectForKey:@"list"] objectAtIndex:row];
    
    MomentsDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        cell = [[MomentsDetailTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
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
    label.font = [UIFont systemFontOfSize:14.0f];
    
    CGSize msgSize = [label sizeThatFits:CGSizeMake(0, 16)];//update 2015.08.12

    
    

    // 增加名字点击事件
    cell.ohAttributeLabel.msgPid = [dic objectForKey:@"pid"];
    cell.ohAttributeLabel.msgUid = [dic objectForKey:@"uid"];
    cell.ohAttributeLabel.msgPos = [NSString stringWithFormat:@"%lu", (unsigned long)row];

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
    if (msgSize.width > (320 - 40)) {
        // 超过一行的宽度，按照msg一行的宽度计算的高度set到label中
//        CGSize msgSize1 = [Utilities getStringHeight:testFormEmo andFont:[UIFont systemFontOfSize:14] andSize:CGSizeMake(320 - 40, 0)];
        CGSize msgSize1 = [self getTextHeight:testFormEmo andFont:[UIFont systemFontOfSize:14] andSize:CGSizeMake(320-40, 0)];

        cell.ohAttributeLabel.msgHeight = msgSize1.height;
        cell.ohAttributeLabel.msgWidth = msgSize1.width;
    }else {
        cell.ohAttributeLabel.msgHeight = msgSize.height;
        cell.ohAttributeLabel.msgWidth = 320 - 40;
    }
    
    [cell.textParser.images removeAllObjects];

#if 0
    
    NSMutableAttributedString* attString = [cell.textParser attrStringFromMarkup:msg];
    attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
    
    [attString setFont:[UIFont systemFontOfSize:14]];
    [attString setTextColor:[[UIColor alloc] initWithRed:27/255.0f green:128/255.0f blue:209/255.0f alpha:1.0] range:NSMakeRange(0,[commentName length])];
    
    if (![@""  isEqual: commentToName]) {
        [attString setTextColor:[[UIColor alloc] initWithRed:27/255.0f green:128/255.0f blue:209/255.0f alpha:1.0] range:NSMakeRange([commentName length]+2,[commentToName length])];
    }
    [cell.ohAttributeLabel setVerticalAlignment:VerticalAlignmentMiddle];

    [cell.ohAttributeLabel resetAttributedText];
    [cell.ohAttributeLabel setAttString:attString withImages:cell.textParser.images];
    
#endif
    
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
    

    
//    NSAttributedString* attString = [cmt expressionAttributedStringWithExpression:exp];
//    NSMutableAttributedString* mutableAttStr = [[NSMutableAttributedString alloc] initWithAttributedString:attString];
    
    cell.ohAttributeLabel.attributedText = mutableAttStr;
    
    cell.ohAttributeLabel.font = [UIFont systemFontOfSize:14.0f];

    
    
    

//    [cell.ohAttributeLabel setBackgroundColor:[UIColor redColor]];

    cell.ohAttributeLabel.numberOfLines = 0;

//    cell.ohAttributeLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
//    cell.ohAttributeLabel.automaticallyAddLinksForType = NSTextCheckingAllTypes;
    
    
    int ohAttributeLabelHeight = [[cellHeightArray objectAtIndex:row] integerValue];
    cell.ohAttributeLabel.frame = CGRectMake(20,
                                             10,
                                             WIDTH-45,
                                             ohAttributeLabelHeight+10);

    cell.imgView_bottomLime.frame = CGRectMake(20,
                                               [[cellHeightArray objectAtIndex:[indexPath row]] integerValue] + 19,
                                               WIDTH-40,
                                               1);
    
    if (true == [[dic objectForKey:@"blocked"] integerValue]) {

    }
    
    
    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSLog(@"回复某人");
    

    //[textView becomeFirstResponder];
    
}

-(void)calcCellHeighti
{
    if ([@"0"  isEqual: startNum]) {
        [cellHeightArray removeAllObjects];
//        [cellMessageHeightArray removeAllObjects];
    }
    
    NSUInteger start = [startNum integerValue];
    NSUInteger end  = [(NSArray *)[[dataDic objectForKey:@"comments"] objectForKey:@"list"] count];
    
    // 根据cell内容，提前计算好每个cell的高度
    for (int i=start; i<end; i++) {
        NSDictionary *dic = [[[dataDic objectForKey:@"comments"] objectForKey:@"list"] objectAtIndex:i];
        
        // 动态内容计算高度
        NSString *msg = [self textFromEmoji:[dic objectForKey:@"message"]];
        NSString *commentName = [Utilities replaceNull:[dic objectForKey:@"name"]];
        NSString *commentToName = [dic objectForKey:@"toName"];
        
        NSString *cmt;
        if ([@""  isEqual: commentToName]) {
            // 单独回复
            cmt = [NSString stringWithFormat:@"%@：%@",commentName, msg];
        }else {
            // 回复的回复
            cmt = [NSString stringWithFormat:@"%@回复%@：%@",commentName, commentToName, msg];
        }
        
//        CGSize msgSize;
//        msgSize = [self getTextHeight:cmt andFont:[UIFont systemFontOfSize:14] andSize:CGSizeMake(320-40, 0)];

        MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"/faceImages/expression/emotionImage.plist" bundleName:@"Expression"];//plistName bundleName 需要修改

        NSAttributedString *expressionText = [[dic objectForKey:@"message"] expressionAttributedStringWithExpression:exp];
        
        TSAttributedLabel *label = kProtypeLabel();
        label.attributedText = expressionText;
        label.font = [UIFont systemFontOfSize:14.0f];
        
        CGSize msgSize = [label preferredSizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width - 40.0];//update 2015.08.12

        
//        CGSize msgSize = [Utilities getStringHeight:cmt andFont:[UIFont systemFontOfSize:14]  andSize:CGSizeMake(320-40, 0)];
        
        [cellHeightArray addObject:[NSString stringWithFormat:@"%d",(int)msgSize.height]];
    }
}

#pragma mark - height
static TSAttributedLabel * kProtypeLabel() {
    
    static TSAttributedLabel *_protypeLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _protypeLabel = [TSAttributedLabel new];
        _protypeLabel.font = [UIFont systemFontOfSize:14.0f];
        _protypeLabel.numberOfLines = 0;
        _protypeLabel.textInsets = UIEdgeInsetsMake(0, 0, 10, 0);
        
        
    });
    return _protypeLabel;
}

-(void)showProfile:(NSNotification *)notification
{
    NSLog(@"showProfile");
    FriendProfileViewController *fpvc = [[FriendProfileViewController alloc]init];
    fpvc.fuid = [dataDic objectForKey:@"uid"];
    [self.navigationController pushViewController:fpvc animated:YES];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    OHAttributedLabel *a = (OHAttributedLabel *)touch.view;
    NSInteger b = a.tag;
    
    if (b == 999) {
        return YES;
    }
    
    if(([touch.view isMemberOfClass:[TSTouchLabel class]]) ||
       ([touch.view isMemberOfClass:[OHAttributedLabel class]]) ||
       ([touch.view isMemberOfClass:[UIButton class]]) ||
       ([touch.view isMemberOfClass:[TSAttributedLabel class]])) {
        //放过以上事件的点击拦截
        return NO;
    }else{
        isCommentComment = NO;
        _replyTo = @"";

        return YES;
    }
}

-(void)doShowMomentsDetailHeaderView
{
    
    if ([@"classPhoto" isEqualToString:_fromName]) {
        
        Utilities *util = [Utilities alloc];
        
        // 日期
        _label_dateline.frame = CGRectMake(
                                           10,
                                           15.0,
                                           200,
                                           20);
         NSString *isYestOrToday  = [Utilities timeIntervalToDate:[[dataDic objectForKey:@"dateline"] longLongValue] timeType:9 compareWithToday:YES];
        if ([@"昨天" isEqualToString:isYestOrToday] || [@"今天" isEqualToString:isYestOrToday]) {
        
            NSString *tempdate = [util linuxDateToString:[dataDic objectForKey:@"dateline"] andFormat:@" %@:%@" andType:DateFormat_HM];
            _label_dateline.text = [NSString stringWithFormat:@"%@%@",isYestOrToday,tempdate];
            
        }else{
            _label_dateline.text = [util linuxDateToString:[dataDic objectForKey:@"dateline"] andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
            
        }
        _label_dateline.lineBreakMode = NSLineBreakByWordWrapping;
        _label_dateline.font = [UIFont systemFontOfSize:15.0];
        _label_dateline.numberOfLines = 0;
        _label_dateline.textColor = [UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1];
        _label_dateline.backgroundColor = [UIColor clearColor];
        _label_dateline.lineBreakMode = NSLineBreakByTruncatingTail;
        [headerView addSubview:_label_dateline];

        
    }else{
        // 头像
        _btn_thumb.frame = CGRectMake(
                                      10,
                                      10,
                                      50,
                                      50);
        [_btn_thumb addTarget:self action:@selector(showProfile:) forControlEvents: UIControlEventTouchUpInside];
        _btn_thumb.layer.masksToBounds = YES;
        _btn_thumb.layer.cornerRadius = 50/2;
        _btn_thumb.contentMode = UIViewContentModeScaleToFill;
        [_btn_thumb sd_setImageWithURL:[NSURL URLWithString:[dataDic objectForKey:@"avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
        [_btn_thumb sd_setImageWithURL:[NSURL URLWithString:[dataDic objectForKey:@"avatar"]] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
        [headerView addSubview:_btn_thumb];
        
        // 名字
        _label_username.frame = CGRectMake(
                                           _btn_thumb.frame.origin.x + _btn_thumb.frame.size.width + 5,
                                           _btn_thumb.frame.origin.y + 3,
                                           200,
                                           15);
        
        CGSize msgSize = [Utilities getStringHeight:[Utilities replaceNull:[dataDic objectForKey:@"name"]] andFont:[UIFont systemFontOfSize:15]  andSize:CGSizeMake(200, 15)];
        
        _label_username.uid = [dataDic objectForKey:@"uid"];
        _label_username.touchType = @"touchMomentsNameToProfile";
        
        CGRect a = _label_username.frame;
        //-------add by kate 2015.04.08-------------------------------
        if ([[[UIDevice currentDevice]systemVersion]floatValue] < 8.0){
            
            msgSize = CGSizeMake(200.0, msgSize.height - 19.0);
        }
        //-------------------------------------------------------------
        a.size = msgSize;
        _label_username.frame = a;
        
        _label_username.userInteractionEnabled = YES;
        _label_username.text = [dataDic objectForKey:@"name"];
        _label_username.lineBreakMode = NSLineBreakByWordWrapping;
        _label_username.font = [UIFont systemFontOfSize:15.0f];
        _label_username.numberOfLines = 0;
        _label_username.backgroundColor = [UIColor clearColor];
        _label_username.lineBreakMode = NSLineBreakByTruncatingTail;
        _label_username.textColor = [[UIColor alloc] initWithRed:54/255.0f green:182/255.0f blue:169/255.0f alpha:1.0];
        [headerView addSubview:_label_username];
        
        Utilities *util = [Utilities alloc];
        
        // 日期
        _label_dateline.frame = CGRectMake(
                                           _label_username.frame.origin.x,
                                           _label_username.frame.origin.y + _label_username.frame.size.height+5,
                                           120,
                                           20);
        _label_dateline.text = [util linuxDateToString:[dataDic objectForKey:@"dateline"] andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
        _label_dateline.lineBreakMode = NSLineBreakByWordWrapping;
        _label_dateline.font = [UIFont systemFontOfSize:12.0f];
        _label_dateline.numberOfLines = 0;
        _label_dateline.textColor = [UIColor grayColor];
        _label_dateline.backgroundColor = [UIColor clearColor];
        _label_dateline.lineBreakMode = NSLineBreakByTruncatingTail;
        [headerView addSubview:_label_dateline];

        
    }
   
    NSString *uid = [[g_userInfo getUserDetailInfo]  objectForKey:@"uid"];
    NSString *usertype = [NSString stringWithFormat:@"%@",[[g_userInfo getUserDetailInfo] objectForKey:@"role_id"]];
    
    _tsLabel_delete.frame = CGRectMake(_label_dateline.frame.origin.x + _label_dateline.frame.size.width, _label_dateline.frame.origin.y+2, 26, 16);
    _tsLabel_delete.tid = [dataDic objectForKey:@"id"];

    if ([usertype intValue] == 9) {
        if ([[dataDic objectForKey:@"uid"] isEqual:uid] ) {
            _tsLabel_delete.hidden = NO;
            _tsLabel_delete.text = @"删除";
            _tsLabel_delete.touchType = @"touchMomentsListDelete";
        }else {
            
            if([@"classPhoto" isEqualToString:_fromName]){
                
                _tsLabel_delete.hidden = YES;
                
            }else{
                _tsLabel_delete.hidden = NO;
                _tsLabel_delete.text = @"屏蔽";
                _tsLabel_delete.touchType = @"touchMomentsListBlock";
            }
           
        }
    }else{
        if ([[dataDic objectForKey:@"uid"] isEqual:uid] ) {
            _tsLabel_delete.hidden = NO;
            _tsLabel_delete.text = @"删除";
            _tsLabel_delete.touchType = @"touchMomentsListDelete";
        }else {
            _tsLabel_delete.hidden = YES;
        }
    }
    
    if ([@"classPhoto" isEqualToString:_fromName]){
        yOffset = _label_dateline.frame.origin.y + _label_dateline.frame.size.height + 15;
    }else{
       yOffset = _btn_thumb.frame.origin.y + _btn_thumb.frame.size.height + 10;
    }
    
    // 内容label
    // 先判断是否需要显示_ohAttributeLabel
    if (![[dataDic objectForKey:@"message"]  isEqual: @""]) {
        [_textParser.images removeAllObjects];
         
#if 0
        
        NSString *displayStr = [self transformString:[dataDic objectForKey:@"message"]];
        NSMutableAttributedString* attString = [_textParser attrStringFromMarkup:displayStr];
        
        attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
        [attString setFont:[UIFont systemFontOfSize:16]];
        [headerView addSubview:_ohAttributeLabel];

        [_ohAttributeLabel resetAttributedText];
        [_ohAttributeLabel setAttString:attString withImages:_textParser.images];
        
#endif
        MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"/faceImages/expression/emotionImage.plist" bundleName:@"Expression"];//plistName bundleName 需要修改

        NSAttributedString* attString = [[dataDic objectForKey:@"message"] expressionAttributedStringWithExpression:exp];
        
        _ohAttributeLabel.attributedText = attString;
        
        _ohAttributeLabel.font = [UIFont systemFontOfSize:14.0f];
        _ohAttributeLabel.numberOfLines = 0;
        _ohAttributeLabel.dataDetectorTypes = MLDataDetectorTypeURL;

        [headerView addSubview:_ohAttributeLabel];

        
        _ohAttributeLabel.userInteractionEnabled = YES;
        _ohAttributeLabel.msgComment = [dataDic objectForKey:@"message"];
        _ohAttributeLabel.tag = 999;
        
//        NSString *msg = [self textFromEmoji:[dataDic objectForKey:@"message"]];
//        
//        CGSize msgSize = [self getTextHeight:msg andFont:[UIFont systemFontOfSize:16] andSize:CGSizeMake(320-40, 0)];

        
        CGSize msgSize = [_ohAttributeLabel preferredSizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width - 70.0];//update 2015.08.12

//        CGSize msgSize = [Utilities getStringHeight:msg andFont:[UIFont systemFontOfSize:16]  andSize:CGSizeMake(320-40, 0)];
        
        // 把内容原高度记录下来
        headerMsgHeight = msgSize.height;
        
        
        TSTapGestureRecognizer *singleTouch = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(webLink_click:)];
        singleTouch.delegate = self;
        [_ohAttributeLabel addGestureRecognizer:singleTouch];

        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu:)];
        longPressRecognizer.delegate = self;
        [longPressRecognizer setMinimumPressDuration:1.0];
        [_ohAttributeLabel addGestureRecognizer:longPressRecognizer];

        // 判断是否需要显示全文按钮
        if (msgSize.height > 57) {
            
            if ([@"classPhoto" isEqualToString:_fromName]){
                
                _ohAttributeLabel.frame = CGRectMake(_label_dateline.frame.origin.x,
                                                     yOffset,
                                                     WIDTH-40,
                                                     60);
                
            }else{
                _ohAttributeLabel.frame = CGRectMake(_btn_thumb.frame.origin.x,
                                                     yOffset,
                                                     WIDTH-40,
                                                     60);
                
            }
            
            
            
            _btn_more.frame = CGRectMake(_btn_thumb.frame.origin.x,
                                         _ohAttributeLabel.frame.origin.y + _ohAttributeLabel.frame.size.height + 5,
                                         30,
                                         20);
            
            [_btn_more setTitleColor:[[UIColor alloc] initWithRed:54.0/255.0f green:182.0/255.0f blue:169.0/255.0f alpha:1.0] forState:UIControlStateNormal];
            [_btn_more setTitleColor:[[UIColor alloc] initWithRed:54.0/255.0f green:182.0/255.0f blue:169.0/255.0f alpha:1.0] forState:UIControlStateHighlighted];
            _btn_more.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
            
            [_btn_more setBackgroundImage:[UIImage imageNamed:@"loading_gray.png"] forState:UIControlStateHighlighted] ;
            [_btn_more addTarget:self action:@selector(more_btnclick:) forControlEvents: UIControlEventTouchUpInside];
            
            [_btn_more setTitle:@"全文" forState:UIControlStateNormal];
            [_btn_more setTitle:@"全文" forState:UIControlStateHighlighted];
            
//            if ([@"classPhoto" isEqualToString:_fromName]){
//                
//               
//                
//            }else{
                [headerView addSubview:_btn_more];
//           }
            
            yOffset = _btn_more.frame.origin.y + _btn_more.frame.size.height + 5;
        }else {
            
            if ([@"classPhoto" isEqualToString:_fromName]){
                
                _ohAttributeLabel.frame = CGRectMake(_label_dateline.frame.origin.x,
                                                     yOffset,
                                                     WIDTH-40,
                                                     msgSize.height+10);
                
            }else{
            
                _ohAttributeLabel.frame = CGRectMake(_btn_thumb.frame.origin.x,
                                                     yOffset,
                                                     WIDTH-40,
                                                     msgSize.height+10);
            }
            
              NSLog(@"_ohAttributeLabel.frame1111111:%f",_ohAttributeLabel.frame.origin.y);
            
            yOffset = _ohAttributeLabel.frame.origin.y + _ohAttributeLabel.frame.size.height + 5;
        }
    }

    // 按照y加上sharedlink
    NSString *shareUrl = [dataDic objectForKey:@"shareUrl"];
    NSString *shareContent = [dataDic objectForKey:@"shareContent"];
    NSString *shareSnapshot = [dataDic objectForKey:@"shareSnapshot"];
    
    if (![@""  isEqual: shareUrl]) {
        _sharedLink.frame = CGRectMake(_btn_thumb.frame.origin.x, yOffset + 10, WIDTH-40, 40);
        _sharedLink.hidden = NO;
        _sharedLink.shareContent = shareContent;
        _sharedLink.shareUrl = shareUrl;
        _sharedLink.shareSnapshot = shareSnapshot;
        
        [_sharedLink.img_snapshot sd_setImageWithURL:[NSURL URLWithString:shareSnapshot] placeholderImage:[UIImage imageNamed:@"CommonIconsAndPics/default_link"]];
        _sharedLink.label_content.text = shareContent;
        _sharedLink.img_default.frame = CGRectMake(0, 0, WIDTH-40, 40);
        
        yOffset = yOffset + 60;
    }else {
        _sharedLink.hidden = YES;
    }

    // 如果是被屏蔽的信息，则只显示消息，其他都不显示
    if (true == [[dataDic objectForKey:@"blocked"] integerValue]) {
        if ([[dataDic objectForKey:@"uid"] isEqual:uid] ) {
            _tsLabel_delete.hidden = NO;
            _tsLabel_delete.text = @"删除";
            _tsLabel_delete.touchType = @"touchMomentsListDelete";
        }else {
            _tsLabel_delete.hidden = YES;
        }
        
        _btn_like.hidden = YES;
        _btn_likeIcon.hidden = YES;
        _btn_comment.hidden = YES;
        _btn_commentIcon.hidden = YES;
        _btn_addToPath.hidden = YES;
        _btn_pathIcon.hidden = YES;

        _imgView_headImg1.hidden = YES;
        _imgView_headImg2.hidden = YES;
        _imgView_headImg3.hidden = YES;
        _imgView_headImg4.hidden = YES;
        _imgView_headImg5.hidden = YES;
        
        _imgView_likeBg.hidden = YES;
        _btn_likeNum.hidden = YES;
        
        _label_likeCount.hidden = YES;
        
        _btn_more.hidden = YES;
        
        NSArray *pics = [dataDic objectForKey:@"pics"];
        for (int i=0; i<[pics count]; i++) {
            ((TSTouchImageView *)[_ary_imgThumb objectAtIndex:i]).hidden = YES;
        }

    }else {
        [self rePosImgAndButton:yOffset];

    }
    
    //成长足迹 吴宁确认 2015.12.30-----------------------------------------------------
//    if ([_fromName isEqualToString:@"footmark"]) {
//        
//        if ([usertype integerValue] == 0 || [usertype integerValue] == 6) {
//            
//            _tsLabel_delete.hidden = NO;
//            _tsLabel_delete.text = @"移除";
//            _tsLabel_delete.touchType = @"touchMomentsListRemove";
//            
//            
//        }else{
//          _tsLabel_delete.hidden = YES;
//        }
//        
//    }
    
    if ([_fromName isEqualToString:@"classPhoto"]) {
        
        if (_path) {
            
            _tsLabel_delete.hidden = YES;
            
        }
    }else if ([_fromName isEqualToString:@"footmark"]){
        
       
        _tsLabel_delete.hidden = YES;
        
        
    }
    //---------------------------------------------------------------------------
    
    headerView.frame = CGRectMake(0, 0, WIDTH, yOffset);
    
    _tableView.tableHeaderView = headerView;
}

-(void)rePosImgAndButton:(int)yPos
{
    // 图片
    // 先判断是否有图片要显示
    if (0 != [(NSArray *)[dataDic objectForKey:@"pics"] count]) {
        NSArray *pics = [dataDic objectForKey:@"pics"];
        
        if ([@"classPhoto" isEqualToString:_fromName]) {
            yOffset = _label_dateline.frame.size.height+_label_dateline.frame.origin.y+10;
        }
        
        [self showCellPics:pics andYPos:yOffset];
    }
    
//    // 按照y加上sharedlink
//    NSString *shareUrl = [dataDic objectForKey:@"shareUrl"];
//    NSString *shareContent = [dataDic objectForKey:@"shareContent"];
//    NSString *shareSnapshot = [dataDic objectForKey:@"shareSnapshot"];
//    
//    if (![@""  isEqual: shareUrl]) {
//        _sharedLink.frame = CGRectMake(_ohAttributeLabel.frame.origin.x, yOffset + 10, 320-40, 40);
//        _sharedLink.hidden = NO;
//        _sharedLink.shareContent = shareContent;
//        _sharedLink.shareUrl = shareUrl;
//        _sharedLink.shareSnapshot = shareSnapshot;
//        
//        [_sharedLink.img_snapshot sd_setImageWithURL:[NSURL URLWithString:shareSnapshot] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
//        _sharedLink.label_content.text = shareContent;
//        _sharedLink.img_default.frame = CGRectMake(0, 0, 320-40, 40);
//        
//        yOffset = yOffset + 60;
//    }else {
//        _sharedLink.hidden = YES;
//    }

    // 赞文字数量
    CGSize likeTextSize;
    NSString *strLike = @"赞";
    
    NSDictionary *growpath = [dataDic objectForKey:@"growpath"];
    if (growpath) {
        
        NSString *save = [NSString stringWithFormat:@"%@",[growpath objectForKey:@"save"]];
        
        if ([save integerValue] == 1) {
            
            [_btn_addToPath setBackgroundImage:[UIImage imageNamed:@"ClassKin/collection_press.png"] forState:UIControlStateNormal];
            
            
        }else{
            
            [_btn_addToPath setBackgroundImage:[UIImage imageNamed:@"ClassKin/collection_normal.png"] forState:UIControlStateNormal];
           
            
        }
     
    }
    
    
    NSUInteger loved = [[dataDic objectForKey:@"loved"] integerValue];
    if (loved) {
//        _btn_like.backgroundColor = [UIColor blueColor];
        
        
        
//        [_btn_like setTitle:strLike forState:UIControlStateNormal];
//        [_btn_like setTitle:strLike forState:UIControlStateHighlighted];
//        [_btn_like setTitleColor:[[UIColor alloc] initWithRed:27/255.0f green:128/255.0f blue:209/255.0f alpha:1.0] forState:UIControlStateNormal];
//        [_btn_like setTitleColor:[[UIColor alloc] initWithRed:27/255.0f green:128/255.0f blue:209/255.0f alpha:1.0] forState:UIControlStateHighlighted];
        
        _btn_like.enabled = YES;
        
        [_btn_like setBackgroundImage:[UIImage imageNamed:@"moments/momentsLike_s"] forState:UIControlStateNormal] ;

//        [_btn_likeIcon setImage:[UIImage imageNamed:@"moments/icon_moments_z_p.png"]];
        
        likeTextSize = [Utilities getStringHeight:strLike andFont:[UIFont systemFontOfSize:13] andSize:CGSizeMake(0, 20)];
    }else {
//        [_btn_like setTitle:strLike forState:UIControlStateNormal];
//        [_btn_like setTitle:strLike forState:UIControlStateHighlighted];
//        [_btn_like setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [_btn_like setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        
        [_btn_like setBackgroundImage:[UIImage imageNamed:@"moments/momentsLike_d"] forState:UIControlStateNormal] ;

        _btn_like.enabled = YES;
//        [_btn_likeIcon setImage:[UIImage imageNamed:@"moments/icon_moments_z_d.png"]];
        
        likeTextSize = [Utilities getStringHeight:strLike andFont:[UIFont systemFontOfSize:13] andSize:CGSizeMake(0, 20)];
    }
    
    _btn_likeIcon.hidden = YES;

    // 评论文字数量
    CGSize commentTextSize;
    //        NSString *str = [NSString stringWithFormat:@"评论%@",[[dic objectForKey:@"comments"] objectForKey:@"count"]];
    NSString *str = @"评论";
    
//    [_btn_comment setTitle:str forState:UIControlStateNormal];
//    [_btn_comment setTitle:str forState:UIControlStateHighlighted];
    
    commentTextSize = [Utilities getStringHeight:str andFont:[UIFont systemFontOfSize:13] andSize:CGSizeMake(0, 20)];
    [_btn_comment setBackgroundImage:[UIImage imageNamed:@"moments/momentsComment_d"] forState:UIControlStateNormal] ;

    if ([@"classPhoto" isEqualToString:_fromName]) {
        
        _btn_comment.frame = CGRectMake(250,
                                        yOffset+_ohAttributeLabel.frame.size.height+15,
                                        50,
                                        24);
        
        _btn_like.frame = CGRectMake(180,
                                     yOffset+_ohAttributeLabel.frame.size.height+15,
                                     50,
                                     24);
        
        _btn_addToPath.frame = CGRectMake(_label_dateline.frame.origin.x, _btn_like.frame.origin.y, 50.0, 24);
        
    }else{
        
        // 按照评论数和赞的数量的长度来进行从右至左描画
        _btn_comment.frame = CGRectMake(250,
                                        yOffset,
                                        50,
                                        24);
        //    _btn_commentIcon.frame = CGRectMake(_btn_comment.frame.origin.x - 15,
        //                                            yOffset+2,
        //                                            15, 15);
        
        _btn_like.frame = CGRectMake(180,
                                     yOffset,
                                     50,
                                     24);
        //    _btn_likeIcon.frame = CGRectMake(_btn_like.frame.origin.x - 15,
        //                                         yOffset+2,
        //                                         15, 15);
        
        
    }
    
    
    
    NSString *usertype = [NSString stringWithFormat:@"%@",[[g_userInfo getUserDetailInfo] objectForKey:@"role_id"]];
    
    // 判断是否是学生或者家长，如果是需要显示添加到我的足迹
    if (([@"0"  isEqual: usertype]) || ([@"6"  isEqual: usertype])) {
        
       //班级是否有学籍
        if ([@"0"  isEqual: _growingPathStatusClass]) {
            _btn_addToPath.hidden = YES;
        }else{
            _btn_addToPath.hidden = NO;
        }
//        _btn_pathIcon.hidden = NO;
//        _btn_addToPath.hidden = NO;
        
        if ([@"classPhoto" isEqualToString:_fromName]) {
            _btn_addToPath.frame = CGRectMake(_label_dateline.frame.origin.x, _btn_like.frame.origin.y, 50.0, 24);
        }else{
             _btn_addToPath.frame = CGRectMake(_btn_thumb.frame.origin.x, _btn_like.frame.origin.y, 50.0, 24);
        }
//        _btn_pathIcon.frame = CGRectMake(_btn_thumb.frame.origin.x,
//                                             yOffset+3,
//                                             15, 15);
        
       
    }else {
        _btn_pathIcon.hidden = YES;
       _btn_addToPath.hidden = YES;
    }
    
    // 把评论和赞的高度加上
//    yOffset = yOffset + 20;
    
    int bgGrayYstart = 0;
    _bgGrayView.backgroundColor = [[UIColor alloc] initWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1.0];
    
    int lovesHeight = 0;

    // 喜欢的人背景框和上面的头像
    if (0 != [(NSArray *)[dataDic objectForKey:@"loves"] count]) {
        
        // 喜欢的人
        _lovesStrLabel.hidden = NO;
        
        NSString *lovesStr = @"";
        for (int i=0; i<[(NSArray *)[dataDic objectForKey:@"loves"] count]; i++) {
            NSDictionary *dicLoves = [[dataDic objectForKey:@"loves"] objectAtIndex:i];
            
            lovesStr = [lovesStr stringByAppendingString:[NSString stringWithFormat:@"%@,", [dicLoves objectForKey:@"name"]]];
        }
        
        lovesStr = [lovesStr substringWithRange:NSMakeRange(0, [lovesStr length] - 1)];
        
        yOffset = yOffset + 30;
        
        if ([@"classPhoto" isEqualToString:_fromName]) {
            
            yOffset = _btn_like.frame.origin.y+_btn_like.frame.size.height+10;
            
        }
        
        bgGrayYstart = yOffset;
        
        _lovesStrLabel.text = [NSString stringWithFormat:@"     %@", lovesStr];
        
        CGSize a = [_lovesStrLabel sizeThatFits:CGSizeMake(290, 0)];
        lovesHeight = a.height;
        
        
        
        _lovesStrLabel.frame =  CGRectMake(
                                               _ohAttributeLabel.frame.origin.x+5,
                                               yOffset+5,
                                               WIDTH - _btn_thumb.frame.origin.x - 15,
                                               a.height);
            
        
        
        _lovesStrImageView.hidden = NO;
        _lovesStrImageView.frame =  CGRectMake(
                                                   _ohAttributeLabel.frame.origin.x+6,
                                                   yOffset+6,
                                                   13,
                                                   13);
        
        yOffset = yOffset + lovesHeight;
        
        _lovesStrLabel.hidden = NO;
        _lovesStrImageView.hidden = NO;

    }else {
        yOffset = yOffset + 10 + 20;
        
        _lovesStrLabel.hidden = YES;
        _lovesStrImageView.hidden = YES;
        
        if ([@"classPhoto" isEqualToString:_fromName]) {
            
            yOffset = _btn_like.frame.origin.y+_btn_like.frame.size.height+10;
            
        }

        bgGrayYstart = yOffset;
        

        _imgView_likeBg.hidden = YES;
        _btn_likeNum.hidden = YES;
        
        _imgView_headImg1.hidden = YES;
        _imgView_headImg2.hidden = YES;
        _imgView_headImg3.hidden = YES;
        _imgView_headImg4.hidden = YES;
        _imgView_headImg5.hidden = YES;
        
        _label_likeCount.hidden = YES;
    }
    
    if (0 == lovesHeight) {
        _bgGrayView.hidden = YES;
    }else {
        _bgGrayView.hidden = NO;
    }

    _bgGrayView.frame = CGRectMake(_ohAttributeLabel.frame.origin.x,
                                   bgGrayYstart,
                                   300,
                                   lovesHeight+10);

}

-(void)showCellPics:(NSArray *)pics andYPos:(int)pos
{
    int picCount = [pics count];
    // 按照cell中图片的个数算出图片的位置
    
    float x = _btn_thumb.frame.origin.x;
    if ([@"classPhoto" isEqualToString:_fromName]) {
        x = _label_dateline.frame.origin.x;
    }
    
    int picWidth = ([Utilities getScreenSizeWithoutBar].width-40)/3;
    
    if (picCount == 1) {
        
         NSString *type = [NSString stringWithFormat:@"%@",[[pics objectAtIndex:0] objectForKey:@"type"]];
        
        if ([type integerValue] == 1) {
          picWidth = [Utilities convertPixsH:180.0];
        }
        
    }

    for (int i=0; i<picCount; i++) {
        if (i<3) {
            
             ((TSTouchImageView *)[_ary_imgThumb objectAtIndex:i]).hidden = NO;
            
            NSString *type = [NSString stringWithFormat:@"%@",[[pics objectAtIndex:i] objectForKey:@"type"]];
            
            if ([type integerValue] == 1) {//小视频
                
                [((TSTouchImageView *)[_ary_imgThumb objectAtIndex:i]) setFrame:CGRectMake(x +(5+picWidth)*i,
                                                                                           pos+5,
                                                                                           [Utilities convertPixsH:240.0], picWidth)];
                UIImageView *videoMarkImgV = [[UIImageView alloc] initWithFrame:CGRectMake(([Utilities convertPixsH:240.0] - 60.0)/2.0, (picWidth-60.0)/2.0, 60.0, 60.0)];
                videoMarkImgV.image = [UIImage imageNamed:@"videoMarkBig.png"];
                [(TSTouchImageView *)[_ary_imgThumb objectAtIndex:i] addSubview:videoMarkImgV];
 
            }else{//图片
                
                [((TSTouchImageView *)[_ary_imgThumb objectAtIndex:i]) setFrame:CGRectMake(x +(5+picWidth)*i,
                                                                                           pos+5,
                                                                                           picWidth, picWidth)];
            }
            
          
           // [((TSTouchImageView *)[_ary_imgThumb objectAtIndex:i]) sd_setImageWithURL:[NSURL URLWithString:[[pics objectAtIndex:i] objectForKey:@"pic"]]placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            
            
        }else if ((i>=3) && (i<6)) {
            ((TSTouchImageView *)[_ary_imgThumb objectAtIndex:i]).hidden = NO;
            
            [((TSTouchImageView *)[_ary_imgThumb objectAtIndex:i]) setFrame:CGRectMake(x +(5+picWidth)*(i-3),
                                                                     pos +5 + picWidth + 5,
                                                                     picWidth, picWidth)];
            //[((TSTouchImageView *)[_ary_imgThumb objectAtIndex:i]) sd_setImageWithURL:[NSURL URLWithString:[[pics objectAtIndex:i] objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
        }else if ((i>=6) && (i<9)) {
            ((TSTouchImageView *)[_ary_imgThumb objectAtIndex:i]).hidden = NO;
            
            [((TSTouchImageView *)[_ary_imgThumb objectAtIndex:i]) setFrame:CGRectMake(x +(5+picWidth)*(i-6),
                                                                     pos +5 + picWidth + picWidth + 10,
                                                                     picWidth,
                                                                     picWidth)];
            //[((TSTouchImageView *)[_ary_imgThumb objectAtIndex:i]) sd_setImageWithURL:[NSURL URLWithString:[[pics objectAtIndex:i] objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
        }
        
         [((TSTouchImageView *)[_ary_imgThumb objectAtIndex:i]) sd_setImageWithURL:[NSURL URLWithString:[[pics objectAtIndex:i] objectForKey:@"thumb"]]placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    }
    
    // 按照图片的个数计算高度偏移量
//    if ((picCount<=3) && (picCount != 0)) {
//        yOffset = yOffset + 80;
//    }else if ((picCount>3) && (picCount<=6)) {
//        yOffset = yOffset + 80*2;
//    }else if ((picCount>6) && (picCount<=9)) {
//        yOffset = yOffset + 80*3;
//    }
    
    // 按照图片的个数计算高度偏移量
    if ((picCount<=3) && (picCount != 0)) {
        yOffset = yOffset + picWidth+10;
    }else if ((picCount>3) && (picCount<=6)) {
        yOffset = yOffset + (picWidth*2 + 20);
    }else if ((picCount>6) && (picCount<=9)) {
        yOffset = yOffset + (picWidth*3 + 30);
    }

    // 把最大个数图片以后的图片设置为hidden
    for (int i=[pics count]; i<9; i++) {
        ((UIButton *)[_ary_imgThumb objectAtIndex:i]).hidden = YES;
    }
    
    if ([@"classPhoto" isEqualToString:_fromName]) {
        
        
        if (_ohAttributeLabel.frame.size.height > 0) {
           
            _ohAttributeLabel.frame = CGRectMake(_label_dateline.frame.origin.x,
                                                 yOffset,
                                                 WIDTH-40,
                                                 _ohAttributeLabel.frame.size.height+10);
            
        }
        
        _btn_more.frame = CGRectMake(_ohAttributeLabel.frame.origin.x,
                                     _ohAttributeLabel.frame.origin.y + _ohAttributeLabel.frame.size.height + 5,
                                     30,
                                     20);
        
        NSLog(@"_ohAttributeLabel.frame:%f",_ohAttributeLabel.frame.origin.y);
        NSLog(@"_ohAttributeLabel.height:%f",_ohAttributeLabel.frame.size.height);
        NSLog(@"_btn_more.frame:%f",_btn_more.frame.origin.y);
        
    }
    
}

- (IBAction)more_btnclick:(id)sender
{
    if ([@"全文"  isEqual: _btn_more.titleLabel.text]) {
        _ohAttributeLabel.frame = CGRectMake(_btn_thumb.frame.origin.x,
                                             _btn_thumb.frame.origin.y + _btn_thumb.frame.size.height + 10,
                                             WIDTH-40,
                                             headerMsgHeight);
        
        [_btn_more setTitle:@"收起" forState:UIControlStateNormal];
        [_btn_more setTitle:@"收起" forState:UIControlStateHighlighted];
        
        // 重新设置headerview的高度
        CGSize headSize = headerView.frame.size;
        headerView.frame = CGRectMake(0, 0,
                                      WIDTH,
                                      headSize.height + headerMsgHeight - 60);
    }else {
        _ohAttributeLabel.frame = CGRectMake(_btn_thumb.frame.origin.x,
                                             _btn_thumb.frame.origin.y + _btn_thumb.frame.size.height + 10,
                                             WIDTH-40,
                                             60);

        [_btn_more setTitle:@"全文" forState:UIControlStateNormal];
        [_btn_more setTitle:@"全文" forState:UIControlStateHighlighted];

        // 重新设置headerview的高度
        CGSize headSize = headerView.frame.size;
        headerView.frame = CGRectMake(0, 0,
                                      WIDTH,
                                      headSize.height - headerMsgHeight + 60);
    }
    
    _btn_more.frame = CGRectMake(_btn_thumb.frame.origin.x,
                                 _ohAttributeLabel.frame.origin.y + _ohAttributeLabel.frame.size.height + 5,
                                 30,
                                 20);
    
    yOffset = _btn_more.frame.origin.y + _btn_more.frame.size.height + 5;
    
    // 按照y加上sharedlink
    NSString *shareUrl = [dataDic objectForKey:@"shareUrl"];
    NSString *shareContent = [dataDic objectForKey:@"shareContent"];
    NSString *shareSnapshot = [dataDic objectForKey:@"shareSnapshot"];
    
    if (![@""  isEqual: shareUrl]) {
        _sharedLink.frame = CGRectMake(_btn_thumb.frame.origin.x, yOffset + 10, WIDTH-40, 40);
        _sharedLink.hidden = NO;
        _sharedLink.shareContent = shareContent;
        _sharedLink.shareUrl = shareUrl;
        _sharedLink.shareSnapshot = shareSnapshot;
        
        [_sharedLink.img_snapshot sd_setImageWithURL:[NSURL URLWithString:shareSnapshot] placeholderImage:[UIImage imageNamed:@"CommonIconsAndPics/default_link"]];
        _sharedLink.label_content.text = shareContent;
        _sharedLink.img_default.frame = CGRectMake(0, 0, WIDTH-40, 40);
        
        yOffset = yOffset + 60;
    }else {
        _sharedLink.hidden = YES;
    }

    
    
    [self rePosImgAndButton:yOffset];

    _tableView.tableHeaderView = headerView;
    [_tableView reloadData];

//    [self setFooterView];
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

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    
    [Utilities dismissProcessingHud:self.view];// 2015.05.12
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    //NSLog(@"resultJSON:%@",resultJSON);
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if ([@"CircleAction.view"  isEqual: [resultJSON objectForKey:@"protocol"]] || [@"KindergartenAction.classTopic"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
        if(true == [result intValue])
        {
            NSDictionary* message_info = [resultJSON objectForKey:@"message"];
            
            if ([@"0"  isEqual: startNum]) {
                [dataDic removeAllObjects];
                [commentsArr removeAllObjects];
                
                if ([@"CircleAction.view"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
                    [[MomentsDetailDBDao getDaoInstance] deleteAllData:@"1" momentID:_tid];// 删除所有数据2015.05.15
                }
                
                
            }
            
            if ([@"CircleAction.view"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
                //------获取数据，直接更新数据库即可 2015.05.15-------------------------------------------
                if (![@"0"  isEqual: [NSString stringWithFormat:@"%@", [[message_info objectForKey:@"comments"] objectForKey:@"size"]]]) {
                    NSString *size = [[message_info objectForKey:@"comments"] objectForKey:@"size"];
                    int pageNum = [startNum intValue]/[size intValue];
                    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    MomentsDetailObject *momentsDetail = [[MomentsDetailObject alloc] init];
                    momentsDetail.momentType = @"1";
                    momentsDetail.jsonStr = jsonStr;
                    momentsDetail.momentId = _tid;
                    momentsDetail.page = [NSString stringWithFormat:@"%d",pageNum];
                    [momentsDetail updateToDB];
                }
                
                //-------------------------------------------------------------------------------------
            }
       
            
            if ([@"KindergartenAction.classTopic"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
                
                NSDictionary *topic = [message_info objectForKey:@"topic"];
                [dataDic setObject:[topic objectForKey:@"id"] forKey:@"id"];
                [dataDic setObject:[topic objectForKey:@"uid"] forKey:@"uid"];
                [dataDic setObject:[topic objectForKey:@"thumb"] forKey:@"avatar"];
                [dataDic setObject:@"" forKey:@"name"];
                [dataDic setObject:[topic objectForKey:@"title"] forKey:@"message"];
                [dataDic setObject:[topic objectForKey:@"dateline"] forKey:@"dateline"];
                
            }else{
               
                [dataDic setObject:[message_info objectForKey:@"id"] forKey:@"id"];
                [dataDic setObject:[message_info objectForKey:@"uid"] forKey:@"uid"];
                [dataDic setObject:[message_info objectForKey:@"avatar"] forKey:@"avatar"];
                [dataDic setObject:[message_info objectForKey:@"name"] forKey:@"name"];
                [dataDic setObject:[message_info objectForKey:@"message"] forKey:@"message"];
                [dataDic setObject:[message_info objectForKey:@"dateline"] forKey:@"dateline"];
            }
            
            
            
            [dataDic setObject:[message_info objectForKey:@"pics"] forKey:@"pics"];
            [dataDic setObject:[message_info objectForKey:@"like"] forKey:@"like"];
            [dataDic setObject:[message_info objectForKey:@"loved"] forKey:@"loved"];
            [dataDic setObject:[message_info objectForKey:@"growpath"] forKey:@"growpath"];
            [dataDic setObject:[Utilities replaceNull:[NSString stringWithFormat:@"%@",[message_info objectForKey:@"blocked"]]] forKey:@"blocked"];
            [dataDic setObject:[Utilities replaceNull:[NSString stringWithFormat:@"%@",[message_info objectForKey:@"privilege"]]] forKey:@"privilege"];
            //----add by kate----------------------------------------
            NSLog(@"classess:%@",[message_info objectForKey:@"classes"]);
            
            // shared links
            [dataDic setObject:[Utilities replaceNull:[message_info objectForKey:@"shareUrl"]] forKey:@"shareUrl"];
            [dataDic setObject:[Utilities replaceNull:[message_info objectForKey:@"shareSnapshot"]] forKey:@"shareSnapshot"];
            [dataDic setObject:[Utilities replaceNull:[message_info objectForKey:@"shareContent"]] forKey:@"shareContent"];

            if ([message_info objectForKey:@"classes"] != nil) {
                [dataDic setObject:[message_info objectForKey:@"classes"] forKey:@"classes"];
                [dataDic setObject:[Utilities replaceNull:[NSString stringWithFormat:@"%@",[message_info objectForKey:@"cids"]]] forKey:@"cids"];
            }
            //-----------------------------------------------------

            // 将评论内容转化为动态数组
            NSDictionary *commentsDic = [message_info objectForKey:@"comments"];
            NSMutableDictionary *comments_tempDic = [NSMutableDictionary dictionary];
            
            [comments_tempDic setObject:[commentsDic objectForKey:@"page"] forKey:@"page"];
            [comments_tempDic setObject:[commentsDic objectForKey:@"size"] forKey:@"size"];
            //[comments_tempDic setObject:[commentsDic objectForKey:@"count"] forKey:@"count"];//2016.03.21 luke说不再使用count字段影响性能 update by kate
            
            NSArray *comment_temp = [commentsDic objectForKey:@"list"];
//            NSMutableArray *arrComments = [NSMutableArray array];
            
            for (NSObject *object in comment_temp) {
                NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
                NSDictionary *dic = (NSDictionary *)object;
                
                [dic1 addEntriesFromDictionary:dic];
//                [arrComments addObject:dic1];
                [commentsArr addObject:dic1];

            }
//            [comments_tempDic setObject:arrComments forKey:@"list"];
            [comments_tempDic setObject:commentsArr forKey:@"list"];
            [comments_tempDic setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[commentsArr count] ]forKey:@"count"];//update by kate 2016.03.21

            // 将喜欢的人转换为动态数组
            NSArray *oriArrLoves = [message_info objectForKey:@"loves"];
            NSMutableArray *arrLoves = [NSMutableArray array];
            
            for (NSObject *object in oriArrLoves) {
                NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
                NSDictionary *dic = (NSDictionary *)object;
                
                [dic1 addEntriesFromDictionary:dic];
                [arrLoves addObject:dic1];
            }
            
            [dataDic setObject:arrLoves forKey:@"loves"];
            [dataDic setObject:comments_tempDic forKey:@"comments"];

            [self doShowMomentsDetailHeaderView];
            [self calcCellHeighti];

            startNum = [NSString stringWithFormat:@"%lu",(startNum.integerValue + [comment_temp count])];
            
            [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
            
            [_tableView reloadData];
            
            //------add by kate---------------------------------------
            // 权限设置右侧按钮
            NSString *tUid = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"uid"]];
            NSString *uid = [[g_userInfo getUserDetailInfo] objectForKey:@"uid"];
            
            if ([_fromName isEqualToString:@"footmark"]) {//成长足迹
                
                NSString *usertype = [NSString stringWithFormat:@"%@",[[g_userInfo getUserDetailInfo] objectForKey:@"role_id"]];
                //学生家长有设置权限 其他身份没有 吴宁确认2015.12.29
                if ([usertype integerValue] == 0 || [usertype integerValue] == 6) {
                    
                    if([tUid length] != 0){
                        if ([tUid isEqual: uid]) {
                            
                            if(![@"KindergartenAction.classTopic"  isEqual: [resultJSON objectForKey:@"protocol"]]){
                                
                                // 如果是自己发的
                                [self setCustomizeRightButton:@"icon_more.png"];
                            }
                            
                           
                            
                        }
                    }
                }
                
            }else{
                if([tUid length] != 0){
                    if ([tUid isEqual: uid]) {
                        
                        if(![@"KindergartenAction.classTopic"  isEqual: [resultJSON objectForKey:@"protocol"]]){
                            // 如果是自己发的
                            [self setCustomizeRightButton:@"icon_more.png"];
                            
                        }
                     
                        
                    }
                }
            }
            
            //-------------------------------------------------------
            
        }else {
            
            NSString* message_info = [resultJSON objectForKey:@"message"];

            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"获取失败"
                                                           message:message_info
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            alert.tag = 134;
            [alert show];
        }
        
    }else if ([@"CircleAction.love"  isEqual: [resultJSON objectForKey:@"protocol"]] || [@"KindergartenAction.loveClassTopic"  isEqual: [resultJSON objectForKey:@"protocol"]]){
        // 赞
        if(true == [result intValue])
        {
            NSUInteger heightBefore = 0;
            if (0 != [(NSArray *)[dataDic objectForKey:@"loves"] count]) {
                NSString *lovesStr = @"";
                for (int i=0; i<[(NSArray *)[dataDic objectForKey:@"loves"] count]; i++) {
                    NSDictionary *dicLoves = [[dataDic objectForKey:@"loves"] objectAtIndex:i];
                    
                    lovesStr = [lovesStr stringByAppendingString:[NSString stringWithFormat:@"%@,", [dicLoves objectForKey:@"name"]]];
                }
                
                lovesStr = [lovesStr substringWithRange:NSMakeRange(0, [lovesStr length] - 1)];
                
                UILabel *lovesStrLabel = [[UILabel alloc] init];
                lovesStrLabel.lineBreakMode = NSLineBreakByWordWrapping;
                lovesStrLabel.font = [UIFont systemFontOfSize:13.0f];
                lovesStrLabel.numberOfLines = 0;
                lovesStrLabel.textColor = [UIColor grayColor];
                lovesStrLabel.backgroundColor = [UIColor clearColor];
                lovesStrLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                lovesStrLabel.text = lovesStr;
                
                CGSize a = [_lovesStrLabel sizeThatFits:CGSizeMake(290, 0)];
                
                heightBefore = a.height;
            }
            
//            NSUInteger num = [[[dataArray objectAtIndex:[likeCellNum integerValue]] objectForKey:@"like"] integerValue];
            
            // 设置已赞
            [dataDic setObject:@"1" forKey:@"loved"];
            // 已赞数目+1
//            [[dataArray objectAtIndex:[likeCellNum integerValue]] setObject:[NSString stringWithFormat:@"%lu",num +1] forKey:@"like"];
            
            NSString *uid = [[g_userInfo getUserDetailInfo]  objectForKey:@"uid"];
            NSString *avatar = [[g_userInfo getUserDetailInfo]  objectForKey:@"avatar"];
            NSString *name = [[g_userInfo getUserDetailInfo]  objectForKey:@"name"];
            
            // 赞列表的人
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",avatar,@"avatar", name,@"name",nil];
            
            [[dataDic objectForKey:@"loves"] addObject:dictionary];
            
            if (0 != [(NSArray *)[dataDic objectForKey:@"loves"] count]) {
                NSString *lovesStr = @"";
                for (int i=0; i<[(NSArray *)[dataDic objectForKey:@"loves"] count]; i++) {
                    NSDictionary *dicLoves = [[dataDic objectForKey:@"loves"] objectAtIndex:i];
                    
                    lovesStr = [lovesStr stringByAppendingString:[NSString stringWithFormat:@"%@,", [dicLoves objectForKey:@"name"]]];
                }
                
                lovesStr = [lovesStr substringWithRange:NSMakeRange(0, [lovesStr length] - 1)];
                
                UILabel *lovesStrLabel = [[UILabel alloc] init];
                lovesStrLabel.lineBreakMode = NSLineBreakByWordWrapping;
                lovesStrLabel.font = [UIFont systemFontOfSize:13.0f];
                lovesStrLabel.numberOfLines = 0;
                lovesStrLabel.textColor = [UIColor grayColor];
                lovesStrLabel.backgroundColor = [UIColor clearColor];
                lovesStrLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                lovesStrLabel.text = lovesStr;
                
                CGSize a = [_lovesStrLabel sizeThatFits:CGSizeMake(290, 0)];
                
                NSUInteger height = headerView.frame.size.height -heightBefore + a.height;
                headerView.frame = CGRectMake(0, 0, WIDTH, height);

//                if (0 == heightBefore) {
//                    // 增加高度
//                    [cellHeightArray replaceObjectAtIndex:[likeCellNum integerValue] withObject:[NSString stringWithFormat:@"%lu", (unsigned long)height+8]];
//                }else {
//                    // 增加高度
//                    [cellHeightArray replaceObjectAtIndex:[likeCellNum integerValue] withObject:[NSString stringWithFormat:@"%lu", (unsigned long)height]];
//                }
                
            }
            [self doShowMomentsDetailHeaderView];

//            [_tableView reloadData];

#if 0
            int num = [[dataDic objectForKey:@"like"] integerValue];
            
            // 设置已赞
            [dataDic setObject:@"1" forKey:@"loved"];
            // 已赞数目+1
            [dataDic setObject:[NSString stringWithFormat:@"%d",num +1] forKey:@"like"];
            
            NSString *uid = [[g_userInfo getUserDetailInfo]  objectForKey:@"uid"];
            NSString *avatar = [[g_userInfo getUserDetailInfo]  objectForKey:@"avatar"];
            
            // 赞列表的人
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",avatar,@"avatar", nil];
            
            if (0 == [(NSArray *)[dataDic objectForKey:@"loves"] count]) {
                int height = headerView.frame.size.height + 60;
                // 增加高度
                headerView.frame = CGRectMake(0, 0, WIDTH, height);
            }
            
            [[dataDic objectForKey:@"loves"] addObject:dictionary];
            
            [self doShowMomentsDetailHeaderView];
            
#endif
            [ReportObject event:ID_CIRCLE_LOVE];//2015.06.25
            
        }
    }else if ([@"CircleAction.hate"  isEqual: [resultJSON objectForKey:@"protocol"]] || [@"KindergartenAction.hateClassTopic"  isEqual: [resultJSON objectForKey:@"protocol"]]){
        // 取消赞
        if(true == [result intValue])
        {
            // 设置取消赞
            [dataDic setObject:@"0" forKey:@"loved"];
            
            int num = [[dataDic objectForKey:@"like"] integerValue];
            
            // 已赞数目+1
            [dataDic setObject:[NSString stringWithFormat:@"%d",num-1] forKey:@"like"];

            // 找到当前点赞的人得uid，变更点赞的人列表
            NSArray *arr = (NSArray *)[dataDic objectForKey:@"loves"];
            if (1 == [arr count]) {
                // 只有一个赞就是本人的时候
                int height = headerView.frame.size.height - 60;
                // 减少高度
                headerView.frame = CGRectMake(0, 0, WIDTH, height);

                // remove赞数组里面的值
                [[dataDic objectForKey:@"loves"] removeObjectAtIndex:0];
            }else {
                // 有很多人赞的时候
                NSString *uid = [Utilities getUniqueUid];
                
                NSMutableArray *arrLove = [dataDic objectForKey:@"loves"];
                
                int pos = -1;
                for (int i=0; i<[arrLove count]; i++) {
                    NSDictionary *dicLove = [arrLove objectAtIndex:i];
                    NSString *uidLove = [dicLove objectForKey:@"uid"];
                    
                    if ([uidLove isEqual:uid]) {
                        pos = i;
                        break;
                    }
                }
                
                [[dataDic objectForKey:@"loves"] removeObjectAtIndex:pos];
            }

            [self doShowMomentsDetailHeaderView];
        }else{
            [Utilities showFailedHud:@"取消赞失败" descView:self.view];//2015.05.12
        }
    }else if (([@"CircleAction.comment"  isEqual: [resultJSON objectForKey:@"protocol"]]) || ([@"KindergartenAction.addClassTopicComment"  isEqual: [resultJSON objectForKey:@"protocol"]])){
        // 评论一条动态
        if(true == [result intValue])
        {
#if 0
#endif
            // 如果当前显示的评论条数是最大条目，上拉刷新不会再拉取到新消息，则把新回复的添加到最后
            if ([(NSArray *)[[dataDic objectForKey:@"comments"] objectForKey:@"list"] count] == [[[dataDic objectForKey:@"comments"] objectForKey:@"count"] integerValue]) {
                // 更新commentlist
                NSDictionary *msg = [resultJSON objectForKey:@"message"];
                [[[dataDic objectForKey:@"comments"] objectForKey:@"list"] addObject:msg];
                
                // 计算新增加的comment的高度
                NSString *msg1 = [self textFromEmoji:[msg objectForKey:@"message"]];
                NSString *commentName = [Utilities replaceNull:[msg objectForKey:@"name"]];
                NSString *commentToName = [msg objectForKey:@"toName"];

                NSString *cmt;
                if ([@""  isEqual: commentToName]) {
                    // 单独回复
                    cmt = [NSString stringWithFormat:@"%@：%@",commentName, msg1];
                }else {
                    // 回复的回复
                    cmt = [NSString stringWithFormat:@"%@回复%@：%@",commentName, commentToName, msg1];
                }

                NSString *retStr = [self textFromEmoji:cmt];

                CGSize msgSize;
                if (![@""  isEqual: retStr]) {
                    msgSize = [self getTextHeight:retStr andFont:[UIFont systemFontOfSize:14] andSize:CGSizeMake(WIDTH-40, 0)];

//                    msgSize = [Utilities getStringHeight:retStr andFont:[UIFont systemFontOfSize:14]  andSize:CGSizeMake(320-40, 0)];
                }
                
                // 增加cell高度
                [cellHeightArray addObject:[NSString stringWithFormat:@"%d",(int)msgSize.height]];
                
                startNum = [NSString stringWithFormat:@"%d", [startNum integerValue] + 1];
            }
            
            // 修改dataDic中得评论数
            NSUInteger newCount = [[[dataDic objectForKey:@"comments"] objectForKey:@"count"] integerValue] + 1;
            [[dataDic objectForKey:@"comments"] setObject:[NSString stringWithFormat:@"%lu", (unsigned long)newCount] forKey:@"count"];

            // 重新画headerview
            [self doShowMomentsDetailHeaderView];
            
            // 刷新tableview
            [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
            
            //[MBProgressHUD showSuccess:@"回复成功" toView:nil];
            [Utilities showSuccessedHud:@"回复成功" descView:self.view];// 2015.05.12
            [ReportObject event:ID_CIRCLE_REPLY];//2015.06.25
            
        }else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:[resultJSON objectForKey:@"message"]
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }else if (([@"CircleAction.removeComment"  isEqual: [resultJSON objectForKey:@"protocol"]])|| ([@"KindergartenAction.delClassTopicComment"  isEqual: [resultJSON objectForKey:@"protocol"]])){
        // 删除自己发的评论
        if(true == [result intValue])
        {
            [Utilities showSuccessedHud:[resultJSON objectForKey:@"message"] descView:self.view];// 2015.05.12
            
            // 删除列表中内容
            [[[dataDic objectForKey:@"comments"] objectForKey:@"list"] removeObjectAtIndex:[_deletePidPos integerValue]];
            
            // 删除高度array中的内容
            [cellHeightArray removeObjectAtIndex:[_deletePidPos integerValue]];
            
            startNum = [NSString stringWithFormat:@"%d", [startNum integerValue] - 1];

            // 修改dataDic中得评论数
            int newCount = [[[dataDic objectForKey:@"comments"] objectForKey:@"count"] integerValue] - 1;
            [[dataDic objectForKey:@"comments"] setObject:[NSString stringWithFormat:@"%d", newCount] forKey:@"count"];
            
            // 重新画headerview
            [self doShowMomentsDetailHeaderView];

            [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
            
            [ReportObject event:ID_CIRCLE_REPLY_DEL];//2015.06.25
            
        }else{
            [Utilities showFailedHud:[resultJSON objectForKey:@"message"] descView:self.view];// 2015.05.12
        }
    }else if ([@"CircleAction.removePost"  isEqual: [resultJSON objectForKey:@"protocol"]] || [@"KindergartenAction.delClassTopic"  isEqualToString: [resultJSON objectForKey:@"protocol"]]){
        // 删除自己发的动态
        if(true == [result intValue])
        {
            // 取消所有的网络请求
            [network cancelCurrentRequest];
            
            if ([@"KindergartenAction.delClassTopic"  isEqual: [resultJSON objectForKey:@"protocol"]]) {
                //刷新班级最新相册列表
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadClassNewPhoto" object:nil];
            }else{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadSchoolMomentsView1" object:nil];
                [ReportObject event:ID_CIRCLE_DEL];//2015.06.25
 
            }
              [self.navigationController popViewControllerAnimated:YES];
            
    }
    }else if ([@"CircleAction.block"  isEqual: [resultJSON objectForKey:@"protocol"]]){
        // 管理员屏蔽动态
        if(true == [result intValue])
        {
            // 改变array里面的值，重新描画
            [dataDic setObject:@"1" forKey:@"blocked"];
            [dataDic setObject:[resultJSON objectForKey:@"message"] forKey:@"message"];
            [[dataDic objectForKey:@"comments"] setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"count"];
            
            NSArray *arr = [[NSArray alloc] init];
            [[dataDic objectForKey:@"comments"] setObject:arr forKey:@"list"];

            toolBar.hidden = YES;
            [self doShowMomentsDetailHeaderView];

            [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
            
            [ReportObject event:ID_CIRCLE_BLOCK];//2015.06.25
            
        }else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:[resultJSON objectForKey:@"message"]
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void)reciveHttpDataError:(NSError*)err
{
   
    [Utilities dismissProcessingHud:self.view];//2015.05.12
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                   message:@"网络连接错误，请稍候再试"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    [alert show];
}

//-----add by kate--------------------------------------------------
-(void)showCustomKeyBoard{
    
    // 自定义数据框
    toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height - 44 - 44, [UIScreen mainScreen].bounds.size.width, 44)];
    toolBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(43.0, 5.0, [UIScreen mainScreen].bounds.size.width - 60 - 33, 33)];
    textView.delegate = self;
    textView.backgroundColor = [UIColor clearColor];
    //textView.returnKeyType = UIReturnKeyDone;
    
    //---update 2015.07.23-----------------------------------------------
//    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTextView:)];
//    singleTouch.delegate = self;
//    [textView addGestureRecognizer:singleTouch];

    //---------------------------------------------------------------------
    
    UIImage *rawEntryBackground = [UIImage imageNamed:@"friend/bg_message_entry_InputField2.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:15 topCapHeight:21];
    entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(43.0, 5, [UIScreen mainScreen].bounds.size.width - 60 - 33, 33);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    entryImageView.userInteractionEnabled = YES;
    
    _replyToLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 20)];
    _replyToLabel.enabled = NO;
    _replyToLabel.text = @"";
    _replyToLabel.font =  [UIFont systemFontOfSize:13];
    _replyToLabel.textColor = [UIColor grayColor];
    [textView addSubview:_replyToLabel];

    [toolBar addSubview:entryImageView];
    [toolBar addSubview:textView];
    
    if (!faceBoard) {
        
        faceBoard = [[FaceBoard alloc] init];
        faceBoard.delegate = self;
        faceBoard.maxLength = 500;// 2015.07.21
        faceBoard.inputTextView = textView;
    }
    isFirstShowKeyboard = YES;
    isClickImg = NO;
    clickFlag = 0;
    
    //表情按钮
    keyboardButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    keyboardButton.frame = CGRectMake(5.0, 5.0, 33.0, 33.0);
    keyboardButton.tag = 122;
    [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                    forState:UIControlStateNormal];
    [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                    forState:UIControlStateHighlighted];
    [keyboardButton addTarget:self action:@selector(faceBoardClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:keyboardButton];
    
    AudioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    AudioButton.frame = CGRectMake(284.0 - 9, 5.0, 40.0, 33.0);
    AudioButton.tag = 124;
    [AudioButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/send_normal.png"]
                 forState:UIControlStateNormal];
    [AudioButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/send_press.png"]
                 forState:UIControlStateHighlighted];
    [AudioButton addTarget:self action:@selector(AudioClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:AudioButton];
    
    [self.view addSubview:toolBar];
}

// 自定义输入框发表按钮,发送评论
-(void)AudioClick:(id)sender
{
    if ([@""  isEqual: textView.text]) {
        //[MBProgressHUD showError:@"请输入回复内容。" toView:textView.inputView];
        [Utilities showFailedHud:@"请输入回复内容。" descView:textView.inputView];//2015.05.12
    }else {
        
        if (isCommentComment) {
            
            [Utilities showProcessingHud:self.view];// 2015.05.12
            if ([@"classPhoto" isEqualToString:_fromName]) {
                /**
                 * 班级相册图片评论添加
                 * @author luke
                 * @date 2016.03.17
                 * @args
                 *  v=3 ac=Kindergarten op=addClassTopicComment sid= cid= uid= tid=主题ID pid=评论ID message=评论内容
                 */
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                      @"Kindergarten",@"ac",
                                      @"3",@"v",
                                      @"addClassTopicComment", @"op",
                                      _tid, @"tid",
                                      _deletePid, @"pid",
                                      textView.text, @"message",
                                      _cid,@"cid",
                                      nil];
                
                [network sendHttpReq:HttpReq_ClassNewPhotoComment andData:data];
                
            }else{
                
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                      @"Circle",@"ac",
                                      @"2",@"v",
                                      @"comment", @"op",
                                      _tid, @"tid",
                                      _deletePid, @"pid",
                                      textView.text, @"message",
                                      nil];
                
                [network sendHttpReq:HttpReq_MomentsComment andData:data];
                
            }
            
           
            
            isCommentComment = NO;
        }else {
            
            [Utilities showProcessingHud:self.view];// 2015.05.12
            
            if ([@"classPhoto" isEqualToString:_fromName]) {
                /**
                 * 班级相册图片评论添加
                 * @author luke
                 * @date 2016.03.17
                 * @args
                 *  v=3 ac=Kindergarten op=addClassTopicComment sid= cid= uid= tid=主题ID pid=评论ID message=评论内容
                 */
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                      @"Kindergarten",@"ac",
                                      @"3",@"v",
                                      @"addClassTopicComment", @"op",
                                      _tid, @"tid",
                                      textView.text, @"message",
                                      _cid,@"cid",
                                      nil];
                
                [network sendHttpReq:HttpReq_ClassNewPhotoComment andData:data];
                
            }else{
                
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                      @"Circle",@"ac",
                                      @"2",@"v",
                                      @"comment", @"op",
                                      _tid, @"tid",
                                      textView.text, @"message",
                                      nil];
                
                [network sendHttpReq:HttpReq_MomentsComment andData:data];
            }

           
        }
        
        //--------------------------------------------------
        //键盘下落
        isButtonClicked = NO;
        textView.inputView = nil;
        isSystemBoardShow = NO;
        textView.text = @"";
        textView.frame = CGRectMake(43.0, 5.0, 205-15+40.0, 33);
        clickFlag = 0;
        [textView resignFirstResponder];
        toolBar.frame = CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height - 44 - 44, WIDTH, 44);
        [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                        forState:UIControlStateNormal];
        [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                        forState:UIControlStateHighlighted];
    }
}

// 自定义输入框点击输入框事件
-(void)clickTextView:(id)sender{
    
    if (textView.inputView!=nil) {
        isButtonClicked = YES;
        textView.inputView = nil;
        isSystemBoardShow = YES;
        clickFlag = 0;
        [textView resignFirstResponder];
    }else{
        [textView becomeFirstResponder];
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    //点击了非删除键
    if( [text length] == 0 ) {
        
//        if ( range.length > 1 ) {
//            
//            return YES;
//        }
//        else {
//            
//            [faceBoard backFace];
//            
//            return NO;
//        }
        
        return YES;

    }
    else {
        if (range.location >= 500) {// 校友圈回帖 500 2015.07.21
            return NO;
        }else {
//            if (_isFirstClickReply) {
//                self->textView.text = @"";
//                _isFirstClickReply = false;
//            }

            return YES;
        }

//        if ([text isEqualToString:@"\n"]){
//            isButtonClicked = NO;
//            [textView resignFirstResponder];
//            return NO;
//        }else{
//        }
        
    }
}

- (void)textViewDidChange:(UITextView *)_textView {
    
    _replyToLabel.text = _replyTo;
    
    if ([_textView.text length] == 0) {
        [_replyToLabel setHidden:NO];
    }else{
        [_replyToLabel setHidden:YES];
    }

    CGSize size = textView.contentSize;
    size.height -= 2;
    if ( size.height >= 68 ) {
        
        size.height = 68;
    }
    else if ( size.height <= 32 ) {
        
        size.height = 32;
    }
    
    if ( size.height != textView.frame.size.height ) {
        
        CGFloat span = size.height - textView.frame.size.height;
        
        CGRect frame = toolBar.frame;
        frame.origin.y -= span;
        frame.size.height += span;
        toolBar.frame = frame;
        
        CGFloat centerY = frame.size.height / 2;
        
        frame = textView.frame;
        frame.size = size;
        textView.frame = frame;
        
        CGPoint center = textView.center;
        center.y = centerY;
        textView.center = center;
        
    }
}

-(void)faceBoardClick:(id)sender{
    
    clickFlag = 1;
    isButtonClicked = YES;
    
    if ( isKeyboardShowing ) {
        
        [textView resignFirstResponder];
    }
    else {
        
        if ( isFirstShowKeyboard ) {
            
            isFirstShowKeyboard = NO;
            
            isSystemBoardShow = NO;
        }
        
        if ( !isSystemBoardShow ) {
            
            textView.inputView = faceBoard;
        }
        
        [textView becomeFirstResponder];
    }
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    isKeyboardShowing = YES;
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         
                         CGRect frame = _tableView.frame;
                         frame.size.height += keyboardHeight;
                         frame.size.height -= keyboardRect.size.height;
                         _tableView.frame = frame;
                         
                         
                         frame = toolBar.frame;
                         frame.origin.y += keyboardHeight;
                         frame.origin.y -= keyboardRect.size.height;
                         toolBar.frame = frame;
                         
                         keyboardHeight = keyboardRect.size.height;
                     }];
    
    if ( isFirstShowKeyboard ) {
        
        isFirstShowKeyboard = NO;
        
        isSystemBoardShow = !isButtonClicked;
    }
    
    if ( isSystemBoardShow ) {
        
        switch (clickFlag) {
            case 1:{
                [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                                forState:UIControlStateNormal];
                [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                                forState:UIControlStateHighlighted];
                
            }
                
                break;
            case 2:{
                [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                                forState:UIControlStateNormal];
                [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                                forState:UIControlStateHighlighted];
                
            }
                break;
            case 3:{
                
                [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                                forState:UIControlStateNormal];
                [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                                forState:UIControlStateHighlighted];
            }
                break;
                
            default:
                break;
        }
        
    }
    else {
        
        switch (clickFlag) {
            case 1:{
                
                [keyboardButton setImage:[UIImage imageNamed:@"btn_sr_d.png"]
                                forState:UIControlStateNormal];
                [keyboardButton setImage:[UIImage imageNamed:@"btn_sr_p.png"]
                                forState:UIControlStateHighlighted];
            }
                break;
            default:
                break;
        }
    }
    
    //    if ( discussArray.count ) {
    //
    //        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:discussArray.count - 1
    //                                                              inSection:0]
    //                          atScrollPosition:UITableViewScrollPositionBottom
    //                                  animated:NO];
    //    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
//    _replyToLabel.text = @"";
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGRect frame = _tableView.frame;
                         frame.size.height += keyboardHeight;
                         _tableView.frame = frame;
                         
                         frame = toolBar.frame;
                         frame.origin.y += keyboardHeight;
                         toolBar.frame = frame;
                         
                         keyboardHeight = 0;
                     }];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    
    isKeyboardShowing = NO;
//    isCommentComment = NO;
    //textView.text = @"";

    if ( isButtonClicked ) {
        
        isButtonClicked = NO;
        
        //        if ( ![textView.inputView isEqual:faceBoard] ) {
        //
        //            isSystemBoardShow = NO;
        //
        //            textView.inputView = faceBoard;
        //
        //        }
        //        else {
        //
        //            isSystemBoardShow = YES;
        //
        //            textView.inputView = nil;
        //        }
        
        
        
        
        switch (clickFlag) {
                
            case 1:{
                
                if ( [textView.inputView isEqual:faceBoard] || [textView.inputView isEqual:addImageView]) {
                    
                    isSystemBoardShow = YES;
                    textView.inputView = nil;
                    
                    UIImage *img = [UIImage imageNamed:@"btn_sr_d.png"];
                    
                    if ([Utilities image:keyboardButton.imageView.image equalsTo:img]) {
                        
                        isSystemBoardShow = YES;
                        textView.inputView = nil;
                    }else{
                        isSystemBoardShow = NO;
                        textView.inputView = faceBoard;
                        
                    }
                    
                    
                    
                }else{
                    
                    isSystemBoardShow = NO;
                    textView.inputView = faceBoard;
                    
                }
            }
                
                break;
            default:
                break;
        }
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        NSArray *childArray = [window.rootViewController childViewControllers];
        
        if ([childArray count] > 0) {
            if ([[childArray objectAtIndex:[childArray count]-1] isKindOfClass:[MJPhotoBrowser class]]) {
                
            }else{
                [textView becomeFirstResponder];
            }
        }else{
            [textView becomeFirstResponder];
        }
        
    }
}

-(void)dismissKeyboard{
    
    _replyTo = @"";
    //        _replyTo = [NSString stringWithFormat:@"回复%@: ", [dataDic objectForKey:@"name"]];
    _isFirstClickReply = true;
    
    _replyToLabel.text = _replyTo;
    [_replyToLabel setHidden:NO];
    
    self->textView.text = @"";
    isCommentComment = NO;
    
    [textView resignFirstResponder];
}

-(void)reloadData
{
    [_tableView reloadData];
//    [self setFooterView];
}

//----------------------------------------------------------------------------

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 134) {
        // 取消所有的网络请求
        [network cancelCurrentRequest];
        
        // 退回到上个画面
        [self.navigationController popViewControllerAnimated:YES];
    }else if(alertView.tag == 274) {
        {
            // 删除评论
            if (buttonIndex == 1) {
                
                [Utilities showProcessingHud:self.view];
               
                if ([@"classPhoto" isEqualToString:_fromName]) {
                    /**
                     * 班级相册图片评论删除
                     * @author luke
                     * @date 2016.03.17
                     * @args
                     *  v=3 ac=Kindergarten op=delClassTopicComment sid= cid= uid= tid=主题ID pid=评论ID
                     */
                    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                          @"Kindergarten",@"ac",
                                          @"3",@"v",
                                          @"delClassTopicComment", @"op",
                                          _tid,@"tid",
                                          _deletePid,@"pid",
                                          _cid,@"cid",
                                          nil];
                    
                    [network sendHttpReq:HttpReq_ClassNewPhotoRemoveComment andData:data];
                    
                }else{
                    
                    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                          @"Circle",@"ac",
                                          @"2",@"v",
                                          @"removeComment", @"op",
                                          _deletePid,@"pid",
                                          nil];
                    
                    [network sendHttpReq:HttpReq_MomentsRemoveComment andData:data];
                    
                }
              
                
            }
        }
    }else if (alertView.tag == 275) {
        if (buttonIndex == 1) {
            
            if ([_fromName isEqualToString:@"footmark"]) {
                
                /**
                 * 移除成长足迹中导入的记录
                 * @author luke
                 * @date 2015.12.30
                 * @args
                 *  v=3, ac=GrowingPath, op=cancel, sid=, cid=, uid=, path=成长足迹ID
                 */
                
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                             REQ_URL, @"url",
                                             @"GrowingPath",@"ac",
                                             @"3",@"v",
                                             @"cancel", @"op",
                                             _cid,@"cid",
                                             _path,@"path",
                                             nil];
                
                
                [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
                    
                    [Utilities dismissProcessingHud:self.view];
                    NSDictionary *respDic = (NSDictionary*)responseObject;
                    NSString *result = [respDic objectForKey:@"result"];
                    
                    if ([result integerValue] == 1) {
                        
                        NSLog(@"移除足迹:%@",respDic);
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadFootmarkList" object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                      
                    }else{
                        
                        NSString *msg = (NSString*)[respDic objectForKey:@"message"];
                        [Utilities showAlert:@"错误" message:msg cancelButtonTitle:@"确定" otherButtonTitle:nil];
                        
                    }
                
                    
                } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                    
                    [Utilities dismissProcessingHud:self.view];
                    [Utilities doHandleTSNetworkingErr:error descView:self.view];
                    
                }];

            }else if ([@"classPhoto" isEqualToString:_fromName]){
                /**
                 * 班级相册图片主题删除
                 * @author luke
                 * @date 2016.03.17
                 * @args
                 *  v=3 ac=Kindergarten op=delClassTopic sid= cid= uid= tid=主题ID app=
                 */
                [Utilities showProcessingHud:self.view];
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                      @"Kindergarten",@"ac",
                                      @"3",@"v",
                                      @"delClassTopic", @"op",
                                      _deleteTid,@"tid",
                                      _cid,@"cid",
                                      nil];
                
                [network sendHttpReq:HttpReq_ClassNewPhotoRemovePost andData:data];
                
            }else{
                
                [Utilities showProcessingHud:self.view];
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                      @"Circle",@"ac",
                                      @"2",@"v",
                                      @"removePost", @"op",
                                      _deleteTid,@"tid",
                                      nil];
                
                [network sendHttpReq:HttpReq_MomentsRemovePost andData:data];
            }
            
        }
    }else if (alertView.tag == 276) {
        if (buttonIndex == 1) {
            
            [Utilities showProcessingHud:self.view];
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                  @"Circle",@"ac",
                                  @"2",@"v",
                                  @"block", @"op",
                                  _deleteTid,@"tid",
                                  nil];
            
            [network sendHttpReq:HttpReq_MomentsBlockPost andData:data];
        }
    }
}

// 离线缓存 2015.05.14
-(void)getDataFromDB:(NSString*)type{
    
    DB_Dic =  [[MomentsDetailDBDao getDaoInstance] getData:type page:[NSString stringWithFormat:@"%ld",(long)page] momentID:_tid];
    
    //NSLog(@"DB_Dic:%@",DB_Dic);
    
    if (![Utilities isConnected]) {
        if ([DB_Dic count] == 0) {
            
            if (page == 0) {
                UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
                [self.view addSubview:noNetworkV];
                return;
            }
            
        }
    }
    
    if ([DB_Dic count] > 0) {
        
        NSDictionary* message_info = [DB_Dic objectForKey:@"message"];
        
        [dataDic setObject:[message_info objectForKey:@"id"] forKey:@"id"];
        [dataDic setObject:[message_info objectForKey:@"uid"] forKey:@"uid"];
        [dataDic setObject:[message_info objectForKey:@"avatar"] forKey:@"avatar"];
        [dataDic setObject:[message_info objectForKey:@"name"] forKey:@"name"];
        [dataDic setObject:[message_info objectForKey:@"message"] forKey:@"message"];
        [dataDic setObject:[message_info objectForKey:@"dateline"] forKey:@"dateline"];
        [dataDic setObject:[message_info objectForKey:@"pics"] forKey:@"pics"];
        [dataDic setObject:[message_info objectForKey:@"like"] forKey:@"like"];
        [dataDic setObject:[message_info objectForKey:@"loved"] forKey:@"loved"];
        [dataDic setObject:[message_info objectForKey:@"blocked"] forKey:@"blocked"];
        [dataDic setObject:[message_info objectForKey:@"privilege"] forKey:@"privilege"];
        //----add by kate----------------------------------------
        NSLog(@"classess:%@",[message_info objectForKey:@"classes"]);
        
        // shared links
        [dataDic setObject:[Utilities replaceNull:[message_info objectForKey:@"shareUrl"]] forKey:@"shareUrl"];
        [dataDic setObject:[Utilities replaceNull:[message_info objectForKey:@"shareSnapshot"]] forKey:@"shareSnapshot"];
        [dataDic setObject:[Utilities replaceNull:[message_info objectForKey:@"shareContent"]] forKey:@"shareContent"];
        
        if ([message_info objectForKey:@"classes"] != nil) {
            [dataDic setObject:[message_info objectForKey:@"classes"] forKey:@"classes"];
            [dataDic setObject:[message_info objectForKey:@"cids"] forKey:@"cids"];
        }
        //-----------------------------------------------------
        
        // 将评论内容转化为动态数组
        NSDictionary *commentsDic = [message_info objectForKey:@"comments"];
        NSMutableDictionary *comments_tempDic = [NSMutableDictionary dictionary];
        
        [comments_tempDic setObject:[commentsDic objectForKey:@"page"] forKey:@"page"];
        [comments_tempDic setObject:[commentsDic objectForKey:@"size"] forKey:@"size"];
        [comments_tempDic setObject:[commentsDic objectForKey:@"count"] forKey:@"count"];
        
        NSArray *comment_temp = [commentsDic objectForKey:@"list"];
        //            NSMutableArray *arrComments = [NSMutableArray array];
        
        for (NSObject *object in comment_temp) {
            
            NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
            NSDictionary *dic = (NSDictionary *)object;
            
            [dic1 addEntriesFromDictionary:dic];
            [commentsArr addObject:dic1];
            
        }
        
        [comments_tempDic setObject:commentsArr forKey:@"list"];
        
        // 将喜欢的人转换为动态数组
        NSArray *oriArrLoves = [message_info objectForKey:@"loves"];
        NSMutableArray *arrLoves = [NSMutableArray array];
        
        for (NSObject *object in oriArrLoves) {
            NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
            NSDictionary *dic = (NSDictionary *)object;
            
            [dic1 addEntriesFromDictionary:dic];
            [arrLoves addObject:dic1];
        }
        
        [dataDic setObject:arrLoves forKey:@"loves"];
        [dataDic setObject:comments_tempDic forKey:@"comments"];
        
        [self doShowMomentsDetailHeaderView];
        [self calcCellHeighti];

    }else{
        
    }

    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
    
    [_tableView reloadData];
    
    //------add by kate---------------------------------------
    // 权限设置右侧按钮
    NSString *tUid = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"uid"]];
    NSString *uid = [[g_userInfo getUserDetailInfo] objectForKey:@"uid"];
    
    if ([_fromName isEqualToString:@"footmark"]) {
        
        NSString *usertype = [NSString stringWithFormat:@"%@",[[g_userInfo getUserDetailInfo] objectForKey:@"role_id"]];
        //学生家长有设置权限 其他身份没有 吴宁确认2015.12.29
        if ([usertype integerValue] == 0 || [usertype integerValue] == 6) {
            
            if([tUid length] != 0){
                if ([tUid isEqual: uid]) {
                    // 如果是自己发的
                    [self setCustomizeRightButton:@"icon_more.png"];
                    
                }
            }
        }

    }else{
        if([tUid length] != 0){
            if ([tUid isEqual: uid]) {
                // 如果是自己发的
                [self setCustomizeRightButton:@"icon_more.png"];
                
            }
        }
    }
    
    //-------------------------------------------------------
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
        [menuController setTargetRect:gestureRecognizer.view.frame inView:self.view];
        [menuController setMenuVisible:YES animated:YES];
    }
}

// 复制
-(void)menuCopy:(UIMenuController *)menuController{
    NSString *content = _ohAttributeLabel.msgComment;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:content];
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(menuCopy:)) {
        return YES;
    }else {
        return NO;
    }
}

- (IBAction)webLink_click:(id)sender
{
    
    NSString *a;
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

- (BOOL)shouldAutorotate
{
    //return [self.topViewController shouldAutorotate];
    return YES;
}

@end
