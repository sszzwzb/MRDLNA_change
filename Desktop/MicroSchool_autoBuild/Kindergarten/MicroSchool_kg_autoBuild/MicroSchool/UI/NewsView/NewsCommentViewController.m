//
//  NewsCommentViewController.m
//  MicroSchool
//
//  Created by jojo on 15/6/26.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "NewsCommentViewController.h"
#import "FriendProfileViewController.h"

@interface NewsCommentViewController ()

@end

@implementation NewsCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super setCustomizeTitle:@"评论"];
    [self setCustomizeLeftButton];
    
    reflashFlag = 1;
    isReflashViewType = 1;
    _isFirstClickReply = false;
    
    
    _textParser = [[MarkupParser alloc] init];
    _cellHeightArray = [[NSMutableArray alloc] init];
    
    _commentDataArr = [[NSMutableArray alloc] init];
    
    NSString *emojiFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/faceImages/expression/emotionImage.plist"];
    _emojiDic = [[NSDictionary alloc] initWithContentsOfFile:emojiFilePath];
    
    //-----add by kate---------------------------------------------------
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickDeleteComment:) name:NOTIFICATION_UI_NEWS_DELETE_COMMENT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doGoToProfileView:) name:@"Weixiao_fromDiscussDetailView2ProfileView" object:nil];//添加头像点击事件 2015.09.21
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44 - 44) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    // 隐藏tableview分割线
    [self->_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view addSubview:_tableView];
    
    [self showCustomKeyBoard];
    
//    _replyToLabel = [UILabel new];
//    [_inputTextView addSubview:_replyToLabel];
//    [_replyToLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).with.offset(5);
//        make.left.equalTo(self.view).with.offset(5);
//        make.size.mas_equalTo(CGSizeMake(200,20));
//    }];
//    _replyToLabel.enabled = NO;
//    _replyToLabel.text = @"";
//    _replyToLabel.font =  [UIFont systemFontOfSize:13];
//    _replyToLabel.textColor = [UIColor grayColor];
    
    _replyToLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 20)];
    _replyToLabel.enabled = NO;
    _replyToLabel.text = @"";
    _replyToLabel.font =  [UIFont systemFontOfSize:13];
    _replyToLabel.textColor = [UIColor grayColor];
    [_inputTextView addSubview:_replyToLabel];
    
    
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    NSString *cid = [user objectForKey:@"role_cid"];
    
    NSString *role_id = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
    NSString *role_checked = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_checked"]];
    
    NSString *schoolType = [[NSUserDefaults standardUserDefaults]objectForKey:@"schoolType"];
    
    if ([_cmtSid  isEqual: G_SCHOOL_ID]) {
        
        /*2015.10.29 教育局改版
         if ([schoolType isEqualToString:@"bureau"]) {
            toolBar.hidden = NO;
            
        }else*/ {
            //有效身份才可以发表动态评论
            if([@"7"  isEqual: role_id]) {
                
                if ([@"2"  isEqual: role_checked]) {//没有获得教师身份
                    
                    toolBar.hidden = YES;
                    
                    _tableView.frame = CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44);
                    
                }else if([@"0"  isEqual: role_checked]){//没有审核通过的教师
                    
                    toolBar.hidden = YES;
                    
                    _tableView.frame = CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44);
                    
                }else{
                    toolBar.hidden = NO;
                }
            }else if (([@"0"  isEqual: role_id]) || ([@"6"  isEqual: role_id])){
                
                if([@"0"  isEqual: [NSString stringWithFormat:@"%@",cid]]){//未加入班级的学生
                    
                    toolBar.hidden = YES;
                    
                    _tableView.frame = CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44);
                    
                }else{
                    toolBar.hidden = NO;
                }
                
            }else{
                
                toolBar.hidden = NO;
                
            }
        }
        
    }else {
        toolBar.hidden = YES;
        
        _tableView.frame = CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44);
    }
    
//    _replyToLabel = [UILabel new];
//    [_inputTextView addSubview:_replyToLabel];
//    [_replyToLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).with.offset(5);
//        make.left.equalTo(self.view).with.offset(5);
//        make.size.mas_equalTo(CGSizeMake(200,20));
//    }];
//    _replyToLabel.enabled = NO;
//    _replyToLabel.text = @"";
//    _replyToLabel.font =  [UIFont systemFontOfSize:13];
//    _replyToLabel.textColor = [UIColor grayColor];
    
    
    [self createHeaderView];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          _cmtSid, @"sid",
                          @"News", @"ac",
                          @"2", @"v",
                          @"comments", @"op",
                          _newsId, @"nid",
                          @"0", @"page",
                          @"15", @"size",
                          nil];
    
    [self doGetCommentData:data];
    
    [ReportObject event:ID_OPEN_COMMENT];//2015.07.02
    
}

