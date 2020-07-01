//
//  PersonalProfileViewController.m
//  MicroSchool
//
//  Created by Kate on 14-12-22.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "PersonalProfileViewController.h"

@interface PersonalProfileViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PersonalProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeLeftButton];
    _tableView.tableFooterView = [[UIView alloc] init];
    if ([_fromName isEqualToString:@"profile"]) {
        [self setCustomizeTitle:@"详细资料"];
    }else{
        [self setCustomizeTitle:@"亲子关系"];
    }
    
    NSLog(@"listArray:%@",_listArray);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_fromName isEqualToString:@"profile"]) {
        return [(NSArray *)[[_listArray objectAtIndex:section] objectForKey:@"fields"] count];
    }else{
        return [_listArray count];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_fromName isEqualToString:@"profile"]) {
        
        return [_listArray count];
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:CellTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
    }
    
     cell.textLabel.font = [UIFont systemFontOfSize:17.0];
     cell.detailTextLabel.font = [UIFont systemFontOfSize:17.0];
    
    if ([_fromName isEqualToString:@"profile"]) {
        
        /*
         friend = 0;
         title = "\U624b\U673a\U53f7\U7801";
         type = mobile;
         value = 13252990802;
         */
        NSDictionary *dic = [_listArray objectAtIndex:indexPath.section];
        NSArray *arr = [dic objectForKey:@"fields"];
        NSDictionary *dic1 = [arr objectAtIndex:indexPath.row];
        cell.textLabel.text = [dic1 objectForKey:@"title"];
        NSString *type = [NSString stringWithFormat:@"%@",[dic1 objectForKey:@"type"]];
        
        //0 公开可见 //1朋友可见 //不可见
        NSString *friend = [NSString stringWithFormat:@"%@",[dic1 objectForKey:@"friend"]];
        if ([friend integerValue] == 0) {
            
            cell.detailTextLabel.text = [dic1 objectForKey:@"value"];
            if ([@"mobile" isEqualToString:type]){
                
                if ([self isAvailable:cell.detailTextLabel.text]) {
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }else{
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    
                }
                
            }else{
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                
            }
            
        }else if ([friend integerValue] == 1){
            if ([_isFriend integerValue] == 1) {
                cell.detailTextLabel.text = [dic1 objectForKey:@"value"];
            }
            if ([@"mobile" isEqualToString:type]){
                
                if ([self isAvailable:cell.detailTextLabel.text]) {
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }else{
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    
                }
                
            }else{
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                
            }
            
        }else{
            
            cell.detailTextLabel.text = @"保密";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }
        
    }else{
        
        /*
         {
         name = "2011\U7ea78\U73ed \U674e\U6960";
         title = "\U4eb2\U5b50\U5173\U7cfb";
         uid = 63235;
         }
         */
        cell.textLabel.text = [[_listArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    }
    
    return cell;
    
}

//2015.09.14
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    NSDictionary *dic = [_listArray objectAtIndex:indexPath.section];
    NSArray *arr = [dic objectForKey:@"fields"];
    NSDictionary *dic1 = [arr objectAtIndex:indexPath.row];
    NSString *type = [dic1 objectForKey:@"type"];
    NSString *friend = [NSString stringWithFormat:@"%@",[dic1 objectForKey:@"friend"]];
    
    if ([friend integerValue] == 0 || [friend integerValue] == 1) {
        
        if ([@"mobile" isEqualToString:type]) {//手机号码
            
            phoneNum = [NSString stringWithFormat:@"%@",[dic1 objectForKey:@"value"]];
            if ([phoneNum length] > 0) {
                
                if ([Utilities validateMobile:[phoneNum substringToIndex:3]]) {
                    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"呼叫" otherButtonTitles:@"复制", nil];
                    [actionSheet showInView:_tableView];
                }
                
            }
            
        }
    }else{
        
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {// 呼叫
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"tel://%@",phoneNum]]];
        
    }else{// 复制
        
        if (phoneNum!=nil) {
            if ([phoneNum length] > 0) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                [pasteboard setString:phoneNum];
            }
        }
        
    }
}

-(BOOL)isAvailable:(NSString*)str{
    
    if (str!=nil) {
        
        if ([str length] > 0) {
            //过滤空格
            str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            if ([str length] == 11) {
                NSString *prefix = [str substringToIndex:3];
                
                if ([Utilities validateMobile:prefix]) {
                    return YES;
                }
            }
            
        }
        
    }else{
        return NO;
    }
    
    return NO;
}

@end
