//
//  ChildrenViewController.m
//  MicroSchool
//
//  Created by Kate on 16/6/17.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "ChildrenViewController.h"
#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "AddClassApplyViewController.h"
#import "ChildTableViewCell.h"

@interface ChildrenViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView *headerView;

@end

@implementation ChildrenViewController
@synthesize listArray;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeTitle:_titleName];
    [self setCustomizeLeftButton];
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60.0)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, [UIScreen mainScreen].bounds.size.width - 20.0, 40.0)];
    label.numberOfLines = 0;
    label.text = @"以下是您的历史绑定记录，请选择需要沿用的ID";
    label.font = [UIFont systemFontOfSize:14.0];
    label.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:label];
    _tableView.tableHeaderView = _headerView;
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)reload{
    
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [listArray count]+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"ChildTableViewCell";
    
    ChildTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:@"ChildTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
        
        cell.unbinBtn.hidden = YES;
    
        if (indexPath.section <= [listArray count]-1){
            
            NSString *title = [NSString stringWithFormat:@"%@",[[listArray objectAtIndex:indexPath.section] objectForKey:@"student_name"]];
            NSString *stuId = [NSString stringWithFormat:@"学生ID:%@",[[listArray objectAtIndex:indexPath.section] objectForKey:@"student_number"]];
            NSString *sex = [NSString stringWithFormat:@"%@",[[listArray objectAtIndex:indexPath.section] objectForKey:@"sex"]];
            NSString *schoolName = [NSString stringWithFormat:@"之前所属学校:%@",[[listArray objectAtIndex:indexPath.section] objectForKey:@"school_name"]];
            
            cell.titleLabel.text = title;
            CGSize titleSize = [Utilities getLabelHeight:cell.titleLabel size:CGSizeMake(258.0, 21.0)];
            cell.titleLabel.frame = CGRectMake(cell.titleLabel.frame.origin.x, cell.titleLabel.frame.origin.y, titleSize.width, titleSize.height);
            
            if ([sex isEqualToString:@"2"]) {
                cell.isMale.image = [UIImage imageNamed:@"personalInfo/female.png"];
            }else{
                cell.isMale.image = [UIImage imageNamed:@"personalInfo//male.png"];
            }
            cell.isMale.frame = CGRectMake(cell.titleLabel.frame.origin.x+titleSize.width+8.0, cell.isMale.frame.origin.y, cell.isMale.frame.size.width, cell.isMale.frame.size.height);

            cell.idLabel.text = stuId;
            cell.ownSchoolLabel.text = schoolName;
            
            //CGSize typeSize = [Utilities getLabelHeight:cell.ownSchoolLabel size:CGSizeMake([UIScreen mainScreen].bounds.size.width -12*2-18*2, MAXFLOAT)];
            CGSize typeSize = [Utilities getStringHeight:schoolName andFont:[UIFont systemFontOfSize:14.0] andSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 12*2 - 18*2, 0)];
            
            if (typeSize.height > 21.0) {
                
                cell.ownSchoolLabel.frame = CGRectMake(cell.ownSchoolLabel.frame.origin.x, cell.ownSchoolLabel.frame.origin.y, cell.ownSchoolLabel.frame.size.width, typeSize.height);
                cell.baseView.frame = CGRectMake(cell.baseView.frame.origin.x, cell.baseView.frame.origin.y, cell.baseView.frame.size.width, 100+(typeSize.height - 21.0)+15.0);
            }else{
                
                cell.ownSchoolLabel.frame = CGRectMake(cell.ownSchoolLabel.frame.origin.x, cell.ownSchoolLabel.frame.origin.y, cell.ownSchoolLabel.frame.size.width, 21.0);
                cell.baseView.frame = CGRectMake(cell.baseView.frame.origin.x, cell.baseView.frame.origin.y, cell.baseView.frame.size.width, 100);
            }
            
            cell.addChildImgV.hidden = YES;
            cell.addChildLabel.hidden = YES;
            cell.titleLabel.hidden = NO;
            cell.isMale.hidden = NO;
            cell.idLabel.hidden = NO;
            cell.ownSchoolLabel.hidden = NO;
            
        }else{
            
            cell.addChildImgV.image = [UIImage imageNamed:@"SwitchChild/icon_addChild.png"];
            cell.addChildImgV.hidden = NO;
            cell.addChildLabel.hidden = NO;
            cell.titleLabel.hidden = YES;
            cell.isMale.hidden = YES;
            cell.idLabel.hidden = YES;
            cell.ownSchoolLabel.hidden = YES;
            
//            if ([_iden isEqualToString:@"student"]) {
//                
//                cell.addChildLabel.text = @"添加新ID";
//            }
            
        }
    
    return cell;
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    if (indexPath.section <= [listArray count]-1){
        
        AddClassApplyViewController *addCAVC = [[AddClassApplyViewController alloc] init];
        addCAVC.flag = 2;
        addCAVC.iden = _iden;
        addCAVC.dataDic = [listArray objectAtIndex:indexPath.section];
        addCAVC.titleName = @"用户信息完善";
        addCAVC.viewType = _viewType;
        addCAVC.cId = _cId;
        [self.navigationController pushViewController:addCAVC animated:YES];
        
    }else{//添加新学生
        
        AddClassApplyViewController *addCAVC = [[AddClassApplyViewController alloc] init];
        addCAVC.flag = 1;
        addCAVC.iden = _iden;
        addCAVC.titleName = @"用户信息完善";
        addCAVC.viewType = _viewType;
        addCAVC.cId = _cId;
        [self.navigationController pushViewController:addCAVC animated:YES];
        
    }
    

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    float height = 100.0;
    
    if (indexPath.section <= [listArray count]-1) {
       
        NSString *schoolName = [NSString stringWithFormat:@"之前所属学校:%@",[[listArray objectAtIndex:indexPath.section] objectForKey:@"school_name"]];
        
        CGSize typeSize = [Utilities getStringHeight:schoolName andFont:[UIFont systemFontOfSize:14.0] andSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 12*2 - 18*2, 0)];
        
        if (typeSize.height > 21.0) {
            
            height = 100+(typeSize.height - 21.0)+15.0;
        }
        
    }
    
    return height;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }else{
        
        return 5.0;
    }
}

@end
