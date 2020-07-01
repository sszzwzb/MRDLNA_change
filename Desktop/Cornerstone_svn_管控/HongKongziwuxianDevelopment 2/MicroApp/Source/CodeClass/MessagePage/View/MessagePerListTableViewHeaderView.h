//
//  MessagePerListTableViewHeaderView.h
//  MicroApp
//
//  Created by kaiyi on 2018/9/22.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagePerListTableViewHeaderView : UITableViewHeaderFooterView

@property (nonatomic,strong) NSString *timeStr;

+(CGFloat)headerHeight;

@end
