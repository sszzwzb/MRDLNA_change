//
//  EduQuestionTableViewCell.m
//  MicroSchool
//
//  Created by jojo on 14-8-29.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "EduQuestionTableViewCell.h"

@implementation EduQuestionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _label_content = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                10,
                                                                10,
                                                                300,
                                                                0)];
        _label_content.lineBreakMode = NSLineBreakByWordWrapping;
        _label_content.font = [UIFont systemFontOfSize:15.0f];
        _label_content.numberOfLines = 0;
        _label_content.textColor = [UIColor blackColor];
        _label_content.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label_content];

        _label_time = [[UILabel alloc] initWithFrame:CGRectZero];
        _label_time.lineBreakMode = NSLineBreakByWordWrapping;
        _label_time.font = [UIFont systemFontOfSize:14.0f];
        _label_time.numberOfLines = 0;
        _label_time.textColor = [UIColor grayColor];
        _label_time.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label_time];

        _label_ans = [[UILabel alloc] initWithFrame:CGRectZero];
        _label_ans.lineBreakMode = NSLineBreakByWordWrapping;
        _label_ans.font = [UIFont systemFontOfSize:14.0f];
        _label_ans.numberOfLines = 0;
        _label_ans.textColor = [[UIColor alloc] initWithRed:33/255.0f green:126/255.0f blue:213/255.0f alpha:1.0];
        _label_ans.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label_ans];

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
