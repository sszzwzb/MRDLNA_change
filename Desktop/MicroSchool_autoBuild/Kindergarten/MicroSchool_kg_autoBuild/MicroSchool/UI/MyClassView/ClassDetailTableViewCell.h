//
//  ClassDetailTableViewCell.h
//  MicroSchool
//
//  Created by Kate on 14-12-4.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ClassDetailTableViewCellDelegate<NSObject>

@optional
-(void)clickComment:(NSString*)indexInArray row:(NSString*)row;
@end

@interface ClassDetailTableViewCell : UITableViewCell{
    
    
}
@property (nonatomic, assign) id<ClassDetailTableViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIImageView *iconImgV;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UILabel *detailLab;//用于三行显示的note
@property (strong, nonatomic) IBOutlet UILabel *descriptionLab;
@property (strong, nonatomic) IBOutlet UILabel *noteLabel;//用于两行显示的note
@property (strong, nonatomic) IBOutlet UIImageView *redImg;
@property (strong, nonatomic) IBOutlet UIView *commentsV;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel1;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel2;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel3;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel1;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel2;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel3;
@property (strong, nonatomic) IBOutlet UIButton *commnetBtn1;
@property (strong, nonatomic) IBOutlet UIButton *commnetBtn2;
@property (strong, nonatomic) IBOutlet UIButton *commnetBtn3;
@property (strong, nonatomic) IBOutlet UIView *lineV1;
@property (strong, nonatomic) IBOutlet UIView *lineV2;
@property (strong, nonatomic) NSString *row;
@property (strong, nonatomic) IBOutlet UIView *subjectTableView;
@property (strong, nonatomic) IBOutlet UILabel *subjectLabel0;
@property (strong, nonatomic) IBOutlet UILabel *subjectLabel1;
@property (strong, nonatomic) IBOutlet UILabel *subjectLabel2;
@property (strong, nonatomic) IBOutlet UILabel *subjectLabel3;
@property (strong, nonatomic) IBOutlet UILabel *subjectLabel4;
@property (strong, nonatomic) IBOutlet UILabel *subjectLabel5;
@property (strong, nonatomic) IBOutlet UILabel *subjectLabel6;
@property (strong, nonatomic) IBOutlet UILabel *subjectLabel7;
@property (strong, nonatomic) IBOutlet UILabel *subjectLabel8;
@property (strong, nonatomic) IBOutlet UILabel *subjectLabel9;
@property (strong, nonatomic) IBOutlet UIButton *isFreeBtn;

@property (strong, nonatomic) UIImageView *imgViewNew;
@end
