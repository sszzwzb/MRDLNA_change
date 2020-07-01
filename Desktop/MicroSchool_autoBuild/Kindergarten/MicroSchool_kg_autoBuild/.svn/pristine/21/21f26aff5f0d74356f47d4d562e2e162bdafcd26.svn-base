//
//  LoginTableViewCell.m
//  MicroSchool
//
//  Created by jojo on 14-1-11.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "LoginTableViewCell.h"

@implementation LoginTableViewCell

@synthesize pwd;
@synthesize imgView_Veri;;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        label_pwd = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
        label_pwd.lineBreakMode = NSLineBreakByWordWrapping;
        label_pwd.font = [UIFont systemFontOfSize:15.0f];
        label_pwd.textColor = [UIColor blackColor];
        label_pwd.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:label_pwd];
        
        // 密码图标
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        {
            imgView_Veri =[[UIImageView alloc]initWithFrame:CGRectMake(280,label_pwd.frame.origin.y + 6, 17, 17)];
            imgView_Veri.contentMode = UIViewContentModeScaleToFill;
            //imgView_Veri.image=[UIImage imageNamed:@"password.png"];
            [self.contentView addSubview:imgView_Veri];
        }
        else
        {
            imgView_Veri =[[UIImageView alloc]initWithFrame:CGRectMake(270,label_pwd.frame.origin.y + 6, 17, 17)];
            imgView_Veri.contentMode = UIViewContentModeScaleToFill;
            //imgView_Veri.image=[UIImage imageNamed:@"password.png"];
            [self.contentView addSubview:imgView_Veri];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setPwd:(NSString *)n {
    if(![n isEqualToString:pwd]) {
        pwd = [n copy];
        label_pwd.text = pwd;
    }
}

@end
