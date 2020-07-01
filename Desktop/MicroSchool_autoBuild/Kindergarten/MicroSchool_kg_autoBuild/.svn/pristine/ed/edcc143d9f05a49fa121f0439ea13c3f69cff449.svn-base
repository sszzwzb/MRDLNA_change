//
//  ParenthoodListForChildTableViewController.m
//  MicroSchool
//
//  Created by Kate on 14-11-11.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "ParenthoodListForChildTableViewController.h"
#import "MyClassListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "FRNetPoolUtils.h"
#import "FriendProfileViewController.h"

@interface ParenthoodListForChildTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *noDataView;

@end

@implementation ParenthoodListForChildTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@"已绑定亲属关系"];
     _noDataView.hidden = YES;
     _tableView.hidden = YES;
     _tableView.tableFooterView = [[UIView alloc] init];
    
    [self getData];
    
    // 您还未绑定任何亲属
    
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

-(void)getData{
    
    [Utilities showProcessingHud:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *array = [FRNetPoolUtils getParenthoodListForChild];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities dismissProcessingHud:self.view];
            
            if ([array count] > 0) {
                
                _noDataView.hidden = YES;
                _tableView.hidden = NO;
                listArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                
            }else{
                _noDataView.hidden = NO;
                _tableView.hidden = YES;
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
    static NSString *CellTableIdentifier = @"MyClassListTableViewCell";
    
    MyClassListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
       
        UINib *nib = [UINib nibWithNibName:@"MyClassListTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
     NSString* head_url = [[listArray objectAtIndex:indexPath.row] objectForKey:@"avatar"];
     [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"bg_photo.png"]];
     cell.ParentNameLabel.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    
     cell.headImgView.layer.masksToBounds = YES;
     cell.headImgView.layer.cornerRadius = cell.headImgView.frame.size.height/2.0;
    
    return cell;
    
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"99999999999999999 %@", indexPath);
    //    NSLog(@"99999999999999999 %d", indexPath.section);
    //    NSLog(@"99999999999999999 %d", indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    FriendProfileViewController *fpV = [[FriendProfileViewController alloc]init];
    fpV.fuid = [[listArray objectAtIndex:indexPath.row] objectForKey:@"parent"];
    [self.navigationController pushViewController:fpV animated:YES];
    
}

@end
