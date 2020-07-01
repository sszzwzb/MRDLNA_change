//
//  RegionsViewController.m
//  MicroSchool
//
//  Created by Kate on 15-2-5.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "RegionsViewController.h"
#import "ProvinceTableViewCell.h"
#import "CityTableViewCell.h"
#import "SchoolListViewController.h"
#import "SchoolListByCityViewController.h"

@interface RegionsViewController (){
    
     NSMutableArray *_dataList;
}

@property (assign)BOOL isOpen;
@property (nonatomic,retain)NSIndexPath *selectIndex;
@property (strong, nonatomic) IBOutlet UITableView *expansionTableView;

@end

@implementation RegionsViewController
@synthesize isOpen,selectIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    NSString *path  = [[NSBundle mainBundle] pathForResource:@"ExpansionTableTestData" ofType:@"plist"];
    //_dataList = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@"筛选"];
    
    _expansionTableView.tableFooterView = [[UIView alloc]init];
    
    self.expansionTableView.sectionFooterHeight = 0;
    self.expansionTableView.sectionHeaderHeight = 0;
    self.isOpen = NO;
    
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
    
    [_expansionTableView reloadData];
}

-(void)getData{
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *array = nil;
        
        if ([self.fromName isEqualToString:@"stos"]) {
             array = [FRNetPoolUtils getSToSRegions];
        }else{
             array = [FRNetPoolUtils getRegions];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [Utilities dismissProcessingHud:self.view];// 2015.05.12
            
            if (![Utilities isConnected]) {//2015.06.30
                
                noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
                [self.view addSubview:noNetworkV];
                
            }else{
                
                [noNetworkV removeFromSuperview];
            }
            
            if (array == nil) {
                
                //[Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                _expansionTableView.hidden = NO;
                
                if([array count] >0){
                    
                    _expansionTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                    
                    _dataList = [[NSMutableArray alloc]initWithArray:array];
                    
                    
                    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                }
                
            }
        });
        
    });
    

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"sectionCount:%lu",(unsigned long)[_dataList count]);
    return [_dataList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isOpen) {
        if (self.selectIndex.section == section) {
            return [(NSArray *)[[_dataList objectAtIndex:section] objectForKey:@"cities"] count]+1;;
        }
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0) {
        static NSString *CellIdentifier = @"CityTableViewCell";
        CityTableViewCell *cell = (CityTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        NSArray *list = [[_dataList objectAtIndex:self.selectIndex.section] objectForKey:@"cities"];
        cell.titleLabel.text = [[list objectAtIndex:indexPath.row-1] objectForKey:@"name"];
        return cell;
    }else
    {
        static NSString *CellIdentifier = @"ProvinceTableViewCell";
        ProvinceTableViewCell *cell = (ProvinceTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        NSString *name = [[_dataList objectAtIndex:indexPath.section] objectForKey:@"province"];
        cell.titleLabel.text = name;
        [cell changeArrowWithUp:([self.selectIndex isEqual:indexPath]?YES:NO)];
        return cell;
    }
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([indexPath isEqual:self.selectIndex]) {
            self.isOpen = NO;
            [self didSelectCellRowFirstDo:NO nextDo:NO];
            self.selectIndex = nil;
            
        }else
        {
            if (!self.selectIndex) {
                self.selectIndex = indexPath;
                [self didSelectCellRowFirstDo:YES nextDo:NO];
                
            }else
            {
                
                [self didSelectCellRowFirstDo:NO nextDo:YES];
            }
        }
        
    }else
    {
        NSDictionary *dic = [_dataList objectAtIndex:indexPath.section];
        NSArray *list = [dic objectForKey:@"cities"];
        //NSString *item = [[list objectAtIndex:indexPath.row-1] objectForKey:@"name"];
         NSString *rid = [[list objectAtIndex:indexPath.row-1] objectForKey:@"rid"];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:item message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
//        [alert show];
        
       
        if ([self.fromName isEqualToString:@"stos"]) {//校校通
            SchoolListByCityViewController *slv = [[SchoolListByCityViewController alloc]init];
            slv.cid = rid;
            [self.navigationController pushViewController:slv animated:YES];
        }else{
            SchoolListViewController *slv = [[SchoolListViewController alloc]init];
            slv.rid = rid;
            [self.navigationController pushViewController:slv animated:YES];
        }
        
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
    
    ProvinceTableViewCell *cell = (ProvinceTableViewCell *)[self.expansionTableView cellForRowAtIndexPath:self.selectIndex];
    [cell changeArrowWithUp:firstDoInsert];
    
    [self.expansionTableView beginUpdates];
    
    int section = self.selectIndex.section;
    NSUInteger contentCount = [(NSMutableArray *)[[_dataList objectAtIndex:section] objectForKey:@"cities"] count];
    NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
    for (NSUInteger i = 1; i < contentCount + 1; i++) {
        NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
        [rowToInsert addObject:indexPathToInsert];
    }
    
    if (firstDoInsert)
    {
        [self.expansionTableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    else
    {
        [self.expansionTableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    [self.expansionTableView endUpdates];
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [self.expansionTableView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    if (self.isOpen) [self.expansionTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}

@end
