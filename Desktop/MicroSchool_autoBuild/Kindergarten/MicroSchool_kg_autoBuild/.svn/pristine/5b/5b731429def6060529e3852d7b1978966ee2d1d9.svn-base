//
//  SubmitHWViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 16/2/1.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "SubmitHWViewController.h"
#import "Toast+UIView.h"
//#import "FullImageViewController.h"
#import "HomeworkDetailViewController.h"

@interface SubmitHWViewController ()

@end

@implementation SubmitHWViewController
@synthesize text_answer,text_content,text_title,text_time;
@synthesize imageArray,imageArray_answer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setCustomizeLeftButton];
    if (_flag == 1) {
        [self setCustomizeTitle:@"修改作业"];
        [super setCustomizeRightButtonWithName:@"完成"];
        
    }else{
       [self setCustomizeTitle:@"编辑作业"];
       [super setCustomizeRightButtonWithName:@"发布"];
        

    }
    
    network = [NetworkUtility alloc];
    network.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self doShowContent];
    
    [self isNeedShowMasking];

    imageArray = [[NSMutableDictionary alloc] init];//本地存储作业内容图片字典
    imageArray_answer = [[NSMutableDictionary alloc] init];//本地存储作业答案图片字典
    _qngs = @"";
    _angs = @"";
    
}

-(void)drawAddImagesTool:(NSDictionary*)dic{
    
    AddImagesTool *tool = [dic objectForKey:@"tool"];
    NSMutableArray *array = [dic objectForKey:@"array"];
    
    [tool drawAddImagesTool:array withViewController:self];
    
}

-(void)doShowContent{
    
    
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    
    //    CGRect rect;
    //    // 设置背景scrollView
    //    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    //    {
    //        rect = CGRectMake(0, 0, 320 , [UIScreen mainScreen].applicationFrame.size.height - 44);
    //    }
    //    else
    //    {
    //        rect = CGRectMake(0, 0, 320 , [UIScreen mainScreen].applicationFrame.size.height - 44);
    //    }
    //_scrollerView = [[UIScrollView alloc] initWithFrame:rect];
    _scrollerView = [UIScrollView new];
    _scrollerView.scrollEnabled = YES;
    _scrollerView.delegate = self;
    [self.view addSubview:_scrollerView];
    
    [_scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 距离屏幕上边距为0
        make.top.equalTo(self.view.mas_top).with.offset(0);
        
        // 距离屏幕左边距为20
        make.left.equalTo(self.view.mas_left).with.offset(0);
        
        make.bottom.equalTo(self.view).with.offset(0);

        // _labelHeight的大小
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width, [Utilities getScreenSize].height - 64));
    }];
 
    _viewWhiteBg = [UIView new];
    _viewWhiteBg.backgroundColor = [UIColor clearColor];
    [_scrollerView addSubview:_viewWhiteBg];
    
    // 这里设置了背景白色view的edges与scrollView的一致，这样就不需要再次计算这个白色view的size了
    // 这样做可以避免同时两个view依赖于scrollView的contentSize来计算自己的size。
    // 如果有两个view同时依赖于scrollView算高度的话，就会出现其中一个view无法计算正确地高度，并且会有很多警告。
    [_viewWhiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(_scrollViewBg);
        make.edges.equalTo(_scrollerView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        
        make.width.equalTo(_scrollerView);
    }];

    // 标题
    //text_title = [[UITextField alloc]initWithFrame:CGRectMake(12, 20, 310, 30)];
    text_title = [UITextField new];
    text_title.borderStyle = UITextBorderStyleNone;
    text_title.backgroundColor = [UIColor clearColor];
    
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"homeworkTitle"];
    if (1 == _flag) {//修改作业
        if ([_dic objectForKey:@"title"]) {
            text_title.text = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[_dic objectForKey:@"title"]]];
            text_title.placeholder = @"标题";
            
        }else{
            text_title.placeholder = @"标题";
        }
        
    }else {//发布作业
        
        if (nil == value) {
            text_title.placeholder = @"标题";
        }else {
            text_title.text = value;
           
        }
    }
    
    UIColor *color =[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    text_title.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"标题" attributes:@{NSForegroundColorAttributeName: color}];//设置placeholder颜色
    text_title.font = [UIFont systemFontOfSize:15.0];
    text_title.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    text_title.clearButtonMode = UITextFieldViewModeAlways;
    text_title.textAlignment = NSTextAlignmentLeft;
    text_title.keyboardType=UIKeyboardTypeDefault;
    text_title.returnKeyType =UIReturnKeyDone;
    text_title.delegate = self;
//    [text_title becomeFirstResponder];
    [_scrollerView addSubview:text_title];
    
    [text_title mas_makeConstraints:^(MASConstraintMaker *make) {
        // 距离屏幕上边距为80
        make.top.equalTo(_viewWhiteBg.mas_top).with.offset(5);
        // 距离屏幕左边距为20
        make.left.equalTo(_viewWhiteBg.mas_left).with.offset(12);
        
        // _labelHeight的大小
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width-24.0, 30));
    }];
