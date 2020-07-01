//
//  SubjectFilterViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/10/9.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SubjectFilterViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableArray *listArray;
}
@property(nonatomic,strong)NSString *cId;
@end
