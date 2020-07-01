//
//  FriendTableViewCell.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-4-24.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "FriendTableViewCell.h"

@implementation FriendTableViewCell

@synthesize name;
@synthesize uid;
@synthesize isFriend;
@synthesize authority;

@synthesize btn_thumb;

@synthesize button_addFriend;;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // name
        label_name = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               60,
                                                               (60-20)/2,
                                                               180,
                                                               20)];
        //设置title自适应对齐
        label_name.lineBreakMode = NSLineBreakByWordWrapping;
        label_name.font = [UIFont systemFontOfSize:15.0f];
        label_name.lineBreakMode = NSLineBreakByTruncatingTail;
        label_name.textAlignment = NSTextAlignmentLeft;
        label_name.backgroundColor = [UIColor clearColor];
        label_name.textColor = [UIColor blackColor];
        [self.contentView addSubview:label_name];
        
        // 头像
        btn_thumb = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_thumb.frame = CGRectMake(10,10,40,40);
        [btn_thumb addTarget:self action:@selector(thumb_btnclick:) forControlEvents:UIControlEventTouchDown];
        btn_thumb.layer.masksToBounds = YES;
        btn_thumb.layer.cornerRadius = 40/2;
        btn_thumb.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:btn_thumb];
        
        // 添加好友button
        button_addFriend = [UIButton buttonWithType:UIButtonTypeCustom];
        button_addFriend.frame = CGRectMake(230, (60-25)/2, 60, 25);
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
    [ReportObject event:ID_ADD_FRIEND];//2015.06.24
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         uid, @"uid",
                         name, @"name",
                         authority, @"authority",
                         nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_friendAdd" object:self userInfo:dic];
}

- (IBAction)thumb_btnclick:(id)sender
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         uid, @"uid",
                         name, @"name",nil];
    
    if ([_viewName  isEqual: @"friendView"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_fromFriendView2ProfileView" object:self userInfo:dic];
    }else if (([_viewName  isEqual: @"friendCommonView"])) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_fromFriendCommonView2ProfileView" object:self userInfo:dic];
    }
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

@end
