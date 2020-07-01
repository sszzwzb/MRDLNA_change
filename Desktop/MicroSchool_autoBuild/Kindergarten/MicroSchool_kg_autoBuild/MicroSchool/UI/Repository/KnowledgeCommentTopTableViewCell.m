//
//  KnowledgeCommentTopTableViewCell.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-3-12.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "KnowledgeCommentTopTableViewCell.h"
// 屏幕高度
#define HEIGHT [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation KnowledgeCommentTopTableViewCell

@synthesize name;
@synthesize title;
@synthesize time;
@synthesize message;
@synthesize reply;

@synthesize imgView_head;

@synthesize button_thanks;
@synthesize button_noHelp;

@synthesize subuid;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // 标题
        label_title = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                20,
                                                                10,
                                                                300,
                                                                30)];
        label_title.textColor = [UIColor blackColor];
        label_title.backgroundColor = [UIColor clearColor];
        label_title.font = [UIFont boldSystemFontOfSize:15.0f];
        [self.contentView addSubview:label_title];
        
        // 内容
        label_message = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                  label_title.frame.origin.x,
                                                                  label_title.frame.origin.y + label_title.frame.size.height,
                                                                  300,
                                                                  30)];
        
        //设置title自适应对齐
        //label_content.lineBreakMode = NSLineBreakByWordWrapping;
        label_message.font = [UIFont systemFontOfSize:11.0f];
        label_message.numberOfLines = 0;
        label_message.textColor = [UIColor grayColor];
        label_message.backgroundColor = [UIColor clearColor];
        label_message.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_message];
        
        // 头像
        imgView_head =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                              label_title.frame.origin.x,
                                                              label_title.frame.origin.y + label_title.frame.size.height + 5,
                                                              40,
                                                              40)];
        imgView_head.contentMode = UIViewContentModeScaleToFill;
        imgView_head.layer.masksToBounds = YES;
        imgView_head.layer.cornerRadius = 40/2;
        [self.contentView addSubview:imgView_head];
        
        // 名字
        label_name = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               imgView_head.frame.origin.x + imgView_head.frame.size.width + 10,
                                                               imgView_head.frame.origin.y + 5,
                                                               50,
                                                               30)];
        
        //设置title自适应对齐
        //label_content.lineBreakMode = NSLineBreakByWordWrapping;
        label_name.font = [UIFont systemFontOfSize:11.0f];
        label_name.numberOfLines = 0;
        label_name.textColor = [UIColor grayColor];
        label_name.backgroundColor = [UIColor clearColor];
        label_name.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_name];
        
        // 时间
        label_time = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               label_name.frame.origin.x + label_name.frame.size.width + 10,
                                                               label_name.frame.origin.y,
                                                               100,
                                                               30)];
        
        //设置title自适应对齐
        //label_content.lineBreakMode = NSLineBreakByWordWrapping;
        label_time.font = [UIFont systemFontOfSize:11.0f];
        label_time.numberOfLines = 0;
        label_time.textColor = [UIColor grayColor];
        label_time.backgroundColor = [UIColor clearColor];
        label_time.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_time];
        
        // 回复次数图片
        UIImageView *imgView_message =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                                   label_time.frame.origin.x + label_time.frame.size.width + 3,
                                                                                   label_time.frame.origin.y+ 6,
                                                                                   15,
                                                                                   15)];
        imgView_message.image=[UIImage imageNamed:@"icon_task_comment.png"];
        [self.contentView addSubview:imgView_message];
        
        // 回复次数
        label_replynum = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   imgView_message.frame.origin.x + imgView_message.frame.size.width + 3,
                                                                   imgView_message.frame.origin.y - 2,
                                                                   20,
                                                                   20)];
        label_replynum.lineBreakMode = NSLineBreakByWordWrapping;
        label_replynum.font = [UIFont systemFontOfSize:11.0f];
        label_replynum.numberOfLines = 0;
        label_replynum.textColor = [UIColor grayColor];
        label_replynum.backgroundColor = [UIColor clearColor];
        label_replynum.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_replynum];

        // 头像下方比较短的那个线
        UIImageView *imgView_line1 =[[UIImageView alloc]initWithFrame:CGRectMake(20,
                                                                    imgView_head.frame.origin.y + imgView_head.frame.size.height + 10,
                                                                    280,
                                                                    1)];
        [imgView_line1 setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
        [self.contentView addSubview:imgView_line1];
        
        // 感谢button
        button_thanks = [self createButton:CGRectMake(
                                                      imgView_line1.frame.origin.x,
                                                      imgView_line1.frame.origin.y + 2,
                                                      140,
                                                      40) andName:@"感谢" andTag:1];
        [self.contentView addSubview:button_thanks];
        
        // button中间的线
        UIImageView *imgView_line_1 =[[UIImageView alloc]initWithFrame:CGRectMake(button_thanks.frame.origin.x + button_thanks.frame.size.width,button_thanks.frame.origin.y + 4,1,32)];
        [imgView_line_1 setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
        [self.contentView addSubview:imgView_line_1];
        
        // 没有帮助button
        button_noHelp = [self createButton:CGRectMake(
                                                      button_thanks.frame.origin.x + button_thanks.frame.size.width,
                                                      button_thanks.frame.origin.y,
                                                      140,
                                                      40) andName:@"没有帮助" andTag:2];
        [button_noHelp setTitleEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];

        [self.contentView addSubview:button_noHelp];
        
        // 头像下方比较长的那个线
        UIImageView *imgView_line2 =[[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                    imgView_line1.frame.origin.y + imgView_line1.frame.size.height + 40,
                                                                    WIDTH,
                                                                    1)];
        [imgView_line2 setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
        [self.contentView addSubview:imgView_line2];
    }
    return self;
}

- (void)setTitle:(NSString *)n {
    if(![n isEqualToString:title]) {
        title = [n copy];
        label_title.text = title;
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

- (void)setMessage:(NSString *)n {
    if(![n isEqualToString:message]) {
        message = [n copy];
        label_message.text = message;
    }
}

- (void)setReply:(NSString *)n {
    if(![n isEqualToString:reply]) {
        reply = [n copy];
        label_replynum.text = reply;
    }
}

- (UIButton *)createButton:(CGRect)rect andName:(NSString*)name1 andTag:(NSInteger)tag
{
    // 创建button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.tag = tag;
    
    //设置title自适应对齐
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:9.0f];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
    
    CGSize buttonSize;
    buttonSize.width = 140;
    buttonSize.height = 40;
    
    UIImage *image_home_d;
    UIImage *image_home_p;
    
    if (1 == tag) {
        image_home_d = [UIImage imageNamed:@"knowledge/icon_gx_d.png"];
        image_home_p = [UIImage imageNamed:@"knowledge/icon_gx_p.png"];
    } else if (2 == tag) {
        image_home_d = [UIImage imageNamed:@"knowledge/icon_mybz_d.png"];
        image_home_p = [UIImage imageNamed:@"knowledge/icon_mybz_p.png"];
    } else if (3 == tag) {
        image_home_d = [UIImage imageNamed:@"knowledge/icon_sc_d.png"];
        image_home_p = [UIImage imageNamed:@"knowledge/icon_sc_p.png"];
    } else if (4 == tag) {
        image_home_d = [UIImage imageNamed:@"knowledge/icon_pl_d.png"];
        image_home_p = [UIImage imageNamed:@"knowledge/icon_pl_p.png"];
    }
 
    //----------update by kate 2015.07.01----------------------------------------------
//    UIImage *newImage_home_d = [self resizeImage:image_home_d andSize:buttonSize];
//    UIImage *newImage_home_p = [self resizeImage:image_home_p andSize:buttonSize];
//    
//    [button setBackgroundImage:newImage_home_d forState:UIControlStateNormal] ;
//    [button setBackgroundImage:newImage_home_p forState:UIControlStateHighlighted] ;
    
        UIImage *newImage_home_d = image_home_d;
        UIImage *newImage_home_p = image_home_p;
    
        [button setImage:newImage_home_d forState:UIControlStateNormal] ;
        [button setImage:newImage_home_p forState:UIControlStateHighlighted] ;
    //--------------------------------------------------------------------------------
    
    
    //    if (1 == tag) {
    //        [button setBackgroundImage:[UIImage imageNamed:@"knowledge/icon_gx_d.png"] forState:UIControlStateNormal] ;
    //        [button setBackgroundImage:[UIImage imageNamed:@"knowledge/icon_gx_p.png"] forState:UIControlStateHighlighted] ;
    //    } else if (2 == tag) {
    //        [button setBackgroundImage:[UIImage imageNamed:@"knowledge/icon_mybz_d.png"] forState:UIControlStateNormal] ;
    //        [button setBackgroundImage:[UIImage imageNamed:@"knowledge/icon_mybz_p.png"] forState:UIControlStateHighlighted] ;
    //    } else if (3 == tag) {
    //        [button setBackgroundImage:[UIImage imageNamed:@"knowledge/icon_sc_d.png"] forState:UIControlStateNormal] ;
    //        [button setBackgroundImage:[UIImage imageNamed:@"knowledge/icon_sc_p.png"] forState:UIControlStateHighlighted] ;
    //    } else if (4 == tag) {
    //        [button setBackgroundImage:[UIImage imageNamed:@"knowledge/icon_pl_d.png"] forState:UIControlStateNormal] ;
    //        [button setBackgroundImage:[UIImage imageNamed:@"knowledge/icon_pl_p.png"] forState:UIControlStateHighlighted] ;
    //    }
    
    // 添加 action
    [button addTarget:self action:@selector(btnclick1:) forControlEvents: UIControlEventTouchUpInside];
    
    // 设置title
    [button setTitle:name1 forState:UIControlStateNormal];
    [button setTitle:name1 forState:UIControlStateHighlighted];
    
    return button;
}

-(UIImage*)resizeImage:(UIImage*)raw andSize:(CGSize)resize
{
    UIImage *sizedImage;
    
    UIGraphicsBeginImageContext(resize);
    NSInteger iconWidth = 20;
    [raw drawInRect:CGRectMake((resize.width-iconWidth)/2 - 15, (resize.height-iconWidth)/2,iconWidth,iconWidth)];
    
    sizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return sizedImage;
}

- (IBAction)btnclick1:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    
    if(1 == btn.tag) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"1", @"tag",nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_knowledgeLikeOrNot" object:self userInfo:dic];
    }else if (2 == btn.tag) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"2", @"tag",nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_knowledgeLikeOrNot" object:self userInfo:dic];
    }}

@end