#if 9

    // 线
    //    UIImageView *imgView_line =[[UIImageView alloc]initWithFrame:CGRectMake(text_title.frame.origin.x,
    //                                                                            text_title.frame.origin.y + text_title.frame.size.height + 10,
    //                                                                            [UIScreen mainScreen].bounds.size.width-(text_title.frame.origin.x*2),
    //                                                                            1)];
    UIImageView *imgView_line = [UIImageView new];
    imgView_line.image=[UIImage imageNamed:@"lineSystem.png"];
    [_scrollerView addSubview:imgView_line];
    
    [imgView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        // 距离屏幕上边距为80
        make.top.equalTo(text_title.mas_bottom).with.offset(5);
        // 距离屏幕左边距为20
        make.left.equalTo(text_title).with.offset(0);
        
        // _labelHeight的大小
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width-24.0, 1));
    }];
    
    // 预计时间文字
    //    label_username = [[UILabel alloc] initWithFrame:CGRectMake(
    //                                                               text_title.frame.origin.x,
    //                                                               imgView_line.frame.origin.y + imgView_line.frame.size.height + 10,
    //                                                               130,
    //                                                               15)];
    label_username = [UILabel new];
    label_username.text = @"预计完成时间:";
    label_username.lineBreakMode = NSLineBreakByWordWrapping;
    label_username.font = [UIFont systemFontOfSize:12.0f];
    label_username.numberOfLines = 0;
    label_username.textColor = [UIColor grayColor];
    label_username.backgroundColor = [UIColor clearColor];
    label_username.lineBreakMode = NSLineBreakByTruncatingTail;
    [_scrollerView addSubview:label_username];
    
    [label_username mas_makeConstraints:^(MASConstraintMaker *make) {
        // 距离屏幕上边距为80
        make.top.equalTo(imgView_line.mas_bottom).with.offset(5);
        // 距离屏幕左边距为20
        make.left.equalTo(imgView_line).with.offset(0);
        
        // _labelHeight的大小
        make.size.mas_equalTo(CGSizeMake(80.0, 30.0));
    }];
    
    //label_timeTitle
    //    label_timeTitle = [[UILabel alloc] initWithFrame:CGRectMake(
    //                                                               [UIScreen mainScreen].bounds.size.width-40.0,
    //                                                               imgView_line.frame.origin.y + imgView_line.frame.size.height + 10,
    //                                                               40.0,
    //                                                               15.0)];
    label_timeTitle = [UILabel new];
    label_timeTitle.text = @"分钟";
    label_timeTitle.lineBreakMode = NSLineBreakByWordWrapping;
    label_timeTitle.font = [UIFont systemFontOfSize:12.0f];
    label_timeTitle.numberOfLines = 0;
    label_timeTitle.textColor = [UIColor grayColor];
    label_timeTitle.backgroundColor = [UIColor clearColor];
    label_timeTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    [_scrollerView addSubview:label_timeTitle];
    
    [label_timeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        // 距离屏幕上边距为80
        make.top.equalTo(imgView_line.mas_bottom).with.offset(5);
        // 距离屏幕左边距为20
        make.right.equalTo(imgView_line.mas_right).with.offset(0.0);
        // _labelHeight的大小
        make.size.mas_equalTo(CGSizeMake(25.0, 30.0));
    }];
    
    
    
    // 预计时间
    //    text_time = [[UITextField alloc]initWithFrame:CGRectMake(label_timeTitle.frame.origin.x - label_timeTitle.frame.size.width-150.0,
    //                                                             imgView_line.frame.origin.y + imgView_line.frame.size.height + 10,
    //                                                             190.0, 15)];
    text_time = [UITextField new];
    text_time.borderStyle = UITextBorderStyleNone;
    text_time.backgroundColor = [UIColor clearColor];
    text_time.placeholder = @"";
    text_time.font = [UIFont systemFontOfSize:12.0];
    text_time.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    //text_time.clearButtonMode = UITextFieldViewModeAlways;
    text_time.textAlignment = NSTextAlignmentRight;
    text_time.keyboardType=UIKeyboardTypeNumberPad;
    text_time.returnKeyType =UIReturnKeyDone;
    text_time.delegate = self;
    
    if ([_dic objectForKey:@"time"]!=nil){
        
        text_time.text = [_dic objectForKey:@"time"];
    }
    
    [_scrollerView addSubview:text_time];
    
    [text_time mas_makeConstraints:^(MASConstraintMaker *make) {
        // 距离屏幕上边距为80
        make.top.equalTo(label_username).with.offset(0);
        // 距离屏幕左边距为20
        make.left.equalTo(label_username.mas_right).with.offset(0);
        // _labelHeight的大小
        make.size.mas_equalTo(CGSizeMake(190.0, 30.0));
    }];
    
    
    // 线
    //    UIImageView *imgView_line2 =[[UIImageView alloc]initWithFrame:CGRectMake(text_title.frame.origin.x,
    //                                                                             label_username.frame.origin.y + label_username.frame.size.height + 10,
    //                                                                             [UIScreen mainScreen].bounds.size.width-(text_title.frame.origin.x*2),
    //                                                                             1)];
    UIImageView *imgView_line2 = [UIImageView new];
    imgView_line2.image=[UIImage imageNamed:@"lineSystem.png"];
    [_scrollerView addSubview:imgView_line2];
    
    [imgView_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        // 距离屏幕上边距为80
        make.top.equalTo(label_username.mas_bottom).with.offset(5);
        // 距离屏幕左边距为20
        make.left.equalTo(label_username).with.offset(0);
        
        // _labelHeight的大小
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width-24.0, 1));
    }];
    
    // 作业内容view
    contentView = [UIView new];
    [_scrollerView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        // y与_textFieldHeight的y相同
        make.top.equalTo(imgView_line2.mas_bottom).with.offset(0);
        
        // x距离_labelHeight右边最长处5
        make.left.equalTo(imgView_line2).with.offset(-12.0);
        
        //        // _textFieldHeight的大小
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 122.0));
    }];
    
    
    // 初始化
    //    if (IS_IPHONE_5) {
    //        // 作业改版，预计完成时间不要了 2015.11.24
    //        // 作业又改版，预计时间又回来了 2015.12.28
    //        text_content = [[UITextView alloc] initWithFrame:CGRectMake(text_title.frame.origin.x-6,
    //                                                                    5, [UIScreen mainScreen].bounds.size.width-(text_title.frame.origin.x-6)*2, 30.0)];
    //    }else{
    //
    //        text_content = [[UITextView alloc] initWithFrame:CGRectMake(text_title.frame.origin.x-6,
    //                                                                    5, [UIScreen mainScreen].bounds.size.width-(text_title.frame.origin.x-6)*2, 30.0)];
    //    }
    //
    text_content = [UITextView new];
    NSLog(@"y:%f",text_content.frame.origin.y);
    
    NSString *content = [NSString stringWithFormat:@"%@",[_dic objectForKey:@"content"]];
    content = [Utilities replaceNull:content];
    text_content.font = [UIFont systemFontOfSize:14.0];
    float contentHeight = 30;
    if ([content length] > 0) {
        // To do:更新text_content的frame
        text_content.text = [_dic objectForKey:@"content"];
        text_content.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
//        CGSize textContentSize = [Utilities getStringHeight:text_content.text andFont:[UIFont systemFontOfSize:14.0] andSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-12.0, 0)];
        CGSize textContentSize = [text_content sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width-12.0, 0)];
        contentHeight = textContentSize.height;
        if (contentHeight< 30) {
            contentHeight = 30;
        }
        
    }else{
        text_content.text = @"输入作业内容";
        text_content.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    }
    
    //NSLog(@"textContent:%@",text_content.text);
    
    //text_content.contentSize = CGRectMake(10, 0, 300, 130).size ;
    text_content.backgroundColor = [UIColor clearColor];
    //text_content.text = @"输入作业内容";
    
    text_content.delegate = self;
    //是否可以滚动
    text_content.scrollEnabled = NO;
    //text_content.backgroundColor = [UIColor redColor];
    //[text_content sizeToFit];
    [contentView addSubview:text_content];
    
    [text_content mas_makeConstraints:^(MASConstraintMaker *make) {
        // y与_textFieldHeight的y相同
        make.top.equalTo(contentView).with.offset(5.0);
        
        // x距离_labelHeight右边最长处5
        make.left.equalTo(contentView).with.offset(6.0);
        
        //make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width-12.0, 30));
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width-12.0, contentHeight));
        
    }];
    
    //CGRect rectHomework = CGRectMake(text_title.frame.origin.x, text_content.frame.size.height+text_content.frame.origin.y+5.0,  [UIScreen mainScreen].bounds.size.width-(text_title.frame.origin.x*2), 70.0);
    //imageToolForHomework = [[AddImagesTool alloc] initWithFrame:rectHomework imgArray:(NSMutableArray*)[_dic objectForKey:@"imageArray_content"] withViewController:self];
    imageToolForHomework = [AddImagesTool new];
    
    if ([(NSMutableArray*)[_dic objectForKey:@"imageArray_content"] count] > 0) {
        
        //To do:更新imageToolForHomework的frame
        NSLog(@"1");
        
    }
    [contentView addSubview:imageToolForHomework];
    
    [imageToolForHomework mas_makeConstraints:^(MASConstraintMaker *make) {
        // y与_textFieldHeight的y相同
        make.top.equalTo(text_content.mas_bottom).with.offset(5.0);
        
        // x距离_labelHeight右边最长处5
        make.left.equalTo(text_content).with.offset(7.0);
        
        //        // _textFieldHeight的大小
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width-(text_title.frame.origin.x*2), 70.0));
        
    }];
    
    NSDictionary *dic_homework = [[NSDictionary alloc] initWithObjectsAndKeys:imageToolForHomework,@"tool",(NSMutableArray*)[_dic objectForKey:@"imageArray_content"],@"array",nil];
    [self performSelector:@selector(drawAddImagesTool:) withObject:dic_homework afterDelay:0.5];
    
    [self performSelector:@selector(updateCForContentView) withObject:nil afterDelay:0.2];
    
    //获得焦点
    //[text_content becomeFirstResponder];
    //    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, imgView_line2.frame.origin.y + imgView_line2.frame.size.height, [UIScreen mainScreen].bounds.size.width,imageToolForHomework.frame.origin.y+imageToolForHomework.frame.size.height+13.0)];
    
    // 线
    //    UIImageView *imgView_line3 =[[UIImageView alloc]initWithFrame:CGRectMake(text_title.frame.origin.x,
    //                                                                             contentView.frame.size.height-1,
    //                                                                             [UIScreen mainScreen].bounds.size.width-(text_title.frame.origin.x*2),
    //                                                                             1)];
    imgView_line3 = [UIImageView new];
    imgView_line3.image=[UIImage imageNamed:@"lineSystem.png"];
    [contentView addSubview:imgView_line3];
    
    [imgView_line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        // y与_textFieldHeight的y相同
        make.top.equalTo(imageToolForHomework.mas_bottom).with.offset(12.0);
        
        // x距离_labelHeight右边最长处5
        make.left.equalTo(imageToolForHomework).with.offset(0);
        
        //        // _textFieldHeight的大小
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width-24.0, 1.0));
        
    }];
    
