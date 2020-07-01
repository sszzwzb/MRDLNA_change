//
//  HomeworkDetailViewController.m
//  MicroSchool
//
//  Created by CheungStephen on 1/29/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "HomeworkDetailViewController.h"

@interface HomeworkDetailViewController ()

@end

@implementation HomeworkDetailViewController

#define BOTTOM_BUTTON_HEIGHT  50              // 底部button的高度

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _detailInfo = [[NSMutableDictionary alloc] init];
    
    _questions = [[NSMutableDictionary alloc] init];
    _questionsPicsArray = [[NSMutableArray alloc] init];

    _answers = [[NSMutableDictionary alloc] init];
    _answersPicsArray = [[NSMutableArray alloc] init];

    _firstAnswers = [[NSMutableDictionary alloc] init];
    _firstAnswersPicsArray = [[NSMutableArray alloc] init];

    _secondAnswers = [[NSMutableDictionary alloc] init];
    _secondAnswersPicsArray = [[NSMutableArray alloc] init];

    _commentArray = [[NSMutableArray alloc] init];
    _historyDic = [[NSMutableDictionary alloc] init];
    
    commentHeightArr = [[NSMutableArray alloc] init];

    [super setCustomizeTitle:_disTitle];
    [super setCustomizeLeftButton];

    [self doGetHomeworkDetail];
    
    // 刷新详情画面的通知。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reLoadHomeworkDetailView)
                                                 name:@"reLoadHomeworkDetailView"
                                               object:nil];
    
    // 在学生上传完作业之后更新这条作业的state值。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateHomeworkDetailViewState)
                                                 name:@"updateHomeworkDetailViewState"
                                               object:nil];

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
    
    // 手势识别
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    singleTouch.delegate = self;
    [self.view addGestureRecognizer:singleTouch];


    [ReportObject event:ID_OPEN_HOMEWORK_DETAIL];//2016.02.26
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reLoadHomeworkDetailView {
    [self performSelector:@selector(doReLoadHomeworkDetailView) withObject:nil afterDelay:0.1];
}

- (void)updateHomeworkDetailViewState {
    // 0:未改,3:未做,2:完成
    NSString *state = [NSString stringWithFormat:@"%@", [_detailInfo objectForKey:@"state"]];

    if ([@"0"  isEqual: state]) {
        state = @"2";
    }else if ([@"3"  isEqual: state]) {
        state = @"0";
    }
    
    NSString *finished;
    if ([@"2"  isEqual: state]) {
        finished = [NSString stringWithFormat:@"%ld", [[_detailInfo objectForKey:@"finished"] integerValue] + 1];
    }else {
        finished = [_detailInfo objectForKey:@"finished"];
    }
    
    // 通知作业列表页面刷新状态
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         _homeworkListIndex,@"index",
                         state,@"state",
                         finished,@"finished",
                         nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHomeList" object:dic];
}

- (void)doReLoadHomeworkDetailView {
    // 先移除所有subview。
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    // 重新获取作业详情。
    [self doGetHomeworkDetail];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)selectLeftAction:(id)sender {
    if (nil == _submitToDetail) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyHomework" object:nil];

        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    }
}

- (void)selectRightAction:(id)sender {
    NSMutableArray *imageArrar_content = [[NSMutableArray alloc] init];
    NSMutableArray *imageArrar_answer = [[NSMutableArray alloc] init];

    NSMutableArray *picsContent = [_questions objectForKey:@"pics"];
    for (int i=0; i<[picsContent count]; i++) {
        NSDictionary *picDic = [picsContent objectAtIndex:i];
        
        UIImage *picImage = nil;
        NSString *key = [picDic objectForKey:@"url"];
        picImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:key];

        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             picImage, @"image",
                             [NSString stringWithFormat:@"%@", [picDic objectForKey:@"id"]], @"imageId",
                             nil];
        
        [imageArrar_content addObject:dic];
    }
    
    NSMutableArray *picsAnswer = [_answers objectForKey:@"pics"];
    for (int i=0; i<[picsAnswer count]; i++) {
        NSDictionary *picDic = [picsAnswer objectAtIndex:i];
        
        UIImage *picImage = nil;
        NSString *key = [picDic objectForKey:@"url"];
        picImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:key];
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             picImage, @"image",
                             [NSString stringWithFormat:@"%@", [picDic objectForKey:@"id"]], @"imageId",
                             nil];
        
        [imageArrar_answer addObject:dic];
    }

    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                          [_detailInfo objectForKey:@"title"],@"title",
                          [_detailInfo objectForKey:@"times"],@"time",
                          [_questions objectForKey:@"content"], @"content",
                          [_answers objectForKey:@"content"], @"answer",
                          imageArrar_content, @"imageArray_content",
                          imageArrar_answer, @"imageArray_answer",
                          nil];
    
    // 修改作业
    SubmitHWViewController *vc = [[SubmitHWViewController alloc] init];
    vc.flag = 1;
    vc.dic = data;
    vc.cid = _cid;
    vc.tid = _tid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)doGetHomeworkDetail {
    [Utilities showProcessingHud:self.view];
    
    NSString *ac = @"";
    NSString *op = @"";
    
    if ([@"teacher"  isEqual: _viewType]) {
        ac = @"HomeworkTeacher";
        op = @"view";
    }else if ([@"student"  isEqual: _viewType]) {
        ac = @"Homework";
        op = @"view";
    }

    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          ac,@"ac",
                          @"3",@"v",
                          op, @"op",
                          _tid, @"tid",
                          _cid, @"cid",
                          @"1000", @"size",
                          @"0", @"page",

                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            NSDictionary *msg = [respDic objectForKey:@"message"];
            
            _number = [NSString stringWithFormat:@"%@", [msg objectForKey:@"number"]];
            
            NSDictionary *homework = [msg objectForKey:@"homework"];
            if ((nil != homework) && (![homework isKindOfClass:[NSNull class]])) {
                _detailInfo = [NSMutableDictionary dictionaryWithDictionary:homework];
            }else {
                _detailInfo = nil;
            }
            
            if ([@"teacher"  isEqual: _viewType]) {
                if (nil != _homeworkListIndex) {
                    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         _homeworkListIndex,@"index",
                                         [_detailInfo objectForKey:@"answer"],@"answer",
                                         [_detailInfo objectForKey:@"title"],@"title",
                                         nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeworkAnswer" object:dic];
                }
            }

            NSDictionary *questions = [msg objectForKey:@"questions"];
            if ((nil != questions) && (![questions isKindOfClass:[NSNull class]])) {
                _questions = [NSMutableDictionary dictionaryWithDictionary:questions];
            }else {
                _questions = nil;
            }

            NSDictionary *answers = [msg objectForKey:@"answers"];
            if ((nil != answers) && (![answers isKindOfClass:[NSNull class]])) {
                _answers = [NSMutableDictionary dictionaryWithDictionary:answers];
            }else {
                _answers = nil;
            }

            if ([@"teacher"  isEqual: _viewType]) {
                NSDictionary *statistics = [msg objectForKey:@"statistics"];
                if ((nil != statistics) && (![statistics isKindOfClass:[NSNull class]])) {
                    _statistics = [NSMutableDictionary dictionaryWithDictionary:statistics];
                }else {
                    _statistics = nil;
                }

                // 老师显示下方的三个button，未完成，未批改，已完成。
                [self showBottomButtonTeacher];
            }else if ([@"student"  isEqual: _viewType]) {
                // 学生身份需要增加这2个字段
                NSDictionary *first_answers = [msg objectForKey:@"first_answers"];
                if ((nil != first_answers) && (![first_answers isKindOfClass:[NSNull class]])) {
                    _firstAnswers = [NSMutableDictionary dictionaryWithDictionary:first_answers];
                }else {
                    _firstAnswers = nil;
                }
                
                NSDictionary *second_answers = [msg objectForKey:@"second_answers"];
                if ((nil != second_answers) && (![second_answers isKindOfClass:[NSNull class]])) {
                    _secondAnswers = [NSMutableDictionary dictionaryWithDictionary:second_answers];
                }else {
                    _secondAnswers = nil;
                }
                
                if ([@"1"  isEqual: [_detailInfo objectForKey:@"answer"]]) {
                    // 有答案的情况下才显示下面的button，并且需要绑定了学籍信息。
                    if (![@"0"  isEqual: _number]) {
                        [self showBottomButtonStudent];
                    }
                }
            }
            
            NSDictionary *comments = [msg objectForKey:@"comments"];
            if ((nil != comments) && (![comments isKindOfClass:[NSNull class]])) {
                commentsArray = [NSMutableArray arrayWithArray:[comments objectForKey:@"list"]];
            }else {
                commentsArray = nil;
            }
            
            NSDictionary *history = [msg objectForKey:@"history"];
            if ((nil != history) && (![history isKindOfClass:[NSNull class]])) {
                _historyDic = [NSMutableDictionary dictionaryWithDictionary:history];
            }else {
                _historyDic = nil;
            }

            [commentHeightArr removeAllObjects];
            
            for (id obj in commentsArray) {
                
                NSDictionary *dic = (NSDictionary *)obj;
                
                NSString *msg = [self transComment2TSAttLabel:dic];
                
                CGSize size = [self getCommentAttrHeight:msg];
                
                // 由于还有上下的留白部分，给每个评论cell的高度增加14
                //int height = size.height  + 14;
                int height = size.height;
                
                [commentHeightArr addObject:[NSString stringWithFormat:@"%d", height]];
            }
            
            
            [self showHomeworkDetailInfo];
            [self showCustomKeyBoard];
            
            //班级没绑定学籍的情况下 教师 学生 家长 不显示蒙版 2016.03.09
            if([_spaceForClass integerValue] == 1){
                // 判断是否需要使用蒙版
                [self isNeedShowMasking];
            }
            
        } else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:[respDic objectForKey:@"message"]
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];//add by kate 2016.03.09 万一失败也使process消失 不然一直转
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
}

