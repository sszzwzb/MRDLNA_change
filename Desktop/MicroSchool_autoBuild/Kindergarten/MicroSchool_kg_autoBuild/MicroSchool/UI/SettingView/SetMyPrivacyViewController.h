//
//  SetMyPrivacyViewController.h
//  MicroSchool
//
//  Created by Kate on 14-10-27.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SetMyPrivacyViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView *_tableView;
    NSMutableArray *listArray;
    
}

/*"privacy":[{"title":"基本信息","type":"base","fields":[{"field":"marry","title":"婚姻","friend":"0"},{"field":"birth","title":"生日","friend":"0"},{"field":"blood","title":"血型","friend":"0"},{"field":"birthcity","title":"出生地","friend":"0"},{"field":"residecity","title":"居住地","friend":"0"}]},{"title":"联系方式","type":"contact","fields":[{"field":"mobile","title":"手机号码","friend":"3"},{"field":"qq","title":"QQ","friend":"3"},{"field":"msn","title":"MSN","friend":"3"}]}]*/

@end
