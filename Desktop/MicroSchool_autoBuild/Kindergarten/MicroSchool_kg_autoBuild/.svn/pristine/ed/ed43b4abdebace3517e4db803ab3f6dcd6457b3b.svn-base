//
//  EventMemberCell.m
//  MicroSchool
//
//  Created by jojo on 13-12-8.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "EventMemberCell.h"

@implementation EventMemberCell

@synthesize imgView_thumb;
@synthesize imgView_gender;
@synthesize name;
@synthesize note;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        // 头像
        imgView_thumb =[[UIImageView alloc]initWithFrame:CGRectMake(5,(50-40)/2,40,40)];
        imgView_thumb.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imgView_thumb];
        
        // 性别
        imgView_gender =[[UIImageView alloc]initWithFrame:CGRectMake(270,(50-20)/2,20,20)];
        imgView_gender.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imgView_gender];

        // 名字
        label_name = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 160, 15)];
        //设置title自适应对齐
        label_name.lineBreakMode = NSLineBreakByWordWrapping;
        label_name.font = [UIFont boldSystemFontOfSize:12.0f];
        label_name.numberOfLines = 0;
        label_name.textColor = [UIColor blackColor];
        label_name.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:label_name];

        // note
        label_note = [[UILabel alloc] initWithFrame:CGRectMake(50, 25, 160, 15)];
        //设置title自适应对齐
        label_note.lineBreakMode = NSLineBreakByWordWrapping;
        label_note.font = [UIFont systemFontOfSize:11.0f];
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