- (void)isNeedShowMasking{
    if ([@"teacher"  isEqual: _viewType]) {
        if ([@"1"  isEqual: [_detailInfo objectForKey:@"answer"]]) {
            // 有答案的情况
            NSString *mask = [[NSUserDefaults standardUserDefaults] objectForKey:@"homeworkDetailViewTeacherMasking"];
            
            if (nil == mask) {
                [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"homeworkDetailViewTeacherMasking"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                if (iPhone4) {
                    [self showMaskingView:CGRectMake(100, 270, 100, 40) image:[UIImage imageNamed:@"Masking/homeworkDetailViewTeacherFor4.png"]];
                }else {
                    [self showMaskingView:CGRectMake(100, 270, 100, 40) image:[UIImage imageNamed:@"Masking/homeworkDetailViewTeacher.png"]];
                }
            }
        }
    }else if ([@"student"  isEqual: _viewType] && [@"1"  isEqual: [_detailInfo objectForKey:@"answer"]]) {
        // 有答案的情况
        NSString *state = [NSString stringWithFormat:@"%@", [_detailInfo objectForKey:@"state"]];
        // 0:未改,3:未做,2:完成
        if ([@"3"  isEqual: state]) {
            // 完成的状态时候不需要显示底部的button
            NSString *mask = [[NSUserDefaults standardUserDefaults] objectForKey:@"homeworkDetailViewStudentNotDoneMasking"];
            
            if (nil == mask) {
                [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"homeworkDetailViewStudentNotDoneMasking"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                if (iPhone4) {
                    [self showMaskingView:CGRectMake(100, 270, 100, 40) image:[UIImage imageNamed:@"Masking/homeworkDetailStudentNotDoneFor4"]];
                }else {
                    [self showMaskingView:CGRectMake(100, 270, 100, 40) image:[UIImage imageNamed:@"Masking/homeworkDetailStudentNotDone"]];
                }
            }
        }else if ([@"0"  isEqual: state]) {
            // 需要绑定了学籍信息才显示底部button。
            if (![@"0"  isEqual: _number]) {
                NSString *mask = [[NSUserDefaults standardUserDefaults] objectForKey:@"homeworkDetailViewStudentNotCommentMasking"];
                
                if (nil == mask) {
                    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"homeworkDetailViewStudentNotCommentMasking"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    if (iPhone4) {
                        [self showMaskingView:CGRectMake(100, 280, 100, 40) image:[UIImage imageNamed:@"Masking/homeworkDetailStudentNotCommentFor4"]];
                    }else {
                        [self showMaskingView:CGRectMake(100, 280, 100, 40) image:[UIImage imageNamed:@"Masking/homeworkDetailStudentNotComment"]];
                    }
                }
            }
        }
    }
}

- (void)showMaskingView:(CGRect )rect image:(UIImage *)img{
    _viewMasking = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UIImageView *imageViewMasking = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [imageViewMasking setImage:img];
    [_viewMasking addSubview:imageViewMasking];
    
    UIButton *buttonMasking = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonMasking.frame = rect;
        //buttonMasking.backgroundColor = [UIColor redColor];
    [buttonMasking addTarget:self action:@selector(dismissMaskingView:) forControlEvents: UIControlEventTouchUpInside];
    [_viewMasking addSubview:buttonMasking];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_viewMasking];
}

- (void)showHomeworkDetailInfo {
    if ([[Utilities getUniqueUid] isEqual: [_detailInfo objectForKey:@"uid"]]) {
        if ([@"teacher"  isEqual: _viewType]) {
            // 只有老师才能修改作业。
            [super setCustomizeRightButtonWithName:@"修改"];
        }
    }

//    UIView *v = [UIView new];
//    
//    
//    _tableView = [UITableView new];
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    _tableView.tableHeaderView = _scrollViewBg;
//    _tableView.tableFooterView = [[UIView alloc] init];
//    //        [self->_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    
//    [self.view addSubview:_tableView];
//    
//    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_homeworkContent.mas_bottom).with.offset(30);
//        make.left.equalTo(_homeworkContent.mas_left).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, 400));
//    }];
//    
//    // 没有答案的情况下，只显示问题
//    [_viewWhiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(_tableView.mas_bottom);
//    }];

    
#if 9
    _scrollViewBg = [UIScrollView new];
    _scrollViewBg.scrollEnabled = YES;
    _scrollViewBg.delegate = self;
    [self.view addSubview:_scrollViewBg];
    
    [_scrollViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        if ([@"teacher"  isEqual: _viewType]) {
            if ([@"1"  isEqual: [_detailInfo objectForKey:@"answer"]]) {
                if ([@"1"  isEqual: _spaceForClass]) {
                    make.top.equalTo(self.view).with.offset(BOTTOM_BUTTON_HEIGHT+1.5);
                    make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, [Utilities getScreenSizeWithoutBar].height-BOTTOM_BUTTON_HEIGHT-0.5-44));
                }else {
                    make.top.equalTo(self.view).with.offset(0);
                    make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, [Utilities getScreenSizeWithoutBar].height-44));
                }
            }else {
                make.top.equalTo(self.view).with.offset(0);
                make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, [Utilities getScreenSizeWithoutBar].height-44));
            }
        }else if ([@"student"  isEqual: _viewType]) {
            if ([@"0"  isEqual: [_detailInfo objectForKey:@"answer"]]) {
                // 没有答案
                make.top.equalTo(self.view).with.offset(0);
                make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, [Utilities getScreenSizeWithoutBar].height-44));
            }else {
                if ([@"1"  isEqual: _spaceForClass]) {
                    // 0:未改,3:未做,2:完成
                    NSString *state = [NSString stringWithFormat:@"%@", [_detailInfo objectForKey:@"state"]];
                    if ([@"2"  isEqual: state]) {
                        make.top.equalTo(self.view).with.offset(0);
                        
                        // 完成的状态时候不需要显示底部的button
                        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, [Utilities getScreenSizeWithoutBar].height-44));
                    }else {
                        make.top.equalTo(self.view).with.offset(BOTTOM_BUTTON_HEIGHT+1.5);
                        
                        // 需要绑定了学籍信息才显示底部button。
                        if (![@"0"  isEqual: _number]) {
                            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, [Utilities getScreenSizeWithoutBar].height-BOTTOM_BUTTON_HEIGHT-0.5-44));
                        }else {
                            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, [Utilities getScreenSizeWithoutBar].height-44));
                        }
                    }
                }else {
                    make.top.equalTo(self.view).with.offset(0);
                    
                    // 完成的状态时候不需要显示底部的button
                    make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, [Utilities getScreenSizeWithoutBar].height-44));
                }
            }
        }
    }];

    _viewWhiteBg = [UIView new];
    _viewWhiteBg.backgroundColor = [UIColor whiteColor];
    [_scrollViewBg addSubview:_viewWhiteBg];
    
    // 这里设置了背景白色view的edges与scrollView的一致，这样就不需要再次计算这个白色view的size了
    // 这样做可以避免同时两个view依赖于scrollView的contentSize来计算自己的size。
    // 如果有两个view同时依赖于scrollView算高度的话，就会出现其中一个view无法计算正确地高度，并且会有很多警告。
    [_viewWhiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollViewBg).with.insets(UIEdgeInsetsMake(0, 0, 20, 0));
        make.width.equalTo(_scrollViewBg);
    }];

    _headInfo = [HomeworkDetailHead new];
    _headInfo.delegate = self;
    [_scrollViewBg addSubview:_headInfo];
    
    [_headInfo initElementsWithDic:_detailInfo];
    [_headInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollViewBg).with.offset(0);
        make.left.equalTo(_scrollViewBg).with.offset(0);
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, 0));
    }];

    _homeworkContent = [HomeworkDetailInfo new];
    _homeworkContent.delegate = self;
    [_scrollViewBg addSubview:_homeworkContent];
    
    [_homeworkContent initElementsWithDic:_questions showTitle:nil];
    [_homeworkContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headInfo.mas_bottom).with.offset(15);
        make.left.equalTo(_headInfo.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, 0));
    }];

    if ([@"1"  isEqual: [_detailInfo objectForKey:@"answer"]]) {
        // 有答案的情况下才显示答案
        // 还需要判断学生情况下，如果没上传作业照片就不让看答案。
        
        if ([@"teacher"  isEqual: _viewType]) {
            // 教师身份只显示作业内容与答案。所以设置scrollView的bottom的为答案的bottom。
            _homeworkAnswer = [HomeworkDetailInfo new];
            _homeworkAnswer.delegate = self;
            [_scrollViewBg addSubview:_homeworkAnswer];
            
            [_homeworkAnswer initElementsWithDic:_answers showTitle:@"答案："];
            [_homeworkAnswer mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_homeworkContent.mas_bottom).with.offset(15);
                make.left.equalTo(_homeworkContent.mas_left).with.offset(0);
                make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, 0));
            }];

