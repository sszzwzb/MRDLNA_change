//
//  ManagePhotoViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 16/4/11.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "ManagePhotoViewController.h"
#import "ManageCollectionViewCell.h"
#import "ChoosePhotoAlbumViewController.h"

static NSString *cellIdentifier = @"ManageCollectionViewCell";
static NSString *kCollectionViewHeaderIdentifier = @"ManageHeader";

@interface ManagePhotoViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation ManagePhotoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@"管理照片"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeMoveAid:)
                                                 name:@"changeMoveAid"
                                               object:nil];
    
    [self doShowContent];
    
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.allowsMultipleSelection = YES;//支持多选
    
    UINib *nib = [UINib nibWithNibName:@"ManageCollectionViewCell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];
    
    UINib *headerNib = [UINib nibWithNibName:NSStringFromClass([ManageHeaderReusableView class])  bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:headerNib  forSupplementaryViewOfKind :UICollectionElementKindSectionHeader  withReuseIdentifier: kCollectionViewHeaderIdentifier ];  
    
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    [_collectionView addSubview:_refreshHeaderView];
    
    
    checkListArray = [[NSMutableArray alloc] init];
    checkSectionArray = [[NSMutableArray alloc] init];
   
    [Utilities showProcessingHud:self.view];
    [self getData:@"0"];
    startNum = @"0";
    reflashFlag = 1;
    isReflashViewType = 1;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doShowContent{

    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    
    bottomV = [UIView new];
    bottomV.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    [self.view addSubview:bottomV];
    
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(_collectionView.mas_bottom).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width,50.0));
        
    }];
    
    
    moveBtn = [UIButton new];
    moveBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [moveBtn setTitle:@"移动" forState:UIControlStateNormal];
    [moveBtn setTitleColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1] forState:UIControlStateNormal];
    [moveBtn addTarget:self action:@selector(moveAction:) forControlEvents:UIControlEventTouchUpInside];
    moveBtn.userInteractionEnabled = NO;
    [bottomV addSubview:moveBtn];
    [moveBtn mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(bottomV).with.offset(0);
        make.left.equalTo(bottomV).with.offset(0);
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width/2.0-0.5,50.0));
        
    }];
    
    deleteBtn = [UIButton new];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deletePhoto) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.userInteractionEnabled = NO;
    [bottomV addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(bottomV).with.offset(0);
        make.right.equalTo(bottomV).with.offset(0);
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width/2.0-0.5,50.0));
        
    }];
    
    UIView *lineV = [UIView new];
    lineV.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0  blue:220.0/255.0  alpha:1];
    [bottomV addSubview:lineV];
    
    [lineV mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(bottomV).with.offset(0);
        make.left.equalTo(bottomV).with.offset([UIScreen mainScreen].bounds.size.width/2.0-0.5);
        make.size.mas_equalTo(CGSizeMake(1,50.0));
        
    }];
    
    UIView *topLineV = [UIView new];
    topLineV.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0  blue:220.0/255.0  alpha:1];
    [bottomV addSubview:topLineV];
    
    [topLineV mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(bottomV).with.offset(0);
        make.left.equalTo(bottomV).with.offset(0);
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width,1));
        
    }];
    
    
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getData:(NSString*)index{
    
    /**
     * 班级相册详情
     * @author luke
     * @date 2016.03.14
     * @args
     *  v=3 ac=Kindergarten op=classAlbum sid= cid= uid= aid=相册ID app= page= size=
     */
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Kindergarten",@"ac",
                          @"3",@"v",
                          @"classAlbum", @"op",
                          _cid,@"cid",
                          _aid,@"aid",
                          [self getCheckPids],@"selected",
                          index,@"page",
                          @"40",@"size",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            NSLog(@"班级相册详情返回:%@",respDic);
            _collectionView.hidden = NO;
            
            NSArray *array = [[[respDic objectForKey:@"message"] objectForKey:@"data"] objectForKey:@"list"];
            //hasNext = [[[[respDic objectForKey:@"message"] objectForKey:@"data"] objectForKey:@"hasNext"] boolValue];
            
            if ([array count] > 0) {
                
                [noDataView removeFromSuperview];
                //上拉加载更多
                if ([startNum intValue] > 0) {
                    
                    for (int i=0; i<[array count]; i++) {
                        
                        [dataArray addObject:[array objectAtIndex:i]];
                        
                        NSMutableArray *subArray = [[NSMutableArray alloc] init];
                        
                        for (int j=0; j<[(NSArray*)[[array objectAtIndex:i] objectForKey:@"list"] count]; j++){
                            
                            NSString *pid = [[[[array objectAtIndex:i] objectForKey:@"list"] objectAtIndex:j] objectForKey:@"id"];
                            
                            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"isChecked",pid,@"pid",@"0", @"nail",nil];
                            
                            [subArray addObject:dic];
                            
                        }
                        
                        [checkListArray addObject:subArray];
                        
                        NSDictionary *checkSectionDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"isChecked", @"0", @"nail", nil];
                        [checkSectionArray addObject:checkSectionDic];
                        
                    }
                    
                }else{
                    
                    //下拉刷新
                    dataArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                    // 构造多选数组
                    
                    if ([checkListArray count] > 0) {
                        
                        [checkListArray removeAllObjects];
                        [checkSectionArray removeAllObjects];
                        
                        for (int i = 0; i< [dataArray count]; i++) {
                            
                            NSMutableArray *subArray = [[NSMutableArray alloc] init];
                            
                            int sectionCount = 0;
                            
                            for (int j=0; j<[(NSArray*)[[dataArray objectAtIndex:i] objectForKey:@"list"] count]; j++){
                                
                                NSString *pid = [[[[dataArray objectAtIndex:i] objectForKey:@"list"] objectAtIndex:j] objectForKey:@"id"];
                                
                                NSString *isChecked = [[[[dataArray objectAtIndex:i] objectForKey:@"list"] objectAtIndex:j] objectForKey:@"selected"];
                                
                                if ([isChecked integerValue] == 1) {
                                    
                                    sectionCount ++;
                                    
                                }
                                
                                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:isChecked,@"isChecked",pid,@"pid",@"0", @"nail",nil];
                                    
                                [subArray addObject:dic];
                                    
                            
                            }
                            
                            [checkListArray addObject:subArray];
                            
                            NSDictionary *checkSectionDic;
                            
                            if (sectionCount == [subArray count]) {
                                
                                checkSectionDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1",@"isChecked", @"0", @"nail", nil];
                                
                            }else{
                                
                                checkSectionDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"isChecked", @"0", @"nail", nil];
                            }
                            
                            [checkSectionArray addObject:checkSectionDic];
                            
                        }
                        
                        NSLog(@"checkListArray:%@",checkListArray);
                        
                    }else{
                    
                        for (int i = 0; i< [dataArray count]; i++) {
                            
                            NSMutableArray *subArray = [[NSMutableArray alloc] init];
                            
                            for (int j=0; j<[(NSArray*)[[dataArray objectAtIndex:i] objectForKey:@"list"] count]; j++){
                                
                                NSString *pid = [[[[dataArray objectAtIndex:i] objectForKey:@"list"] objectAtIndex:j] objectForKey:@"id"];
                                
                                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"isChecked",pid,@"pid",@"0", @"nail",nil];
                                
                                [subArray addObject:dic];
                                
                            }
                            
                            [checkListArray addObject:subArray];
                            
                            NSDictionary *checkSectionDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"isChecked", @"0", @"nail", nil];
                            [checkSectionArray addObject:checkSectionDic];
                            
                        }
                        
                    }
                   
                }
                
                //NSLog(@"checkListArray:%@",checkListArray);
                
                
            }else{
                
                if([startNum intValue] == 0){
                    
                    dataArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                    
                    //imagev.hidden = YES;
                    
                    [noDataView removeFromSuperview];
                    
                    bottomV.hidden = YES;
                    
                    CGRect rect = CGRectMake(0, 64.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64.0);
                    
                    noDataView = [Utilities showNodataView:@"无图无真相 TOT" msg2:@"" andRect:rect imgName:@"noPhotoBg.png"];
                    
                    [self.view addSubview:noDataView];
                    
                }
                
            }
            
            if (![[self getCheckPids] isEqualToString:@""]) {//有选中的
                
                [moveBtn setTitleColor:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1] forState:UIControlStateNormal];
                [deleteBtn setTitleColor:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1] forState:UIControlStateNormal];
                moveBtn.userInteractionEnabled = YES;
                deleteBtn.userInteractionEnabled = YES;
                
            }else{//没选中的
                
                [moveBtn setTitleColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1] forState:UIControlStateNormal];
                [deleteBtn setTitleColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1] forState:UIControlStateNormal];
                moveBtn.userInteractionEnabled = NO;
                deleteBtn.userInteractionEnabled = NO;
            }
            
            
        }else{
            
            [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
            
        }
        
        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
        [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        
    }];
    
    
}

