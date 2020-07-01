//
//  TestReportDetailViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/12/4.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "TestReportDetailViewController.h"
#import "FriendProfileViewController.h"
#import "TSTouchLabel.h"

@interface TestReportDetailViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TestReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeTitle:@"体测报告详情"];
    [self setCustomizeLeftButton];
   
    [ReportObject event:ID_OPEN_PHYSICAL_DETAIL];

    //[self setCustomizeRightButtonWithName:@"评测标准" font:[UIFont systemFontOfSize:12.0]];
    
    if (![Utilities isConnected]) {//2015.12.07
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
        [self.view addSubview:noNetworkV];
        return;
    }
    
    winSize = [[UIScreen mainScreen] bounds].size;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view.hidden = YES;
    
    _isFirstClickReply = false;
    commentHeightArr = [[NSMutableArray alloc] init];
    commentsArray = [[NSMutableArray alloc]init];
    _deleteTid = _pid;
    
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
    
    [self getData];
    
    if ([usertype integerValue] == 0 || [usertype integerValue] == 6) {
        _replyTo = @"您可在这里与班主任留言互动哦!";
        [self setCustomizeRightButtonWithName:@"标准"];// 教师身份不可查看体测标准
        
    }else{
        _replyTo = @"您可在这里与学生/家长留言互动哦!";
    }
    
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.tableHeaderView = _scrollView;
    
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    singleTouch.delegate = self;
    [self.view addGestureRecognizer:singleTouch];
    
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
    
    
    [self showCustomKeyBoard];
    
    
}


-(void)showCustomKeyBoard{
    
    // 自定义数据框
    toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height - 44 - 44, [UIScreen mainScreen].applicationFrame.size.width, 44)];
    toolBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, 1)];
    topLine.image = [UIImage imageNamed:@"lineSystem.png"];
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(43.0, 5.0, [UIScreen mainScreen].bounds.size.width - 60 - 33, 33)];
    textView.delegate = self;
    textView.backgroundColor = [UIColor clearColor];
    //textView.returnKeyType = UIReturnKeyDone;
    
    UIImage *rawEntryBackground = [UIImage imageNamed:@"friend/bg_message_entry_InputField2.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:15 topCapHeight:21];
    entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(43.0, 5, [UIScreen mainScreen].bounds.size.width - 60 - 33, 33);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    entryImageView.userInteractionEnabled = YES;
    
    _replyToLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, textView.frame.size.width - 10.0, 20)];
    _replyToLabel.enabled = NO;
    //_replyToLabel.text = @"";
    _replyToLabel.text = _replyTo;
    _replyToLabel.font =  [UIFont systemFontOfSize:13];
    _replyToLabel.textColor = [UIColor grayColor];
    [textView addSubview:_replyToLabel];
    
    [toolBar addSubview:entryImageView];
    [toolBar addSubview:textView];
    [toolBar addSubview:topLine];
    
    if (!faceBoard) {
        
        faceBoard = [[FaceBoard alloc] init];
        faceBoard.delegate = self;
        faceBoard.maxLength = 500;// 2015.07.21
        faceBoard.inputTextView = textView;
    }
    isFirstShowKeyboard = YES;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MyTabBarController setTabBarHidden:YES];
}

-(void)selectLeftAction:(id)sender{
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1) {
        UIViewController *v = [viewControllers objectAtIndex:viewControllers.count-2];
        
        if ([Utilities isNeedShowTabbar:v]) {
            // 上层view是否是需要显示tabbar的view
            [MyTabBarController setTabBarHidden:NO];
        }
    }

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectRightAction:(id)sender{
    [ReportObject event:ID_OPEN_BODY_STANDARD];

    //去评测标准页
    SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
    fileViewer.webType = SWLoadURl;
    fileViewer.url = [NSURL URLWithString:[dict objectForKey:@"url"]];
    fileViewer.currentHeadImgUrl = nil;
    fileViewer.isShowSubmenu = @"1";
    [self.navigationController pushViewController:fileViewer animated:YES];
}