//            [_viewWhiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.bottom.equalTo(_homeworkAnswer.mas_bottom);
//            }];
            
            _btn_history = [UIButton new];
            [_btn_history addTarget:self action:@selector(btnclick_history:) forControlEvents:UIControlEventTouchUpInside];
            _btn_history.contentMode = UIViewContentModeScaleToFill;
            [self showHistory];
            [_scrollViewBg addSubview:_btn_history];
            
            [_btn_history mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_homeworkAnswer.mas_bottom).with.offset(20);
                make.left.equalTo(_scrollViewBg).with.offset(10);
                make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-20, 50));
            }];

        }else if ([@"student"  isEqual: _viewType]) {
            // 0:未改,3:未做,2:完成
            NSString *state = [NSString stringWithFormat:@"%@", [_detailInfo objectForKey:@"state"]];
 
            if (![@"3"  isEqual: state]) {
                // 学生身份需要显示第一次，或者还需要显示第二次的答案。
                _homeworkAnswer = [HomeworkDetailInfo new];
                _homeworkAnswer.delegate = self;
                [_scrollViewBg addSubview:_homeworkAnswer];
                
                [_homeworkAnswer initElementsWithDic:_answers showTitle:@"答案："];
                [_homeworkAnswer mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(_homeworkContent.mas_bottom).with.offset(15);
                    make.left.equalTo(_homeworkContent.mas_left).with.offset(0);
                    make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, 0));
                }];

                if (nil != _firstAnswers) {
                    UIView *viewLine = [UIView new];
                    viewLine.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1];
                    [_scrollViewBg addSubview:viewLine];
                    
                    [viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(_homeworkAnswer.mas_bottom).with.offset(20);
                        make.left.equalTo(self.view).with.offset(0);
                        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, 0.5));
                    }];
                    
                    _homeworkFirstAnswer = [HomeworkDetailInfo new];
                    _homeworkFirstAnswer.delegate = self;
                    [_scrollViewBg addSubview:_homeworkFirstAnswer];
                    
                    [_homeworkFirstAnswer initElementsWithDic:_firstAnswers showTitle:@"我的作答："];
                    [_homeworkFirstAnswer mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(viewLine.mas_bottom).with.offset(15);
                        make.left.equalTo(_homeworkAnswer.mas_left).with.offset(0);
                        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, 0));
                    }];
                    
                    if ((nil != _secondAnswers)  && ([@"2"  isEqual: [NSString stringWithFormat:@"%@", [_detailInfo objectForKey:@"state"]]])) {
                        _homeworkSecondAnswer = [HomeworkDetailInfo new];
                        _homeworkSecondAnswer.delegate = self;
                        [_scrollViewBg addSubview:_homeworkSecondAnswer];
                        
                        NSString *str = @"我的批改：";
                        NSArray *pics = [_secondAnswers objectForKey:@"pics"];
                        if ((0 == [pics count]) && ([@"2"  isEqual: [NSString stringWithFormat:@"%@", [_detailInfo objectForKey:@"state"]]])) {
                            // 需要为我的批改做一个特殊处理，因为可能需要显示全部答对
                            str = @"我的批改：作业全部答对。";
                        }
                        [_homeworkSecondAnswer initElementsWithDic:_secondAnswers showTitle:str];
                        [_homeworkSecondAnswer mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(_homeworkFirstAnswer.mas_bottom).with.offset(30);
                            make.left.equalTo(_homeworkFirstAnswer.mas_left).with.offset(0);
                            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, 0));
                        }];
                        
