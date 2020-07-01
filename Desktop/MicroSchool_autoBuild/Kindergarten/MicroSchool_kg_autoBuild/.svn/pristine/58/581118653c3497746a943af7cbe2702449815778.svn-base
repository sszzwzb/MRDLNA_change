//
//  FootmarkLinkOrTxtTableViewCell.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/12/24.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FootmarkLinkOrTxtCellDelegate

-(void)gotoFootmarkDetail:(NSInteger)index type:(NSString*)type;

@end


@interface FootmarkLinkOrTxtTableViewCell : UITableViewCell{
    
    id<FootmarkLinkOrTxtCellDelegate> delegte;
}

@property (strong, nonatomic) IBOutlet UILabel *dayLabel;
@property (strong, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imgV;
@property (strong, nonatomic) IBOutlet UILabel *linkTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *txtTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *linkDescribeLabel;
@property (strong, nonatomic) IBOutlet UIView *baseView;
@property (assign, nonatomic) NSInteger index;
@property (strong ,nonatomic) NSString *type;//
@property (strong, nonatomic) id<FootmarkLinkOrTxtCellDelegate> delegte;
@property (strong, nonatomic) IBOutlet UIButton *clickChangeColorBtn;
- (IBAction)gotoDetail:(id)sender;
@end
