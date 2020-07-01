//
//  TypeListViewController.m
//  MicroSchool
//
//  Created by Kate on 15-2-4.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "TypeListViewController.h"
#import "MySubscribedArticlesViewController.h"
#import "MySubscribedTeachersViewController.h"
#import "MyCollectedArticlesViewController.h"
#import "MySubjectsViewController.h"
#import "FRNetPoolUtils.h"

@interface TypeListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TypeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeTitle:@"知识库"];
    [self setCustomizeLeftButton];
    
     redLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 35+(50-20)/2, 20, 20)];
    
    numLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 252+6+(50-20)/2, 20, 20)];
    //[self getData];
    
    [self addNumView];
    
    [ReportObject event:ID_OPEN_WIKI_MINE];//2015.06.25
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 列表第一行与最后一行数量
/*-(void)getData{
    
    NSString *lastId = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastKid"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSDictionary *diction = [FRNetPoolUtils getKnowledgeTypeCount:lastId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
          
            if(diction!=nil){
                
                dic = [[NSDictionary alloc] initWithDictionary:diction];
                [self addNumView];
            }
        
        });
    
    });
    
    
}*/

-(void)addNumView{
    
    NSString *usertype = [NSString stringWithFormat:@"%@",[[g_userInfo getUserDetailInfo] objectForKey:@"role_id"]];
        
//        NSString *subscribedWikiCount = [dic objectForKey:@"subscribedWikiCount"];
//        NSString *subscriberCount = [dic objectForKey:@"subscriberCount"];
    
    
        if (_subscribedWikiCount!=nil) {
            if([_subscribedWikiCount intValue] > 0){
                int length = [_subscribedWikiCount length];
                
                redLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 35+(50-20)/2 , length*15, 20);
                
                if (length == 1) {
                    
                    redLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 35+(50-20)/2 , 20, 20);
                }
                redLabel.backgroundColor = [UIColor redColor];
                redLabel.text = _subscribedWikiCount;
                redLabel.textColor = [UIColor whiteColor];
                redLabel.layer.cornerRadius = 10.0;
                redLabel.layer.masksToBounds = YES;
                redLabel.textAlignment = NSTextAlignmentCenter;
                [_tableView addSubview:redLabel];
                
            }
        }
        
        if (_subscriberCount!=nil) {
            //if([_subscriberCount intValue] > 0){
                
                int length = [_subscriberCount length];
                
                if ([usertype intValue] == 9 || [usertype intValue] == 7 || [usertype intValue] == 2) {
                    
                    if (length == 1) {
                        
                       numLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 40, 252+6+(50-20)/2-53 , 20, 20);
                       
                    }else{
                        numLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 40, 252+6+(50-20)/2-53 , length*15, 20);
                    }
                    
                    numLabel.backgroundColor = [UIColor lightGrayColor];
                    numLabel.text = _subscriberCount;
                    numLabel.textColor = [UIColor whiteColor];
                    numLabel.layer.cornerRadius = 10.0;
                    numLabel.layer.masksToBounds = YES;
                    numLabel.textAlignment = NSTextAlignmentCenter;
                    [_tableView addSubview:numLabel];
                }
                
            //}
        }
    
}

