//
//  KnowledgeDetailViewController.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-2-28.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "KnowledgeDetailViewController.h"
#import "SingleWebViewController.h"

@interface KnowledgeDetailViewController ()

@end

@implementation KnowledgeDetailViewController

@synthesize tid;
@synthesize subuid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [super setCustomizeTitle:@"知识库详情"];
    
    network = [NetworkUtility alloc];
    network.delegate = self;
    
    likeFlag = 0;
    collectionFlag = 0;
    
    [Utilities showProcessingHud:self.view];//2015.05.12
    
    
    [ReportObject event:ID_OPEN_WIKI_DETAIL];//2015.06.24
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super hideLeftAndRightLine];
    [super setCustomizeLeftButton];
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[ UIScreen mainScreen] .applicationFrame] ;
    self.view = view;
    
    [self performSelector:@selector(doGetProfile) withObject:nil afterDelay:0.1];
}

-(void)doGetProfile
{
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Wiki",@"ac",
                          @"2",@"v",
                          @"wikiItem", @"op",
                          tid, @"kid",
                          nil];
    
    [network sendHttpReq:HttpReq_KnowledgeWikiItemDeatil andData:data];
}

-(void)selectLeftAction:(id)sender
{
    [network cancelCurrentRequest];

    // 退回到上个画面
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImage*)resizeImage:(UIImage*)raw andSize:(CGSize)resize
{
    UIImage *sizedImage;
    
    UIGraphicsBeginImageContext(resize);
    NSInteger iconWidth = 20;
    [raw drawInRect:CGRectMake((resize.width-iconWidth)/2 - 15, (resize.height-iconWidth)/2,iconWidth,iconWidth)];
    
    sizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return sizedImage;
}

- (UIButton *)createButton:(CGRect)rect andName:(NSString*)name andTag:(NSInteger)tag
{
    // 创建button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.tag = tag;

    //设置title自适应对齐
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:9.0f];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    CGSize buttonSize;
    buttonSize.width = 70;
    buttonSize.height = 40;
    
    UIImage *image_home_d;
    UIImage *image_home_p;
    
    if (1 == tag) {
        image_home_d = [UIImage imageNamed:@"knowledge/icon_gx_d.png"];
        image_home_p = [UIImage imageNamed:@"knowledge/icon_gx_p.png"];
    } else if (2 == tag) {
        image_home_d = [UIImage imageNamed:@"knowledge/icon_mybz_d.png"];
        image_home_p = [UIImage imageNamed:@"knowledge/icon_mybz_p.png"];
    } else if (3 == tag) {
        
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];//add by kate 2015.07.01
        image_home_d = [UIImage imageNamed:@"knowledge/icon_sc_d.png"];
        image_home_p = [UIImage imageNamed:@"knowledge/icon_sc_p.png"];
    } else if (4 == tag) {

        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];//add by kate 2015.07.01
        image_home_d = [UIImage imageNamed:@"knowledge/icon_pl_d.png"];
        image_home_p = [UIImage imageNamed:@"knowledge/icon_pl_p.png"];
    }
//---update by kate 2015.07.01-------------------------------------------------------
//    UIImage *newImage_home_d = [self resizeImage:image_home_d andSize:buttonSize];
//    UIImage *newImage_home_p = [self resizeImage:image_home_p andSize:buttonSize];
    
//    [button setBackgroundImage:newImage_home_d forState:UIControlStateNormal] ;
//    [button setBackgroundImage:newImage_home_p forState:UIControlStateHighlighted] ;
    
    UIImage *newImage_home_d = image_home_d;
    UIImage *newImage_home_p = image_home_p;
    
    [button setImage:newImage_home_d forState:UIControlStateNormal] ;
    [button setImage:newImage_home_p forState:UIControlStateHighlighted] ;
    //--------------------------------------------------------------------------
    