-(void)getData{
    
    [Utilities showProcessingHud:self.view];
    [self loadData];
}


/**
 * 体育评测：评测详情
 * @author luke
 * @date 2015.11.27
 * @args
 *  v=2, ac=Physical, op=score, sid=, uid=, cid=, pid=记录ID
 */
-(void)loadData{
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Physical",@"ac",
                          @"2",@"v",
                          @"score", @"op",
                          _cid, @"cid",
                          _pid, @"pid",
                          nil];
    
    if ([usertype integerValue] == 0 || [usertype integerValue] == 6){
        
    }else{
        
        data = [[NSDictionary alloc] initWithObjectsAndKeys:
                REQ_URL, @"url",
                @"Physical",@"ac",
                @"2",@"v",
                @"score", @"op",
                _cid, @"cid",
                _pid, @"pid",
                _nunmber,@"number",
                nil];
        
    }
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        NSLog(@"respDic:%@",respDic);
        
        if ([result integerValue] == 1) {
            
            self.view.hidden = NO;
            
            if (!dict) {
                dict = [[NSDictionary alloc] init];
            }
            
            dict = [respDic objectForKey:@"message"];
            
            NSDictionary *comments = [dict objectForKey:@"comments"];
            [commentHeightArr removeAllObjects];
            [commentsArray removeAllObjects];
            
            NSArray *commentsArr = [comments objectForKey:@"list"];
            
            for (id obj in commentsArr) {
                
                NSDictionary *dic = (NSDictionary *)obj;
                
                NSString *msg = [self transComment2TSAttLabel:dic];
                
                CGSize size = [self getCommentAttrHeight:msg];
                
                // 由于还有上下的留白部分，给每个评论cell的高度增加14
                //int height = size.height  + 14;
                int height = size.height;
                
                [commentHeightArr addObject:[NSString stringWithFormat:@"%d", height]];
                [commentsArray addObject:dic];
                
            }
            
            
            [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:YES];
            
           
            //未开通 欠费 成长空间于有效期内方可回复此消息
            if ([_fromName isEqualToString:@"msgCenter"]) {
                
                if ([usertype integerValue] == 0 || [usertype integerValue] == 6){
                    NSString *status = [NSString stringWithFormat:@"%@",[[respDic objectForKey:@"message"] objectForKey:@"status"]];
                    if ([status integerValue] == 0 || [status integerValue]==3 || [status integerValue] == 4) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"成长空间于有效期内方可回复此消息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        alert.tag = 222;
                        [alert show];
                    }
                }
                
            }
            
        }else{
            
            NSString *msg = [NSString stringWithFormat:@"%@",[respDic objectForKey:@"message"]];
            
            //[Utilities showFailedHud:msg descView:nil];
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:msg
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            alert.delegate = self;
            alert.tag = 333;
            [alert show];
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        
    }];
    
}


