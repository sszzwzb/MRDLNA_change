//
//  TSTableView.m
//  MicroSchool
//
//  Created by CheungStephen on 7/6/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "TSTableView.h"

#import "UIGuidelineDefine.h"
#import "Utilities.h"

@implementation TSTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];

    self.tableFooterView = [[UIView alloc] init];
    
    // 由于未知的原因，如果不设置一个无限小的header的话，使用TSTableView的view并设置为Group类型的话，
    // tableView上面会出现一个比较大的空隙，所以这里先设置一个很小的headerView。
    if (style == UITableViewStyleGrouped) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
        self.tableHeaderView = headerView;
    }

    // 设置统一的背景灰色
    self.backgroundColor = TS_COLOR_BACKGROUND_GREY_RGB;

    // 默认的分割线按照ui规范都设置为12，如有特殊，则在使用的view上个别设置
    [self setSeparatorInset:UIEdgeInsetsMake(0,[Utilities transformationWidth:12],0,0)];
    
    // 设置统一的分割线灰色
    [self setSeparatorColor:TS_COLOR_TABLEVIEW_SEPARATOR_RGB];
    
    self.sectionFooterHeight = 7.5;
    
    return self;
}

// 如果是Xib想继承自这个类 那么init方法重写以下两个 add by kate
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    self.tableFooterView = [[UIView alloc] init];
    
    // 由于未知的原因，如果不设置一个无限小的header的话，使用TSTableView的view并设置为Group类型的话，
    // tableView上面会出现一个比较大的空隙，所以这里先设置一个很小的headerView。
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    self.tableHeaderView = headerView;

    // 设置统一的背景灰色
    self.backgroundColor = TS_COLOR_BACKGROUND_GREY_RGB;
    
    // 默认的分割线按照ui规范都设置为12，如有特殊，则在使用的view上个别设置
    [self setSeparatorInset:UIEdgeInsetsMake(0,[Utilities transformationWidth:12],0,0)];
    
    // 设置统一的分割线灰色
    [self setSeparatorColor:TS_COLOR_TABLEVIEW_SEPARATOR_RGB];
    
    return self;
}

-(void)awakeFromNib{
    
    self.tableFooterView = [[UIView alloc] init];
    
    // 由于未知的原因，如果不设置一个无限小的header的话，使用TSTableView的view并设置为Group类型的话，
    // tableView上面会出现一个比较大的空隙，所以这里先设置一个很小的headerView。
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    self.tableHeaderView = headerView;

    // 设置统一的背景灰色
    self.backgroundColor = TS_COLOR_BACKGROUND_GREY_RGB;
    
    // 默认的分割线按照ui规范都设置为12，如有特殊，则在使用的view上个别设置
    [self setSeparatorInset:UIEdgeInsetsMake(0,[Utilities transformationWidth:12],0,0)];
    
    // 设置统一的分割线灰色
    [self setSeparatorColor:TS_COLOR_TABLEVIEW_SEPARATOR_RGB];
}

@end