//    if (1 == tag) {
//        [button setBackgroundImage:[UIImage imageNamed:@"knowledge/icon_gx_d.png"] forState:UIControlStateNormal] ;
//        [button setBackgroundImage:[UIImage imageNamed:@"knowledge/icon_gx_p.png"] forState:UIControlStateHighlighted] ;
//    } else if (2 == tag) {
//        [button setBackgroundImage:[UIImage imageNamed:@"knowledge/icon_mybz_d.png"] forState:UIControlStateNormal] ;
//        [button setBackgroundImage:[UIImage imageNamed:@"knowledge/icon_mybz_p.png"] forState:UIControlStateHighlighted] ;
//    } else if (3 == tag) {
//        [button setBackgroundImage:[UIImage imageNamed:@"knowledge/icon_sc_d.png"] forState:UIControlStateNormal] ;
//        [button setBackgroundImage:[UIImage imageNamed:@"knowledge/icon_sc_p.png"] forState:UIControlStateHighlighted] ;
//    } else if (4 == tag) {
//        [button setBackgroundImage:[UIImage imageNamed:@"knowledge/icon_pl_d.png"] forState:UIControlStateNormal] ;
//        [button setBackgroundImage:[UIImage imageNamed:@"knowledge/icon_pl_p.png"] forState:UIControlStateHighlighted] ;
//    }
    
    // 添加 action
    [button addTarget:self action:@selector(btnclick1:) forControlEvents: UIControlEventTouchUpInside];
    
    // 设置title
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitle:name forState:UIControlStateHighlighted];
    
    return button;
}