#if 1
    //作业答案view
    answerView = [UIView new];
    //answerView.backgroundColor = [UIColor yellowColor];
    [_scrollerView addSubview:answerView];
    
    [answerView mas_makeConstraints:^(MASConstraintMaker *make) {
        // y与_textFieldHeight的y相同
        make.top.equalTo(contentView.mas_bottom).with.offset(0);
        
        // x距离_labelHeight右边最长处5
        make.left.equalTo(contentView).with.offset(0);
        
        //        // _textFieldHeight的大小
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 122.0));
        

    }];
    
#if 1
    [_scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(answerView.mas_bottom).with.offset(20);
    }];
#endif
    
    //    if (IS_IPHONE_5) {
    //        // 作业改版，预计完成时间不要了 2015.11.24
    //        // 作业又改版，预计时间又回来了 2015.12.28
    //        text_answer = [[UITextView alloc] initWithFrame:CGRectMake(text_title.frame.origin.x-6.0,
    //                                                                    5.0,  [UIScreen mainScreen].bounds.size.width-(text_title.frame.origin.x-6)*2, 30.0)];
    //    }else{
    //
    //        text_answer = [[UITextView alloc] initWithFrame:CGRectMake(text_title.frame.origin.x-6.0,
    //                                                                    5.0, [UIScreen mainScreen].bounds.size.width-(text_title.frame.origin.x-6)*2, 30.0)];
    //    }
    
    text_answer = [UITextView new];
    NSString *answer = [NSString stringWithFormat:@"%@",[_dic objectForKey:@"answer"]];
    answer = [Utilities replaceNull:answer];
    text_answer.font = [UIFont systemFontOfSize:14.0];
    
    float answerHeight = 30;
    
    if ([answer length] > 0) {
        // To do:更新text_content的frame
        text_answer.text = [_dic objectForKey:@"answer"];
        text_answer.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        //CGSize textAnswerSize = [Utilities getStringHeight:text_answer.text andFont:[UIFont systemFontOfSize:14.0] andSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-12.0, 0)];
        CGSize textAnswerSize = [text_answer sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width-12.0, 0)];
        answerHeight = textAnswerSize.height;
        if (answerHeight< 30) {
            answerHeight = 30;
        }
        
    }else{
        text_answer.text = @"输入答案内容";
        text_answer.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    }
    
    text_answer.backgroundColor = [UIColor clearColor];
    //text_answer.text = @"输入答案内容";
   
    text_answer.delegate = self;
   
    //是否可以滚动
    text_answer.scrollEnabled = NO;
    //[text_content sizeToFit];
    [answerView addSubview:text_answer];
    
    [text_answer mas_makeConstraints:^(MASConstraintMaker *make) {
        // y与_textFieldHeight的y相同
        make.top.equalTo(answerView).with.offset(5.0);
        
        // x距离_labelHeight右边最长处5
        make.left.equalTo(answerView).with.offset(6.0);
        
        //make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width-12.0, 30));
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width-12.0, answerHeight));
        
    }];
    
    //    CGRect rectAnswer = CGRectMake(text_title.frame.origin.x, text_answer.frame.size.height+text_answer.frame.origin.y+5.0,  [UIScreen mainScreen].bounds.size.width-(text_title.frame.origin.x*2), 70.0);
    //    imageToolForAnswer = [[AddImagesTool alloc] initWithFrame:rectAnswer imgArray:(NSMutableArray*)[_dic objectForKey:@"imageArray_answer"] withViewController:self];
    imageToolForAnswer = [AddImagesTool new];
    
    if ([(NSMutableArray*)[_dic objectForKey:@"imageArray_answer"] count] > 0) {
        
        //To do:更新imageToolForAnswer的frame
        
    }
    [answerView addSubview:imageToolForAnswer];
    
    //    answerView = [[UIView alloc] initWithFrame:CGRectMake(0, contentView.frame.origin.y + contentView.frame.size.height, [UIScreen mainScreen].bounds.size.width,imageToolForAnswer.frame.origin.y+imageToolForAnswer.frame.size.height+13.0)];
    
    [imageToolForAnswer mas_makeConstraints:^(MASConstraintMaker *make) {
        // y与_textFieldHeight的y相同
        make.top.equalTo(text_answer.mas_bottom).with.offset(5.0);
        
        // x距离_labelHeight右边最长处5
        make.left.equalTo(text_answer).with.offset(7.0);
        
        //        // _textFieldHeight的大小
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width-(text_title.frame.origin.x*2), 70.0));
        
    }];
    
    NSDictionary *dic_answer = [[NSDictionary alloc] initWithObjectsAndKeys:imageToolForAnswer,@"tool",(NSMutableArray*)[_dic objectForKey:@"imageArray_answer"],@"array",nil];
    [self performSelector:@selector(drawAddImagesTool:) withObject:dic_answer afterDelay:0.5];