-(void)reload{
    
    [_collectionView reloadData];
}

//删除选中图片
-(void)deletePhoto{
    
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确认删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertV show];
    
}

-(void)deletePhotoFromServer{
    
    /**
     * 班级相册删除图片们
     * @author luke
     * @date 2016.04.05
     * @args
     *  v=3 ac=Kindergarten op=delClassAlbumPictures sid= cid= uid= app= aid=相册ID pids=图片们ID
     */
    
    [Utilities showProcessingHud:self.view];
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Kindergarten",@"ac",
                          @"3",@"v",
                          @"delClassAlbumPictures", @"op",
                          _cid,@"cid",
                          _aid,@"aid",
                          [self getCheckPids],@"pids",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            NSLog(@"班级相册删除图片:%@",respDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadPhotoCollectionDetail" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadPhotoCollection" object:nil];
            
            [Utilities showSuccessedHud:[NSString stringWithFormat:@"%@",[respDic objectForKey:@"message"]] descView:self.view];
            startNum = @"0";
            [checkListArray removeAllObjects];
            [checkSectionArray removeAllObjects];
            [self getData:@"0"];
            
        }else{
            
            [Utilities showFailedHud:[NSString stringWithFormat:@"%@",[respDic objectForKey:@"message"]] descView:self.view];
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        
    }];
    
}