-(void)clickDeleteComment:(NSNotification *)notification
{
    NSLog(@"clickDeleteComment");
    NSDictionary *dic = [notification userInfo];
    
    _myPostPid =  [dic objectForKey:@"cid"];
    _myPostCellNum =  [dic objectForKey:@"cellNum"];
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:@"屏蔽这条回复？"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"屏蔽",nil];
    alert.tag = 276;
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)doGetCommentData:(NSDictionary *)param
{
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:param successBlock:^(TSNetworking *request, id responseObject) {
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            [Utilities dismissProcessingHud:self.view];
            
            NSDictionary *dic = [respDic objectForKey:@"message"];
          
            if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"count"]] integerValue] == 0) {
                ((UILabel *)self.navigationItem.titleView).text = @"评论";
            }else{
               ((UILabel *)self.navigationItem.titleView).text = [NSString stringWithFormat:@"评论 (%@)", [dic objectForKey:@"count"]];
            }
            
            [_cellHeightArray removeAllObjects];
            
            if ([@"0"  isEqual: startNum]) {
                [_commentDataArr removeAllObjects];
            }
            
            for (NSObject *object in [dic objectForKey:@"list"])
            {
                [_commentDataArr addObject:object];
            }
            
            for (int i=0; i<[_commentDataArr count]; i++) {
                [self calcCellHeight:@"" andRow:i];
            }
            
            [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.1];
            [_tableView reloadData];
            
            if ([@"0"  isEqual: startNum]) {
                //update 2015.09.01 这句话引起下拉刷新后 底部加载更多控件常驻
                //[_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            
            startNum = [NSString stringWithFormat:@"%ld",(startNum.integerValue + 15)];
            
            if ([_commentDataArr count] > 0) {
                
                [noDataView removeFromSuperview];
                
            }else{
                 [noDataView removeFromSuperview];
                CGRect rect = CGRectMake(0, 0, _tableView.frame.size.width, _tableView.frame.size.height - 44);
                noDataView = [Utilities showNodataView:@"留下你的看法~" msg2:@"" andRect:rect imgName:@"无评论_03"];
               
                [self.tableView addSubview:noDataView];
            }
            
        } else {
            [Utilities dismissProcessingHud:self.view];
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"获取信息错误，请稍候再试"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        //[Utilities doHandleTSNetworkingErr:error descView:self.view];
        
        if (![Utilities isConnected]) {//2015.07.02
            UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
            [self.view addSubview:noNetworkV];
            
        }
    }];
    
    //    [network sendHttpReq:HttpReq_NewsDetail andData:data];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_commentDataArr count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[_cellHeightArray objectAtIndex:[indexPath row]] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    
    NSUInteger row = [indexPath row];
    
    DiscussDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        cell = [[DiscussDetailCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellTableIdentifier];
    }
    
    NSDictionary* list_dic = [_commentDataArr objectAtIndex:row];
    
    NSString* cid= [list_dic objectForKey:@"cid"];
    NSString* sbj_uid= [list_dic objectForKey:@"uid"];
    NSString* username= [list_dic objectForKey:@"name"];
    NSString* dateline= [list_dic objectForKey:@"dateline"];
    NSString* message= [list_dic objectForKey:@"message"];
    
    NSDictionary *user = [g_userInfo getUserDetailInfo];
    NSString *role_id = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
    
    if ([_cmtSid  isEqual: G_SCHOOL_ID]) {
        if([@"9"  isEqual: role_id]) {
            cell.tsLabel_delete.hidden = NO;
            cell.tsLabel_delete.tid = [list_dic objectForKey:@"cid"];
            cell.tsLabel_delete.cellNum = [NSString stringWithFormat:@"%lu",(unsigned long)row];
            
        }
    }
    
    cell.pid = cid;
    cell.uid = sbj_uid;
    cell.cellNum = [NSString stringWithFormat:@"%lu",(unsigned long)row];
    
    // 名字，时间
    cell.label_username.text = username;
    
    Utilities *util = [Utilities alloc];
    cell.label_dateline.text = [util linuxDateToString:dateline andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
    
    // 头像
    NSString *head_url = [list_dic objectForKey:@"avatar"];
    [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:head_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];
    [cell.btn_thumb sd_setImageWithURL:[NSURL URLWithString:head_url] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"icon_avatar_big.png"]];
    
    cell.label_leftNum.text = [NSString stringWithFormat:@"%lu", (unsigned long)row];
    
    cell.btn_thumb.frame = CGRectMake(20, 10, 30, 30);
    
    cell.label_username.textColor = [UIColor blackColor];
    cell.label_username.lineBreakMode = NSLineBreakByTruncatingTail;
    cell.label_username.numberOfLines = 1;
    cell.label_username.frame = CGRectMake(cell.btn_thumb.frame.origin.x + cell.btn_thumb.frame.size.width + 5,
                                           cell.btn_thumb.frame.origin.y + 5,
                                           130+30,
                                           15);//2015.09.15
    
    cell.label_dateline.frame = CGRectMake(cell.label_username.frame.origin.x,
                                           cell.label_username.frame.origin.y + cell.label_username.frame.size.height+5,
                                           120,
                                           15);//2015.09.18
    
    cell.tsLabel_delete.frame = CGRectMake(cell.label_dateline.frame.origin.x + cell.label_dateline.frame.size.width + 10, cell.label_dateline.frame.origin.y, 26, 16);
    //----2015.09.15---------------------------------------------------------------------------------
    cell.button_copy.hidden = NO;
    cell.button_copy.frame =cell.tsLabel_delete.frame;
    if ([_cmtSid  isEqual: G_SCHOOL_ID]) {
        if([@"9"  isEqual: role_id]) {
            cell.button_copy.frame = CGRectMake(cell.tsLabel_delete.frame.origin.x + cell.tsLabel_delete.frame.size.width+10, cell.tsLabel_delete.frame.origin.y, 26, 16);//2015.09.15
        }
    }
    //-----------------------------------------------------------------------------------------------
    
    NSString *pic = @"";
    pic= [list_dic objectForKey:@"pic"];
    
    cell.pic = pic;
    
    // 动态计算label高度，set到cell中
    CGRect rect = cell.frame;
    
    // 以/div为标识，分割字符串
    NSArray * array = [message componentsSeparatedByString:@"</div>"];
    NSLog(@"array:%@",array);
    NSLog(@"count:%lu",(unsigned long)[array count]);
    
    NSString *resultStr = @"";
    NSRange range;
    
    //------add by kate 2015.04.01-----
    NSString *citeStr = @"";
    //            NSString *tempStr = @"";
    //            NSString *tempStr1 = @"";
    //            NSString *lineStr0 = @"";
    
    NSString *nameStr;
    
    for(NSObject *temp in array)
    {
        NSString *str = (NSString *)temp;
        
        NSRange foundB=[str rangeOfString:@"<b>" options:NSCaseInsensitiveSearch];
        NSRange foundOB=[str rangeOfString:@"</b>" options:NSCaseInsensitiveSearch];
        NSUInteger len = foundOB.location - foundB.location;
        
        if (0 != len) {
            nameStr = [str substringWithRange:NSMakeRange(foundB.location + 3, len-3)];
        }
        
        // 去掉html中的标识
        while ((range = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
            str=[str stringByReplacingCharactersInRange:range withString:@""];
        }
        
        str = [str stringByAppendingString:@"\n"];
        resultStr = [resultStr stringByAppendingString:str];
    }
    
    
    resultStr = [resultStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //-------update 2015.09.18-----------------------------------------
    /*[cell.textParser.images removeAllObjects];
    
    NSString *displayStr = [self transformString:resultStr];
    NSMutableAttributedString* attString = [cell.textParser attrStringFromMarkup:displayStr];
    
    attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
    [attString setFont:[UIFont systemFontOfSize:16]];
    [attString setTextColor:[[UIColor alloc] initWithRed:27/255.0f green:128/255.0f blue:209/255.0f alpha:1.0] range:NSMakeRange(0,[nameStr length])];
    
    [cell.label setVerticalAlignment:VerticalAlignmentMiddle];
    
    [cell.label resetAttributedText];
    
    //NSLog(@"images:%@",textParser.images);
    //NSLog(@"attString:%@",attString);
    
    [cell.label setAttString:attString withImages:cell.textParser.images];
    
    CGSize a = [self frameSizeForAttributedString:attString];
    
    float hei = a.height;
    if (hei > 450) {
        hei = hei - 10;
    }else if(hei > 225 && hei <450) {
        hei = hei - 5;
    }
    
    cell.label.frame = CGRectMake(cell.label_username.frame.origin.x, cell.label_dateline.frame.origin.y + cell.label_dateline.frame.size.height + 10, cell.contentView.frame.size.width-70,
                                  hei);*/
    
    [cell setMLLabelText:resultStr];
    float hei =[DiscussDetailCell heightForEmojiText:resultStr].height;
    if (hei > 450) {
        hei = hei - 10;
    }else if(hei > 225 && hei <450) {
        hei = hei - 5;
    }
    
    cell.label.frame = CGRectMake(cell.label_username.frame.origin.x -10.0, cell.label_dateline.frame.origin.y + cell.label_dateline.frame.size.height + 10, cell.contentView.frame.size.width-60, hei);
    //-------------------------------------------------------------------------------------------------------------
    
    
    
    //test code
    
    int b = 0;
    
    //---add by kate 2015.04.01-------------------------------
    if ([array count] == 1) {
        cell.citeLabel.hidden = YES;
        
        
        //                cell.citeLabel.frame = cell.label.frame;
        
        NSLog(@"cell.citeLabel.frame  ------  %f",cell.citeLabel.frame.size.height);
        cell.button_copy.pasteboardStr = message;//2015.09.15
        
    }else{
        
        cell.citeLabel.hidden = NO;
        citeStr = [array objectAtIndex:1];
        cell.button_copy.pasteboardStr = citeStr;//2015.09.15
        
        
        /*---------update 2015.09.18----------------------------
         NSString *newString = [self textFromEmoji:citeStr];
        
        NSMutableAttributedString* attString = [cell.textParser attrStringFromMarkup:newString];
        attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
        [attString setFont:[UIFont systemFontOfSize:16]];
        
        CGSize b = [self frameSizeForAttributedString:attString];
        
        CGFloat height = b.height + 2;
        
        NSLog(@"%f",cell.label.frame.size.height);
        NSLog(@"%f",height);
        
        
        cell.citeLabel.frame = CGRectMake(cell.label_username.frame.origin.x, cell.label_dateline.frame.origin.y + cell.label_dateline.frame.size.height + 10, cell.contentView.frame.size.width-70,
                                          cell.label.frame.size.height - height);*/
        
        
        NSString *nameStr;
        
        for(NSObject *temp in array)
        {
            NSString *str = (NSString *)temp;
            
            NSRange foundB=[str rangeOfString:@"<b>" options:NSCaseInsensitiveSearch];
            NSRange foundOB=[str rangeOfString:@"</b>" options:NSCaseInsensitiveSearch];
            NSUInteger len = foundOB.location - foundB.location;
            
            if (0 != len) {
                nameStr = [str substringWithRange:NSMakeRange(foundB.location + 3, len-3)];
            }
            
            // 去掉html中的标识
            while ((range = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
                str=[str stringByReplacingCharactersInRange:range withString:@""];
                citeStr = str;
            }
            
        }
        
        float height =[DiscussDetailCell heightForEmojiText:citeStr].height - 17.0;
        float y = cell.label.frame.origin.y + 7.0;
        cell.citeLabel.frame = CGRectMake(cell.label_username.frame.origin.x - 10.0, y, cell.contentView.frame.size.width-60,
                                          height);
         //---------------------------------------------------------------------------------------------

        
        
    }
    
    rect.size.height = (cell.label.frame.origin.y+cell.label.frame.size.height + 19);
    
    cell.frame = rect;
    
    cell.imgView_leftLine.hidden = YES;
    cell.imgView_leftlittilPoint.hidden = YES;
    cell.imgView_leftlittilMiddlePoint.hidden = YES;
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        cell.imgView_line.frame =CGRectMake(
                                            20,
                                            [[_cellHeightArray objectAtIndex:[indexPath row]] floatValue] - 1,
                                            290,
                                            1);
    }
    else
    {
        // 动态计算分割线位置，set到cell中
        cell.imgView_line.frame =CGRectMake(
                                            cell.label_username.frame.origin.x,
                                            cell.label_message.frame.origin.y + cell.label_message.frame.size.height + 10,
                                            250,
                                            1);
    }
    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    
    if (toolBar.hidden) {/// update by kate 2015.07.04 #Bug 1509
        
    }else{
        
        DiscussDetailCell *detailCell = (DiscussDetailCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        if ([_cmtSid  isEqual: G_SCHOOL_ID]) {
            if (![[Utilities getUniqueUid] isEqual: detailCell.uid]) {
                [_inputTextView becomeFirstResponder];
                
                _inputTextView.text = @"";
                //                        _inputTextView.text = [NSString stringWithFormat:@"回复%@:", detailCell.label_username.text];
                _replyTo = [NSString stringWithFormat:@"回复%@: ", detailCell.label_username.text];
                _isFirstClickReply = true;
                _inputTextView.textColor = [UIColor blackColor];
                
                _replyToLabel.text = _replyTo;
                [_replyToLabel setHidden:NO];
                
                _otherPid = detailCell.pid;
            }else {
                _myPostPid = detailCell.pid;
                _myPostCellNum = [NSString stringWithFormat:@"%ld", (long)[indexPath row]];
                _otherPid = nil;
                
                UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除这条回复？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
                alerV.tag = 305;
                [alerV show];
                
                _replyToLabel.text = @"";
            }
        }
    }
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 276) {
        // 管理员屏蔽回复
        if (buttonIndex == 1) {
            
            [Utilities showProcessingHud:self.view];// 2015.05.12
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  _cmtSid, @"sid",
                                  @"News", @"ac",
                                  @"2", @"v",
                                  @"delete", @"op",
                                  _newsId, @"nid",
                                  _myPostPid, @"cid",
                                  nil];
            
            [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
                
                NSDictionary *respDic = (NSDictionary*)responseObject;
                NSString *result = [respDic objectForKey:@"result"];
                
                if(true == [result intValue]) {
                    [Utilities dismissProcessingHud:self.view];
                    
                    NSString *msg = [respDic objectForKey:@"message"];
                    
                    [Utilities showSuccessedHud:msg descView:self.view];
                    
                    [_commentDataArr removeObjectAtIndex:_myPostCellNum.integerValue];
                    
                    [_cellHeightArray removeAllObjects];
                    
                    for (int i=0; i<[_commentDataArr count]; i++) {
                        [self calcCellHeight:@"" andRow:i];
                    }
                    
                    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.1];
                    [_tableView reloadData];
                    
                    //                    startNum = @"0";
                    //
                    //                    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                    //                                          _cmtSid, @"sid",
                    //                                          @"News", @"ac",
                    //                                          @"2", @"v",
                    //                                          @"comments", @"op",
                    //                                          _newsId, @"nid",
                    //                                          @"0", @"page",
                    //                                          @"15", @"size",
                    //                                          nil];
                    //
                    //                    [self doGetCommentData:data];
                    
                    if ([_commentDataArr count] == 0) {
                        
                        ((UILabel *)self.navigationItem.titleView).text = @"评论";
                        
                    }else{
                       
                        ((UILabel *)self.navigationItem.titleView).text = [NSString stringWithFormat:@"评论 (%@)", [NSString stringWithFormat:@"%lu",(unsigned long)[_commentDataArr count]]];
                        
                    }
                    

                } else {
                    [Utilities dismissProcessingHud:self.view];
                    
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                                   message:@"获取信息错误，请稍候再试"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil];
                    [alert show];
                }
                
            } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                [Utilities doHandleTSNetworkingErr:error descView:self.view];
            }];
            
        }
        
        
    }else {
        if (buttonIndex == 1) {
            [Utilities showProcessingHud:self.view];
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  _cmtSid, @"sid",
                                  @"News", @"ac",
                                  @"2", @"v",
                                  @"delete", @"op",
                                  _newsId, @"nid",
                                  _myPostPid, @"cid",
                                  nil];
            
            [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
                
                NSDictionary *respDic = (NSDictionary*)responseObject;
                NSString *result = [respDic objectForKey:@"result"];
                
                if(true == [result intValue]) {
                    [Utilities dismissProcessingHud:self.view];
                    
                    NSString *msg = [respDic objectForKey:@"message"];
                    
                    [Utilities showSuccessedHud:msg descView:self.view];
                    
                    [_commentDataArr removeObjectAtIndex:_myPostCellNum.integerValue];
                    
                    [_cellHeightArray removeAllObjects];
                    
                    for (int i=0; i<[_commentDataArr count]; i++) {
                        [self calcCellHeight:@"" andRow:i];
                    }
                    
                    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.1];
                    [_tableView reloadData];
                    
                    // add 2015.09.01 删除之后评论数目没变修正
                    if ([_commentDataArr count] == 0) {
                        
                        ((UILabel *)self.navigationItem.titleView).text = @"评论";
                        
                    }else{
                        
                        ((UILabel *)self.navigationItem.titleView).text = [NSString stringWithFormat:@"评论 (%@)", [NSString stringWithFormat:@"%lu",(unsigned long)[_commentDataArr count]]];
                        
                    }
                    
                } else {
                    [Utilities dismissProcessingHud:self.view];
                    
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                                   message:@"获取信息错误，请稍候再试"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil];
                    [alert show];
                }
                
            } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                [Utilities doHandleTSNetworkingErr:error descView:self.view];
            }];
            
        }
    }
    
}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝=
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view
-(void)createHeaderView
{
    [Utilities showProcessingHud:self.view];
    
    startNum = @"0";
    endNum = @"15";
    
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    [self->_tableView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)testFinishedLoadData{
    
    [self finishReloadingData];
    [self setFooterView];
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
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
    
    //  model should call this when its done loading
    _reloading = NO;
    
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_tableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_tableView];
        [self setFooterView];
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
        endNum = @"15";
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              _cmtSid, @"sid",
                              @"News", @"ac",
                              @"2", @"v",
                              @"comments", @"op",
                              _newsId, @"nid",
                              @"0", @"page",
                              @"15", @"size",
                              nil];
        
        [self doGetCommentData:data];
    }
}
//加载调用的方法
-(void)getNextPageView
{
    isReflashViewType = 0;
    
    if (reflashFlag == 1) {
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              _cmtSid, @"sid",
                              @"News", @"ac",
                              @"2", @"v",
                              @"comments", @"op",
                              _newsId, @"nid",
                              self->startNum, @"page",
                              self->endNum, @"size",
                              nil];
        
        [self doGetCommentData:data];
    }
}