#endif
    //_scrollerView.contentSize = CGSizeMake(320, [UIScreen mainScreen].applicationFrame.size.height - 44);
    [self performSelector:@selector(updateCForAnswerView) withObject:nil afterDelay:0.2];
    
#endif
    
}

-(void)updateCForContentView{
    
    if (_flag == 1) {
        
        [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width,imageToolForHomework.frame.origin.y+imageToolForHomework.frame.size.height+13.0));
        }];
    }
    
    
}

-(void)updateCForAnswerView{
    
    if (_flag == 1) {
        
        [answerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width,imageToolForAnswer.frame.origin.y+imageToolForAnswer.frame.size.height+13.0));
        }];
        
    }
    
}

-(void)updateSize:(UIView*)view{

    if (view == imageToolForHomework) {
        
        [imageToolForHomework mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(imageToolForHomework.frame.size.width,imageToolForHomework.frame.size.height));
        }];
        
        [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width,imageToolForHomework.frame.origin.y+imageToolForHomework.frame.size.height+13.0));
        }];
        
        
    }else if (view == imageToolForAnswer){
        
        [imageToolForAnswer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(imageToolForAnswer.frame.size.width,imageToolForAnswer.frame.size.height));
        }];
        [answerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width,imageToolForAnswer.frame.origin.y+imageToolForAnswer.frame.size.height+13.0));
        }];
    }
    
}

-(void)selectLeftAction:(id)sender{
    
    // 取消所有的网络请求
    [network cancelCurrentRequest];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectRightAction:(id)sender{
    
    [self submitAction:nil];
}

-(void)submitAction:(id)sender{
    
   
     [Utilities showProcessingHud:nil];
    
    [text_content resignFirstResponder];
    [text_answer resignFirstResponder];
    [text_title resignFirstResponder];
    [text_time resignFirstResponder];
    
    
     [self saveButtonImageToFile];
    
    contentStr = text_content.text;
    
    if ([text_content.text isEqualToString:@"输入作业内容"]){
        
        UIColor *color = text_content.textColor;
        CGFloat red = 153.0f/255.0f;
        CGFloat green = 153.0f/255.0f;
        CGFloat bluee = 153.0f/255.0f;
        CGFloat alp = 1.0f;
        if ([color getRed:&red green:&green blue:&bluee alpha:&alp]) {
            
            //text_content.text = @"";
            contentStr = @"";
            
        }
        
    }
    if ([text_title.text isEqualToString:@""]) {
        
        [Utilities dismissProcessingHud:nil];
        [self.view makeToast:@"请输入标题"
                    duration:0.5
                    position:@"center"
                       title:nil];
        
    }else if ([text_time.text isEqualToString:@""] || ![Utilities isPureNumandCharacters:text_time.text]){
        
        [Utilities dismissProcessingHud:nil];
        [self.view makeToast:@"请正确输入预计完成时间"
                    duration:0.5
                    position:@"center"
                       title:nil];
        
    }else if ([text_time.text integerValue] == 0){
        
        [Utilities dismissProcessingHud:nil];
        [self.view makeToast:@"请正确输入预计完成时间"
                    duration:0.5
                    position:@"center"
                       title:nil];
    }else if([contentStr isEqualToString:@""] && [imageArray count] == 0) {
        
        if (_flag == 1) {
            
            if ([(NSMutableArray*)[_dic objectForKey:@"imageArray_content"] count] == 0) {
                
                [Utilities dismissProcessingHud:nil];
                [self.view makeToast:@"请输入作业内容"
                            duration:0.5
                            position:@"center"
                               title:nil];
            }else{
                
                [self sendToServer];
            }
            
        }else{
            
            [Utilities dismissProcessingHud:nil];
            [self.view makeToast:@"请输入作业内容"
                        duration:0.5
                        position:@"center"
                           title:nil];
        }
    
        
    }else{
        [self sendToServer];
        
    }

}

-(void)sendToServer{
    
    NSString *answerStr = text_answer.text;
    
    if ([text_answer.text isEqualToString:@"输入答案内容"]) {
        
        UIColor *color = text_content.textColor;
        CGFloat red = 153.0f/255.0f;
        CGFloat green = 153.0f/255.0f;
        CGFloat bluee = 153.0f/255.0f;
        CGFloat alp = 1.0f;
        if ([color getRed:&red green:&green blue:&bluee alpha:&alp]){
            
            //text_answer.text = @"";
            answerStr = @"";
            
        }
        
    }
    
    //To do:发布/修改作业接口
    if (1 == _flag) {//修改作业
        /**
         * 修改作业
         * @author luke
         * @date 2016.01.28
         * @args
         *  v=3 ac=HomeworkTeacher op=edit sid=5303 cid=6735 uid=6939 times=作业时长 title=标题 question=作业内容 answer=答案内容
         *  qng[0..9]=作业图片 ang[0..9]=答案图片 _qngs=作业图片删除IDs _angs=答案图片删除IDs
         */
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"HomeworkTeacher", @"ac",
                              @"3",@"v",
                              @"edit", @"op",
                              _cid, @"cid",
                              _tid,@"tid",
                              text_title.text, @"title",
                              contentStr, @"question",
                              answerStr,@"answer",
                              text_time.text, @"times",
                              _qngs,@"_qngs",
                              _angs,@"_angs",
                              imageArray, @"imageArray",
                              imageArray_answer,@"imageArray2",
                              nil];
        
        [network sendHttpReq:HttpReq_HomeworkModify andData:data];
        
        
    }else{//发布作业
        
        /**
         * 上传作业
         * @author luke
         * @date 2016.01.28
         * @args
         *  v=3 ac=HomeworkTeacher op=upload sid=5303 cid=6735 uid=6939 times=作业时长 title=标题 question=作业内容 answer=答案内容
         *  qng[0..9]=作业图片 ang[0..9]=答案图片
         *
         */
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"HomeworkTeacher", @"ac",
                              @"3",@"v",
                              @"upload", @"op",
                              _cid, @"cid",
                              text_title.text, @"title",
                              contentStr, @"question",
                              answerStr,@"answer",
                              text_time.text, @"times",
                              imageArray, @"imageArray",
                              imageArray_answer,@"imageArray2",
                              nil];
        
        [network sendHttpReq:HttpReq_HomeworkSend andData:data];
        
        
    }
}


