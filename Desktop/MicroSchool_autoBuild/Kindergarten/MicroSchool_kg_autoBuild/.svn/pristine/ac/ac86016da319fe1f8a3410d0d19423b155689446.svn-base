//
//  AddClassApplyViewController.h
//  MicroSchool
//  K12版本新版加入班级申请
//  Created by Kate on 16/6/17.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AddClassApplyViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
    UIView *segmentBaseView;
    UITableView *tableViewLeft;
    UITableView *tableViewRight;
    NSMutableArray *sectionArray;
    NSMutableArray *sectionArrayRight;
    UISegmentedControl *segmentControl;
    UIButton *submitBtn;
    UITextField *_textField_name;
    UITextField *_textField_nameLeft;
    UITextField *_textField_number;
    NSMutableDictionary *personalInfo;
    NSString *leftClassStr;
    NSString *rightClassStr;
    
    NSString *leftClassID;//所选班级ID 暂无学生ID
    NSString *rightClassID;//所选班级ID 已有学生ID
    
    NSString *leftParentID;//与学生关系 暂无学生ID
    NSString *rightParentID;//与学生关系 已有学生ID

    UILabel *tipLabel;//如何查找ID
    UIView *bottomLine;//底部线
    
    UIButton *howtoFindIdBtn;//如何查找ID

}

@property (retain, nonatomic) NSString *iden;//身份
@property(nonatomic,strong)NSMutableDictionary *dataDic;//老用户数据
@property(nonatomic,strong)NSString *titleName;
@property(nonatomic,assign)NSInteger flag;//选择身份页进入0 点击添加新子女进入1 家长身份绑定的子女cell进入2
@property(nonatomic,strong) NSDictionary *classInfoDic;
@property (retain, nonatomic) NSString *type;
// 身份审核类型
// classApply 发起班级审核
@property(nonatomic,strong) NSString *viewType;
@property(nonatomic,strong) NSString *cId;
@property (nonatomic,assign) NSInteger publish;
// 点我了解什么是成长空间的url
@property (retain, nonatomic) NSString *growingPathStatusUrl;
@end