//                        [_viewWhiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
//                            make.bottom.equalTo(_homeworkSecondAnswer.mas_bottom);
//                        }];
                        
                        _btn_history = [UIButton new];
                        [_btn_history addTarget:self action:@selector(btnclick_history:) forControlEvents:UIControlEventTouchUpInside];
                        _btn_history.contentMode = UIViewContentModeScaleToFill;
                        [self showHistory];
                        [_scrollViewBg addSubview:_btn_history];
                        
                        [_btn_history mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(_homeworkSecondAnswer.mas_bottom).with.offset(20);
                            make.left.equalTo(_scrollViewBg).with.offset(10);
                            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-20, 50));
                        }];

                    }else {
//                        [_viewWhiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
//                            make.bottom.equalTo(_homeworkFirstAnswer.mas_bottom);
//                        }];
                        
                        _btn_history = [UIButton new];
                        [_btn_history addTarget:self action:@selector(btnclick_history:) forControlEvents:UIControlEventTouchUpInside];
                        _btn_history.contentMode = UIViewContentModeScaleToFill;
                        [self showHistory];
                        [_scrollViewBg addSubview:_btn_history];
                        
                        [_btn_history mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(_homeworkFirstAnswer.mas_bottom).with.offset(20);
                            make.left.equalTo(_scrollViewBg).with.offset(10);
                            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-20, 50));
                        }];

                    }
                }else {
                    // 没有回答的情况下，只显示答案
//                    [_viewWhiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
//                        make.bottom.equalTo(_homeworkAnswer.mas_bottom);
//                    }];
                    
                    _btn_history = [UIButton new];
                    [_btn_history addTarget:self action:@selector(btnclick_history:) forControlEvents:UIControlEventTouchUpInside];
                    _btn_history.contentMode = UIViewContentModeScaleToFill;
                    [self showHistory];
                    [_scrollViewBg addSubview:_btn_history];
                    
                    [_btn_history mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(_homeworkAnswer.mas_bottom).with.offset(20);
                        make.left.equalTo(_scrollViewBg).with.offset(10);
                        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-20, 50));
                    }];
                    

                }
            }else {
                // 未做的情况下，只显示问题
//                [_viewWhiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.bottom.equalTo(_homeworkContent.mas_bottom);
//                }];
                _btn_history = [UIButton new];
                [_btn_history addTarget:self action:@selector(btnclick_history:) forControlEvents:UIControlEventTouchUpInside];
                _btn_history.contentMode = UIViewContentModeScaleToFill;
                [self showHistory];
                [_scrollViewBg addSubview:_btn_history];
                
                [_btn_history mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(_homeworkContent.mas_bottom).with.offset(20);
                    make.left.equalTo(_scrollViewBg).with.offset(10);
                    make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-20, 50));
                }];

            }
        }
    }else {
        _btn_history = [UIButton new];
        [_btn_history addTarget:self action:@selector(btnclick_history:) forControlEvents:UIControlEventTouchUpInside];
        _btn_history.contentMode = UIViewContentModeScaleToFill;
        [self showHistory];
        [_scrollViewBg addSubview:_btn_history];
        
        [_btn_history mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_homeworkContent.mas_bottom).with.offset(20);
            make.left.equalTo(_scrollViewBg).with.offset(10);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-20, 50));
        }];

        
    }

    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = nil;
    _tableView.scrollEnabled = NO;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    [_scrollViewBg addSubview:_tableView];
    
    float th = 0;
    for (int i=0; i<[commentHeightArr count]; i++) {
        th = [[commentHeightArr objectAtIndex:i] floatValue] + th;
    }
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_btn_history.mas_bottom).with.offset(0);
        make.left.equalTo(_scrollViewBg).with.offset(0);
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, th));
    }];
    
    // 没有答案的情况下，只显示问题
    [_viewWhiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_tableView.mas_bottom);
    }];

//    [_viewWhiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(_tableView.mas_bottom);
//    }];
#endif
}

- (IBAction)btnclick_history:(id)sender
{
    DiscussHistoryViewController *historyViewCtrl = [[DiscussHistoryViewController alloc] init];
    historyViewCtrl.tid = _tid;
    historyViewCtrl.cid = _cid;
    [self.navigationController pushViewController:historyViewCtrl animated:YES];

//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                         uid, @"uid",
//                         nil];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_fromDiscussDetailView2History" object:self userInfo:dic];
}

- (void)showHistory {
    // 浏览痕迹
    _imgView_historyBg =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 50)];
    _imgView_historyBg.contentMode = UIViewContentModeScaleToFill;
    [_imgView_historyBg setImage:[UIImage imageNamed:@"tlq_history.png"]];
    _imgView_historyBg.userInteractionEnabled = NO;
    [_btn_history addSubview:_imgView_historyBg];
    
    // 浏览痕迹上面的5各头像
    _imgView_headImg1 =[[UIImageView alloc]initWithFrame:CGRectZero];
    _imgView_headImg1.contentMode = UIViewContentModeScaleToFill;
    _imgView_headImg1.layer.masksToBounds = YES;
    _imgView_headImg1.layer.cornerRadius = 20.0f;
    _imgView_headImg1.userInteractionEnabled = NO;
    [_btn_history addSubview:_imgView_headImg1];
    
    _imgView_headImg2 =[[UIImageView alloc]initWithFrame:CGRectZero];
    _imgView_headImg2.contentMode = UIViewContentModeScaleToFill;
    _imgView_headImg2.layer.masksToBounds = YES;
    _imgView_headImg2.layer.cornerRadius = 20.0f;
    _imgView_headImg2.userInteractionEnabled = NO;
    [_btn_history addSubview:_imgView_headImg2];
    
    _imgView_headImg3 =[[UIImageView alloc]initWithFrame:CGRectZero];
    _imgView_headImg3.contentMode = UIViewContentModeScaleToFill;
    _imgView_headImg3.layer.masksToBounds = YES;
    _imgView_headImg3.layer.cornerRadius = 20.0f;
    _imgView_headImg3.userInteractionEnabled = NO;
    
    [_btn_history addSubview:_imgView_headImg3];
    
    _imgView_headImg4 =[[UIImageView alloc]initWithFrame:CGRectZero];
    _imgView_headImg4.contentMode = UIViewContentModeScaleToFill;
    _imgView_headImg4.layer.masksToBounds = YES;
    _imgView_headImg4.layer.cornerRadius = 20.0f;
    _imgView_headImg4.userInteractionEnabled = NO;
    
    [_btn_history addSubview:_imgView_headImg4];
    
    _imgView_headImg5 =[[UIImageView alloc]initWithFrame:CGRectZero];
    _imgView_headImg5.contentMode = UIViewContentModeScaleToFill;
    _imgView_headImg5.layer.masksToBounds = YES;
    _imgView_headImg5.layer.cornerRadius = 20.0f;
    _imgView_headImg5.userInteractionEnabled = NO;
    
    [_btn_history addSubview:_imgView_headImg5];
    
    _label_historyCount = [[UILabel alloc] initWithFrame:CGRectZero];
    _label_historyCount.lineBreakMode = NSLineBreakByWordWrapping;
    _label_historyCount.font = [UIFont systemFontOfSize:14.0f];
    _label_historyCount.numberOfLines = 0;
    _label_historyCount.textColor = [UIColor blackColor];
    _label_historyCount.backgroundColor = [UIColor clearColor];
    _label_historyCount.lineBreakMode = NSLineBreakByTruncatingTail;
    _label_historyCount.userInteractionEnabled = NO;
    
    [_btn_history addSubview:_label_historyCount];
    
    int countPos = 0;
    for (int i=0; i<[(NSArray *)[_historyDic objectForKey:@"list"] count]; i++) {
        NSDictionary *dic = [[_historyDic objectForKey:@"list"] objectAtIndex:i];
        if (0 == i) {
            _imgView_headImg1.frame = CGRectMake(10, _imgView_historyBg.frame.origin.y + 5, 40, 40);
            [_imgView_headImg1 sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            countPos = _imgView_headImg1.frame.origin.x + 50;
        }else if (1 == i) {
            _imgView_headImg2.frame = CGRectMake(10 + 40*i + 10*i, _imgView_historyBg.frame.origin.y + 5, 40, 40);
            [_imgView_headImg2 sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            countPos = _imgView_headImg2.frame.origin.x + 50;
        }else if (2 == i) {
            _imgView_headImg3.frame = CGRectMake(10 + 40*i + 10*i, _imgView_historyBg.frame.origin.y + 5, 40, 40);
            [_imgView_headImg3 sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            countPos = _imgView_headImg3.frame.origin.x + 50;
        }else if (3 == i) {
            _imgView_headImg4.frame = CGRectMake(10 + 40*i + 10*i, _imgView_historyBg.frame.origin.y + 5, 40, 40);
            [_imgView_headImg4 sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            countPos = _imgView_headImg4.frame.origin.x + 50;
        }
    }
    
    _label_historyCount.frame = CGRectMake(countPos, _imgView_historyBg.frame.origin.y + (_imgView_historyBg.frame.size.height-30)/2, WIDTH-countPos-10, 30);
    _label_historyCount.text = [_historyDic objectForKey:@"count"];

        //                else if (4 == i) {
        //                    cell.imgView_headImg5.frame = CGRectMake(10 + 40*i + 10*i, cell.btn_history.frame.origin.y + 5, 40, 40);
        //                    [cell.imgView_headImg5 sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
        //                    countPos = cell.imgView_headImg5.frame.origin.x + 50;
        //                }
//    }

    
//    _btn_history = [UIButton buttonWithType:UIButtonTypeCustom];
//
//    //        [_btn_history setBackgroundColor:[UIColor redColor]];
//    //        [_btn_history setBackgroundImage:[UIImage imageNamed:@"tlq_history.png"] forState:UIControlStateNormal] ;
//    //        [_btn_history setBackgroundImage:[UIImage imageNamed:@"tlq_history.png"] forState:UIControlStateHighlighted] ;
//    [_btn_history addSubview:_btn_history];

}

- (void)showBottomButtonTeacher {
    if ([@"1"  isEqual: [_detailInfo objectForKey:@"answer"]] && [@"1"  isEqual: _spaceForClass]) {
        // 有答案的情况下才显示button
        // button上面的线
        _viewLine = [UIView new];
        _viewLine.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1];
        [self.view addSubview:_viewLine];
        
        [_viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(BOTTOM_BUTTON_HEIGHT+0.5);
            
            //            make.top.equalTo(self.view).with.offset([Utilities getScreenSizeWithoutBar].height-BOTTOM_BUTTON_HEIGHT-1);
            make.left.equalTo(self.view).with.offset(0);
            
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, 0.5));
        }];
        
        //    UIImageView *imgView_line =[UIImageView new];
        //    imgView_line.image=[UIImage imageNamed:@"lineSystem.png"];
        //    [self.view addSubview:imgView_line];
        //    [imgView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(self.view).with.offset(100);
        //        make.left.equalTo(self.view).with.offset(0);
        //
        //        make.size.mas_equalTo(CGSizeMake(200, 1));
        //    }];
        
        // 未完成
        _buttonNotDone = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_buttonNotDone];
        
        NSMutableAttributedString *notDone = [self createButtonMutableAttributeString:@"未完成"
                                                                               number:[_statistics objectForKey:@"state3"]
                                                                                color:[[UIColor alloc] initWithRed:236/255.0f green:80/255.0f blue:81/255.0f alpha:1.0]];
        [_buttonNotDone setAttributedTitle:notDone forState:UIControlStateNormal];
        
        [_buttonNotDone setBackgroundColor:[[UIColor alloc] initWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0]];
        [_buttonNotDone addTarget:self action:@selector(buttonClickEvent:) forControlEvents: UIControlEventTouchUpInside];
        
        [_buttonNotDone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(0);
            make.left.equalTo(self.view).with.offset(0);
            
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width/3, BOTTOM_BUTTON_HEIGHT));
        }];
        
        // 未批改
        _buttonNotComment = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_buttonNotComment];
        
        NSMutableAttributedString *notComment = [self createButtonMutableAttributeString:@"未批改"
                                                                                  number:[_statistics objectForKey:@"state0"]
                                                                                   color:[[UIColor alloc] initWithRed:255/255.0f green:138/255.0f blue:67/255.0f alpha:1.0]];
        [_buttonNotComment setAttributedTitle:notComment forState:UIControlStateNormal];
        
        [_buttonNotComment setBackgroundColor:[[UIColor alloc] initWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0]];
        [_buttonNotComment addTarget:self action:@selector(buttonClickEvent:) forControlEvents: UIControlEventTouchUpInside];
        
        [_buttonNotComment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(0);
            make.left.equalTo(_buttonNotDone.mas_right).with.offset(0);
            
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width/3, BOTTOM_BUTTON_HEIGHT));
        }];
        
        // 已完成
        _buttonDone = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_buttonDone];
        
        NSMutableAttributedString *done = [self createButtonMutableAttributeString:@"已完成"
                                                                            number:[_statistics objectForKey:@"state2"]
                                                                             color:[[UIColor alloc] initWithRed:76/255.0f green:175/255.0f blue:130/255.0f alpha:1.0]];
        [_buttonDone setAttributedTitle:done forState:UIControlStateNormal];
        
        [_buttonDone setBackgroundColor:[[UIColor alloc] initWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0]];
        [_buttonDone addTarget:self action:@selector(buttonClickEvent:) forControlEvents: UIControlEventTouchUpInside];
        
        [_buttonDone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(0);
            make.left.equalTo(_buttonNotComment.mas_right).with.offset(0);
            
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width/3, BOTTOM_BUTTON_HEIGHT));
        }];
        
        UIView *viewLine1 = [UIView new];
        viewLine1.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1];
        [self.view addSubview:viewLine1];
        
        [viewLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_buttonNotDone.mas_top).with.offset(0);
            make.left.equalTo(_buttonNotDone.mas_right).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(0.5, BOTTOM_BUTTON_HEIGHT));
        }];
        
        UIView *viewLine2 = [UIView new];
        viewLine2.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1];
        [self.view addSubview:viewLine2];
        
        [viewLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_buttonNotDone.mas_top).with.offset(0);
            make.left.equalTo(_buttonNotComment.mas_right).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(0.5, BOTTOM_BUTTON_HEIGHT));
        }];
    }
}