-(void)saveButtonImageToFile{
    
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //指定新建文件夹路径
    NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"WeixiaoHomeworkImageFile"];
    //创建ImageFile文件夹
    [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    if (1 == _flag){
       
        if (imageToolForHomework.buttonArray.count > 1) {
            
            UIImage *image = nil;
            
            if ([imageToolForHomework.assetsAndImgs count] > [imageToolForHomework.imageWithIdArray count]) {
                
                int start = [imageToolForHomework.imageWithIdArray count];//大于imageWithIdArray数量的图片是新增的
                for (int i = start; i<[imageToolForHomework.assetsAndImgs count]; i++) {
                    
                    NSString *imgPath = [imageDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"imageEdit%d.png",(i+1)]];
                    NSLog(@"imgPath:%@",imgPath);
                    
                    if ([[imageToolForHomework.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
                        
                        ALAsset *asset = [imageToolForHomework.assetsAndImgs objectAtIndex:i];// update 2015.04.13
                        //获取资源图片的详细资源信息
                        ALAssetRepresentation* representation = [asset defaultRepresentation];
                        //获取资源图片的高清图
                        //[representation fullResolutionImage];
                        //获取资源图片的全屏图
                        //[representation fullScreenImage];
                        
                        image = [UIImage imageWithCGImage:[representation fullScreenImage]];
                        
                    }else{
                        image = [imageToolForHomework.assetsAndImgs objectAtIndex:i];
                        UIImage *tempImage = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:image.imageOrientation];
                        image = [Utilities fixOrientation:tempImage];
                        
                    }
                    
                    UIImage *scaledImage;
                    UIImage *updateImage;
                    
                    // 如果宽度超过480，则按照比例进行缩放，把宽度固定在480
                    if (image.size.width >= 480) {
                        float scaleRate = 480/image.size.width;
                        
                        float w = 480;
                        float h = image.size.height * scaleRate;
                        
                        scaledImage = [Utilities imageWithImageSimple:image scaledToSize:CGSizeMake(w, h)];
                    }
                    
                    if (scaledImage != Nil) {
                        updateImage = scaledImage;
                    } else {
                        updateImage = image;
                    }
                    
                    NSData *data;
                    data = UIImageJPEGRepresentation(image, 0.3);
                    
                    UIImage *img = [UIImage imageWithData:data];
                    
                    [[NSFileManager defaultManager] createFileAtPath:imgPath contents:[self imageToNsdata:img] attributes:nil];
                    
                    [imageArray setValue:imgPath forKey:[@"qng" stringByAppendingString:[NSString stringWithFormat:@"%d",i-start]]];
                }
            }
           
            
        }
        
        for (int i=0; i<[imageToolForHomework.deleteFlagArray count]; i++) {
            
            NSString *deleteIdStr = [imageToolForHomework.deleteFlagArray objectAtIndex:i];
            
            if (i == 0) {
                _qngs = deleteIdStr;
                
            }else{
                _qngs = [NSString stringWithFormat:@"%@,%@",_qngs,deleteIdStr];
                
            }
            
            
        }
        
        NSLog(@"qngs:%@",_qngs);
        
        if (imageToolForAnswer.buttonArray.count > 1) {
            
            UIImage *image = nil;
            
            if ([imageToolForAnswer.assetsAndImgs count] > [imageToolForAnswer.imageWithIdArray count]){
                
                for (int i=0; i<[imageToolForAnswer.assetsAndImgs count]; i++) {
                    
                    int start = [imageToolForAnswer.imageWithIdArray count];//大于imageWithIdArray数量的图片是新增的
                    for (int i = start; i<[imageToolForAnswer.assetsAndImgs count]; i++) {
                        
                        NSString *imgPath = [imageDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"imageaEdit%d.png",(i+1)]];
                        
                        if ([[imageToolForAnswer.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
                            
                            ALAsset *asset = [imageToolForAnswer.assetsAndImgs objectAtIndex:i];// update 2015.04.13
                            //获取资源图片的详细资源信息
                            ALAssetRepresentation* representation = [asset defaultRepresentation];
                            //获取资源图片的高清图
                            //[representation fullResolutionImage];
                            //获取资源图片的全屏图
                            //[representation fullScreenImage];
                            
                            image = [UIImage imageWithCGImage:[representation fullScreenImage]];
                            
                        }else{
                            image = [imageToolForAnswer.assetsAndImgs objectAtIndex:i];
                            UIImage *tempImage = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:image.imageOrientation];
                            image = [Utilities fixOrientation:tempImage];
                            
                        }
                        
                        UIImage *scaledImage;
                        UIImage *updateImage;
                        
                        // 如果宽度超过480，则按照比例进行缩放，把宽度固定在480
                        if (image.size.width >= 480) {
                            float scaleRate = 480/image.size.width;
                            
                            float w = 480;
                            float h = image.size.height * scaleRate;
                            
                            scaledImage = [Utilities imageWithImageSimple:image scaledToSize:CGSizeMake(w, h)];
                        }
                        
                        if (scaledImage != Nil) {
                            updateImage = scaledImage;
                        } else {
                            updateImage = image;
                        }
                        
                        NSData *data;
                        data = UIImageJPEGRepresentation(image, 0.3);
                        
                        UIImage *img = [UIImage imageWithData:data];
                        
                        [[NSFileManager defaultManager] createFileAtPath:imgPath contents:[self imageToNsdata:img] attributes:nil];
                        
                        [imageArray_answer setValue:imgPath forKey:[@"ang" stringByAppendingString:[NSString stringWithFormat:@"%d",i-start]]];
                    }
                }
            }
            
        }
        
        for (int i=0; i<[imageToolForAnswer.deleteFlagArray count]; i++) {
            
            NSString *deleteIdStr = [imageToolForAnswer.deleteFlagArray objectAtIndex:i];
            
            if (i == 0) {
                _angs = deleteIdStr;
                
            }else{
                _angs = [NSString stringWithFormat:@"%@,%@",_angs,deleteIdStr];
                
            }
            
        }
        
        NSLog(@"angs:%@",_angs);
        
    }else{
        
        if(imageToolForHomework.buttonArray.count > 1){
            
            UIImage *image = nil;
            
            for (int i=0; i<[imageToolForHomework.assetsAndImgs count]; i++) {
                
                NSString *imgPath = [imageDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image%d.png",(i+1)]];
                
                if ([[imageToolForHomework.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
                    
                    ALAsset *asset = [imageToolForHomework.assetsAndImgs objectAtIndex:i];// update 2015.04.13
                    //获取资源图片的详细资源信息
                    ALAssetRepresentation* representation = [asset defaultRepresentation];
                    //获取资源图片的高清图
                    //[representation fullResolutionImage];
                    //获取资源图片的全屏图
                    //[representation fullScreenImage];
                    
                    image = [UIImage imageWithCGImage:[representation fullScreenImage]];
                    
                }else{
                    image = [imageToolForHomework.assetsAndImgs objectAtIndex:i];
                    UIImage *tempImage = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:image.imageOrientation];
                    image = [Utilities fixOrientation:tempImage];
                    
                }
                
                UIImage *scaledImage;
                UIImage *updateImage;
                
                // 如果宽度超过480，则按照比例进行缩放，把宽度固定在480
                if (image.size.width >= 480) {
                    float scaleRate = 480/image.size.width;
                    
                    float w = 480;
                    float h = image.size.height * scaleRate;
                    
                    scaledImage = [Utilities imageWithImageSimple:image scaledToSize:CGSizeMake(w, h)];
                }
                
                if (scaledImage != Nil) {
                    updateImage = scaledImage;
                } else {
                    updateImage = image;
                }
                
                NSData *data;
                data = UIImageJPEGRepresentation(image, 0.3);
                
                UIImage *img = [UIImage imageWithData:data];
                
                [[NSFileManager defaultManager] createFileAtPath:imgPath contents:[self imageToNsdata:img] attributes:nil];
                
                [imageArray setValue:imgPath forKey:[@"qng" stringByAppendingString:[NSString stringWithFormat:@"%d",i]]];
            }
        }
        
        if(imageToolForAnswer.buttonArray.count > 1){
            
            UIImage *image = nil;
            
            for (int i=0; i<[imageToolForAnswer.assetsAndImgs count]; i++) {
                
                NSString *imgPath = [imageDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"imagea%d.png",(i+1)]];
                
                if ([[imageToolForAnswer.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
                    
                    ALAsset *asset = [imageToolForAnswer.assetsAndImgs objectAtIndex:i];// update 2015.04.13
                    //获取资源图片的详细资源信息
                    ALAssetRepresentation* representation = [asset defaultRepresentation];
                    //获取资源图片的高清图
                    //[representation fullResolutionImage];
                    //获取资源图片的全屏图
                    //[representation fullScreenImage];
                    
                    image = [UIImage imageWithCGImage:[representation fullScreenImage]];
                    
                }else{
                    image = [imageToolForAnswer.assetsAndImgs objectAtIndex:i];
                    UIImage *tempImage = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:image.imageOrientation];
                    image = [Utilities fixOrientation:tempImage];
                    
                }
                
                UIImage *scaledImage;
                UIImage *updateImage;
                
                // 如果宽度超过480，则按照比例进行缩放，把宽度固定在480
                if (image.size.width >= 480) {
                    float scaleRate = 480/image.size.width;
                    
                    float w = 480;
                    float h = image.size.height * scaleRate;
                    
                    scaledImage = [Utilities imageWithImageSimple:image scaledToSize:CGSizeMake(w, h)];
                }
                
                if (scaledImage != Nil) {
                    updateImage = scaledImage;
                } else {
                    updateImage = image;
                }
                
                NSData *data;
                data = UIImageJPEGRepresentation(image, 0.3);
                
                UIImage *img = [UIImage imageWithData:data];
                
                [[NSFileManager defaultManager] createFileAtPath:imgPath contents:[self imageToNsdata:img] attributes:nil];
                
                [imageArray_answer setValue:imgPath forKey:[@"ang" stringByAppendingString:[NSString stringWithFormat:@"%d",i]]];
            }
        }
    }
    
}

-(NSData *)imageToNsdata:(UIImage*)img
{
    //以下是保存文件到沙盒路径下
    //把图片转成NSData类型的数据来保存文件
    NSData *data;
    
    return data = UIImageJPEGRepresentation(img, 0.3);

}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (text_time == textField)
    {
        if ([string length]!=0) {
            if ([text_time.text length]>=3) {
                return NO;
            }else{
                return YES;
            }
        }else{
            return YES;
        }
       
    }
    else if(text_title == textField)
    {
        if ([text_title.text length] >= 50) {//班级作业发帖标题 50
            return NO;
        }
        return YES;
    }
    return YES;
}

//--------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
   
    return YES;
}