-(void)updateUI{
    
   
    NSString *title = [NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
    NSString *dateStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"dateline"]];
    NSDictionary *rankDic = [dict objectForKey:@"rank"];
    
    if (rankDic) {
        
        NSString *grade = [NSString stringWithFormat:@"%@",[rankDic objectForKey:@"grade"]];
        
        if ([grade integerValue] == 0) {
            
            _RankLabel.text = @"--";
            _RankLabel.textColor = [UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1];
            
        }else{
            NSString *tempStr = [NSString stringWithFormat:@"第%@名",grade];
            NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:tempStr];
            [title addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1] range:NSMakeRange(1,[grade length])];//颜色
            _RankLabel.attributedText = title;
        }
        
    
    }else{
        
    }
    
    NSString *score = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dict objectForKey:@"score"]]];
    _dateLabel.text = title;
    NSString *updateDate = [[Utilities alloc] linuxDateToString:dateStr andFormat:@"%@-%@-%@" andType:DateFormat_YMD];
    _updateLabel.text = [NSString stringWithFormat:@"更新时间：%@",updateDate];
    _scoreLabel.text = score;
    
    NSArray *courses = [dict objectForKey:@"courses"];
    [self addMoudelView:courses];
    
    _AdviceTxv.text = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dict objectForKey:@"advice"]]];
    CGSize size =  [Utilities getStringHeight:_AdviceTxv.text andFont:[UIFont systemFontOfSize:15.0] andSize:CGSizeMake(winSize.width - 20.0, 0)];
    
    _BodyTitleLabel.frame = CGRectMake(_BodyTitleLabel.frame.origin.x, _headerView.frame.size.height, _BodyTitleLabel.frame.size.width, _BodyTitleLabel.frame.size.height);
    
    _AdviceTxv.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    _AdviceTxv.font = [UIFont systemFontOfSize:15.0];
    if ([_AdviceTxv.text length] > 0) {
       _AdviceTxv.frame = CGRectMake(_AdviceTxv.frame.origin.x, 0, winSize.width - 20.0, size.height+18.0);
    }else{
        _AdviceTxv.frame = CGRectMake(_AdviceTxv.frame.origin.x, 0, 0, 0);
    }
    
    _adviceV.frame = CGRectMake(0, _BodyTitleLabel.frame.origin.y+_BodyTitleLabel.frame.size.height,winSize.width , _AdviceTxv.frame.size.height);
    
    float totalHeight = _headerView.frame.size.height + _BodyTitleLabel.frame.size.height + _adviceV.frame.size.height;
 
#if 0
    if (totalHeight > (winSize.height - 64.0)) {
        
        float height = totalHeight - (winSize.height - 64.0);
        
        _scrollView.contentSize = CGSizeMake(winSize.width, _scrollView.frame.size.height+height);
        
    }
#endif
    
    _scrollView.contentSize = CGSizeMake(winSize.width, 0);
    _scrollView.frame = CGRectMake(0, 0, winSize.width, totalHeight);
    
    _tableView.tableHeaderView = _scrollView;
    
    [_tableView reloadData];
    
    
}

-(void)addMoudelView:(NSArray*)courses{
    
    int x = 0;//横
    int j = 0;//竖
    
    float lastY = 0;
    
    for (int i=0; i<[courses count]; i++) {
        
        NSString *score = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[courses objectAtIndex:i] objectForKey:@"value"]]];
        
        if ([score length] == 0) {
            score = @"--";
        }else if ([score integerValue] == -1){
            score = @"--";
        }
        
        NSString *name = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[courses objectAtIndex:i] objectForKey:@"name"]]];
        
        
        
        UILabel *labelScore = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 106.0, 30.0)];
        labelScore.textColor = [UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1];
        labelScore.textAlignment = NSTextAlignmentCenter;
        labelScore.font = [UIFont systemFontOfSize:23.0];
        
        
        UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(0, 75.0-21.0-10.0, 106.0, 21.0)];
        labelName.textAlignment = NSTextAlignmentCenter;
        labelName.font = [UIFont systemFontOfSize:15.0];
        labelName.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        
        
        /*
         UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 106.0, 75.0);
        button.tag = 410+i;
        [button addTarget:self action:@selector(moudelSelect:) forControlEvents:UIControlEventTouchUpInside];
         */
        
        if ((i!=0) && (i%3 == 0)) {
            
            j++;
            x = 0;
        }
        
        UIView *moudelView = [[UIView alloc]init];
        moudelView.frame = CGRectMake(x*106.0, 75.0*j, 106.0, 75.0);
        moudelView.tag = 110+i;
        
        
        labelName.text = name;
        labelScore.text = score;
        
        [moudelView addSubview:labelScore];
        [moudelView addSubview:labelName];
        //[moudelView addSubview:button];
        
        NSLog(@"i:%d x:%f y:%f",i,moudelView.frame.origin.x,moudelView.frame.origin.y);
        
        [_subjectView addSubview:moudelView];
        
        x++;
        
        lastY = j*75.0 + 75.0;
        
        // 横竖线
        UIView *rowV = [[UIView alloc] initWithFrame:CGRectMake(0, j*75.0, winSize.width, 1.0)];
        rowV.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:241.0/255.0 alpha:1];
        [_subjectView addSubview:rowV];
        
        UIView *columnV = [[UIView alloc] initWithFrame:CGRectMake(x*106.0,75.0*j ,1.0, 75.0)];
        columnV.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:241.0/255.0 alpha:1];
        if (x!=3) {
            [_subjectView addSubview:columnV];
        }
        
        
    }
    
    _subjectView.frame = CGRectMake(0.0, _subjectView.frame.origin.y, winSize.width, lastY);
    _headerView.frame = CGRectMake(0.0, _headerView.frame.origin.y, winSize.width, _subjectView.frame.origin.y+_subjectView.frame.size.height);
    
}