// cell高度
-(void)calcCellHeight:(NSString *)str andRow:(int)row
{
    NSDictionary* list_dic = [_commentDataArr objectAtIndex:row];
    
    NSString* message= [list_dic objectForKey:@"message"];
    
    // 以/div为标识，分割字符串
    NSArray * array = [message componentsSeparatedByString:@"</div>"];
    
    NSString *resultStr = @"";
    NSRange range;
    
    for(NSObject *temp in array)
    {
        NSString *str = (NSString *)temp;
        
        // 去掉html中的标识
        while ((range = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
            str=[str stringByReplacingCharactersInRange:range withString:@""];
        }
        
        str = [str stringByAppendingString:@"\n"];
        resultStr = [resultStr stringByAppendingString:str];
    }
    
    
    //    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    resultStr = [resultStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    //---update by kate---------------------------------------
    /*NSString *displayStr = [self transformString:resultStr];
     
     [textParser.images removeAllObjects];
     
     NSMutableAttributedString* attString = [textParser attrStringFromMarkup:displayStr];
     
     attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
     [attString setFont:[UIFont systemFontOfSize:14]];
     
     [currentLabel setAttString:attString withImages:textParser.images];
     
     CGRect labelRect = currentLabel.frame;
     labelRect.size.width = [currentLabel sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].width;
     labelRect.size.height = [currentLabel sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].height;*/
    
    /*---update 2015.09.18--------------------------------------------------------------------------------------
     NSString *newString = [self textFromEmoji:resultStr];
     //    CGFloat contentHeight = [Utilities heightForText:newString withFont:[UIFont systemFontOfSize:16.0]  withWidth:[UIScreen mainScreen].bounds.size.width - 70.0];
     
     NSMutableAttributedString* attString = [_textParser attrStringFromMarkup:newString];
     attString = [NSMutableAttributedString attributedStringWithAttributedString:attString];
     [attString setFont:[UIFont systemFontOfSize:16]];
     
     CGSize b = [self frameSizeForAttributedString:attString];
     
     //   CGSize size = [Utilities getStringHeight:newString andFont:[UIFont systemFontOfSize:16.0] andSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 70.0, 0)];
     
     //    CGSize a = [self frameSizeForAttributedString:attString];*/
    CGSize b = [DiscussDetailCell heightForEmojiText:resultStr];
    //-----------------------------------------------------------------------------------------------------------
    
    //float hei = b.height;
    float hei = b.height;//2015.09.18
    if (hei >= 450) {
        hei = hei - 10;
    }else if(hei > 225 && hei <450) {
        hei = hei - 3;
    }
    
    
    CGFloat contentHeight = hei + 2;
    
    [_cellHeightArray addObject:[NSString stringWithFormat:@"%f",contentHeight + 70]];
    
    //-------------------------------------------------------------------------

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

- (CGSize)frameSizeForAttributedString:(NSAttributedString *)attributedString
{
    CTTypesetterRef typesetter = CTTypesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 70.0;
    
    CFIndex offset = 0, length;
    CGFloat y = 0;
    do {
        length = CTTypesetterSuggestLineBreak(typesetter, offset, width);
        CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(offset, length));
        
        CGFloat ascent, descent, leading;
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        
        CFRelease(line);
        
        offset += length;
        y += ascent + descent + leading;
    } while (offset < [attributedString length]);
    
    CFRelease(typesetter);
    
    return CGSizeMake(width, ceil(y));
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

//-----add by kate--------------------------------------------------
-(void)showCustomKeyBoard{
    
    // 自定义数据框
    toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height - 44 - 44, WIDTH, 44)];
    toolBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _inputTextView = [[UITextView alloc]initWithFrame:CGRectMake(43.0, 5.0, [UIScreen mainScreen].bounds.size.width - 60 - 33, 33)];
    _inputTextView.delegate = self;
    _inputTextView.backgroundColor = [UIColor clearColor];
    _inputTextView.returnKeyType = UIReturnKeyDone;
    //    [_inputTextView.layer setCornerRadius:6];
    //    [_inputTextView.layer setMasksToBounds:YES];
    
    
    //---update 2015.07.23-----------------------------------------------
    
    //        UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTextView:)];
    //        singleTouch.delegate = self;
    //        [_inputTextView addGestureRecognizer:singleTouch];
    
    
    //---------------------------------------------------------------------
    
    UIImage *rawEntryBackground = [UIImage imageNamed:@"friend/bg_message_entry_InputField2.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:15 topCapHeight:21];
    entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(43.0, 5, [UIScreen mainScreen].bounds.size.width - 60 - 33, 33);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    entryImageView.userInteractionEnabled = YES;
    
    [toolBar addSubview:entryImageView];
    [toolBar addSubview:_inputTextView];
    
    if (!faceBoard) {
        
        faceBoard = [[FaceBoard alloc] init];
        faceBoard.delegate = self;
        faceBoard.maxLength = 500;// 2015.07.21
        faceBoard.inputTextView = _inputTextView;
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
    [_inputTextView resignFirstResponder];
    
    if ([@""  isEqual: _inputTextView.text]) {
        [Utilities showFailedHud:@"请输入回复内容。" descView:_inputTextView.inputView];//2015.05.12
    }else {
        [Utilities showProcessingHud:self.view];
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              _cmtSid, @"sid",
                              @"News", @"ac",
                              @"2", @"v",
                              @"post", @"op",
                              _newsId, @"nid",
                              _inputTextView.text, @"message",
                              _otherPid, @"cid",
                              nil];
        
        [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
            
            NSDictionary *respDic = (NSDictionary*)responseObject;
            NSString *result = [respDic objectForKey:@"result"];
            
            if(true == [result intValue]) {
                
                _otherPid = nil;
                
                [ReportObject event:ID_COMMENT_REPLY];//2015.07.02
                
                [Utilities dismissProcessingHud:self.view];
                
                [Utilities showSuccessedHud:@"回复成功。" descView:self.view];
                
                startNum = @"0";
                
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      _cmtSid, @"sid",
                                      @"News", @"ac",
                                      @"2", @"v",
                                      @"comments", @"op",
                                      _newsId, @"nid",
                                      @"0", @"page",
                                      @"15", @"size",
                                      nil];
                
                [self doGetCommentData:data];
            } else {
                [Utilities dismissProcessingHud:self.view];
                
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                               message:@"获取信息错误，请稍候再试"
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
                [alert show];
            }
            
        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
            [Utilities doHandleTSNetworkingErr:error descView:self.view];
        }];
        
        
        
        //        if (isCommentComment) {
        //
        //            [Utilities showProcessingHud:self.view];// 2015.05.12
        //            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
        //                                  @"Circle",@"ac",
        //                                  @"2",@"v",
        //                                  @"comment", @"op",
        //                                  _tid, @"tid",
        //                                  _deletePid, @"pid",
        //                                  textView.text, @"message",
        //                                  nil];
        //
        //            [network sendHttpReq:HttpReq_MomentsComment andData:data];
        //
        //            isCommentComment = NO;
        //        }else {
        //
        //            [Utilities showProcessingHud:self.view];// 2015.05.12
        //
        //            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
        //                                  @"Circle",@"ac",
        //                                  @"2",@"v",
        //                                  @"comment", @"op",
        //                                  _tid, @"tid",
        //                                  textView.text, @"message",
        //                                  nil];
        //
        //            [network sendHttpReq:HttpReq_MomentsComment andData:data];
        //        }
        //
        //--------------------------------------------------
        //键盘下落
        isButtonClicked = NO;
        _inputTextView.inputView = nil;
        isSystemBoardShow = NO;
        _inputTextView.text = @"";
        _inputTextView.frame = CGRectMake(43.0, 5.0, 205-15+40.0, 33);
        clickFlag = 0;
        [_inputTextView resignFirstResponder];
        toolBar.frame = CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height - 44 - 44, WIDTH, 44);
        [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                        forState:UIControlStateNormal];
        [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                        forState:UIControlStateHighlighted];
    }
}

