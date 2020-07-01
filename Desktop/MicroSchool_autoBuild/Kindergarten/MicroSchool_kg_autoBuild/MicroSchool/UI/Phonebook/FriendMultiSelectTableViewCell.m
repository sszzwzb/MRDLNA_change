//
//  FriendMultiSelectTableViewCell.m
//  MicroSchool
//
//  Created by zhanghaotian on 6/6/14.
//  Copyright (c) 2014 jiaminnet. All rights reserved.
//

#import "FriendMultiSelectTableViewCell.h"

@implementation FriendMultiSelectTableViewCell

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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // 头像
        imgView_thumb =[[UIImageView alloc]initWithFrame:CGRectMake(15,(50-35)/2,35,35)];
        imgView_thumb.contentMode = UIViewContentModeScaleToFill;
        imgView_thumb.layer.masksToBounds = YES;
        imgView_thumb.layer.cornerRadius = 35/2;
        [self.contentView addSubview:imgView_thumb];
        
        m_checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"friend/choose_d.png"]];
        m_checkImageView.frame = CGRectMake(250, (50-27)/2, 27, 27);

        [self addSubview:m_checkImageView];
        m_checked = NO;
        [self setChecked:m_checked];

        // name
        label_name = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               65,
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

//        // 添加好友button
//        button_addFriend = [UIButton buttonWithType:UIButtonTypeCustom];
//        
//        CGSize tagSize = CGSizeMake(35, 35);
//        UIImage *buttonImg_d = [Utilities imageByScalingToSize:tagSize andImg:[UIImage imageNamed:@"friend/choose_d.png"]];
//        UIImage *buttonImg_p = [Utilities imageByScalingToSize:tagSize andImg:[UIImage imageNamed:@"friend/choose_p.png"]];
//
//        [button_addFriend setImage:buttonImg_d forState:UIControlStateNormal] ;
//        [button_addFriend setImage:buttonImg_p forState:UIControlStateHighlighted] ;
//
//        button_addFriend.frame = CGRectMake(250, (50-35)/2, 35, 35);
//        //button_addFriend.hidden = YES;
////        button_addFriend.titleLabel.textAlignment = NSTextAlignmentCenter;
////        button_addFriend.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
////        [button_addFriend setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
////        [button_addFriend setTitleColor:[[UIColor alloc] initWithRed:75/255.0f green:170/255.0f blue:251/255.0f alpha:1.0] forState:UIControlStateNormal];
////        [button_addFriend setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
////        button_addFriend.titleLabel.font = [UIFont boldSystemFontOfSize:11.0f];
//        
//        [button_addFriend addTarget:self action:@selector(addFriend_btnclick:) forControlEvents: UIControlEventTouchUpInside];
//        
//        [self.contentView addSubview:button_addFriend];
        
    }
    return self;
}

- (IBAction)addFriend_btnclick:(id)sender
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         uid, @"uid",
                         name, @"name",
                         cellIndex, @"cellIndex",nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_friendSelect" object:self userInfo:dic];
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
//		self.selectionStyle = UITableViewCellSelectionStyleNone;
//		self.backgroundView = [[UIView alloc] init];
//		self.backgroundView.backgroundColor = [UIColor whiteColor];
//		self.textLabel.backgroundColor = [UIColor clearColor];
//		self.detailTextLabel.backgroundColor = [UIColor clearColor];
		
		if (m_checkImageView == nil)
		{
			m_checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"friend/choose_d.png"]];
			[self addSubview:m_checkImageView];
		}
		
		[self setChecked:m_checked];
        m_checkImageView.frame = CGRectMake(0, 0, 30, 30);
//		m_checkImageView.center = CGPointMake(-CGRectGetWidth(m_checkImageView.frame) * 0.5,
//											  CGRectGetHeight(self.bounds) * 0.5);
//		m_checkImageView.alpha = 0.0;
//		[self setCheckImageViewCenter:CGPointMake(20.5, CGRectGetHeight(self.bounds) * 0.5)
//								alpha:1.0 animated:animated];
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

- (void) setChecked:(BOOL)checked
{
	if (checked)
	{
		m_checkImageView.image = [UIImage imageNamed:@"friend/choose_p.png"];
		self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
	}
	else
	{
		m_checkImageView.image = [UIImage imageNamed:@"friend/choose_d.png"];
		self.backgroundView.backgroundColor = [UIColor whiteColor];
	}
	m_checked = checked;
}

@end