-(void)reload{
    
    [_tableView reloadData];
    
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    
    return [commentsArray count];
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[commentHeightArr objectAtIndex:indexPath.row] floatValue];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    
    NSDictionary *dic = [commentsArray objectAtIndex:indexPath.row];
    
    MomentsDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    
    cell.backgroundColor = [UIColor redColor];
    
    if (cell == nil) {
        cell = [[MomentsDetailTableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.flag = 1;
    cell.delegate = self;
    
    
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
    
    // 为了准确计算高度，需要先把表情字符换算成一个汉字，然后计算高度
    //NSString *testFormEmo = [self textFromEmoji:cmt];
    
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
    cell.ohAttributeLabel.msgPid = [dic objectForKey:@"pid"];// 引用评论ID
    cell.ohAttributeLabel.msgUid = [dic objectForKey:@"uid"];
    cell.ohAttributeLabel.msgPos = [NSString stringWithFormat:@"%lu", indexPath.row];
    cell.ohAttributeLabel.cellNum = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    cell.ohAttributeLabel.msgTid = _pid;//代表模块id
    
    cell.ohAttributeLabel.hasName1 = 1;
    cell.ohAttributeLabel.name1Start = 0;
    cell.ohAttributeLabel.name1End = commentNameSize.width;
    cell.ohAttributeLabel.name1Uid = [dic objectForKey:@"uid"];
    
    cell.ohAttributeLabel.hasName2 = 1;
    cell.ohAttributeLabel.name2Start = wholeNameSize.width - commentToNameSize.width;
    cell.ohAttributeLabel.name2End = wholeNameSize.width;
    cell.ohAttributeLabel.name2Size = commentToNameSize.width;
    cell.ohAttributeLabel.name2Uid = [dic objectForKey:@"toUid"];
    
    cell.ohAttributeLabel.nameY = 24.0;
    
    cell.ohAttributeLabel.msgComment = displayStr1;
    
    // 增加对整条msg的点击事件
    if (msgSize.width > (320 - 15.0)) {
        // 超过一行的宽度，按照msg一行的宽度计算的高度set到label中
        CGSize msgSize1 = [self getCommentAttrHeight:cmt];
        
        cell.ohAttributeLabel.msgHeight = msgSize1.height;
        cell.ohAttributeLabel.msgWidth = msgSize1.width;
    }else {
        cell.ohAttributeLabel.msgHeight = msgSize.height;
        cell.ohAttributeLabel.msgWidth = 320 - 15.0;
    }
    
    [cell.textParser.images removeAllObjects];
    
    NSAttributedString* attString = [cmt expressionAttributedStringWithExpression:exp];
    NSMutableAttributedString* mutableAttStr = [[NSMutableAttributedString alloc] initWithAttributedString:attString];
    
    [mutableAttStr addAttribute:NSForegroundColorAttributeName
                          value:[[UIColor alloc] initWithRed:54.0/255.0f green:182.0/255.0f blue:169.0/255.0f alpha:1.0]
                          range:NSMakeRange(0,[commentName length])];
    
    if (![@""  isEqual: commentToName]) {
        [mutableAttStr addAttribute:NSForegroundColorAttributeName
                              value:[[UIColor alloc] initWithRed:54.0/255.0f green:182.0/255.0f blue:169.0/255.0f alpha:1.0]
                              range:NSMakeRange([commentName length]+2,[commentToName length])];
    }
    
    cell.ohAttributeLabel.attributedText = mutableAttStr;
    cell.ohAttributeLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.ohAttributeLabel.numberOfLines = 0;
    
    int ohAttributeLabelHeight = [[commentHeightArr objectAtIndex:indexPath.row] floatValue];
    cell.ohAttributeLabel.frame = CGRectMake(15.0,
                                             5,
                                             winSize.width - 15.0,
                                             ohAttributeLabelHeight-10.0);
    
    cell.imgView_bottomLime.frame = CGRectMake(20,
                                               [[commentHeightArr objectAtIndex:indexPath.row] floatValue],
                                               280,
                                               1);
    
    cell.imgView_bottomLime.hidden = YES;
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
}

-(CGSize)getCommentAttrHeight:(NSString *)msg
{
    MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"/faceImages/expression/emotionImage.plist" bundleName:@"Expression"];//plistName bundleName 需要修改
    NSAttributedString *expressionText = [msg expressionAttributedStringWithExpression:exp];
    
    TSAttributedLabel *label = kProtypeLabel();
    label.attributedText = expressionText;
    label.font = [UIFont systemFontOfSize:14.0f];
    
    return [label preferredSizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width - 15.0];
}

-(NSString *)transComment2TSAttLabel:(NSDictionary *)dic
{
    NSString *cmtMsg = [dic objectForKey:@"message"];
    NSString *commentName = [Utilities replaceNull:[dic objectForKey:@"name"]];
    NSString *commentToName = [dic objectForKey:@"toName"];
    
    NSString *cmt;
    if ([@""  isEqual: commentToName]) {
        // 单独回复
        cmt = [NSString stringWithFormat:@"%@：%@",commentName, cmtMsg];
    }else {
        // 回复的回复
        cmt = [NSString stringWithFormat:@"%@回复%@：%@",commentName, commentToName, cmtMsg];
    }
    
    return cmt;
}

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

// 代理回调
-(void)clickComment:(NSDictionary*)dic{
    
    NSLog(@"clickComment");
    NSLog(@"clickRemovePost");
    
    _deletePid = [dic objectForKey:@"pid"];
    NSString *tUid = [dic objectForKey:@"uid"];
    _deletePidPos = [dic objectForKey:@"msgPos"];
    _deleteCellNum = [dic objectForKey:@"cellNum"];
    _deleteTid = [dic objectForKey:@"tid"];
    likeCellNum = [dic objectForKey:@"cellNum"];
    
    NSString *uid = [[g_userInfo getUserDetailInfo]  objectForKey:@"uid"];
    
    if ([tUid isEqual: uid]) {
        isCommentComment = NO;
        [textView resignFirstResponder];
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"删除这条评论？"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"删除",nil];
        alert.tag = 274;
        [alert show];
    }else {
        // 如果是别人发的，评论别人的评论
        NSDictionary *cmt = [commentsArray objectAtIndex:_deletePidPos.integerValue];
        
        _replyTo = [NSString stringWithFormat:@"回复%@: ", [cmt objectForKey:@"name"]];
        _isFirstClickReply = true;
        
        textView.text = @"";
        
        _replyToLabel.text = _replyTo;
        [_replyToLabel setHidden:NO];
        
        //        textView.text = [NSString stringWithFormat:@"回复%@:", [cmt objectForKey:@"name"]];
        //        _isFirstClickReply = true;
        
        [textView becomeFirstResponder];
        
        isCommentComment = YES;
    }
}

