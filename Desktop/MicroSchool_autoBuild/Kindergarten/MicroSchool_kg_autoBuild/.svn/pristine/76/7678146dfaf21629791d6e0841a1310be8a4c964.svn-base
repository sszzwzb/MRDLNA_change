//
//  SubscribePeopleTableViewCell.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-2-22.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "SubscribePeopleTableViewCell.h"
// 屏幕高度
#define HEIGHT [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation SubscribePeopleTableViewCell

@synthesize name;
@synthesize school;

@synthesize imgView_head;

@synthesize button_cancelSubscribe;

@synthesize subuid;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // 头像
        imgView_head = [[UIImageView alloc]initWithFrame:CGRectMake(
                                                                   20,
                                                                   (80 - 50)/2,
                                                                   50,
                                                                   50)];
        imgView_head.contentMode = UIViewContentModeScaleToFill;
        imgView_head.layer.masksToBounds = YES;
        imgView_head.layer.cornerRadius = 50/2;
        [self.contentView addSubview:imgView_head];
        
        // 姓名
        label_name = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                imgView_head.frame.origin.x + imgView_head.frame.size.width + 15,
                                                                imgView_head.frame.origin.y + 3,
                                                                WIDTH - 75 - 30,
                                                                20)];
        
        //设置title自适应对齐
        //label_name.lineBreakMode = NSLineBreakByWordWrapping;
        label_name.font = [UIFont systemFontOfSize:13.0f];
        //label_name.numberOfLines = 0;
        label_name.textColor = [UIColor blackColor];
        label_name.backgroundColor = [UIColor clearColor];
        label_name.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_name];
        
        // 学校
        label_school = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               label_name.frame.origin.x,
                                                               label_name.frame.origin.y + label_name.frame.size.height + 2,
                                                               170,
                                                               20)];
        
        //设置title自适应对齐
        //label_school.lineBreakMode = NSLineBreakByWordWrapping;
        label_school.font = [UIFont systemFontOfSize:10.0f];
        label_school.textColor = [UIColor grayColor];
        label_school.backgroundColor = [UIColor clearColor];
        label_school.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_school];
        
        // 取消收藏button
        button_cancelSubscribe = [UIButton buttonWithType:UIButtonTypeCustom];
        button_cancelSubscribe.frame = CGRectMake(240, label_school.frame.origin.y, 60, 20);
        //button.center = CGPointMake(160.0f, 140.0f);
        
        button_cancelSubscribe.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        // 设置title自适应对齐
        button_cancelSubscribe.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [button_cancelSubscribe setBackgroundImage:[UIImage imageNamed:@"knowledge/btn_common_r_d.png"] forState:UIControlStateNormal] ;
        [button_cancelSubscribe setBackgroundImage:[UIImage imageNamed:@"knowledge/btn_common_r_p.png"] forState:UIControlStateHighlighted] ;
        
        button_cancelSubscribe.titleLabel.font = [UIFont boldSystemFontOfSize:9.0f];
        [button_cancelSubscribe setTitle:@"取消订阅" forState:UIControlStateNormal];
        [button_cancelSubscribe setTitle:@"取消订阅" forState:UIControlStateHighlighted];
        
        [button_cancelSubscribe addTarget:self action:@selector(collect_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        
        [self.contentView addSubview:button_cancelSubscribe];
        
        // 每条cell最下方的线
        UIImageView *imgView_line1 =[[UIImageView alloc]initWithFrame:CGRectMake(20,78,280,1)];
        [imgView_line1 setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
        [self.contentView addSubview:imgView_line1];
    }
    return self;
}

- (IBAction)collect_btnclick:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"确定取消订阅么？"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:@"取消"
                              , nil];
    
    [alertView show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // test title
        NSDictionary *dic = [NSDictionary dictionaryWithObject:subuid forKey:@"subuid"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_knowledgeCancelFollowing" object:self userInfo:dic];
    }
    else {
        // nothing
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setSchool:(NSString *)n {
    if(![n isEqualToString:school]) {
        school = [n copy];
        label_school.text = school;
    }
}

- (void)setName:(NSString *)n {
    if(![n isEqualToString:name]) {
        name = [n copy];
        label_name.text = name;
    }
}


@end