-(void)doShowUserView
{
    // 背景图片
//    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,imgView_line2.frame.origin.y + 2,320,[UIScreen mainScreen].applicationFrame.size.height)];
//    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
//    [self.view addSubview:imgView_bgImg];
    

    CGRect rect;
    // 设置背景scrollView
    if (iPhone5)
    {
        rect = CGRectMake(0, 0, WIDTH , [UIScreen mainScreen].applicationFrame.size.height - 44);
    }
    else
    {
        rect = CGRectMake(0, 0, WIDTH , [UIScreen mainScreen].applicationFrame.size.height - 44);
    }
    _scrollerView = [[UIScrollView alloc] initWithFrame:rect];
    
    if (iPhone5)
    {
        _scrollerView.contentSize = CGSizeMake(WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44);
    }
    else
    {
        _scrollerView.contentSize = CGSizeMake(WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 20);
    }
    
    _scrollerView.scrollEnabled = YES;
    _scrollerView.delegate = self;
    _scrollerView.bounces = YES;
    _scrollerView.alwaysBounceHorizontal = NO;
    _scrollerView.alwaysBounceVertical = YES;
    _scrollerView.directionalLockEnabled = YES;
    [self.view addSubview:_scrollerView];
    
    // 头像
    imgView =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                          35,
                                                          15,
                                                          65,
                                                          65)];
    imgView.contentMode = UIViewContentModeScaleToFill;
    imgView.layer.masksToBounds = YES;
    imgView.layer.cornerRadius = 65/2;
    [_scrollerView addSubview:imgView];
    
    // 姓名
    label_name = [[UILabel alloc] initWithFrame:CGRectMake(
                                                           imgView.frame.origin.x + imgView.frame.size.width + 15,
                                                           imgView.frame.origin.y+10,
                                                           190,
                                                           20)];
    label_name.textColor = [UIColor blackColor];
    label_name.backgroundColor = [UIColor clearColor];
    label_name.font = [UIFont systemFontOfSize:16.0f];
    [_scrollerView addSubview:label_name];
    
    // 学校
    label_school = [[UILabel alloc] initWithFrame:CGRectMake(
                                                           label_name.frame.origin.x,
                                                           label_name.frame.origin.y + label_name.frame.size.height + 1,
                                                           190,
                                                           20)];
    label_school.textColor = [UIColor grayColor];
    label_school.backgroundColor = [UIColor clearColor];
    label_school.font = [UIFont systemFontOfSize:13.0f];
    [_scrollerView addSubview:label_school];

    _button_toAuthor = [UIButton buttonWithType:UIButtonTypeCustom];
    _button_toAuthor.frame = CGRectMake(0, 0, WIDTH, imgView.frame.origin.y + imgView.frame.size.height + 9);
    [_button_toAuthor addTarget:self action:@selector(toAuthor_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    [_scrollerView addSubview:_button_toAuthor];

    // 头像下方比较短的那个线
    UIImageView *imgView_line1 =[[UIImageView alloc]initWithFrame:CGRectMake(20,
                                                                             imgView.frame.origin.y + imgView.frame.size.height + 10,
                                                                             WIDTH-40,
                                                                             1)];
    [imgView_line1 setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
    [_scrollerView addSubview:imgView_line1];

    // 感谢button
    button_thanks = [self createButton:CGRectMake(
                                                  imgView_line1.frame.origin.x,
                                                  imgView_line1.frame.origin.y + 2,
                                                  70,
                                                  40) andName:@"" andTag:1];
    [_scrollerView addSubview:button_thanks];

    // button中间的线
    UIImageView *imgView_line_1 =[[UIImageView alloc]initWithFrame:CGRectMake(button_thanks.frame.origin.x + button_thanks.frame.size.width,button_thanks.frame.origin.y + 4,1,32)];
    [imgView_line_1 setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
    [_scrollerView addSubview:imgView_line_1];

    // 没有帮助button
    button_noHelp = [self createButton:CGRectMake(
                                                  button_thanks.frame.origin.x + button_thanks.frame.size.width,
                                                  button_thanks.frame.origin.y,
                                                  70,
                                                  40) andName:@"" andTag:2];
    [_scrollerView addSubview:button_noHelp];

    // button中间的线
    UIImageView *imgView_line_2 =[[UIImageView alloc]initWithFrame:CGRectMake(button_noHelp.frame.origin.x + button_noHelp.frame.size.width,button_noHelp.frame.origin.y + 4,1,32)];
    [imgView_line_2 setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
    [_scrollerView addSubview:imgView_line_2];

    // 收藏button
    button_collection = [self createButton:CGRectMake(
                                                  button_noHelp.frame.origin.x + button_noHelp.frame.size.width,
                                                  button_noHelp.frame.origin.y,
                                                  70,
                                                  40) andName:@"收藏" andTag:3];
    [_scrollerView addSubview:button_collection];
    
    // button中间的线
    UIImageView *imgView_line_3 =[[UIImageView alloc]initWithFrame:CGRectMake(button_collection.frame.origin.x + button_collection.frame.size.width,button_collection.frame.origin.y + 4,1,32)];
    [imgView_line_3 setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
    [_scrollerView addSubview:imgView_line_3];

    // 评论button
    button_comment = [self createButton:CGRectMake(
                                                  button_collection.frame.origin.x + button_collection.frame.size.width,
                                                  button_collection.frame.origin.y,
                                                  70,
                                                  40) andName:@"评论" andTag:4];
    [_scrollerView addSubview:button_comment];

    // 头像下方比较长的那个线
    imgView_line2 =[[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                             imgView_line1.frame.origin.y + imgView_line1.frame.size.height + 40,
                                                                             WIDTH,
                                                                             1)];
    [imgView_line2 setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
    [_scrollerView addSubview:imgView_line2];

//    imgView_bgImg.frame = CGRectMake(0,imgView_line2.frame.origin.y + 2,320,[UIScreen mainScreen].applicationFrame.size.height);
    
    // 标题
    _label_title = [[UILabel alloc] initWithFrame:CGRectMake(
                                                             20,
                                                             imgView_line2.frame.origin.y + imgView_line2.frame.size.height+10,
                                                             280,
                                                             0)];
    _label_title.textColor = [UIColor blackColor];
    _label_title.backgroundColor = [UIColor clearColor];
    _label_title.font = [UIFont systemFontOfSize:16.0f];
    _label_title.lineBreakMode = NSLineBreakByWordWrapping;
    _label_title.numberOfLines = 0;
    [_scrollerView addSubview:_label_title];

    // 正文内容
    webViewContent = [[UIWebView alloc]initWithFrame:CGRectMake(
                                                                0,
                                                                _label_title.frame.origin.y + _label_title.frame.size.height+5,
                                                                WIDTH,
                                                                0)];
//    webViewContent.backgroundColor = [[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0];
    webViewContent.backgroundColor = [UIColor whiteColor];

    webViewContent.opaque = NO;
    webViewContent.delegate = self;
    
    [webViewContent setUserInteractionEnabled:YES];//是否支持交互

    //禁止UIWebView拖动
    [(UIScrollView *)[[webViewContent subviews] objectAtIndex:0] setBounces:NO];
    //设置UIWebView是按 WebView自适应大小显示,还是按正文内容的大小来显示,YES:表示WebView自适应大小,NO:表示按正文内容的大小来显示
    [webViewContent setScalesPageToFit:NO];
//    [webViewContent loadHTMLString:msg baseURL:nil];
    [_scrollerView addSubview:webViewContent];

    [self addTapOnWebView];
}

- (IBAction)toAuthor_btnclick:(id)sender
{
    AuthorZoneViewController *azv = [[AuthorZoneViewController alloc]init];
    azv.tid = _model.uid;
    [self.navigationController pushViewController:azv animated:YES];
}

- (IBAction)btnclick1:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    
    if(1 == btn.tag) {
        if(0 == likeFlag)
        {
//            if(([[NSString stringWithFormat:@"%@",[detailInfo objectForKey:@"isLikeClicked"]] isEqual: @"1"]) ||
//               ([[NSString stringWithFormat:@"%@",[detailInfo objectForKey:@"isNoHelpClicked"]]  isEqual: @"1"]))
//            {
//                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
//                                                               message:@"您已评价过该文章。"
//                                                              delegate:nil
//                                                     cancelButtonTitle:@"确定"
//                                                     otherButtonTitles:nil];
//                [alert show];
//
//            }
//            else
//            {
            
                [ReportObject event:ID_LIKE_WIKI];//2015.06.24
                [Utilities showProcessingHud:self.view];//2015.05.12
                _goodOrBadClicked = @"good";
            
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      REQ_URL, @"url",
                                      @"MyWiki",@"ac",
                                      @"2",@"v",
                                      @"reviewWiki", @"op",
                                      tid, @"kid",
                                      @"1", @"review",
                                      nil];
            
                [network sendHttpReq:HttpReq_WikiLikeOrNot andData:data];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"您已评价过该文章。"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }else if (2 == btn.tag) {
        if(0 == likeFlag)
        {
//            if(([[NSString stringWithFormat:@"%@",[detailInfo objectForKey:@"isLikeClicked"]] isEqual: @"1"]) ||
//               ([[NSString stringWithFormat:@"%@",[detailInfo objectForKey:@"isNoHelpClicked"]]  isEqual: @"1"]))
//            {
//                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
//                                                               message:@"您已评价过该文章。"
//                                                              delegate:nil
//                                                     cancelButtonTitle:@"确定"
//                                                     otherButtonTitles:nil];
//                [alert show];
//
//            }
//            else
//            {
            [ReportObject event:ID_UNLIKE_WIKI];//2015.06.24
                [Utilities showProcessingHud:self.view];//2015.05.12
                _goodOrBadClicked = @"bad";

                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      REQ_URL, @"url",
                                      @"MyWiki",@"ac",
                                      @"2",@"v",
                                      @"reviewWiki", @"op",
                                      tid, @"kid",
                                      @"0", @"review",
                                      nil];
            
                [network sendHttpReq:HttpReq_WikiLikeOrNot andData:data];

//            }
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"您已评价过该文章。"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }else if (3 == btn.tag) {
        
        [ReportObject event:ID_COLLECT_WIKI];
        [Utilities showProcessingHud:self.view];//2015.05.12
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"MyWiki",@"ac",
                              @"2",@"v",
                              @"addFavoriteWiki", @"op",
                              tid, @"kid",
                              nil];
        
        [network sendHttpReq:HttpReq_WikiFavorite andData:data];
    }else if (4 == btn.tag) {
        
        KnowledgeCommentViewController *commentViewCtrl = [[KnowledgeCommentViewController alloc] init];
//        commentViewCtrl.data = detailInfo;
        commentViewCtrl.kid = _model.kid;
        commentViewCtrl.detail_model = _model;
        [self.navigationController pushViewController:commentViewCtrl animated:YES];
    }
}

- (IBAction)collectDetail_btnclick:(id)sender
{
    
    [Utilities showProcessingHud:self.view];//2015.05.12

    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          AC_WIKI, @"url",
                          @"follow", @"op",
                          subuid, @"subuid",
                          nil];

    [network sendHttpReq:HttpReq_WikiFollow andData:data];
}

-(void)doShowUserInfo
{
    label_name.text = _model.name;
    label_school.text = _model.school;
    _label_title.text = _model.title;

    CGSize msgSize;
    if (![@""  isEqual: _model.title]) {
        msgSize = [Utilities getStringHeight:_model.title andFont:[UIFont systemFontOfSize:16]  andSize:CGSizeMake([UIScreen mainScreen].applicationFrame.size.width, 0)];
    }
    _label_title.frame = CGRectMake(
                                    20,
                                    imgView_line2.frame.origin.y + imgView_line2.frame.size.height+10,
                                    280,
                                    msgSize.height);
    
    webViewContent.frame = CGRectMake(
                                      0,
                                      _label_title.frame.origin.y + _label_title.frame.size.height+5,
                                      WIDTH,
                                      0);

    //---update by kate 2014.11.14----------------------------------------------------------
    //Utilities *util = [Utilities alloc];
    //NSString* head_url = [util getAvatarFromUid:[detailInfo objectForKey:@"uid"] andType:@"1"];
    NSString *head_url = _model.avatar;
    [imgView sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];
    //------------------------------------------------------------------------------------
    
    [webViewContent loadHTMLString:_model.content baseURL:nil];

    [button_noHelp setTitle:[NSString stringWithFormat:@"%@", _model.bad] forState:UIControlStateNormal];
    [button_thanks setTitle:[NSString stringWithFormat:@"%@", _model.good] forState:UIControlStateNormal];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    CGRect newFrame = webView.frame;
    newFrame.size.height = actualSize.height;
    webView.frame = newFrame;
    NSString *string = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
    webHight = [string floatValue];
    
    [webViewContent setFrame:CGRectMake(
                                        0,
                                        _label_title.frame.origin.y + _label_title.frame.size.height+5,
                                        WIDTH,
                                        webHight)];
    
    _scrollerView.contentSize = CGSizeMake(WIDTH, webHight + imgView_line2.frame.origin.y + _label_title.frame.size.height + 2);
//    [_scrollerView setFrame:CGRectMake(
//                                       0,
//                                       0,
//                                       320,
//                                       webHight + 1136)];
    
    webViewContentHiden.hidden = true;
}


#if 0
-(void)addTapOnWebView
{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [webViewContent addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}

#pragma mark- TapGestureRecognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    
    CGPoint pt = [sender locationInView:webViewContent];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).href", pt.x, pt.y];
    //NSString *urlToSave = [self.showWebView stringByEvaluatingJavaScriptFromString:imgURL];
    NSString *urlToSave = [webViewContent stringByEvaluatingJavaScriptFromString:imgURL];
    aaa = urlToSave;
    //NSLog(@"image url=%@", urlToSave);
    if (urlToSave.length > 0) {
        
        if([urlToSave rangeOfString:@"face"].location == NSNotFound )//非表情图片
        {
            //[self showImageURL:urlToSave point:pt];
            
#if 0
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  urlToSave, @"url",
                                  nil];
            
            [network sendHttpReq:HttpReq_GetFile andData:data];
#endif

            
            
#if 0
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:urlToSave] options:0 progress:^(NSUInteger receivedSize, long long expectedSize)
             {
                 
             } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
             {
                 if (image && finished)
                 {
                     //获取Documents文件夹目录
                     NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                     NSString *documentPath = [path objectAtIndex:0];
                     //指定新建文件夹路径
                     NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"zhixiaofile"];
                     //创建ImageFile文件夹
                     [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
                     //保存图片的路径
                     NSString *filePath = [imageDocPath stringByAppendingPathComponent:@"file"];
                     
                     //保存
                     [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
                 }
             }];
#endif

#if 0
            QLPreviewController *previewoCntroller = [[QLPreviewController alloc] init];
            
            PreviewDataSource *dataSource = [[PreviewDataSource alloc]init];
            dataSource.path=urlToSave;
            previewoCntroller.dataSource=dataSource;
            [self.navigationController pushViewController: previewoCntroller animated:YES];
            [previewoCntroller setTitle:@"aaaa"];
            previewoCntroller.navigationItem.rightBarButtonItem=nil;
#endif
            
            
            
//            QLPreviewController *previewController = [[QLPreviewController alloc] init];
//            previewController.dataSource = self;
//            previewController.delegate = self;
//            previewController.currentPreviewItemIndex = 0;
//            [[self navigationController] pushViewController:previewController animated:YES];
            
#if 1
            EduModuleDetailViewController *detailViewCtrl = [[EduModuleDetailViewController alloc] init];
            detailViewCtrl.detailInfo = aaa;
            detailViewCtrl.titlea = @"内容";
            [self.navigationController pushViewController:detailViewCtrl animated:YES];
#endif

//            NSString *imgUrl = urlToSave;
            int a = 0 ;
//            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//            // 弹出相册时显示的第一张图片是点击的图片
//            browser.currentPhotoIndex = 0;
//            // 设置所有的图片。photos是一个包含所有图片的数组。
//            
//            //NSArray *photo1 = [[NSArray alloc] initWithObjects:imgUrl,nil];;
//            NSMutableArray *photos = [[NSMutableArray alloc] init];
//            
//            MJPhoto *photo = [[MJPhoto alloc] init];
//            photo.save = NO;
//            photo.url = [NSURL URLWithString:imgUrl]; // 图片路径
//            [photos addObject:photo];
//            browser.photos = photos;
//            [browser show];
            
        }
        
    }
}
#endif

