//
//  WeeklyRecipesViewController.m
//  MicroSchool
//
//  Created by CheungStephen on 3/15/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "WeeklyRecipesViewController.h"

@interface WeeklyRecipesViewController ()

@end

@implementation WeeklyRecipesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setCustomizeLeftButton];
    [super setCustomizeTitle:_titleName];

    _recipesAryHeight = [[NSMutableArray alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStyleGrouped];
    
    _tableView.backgroundColor = [[UIColor alloc] initWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    // 隐藏tableview分割线
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view addSubview:_tableView];

    [Utilities showProcessingHud:self.view];
    [self doGetWeeklyRecipes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)doGetWeeklyRecipes {
    /**
     * 一周菜谱
     * @author luke
     * @date 2016.03.14
     * @args
     *  v=3 ac=Kindergarten op=recipes sid= cid= uid= app=
     */
    
    NSString *op = @"recipes";
    NSString *app = [Utilities getAppVersion];

    NSDictionary *user = [g_userInfo getUserDetailInfo];
    NSString *cid = [user objectForKey:@"role_cid"];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Kindergarten",@"ac",
                          @"3",@"v",
                          op, @"op",
                          cid, @"cid",
                          app,@"app",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            _recipesAry = [NSMutableArray arrayWithArray:[respDic objectForKey:@"message"]];
            
            if (0 == [_recipesAry count]) {
                NSString *name = @"BlankViewImage/幼标@3_11.png";
                NSString *title = @"木有粗面，木有鱼丸";
                
                CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44);
                _noDataView = [Utilities showNodataView:title msg2:nil andRect:rect imgName:name];
                
                [_tableView addSubview:_noDataView];
            }else{
                [_noDataView removeFromSuperview];
            }

            [self calculateCellHeight];
            [_tableView reloadData];
        } else {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                               message:@"获取信息错误，请稍候再试"
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
                [alert show];
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
    }];
}