- (void)showBottomButtonStudent {
    if ([@"1"  isEqual: _spaceForClass]) {
        // 0:未改,3:未做,2:完成
        NSString *state = [NSString stringWithFormat:@"%@", [_detailInfo objectForKey:@"state"]];
        
        if (![@"2"  isEqual: state]) {
            // 非完成状态下才显示button上面的线
            _viewLine = [UIView new];
            _viewLine.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1];
            [self.view addSubview:_viewLine];
            
            [_viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).with.offset(BOTTOM_BUTTON_HEIGHT+0.5);
                
                //            make.top.equalTo(self.view).with.offset([Utilities getScreenSizeWithoutBar].height-BOTTOM_BUTTON_HEIGHT-1);
                make.left.equalTo(self.view).with.offset(0);
                
                make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, 0.5));
            }];
        }
        
        if ([@"3"  isEqual: state]) {
            // 未做状态下，显示“上传作业照片”button
            _buttonAnswerUpload = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.view addSubview:_buttonAnswerUpload];
            
            [_buttonAnswerUpload setTitle:@"上传作业照片" forState:UIControlStateNormal];
            [_buttonAnswerUpload setTitleColor:[[UIColor alloc] initWithRed:86/255.0f green:154/255.0f blue:248/255.0f alpha:1.0] forState:UIControlStateNormal];
            [_buttonAnswerUpload.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
            
            [_buttonAnswerUpload setBackgroundColor:[[UIColor alloc] initWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0]];
            [_buttonAnswerUpload addTarget:self action:@selector(buttonClickEvent:) forControlEvents: UIControlEventTouchUpInside];
            
            [_buttonAnswerUpload mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).with.offset(0);
                make.left.equalTo(self.view).with.offset(0);
                
                make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, BOTTOM_BUTTON_HEIGHT));
            }];
        }else if ([@"0"  isEqual: state]) {
            // 未批改状态下，显示“上传批改后作业”，“全部答对”两个button
            _buttonSecondAnswerUpload = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.view addSubview:_buttonSecondAnswerUpload];
            
            [_buttonSecondAnswerUpload setTitle:@"上传批改后的作业" forState:UIControlStateNormal];
            [_buttonSecondAnswerUpload setTitleColor:[[UIColor alloc] initWithRed:86/255.0f green:154/255.0f blue:248/255.0f alpha:1.0] forState:UIControlStateNormal];
            [_buttonSecondAnswerUpload.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
            
            [_buttonSecondAnswerUpload setBackgroundColor:[[UIColor alloc] initWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0]];
            [_buttonSecondAnswerUpload addTarget:self action:@selector(buttonClickEvent:) forControlEvents: UIControlEventTouchUpInside];
            
            [_buttonSecondAnswerUpload mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).with.offset(0);
                make.left.equalTo(self.view).with.offset(0);
                
                make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width/2, BOTTOM_BUTTON_HEIGHT));
            }];
            
            _buttonAllCorrect = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.view addSubview:_buttonAllCorrect];
            
            [_buttonAllCorrect setTitle:@"全部答对" forState:UIControlStateNormal];
            [_buttonAllCorrect setTitleColor:[[UIColor alloc] initWithRed:86/255.0f green:154/255.0f blue:248/255.0f alpha:1.0] forState:UIControlStateNormal];
            [_buttonAllCorrect.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
            
            [_buttonAllCorrect setBackgroundColor:[[UIColor alloc] initWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0]];
            [_buttonAllCorrect addTarget:self action:@selector(buttonClickEvent:) forControlEvents: UIControlEventTouchUpInside];
            
            [_buttonAllCorrect mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).with.offset(0);
                make.left.equalTo(_buttonSecondAnswerUpload.mas_right).with.offset(0);
                
                make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width/2, BOTTOM_BUTTON_HEIGHT));
            }];
            
            UIView *viewLine = [UIView new];
            viewLine.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1];
            [self.view addSubview:viewLine];
            
            [viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_buttonSecondAnswerUpload.mas_top).with.offset(0);
                make.left.equalTo(_buttonSecondAnswerUpload.mas_right).with.offset(0);
                make.size.mas_equalTo(CGSizeMake(0.5, BOTTOM_BUTTON_HEIGHT));
            }];
        }
    }
}