-(void)addTapOnWebView
{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [webViewContent addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}

#pragma mark- TapGestureRecognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    
    CGPoint pt = [sender locationInView:webViewContent];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    //NSString *urlToSave = [self.showWebView stringByEvaluatingJavaScriptFromString:imgURL];
    NSString *urlToSave = [webViewContent stringByEvaluatingJavaScriptFromString:imgURL];
    //NSLog(@"image url=%@", urlToSave);
    if (urlToSave.length > 0) {
        
        if([urlToSave rangeOfString:@"face"].location == NSNotFound )//非表情图片
        {
            //[self showImageURL:urlToSave point:pt];
            
            NSString *imgUrl = urlToSave;
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.backgroundColor = [UIColor clearColor];
            if(IS_IPHONE_5){
                imageView.image = [UIImage imageNamed:@"placeholderImage_large.png"];
            }else{
                imageView.image = [UIImage imageNamed:@"placeholderImage_small.png"];
            }
            
            
            NSInteger pos = [Utilities findStringPositionInArray:_model.pics andStr:urlToSave];
            
            if (-1 != pos) {
                MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
                browser.currentPhotoIndex = pos;
                
                NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[_model.pics count]];
                
                for (int i = 0; i<[_model.pics count]; i++) {
                    NSString *pic_url = [_model.pics objectAtIndex:i];
                    
                    MJPhoto *photo = [[MJPhoto alloc] init];
                    photo.save = NO;
                    photo.url = [NSURL URLWithString:pic_url];
                    photo.srcImageView = imageView;
                    [photos addObject:photo];
                }
                
                browser.photos = photos;
                [browser show];
            }

#if 0
            // 1.封装图片数据
            //设置所有的图片。photos是一个包含所有图片的数组。
            NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.save = NO;
            photo.url = [NSURL URLWithString:imgUrl]; // 图片路径
            photo.srcImageView = imageView; // 来源于哪个UIImageView
            [photos addObject:photo];
            
            // 2.显示相册
            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
            browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
            browser.photos = photos; // 设置所有的图片
            [browser show];
#endif
        }
    }
}

