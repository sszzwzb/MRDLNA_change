//
//  FriendNewFriendTableViewCell.m
//  MicroSchool
//
//  Created by zhanghaotian on 5/8/14.
//  Copyright (c) 2014 jiaminnet. All rights reserved.
//

#import "FriendNewFriendTableViewCell.h"

@implementation FriendNewFriendTableViewCell

@synthesize name;
@synthesize content;
@synthesize time;

@synthesize uid;

@synthesize imgView_thumb;;

@synthesize button_addFriend;;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // 头像
        imgView_thumb =[[UIImageView alloc]initWithFrame:CGRectMake(10,15,40,40)];
        imgView_thumb.contentMode = UIViewContentModeScaleToFill;
        imgView_thumb.layer.masksToBounds = YES;
        imgView_thumb.layer.cornerRadius = 40/2;
        [self.contentView addSubview:imgView_thumb];

        // name 148
        label_name = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               imgView_thumb.frame.origin.x + imgView_thumb.frame.size.width + 10,
                                                               imgView_thumb.frame.origin.y,
                                                               180,
                                                               14)];
        label_name.lineBreakMode = NSLineBreakByWordWrapping;
        label_name.font = [UIFont systemFontOfSize:15.0f];
        label_name.lineBreakMode = NSLineBreakByTruncatingTail;
        label_name.textAlignment = NSTextAlignmentLeft;
        label_name.backgroundColor = [UIColor clearColor];
        label_name.textColor = [[UIColor alloc] initWithRed:68/255.0f green:68/255.0f blue:68/255.0f alpha:1.0];
        [self.contentView addSubview:label_name];
        
        // 请求内容
        label_content = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               label_name.frame.origin.x,
                                                               label_name.frame.origin.y + label_name.frame.size.height + 2,
                                                               180,
                                                               14)];
        label_content.lineBreakMode = NSLineBreakByWordWrapping;
        label_content.font = [UIFont systemFontOfSize:13.0f];
        label_content.lineBreakMode = NSLineBreakByTruncatingTail;
        label_content.textAlignment = NSTextAlignmentLeft;
        label_content.backgroundColor = [UIColor clearColor];
        label_content.textColor = [UIColor blackColor];
        [self.contentView addSubview:label_content];

        // 时间
        label_time = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               label_content.frame.origin.x,
                                                               label_content.frame.origin.y + label_content.frame.size.height + 2,
                                                               180,
                                                               14)];
        label_time.lineBreakMode = NSLineBreakByWordWrapping;
        label_time.font = [UIFont systemFontOfSize:13.0f];
        label_time.lineBreakMode = NSLineBreakByTruncatingTail;
        label_time.textAlignment = NSTextAlignmentLeft;
        label_time.backgroundColor = [UIColor clearColor];
        label_time.textColor = [UIColor blackColor];
        [self.contentView addSubview:label_time];

        // 是否同意button
        button_addFriend = [UIButton buttonWithType:UIButtonTypeCustom];
        button_addFriend.frame = CGRectMake(230, (70-30)/2, 50, 30);
        button_addFriend.hidden = YES;
        button_addFriend.titleLabel.textAlignment = NSTextAlignmentCenter;
        button_addFriend.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        [button_addFriend setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        
        [button_addFriend setBackgroundImage:[UIImage imageNamed:@"knowledge/btn_common_d.png"] forState:UIControlStateNormal];
        [button_addFriend setBackgroundImage:[UIImage imageNamed:@"knowledge/btn_common_p.png"] forState:UIControlStateHighlighted];
        
        [button_addFriend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button_addFriend setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        button_addFriend.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        
        [button_addFriend addTarget:self action:@selector(addFriendAgreeOrNot_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        
        [self.contentView addSubview:button_addFriend];
    }
    return self;
}

- (IBAction)addFriendAgreeOrNot_btnclick:(id)sender
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         uid, @"uid",
                         name, @"name",nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_friendAddAgree" object:self userInfo:dic];
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

- (void)setContent:(NSString *)n {
    if(![n isEqualToString:content]) {
        content = [n copy];
        label_content.text = content;
    }
}

- (void)setTime:(NSString *)n {
    if(![n isEqualToString:time]) {
        time = [n copy];
        label_time.text = time;
    }
}

@end