//选择后的相册id
-(void)changeMoveAid:(NSNotification*)notify{
    
    moveAid = (NSString*)[notify object];
    
    /**
     * 班级相册移动照片
     * @author luke
     * @date 2016.04.11
     * @args
     *  v=3 ac=Kindergarten op=moveClassAlbumPictures sid= cid= uid= app= aid=新相册ID pics=移动的图片ids
     */
    
    [Utilities showProcessingHud:self.view];
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Kindergarten",@"ac",
                          @"3",@"v",
                          @"moveClassAlbumPictures", @"op",
                          _cid,@"cid",
                          moveAid,@"aid",
                          [self getCheckPids],@"pics",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            NSLog(@"班级相册移动图片:%@",respDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadPhotoCollectionDetail" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadPhotoCollection" object:nil];
            
            [Utilities showSuccessedHud:[NSString stringWithFormat:@"%@",[respDic objectForKey:@"message"]] descView:self.view];
            startNum = @"0";
            [checkListArray removeAllObjects];
            [checkSectionArray removeAllObjects];
            [self getData:@"0"];
            
            
        }else{
            
             [Utilities showFailedHud:[NSString stringWithFormat:@"%@",[respDic objectForKey:@"message"]] descView:self.view];
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        
    }];
    
}

//去相册列表
-(void)moveAction:(id)sender{
    
    
    ChoosePhotoAlbumViewController *ccvc = [[ChoosePhotoAlbumViewController alloc] init];
    ccvc.cid = _cid;
    ccvc.fromName = @"managePhoto";
    ccvc.aid = _aid;
    [self.navigationController pushViewController:ccvc animated:YES];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0){
    
    if(buttonIndex == 1){
        
        [self deletePhotoFromServer];
        
    }
}

