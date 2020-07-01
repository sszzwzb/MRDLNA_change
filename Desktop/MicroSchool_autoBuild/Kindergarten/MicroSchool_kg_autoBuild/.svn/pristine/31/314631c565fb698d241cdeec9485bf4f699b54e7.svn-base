//
//  HomeworkStateDetailViewController.m
//  MicroSchool
//
//  Created by CheungStephen on 2/3/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "HomeworkStateDetailViewController.h"

@interface HomeworkStateDetailViewController ()

@end

@implementation HomeworkStateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _detailInfo = [[NSMutableDictionary alloc] init];
    _firstAnswers = [[NSMutableDictionary alloc] init];
    _secondAnswers = [[NSMutableDictionary alloc] init];

    [self setCustomizeLeftButton];
    [super setCustomizeTitle:_titleName];
    
    [self doGetStateFinished];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doGetStateFinished {
    /**
     * 查看某学生完成的作业详情
     * @author luke
     * @date 2016.01.28
     * @args
     *  v=3 ac=HomeworkTeacher op=viewFinished sid=5303 cid=6735 uid=6939 tid=
     */
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"HomeworkTeacher",@"ac",
                          @"3",@"v",
                          @"viewFinished", @"op",
                          _cid, @"cid",
                          _tid, @"tid",
                          _number, @"number",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            NSDictionary *msg = [respDic objectForKey:@"message"];
            
            NSDictionary *homework = [msg objectForKey:@"homework"];
            if ((nil != homework) && (![homework isKindOfClass:[NSNull class]])) {
                _detailInfo = [NSMutableDictionary dictionaryWithDictionary:homework];
            }else {
                _detailInfo = nil;
            }

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

            [self showHomeworkAnswers];
        } else {
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

#define LEFT_OFFSET 12                  // 控件到左边距的距离

- (void)showHomeworkAnswers {
    _scrollViewBg = [UIScrollView new];
    _scrollViewBg.scrollEnabled = YES;
    _scrollViewBg.delegate = self;
    [self.view addSubview:_scrollViewBg];
    
    [_scrollViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, [Utilities getScreenSizeWithoutBar].height));
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

    if ([@"2"  isEqual: [NSString stringWithFormat:@"%@", [_detailInfo objectForKey:@"state"]]]) {
        // 已完成作业，分为两种，
        // 一种是上传了两次作业照片的，一种是上传了一次作业照片，然后全对的。
        if ((nil != _secondAnswers) && (0 != [(NSArray *)[_secondAnswers objectForKey:@"pics"] count])) {
            // 上传了两次照片的
            _homeworkFirstAnswer = [HomeworkDetailInfo new];
            _homeworkFirstAnswer.delegate = self;
            [_scrollViewBg addSubview:_homeworkFirstAnswer];
            
            [_firstAnswers setObject:@"作业照片" forKey:@"content"];
            [_homeworkFirstAnswer initElementsWithDic:_firstAnswers showTitle:nil];
            
            [_homeworkFirstAnswer mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_scrollViewBg).with.offset(15);
                make.left.equalTo(_scrollViewBg).with.offset(0);
                make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, 0));
            }];

            _homeworkSecondAnswer = [HomeworkDetailInfo new];
            _homeworkSecondAnswer.delegate = self;
            [_scrollViewBg addSubview:_homeworkSecondAnswer];
            
            [_secondAnswers setObject:@"批改后作业照片" forKey:@"content"];
            [_homeworkSecondAnswer initElementsWithDic:_secondAnswers showTitle:nil];
            
            [_homeworkSecondAnswer mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_homeworkFirstAnswer.mas_bottom).with.offset(15);
                make.left.equalTo(_scrollViewBg).with.offset(0);
                make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, 0));
            }];

            [_viewWhiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_homeworkSecondAnswer.mas_bottom);
            }];

        }else {
            // 只上传了一次照片，全对
            _homeworkFirstAnswer = [HomeworkDetailInfo new];
            _homeworkFirstAnswer.delegate = self;
            [_scrollViewBg addSubview:_homeworkFirstAnswer];
            
            [_firstAnswers setObject:@"作业照片" forKey:@"content"];
            [_homeworkFirstAnswer initElementsWithDic:_firstAnswers showTitle:nil];
            
            [_homeworkFirstAnswer mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_scrollViewBg).with.offset(15);
                make.left.equalTo(_scrollViewBg).with.offset(0);
                make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, 0));
            }];
            
            _labelComment = [UILabel new];
            _labelComment.font = [UIFont systemFontOfSize:14.0f];
            _labelComment.textColor = [[UIColor alloc] initWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
            _labelComment.numberOfLines = 0;
            _labelComment.lineBreakMode = NSLineBreakByWordWrapping;
            _labelComment.attributedText = [self createButtonMutableAttributeString:@"批改结果："
                                                                             number:@"作业全部答对。"
                                                                              color:[[UIColor alloc] initWithRed:236/255.0f green:80/255.0f blue:81/255.0f alpha:1.0]];
            
            CGSize subjectSize = [Utilities getLabelHeight:_labelComment size:CGSizeMake([Utilities getScreenSize].width-LEFT_OFFSET*2, MAXFLOAT)];
            [self.view addSubview:_labelComment];
            
            [_labelComment mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_homeworkFirstAnswer.mas_bottom).with.offset(15);
                make.left.equalTo(_homeworkFirstAnswer).with.offset(LEFT_OFFSET);
                make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width-LEFT_OFFSET*2, subjectSize.height));
            }];
            
            [_viewWhiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_labelComment.mas_bottom);
            }];
        }
    }else if ([@"0"  isEqual: [NSString stringWithFormat:@"%@", [_detailInfo objectForKey:@"state"]]]) {
        // 未批改作业
        _homeworkFirstAnswer = [HomeworkDetailInfo new];
        _homeworkFirstAnswer.delegate = self;
        [_scrollViewBg addSubview:_homeworkFirstAnswer];
        
        [_firstAnswers setObject:@"作业照片" forKey:@"content"];
        [_homeworkFirstAnswer initElementsWithDic:_firstAnswers showTitle:nil];
        
        [_homeworkFirstAnswer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_scrollViewBg).with.offset(15);
            make.left.equalTo(_scrollViewBg).with.offset(0);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, 0));
        }];
        
        [_viewWhiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_homeworkFirstAnswer.mas_bottom);
        }];
    }
}

- (NSMutableAttributedString *)createButtonMutableAttributeString:(NSString *)text
                                                           number:(NSString *)number
                                                            color:(UIColor *)color {
    NSString *s = [NSString stringWithFormat:@"%@%@", text, number];
    NSInteger textLength = [text length];
    NSInteger numberLength = [number length];
    NSInteger sLength = [s length];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:s];
    [str addAttribute:NSForegroundColorAttributeName value:[[UIColor alloc] initWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0] range:NSMakeRange(0,textLength)];
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(textLength,numberLength)];
    
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0, sLength)];
    
    return str;
}

#pragma mark -
#pragma mark HomeworkDetailInfo delegate
- (void)homeworkDetailInfo:(HomeworkDetailInfo *)v height:(NSInteger)h
{
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
    if (v == _homeworkFirstAnswer) {
        [ReportObject event:ID_OPEN_HOMEWORK_TEACHER_VIEW_PIC];

        picAry = [_firstAnswers objectForKey:@"pics"];
    }else if (v == _homeworkSecondAnswer) {
        [ReportObject event:ID_OPEN_HOMEWORK_TEACHER_COMMENT_PIC];

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

@end
