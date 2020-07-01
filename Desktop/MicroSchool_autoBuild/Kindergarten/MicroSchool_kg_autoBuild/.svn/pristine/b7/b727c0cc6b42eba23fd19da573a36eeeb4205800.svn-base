//
//  HomeworkStateDetailViewController.h
//  MicroSchool
//
//  Created by CheungStephen on 2/3/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "HomeworkDetailInfo.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface HomeworkStateDetailViewController : BaseViewController <HomeworkDetailInfoDelegate, UIScrollViewDelegate>

@property(nonatomic,retain) NSString *viewType;
@property(nonatomic,retain) NSString *titleName;

@property(nonatomic,retain) NSString *cid;
@property(nonatomic,retain) NSString *tid;
@property(nonatomic,retain) NSString *number;

@property (nonatomic, retain) NSMutableDictionary *detailInfo;
@property (nonatomic, retain) NSMutableDictionary *firstAnswers;
@property (nonatomic, retain) NSMutableDictionary *secondAnswers;

// 背景scrollView
@property (nonatomic, retain) UIScrollView *scrollViewBg;
@property (nonatomic, retain) UIView *viewWhiteBg;

// 学生第一次回答内容
@property (nonatomic, retain) HomeworkDetailInfo *homeworkFirstAnswer;

// 学生第二次回答内容
@property (nonatomic, retain) HomeworkDetailInfo *homeworkSecondAnswer;

// 批改结果
@property (nonatomic, retain) UILabel *labelComment;

@end