//// 自定义输入框点击输入框事件
//-(void)clickTextView:(id)sender{
//
//    if (_inputTextView.inputView!=nil) {
//        isButtonClicked = YES;
//        _inputTextView.inputView = nil;
//        isSystemBoardShow = YES;
//        clickFlag = 0;
//        [_inputTextView resignFirstResponder];
//    }else{
//
//        if (![_inputTextView isFirstResponder]) {
//            [_inputTextView becomeFirstResponder];
//        }
//    }
//}

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
        //            if ([textView.text length] == 0 && photoFlagImageView.hidden == YES) {
        //                AudioButton.frame = CGRectMake(284.0 - 7 , 5.0, 33.0, 33.0);
        //                [AudioButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/audio_normal.png"] forState:UIControlStateNormal];
        //                [AudioButton setImage:[UIImage imageNamed:@"faceImages/faceBoard/audio_press.png"] forState:UIControlStateHighlighted];
        //            }
        //
        //            return NO;
        //        }
        
        return YES;
    }
    else {
        textView.textColor = [UIColor blackColor];
        
        if (range.location >= 500) {// 校园公告回帖 500 2015.07.21
            return NO;
        }else{
            if ([text isEqualToString:@"\n"]){
                isButtonClicked = NO;
                
                [textView resignFirstResponder];
                return NO;
            }else{
                if (_isFirstClickReply) {
                    textView.text = @"";
                    _isFirstClickReply = false;
                }
                
                return YES;
            }
        }
        
    }
}

