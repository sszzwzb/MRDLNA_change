//
//  GroupChatSettingMemberTableViewCell.m
//  MicroSchool
//
//  Created by jojo on 15/5/27.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "GroupChatSettingMemberTableViewCell.h"

@implementation GroupChatSettingMemberTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _memberList = [[GroupChatSettingMemberList alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_memberList];
    }
    
    return  self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMemberListFrame:(CGRect)frame andArr:(NSArray *)arr
{
    _memberList.frame = frame;
    [_memberList setImgAndName:arr];
}

- (void)setMemberListFrame:(CGRect)frame andArr:(NSArray *)arr showRemoveIcon:(BOOL)isShow
{
    _memberList.frame = frame;
    _memberList.hiddenMomentsList = _hiddenMomentsList;

    [_memberList setImgAndName:arr showRemoveIcon:isShow];
}

- (void)setMemberListDelete
{
    
}

- (void)setRemoveIconHidden:(BOOL)isHidden;
{
    [_memberList setRemoveIconHidden:isHidden];
}

- (void)removeAllMember
{
    [_memberList removeAllMember];
}

- (void)removeMemberAtIndex:(NSInteger)pos
{
    [_memberList removeMemberAtIndex:pos];
}

@end
