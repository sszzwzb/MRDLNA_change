//
//  FriendSearchTableViewCell.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-4-30.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "FriendAddSearchTableViewCell.h"

@implementation FriendAddSearchTableViewCell

@synthesize name;
@synthesize shcool;
@synthesize spacenote;

@synthesize imgView_thumb;
@synthesize button_addFriend;

@synthesize uid;
@synthesize isFriend;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // 头像
        imgView_thumb =[[UIImageView alloc]initWithFrame:CGRectMake(15,15,50,50)];
        imgView_thumb.contentMode = UIViewContentModeScaleToFill;
        imgView_thumb.layer.masksToBounds = YES;
        imgView_thumb.layer.cornerRadius = 50/2;
        [self.contentView addSubview:imgView_thumb];

        // name
        label_name = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               80,
                                                               (80-20)/2,
                                                               100,
                                                               20)];
        //设置title自适应对齐
        label_name.lineBreakMode = NSLineBreakByWordWrapping;
        label_name.font = [UIFont systemFontOfSize:15.0f];
        label_name.lineBreakMode = NSLineBreakByTruncatingTail;
        label_name.textAlignment = NSTextAlignmentLeft;
        label_name.backgroundColor = [UIColor clearColor];
        label_name.textColor = [UIColor blackColor];
        [self.contentView addSubview:label_name];

        // spacenote
//        label_spacenote = [[UILabel alloc] initWithFrame:CGRectMake(
//                                                               label_name.frame.origin.x,
//                                                               label_name.frame.origin.y + label_name.frame.size.height,
//                                                               200,
//                                                               20)];
//        //设置title自适应对齐
//        label_spacenote.lineBreakMode = NSLineBreakByWordWrapping;
//        label_spacenote.font = [UIFont systemFontOfSize:12.0f];
//        label_spacenote.lineBreakMode = NSLineBreakByTruncatingTail;
//        label_spacenote.textAlignment = NSTextAlignmentLeft;
//        label_spacenote.backgroundColor = [UIColor clearColor];
//        label_spacenote.textColor = [UIColor grayColor];
//        [self.contentView addSubview:label_spacenote];

        // 添加好友button
        button_addFriend = [UIButton buttonWithType:UIButtonTypeCustom];
        button_addFriend.frame = CGRectMake(230, (80-25)/2, 60, 25);
        button_addFriend.hidden = YES;
        button_addFriend.titleLabel.textAlignment = NSTextAlignmentCenter;
        button_addFriend.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [button_addFriend setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [button_addFriend setTitleColor:[[UIColor alloc] initWithRed:75/255.0f green:170/255.0f blue:251/255.0f alpha:1.0] forState:UIControlStateNormal];
        [button_addFriend setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        button_addFriend.titleLabel.font = [UIFont boldSystemFontOfSize:11.0f];
        
        [button_addFriend addTarget:self action:@selector(addFriend_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        
        [self.contentView addSubview:button_addFriend];

    }
    return self;
}

- (IBAction)addFriend_btnclick:(id)sender
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         uid, @"uid",
                         name, @"name",nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_friendAddReq" object:self userInfo:dic];
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

- (void)setName:(NSString *)n {
    if(![n isEqualToString:name]) {
        name = [n copy];
        label_name.text = name;
    }
}

- (void)setShcool:(NSString *)n {
    if(![n isEqualToString:shcool]) {
        shcool = [n copy];
        label_shcool.text = shcool;
    }
}

- (void)setSpacenote:(NSString *)n {
    if(![n isEqualToString:spacenote]) {
        spacenote = [n copy];
        label_spacenote.text = spacenote;
    }
}

@end
