//
//  LoginTableViewCell.h
//  MicroSchool
//
//  Created by jojo on 14-1-11.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginTableViewCell : UITableViewCell
{
    UILabel *label_pwd;
}

@property (copy, nonatomic) NSString *pwd;
@property (nonatomic, retain) UIImageView *imgView_Veri;

@end