- (void)calculateCellHeight {
    for (int i=0; i<[_recipesAry count]; i++) {
        NSMutableArray *dayRecipesAry = [NSMutableArray arrayWithArray:[[_recipesAry objectAtIndex:i] objectForKey:@"list"]];
        
        float h = 0;
        for (int j=0; j<[dayRecipesAry count]; j++) {
            NSMutableDictionary *dayRecipesDic = [NSMutableDictionary dictionaryWithDictionary:[dayRecipesAry objectAtIndex:j]];
            NSString *title = [dayRecipesDic objectForKey:@"title"];
            NSString *content = [dayRecipesDic objectForKey:@"content"];
            
            UILabel *_title1Label = [UILabel new];
            _title1Label = [UILabel new];
            _title1Label.font = [UIFont systemFontOfSize:14.0f];
            _title1Label.lineBreakMode = NSLineBreakByTruncatingTail;
            _title1Label.textAlignment = NSTextAlignmentLeft;
            _title1Label.textColor = [[UIColor alloc] initWithRed:54/255.0f green:102/255.0f blue:160/255.0f alpha:1.0];
            _title1Label.text = title;
            CGSize msgSizeTitle = [_title1Label sizeThatFits:(CGSizeMake([Utilities getScreenSizeWithoutBar].width-10-10-17-10, 0))];
            msgSizeTitle.height += [Utilities convertPixsH:10];
            
            UILabel *_content1Label = [UILabel new];
            _content1Label.font = [UIFont systemFontOfSize:14.0f];
            _content1Label.lineBreakMode = NSLineBreakByWordWrapping;
            _content1Label.numberOfLines = 0;
            _content1Label.textAlignment = NSTextAlignmentLeft;
            _content1Label.textColor = [[UIColor alloc] initWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
            _content1Label.text = content;
            CGSize msgSizeContent = [_content1Label sizeThatFits:(CGSizeMake([Utilities getScreenSizeWithoutBar].width-10-10-17-10, 0))];
            msgSizeContent.height += [Utilities convertPixsH:18];

            h = msgSizeTitle.height + msgSizeContent.height + h;
        }
        
        h += [Utilities convertPixsH:46];
        [_recipesAryHeight addObject:[NSString stringWithFormat:@"%f", h]];

    }
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_recipesAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == ([_recipesAry count]-1)) {
        return 10;
    }else {
        return 1;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[_recipesAryHeight objectAtIndex:[indexPath section]] integerValue];
    
//    WeeklyRecipesTableViewCell *cell = (WeeklyRecipesTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//    
//    CGSize a = cell.title1Label.frame.size;
//    
//    return a.height;
////
//    CGSize a = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    
//    return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    
    NSUInteger section = [indexPath section];
    NSMutableDictionary *recipesDic = [NSMutableDictionary dictionaryWithDictionary:[_recipesAry objectAtIndex:section]];
    
    WeeklyRecipesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    if (cell == nil) {
        cell = [[WeeklyRecipesTableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:CellTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.dateLabel.text = [[recipesDic objectForKey:@"profile"] objectForKey:@"date"];
    
    NSMutableArray *recipesAry = [NSMutableArray arrayWithArray:[recipesDic objectForKey:@"list"]];
    
    for (int i=0; i<[recipesAry count]; i++) {
        NSDictionary *recipesDic = [recipesAry objectAtIndex:i];
        NSString *type = [recipesDic objectForKey:@"type"];
        
        if (0 == i) {
            cell.icon1ImageView.hidden = NO;
            cell.icon2ImageView.hidden = YES;
            cell.icon3ImageView.hidden = YES;
            cell.icon4ImageView.hidden = YES;
            cell.icon5ImageView.hidden = YES;

            cell.title1Label.hidden = NO;
            cell.title2Label.hidden = YES;
            cell.title3Label.hidden = YES;
            cell.title4Label.hidden = YES;
            cell.title5Label.hidden = YES;

            cell.content1Label.hidden = NO;
            cell.content2Label.hidden = YES;
            cell.content3Label.hidden = YES;
            cell.content4Label.hidden = YES;
            cell.content5Label.hidden = YES;

            [cell.icon1ImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"SchoolHomePics/schoolHomeRepicesIcon%@", type]]];
            cell.title1Label.text = [recipesDic objectForKey:@"title"];
            cell.content1Label.text = [recipesDic objectForKey:@"content"];
        }else if (1 == i) {
            cell.icon2ImageView.hidden = NO;
            cell.icon3ImageView.hidden = YES;
            cell.icon4ImageView.hidden = YES;
            cell.icon5ImageView.hidden = YES;

            cell.title2Label.hidden = NO;
            cell.title3Label.hidden = YES;
            cell.title4Label.hidden = YES;
            cell.title5Label.hidden = YES;
            cell.title5Label.hidden = YES;

            cell.content2Label.hidden = NO;
            cell.content3Label.hidden = YES;
            cell.content4Label.hidden = YES;
            cell.content5Label.hidden = YES;

            [cell.icon2ImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"SchoolHomePics/schoolHomeRepicesIcon%@", type]]];
            cell.title2Label.text = [recipesDic objectForKey:@"title"];
            cell.content2Label.text = [recipesDic objectForKey:@"content"];
        }else if (2 == i) {
            cell.icon3ImageView.hidden = NO;
            cell.icon4ImageView.hidden = YES;
            cell.icon5ImageView.hidden = YES;

            cell.title3Label.hidden = NO;
            cell.title4Label.hidden = YES;
            cell.title5Label.hidden = YES;

            cell.content3Label.hidden = NO;
            cell.content4Label.hidden = YES;
            cell.content5Label.hidden = YES;

            [cell.icon3ImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"SchoolHomePics/schoolHomeRepicesIcon%@", type]]];
            cell.title3Label.text = [recipesDic objectForKey:@"title"];
            cell.content3Label.text = [recipesDic objectForKey:@"content"];
        }else if (3 == i) {
            cell.icon4ImageView.hidden = NO;
            cell.icon5ImageView.hidden = YES;

            cell.title4Label.hidden = NO;
            cell.title5Label.hidden = YES;

            cell.content4Label.hidden = NO;
            cell.content5Label.hidden = YES;

            [cell.icon4ImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"SchoolHomePics/schoolHomeRepicesIcon%@", type]]];
            cell.title4Label.text = [recipesDic objectForKey:@"title"];
            cell.content4Label.text = [recipesDic objectForKey:@"content"];
        }else if (4 == i) {
            cell.icon5ImageView.hidden = NO;
            
            cell.title5Label.hidden = NO;
            
            cell.content5Label.hidden = NO;
            
            [cell.icon5ImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"SchoolHomePics/schoolHomeRepicesIcon%@", type]]];
            cell.title5Label.text = [recipesDic objectForKey:@"title"];
            cell.content5Label.text = [recipesDic objectForKey:@"content"];
        }
    }

    return cell;
}

- (void)aaa:(NSDictionary *)dic {
    
    WeeklyRecipesTableViewCell *cell = [dic objectForKey:@"cell"];
    [cell updateCellConstraints];
    
    [_tableView reloadData];
}

//选中Cell响应事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    NSDictionary* list_dic = [_recipesAry objectAtIndex:[indexPath row]];
    
    
    
}

@end
