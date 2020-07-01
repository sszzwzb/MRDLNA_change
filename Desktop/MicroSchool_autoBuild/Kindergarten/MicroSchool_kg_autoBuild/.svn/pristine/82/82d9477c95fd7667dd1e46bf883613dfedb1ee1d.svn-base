//
//  LikerListViewController.m
//  MicroSchool
//
//  Created by Kate on 14-12-22.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "LikerListViewController.h"
#import "LikerListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "FRNetPoolUtils.h"
#import "FriendProfileViewController.h"

@interface LikerListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;

@end

@implementation LikerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeTitle:@"点赞的人"];
    [self setCustomizeLeftButton];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = _headerView;
    [self getData];
    
    [ReportObject event:ID_CIRCLE_LOVE_LIST];//2015.06.25
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

// 获取数据从服务器
-(void)getData{
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *array = [FRNetPoolUtils getLikerList:_tid];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [Utilities dismissProcessingHud:self.view];// 2015.05.12
            
            if (array == nil) {
                
                [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                _tableView.hidden = NO;
                
                if ([array count] >0) {
                    
                  listArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                    
                    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                }
                
                
            }
        });
        
    });
}


#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"LikerListTableViewCell";
    
    LikerListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        
        UINib *nib = [UINib nibWithNibName:@"LikerListTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    NSString* head_url = [[listArray objectAtIndex:indexPath.row] objectForKey:@"avatar"];
    [cell.headImgV sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    cell.nameLabel.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.dateLabel.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"dateline"];
    if (![cell.dateLabel.text isEqualToString:@""]) {
        cell.greenDotImgV.image = [UIImage imageNamed:@"moments/icon_green_dot.png"];
    }else{
        cell.greenDotImgV.image = nil;
    }
    
    NSString *isLine = [[listArray objectAtIndex:indexPath.row] objectForKey:@"line"];
    if ([isLine intValue] == 0) {
        cell.lineView.hidden = YES;
    }else{
        cell.lineView.hidden = NO;
    }
    
    cell.headImgV.layer.masksToBounds = YES;
    cell.headImgV.layer.cornerRadius = cell.headImgV.frame.size.height/2.0;
    
    return cell;
    
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    NSString *uid = [[listArray objectAtIndex:indexPath.row]objectForKey:@"uid"];
    //跳转到个人资料页
    FriendProfileViewController *fpv = [[FriendProfileViewController alloc]init];
    fpv.fuid = uid;
    [self.navigationController pushViewController:fpv animated:YES];
    
    
}


@end