- (NSMutableAttributedString *)createButtonMutableAttributeString:(NSString *)text
                                                           number:(NSString *)number
                                                            color:(UIColor *)color {
    NSString *s = [NSString stringWithFormat:@"%@ %@人", text, number];
    NSInteger textLength = [text length];
    NSInteger numberLength = [number length];
    NSInteger sLength = [s length];

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:s];
    [str addAttribute:NSForegroundColorAttributeName value:[[UIColor alloc] initWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0] range:NSMakeRange(0,textLength)];
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(textLength+1,numberLength)];
    [str addAttribute:NSForegroundColorAttributeName value:[[UIColor alloc] initWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0] range:NSMakeRange(textLength + numberLength + 1,1)];

    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0, sLength)];
    
    return str;
}
        
#pragma mark -
#pragma mark UIButton callback
- (IBAction)buttonClickEvent:(id)sender {
    UIButton *button = (UIButton *)sender;
    if ([@"teacher"  isEqual: _viewType]) {
        NSString *viewType = @"";
        NSString *titleName = @"";
        
        if (button == _buttonNotDone) {
            [ReportObject event:ID_OPEN_HOMEWORK_TEACHER_NOT_DONE];

            viewType = @"notDone";
            titleName = @"未完成";
        }else if (button == _buttonNotComment) {
            [ReportObject event:ID_OPEN_HOMEWORK_TEACHER_NOT_COMMENT];

            viewType = @"notComment";
            titleName = @"未批改";
        }else if (button == _buttonDone) {
            [ReportObject event:ID_OPEN_HOMEWORK_TEACHER_DONE];

            viewType = @"done";
            titleName = @"已完成";
        }
        
        HomeworkStateListViewController *vc = [[HomeworkStateListViewController alloc] init];
        vc.viewType = viewType;
        vc.titleName = titleName;
        vc.cid = _cid;
        vc.tid = _tid;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([@"student"  isEqual: _viewType]) {
        if (button == _buttonAnswerUpload) {
            [ReportObject event:ID_OPEN_HOMEWORK_STUDENT_UPLOAD];

            // 上传作业照片
            HomeworkDetailUploadViewController *vc = [[HomeworkDetailUploadViewController alloc] init];
            vc.cid = _cid;
            vc.tid = _tid;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (button == _buttonSecondAnswerUpload) {
            [ReportObject event:ID_OPEN_HOMEWORK_STUDENT_COMMENT_UPLOAD];

            // 再次上传作业照片
            HomeworkDetailUploadViewController *vc = [[HomeworkDetailUploadViewController alloc] init];
            vc.cid = _cid;
            vc.tid = _tid;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (button == _buttonAllCorrect) {
            [ReportObject event:ID_OPEN_HOMEWORK_STUDENT_ALL_CORRENT];

            TSAlertView *alert = [[TSAlertView alloc] initWithTitle:@"提示" message:@"同学，你确定全部答对了么？"];
            
            [alert addBtnTitle:@"取消" action:^{
                // nothing to do
            }];
            [alert addBtnTitle:@"确定" action:^{
                /**
                 * 全部答对
                 * 判断作业状态
                 * @author luke
                 * @date 2016.01.28
                 * @args
                 *  v=3 ac=Homework op=shot sid=5303 cid= uid= tid=
                 */
                
                [Utilities showProcessingHud:self.view];
                
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      @"Homework",@"ac",
                                      @"3",@"v",
                                      @"shot", @"op",
                                      _cid, @"cid",
                                      _tid, @"tid",
                                      nil];
                
                [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
                    [Utilities dismissProcessingHud:self.view];
                    
                    NSDictionary *respDic = (NSDictionary*)responseObject;
                    NSString *result = [respDic objectForKey:@"result"];
                    
                    if(true == [result intValue]) {
                        // 刷新详情页面
                        [self performSelector:@selector(doReLoadHomeworkDetailView) withObject:nil afterDelay:0.1];
                        
                        // 通知作业列表页面刷新状态
                        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                             _homeworkListIndex,@"index",
                                             @"2",@"state",
                                             [NSString stringWithFormat:@"%ld", [[_detailInfo objectForKey:@"finished"] integerValue] + 1],@"finished",
                                             nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHomeList" object:dic];
                    } else {
                        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                                       message:[respDic objectForKey:@"message"]
                                                                      delegate:nil
                                                             cancelButtonTitle:@"确定"
                                                             otherButtonTitles:nil];
                        [alert show];
                    }
                    
                } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                    [Utilities doHandleTSNetworkingErr:error descView:self.view];
                }];
            }];
            
            [alert showAlertWithSender:self];
        }
    }
}

#pragma mark -
#pragma mark HomeworkDetailHead delegate
- (void)homeworkDetailHead:(HomeworkDetailHead *)v height:(NSInteger)h {
    // detailHead的代理方法，返回作业标题，姓名等基本信息。
    [_headInfo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, h));
    }];
}

#pragma mark -
#pragma mark HomeworkDetailInfo delegate
- (void)homeworkDetailInfo:(HomeworkDetailInfo *)v height:(NSInteger)h {
    // detailInfo的代理方法，返回每一个用到的作业答案的文字以及图片的总高度。
    [v mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, h));
    }];
}

-(void)homeworkDetailInfoSelectedImage:(HomeworkDetailInfo *)v index:(NSInteger)index {
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    // 弹出相册时显示的第一张图片是点击的图片
    browser.currentPhotoIndex = index;
    // 设置所有的图片。photos是一个包含所有图片的数组。
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:@"placeholderImage_large.png"];

    NSArray *picAry;
    if (v == _homeworkContent) {
        picAry = [_questions objectForKey:@"pics"];
    }else if (v == _homeworkAnswer) {
        picAry = [_answers objectForKey:@"pics"];
    }else if (v == _homeworkFirstAnswer) {
        picAry = [_firstAnswers objectForKey:@"pics"];
    }else if (v == _homeworkSecondAnswer) {
        picAry = [_secondAnswers objectForKey:@"pics"];
    }
    
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[picAry count]];
    
    for (int i = 0; i<[picAry count]; i++) {
        NSString *pic_url = [[picAry objectAtIndex:i] objectForKey:@"url"];
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.save = NO;
        photo.url = [NSURL URLWithString:pic_url]; // 图片路径
        photo.srcImageView = imageView; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    browser.photos = photos;
    [browser show];
}