#pragma mark - UIWebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *requestURL =[request URL];
    
    NSString *urlStr = [requestURL resourceSpecifier];
    NSArray *arrayDot = [urlStr componentsSeparatedByString:@"."];
    NSString *type = [arrayDot objectAtIndex:[arrayDot count]-1];

//    NSString *scheme = [requestURL scheme];
    if (([[requestURL scheme] isEqualToString: @"http"] || [[requestURL scheme] isEqualToString:@"https"] || [[requestURL scheme] isEqualToString: @"mailto" ]) && (navigationType == UIWebViewNavigationTypeLinkClicked)) {
        
        if (([@"rar"  isEqual: type]) ||
            ([@"zip"  isEqual: type]))
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"不支持此格式，无法打开。"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }else if (([@"txt"  isEqual: type]) ||
                  ([@"doc"  isEqual: type]) ||
                  ([@"docx"  isEqual: type]) ||
                  ([@"xls"  isEqual: type]) ||
                  ([@"xlsx"  isEqual: type]) ||
                  ([@"pptx"  isEqual: type]) ||
                  ([@"ppt"  isEqual: type]) ||
                  ([@"pdf"  isEqual: type]) ||
                  ([@"png"  isEqual: type]) ||
                  ([@"jpg"  isEqual: type]) ||
                  ([@"gif"  isEqual: type])) {
            // 为了使iOS 7以及以下可以在app内部打开文件，这里再做个判断
#if 0
            FileViewerViewController *fileViewer = [[FileViewerViewController alloc] init];
            fileViewer.requestURL = requestURL;
            fileViewer.titlea = @"内容";
#endif
            // 2015.09.23
            SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
            fileViewer.webType = SWFile;
            fileViewer.url = requestURL;
            fileViewer.titleName = @"内容";
            
            [self.navigationController pushViewController:fileViewer animated:YES];
        }else {
            // 网页的话，iOS 8以上就可以内部打开，以下去safari
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
#if 0
                FileViewerViewController *fileViewer = [[FileViewerViewController alloc] init];
                fileViewer.requestURL = requestURL;
                fileViewer.titlea = @"内容";
#endif
                // 2015.09.23
                SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                fileViewer.webType = SWFile;
                fileViewer.url = requestURL;
                fileViewer.titleName = @"内容";
                
                [self.navigationController pushViewController:fileViewer animated:YES];
            }else {
                [[UIApplication sharedApplication] openURL:requestURL];
            }
        }

        return NO;
    }else {
        return YES;
    }
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
  
    [Utilities dismissProcessingHud:self.view];// 2015.05.12
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if([@"WikiAction.wikiItem"  isEqual: [resultJSON objectForKey:@"protocol"]])
    {
        if(true == [result intValue])
        {
            //将JSON数据和Model的属性进行绑定
            _model = [MTLJSONAdapter modelOfClass:[KnowledgeDetailModel class]
                               fromJSONDictionary:resultJSON
                                            error:&error];
            
//            _pics = [thread objectForKey:@"pics"];

            // 先显示在一个隐藏的webview中，可以先计算webview的高度
            webViewContentHiden = [[UIWebView alloc]initWithFrame:CGRectMake(0.400, 100.0, WIDTH, 100)];
            webViewContentHiden.backgroundColor = [UIColor clearColor];
            webViewContentHiden.opaque = NO;
            webViewContentHiden.delegate = self;
            [(UIScrollView *)[[webViewContentHiden subviews] objectAtIndex:0] setBounces:NO];
            //设置UIWebView是按 WebView自适应大小显示,还是按正文内容的大小来显示,YES:表示WebView自适应大小,NO:表示按正文内容的大小来显示
            [webViewContentHiden setScalesPageToFit:NO];
            [webViewContentHiden loadHTMLString:_model.content baseURL:nil];
            
            // 显示用户view
            [self doShowUserView];
            
            // 显示用户信息
            [self doShowUserInfo];
            
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"获取知识库错误，请重试"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
    else if ([@"MyWikiAction.addFavoriteWiki"  isEqual: [resultJSON objectForKey:@"protocol"]])
    {
        // 收藏结果
        NSString* message_info = [resultJSON objectForKey:@"message"];
        
        if(true == [result intValue]) {
            collectionFlag = 1;
            //[MBProgressHUD showSuccess:message_info toView:nil];
            [Utilities showSuccessedHud:message_info descView:self.view];//2015.05.12
        }else {
            //[MBProgressHUD showError:message_info toView:nil];
            [Utilities showFailedHud:message_info descView:self.view];//2015.05.12
        }
    }
    else if ([@"MyWikiAction.reviewWiki"  isEqual: [resultJSON objectForKey:@"protocol"]])
    {
        // 赞或者不喜欢结果
        NSString* message_info = [resultJSON objectForKey:@"message"];
        
        if(true == [result intValue]) {
            //[MBProgressHUD showSuccess:message_info toView:nil];
            [Utilities showSuccessedHud:message_info descView:self.view];//2015.05.12
            if ([@"good" isEqualToString:_goodOrBadClicked]) {
                [button_thanks setTitle:[NSString stringWithFormat:@"%ld", [_model.good integerValue] + 1] forState:UIControlStateNormal];
            }else {
                [button_noHelp setTitle:[NSString stringWithFormat:@"%ld", [_model.bad integerValue] + 1] forState:UIControlStateNormal];
            }
        }else {
            //[MBProgressHUD showError:message_info toView:nil];
            [Utilities showFailedHud:message_info descView:self.view];//2015.05.12
        }
    }
    else if (HttpReq_WikiFollow == type)
    {
        NSString* message_info = [resultJSON objectForKey:@"message"];
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:message_info
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
        
        collectionFlag = 1;
    }
    else if (HttpReq_WikiLikeOrNot == type)
    {
        // todo 写新的接收判断
        NSString* message_info = [resultJSON objectForKey:@"message"];
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:message_info
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
        
        [button_thanks setTitle:[NSString stringWithFormat:@"%ld", [_model.good integerValue]] forState:UIControlStateNormal];
        
        likeFlag = 1;
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

@end
