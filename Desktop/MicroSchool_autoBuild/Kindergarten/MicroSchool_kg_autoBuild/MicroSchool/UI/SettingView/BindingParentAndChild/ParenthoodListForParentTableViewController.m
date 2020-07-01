//
//  ParenthoodListForParentTableViewController.m
//  MicroSchool
//
//  Created by Kate on 14-11-12.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "ParenthoodListForParentTableViewController.h"
#import "FRNetPoolUtils.h"
#import "ParentBindListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ScanViewController.h"
#import "FriendProfileViewController.h"

@interface ParenthoodListForParentTableViewController ()
@property (strong, nonatomic) IBOutlet UIView *nodataView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ParenthoodListForParentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _nodataView.hidden = YES;
    _tableView.hidden = YES;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@"亲子关系绑定"];
    [self setCustomizeRightButton:@"icon_jrbj"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:@"refreshParentBindList" object:nil];
    
    [self getData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reload{
    
    [_tableView reloadData];
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)selectRightAction:(id)sender{
    
    ScanViewController *scanV = [[ScanViewController alloc]init];
    [self.navigationController pushViewController:scanV animated:YES];
    
}


-(void)getData{
    
    [Utilities showProcessingHud:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *array = [FRNetPoolUtils getParenthoodListForParents];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities dismissProcessingHud:self.view];
            
            if ([array count] > 0) {
                
                _nodataView.hidden = YES;
                _tableView.hidden = NO;
                
                listArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                
            }else{
                
                _nodataView.hidden = NO;
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
    static NSString *CellTableIdentifier = @"ParentBindListTableViewCell";
    
    ParentBindListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        
        UINib *nib = [UINib nibWithNibName:@"ParentBindListTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    NSString* head_url = [[listArray objectAtIndex:indexPath.row] objectForKey:@"avatar"];
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"bg_photo.png"]];
    cell.studentNameLabel.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    cell.headImgView.layer.masksToBounds = YES;
    cell.headImgView.layer.cornerRadius = cell.headImgView.frame.size.height/2.0;
    
    cell.delegte = self;
    cell.index = [NSString stringWithFormat:@"%d",indexPath.row];
    
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
    fpV.fuid = [[listArray objectAtIndex:[sIndex intValue]] objectForKey:@"child"];
    [self.navigationController pushViewController:fpV animated:YES];
    
}

-(void)unBind:(NSString*)index{
    
    sIndex = index;
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要解除绑定关系吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1){
        [Utilities showProcessingHud:self.view];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *msg = [FRNetPoolUtils UnbindForParenthood:[[listArray objectAtIndex:[sIndex intValue]] objectForKey:@"child"]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utilities dismissProcessingHud:self.view];
                
                if (msg == nil) {
                    
                    
                    [self getData];
                    
                    
                }else{
                    
                    [Utilities showAlert:@"错误" message:msg cancelButtonTitle:@"确定" otherButtonTitle:nil];
                }
                
            });
            
        });
    }
}

// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return NO;
}
//
// 是否支持横竖屏显示
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)viewWillAppear:(BOOL)animated{
   
    [super viewWillAppear:animated];
    [MyTabBarController setTabBarHidden:YES];
    self.navigationController.navigationBarHidden = NO;

    if ([self isKindOfClass:[ParenthoodListForParentTableViewController class]]) {
        NSLog(@"Y");
    }

}



@end