//--------------------------------------------------------------------------------------

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    // 键盘下落
    [text_content resignFirstResponder];
    [text_answer resignFirstResponder];
    NSLog(@"scrollViewDidEndDragging");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 键盘下落
    NSLog(@"scrollViewDidScroll");
}


//-----------------------------------------------------
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
//    [UIView beginAnimations:@"showKeyboardAnimation" context:nil];
//    [UIView setAnimationDuration:0.20];
//    _scrollerView.contentOffset = CGPointMake(0, 30 );
//    [UIView commitAnimations];
//    
    if (textView == text_answer) {
        if ([text_answer.text isEqualToString:@"输入答案内容"]) {
            
            UIColor *color = text_content.textColor;
            CGFloat red = 153.0f/255.0f;
            CGFloat green = 153.0f/255.0f;
            CGFloat bluee = 153.0f/255.0f;
            CGFloat alp = 1.0f;
            if ([color getRed:&red green:&green blue:&bluee alpha:&alp]){
                
                text_answer.text = @"";
                text_answer.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
                
            }
           
        }
    }else if(textView == text_content){
       
        if ([text_content.text isEqualToString:@"输入作业内容"]){
           
            UIColor *color = text_content.textColor;
            CGFloat red = 153.0f/255.0f;
            CGFloat green = 153.0f/255.0f;
            CGFloat bluee = 153.0f/255.0f;
            CGFloat alp = 1.0f;
            if ([color getRed:&red green:&green blue:&bluee alpha:&alp]) {
                
                text_content.text = @"";
                text_content.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];

            }
            
        }
    }

    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