// 代理回调
-(void)clickUserName:(NSDictionary*)dic{
    NSLog(@"clickUserName");
    
    FriendProfileViewController *fpvc = [[FriendProfileViewController alloc]init];
    fpvc.fuid = [dic objectForKey:@"uid"];
    [self.navigationController pushViewController:fpvc animated:YES];
    
}

// 代理回调
-(void)deleteComment:(NSDictionary*)dic{
    NSLog(@"deleteComment");
    [self clickComment:dic];
    
}

/**
 * 体育评测：评论删除
 * @author luke
 * @date 2015.11.27
 * @args
 *  v=2, ac=Physical, op=commentDelete, sid=, uid=, cid=, pid=评论ID
 */
-(void)deleteComment{
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                          @"Physical",@"ac",
                          @"2",@"v",
                          @"commentDelete", @"op",
                          _cid,@"cid",
                          _deletePid,@"pid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            //To do:评论数字里删除一条
            [commentsArray removeObjectAtIndex:[_deleteCellNum integerValue]];
            [commentHeightArr removeObjectAtIndex:[_deleteCellNum integerValue]];
            
            [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        
    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 274){
        
        if (buttonIndex == 1){
            
            [self deleteComment];
        }
    }else if (alertView.tag == 222){
        
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else if (alertView.tag == 333){
        
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }

    
}

// 自定义输入框发表按钮,发送评论
/**
 * 体育评测：身体详情评论
 * @author luke
 * @date 2015.12.13
 * @args
 *  v=2, ac=Physical, op=commentCondition, sid=, cid, uid=, rid=身体ID, [pid=引用评论ID], message=
 * @example:
 *
 */
-(void)AudioClick:(id)sender{
    
    if ([@""  isEqual: textView.text]) {
        
        [Utilities showFailedHud:@"请输入回复内容" descView:textView.inputView];//2015.05.12
    }else {
        if (isCommentComment) {
            
            [Utilities showProcessingHud:self.view];// 2015.05.12
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                  @"Physical",@"ac",
                                  @"2",@"v",
                                  @"commentScore", @"op",
                                  _deleteTid, @"rid",
                                  _deletePid, @"pid",
                                  textView.text, @"message",
                                  _nunmber,@"number",
                                  _cid,@"cid",
                                  nil];
            
            [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
                
                [Utilities dismissProcessingHud:self.view];
                
                NSDictionary *respDic = (NSDictionary*)responseObject;
                NSString *result = [respDic objectForKey:@"result"];
                
                if ([result integerValue] == 1) {
                    //To do: 评论数组里增加一条
                    NSDictionary *message = [respDic objectForKey:@"message"];
                    [commentsArray addObject:message];
                    
                    NSString *msg = [self transComment2TSAttLabel:message];
                    CGSize size = [self getCommentAttrHeight:msg];
                    int height = size.height;
                    [commentHeightArr addObject:[NSString stringWithFormat:@"%d", height]];
                    
                    if ([usertype integerValue] == 0 || [usertype integerValue] == 6) {
                        _replyTo = @"您可在这里与班主任留言互动哦!";
                        
                    }else{
                        _replyTo = @"您可在这里与学生/家长留言互动哦!";
                    }
                    
                    _replyToLabel.text = _replyTo;
                    [_replyToLabel setHidden:NO];
                    
                    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                    
                }else{
                    
                    NSString *msg = [respDic objectForKey:@"message"];
                    [Utilities showFailedHud:msg descView:nil];
                    
                }
                
                
            } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                
                //[Utilities dismissProcessingHud:self.view];
                [Utilities doHandleTSNetworkingErr:error descView:self.view];
            }];
            
            isCommentComment = NO;
        }else {
            
            [Utilities showProcessingHud:self.view];// 2015.05.12
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                  @"Physical",@"ac",
                                  @"2",@"v",
                                  @"commentScore", @"op",
                                  _deleteTid, @"rid",
                                  textView.text, @"message",
                                  _nunmber,@"number",
                                  _cid,@"cid",
                                  nil];
            
            [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
                
                [Utilities dismissProcessingHud:self.view];
                
                NSDictionary *respDic = (NSDictionary*)responseObject;
                NSString *result = [respDic objectForKey:@"result"];
                
                if ([result integerValue] == 1) {
                    //To do: 评论数组里增加一条
                    NSDictionary *message = [respDic objectForKey:@"message"];
                    [commentsArray addObject:message];
                    
                    NSString *msg = [self transComment2TSAttLabel:message];
                    CGSize size = [self getCommentAttrHeight:msg];
                    int height = size.height;
                    [commentHeightArr addObject:[NSString stringWithFormat:@"%d", height]];
                    
                    if ([usertype integerValue] == 0 || [usertype integerValue] == 6) {
                        _replyTo = @"您可在这里与班主任留言互动哦!";
                        
                    }else{
                        _replyTo = @"您可在这里与学生/家长留言互动哦!";
                    }
                    
                    _replyToLabel.text = _replyTo;
                    [_replyToLabel setHidden:NO];
                    
                    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                    
                }else{
                    
                    NSString *msg = [respDic objectForKey:@"message"];
                    [Utilities showFailedHud:msg descView:nil];
                    
                }
                
                
            } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                
                //[Utilities dismissProcessingHud:self.view];
                [Utilities doHandleTSNetworkingErr:error descView:self.view];
            }];
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
        
        return YES;
    }
    else {
        if (range.location >= 500) {// 成长空间评论 500 2015.07.21
            return NO;
        }else {
            if (_isFirstClickReply) {
                self->textView.text = @"";
                _isFirstClickReply = false;
            }
            
            return YES;
        }
    }
}