- (void)textViewDidChange:(UITextView *)_textView {
    
    _replyToLabel.text = _replyTo;
    
    if ([_textView.text length] == 0) {
        [_replyToLabel setHidden:NO];
    }else{
        [_replyToLabel setHidden:YES];
    }
    
    CGSize size = _inputTextView.contentSize;
    size.height -= 2;
    if ( size.height >= 68 ) {
        
        size.height = 68;
    }
    else if ( size.height <= 32 ) {
        
        size.height = 32;
    }
    
    if ( size.height != _inputTextView.frame.size.height ) {
        
        CGFloat span = size.height - _inputTextView.frame.size.height;
        
        CGRect frame = toolBar.frame;
        frame.origin.y -= span;
        frame.size.height += span;
        toolBar.frame = frame;
        
        CGFloat centerY = frame.size.height / 2;
        
        frame = _inputTextView.frame;
        frame.size = size;
        _inputTextView.frame = frame;
        
        CGPoint center = _inputTextView.center;
        center.y = centerY;
        _inputTextView.center = center;
        
    }
}
- (void)faceBoardHide:(id)sender{
    
    //    BOOL needReload = NO;
    //    if ( ![textView.text isEqualToString:@""] ) {
    //
    //        needReload = YES;
    //
    //        NSMutableArray *messageRange = [[NSMutableArray alloc] init];
    //        [self getMessageRange:textView.text :messageRange];
    //        [messageList addObject:messageRange];
    //        [messageRange release];
    //
    //        messageRange = [[NSMutableArray alloc] init];
    //        [self getMessageRange:textView.text :messageRange];
    //        [messageList addObject:messageRange];
    //        [messageRange release];
    //    }
    //
    
    _inputTextView.text = nil;
    [self textViewDidChange:_inputTextView];
    
    [_inputTextView resignFirstResponder];
    
    isFirstShowKeyboard = YES;
    
    isButtonClicked = NO;
    
    _inputTextView.inputView = nil;
    
    [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_d.png"]
                    forState:UIControlStateNormal];
    [keyboardButton setImage:[UIImage imageNamed:@"btn_bq_p.png"]
                    forState:UIControlStateHighlighted];
    
    //    if ( needReload ) {
    //
    //        [messageListView reloadData];
    //
    //        [messageListView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messageList.count - 1
    //                                                                   inSection:0]
    //                               atScrollPosition:UITableViewScrollPositionBottom
    //                                       animated:NO];
    //    }
    
    
}