//    [UIView beginAnimations:@"showKeyboardAnimation" context:nil];
//    [UIView setAnimationDuration:0.20];
//    _scrollerView.contentOffset = CGPointMake(0, 0 );
//    [UIView commitAnimations];
    
    if (textView == text_answer) {
        if ([text_answer.text isEqualToString:@""]) {
            text_answer.text = @"输入答案内容";
            text_answer.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
        }
    }else {
        if ([text_content.text isEqualToString:@""]) {
            text_content.text = @"输入作业内容";
            text_content.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
        }
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < 10000) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    /*if (textView == text_content) {
        
        if ([comcatstr length] == 0) {
            text_content.text = @"输入作业内容";
            text_content.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
        }

        
    }else if (textView == text_answer){
        
        if ([comcatstr length] == 0) {
            text_answer.text = @"输入答案内容";
            text_answer.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
        }
    }*/
    
    NSInteger caninputlen = 10000 - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            //            label_leftNum.text = [NSString stringWithFormat:@"%d/%ld",0,(long)50];
        }
        return NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView == text_content) {
        
        //
        //    if ([textView.text length] == 0) {
        //        [_textViewCommentPlaceholder setHidden:NO];
        //    }else{
        //        [_textViewCommentPlaceholder setHidden:YES];
        //    }
        
        NSString  *nsTextContent = textView.text;
        NSInteger existTextNum = nsTextContent.length;
        
        if (existTextNum > 10000)
        {
            //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
            NSString *s = [nsTextContent substringToIndex:10000];
            
            [textView setText:s];
            
        }else {
            
            CGSize constraintSize;
            constraintSize.width = textView.frame.size.width;
            constraintSize.height = MAXFLOAT;
            
            CGSize sizeFrame = [textView sizeThatFits:constraintSize];
            NSLog(@"*******************************");
            NSLog(@"height:%f",sizeFrame.height);
            NSLog(@"*******************************");
            // 修改下边距约束
            [text_content mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(textView.frame.size.width,sizeFrame.height));
            }];
            // 当黏贴一段文字时 刚更新完text_content的约束立即更新contentView的约束不能生效 需要延时处理 正常输入没问题
            [self performSelector:@selector(updateContentView) withObject:nil afterDelay:0.2];

            // 先取得光标位置
            NSRange cursorTextRange = [text_content selectedRange];
            
            // 获取光标位置之前的所有文字text
            NSString *cursorText = [text_content.text substringToIndex:cursorTextRange.location];
            
            // 接着获取此光标之前的文字在该textView中的高度
            UITextView *tv = [[UITextView alloc] init];
            tv.textAlignment = NSTextAlignmentLeft;
            tv.font = [UIFont systemFontOfSize:17.0f];
            tv.text = cursorText;
            CGSize sizeToFit = [tv sizeThatFits:CGSizeMake(text_content.frame.size.width, MAXFLOAT)];
            int cursorHeight = sizeToFit.height;
            //    NSLog(@"cursorHeight = %d", cursorHeight);
            
            // 整个textView的高度
            int textViewTotalHeight = sizeFrame.height;
            
            // textView的y坐标到屏幕底部的高度
            int r = [Utilities getScreenSize].height - text_content.frame.origin.y-64;
            
            // 为了防止光标点击在整个textView中间时候修改后，scrollView的偏移问题，这里计算一下textView整个的高度距离光标的高度
            int ooo = textViewTotalHeight - cursorHeight;
            //    NSLog(@"ooo = %d", ooo);
            
            // 首先，如果整个textView的高度超出了textView的y坐标到屏幕底部的高度的话，就认为已经超出了屏幕的绘制范围，需要将scrollView的offset设置为输入的文字超出的高度。
            if (textViewTotalHeight > r) {
                // 如果textView整个的高度距离光标的高度小于一行的高度，就认为在整个textView的最下面，需要更改scrollView的offset，并设置偏移。
                if (ooo < 20) {
                    // 最后多加的20是为了多偏移一些，露出一些余白，好看一点。。用于键盘一起开启的情况下
#if 0
                    [_scrollerView setContentOffset:CGPointMake(0, textViewTotalHeight-r+20+10) animated:YES];
#endif
                }else {
                    //            [_scrollViewBg setContentOffset:CGPointMake(0, ooo+10) animated:YES];
                }
            }
            
            //    NSLog(@"textViewTotalHeight = %d", textViewTotalHeight);
            //    NSLog(@"r = %d", r);
            //    NSLog(@"textViewTotalHeight-r = %d", textViewTotalHeight-r);
            
            [UIView animateWithDuration:0.1 animations:^{
                [self.view layoutIfNeeded]; }];
        }
        
    }else{
       
        //
        //    if ([textView.text length] == 0) {
        //        [_textViewCommentPlaceholder setHidden:NO];
        //    }else{
        //        [_textViewCommentPlaceholder setHidden:YES];
        //    }
        
        NSString  *nsTextContent = textView.text;
        NSInteger existTextNum = nsTextContent.length;
        
        if (existTextNum > 10000)
        {
            //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
            NSString *s = [nsTextContent substringToIndex:10000];
            
            [textView setText:s];
            
        }else {
            CGSize constraintSize;
            constraintSize.width = textView.frame.size.width;
            constraintSize.height = MAXFLOAT;
            
            CGSize sizeFrame = [textView sizeThatFits:constraintSize];
            
            // 修改下边距约束
            [text_answer mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(textView.frame.size.width,sizeFrame.height));
            }];
            