- (void)textViewDidChange:(UITextView *)_textView {
    _replyToLabel.text = _replyTo;
    
    if ([_textView.text length] == 0 && [_replyTo length] > 0) {
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
    
    if (_isFirstClickReply) {
        self->textView.text = @"";
        _isFirstClickReply = false;
    }
    
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
    // 键盘弹出时，清空输入框，之后可以优化为为每一条记录之前输入的内容，类似微信。
    //    textView.text = @"";
    
    toolBar.hidden = NO;
    
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
                         //_tableView.frame = frame;
                         
                         
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
    
    //toolBar.hidden = YES;
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGRect frame = _tableView.frame;
                         frame.size.height += keyboardHeight;
                         //_tableView.frame = frame;
                         
                         frame = toolBar.frame;
                         frame.origin.y += keyboardHeight;
                         toolBar.frame = frame;
                         
                         keyboardHeight = 0;
                     }];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    
    //    isCommentComment = NO;
    //textView.text = @"";
    isKeyboardShowing = NO;
    
    if ( isButtonClicked ) {
        
        isButtonClicked = NO;
        
        switch (clickFlag) {
                
            case 1:{
                
                if ( [textView.inputView isEqual:faceBoard]) {
                    
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
        
        [textView becomeFirstResponder];
    }
}

-(void)dismissKeyboard{
    
    
    [textView resignFirstResponder];
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setMenuVisible:NO animated:YES];
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if(([touch.view isMemberOfClass:[TSTouchLabel class]]) ||
       ([touch.view isMemberOfClass:[TSAttributedLabel class]]) ||
       ([touch.view isMemberOfClass:[UIButton class]]) ||
       ([touch.view isMemberOfClass:[UITableViewCell class]])) {
        //放过以上事件的点击拦截
        
        return NO;
    }else{
        
        UIView* v=[touch.view superview];
        
        // 特殊放过tableViewCell的点击事件
        //        if([v isMemberOfClass:[Test1TableViewCell class]]) {
        //            return NO;
        //        }
        
        return YES;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    // 滑动屏幕使键盘下落
    [textView resignFirstResponder];
    NSLog(@"scrollViewDidEndDragging");
}

@end
