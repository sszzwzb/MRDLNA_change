//
//  TeacherApplyViewController.m
//  MicroSchool
//
//  Created by CheungStephen on 8/5/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "TeacherApplyViewController.h"

#import "TeacherApplyTableViewCell.h"
#import "TeacherApplyHeaderTableViewCell.h"

@interface TeacherApplyViewController ()

@end

@implementation TeacherApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super setCustomizeTitle:@"我的消息"];
    [self setCustomizeLeftButton];

    _tableView = [[TSTableView alloc] initWithFrame:CGRectMake(0, 0,  [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:_tableView];
    
    _dataArr = [[NSMutableArray alloc] init];
    
    NSMutableArray *section1 = [[NSMutableArray alloc] init];
    NSMutableArray *section2 = [[NSMutableArray alloc] init];
//    NSDictionary *a = _action_msg;
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"111", @"title",
                             [_action_msg objectForKey:@"subject"], @"subject",
                             [_action_msg objectForKey:@"applicant"], @"applicant",
                             [_action_info objectForKey:@"avatar"], @"avatar",
                             [_action_info objectForKey:@"dateline"], @"dateline",

                          nil];

    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,[Utilities transformationWidth:[UIScreen mainScreen].applicationFrame.size.width-90-20], 20000)];
    commentLabel.backgroundColor = [UIColor clearColor];
    commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    commentLabel.font = [UIFont systemFontOfSize:14.0f];
    commentLabel.numberOfLines = 0;
    
    NSString *commentStr = @"暂无";
    if (![[_action_msg objectForKey:@"message"] isEqualToString:@""]) {
        commentStr = [_action_msg objectForKey:@"message"];
    }

    commentLabel.text = commentStr;
    
    CGSize reason = [Utilities getLabelHeight:commentLabel size:CGSizeMake(commentLabel.frame.size.width, 20000)];
    NSDictionary *applyReason = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"申请说明", @"title",
                          commentStr, @"comment",
                        [NSString stringWithFormat:@"%f", reason.height], @"height",
                          nil];
    
    commentLabel.text = [_action_msg objectForKey:@"auditor"];
    CGSize auditHeight = [Utilities getLabelHeight:commentLabel size:CGSizeMake([UIScreen mainScreen].applicationFrame.size.width-90-20, 0)];
    
    NSDictionary *audit = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"审批人", @"title",
                           [_action_msg objectForKey:@"auditor"], @"comment",
                           [NSString stringWithFormat:@"%f", auditHeight.height], @"height",

                                 nil];

    NSString *reasonStr = @"暂无";
    if (![[NSString stringWithFormat:@"%@", [_action_msg objectForKey:@"reason"]] isEqualToString:@""]) {
        reasonStr = [NSString stringWithFormat:@"%@", [_action_msg objectForKey:@"reason"]];
    }
    commentLabel.text = reasonStr;
    CGSize auditReasonHeight = [Utilities getLabelHeight:commentLabel size:CGSizeMake([UIScreen mainScreen].applicationFrame.size.width-90-20, 0)];

    NSDictionary *auditReason = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"审批理由", @"title",
                                 reasonStr, @"comment",
                                 [NSString stringWithFormat:@"%f", auditReasonHeight.height], @"height",
                           nil];

    [section1 addObject:infoDic];
    [section1 addObject:applyReason];
    [section2 addObject:audit];
    [section2 addObject:auditReason];

    [_dataArr addObject:section1];
    [_dataArr addObject:section2];
    
    
    
    
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//右滑返回手势 如果是右滑返回走这个方法 相当于 selectLeftAction 2016.07.15
- (BOOL)gestureRecognizerShouldBegin {
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark Table Data Source Methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)[_dataArr objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_dataArr count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((0 == indexPath.section) &&(0 == indexPath.row) ) {
        return 85;
    }else {
        NSDictionary *dic = [(NSArray *)[_dataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        return ((NSString *)[dic objectForKey:@"height"]).integerValue+36;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    
    NSArray *arr = [_dataArr objectAtIndex:indexPath.section];
    
    NSDictionary* list_dic = [arr objectAtIndex:indexPath.row];
    
    if (0 == indexPath.section && 0 == indexPath.row) {
        TeacherApplyHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        if(cell == nil) {
            cell = [[TeacherApplyHeaderTableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellTableIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *title = [list_dic objectForKey:@"applicant"];
        cell.nameLabel.text = title;
        cell.applyLabel.text = [list_dic objectForKey:@"subject"];
        cell.datelineLabel.text = [_action_info objectForKey:@"dateline"];
        
        if ([[_action_msg objectForKey:@"result"] isEqualToString:@"拒绝"]) {
            cell.statusLabel.textColor = [UIColor redColor];
        }
        cell.statusLabel.text = [_action_msg objectForKey:@"result"];
        
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[list_dic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];

        return cell;
    }else {
        TeacherApplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        if(cell == nil) {
            cell = [[TeacherApplyTableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellTableIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *title = [list_dic objectForKey:@"title"];
        cell.nameLabel.text = title;
        cell.commentLabel.text = [list_dic objectForKey:@"comment"];
        
        [cell.commentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(((NSString *)[list_dic objectForKey:@"height"]).floatValue);
        }];
        
        if ([title isEqualToString:@"审批人"] ) {
            cell.commentLabel.textColor = [[UIColor alloc] initWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
        }else {
            cell.commentLabel.textColor = [[UIColor alloc] initWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0];
        }
        
        
        return cell;
    }
    
}

- (void)reloadTableViewData {
    [_tableView reloadData];
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
}

@end