- (IBAction)dismissMaskingView:(id)sender {
    _viewMasking.hidden = YES;
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
    
//    if (!faceBoard) {
    
        faceBoard = [[FaceBoard alloc] init];
        faceBoard.delegate = self;
        faceBoard.maxLength = 500;// 2015.07.21
        faceBoard.inputTextView = textView;
//    }
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

-(void)AudioClick:(id)sender{
    
    NSString *ac = @"";
    
    if ([@"teacher"  isEqual: _viewType]) {
        ac = @"HomeworkTeacher";
    }else if ([@"student"  isEqual: _viewType]) {
        ac = @"Homework";
    }
    
    if ([@""  isEqual: textView.text]) {
        
        [Utilities showFailedHud:@"请输入回复内容" descView:textView.inputView];//2015.05.12
    }else {
        if (isCommentComment) {
            
            [Utilities showProcessingHud:self.view];// 2015.05.12
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                  ac,@"ac",
                                  @"3",@"v",
                                  @"comment", @"op",
                                  textView.text, @"message",
                                  _cid,@"cid",
                                  _tid, @"tid",
                                  _deletePid, @"pid",
                                  nil];
            
            [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
                
                [Utilities dismissProcessingHud:self.view];
                
                NSDictionary *respDic = (NSDictionary*)responseObject;
                NSString *result = [respDic objectForKey:@"result"];
                
                if ([result integerValue] == 1) {
                    //To do: 评论数组里增加一条
                    NSDictionary *message = [respDic objectForKey:@"message"];
//                    [commentsArray addObject:message];
                    [commentsArray insertObject:message atIndex:0];

                    NSString *msg = [self transComment2TSAttLabel:message];
                    CGSize size = [self getCommentAttrHeight:msg];
                    int height = size.height;
//                    [commentHeightArr addObject:[NSString stringWithFormat:@"%d", height]];
                    [commentHeightArr insertObject:[NSString stringWithFormat:@"%d", height] atIndex:0];

                    if ([usertype integerValue] == 0 || [usertype integerValue] == 6) {
//                        _replyTo = @"您可在这里与班主任留言互动哦!";
                        
                    }else{
//                        _replyTo = @"您可在这里与学生/家长留言互动哦!";
                    }
                    
                    _replyToLabel.text = _replyTo;
                    [_replyToLabel setHidden:NO];
                    
//                    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                    float th = 0;
                    for (int i=0; i<[commentHeightArr count]; i++) {
                        th = [[commentHeightArr objectAtIndex:i] floatValue] + th;
                    }
                    
                    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, th));
                    }];
                    
                    
                    [_tableView reloadData];
                    
                }else{
                    
                    NSString *msg = [respDic objectForKey:@"message"];
                    [Utilities showFailedHud:msg descView:nil];
                }
                
                
            } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                
                //[Utilities dismissProcessingHud:self.view];
                [Utilities doHandleTSNetworkingErr:error descView:self.view];
            }];
            
            _replyTo = @"";
            //        _replyTo = [NSString stringWithFormat:@"回复%@: ", [dataDic objectForKey:@"name"]];
            
            _replyToLabel.text = _replyTo;
            [_replyToLabel setHidden:NO];
            
            self->textView.text = @"";
            isCommentComment = NO;
        }else {
            
            
            [Utilities showProcessingHud:self.view];// 2015.05.12
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                                  ac,@"ac",
                                  @"3",@"v",
                                  @"comment", @"op",
                                  textView.text, @"message",
                                  _cid,@"cid",
                                  _tid, @"tid",
                                  @"0", @"pid",
                                  nil];
            
            [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
                
                [Utilities dismissProcessingHud:self.view];
                
                NSDictionary *respDic = (NSDictionary*)responseObject;
                NSString *result = [respDic objectForKey:@"result"];
                
                if ([result integerValue] == 1) {
                    //To do: 评论数组里增加一条
                    NSDictionary *message = [respDic objectForKey:@"message"];
//                    [commentsArray addObject:message];
                    [commentsArray insertObject:message atIndex:0];

                    NSString *msg = [self transComment2TSAttLabel:message];
                    CGSize size = [self getCommentAttrHeight:msg];
                    int height = size.height;
//                    [commentHeightArr addObject:[NSString stringWithFormat:@"%d", height]];
                    [commentHeightArr insertObject:[NSString stringWithFormat:@"%d", height] atIndex:0];

                    
                    if ([usertype integerValue] == 0 || [usertype integerValue] == 6) {
//                        _replyTo = @"您可在这里与班主任留言互动哦!";
                        
                    }else{
//                        _replyTo = @"您可在这里与学生/家长留言互动哦!";
                    }
                    
                    _replyToLabel.text = _replyTo;
                    [_replyToLabel setHidden:NO];
                    
                    float th = 0;
                    for (int i=0; i<[commentHeightArr count]; i++) {
                        th = [[commentHeightArr objectAtIndex:i] floatValue] + th;
                    }
                    
                    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, th));
                    }];

                    
                    [_tableView reloadData];
                    
                }else{
                    
                    NSString *msg = [respDic objectForKey:@"message"];
                    [Utilities showFailedHud:msg descView:nil];
                }
                
                
            } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
                
                //[Utilities dismissProcessingHud:self.view];
                [Utilities doHandleTSNetworkingErr:error descView:self.view];
            }];
            
            _replyTo = @"";
            //        _replyTo = [NSString stringWithFormat:@"回复%@: ", [dataDic objectForKey:@"name"]];
            
            _replyToLabel.text = _replyTo;
            [_replyToLabel setHidden:NO];
            
            self->textView.text = @"";
            isCommentComment = NO;

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
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    
    NSDictionary *dic = [commentsArray objectAtIndex:indexPath.row];
    
    MomentsDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    
    if (cell == nil) {
        cell = [[MomentsDetailTableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    cell.flag = 1;
    cell.delegate = self;
    
    
    NSString *displayStr1 = [dic objectForKey:@"message"];
    
    NSArray *array = [displayStr1 componentsSeparatedByString:@"</div>"];

    NSString *commentName = [Utilities replaceNull:[dic objectForKey:@"username"]];
    NSString *commentToName = @"";
    NSString *citeStr = @"";
    NSString *nameStr2 = @"";
    if ([array count] == 1) {
//        commentName = displayStr1;
        nameStr2 = displayStr1;

    }else{
        
        citeStr = [array objectAtIndex:1];
        
        for(NSObject *temp in array)
        {
            NSString *str = (NSString *)temp;
            
            if ([@"</span>"  isEqual: str]) {
                continue;
            }
            
            NSRange foundB=[str rangeOfString:@"<b>" options:NSCaseInsensitiveSearch];
            NSRange foundOB=[str rangeOfString:@"</b>" options:NSCaseInsensitiveSearch];
            NSUInteger len = foundOB.location - foundB.location;
            
            if (0 != len) {
                commentToName = [str substringWithRange:NSMakeRange(foundB.location + 3, len-3)];
            }
            
            NSRange foundOBDiv=[str rangeOfString:@"</span>" options:NSCaseInsensitiveSearch];
            NSUInteger lenSpan = foundOBDiv.location - foundOB.location;
            
            if (0 != lenSpan) {
                nameStr2 = [str substringWithRange:NSMakeRange(foundOB.location + 6, lenSpan-6)];
//                str = [NSString stringWithFormat:@"%@\n%@",nameStr1, nameStr2];
//                citeStr = str;
                
                nameStr2 = citeStr;
                break;
            }
        }
    }
    

//    NSString *commentName = [Utilities replaceNull:[dic objectForKey:@"username"]];
//    NSString *commentToName = [dic objectForKey:@"toName"];
//
    NSString *cmt;
    if ([@""  isEqual: commentToName]) {
        // 单独回复
        cmt = [NSString stringWithFormat:@"%@：%@",commentName, nameStr2];
    }else {
        // 回复的回复
        cmt = [NSString stringWithFormat:@"%@回复%@：%@",commentName, commentToName, nameStr2];
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
//    cell.ohAttributeLabel.msgTid = _examId;//代表模块id
    
//    cell.ohAttributeLabel.hasName1 = 1;
//    cell.ohAttributeLabel.name1Start = 0;
//    cell.ohAttributeLabel.name1End = commentNameSize.width;
//    cell.ohAttributeLabel.name1Uid = [dic objectForKey:@"uid"];
//    
//    cell.ohAttributeLabel.hasName2 = 1;
//    cell.ohAttributeLabel.name2Start = wholeNameSize.width - commentToNameSize.width;
//    cell.ohAttributeLabel.name2End = wholeNameSize.width;
//    cell.ohAttributeLabel.name2Size = commentToNameSize.width;
//    cell.ohAttributeLabel.name2Uid = [dic objectForKey:@"toUid"];
//    
//    cell.ohAttributeLabel.nameY = 24.0;
    
    cell.ohAttributeLabel.msgComment = displayStr1;
    
    [cell disableLongTouchAction];
//    [cell disableTouchAction];

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
                          value:[[UIColor alloc] initWithRed:51/255.0f green:153.0/255.0f blue:255/255.0f alpha:1.0]
                          range:NSMakeRange(0,[commentName length])];
    
    if (![@""  isEqual: commentToName]) {
        [mutableAttStr addAttribute:NSForegroundColorAttributeName
                              value:[[UIColor alloc] initWithRed:51/255.0f green:153.0/255.0f blue:255/255.0f alpha:1.0]
                              range:NSMakeRange([commentName length]+2,[commentToName length])];
    }
    
    cell.ohAttributeLabel.attributedText = mutableAttStr;
    cell.ohAttributeLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.ohAttributeLabel.numberOfLines = 0;
    
    int ohAttributeLabelHeight = [[commentHeightArr objectAtIndex:indexPath.row] floatValue];
    cell.ohAttributeLabel.frame = CGRectMake(15.0,
                                             5,
                                             [[UIScreen mainScreen] bounds].size.width - 15.0,
                                             ohAttributeLabelHeight-10.0);
//
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
//    NSString *cmtMsg = [dic objectForKey:@"message"];
//    NSString *commentName = [Utilities replaceNull:[dic objectForKey:@"name"]];
//    NSString *commentToName = [dic objectForKey:@"toName"];
//    
//    NSString *cmt;
//    if ([@""  isEqual: commentToName]) {
//        // 单独回复
//        cmt = [NSString stringWithFormat:@"%@：%@",commentName, cmtMsg];
//    }else {
//        // 回复的回复
//        cmt = [NSString stringWithFormat:@"%@回复%@：%@",commentName, commentToName, cmtMsg];
//    }
//    
//    return cmt;
    
    
    NSString *displayStr1 = [dic objectForKey:@"message"];
    
    NSArray *array = [displayStr1 componentsSeparatedByString:@"</div>"];
    
    NSString *commentName = [Utilities replaceNull:[dic objectForKey:@"username"]];
    NSString *commentToName = @"";
    NSString *citeStr = @"";
    NSString *nameStr2 = @"";
    if ([array count] == 1) {
        //        commentName = displayStr1;
        nameStr2 = displayStr1;
        
    }else{
        
        citeStr = [array objectAtIndex:1];
        
        for(NSObject *temp in array)
        {
            NSString *str = (NSString *)temp;
            
            if ([@"</span>"  isEqual: str]) {
                continue;
            }
            
            NSRange foundB=[str rangeOfString:@"<b>" options:NSCaseInsensitiveSearch];
            NSRange foundOB=[str rangeOfString:@"</b>" options:NSCaseInsensitiveSearch];
            NSUInteger len = foundOB.location - foundB.location;
            
            if (0 != len) {
                commentToName = [str substringWithRange:NSMakeRange(foundB.location + 3, len-3)];
            }
            
            NSRange foundOBDiv=[str rangeOfString:@"</span>" options:NSCaseInsensitiveSearch];
            NSUInteger lenSpan = foundOBDiv.location - foundOB.location;
            
            if (0 != lenSpan) {
                nameStr2 = [str substringWithRange:NSMakeRange(foundOB.location + 6, lenSpan-6)];
                //                str = [NSString stringWithFormat:@"%@\n%@",nameStr1, nameStr2];
//                citeStr = str;
                
                nameStr2 = citeStr;
                break;
            }
        }
    }
    
    
    //    NSString *commentName = [Utilities replaceNull:[dic objectForKey:@"username"]];
    //    NSString *commentToName = [dic objectForKey:@"toName"];
    //
    NSString *cmt;
    if ([@""  isEqual: commentToName]) {
        // 单独回复
        cmt = [NSString stringWithFormat:@"%@：%@",commentName, nameStr2];
    }else {
        // 回复的回复
        cmt = [NSString stringWithFormat:@"%@回复%@：%@",commentName, commentToName, nameStr2];
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
        _replyTo = @"";
        //        _replyTo = [NSString stringWithFormat:@"回复%@: ", [dataDic objectForKey:@"name"]];
        
        _replyToLabel.text = _replyTo;
        [_replyToLabel setHidden:NO];
        
        self->textView.text = @"";
        isCommentComment = NO;
//        [textView resignFirstResponder];
//        
//        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
//                                                       message:@"删除这条评论？"
//                                                      delegate:self
//                                             cancelButtonTitle:@"取消"
//                                             otherButtonTitles:@"删除",nil];
//        alert.tag = 274;
//        [alert show];
    }else {
        // 如果是别人发的，评论别人的评论
        NSDictionary *cmt = [commentsArray objectAtIndex:_deletePidPos.integerValue];
        
        _replyTo = [NSString stringWithFormat:@"回复%@: ", [cmt objectForKey:@"username"]];
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
//                         _tableView.frame = frame;
                         
                         
                         frame = toolBar.frame;
                         frame.origin.y += keyboardHeight;
                         frame.origin.y -= keyboardRect.size.height;
                         toolBar.frame = frame;
                         
                         keyboardHeight = keyboardRect.size.height;
                         
//                         float a = _viewWhiteBg.frame.size.height;
//                         
//                         [_viewWhiteBg mas_updateConstraints:^(MASConstraintMaker *make) {
//                             make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, _viewWhiteBg.frame.size.height - keyboardHeight));
//                         }];

                     }];
    
    CGRect rect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat keyboardHeight = CGRectGetHeight(rect);
    CGFloat keyboardDuration =
    [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 修改下边距约束
    [_scrollViewBg mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(-keyboardHeight);
//        make.bottom.equalTo(_tableView.mas_bottom).width.offset(-keyboardHeight);
//        make.bottom.equalTo(_tableView.mas_bottom);


    }];
    
    // 更新约束
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self.view layoutIfNeeded]; }];

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
    isKeyboardShowing = NO;
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGRect frame = _tableView.frame;
                         frame.size.height += keyboardHeight;
                         //                         _tableView.frame = frame;
                         
                         frame = toolBar.frame;
                         frame.origin.y += keyboardHeight;
                         toolBar.frame = frame;
                         
                         keyboardHeight = 0;
                     }];
    
    CGRect rect = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    CGFloat keyboardHeight = CGRectGetHeight(rect);
    CGFloat keyboardDuration =
    [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 修改下边距约束
    [_scrollViewBg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_tableView.mas_bottom);
    }];
    
    // 更新约束
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self.view layoutIfNeeded]; }];
    
}