//获取选中的pid,组合成以逗号分割的字符串
-(NSString*)getCheckPids{
    
    NSString *pids = @"";
    
    for (int i=0; i<[checkListArray count]; i++ ) {
        
        NSMutableArray *list = [checkListArray objectAtIndex:i];
        
        for (int j =0; j<[list count]; j++) {
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[list objectAtIndex:j]];
            NSString *isChecked = [dic objectForKey:@"isChecked"];
            
            if ([isChecked integerValue] == 1) {
                
                NSString *item = [dic objectForKey:@"pid"];
                if ([pids length] == 0) {
                    pids = item;
                }else{
                    pids = [NSString stringWithFormat:@"%@,%@",pids,item];
                }
               
            }
        }
        
    }
    
    return pids;
    
}

#pragma mark - Collection View Data Source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [(NSArray*)[[dataArray objectAtIndex:section] objectForKey:@"list"] count];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return dataArray.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ManageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    //NSLog(@"section %d:row %d",indexPath.section,indexPath.row);
    
    NSArray *rowArray = [[dataArray objectAtIndex:indexPath.section] objectForKey:@"list"];
    
    //NSLog(@"rowArray:%@",rowArray);
    
    NSString *urlStr = [[rowArray objectAtIndex:indexPath.row] objectForKey:@"thumb"];
    
    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    
    
    NSString *nail = [[[checkListArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"nail"];
    
    if ([nail integerValue] == 1) {
        
       
    }else{
        
        NSString *isCheck = [[[checkListArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"isChecked"];
        
        if ([isCheck integerValue] == 1) {
            
            cell.checkImg.hidden = NO;//这里如果写成直接调用cell.selected = YES;那么取消选择点击事件不走
            
        }else{
            
            cell.checkImg.hidden = YES;
            
        }
        
    }
    
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        ManageHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ManageHeader" forIndexPath:indexPath];
        
        headerView.indexPath = indexPath;
        
        headerView.delegate = self;
        
        NSString *title = [[dataArray objectAtIndex:indexPath.section] objectForKey:@"dateline"];
        
        headerView.titleLabel.text = title;
        
        if ([[[checkSectionArray objectAtIndex:indexPath.section] objectForKey:@"isChecked"] integerValue] == 1) {
            
            [headerView.checkForHeaderBtn setImage:[UIImage imageNamed:@"selectP.png"] forState:UIControlStateNormal];
            [headerView.checkForHeaderBtn setImage:[UIImage imageNamed:@"selectP.png"] forState:UIControlStateHighlighted];
            
        }else{
            
            [headerView.checkForHeaderBtn setImage:[UIImage imageNamed:@"unSelectBig.png"] forState:UIControlStateNormal];
            [headerView.checkForHeaderBtn setImage:[UIImage imageNamed:@"unSelectBig.png"] forState:UIControlStateHighlighted];
            
        }
        reusableview = headerView;
        
    }else if (kind == UICollectionElementKindSectionFooter){
        
        reusableview = nil;
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 50.0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *rowArray = [[dataArray objectAtIndex:indexPath.section] objectForKey:@"list"];
    NSString *pid = [NSString stringWithFormat:@"%@",[[rowArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
    
    NSMutableDictionary *dic;
    
    NSString *isCheck = [[[checkListArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"isChecked"];
    
    if ([isCheck integerValue] ==1){
        
        dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"isChecked",pid,@"pid",@"0", @"nail",nil];
        
    }else{
       
        dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1",@"isChecked",pid,@"pid",@"0", @"nail",nil];

    }
    
    [[checkListArray objectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row withObject:dic];
    
    //---section选中情况-------------------------------------------------------------------------------------------
    int sectionCount = 0;
    NSMutableArray *list = [checkListArray objectAtIndex:indexPath.section];
    for (int j =0; j<[list count]; j++) {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[list objectAtIndex:j]];
        NSString *isChecked = [dic objectForKey:@"isChecked"];
        
        if ([isChecked integerValue] == 1) {
            
            sectionCount ++;
            
        }
    }
    
    //NSLog(@"sectionCount=%d,listCount=%lu",sectionCount,(unsigned long)[list count]);
    
    if (sectionCount == [list count]) {
        
        [checkSectionArray replaceObjectAtIndex:indexPath.section withObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1",@"isChecked", @"0", @"nail", nil]];
        
        
       
    }else{
        
        [checkSectionArray replaceObjectAtIndex:indexPath.section withObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"isChecked", @"0", @"nail", nil]];
      
        
    }
    
    if (![[self getCheckPids] isEqualToString:@""]) {//有选中的
        
        [moveBtn setTitleColor:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1] forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1] forState:UIControlStateNormal];
        moveBtn.userInteractionEnabled = YES;
        deleteBtn.userInteractionEnabled = YES;
        
    }else{//没选中的
        
         [moveBtn setTitleColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1] forState:UIControlStateNormal];
         [deleteBtn setTitleColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1] forState:UIControlStateNormal];
         moveBtn.userInteractionEnabled = NO;
         deleteBtn.userInteractionEnabled = NO;
    }
    
     [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
   
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didDeselectItemAtIndexPath");
    
    NSArray *rowArray = [[dataArray objectAtIndex:indexPath.section] objectForKey:@"list"];
    NSString *pid = [NSString stringWithFormat:@"%@",[[rowArray objectAtIndex:indexPath.row] objectForKey:@"id"]];

    NSMutableDictionary *dic;

    NSString *isCheck = [[[checkListArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"isChecked"];
    
    if ([isCheck integerValue] ==1){
        
        dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"isChecked",pid,@"pid",@"0", @"nail",nil];
        
    }else{
        
        dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1",@"isChecked",pid,@"pid",@"0", @"nail",nil];
        
    }
    
    [[checkListArray objectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row withObject:dic];
    
    
    int sectionCount = 0;
    NSMutableArray *list = [checkListArray objectAtIndex:indexPath.section];
    for (int j =0; j<[list count]; j++) {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[list objectAtIndex:j]];
        NSString *isChecked = [dic objectForKey:@"isChecked"];
        
        if ([isChecked integerValue] == 1) {
            
            sectionCount ++;
            
        }
    }
    
    if (sectionCount == [list count]) {
        
        [checkSectionArray replaceObjectAtIndex:indexPath.section withObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1",@"isChecked", @"0", @"nail", nil]];
        
        
    }else{
        
        [checkSectionArray replaceObjectAtIndex:indexPath.section withObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"isChecked", @"0", @"nail", nil]];
      
    }
    
    if (![[self getCheckPids] isEqualToString:@""]) {//有选中的
        
        [moveBtn setTitleColor:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1] forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1] forState:UIControlStateNormal];
        moveBtn.userInteractionEnabled = YES;
        deleteBtn.userInteractionEnabled = YES;
        
    }else{//没选中的
        
        [moveBtn setTitleColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1] forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1] forState:UIControlStateNormal];
        moveBtn.userInteractionEnabled = NO;
        deleteBtn.userInteractionEnabled = NO;
    }
    
    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
    
    
}

// header组全选回调
-(void)clickSection:(NSIndexPath*)indexPath{
    
    if ([[[checkSectionArray objectAtIndex:indexPath.section] objectForKey:@"isChecked"] integerValue] == 0) {// 选中
        NSMutableArray *list = [checkListArray objectAtIndex:indexPath.section];
        
        for (int j =0; j<[list count]; j++) {
            
            NSString *nail = [[list objectAtIndex:j] objectForKey:@"nail"];
            
            if (![@"1"  isEqual: nail]) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[list objectAtIndex:j]];
                [dic setObject:@"1" forKey:@"isChecked"];
                
                [list replaceObjectAtIndex:j withObject:dic];
            }else {
                
            }
            
        }
        
        [checkListArray replaceObjectAtIndex:indexPath.section withObject:list];
        [checkSectionArray replaceObjectAtIndex:indexPath.section withObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1",@"isChecked", @"0", @"nail", nil]];
    
    }else{// 取消选中
        
        NSMutableArray *list = [checkListArray objectAtIndex:indexPath.section];
        
        for (int j =0; j<[list count]; j++) {
            
            NSString *nail = [[list objectAtIndex:j] objectForKey:@"nail"];
            
            if (![@"1"  isEqual: nail]) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[list objectAtIndex:j]];
                [dic setObject:@"0" forKey:@"isChecked"];
                
                [list replaceObjectAtIndex:j withObject:dic];
            }else {
                
            }
            
        }
        
        [checkListArray replaceObjectAtIndex:indexPath.section withObject:list];
        [checkSectionArray replaceObjectAtIndex:indexPath.section withObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"isChecked", @"0", @"nail", nil]];
        
    }
    
    if (![[self getCheckPids] isEqualToString:@""]) {//有选中的
        
        [moveBtn setTitleColor:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1] forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1] forState:UIControlStateNormal];
        moveBtn.userInteractionEnabled = YES;
        deleteBtn.userInteractionEnabled = YES;
        
    }else{//没选中的
        
        [moveBtn setTitleColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1] forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1] forState:UIControlStateNormal];
        moveBtn.userInteractionEnabled = NO;
        deleteBtn.userInteractionEnabled = NO;
    }
    
    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
    
}



