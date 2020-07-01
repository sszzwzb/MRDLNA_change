//
//  EventTableViewCell.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-25.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "EventTableViewCell.h"

@implementation EventTableViewCell

@synthesize start;
@synthesize end;
@synthesize title;
@synthesize top;
@synthesize jing;
@synthesize type;
@synthesize location;
@synthesize time;
@synthesize member;
@synthesize mtagtype;
@synthesize status;

@synthesize imgView_thumb;
@synthesize imgView_mtagtype;
@synthesize imgView_status;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code        
//        NSLog(@"self.contentView.frame.size.width is %f", self.contentView.frame.size.width);
//        NSLog(@"self.contentView.frame.size.height is %f", self.contentView.frame.size.height);
        
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        {
            // 缩略图
            imgView_thumb =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,self.contentView.frame.size.width,160)];
            imgView_thumb.contentMode = UIViewContentModeScaleToFill;
            [self.contentView addSubview:imgView_thumb];
        }
        else
        {
            // 缩略图
            imgView_thumb =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,300,160)];
            imgView_thumb.contentMode = UIViewContentModeScaleToFill;
            [self.contentView addSubview:imgView_thumb];
        }
        
        // 标题
        label_title = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                    imgView_thumb.frame.origin.y + imgView_thumb.frame.size.height + 20,
                                    self.contentView.frame.size.width,
                                    20)];
        
        //设置title自适应对齐
        label_title.lineBreakMode = NSLineBreakByWordWrapping;
        label_title.font = [UIFont boldSystemFontOfSize:17.0f];
//        label_title.numberOfLines = 0;
        label_title.textColor = [UIColor blackColor];
        label_title.backgroundColor = [UIColor clearColor];
        label_title.lineBreakMode = NSLineBreakByTruncatingTail;

        [self.contentView addSubview:label_title];
        
        // 时间图片
        imgView_startTime =[[UIImageView alloc]initWithFrame:CGRectMake(10,
                                                                        label_title.frame.origin.y + label_title.frame.size.height + 20,
                                                                        15,
                                                                        15)];
        imgView_startTime.image=[UIImage imageNamed:@"icon_event_start_time.png"];
        imgView_startTime.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imgView_startTime];
        
        // 时间
        label_time = [[UILabel alloc]initWithFrame:CGRectMake(10 + 20,
                                                              label_title.frame.origin.y + label_title.frame.size.height + 20,
                                                              150,
                                                              15)];
        
        label_time.font = [UIFont systemFontOfSize:12.0f];
        label_time.textColor = [UIColor grayColor];
        label_time.backgroundColor = [UIColor clearColor];

        [self.contentView addSubview:label_time];
        
        // 地点图片
        imgView_location =[[UIImageView alloc]initWithFrame:CGRectMake(10,
                                                                        imgView_startTime.frame.origin.y + imgView_startTime.frame.size.height + 10,
                                                                        15,
                                                                        20)];
        imgView_location.image=[UIImage imageNamed:@"icon_event_list_location.png"];
        imgView_location.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imgView_location];

        // 地点
        label_location = [[UILabel alloc] initWithFrame:CGRectMake(
                                                            imgView_location.frame.origin.x + imgView_location.frame.size.width + 5,
                                                              imgView_location.frame.origin.y + 5,
                                                              self.contentView.frame.size.width,
                                                              12)];
        
        label_location.font = [UIFont systemFontOfSize:12.0f];
        label_location.textColor = [UIColor grayColor];
        label_location.backgroundColor = [UIColor clearColor];

        [self.contentView addSubview:label_location];
        
        // 成员图片
        imgView_member =[[UIImageView alloc]initWithFrame:CGRectMake(imgView_thumb.frame.size.width - 35,
                                                    label_title.frame.origin.y + label_title.frame.size.height + 20,
                                                    15,
                                                    15)];
        
        imgView_member.image=[UIImage imageNamed:@"icon_event_list_join_in.png"];
        imgView_member.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imgView_member];

        // 成员
        label_member = [[UILabel alloc]initWithFrame:CGRectMake(imgView_member.frame.origin.x + imgView_member.frame.size.width + 5,
                                                              label_title.frame.origin.y + label_title.frame.size.height + 20,
                                                              15,
                                                              15)];
        
        label_member.font = [UIFont systemFontOfSize:12.0f];
        label_member.textColor = [UIColor grayColor];
        label_member.backgroundColor = [UIColor clearColor];

        [self.contentView addSubview:label_member];

        // 班级 or 社团 or 校园图片
        imgView_mtagtype =[[UIImageView alloc]initWithFrame:CGRectMake(imgView_thumb.frame.size.width - 30,
                                                                       imgView_thumb.frame.origin.y + imgView_thumb.frame.size.height + 5,
                                                                        25,
                                                                        15)];
        
        imgView_mtagtype.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imgView_mtagtype];

        // 活动是否结束图片
        imgView_status =[[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       80,
                                                                       80)];
        
        imgView_status.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:imgView_status];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setStart:(NSString *)n {
    if(![n isEqualToString:start]) {
        start = [n copy];
        label_start.text = start;
    }
}

- (void)setEnd:(NSString *)n {
    if(![n isEqualToString:end]) {
        end = [n copy];
        label_end.text = end;
    }
}

- (void)setTitle:(NSString *)n {
    if(![n isEqualToString:title]) {
        title = [n copy];
        label_title.text = title;
    }
}

- (void)setLocation:(NSString *)n {
    if(![n isEqualToString:location]) {
        location = [n copy];
        label_location.text = location;
    }
}

- (void)setTime:(NSString *)n {
    if(![n isEqualToString:time]) {
        time = [n copy];
        label_time.text = time;
    }
}

- (void)setMember:(NSString *)n {
    if(![n isEqualToString:member]) {
        member = [n copy];
        label_member.text = member;
    }
}

- (void)setStatus:(NSString *)n {
    if(![n isEqualToString:status]) {
        status = [n copy];
    }
}




- (void)setTop:(NSString *)n {
    if(![n isEqualToString:top]) {
        top = [n copy];
        label_top.text = top;
    }
}

- (void)setJing:(NSString *)n {
    if(![n isEqualToString:jing]) {
        jing = [n copy];
        label_jing.text = jing;
    }
}

- (void)setType:(NSString *)n {
    if(![n isEqualToString:type]) {
        type = [n copy];
        label_type.text = type;
    }
}

- (void)setImage:(UIImage *)n {
    [imgView_thumb setImage:n];
}

@end