//            [answerView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width,imageToolForAnswer.frame.origin.y+imageToolForAnswer.frame.size.height+13.0));
//            }];
            // 当黏贴一段文字时 刚更新完text_answer的约束立即更新answerView的约束不能生效 需要延时处理 正常输入没问题
            [self performSelector:@selector(updateAnswerView) withObject:nil afterDelay:0.2];
            
            // 先取得光标位置
            NSRange cursorTextRange = [text_answer selectedRange];
            
            // 获取光标位置之前的所有文字text
            NSString *cursorText = [text_answer.text substringToIndex:cursorTextRange.location];
            
            // 接着获取此光标之前的文字在该textView中的高度
            UITextView *tv = [[UITextView alloc] init];
            tv.textAlignment = NSTextAlignmentLeft;
            tv.font = [UIFont systemFontOfSize:17.0f];
            tv.text = cursorText;
            CGSize sizeToFit = [tv sizeThatFits:CGSizeMake(text_answer.frame.size.width, MAXFLOAT)];
            int cursorHeight = sizeToFit.height;
            //    NSLog(@"cursorHeight = %d", cursorHeight);
            
            // 整个textView的高度
            int textViewTotalHeight = sizeFrame.height;
            
            // textView的y坐标到屏幕底部的高度
            int r = [Utilities getScreenSize].height - text_answer.frame.origin.y-64;
            
            // 为了防止光标点击在整个textView中间时候修改后，scrollView的偏移问题，这里计算一下textView整个的高度距离光标的高度
            int ooo = textViewTotalHeight - cursorHeight;
            //    NSLog(@"ooo = %d", ooo);
            
            // 首先，如果整个textView的高度超出了textView的y坐标到屏幕底部的高度的话，就认为已经超出了屏幕的绘制范围，需要将scrollView的offset设置为输入的文字超出的高度。
            if (textViewTotalHeight > r) {
                // 如果textView整个的高度距离光标的高度小于一行的高度，就认为在整个textView的最下面，需要更改scrollView的offset，并设置偏移。
                if (ooo < 20) {
                    // 最后多加的20是为了多偏移一些，露出一些余白，好看一点。。
#if 0
                    [_scrollerView setContentOffset:CGPointMake(0, textViewTotalHeight-r+20+10) animated:YES];
#endif
                }else {
                    //            [_scrollViewBg setContentOffset:CGPointMake(0, ooo+10) animated:YES];
                }
            }
            
            //    NSLog(@"textViewTotalHeight = %d", textViewTotalHeight);
            //    NSLog(@"r = %d", r);
            //    NSLog(@"textViewTotalHeight-r = %d", textViewTotalHeight-r);
            
            [UIView animateWithDuration:0.1 animations:^{
                [self.view layoutIfNeeded]; }];
        }
        
    }

}

- (void)updateContentView {

    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width,imageToolForHomework.frame.origin.y+imageToolForHomework.frame.size.height+13.0));
    }];

    [self performSelector:@selector(updateAnswerView) withObject:nil afterDelay:0.2];

    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];


}

- (void)updateAnswerView {
    
    [answerView mas_updateConstraints:^(MASConstraintMaker *make) {
        // y与_textFieldHeight的y相同
        make.top.equalTo(contentView.mas_bottom).with.offset(0);
        
        // x距离_labelHeight右边最长处5
        make.left.equalTo(contentView).with.offset(0);
        
        //        // _textFieldHeight的大小
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width,imageToolForAnswer.frame.origin.y+imageToolForAnswer.frame.size.height+13.0));
        
        
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    CGRect rect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat keyboardHeight = CGRectGetHeight(rect);
    CGFloat keyboardDuration =
    [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 修改下边距约束
    [_scrollerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-keyboardHeight); }];
    
    // 更新约束
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self.view layoutIfNeeded]; }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGRect rect = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    CGFloat keyboardHeight = CGRectGetHeight(rect);
    CGFloat keyboardDuration =
    [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 修改下边距约束
    [_scrollerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view); }];
    
    // 更新约束
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self.view layoutIfNeeded]; }];
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    NSError *error;
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    NSLog(@"resultJSON:%@",resultJSON);
    
    [Utilities dismissProcessingHud:nil];
    
    [text_content resignFirstResponder];
    [text_time resignFirstResponder];
    [text_content resignFirstResponder];

    
    if(true == [result intValue])
    {
        NSString *title = text_title.text;
        
        [[NSUserDefaults standardUserDefaults] setObject:title forKey:[NSString stringWithFormat:@"homeworkTitle"]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        if (_flag == 1 ) {//修改作业
            [ReportObject event:ID_OPEN_HOMEWORK_EDIT];

            // 取消所有的网络请求
            [network cancelCurrentRequest];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadHomeworkDetailView" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            // 取消所有的网络请求
            [network cancelCurrentRequest];
            //done: 发布成功 获取tid 跳转至详情页
            NSDictionary *message_info = [resultJSON objectForKey:@"message"];
            NSString *tid = [NSString stringWithFormat:@"%@",[message_info objectForKey:@"tid"]];
            HomeworkDetailViewController *homeworkDetailV = [[HomeworkDetailViewController alloc] init];
            homeworkDetailV.viewType = @"teacher";
            homeworkDetailV.spaceForClass = _spaceForClass;
            homeworkDetailV.cid = _cid;
            homeworkDetailV.tid = tid;
            homeworkDetailV.submitToDetail = @"1";
            homeworkDetailV.disTitle = _titleName;
            [self.navigationController pushViewController:homeworkDetailV animated:YES];
            
        }
        
    }
}

-(void)reciveHttpDataError:(NSError*)err{
    
    [Utilities dismissProcessingHud:nil];
  
    if (![Utilities isConnected]) {
        [Utilities showAlert:@"错误" message:@"网络连接错误，请稍候再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
    }
}

- (void)isNeedShowMasking{
    // 有答案的情况
    NSString *mask = [[NSUserDefaults standardUserDefaults] objectForKey:@"homeworkTeacherSubmitMasking"];
    
    if (nil == mask) {
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"homeworkTeacherSubmitMasking"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        if (iPhone4) {
            [self showMaskingView:CGRectMake(110, 400, 100, 40) image:[UIImage imageNamed:@"Masking/homeworkTeacherSubmitFor4"]];
        }else {
            [self showMaskingView:CGRectMake(110, 390, 100, 40) image:[UIImage imageNamed:@"Masking/homeworkTeacherSubmit"]];
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
    //    buttonMasking.backgroundColor = [UIColor redColor];
    [buttonMasking addTarget:self action:@selector(dismissMaskingView:) forControlEvents: UIControlEventTouchUpInside];
    [_viewMasking addSubview:buttonMasking];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_viewMasking];
}

- (IBAction)dismissMaskingView:(id)sender {
    _viewMasking.hidden = YES;
}

@end
