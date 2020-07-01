//
//  ChooseClassViewController.m
//  MicroSchool
//
//  Created by Kate on 15-1-15.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "ChooseClassViewController.h"
#import "FRNetPoolUtils.h"
#import "ChooseClassTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface ChooseClassViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIButton *chooseAllAction;
@property (strong, nonatomic) IBOutlet UIImageView *allImgV;
- (IBAction)chooseAllAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *chooseTopBarLab;

@end

extern NSString *privilege;//权限
extern NSString *privilegeFromMyM;
@implementation ChooseClassViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomizeLeftButton];
    [self setCustomizeRightButtonWithName:@"确定"];
    
#if BUREAU_OF_EDUCATION
    [self setCustomizeTitle:@"选择部门"];
    _chooseTopBarLab.text = @"选中的部门可见";
#else
    [self setCustomizeTitle:@"选择班级"];
#endif
    
    
    _tableView.tableHeaderView = _headerView;
    _tableView.tableFooterView = [[UIView alloc]init];
  
    NSMutableArray *tempArray = nil;
    if([_fromName isEqualToString:@"setPublishM"]){
        tempArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"classListCheckArray"];
        if ([tempArray count] > 0) {
            listCheckArray = [[NSMutableArray alloc]initWithArray:tempArray];
        }else{
            listCheckArray = [[NSMutableArray alloc]init];
        }
    }else if ([_fromName isEqualToString:@"setMyM"]){
        
         NSString *mid = [NSString stringWithFormat:@"%@_classListCheckArray",_fmid];
        tempArray = [[NSUserDefaults standardUserDefaults]objectForKey:mid];
        
        if (_classList == nil) {
            if ([tempArray count] > 0) {
                listCheckArray = [[NSMutableArray alloc]initWithArray:tempArray];
                [self refreshAll];
            }else{
                listCheckArray = [[NSMutableArray alloc]init];
            }

        }else{
            
            if ([tempArray count] > 0) {
                listCheckArray = [[NSMutableArray alloc]initWithArray:tempArray];
                [self refreshAll];
            }else{
               listCheckArray = [[NSMutableArray alloc]init];
            }
        }
       
    }
    
    [self getData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reload{
    
    [_tableView reloadData];
}

// 获取数据从服务器
-(void)getData{
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    [self reloadData];
    
}

-(void)reloadData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *dic = [FRNetPoolUtils getMyClassList];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //[HUD hide:YES];
            [Utilities dismissProcessingHud:self.view];// 2015.05.12
            if (dic == nil) {
                
                [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                NSMutableArray *array = [dic objectForKey:@"list"];
                if (array!=nil) {
                    
                    if ([array count] >0) {
                        
                        _tableView.hidden = NO;
                       
                        listArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                        
                        if ([_fromName isEqualToString:@"setMyM"]){
                            
                            NSString *mid = [NSString stringWithFormat:@"%@_classListCheckArray",_fmid];
                            NSMutableArray *tempArray = [[NSUserDefaults standardUserDefaults]objectForKey:mid];
                            
                            if (_classList!=nil){
                                
                                if ([tempArray count] == 0) {
                                   int checkCount = 0;
                                    if ([listCheckArray count] == 0) {
                                        for (int i=0; i<[listArray count]; i++) {
                                            
                                            NSString *cid = [[listArray objectAtIndex:i] objectForKey:@"tagid"];
                                            NSString *cName = [[listArray objectAtIndex:i] objectForKey:@"tagname"];
                                            NSString *isChecked = @"0";
                                            
                                            for (int j=0; j<[_classList count]; j++) {
                                                if ([cid intValue] == [[[_classList objectAtIndex:j] objectForKey:@"cid"] intValue]) {
                                                    isChecked = @"1";
                                                }
                                            }
                                            
                                            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:isChecked,@"isChecked",cid,@"cid",cName,@"cName",nil];
                                            
                                            [listCheckArray addObject:dic];
                                            
                                           
                                            if ([isChecked intValue] == 1) {
                                                checkCount++;
                                            }
                                            
                                        }
                                        if (checkCount == [listCheckArray count]) {
                                            _allImgV.image = [UIImage imageNamed:@"choose_p.png"];
                                        }else{
                                            _allImgV.image = [UIImage imageNamed:@"choose_d.png"];
                                        }
                                        
                                    }else{
                                        [self refreshAll];
                                    }
                                    
                                }
                            }else{
                                
                                if ([tempArray count] == 0) {
                                    
                                  if ([listCheckArray count] == 0) {
                                      
                                    for (int i=0; i<[listArray count]; i++) {
                                        
                                        NSString *cid = [[listArray objectAtIndex:i] objectForKey:@"tagid"];
                                        NSString *cName = [[listArray objectAtIndex:i] objectForKey:@"tagname"];
                                        
                                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"isChecked",cid,@"cid",cName,@"cName",nil];
                                        
                                        [listCheckArray addObject:dic];
                                        
                                        
                                    }
                                      
                                  }else{
                                      [self refreshAll];
                                  }
                                }
                            }
                            
                        }else if ([_fromName isEqualToString:@"setPublishM"]){
                            if ([listCheckArray count] == 0) {
                                
                                if(_isClass){
                                    
                                    for (int i=0; i<[listArray count]; i++) {
                                        
                                        NSString *cid = [[listArray objectAtIndex:i] objectForKey:@"tagid"];
                                        NSString *cName = [[listArray objectAtIndex:i] objectForKey:@"tagname"];
                                        NSMutableDictionary *dic = nil;
                                        
                                        if([_cid isEqualToString:cid]){
                                            
                                            dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1",@"isChecked",cid,@"cid",cName,@"cName",nil];
                                            
                                        }else{
                                           dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"isChecked",cid,@"cid",cName,@"cName",nil];
                                        }
                                        
                                        [listCheckArray addObject:dic];
                                    }
                                    
                                }else{
                                    
                                    for (int i=0; i<[listArray count]; i++) {
                                        
                                        NSString *cid = [[listArray objectAtIndex:i] objectForKey:@"tagid"];
                                        NSString *cName = [[listArray objectAtIndex:i] objectForKey:@"tagname"];
                                        
                                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"isChecked",cid,@"cid",cName,@"cName",nil];
                                        
                                        [listCheckArray addObject:dic];
                                    }
                                }
                                
                            }else{
                                [self refreshAll];
                            }
                        }
                        [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
//                        NSMutableArray *tempArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"classListCheckArray"];
                   
                        
                    }else{
                        
                        _tableView.hidden = YES;
                      
                    }
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

    static NSString *CellTableIdentifier = @"ChooseClassTableViewCell";
    ChooseClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        
        UINib *nib = [UINib nibWithNibName:@"ChooseClassTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    NSString* head_url = [[listArray objectAtIndex:indexPath.row] objectForKey:@"pic"];
    [cell.headImgV sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"icon_class_avatar_defalt.png"]];
    cell.titleLabel.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"tagname"];

    if ([[[listCheckArray objectAtIndex:indexPath.row] objectForKey:@"isChecked"] intValue] == 1) {
        cell.checkImgV.image = [UIImage imageNamed:@"choose_p.png"];
    }else{
         cell.checkImgV.image = [UIImage imageNamed:@"choose_d.png"];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cid = [[listArray objectAtIndex:indexPath.row] objectForKey:@"tagid"];
    NSString *cName = [[listArray objectAtIndex:indexPath.row] objectForKey:@"tagname"];
    NSDictionary *dic = nil;
    
    NSString *isCheck =[[listCheckArray objectAtIndex:indexPath.row] objectForKey:@"isChecked"];
    
    if ([isCheck intValue] == 1) {
        
        dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"isChecked",cid,@"cid",cName,@"cName",nil];
    }else{
        
        dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1",@"isChecked",cid,@"cid",cName,@"cName",nil];
    }
    
    [listCheckArray replaceObjectAtIndex:indexPath.row withObject:dic];
    
    int checkCount = 0;
    for (int i=0; i<[listCheckArray count]; i++) {
        
        NSMutableDictionary *dic = [listCheckArray objectAtIndex:i];
        NSString *isChecked = [dic objectForKey:@"isChecked"];
        if ([isChecked intValue] == 1) {
            checkCount++;
        }
    }
    
    if (checkCount == [listCheckArray count]) {
         _allImgV.image = [UIImage imageNamed:@"choose_p.png"];
    }else{
        _allImgV.image = [UIImage imageNamed:@"choose_d.png"];
    }
    
    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
    
}

