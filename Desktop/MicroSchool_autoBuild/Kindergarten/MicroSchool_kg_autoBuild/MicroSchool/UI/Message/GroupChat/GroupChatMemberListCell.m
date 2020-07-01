//
//  GroupChatMemberListCell.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/6/4.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "GroupChatMemberListCell.h"

@implementation GroupChatMemberListCell

@synthesize name;
@synthesize shcool;
@synthesize spacenote;

@synthesize imgView_thumb;
@synthesize button_addFriend;
@synthesize label_name;
@synthesize label_comment;

@synthesize m_checkImageView;

@synthesize uid;
@synthesize isFriend;
@synthesize cellIndex;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
       
        
        m_checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rb_gander_d_01.png"]];
        m_checkImageView.frame = CGRectMake(15.0, (50.0-18.0)/2, 18.0, 18.0);
        
        [self addSubview:m_checkImageView];
        m_checked = NO;
        [self setChecked:m_checked];
        
        // 头像
        imgView_thumb =[[UIImageView alloc]initWithFrame:CGRectMake(m_checkImageView.frame.origin.x+10+18.0,(50-35)/2,35,35)];
        imgView_thumb.contentMode = UIViewContentModeScaleToFill;
        imgView_thumb.layer.masksToBounds = YES;
        imgView_thumb.layer.cornerRadius = 35/2;
        [self.contentView addSubview:imgView_thumb];
        
        // name
        label_name = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               imgView_thumb.frame.origin.x+35.0+10,
                                                               (50-20)/2,
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
        
        label_comment = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                  185,
                                                                  (35-20)/2,
                                                                  100,
                                                                  20)];
        //设置title自适应对齐
        label_comment.lineBreakMode = NSLineBreakByWordWrapping;
        label_comment.font = [UIFont systemFontOfSize:13.0f];
        label_comment.lineBreakMode = NSLineBreakByTruncatingTail;
        label_comment.textAlignment = NSTextAlignmentLeft;
        label_comment.backgroundColor = [UIColor clearColor];
        label_comment.textColor = [UIColor whiteColor];
        label_comment.hidden = YES;
        label_comment.text = @"选择全部";
        [self.contentView addSubview:label_comment];
        

        
    }
    return self;
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

- (void) setCheckImageViewCenter:(CGPoint)pt alpha:(CGFloat)alpha animated:(BOOL)animated
{
    if (animated)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        
        m_checkImageView.center = pt;
        m_checkImageView.alpha = alpha;
        
        [UIView commitAnimations];
    }
    else
    {
        m_checkImageView.center = pt;
        m_checkImageView.alpha = alpha;
    }
}


- (void) setEditing:(BOOL)editting animated:(BOOL)animated
{
    if (self.editing == editting)
    {
        return;
    }
    
    [super setEditing:editting animated:animated];
    
    if (editting)
    {
        
        if (m_checkImageView == nil)
        {
            m_checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rb_gander_d_01.png"]];
            [self addSubview:m_checkImageView];
        }
        
        [self setChecked:m_checked];
        m_checkImageView.frame = CGRectMake(0, 0, 30, 30);
      
    }
    else
    {
        m_checked = NO;
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.backgroundView = nil;
        
        if (m_checkImageView)
        {
            [self setCheckImageViewCenter:CGPointMake(-CGRectGetWidth(m_checkImageView.frame) * 0.5,
                                                      CGRectGetHeight(self.bounds) * 0.5)
                                    alpha:0.0
                                 animated:animated];
        }
    }
}

- (void) setChecked:(NSInteger)checked
{
    if (checked == 1)
    {
        m_checkImageView.image = [UIImage imageNamed:@"rb_gander_p_01.png"];
        self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
        
    }else if (checked == 2){
     
        m_checkImageView.image = [UIImage imageNamed:@"rb_gander_ee.png"];
        self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
        
    }else
    {
        m_checkImageView.image = [UIImage imageNamed:@"rb_gander_d_01.png"];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    m_checked = checked;
}

@end
