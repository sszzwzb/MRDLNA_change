//
//  SchoolExhibitionViewController.h
//  MicroSchool
//
//  Created by jojo on 14/11/28.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

//#import "JSONKit.h"

#import "NameAndImgTableViewCell.h"
#import "SchoolDetailViewController.h"
#import "MyTabBarController.h"
#import "SchoolTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface SchoolExhibitionViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, HttpReqCallbackDelegate, UISearchBarDelegate>
{
    NSMutableArray *dataArray;
    NSMutableArray *searchResults;
    
    UISearchBar *mySearchBar;
    UISearchDisplayController *searchDisplayController;
    
    UIView *noNetworkV;
}

@property (nonatomic, retain) UITableView *tableView;;

@property (nonatomic, retain) UILabel *label_noLike;;

@end