-(void)refreshAll{
    
    int checkCount = 0;
    for (int i=0; i<[listCheckArray count]; i++) {
        
        NSMutableDictionary *dic = [listCheckArray objectAtIndex:i];
        NSString *isChecked = [dic objectForKey:@"isChecked"];
        if ([isChecked intValue] == 1) {
            checkCount++;
        }
    }
    
    if (checkCount == [listCheckArray count]) {
        _allImgV.image = [UIImage imageNamed:@"choose_p.png"];
    }else{
        _allImgV.image = [UIImage imageNamed:@"choose_d.png"];
    }
    
    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
}


-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)selectRightAction:(id)sender{
    
    if([_fromName isEqualToString:@"setPublishM"]){
    
        if ([listCheckArray count] > 0) {
            
            privilege = @"16";
            
            int checkCount = 0;
            for (int i=0; i<[listCheckArray count]; i++) {
                
                NSMutableDictionary *dic = [listCheckArray objectAtIndex:i];
                NSString *isChecked = [dic objectForKey:@"isChecked"];
                if ([isChecked intValue] == 1) {
                    checkCount++;
                }
            }
            
            if (checkCount == 0) {
                
#if BUREAU_OF_EDUCATION
                UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择部门" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
#else
                UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择班级" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
#endif
                
                
                [alerV show];
            }else{
                
                 //NSLog(@"listCheckArray:%@",listCheckArray);
                
                [[NSUserDefaults standardUserDefaults]setObject:listCheckArray forKey:@"classListCheckArray"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
           
            
        }else{
            
#if BUREAU_OF_EDUCATION
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先加入部门" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alerV show];
#else
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先加入班级" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alerV show];
#endif
            
            
            
            
        }
        
    }else if ([_fromName isEqualToString:@"setMyM"]){
        
        if ([listCheckArray count] > 0) {
            
            privilegeFromMyM = @"16";
            
            NSLog(@"listCheckArray:%@",listCheckArray);
            
            int checkCount = 0;
            for (int i=0; i<[listCheckArray count]; i++) {
                
                NSMutableDictionary *dic = [listCheckArray objectAtIndex:i];
                NSString *isChecked = [dic objectForKey:@"isChecked"];
                if ([isChecked intValue] == 1) {
                    checkCount++;
                }
            }
            
            if (checkCount == 0) {
                
#if BUREAU_OF_EDUCATION
                UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择部门" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alerV show];
#else
                UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择班级" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alerV show];
#endif
                
                
            }else{
                NSString *mid = [NSString stringWithFormat:@"%@_classListCheckArray",_fmid];
                [[NSUserDefaults standardUserDefaults]setObject:listCheckArray forKey:mid];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [self.navigationController popViewControllerAnimated:YES];
            }

        }else{
          #if BUREAU_OF_EDUCATION
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先加入部门" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alerV show];
            #else
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先加入班级" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alerV show];
            #endif
            
          
            
            
            
        }

        
    }
    
    
}

// 选择全部
- (IBAction)chooseAllAction:(id)sender {
    
    UIImage *img1 = [UIImage imageNamed:@"choose_d.png"];
    
    if ([Utilities image:_allImgV.image equalsTo:img1]) {
        
        _allImgV.image = [UIImage imageNamed:@"choose_p.png"];
        
        for (int i = 0; i<[listCheckArray count]; i++) {
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[listCheckArray objectAtIndex:i]];
            [dic setObject:@"1" forKey:@"isChecked"];
            [listCheckArray replaceObjectAtIndex:i withObject:dic];
            
        }
        [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
        
    }else{
        
        _allImgV.image = [UIImage imageNamed:@"choose_d.png"];
        
        for (int i = 0; i<[listCheckArray count]; i++) {
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[listCheckArray objectAtIndex:i]];
            [dic setObject:@"0" forKey:@"isChecked"];
            [listCheckArray replaceObjectAtIndex:i withObject:dic];
            
            
        }
        [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
        
    }
    
}
@end