- (void)keyboardDidHide:(NSNotification *)notification {
    
//    isCommentComment = NO;
//    
//    textView.text = @"";
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
    
    _replyTo = @"";
    //        _replyTo = [NSString stringWithFormat:@"回复%@: ", [dataDic objectForKey:@"name"]];
    
    _replyToLabel.text = _replyTo;
    [_replyToLabel setHidden:NO];
    
    self->textView.text = @"";
    isCommentComment = NO;

    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setMenuVisible:NO animated:YES];
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if(([touch.view isMemberOfClass:[TSAttributedLabel class]]) ||
       ([touch.view isMemberOfClass:[UIButton class]]) ||
       ([touch.view isMemberOfClass:[UITableViewCell class]])) {
        //放过以上事件的点击拦截
        
        return NO;
    }else{
        
        isCommentComment = NO;
        _replyTo = @"";

        UIView* v=[touch.view superview];
        
        // 特殊放过tableViewCell的点击事件
        //        if([v isMemberOfClass:[Test1TableViewCell class]]) {
        //            return NO;
        //        }
        
        return YES;
    }
}

// 2015.12.16
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    // 滑动屏幕使键盘下落
    [textView resignFirstResponder];
    
    _replyTo = @"";
    //        _replyTo = [NSString stringWithFormat:@"回复%@: ", [dataDic objectForKey:@"name"]];
    
    _replyToLabel.text = _replyTo;
    [_replyToLabel setHidden:NO];
    
    self->textView.text = @"";
    isCommentComment = NO;

//    NSLog(@"scrollViewDidEndDragging");
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 274){
        
        if (buttonIndex == 1){
            
//            [self deleteComment];
        }
    }
    
}

#if 0
-(void)deleteComment{
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:REQ_URL, @"url",
                          @"GrowingSpace",@"ac",
                          @"2",@"v",
                          @"commentDelete", @"op",
                          _cId,@"cid",
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
#endif


@end