-(void)refreshView
{
    isReflashViewType = 1;
    
    if (reflashFlag == 1) {
        NSLog(@"刷新完成");
        startNum = @"0";
        [self getData:startNum];
        
    }
}

//加载调用的方法
-(void)getNextPageView
{
    isReflashViewType = 0;
    
    if (reflashFlag == 1) {
        
        NSLog(@"dataArray:%@",dataArray);
        
        NSInteger count;
        
        for (int i=0; i<[dataArray count]; i++) {
            
            if (i == 0) {
                
                NSDictionary *dic = [dataArray objectAtIndex:0];
                count = [(NSArray*)[dic objectForKey:@"list"] count];
                
            }else{
                
                NSDictionary *dic = [dataArray objectAtIndex:i];
                count = count + [(NSArray*)[dic objectForKey:@"list"] count];
                
            }
            
        }
        
        startNum = [NSString stringWithFormat:@"%lu",(unsigned long)count];
        [self getData:startNum];
        
    }
    
}

-(void)testFinishedLoadData{
    
    [self finishReloadingData];
    [self setFooterView];
    
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
    
    //  model should call this when its done loading
    _reloading = NO;
    
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_collectionView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_collectionView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
    //    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    
    CGFloat height = MAX(self->_collectionView.bounds.size.height, self->_collectionView.contentSize.height);
    //CGFloat height = MAX(self->_tableView.contentSize.height, self->_tableView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview])
    {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self->_collectionView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
    {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.view.frame.size.width, self->_collectionView.bounds.size.height)];
        //self->_tableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [_collectionView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView)
    {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
    
    //  should be calling your tableviews data source model to reload
    _reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader)
    {
        // pull down to refresh data
        //[self refreshView];
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.1];
    }else if(aRefreshPos == EGORefreshFooter)
    {
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:0.005];
    }
    
    // overide, the actual loading data operation is done in the subclass
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_reloading == NO) {
        if (_refreshHeaderView)
        {
            [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
            
        }
        
        if (_refreshFooterView)
        {
            [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_reloading == NO) {
        if (_refreshHeaderView)
        {
            [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
        }
        
        if (_refreshFooterView)
        {
            [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
        }
    }
}

#pragma mark -
#pragma mark EGORefreshTableDelegate Methods
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    if (_reloading == NO) {
        [self beginToReloadData:aRefreshPos];
    }
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
    return _reloading; // should return if data source model is reloading
}

// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
    return [NSDate date]; // should return date data source was last changed
}

@end
