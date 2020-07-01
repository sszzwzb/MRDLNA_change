//
//  AtListViewController.m
//  MicroSchool
//
//  Created by Kate on 16/7/6.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "AtListViewController.h"
#import "AtListTableViewCell.h"
#import "pinyin.h"
#import "ChineseString.h"
#import "PinYinForObjc.h"
#import "UIImageView+WebCache.h"


@interface AtListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation AtListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //这页没搜索 清松确认 2016.07.06
    [self setCustomizeTitle:@"选择提醒的人"];
    [self setCustomizeLeftButton];
    
    mutableArrayOrign = [[NSMutableArray alloc] init];
    searchResults = [[NSMutableArray alloc]init];
    
    _sortedArrForArrays = [[NSMutableArray alloc] init];
    _sectionHeadsKeys = [[NSMutableArray alloc] init];
    
    _sortedArrForArraysFilter = [[NSMutableArray alloc] init];
    _sectionHeadsKeysFilter = [[NSMutableArray alloc] init];
    
    _tableView.hidden = YES;
    
    _tableView.tableFooterView = [[UIView alloc] init];
    
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
   
    [[NSNotificationCenter defaultCenter] postNotificationName:GETATNAMES_MIX object:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//右滑返回手势 如果是右滑返回走这个方法 相当于 selectLeftAction 2016.07.15
- (BOOL)gestureRecognizerShouldBegin{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GETATNAMES_MIX object:nil];
    return YES;
}

-(void)getData{
    
    [Utilities showProcessingHud:self.view];
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"GroupChat",@"ac",
                          @"2",@"v",
                          @"getGroupProfile", @"op",
                          [NSString stringWithFormat:@"%lld",_gid], @"gid",
                          nil];
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
    
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            
            _tableView.hidden = NO;
            
            NSMutableArray *message_info = [[NSMutableArray alloc]initWithArray:[[respDic objectForKey:@"message"] objectForKey:@"members"]];
            NSLog(@"message:%@",message_info);
            
            NSUInteger index = -1;
            for (int i=0; i<[message_info count]; i++) {
                
                NSString *memberUid = [[message_info objectAtIndex:i] objectForKey:@"uid"];
                NSString *myUid = [Utilities getUniqueUidWithoutQuit];
                
                if ([memberUid integerValue] == [myUid integerValue]) {
                    index = i;
                }
                
            }
            
            if (index != -1) {
                [message_info removeObjectAtIndex:index];
            }
            
            if (0 != [message_info count]) {
                
                mutableArrayOrign = [NSMutableArray arrayWithArray:message_info];
                self.sortedArrForArrays = [Utilities getChineseStringArr:mutableArrayOrign andResultKeys:_sectionHeadsKeys flag:0];
                NSLog(@"self.sortedArrForArrays:%@",self.sortedArrForArrays);
            }

            [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
            
        }else{
            
            [Utilities showFailedHud:[NSString stringWithFormat:@"%@",[respDic objectForKey:@"message"]] descView:self.view];
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        
    }];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.sortedArrForArraysFilter count];
    }
    else {
        return [self.sortedArrForArrays count];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return  [(NSArray *)[self.sortedArrForArraysFilter objectAtIndex:section] count];
    }
    else {
        return  [(NSArray *)[self.sortedArrForArrays objectAtIndex:section] count];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_sectionHeadsKeysFilter objectAtIndex:section];
    }
    else {
        return [_sectionHeadsKeys objectAtIndex:section];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.sectionHeadsKeysFilter;
    }
    else {
        return self.sectionHeadsKeys;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AtListTableViewCell";
    
    AtListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        
        UINib *nib = [UINib nibWithNibName:@"AtListTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if ([self.sortedArrForArraysFilter count] > indexPath.section) {
            NSArray *arr = [self.sortedArrForArraysFilter objectAtIndex:indexPath.section];
            if ([arr count] > indexPath.row) {
                ChineseString *str = (ChineseString *) [arr objectAtIndex:indexPath.row];
                
                cell.textLabel.text = str.string;
                
            } else {
                NSLog(@"arr out of range");
            }
        } else {
            NSLog(@"sortedArrForArrays out of range");
        }
    }else{
        
        /*     {
         avatar = "http://test.5xiaoyuan.cn/weixiao/avatar.php?uid=63675&size=big&timestamp=1467599747";
         name = 202mm7;
         uid = 63675;
         },
         */
        
        if ([self.sortedArrForArrays count] > indexPath.section) {
            
            NSArray *arr = [self.sortedArrForArrays objectAtIndex:indexPath.section];
            if ([arr count] > indexPath.row) {
                
                ChineseString *str = (ChineseString *) [arr objectAtIndex:indexPath.row];
                
                cell.titleLabel.text = str.string;
                [cell.imgV sd_setImageWithURL:[NSURL URLWithString:str.avatar] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
               
                
            } else {
                NSLog(@"arr out of range");
            }
        } else {
            NSLog(@"sortedArrForArrays out of range");
        }
    }
    
    return cell;
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *arr = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        arr = [self.sortedArrForArraysFilter objectAtIndex:indexPath.section];
    }
    else {
        arr = [self.sortedArrForArrays objectAtIndex:indexPath.section];
    }
    
    if ([arr count] > indexPath.row) {
        
        // 本页dismiss掉 将@某人 name和uid带回去
        ChineseString *str = (ChineseString *) [arr objectAtIndex:indexPath.row];
        NSString *uid = str.uid;    //value
        NSString *name = str.string;//key
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:uid,@"uid",name,@"name",nil];
        
        if (_type == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GETATNAMES_MIX object:dic];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:GETATNAMES_GROUP object:dic];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
       
    }
    
}

@end