-(void)faceBoardClick:(id)sender{
    
    clickFlag = 1;
    isButtonClicked = YES;
    
    if ( isKeyboardShowing ) {
        
        [_inputTextView resignFirstResponder];
    }
    else {
        
        if ( isFirstShowKeyboard ) {
            
            isFirstShowKeyboard = NO;
            
            isSystemBoardShow = NO;
        }
        
        if ( !isSystemBoardShow ) {
            
            _inputTextView.inputView = faceBoard;
        }
        
        [_inputTextView becomeFirstResponder];
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
                
                if ( [_inputTextView.inputView isEqual:faceBoard] || [_inputTextView.inputView isEqual:addImageView]) {
                    
                    isSystemBoardShow = YES;
                    _inputTextView.inputView = nil;
                    
                    UIImage *img = [UIImage imageNamed:@"btn_sr_d.png"];
                    
                    if ([Utilities image:keyboardButton.imageView.image equalsTo:img]) {
                        
                        isSystemBoardShow = YES;
                        _inputTextView.inputView = nil;
                    }else{
                        isSystemBoardShow = NO;
                        _inputTextView.inputView = faceBoard;
                        
                    }
                    
                    
                    
                }else{
                    
                    isSystemBoardShow = NO;
                    _inputTextView.inputView = faceBoard;
                    
                }
            }
                
                break;
            default:
                break;
        }
        
        [_inputTextView becomeFirstResponder];
    }
}

-(void)dismissKeyboard{
    
    [_inputTextView resignFirstResponder];
}

-(void)reloadData
{
    [_tableView reloadData];
    [self setFooterView];
}

-(void)doGoToProfileView:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    NSString *fuid = [dic objectForKey:@"uid"];
    
    FriendProfileViewController *friendProfileViewCtrl = [[FriendProfileViewController alloc] init];
    friendProfileViewCtrl.fuid = fuid;
    [self.navigationController pushViewController:friendProfileViewCtrl animated:YES];
}

@end
