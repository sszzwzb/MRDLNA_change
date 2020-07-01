//
//  SubscribeTableViewCell.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-2-21.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "SubscribeTableViewCell.h"
// 屏幕高度
#define HEIGHT [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation SubscribeTableViewCell

@synthesize title;
@synthesize content;
@synthesize name;
@synthesize time;
@synthesize topNum;

@synthesize imgView_head;
@synthesize imgView_top;

@synthesize button_collect;

@synthesize tid;
@synthesize subuid;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // 头像
        imgView_head =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                   15,
                                                                   (100 - 50)/2,
                                                                   50,
                                                                   50)];
        imgView_head.contentMode = UIViewContentModeScaleToFill;
        imgView_head.layer.masksToBounds = YES;
        imgView_head.layer.cornerRadius = 50/2;
        [self.contentView addSubview:imgView_head];
        
        // 标题
        label_title = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                imgView_head.frame.origin.x + imgView_head.frame.size.width + 10,
                                                                5,
                                                                WIDTH - 75 - 35 - 15,
                                                                35)];
        
        //设置title自适应对齐
        label_title.lineBreakMode = NSLineBreakByWordWrapping;
        label_title.font = [UIFont systemFontOfSize:13.0f];
        label_title.numberOfLines = 0;
        label_title.textColor = [UIColor blackColor];
        label_title.backgroundColor = [UIColor clearColor];
        label_title.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_title];
        
        // 内容
        label_content = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               label_title.frame.origin.x,
                                                               label_title.frame.origin.y + label_title.frame.size.height,
                                                               WIDTH - 75 - 35 - 15 - 20,
                                                               25)];
        
        //设置title自适应对齐
        //label_content.lineBreakMode = NSLineBreakByWordWrapping;
        label_content.font = [UIFont systemFontOfSize:10.0f];
        label_content.numberOfLines = 0;
        label_content.textColor = [UIColor grayColor];
        label_content.backgroundColor = [UIColor clearColor];
        label_content.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_content];

        // 姓名
        label_name = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               label_content.frame.origin.x,
                                                               label_content.frame.origin.y + label_content.frame.size.height+ 5,
                                                               200,
                                                               12)];
        
        //设置title自适应对齐
        label_name.lineBreakMode = NSLineBreakByWordWrapping;
        label_name.font = [UIFont systemFontOfSize:8.0f];
        label_name.textColor = [UIColor grayColor];
        label_name.backgroundColor = [UIColor clearColor];
        label_name.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_name];
        
        // 时间
        label_time = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               label_name.frame.origin.x,
                                                               label_name.frame.origin.y + label_name.frame.size.height,
                                                               200,
                                                               12)];

        //设置title自适应对齐
        label_time.lineBreakMode = NSLineBreakByWordWrapping;
        label_time.font = [UIFont systemFontOfSize:8.0f];
        label_time.textColor = [UIColor grayColor];
        label_time.backgroundColor = [UIColor clearColor];
        label_time.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_time];
        
        // 每条cell最下方的线
        UIImageView *imgView_line1 =[[UIImageView alloc]initWithFrame:CGRectMake(20,98,280,1)];
        [imgView_line1 setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
        [self.contentView addSubview:imgView_line1];

        // 赞图标
        UIImageView *imgView_zan =[[UIImageView alloc]initWithFrame:CGRectMake(280,
                                                                               18,15,15)];
        [imgView_zan setImage:[UIImage imageNamed:@"knowledge/zan.png"]];
        [self.contentView addSubview:imgView_zan];
        
        // 赞数量
        label_topNum = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               imgView_zan.frame.origin.x + imgView_zan.frame.size.width+2,
                                                               imgView_zan.frame.origin.y,
                                                               15,
                                                               15)];
        
        //设置title自适应对齐
        label_topNum.lineBreakMode = NSLineBreakByWordWrapping;
        label_topNum.font = [UIFont boldSystemFontOfSize:9.0f];
        label_topNum.textColor = [UIColor redColor];
        label_topNum.backgroundColor = [UIColor clearColor];
        label_topNum.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_topNum];

        // 订阅button
        button_collect = [UIButton buttonWithType:UIButtonTypeCustom];
        button_collect.frame = CGRectMake(250, 70, 60, 20);
        //button.center = CGPointMake(160.0f, 140.0f);
        
        button_collect.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        // 设置title自适应对齐
        button_collect.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [button_collect setBackgroundImage:[UIImage imageNamed:@"knowledge/btn_common_d.png"] forState:UIControlStateNormal] ;
        [button_collect setBackgroundImage:[UIImage imageNamed:@"knowledge/btn_common_p.png"] forState:UIControlStateHighlighted] ;
        
        button_collect.titleLabel.font = [UIFont boldSystemFontOfSize:9.0f];
        [button_collect setTitle:@"订阅" forState:UIControlStateNormal];
        [button_collect setTitle:@"订阅" forState:UIControlStateHighlighted];
        
        [button_collect addTarget:self action:@selector(collect_btnclick:) forControlEvents: UIControlEventTouchUpInside];
        
        [self.contentView addSubview:button_collect];
    }
    return self;
}

- (IBAction)collect_btnclick:(id)sender
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         tid, @"tid",
                         subuid, @"subuid", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_knowledgeSubscribe" object:self userInfo:dic];

//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"确定订阅么？"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:@"取消"
//                              , nil];
//    
//    [alertView show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // test title
         NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                              tid, @"tid",
                              subuid, @"subuid", nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_knowledgeSubscribe" object:self userInfo:dic];
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

- (void)setTitle:(NSString *)n {
    if(![n isEqualToString:title]) {
        title = [n copy];
        label_title.text = title;
    }
}

- (void)setContent:(NSString *)n {
    if(![n isEqualToString:content]) {
        content = [n copy];
        label_content.text = content;
    }
}

- (void)setName:(NSString *)n {
    if(![n isEqualToString:name]) {
        name = [n copy];
        label_name.text = name;
    }
}

- (void)setTime:(NSString *)n {
    if(![n isEqualToString:time]) {
        time = [n copy];
        label_time.text = time;
    }
}

- (void)setTopNum:(NSString *)n {
    if(![n isEqualToString:topNum]) {
        topNum = [n copy];
        label_topNum.text = topNum;
    }
}

@end
