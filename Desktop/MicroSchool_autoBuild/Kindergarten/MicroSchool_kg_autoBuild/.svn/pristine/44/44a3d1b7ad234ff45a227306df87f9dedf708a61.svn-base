//
//  SchoolListViewController.m
//  MicroSchool
//
//  Created by Kate on 15-2-5.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "SchoolListViewController.h"
#import "MyClassListTableViewCell.h"
#import "UIImageView+WebCache.h"


@interface SchoolListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

extern NSString *ownsid;
@implementation SchoolListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeTitle:@"选择学校"];
    [self setCustomizeLeftButton];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self getData];
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
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *array = [FRNetPoolUtils getSchool:_rid];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [Utilities dismissProcessingHud:self.view];// 2015.05.12
            
            if (array == nil) {
                
                [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                _tableView.hidden = NO;
                
                if([array count] >0){
                    
                    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                    
                    listArray = [[NSMutableArray alloc]initWithArray:array];
                    
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
    
    static NSString *CellTableIdentifier = @"MyClassListTableViewCell";
    
    MyClassListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        
        UINib *nib = [UINib nibWithNibName:@"MyClassListTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
        NSString* head_url = [[listArray objectAtIndex:indexPath.row] objectForKey:@"avatar"];
        [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"icon_class_avatar_defalt.png"]];
        cell.titleLabel.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.introductionLabel.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"note"];
    
    
    return cell;
    
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    ownsid = [[listArray objectAtIndex:indexPath.row] objectForKey:@"sid"];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    
}

@end
