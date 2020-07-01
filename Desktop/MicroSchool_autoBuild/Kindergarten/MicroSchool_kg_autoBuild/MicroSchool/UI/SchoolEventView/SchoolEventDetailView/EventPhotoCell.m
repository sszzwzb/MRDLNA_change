//
//  EventPhotoCell.m
//  MicroSchool
//
//  Created by jojo on 13-12-8.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "EventPhotoCell.h"

@implementation EventPhotoCell

@synthesize imgView_thumb;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        {
            // 每一条的缩略图
            imgView_thumb =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,self.contentView.frame.size.width,220)];
            imgView_thumb.contentMode = UIViewContentModeScaleAspectFit;
            [self.contentView addSubview:imgView_thumb];
        }
        else
        {
            // 每一条的缩略图
            imgView_thumb =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,300,220)];
            imgView_thumb.contentMode = UIViewContentModeScaleAspectFit;
            [self.contentView addSubview:imgView_thumb];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImage:(UIImage *)n {
    [imgView_thumb setImage:n];
}

@end