-(void)reload{
    
    [_tableView reloadData];
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSString *usertype = [NSString stringWithFormat:@"%@",[[g_userInfo getUserDetailInfo] objectForKey:@"role_id"]];
    if ([usertype intValue] == 9 || [usertype intValue] == 7 || [usertype intValue] == 2) {
    
        return 3;
        
    }else{
        
        return 2;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
     NSString *usertype = [NSString stringWithFormat:@"%@",[[g_userInfo getUserDetailInfo] objectForKey:@"role_id"]];
    int count =1;
    if ([usertype intValue] == 9 || [usertype intValue] == 7 || [usertype intValue] == 2) {
        if (section == 0) {
            count = 2;
            
        }else if (section == 1){
            count = 2;
            
        }else if (section == 2){
            count = 1;
        }
        
    }else{
        
        if (section == 0) {
            count = 2;
        }else if (section == 1){
            
                count = 1;
            
        }
    }
    
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *usertype = [NSString stringWithFormat:@"%@",[[g_userInfo getUserDetailInfo] objectForKey:@"role_id"]];
    
    static NSString *GroupedTableIdentifier = @"reuseIdentifier0";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    if ([usertype intValue] == 9 || [usertype intValue] == 7) {
    
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"我订阅的文章";
                cell.imageView.image = [UIImage imageNamed:@"icon_wdydwz.png"];
                
            }else if (indexPath.row == 1){
                //            cell.textLabel.text = @"我订阅的教师";
                //            cell.imageView.image = [UIImage imageNamed:@"icon_wdydjs.png"];
                cell.textLabel.text = @"我收藏的文章";
                cell.imageView.image = [UIImage imageNamed:@"icon_wscdwz.png"];
            }
        }else if (indexPath.section == 1){
            
        if (indexPath.row == 0){
            
            cell.textLabel.text = @"我订阅的教师";
            cell.imageView.image = [UIImage imageNamed:@"icon_wdydjs.png"];
        }else if (indexPath.row == 1){

                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"订阅我的人";
                cell.imageView.image = [UIImage imageNamed:@"icon_dywdr.png"];
            
        }
        
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"我的课程";
            cell.imageView.image = [UIImage imageNamed:@"icon_wdkc.png"];
        }
    }

    }else{
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                cell.textLabel.text = @"我订阅的文章";
                cell.imageView.image = [UIImage imageNamed:@"icon_wdydwz.png"];
                
            }else if (indexPath.row == 1){
                //            cell.textLabel.text = @"我订阅的教师";
                //            cell.imageView.image = [UIImage imageNamed:@"icon_wdydjs.png"];
                cell.textLabel.text = @"我收藏的文章";
                cell.imageView.image = [UIImage imageNamed:@"icon_wscdwz.png"];
            }
            
        }else if (indexPath.section == 1){
            
            cell.textLabel.text = @"我订阅的教师";
            cell.imageView.image = [UIImage imageNamed:@"icon_wdkc.png"];
        }
    }
   
    
    return cell;
}

#pragma mark - Table view delegate
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
     NSString *usertype = [NSString stringWithFormat:@"%@",[[g_userInfo getUserDetailInfo] objectForKey:@"role_id"]];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    if ([usertype intValue] == 9 || [usertype intValue] == 7 || [usertype intValue] == 2) {
    
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                MySubscribedArticlesViewController *mysav = [[MySubscribedArticlesViewController alloc]init];
                [self.navigationController pushViewController:mysav animated:YES];
                [redLabel removeFromSuperview];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:nil forKey:@"subscribedWikiCount"];
                [defaults synchronize];
            }else if (indexPath.row == 1){
//                MySubscribedTeachersViewController *mysav = [[MySubscribedTeachersViewController alloc]init];
//                [self.navigationController pushViewController:mysav animated:YES];
                MyCollectedArticlesViewController *mysav = [[MyCollectedArticlesViewController alloc]init];
                [self.navigationController pushViewController:mysav animated:YES];
                
            }
            
        }else if (indexPath.section == 1){
            
            if (indexPath.row == 0) {
//                    MyCollectedArticlesViewController *mysav = [[MyCollectedArticlesViewController alloc]init];
//                    [self.navigationController pushViewController:mysav animated:YES];
                 MySubscribedTeachersViewController *mysav = [[MySubscribedTeachersViewController alloc]init];
                [self.navigationController pushViewController:mysav animated:YES];
                    
                }else if (indexPath.row == 1){

                
                }
                
                
        }else{
            MySubjectsViewController *mysav = [[MySubjectsViewController alloc]init];
            [self.navigationController pushViewController:mysav animated:YES];
            
        }
    }else{
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                
                MySubscribedArticlesViewController *mysav = [[MySubscribedArticlesViewController alloc]init];
                [self.navigationController pushViewController:mysav animated:YES];
                [redLabel removeFromSuperview];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:nil forKey:@"subscribedWikiCount"];
                [defaults synchronize];
                
            }else if (indexPath.row == 1){
                MyCollectedArticlesViewController *mysav = [[MyCollectedArticlesViewController alloc]init];
                [self.navigationController pushViewController:mysav animated:YES];
            }
            
        }else if (indexPath.section == 1){
            
            MySubscribedTeachersViewController *mysav = [[MySubscribedTeachersViewController alloc]init];
            [self.navigationController pushViewController:mysav animated:YES];
        }
    }
    
}



@end
