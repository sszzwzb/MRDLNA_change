//
//  KnowledgeHotWikiFilterViewController.m
//  MicroSchool
//
//  Created by jojo on 15/2/9.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "KnowledgeHotWikiFilterViewController.h"

@interface KnowledgeHotWikiFilterViewController ()

@end

@implementation KnowledgeHotWikiFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    if(OSVersionIsAtLeastiOS7()){
//        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//    }
//    else {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStylePlain];
//    }
    
    [self.tableView setBackgroundColor:[UIColor colorWithRed:110.0/255.0
                                                       green:113.0/255.0
                                                        blue:115.0/255.0
                                                       alpha:1.0]];

    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    
    [self.mm_drawerController setShowsShadow:YES];

//    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
//    
//    UIColor * tableViewBackgroundColor;
//        tableViewBackgroundColor = [UIColor colorWithRed:110.0/255.0
//                                                   green:113.0/255.0
//                                                    blue:115.0/255.0
//                                                   alpha:1.0];
//
//    [self.tableView setBackgroundColor:tableViewBackgroundColor];
//    
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    
//    [self.view setBackgroundColor:[UIColor colorWithRed:66.0/255.0
//                                                  green:69.0/255.0
//                                                   blue:71.0/255.0
//                                                  alpha:1.0]];
    
//    UIColor * barColor = [UIColor colorWithRed:161.0/255.0
//                                         green:164.0/255.0
//                                          blue:166.0/255.0
//                                         alpha:1.0];
//    if([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]){
//        [self.navigationController.navigationBar setBarTintColor:barColor];
//    }
//    else {
//        [self.navigationController.navigationBar setTintColor:barColor];
//    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)selectLeftAction:(id)sender
{
    // 取消所有的网络请求
    [network cancelCurrentRequest];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"KnowlegeHomeTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        
        UINib *nib = [UINib nibWithNibName:@"KnowlegeHomeTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor colorWithRed:110.0/255.0
                                           green:113.0/255.0
                                            blue:115.0/255.0
                                           alpha:1.0];
    
    NSUInteger row = [indexPath row];
    
    return cell;
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    
    KnowledgeHotWikiViewController * center = [[KnowledgeHotWikiViewController alloc] init];
    
    UINavigationController * nav = [[MMNavigationController alloc] initWithRootViewController:center];
    
//    if(indexPath.row%2==0){
//        [self.mm_drawerController
//         setCenterViewController:nav
//         withCloseAnimation:YES
//         completion:nil];
//    }
//    else {
        [self.mm_drawerController
         setCenterViewController:center
         withCloseAnimation:YES
         completion:nil];
//    }

}

@end
