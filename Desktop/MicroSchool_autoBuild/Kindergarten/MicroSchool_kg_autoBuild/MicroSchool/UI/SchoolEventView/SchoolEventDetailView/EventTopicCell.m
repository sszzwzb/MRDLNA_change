//
//  EventTopicCell.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-1-20.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "EventTopicCell.h"

@implementation EventTopicCell

@synthesize imgView_thumb;
@synthesize imgView_gender;
@synthesize name;
@synthesize note;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        // 名字
        label_name = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 300, 15)];
        //设置title自适应对齐
        label_name.lineBreakMode = NSLineBreakByWordWrapping;
        label_name.textAlignment = NSTextAlignmentRight;
        label_name.font = [UIFont systemFontOfSize:12.0f];
        label_name.numberOfLines = 0;
        label_name.textColor = [UIColor blackColor];
        label_name.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:label_name];
        
        // note
        label_note = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 300, 20)];
        //设置title自适应对齐
        label_note.lineBreakMode = NSLineBreakByWordWrapping;
        label_note.textAlignment = NSTextAlignmentLeft;
        label_note.font = [UIFont systemFontOfSize:16.0f];
        label_note.numberOfLines = 0;
        label_note.backgroundColor = [UIColor clearColor];
        label_note.textColor = [UIColor blackColor];
        [self.contentView addSubview:label_note];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setName:(NSString *)n {
    if(![n isEqualToString:name]) {
        name = [n copy];
        label_name.text = name;
    }
}

- (void)setNote:(NSString *)n {
    if(![n isEqualToString:note]) {
        note = [n copy];
        label_note.text = note;
    }
}

@end
