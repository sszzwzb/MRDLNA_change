//
//  PhotoCollectionDetailViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 16/4/6.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "PhotoCollectionDetailViewController.h"
#import "PublishMomentsViewController.h"
#import "PhotoCollectionEditViewController.h"
#import "PhotoCollDetailCollectionViewCell.h"
#import "RecipeCollectionHeaderView.h"
#import "FullImageViewController.h"
#import "ManagePhotoViewController.h"
#import "ManagePhotoViewController.h"

static NSString *cellIdentifier = @"PhotoCollDetailCollectionViewCell";
static NSString *kCollectionViewHeaderIdentifier = @"HeaderView";
static NSString *CHeaderIdentifier = @"HHeaderView";

@interface PhotoCollectionDetailViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation PhotoCollectionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshView)
                                                 name:@"reLoadPhotoCollectionDetail"
                                               object:nil];
    
    loading = 0;
   
    _collectionView.alwaysBounceVertical = YES;
    /*
    _collectionView.contentInset = UIEdgeInsetsMake(250.0, 0, 0, 0);
    
    imagev = [[UIImageView alloc]init];//封面
    imagev.frame = CGRectMake(0, -250, 320, 250.0);
    imagev.frame = CGRectMake(0, 0, 320, 250.0);
    imagev.userInteractionEnabled = YES;
    
    titleLab = [UILabel new];
    titleLab.font = [UIFont boldSystemFontOfSize:20.0];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [imagev addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        // y与_textFieldHeight的y相同
        make.top.equalTo(imagev).with.offset((250-21)/2.0);
        
        make.left.equalTo(imagev).with.offset(0);
       
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 21.0));
    }];
    
    maskImgV = [UIImageView new];
    maskImgV.image = [UIImage imageNamed:@"photoDetailMask.png"];
    [imagev addSubview:maskImgV];
    
    [maskImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        // y与_textFieldHeight的y相同
        make.top.equalTo(imagev).with.offset(0);
        
        // x距离_labelHeight右边最长处5
        make.left.equalTo(imagev).with.offset(0);
       
        make.size.mas_equalTo(imagev.frame.size);
    }];
    
    
    [_collectionView addSubview: imagev];*/
    
   //---------------------------------------------------
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-20.0)/2.0, 25.0, 20.0f, 20.0f);

    //------导航条----------------------------------------------------------------------------------------
    CGRect frame = self.navigationController.navigationBar.frame;
    _alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height+20)];
   
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height+20)];
    [imgV setImage:[UIImage imageNamed:@"bg_img.png"]];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               0,
                                                               32,
                                                               WIDTH,
                                                               20)];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    
    title.font = [UIFont boldSystemFontOfSize:17.0];
    title.text = _photoAlbumTitle;
    
    [_alphaView addSubview:imgV];
    [_alphaView addSubview:title];
    
    _alphaView.alpha = 0.0;
    
    [self.view insertSubview:_alphaView belowSubview:self.navigationController.navigationBar];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"CommonIconsAndPics/bigShadow.png"] forBarMetrics:UIBarMetricsCompact];
   
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    leftButton.frame = CGRectMake(0, 25, 33, 33);
    [leftButton setImage:[UIImage imageNamed:@"leftBarButtonItem"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"leftBarButtonItem"] forState:UIControlStateSelected];
    [leftButton addTarget:self action:@selector(selectLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    rightButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 33.0, 25, 33, 33);
    [rightButton setImage:[UIImage imageNamed:@"icon_more.png"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"icon_more.png"] forState:UIControlStateSelected];
    [rightButton addTarget:self action:@selector(selectRightAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_alphaView addSubview:leftButton];
    [_alphaView addSubview:rightButton];
    
    
    //---图片上的返回按钮----
    leftButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton1.tag = 111;
    [leftButton1 setBackgroundColor:[UIColor clearColor]];
    leftButton1.frame = CGRectMake(0, 25, 33, 33);
    [leftButton1 setImage:[UIImage imageNamed:@"leftBarButtonItem"] forState:UIControlStateNormal];
    [leftButton1 setImage:[UIImage imageNamed:@"leftBarButtonItem"] forState:UIControlStateSelected];
    [leftButton1 addTarget:self action:@selector(selectLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    
    rightButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton1.tag = 112;
    [rightButton1 setBackgroundColor:[UIColor clearColor]];
    rightButton1.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 33.0, 25, 33, 33);
    [rightButton1 setImage:[UIImage imageNamed:@"icon_more.png"] forState:UIControlStateNormal];
    [rightButton1 setImage:[UIImage imageNamed:@"icon_more.png"] forState:UIControlStateSelected];
    [rightButton1 addTarget:self action:@selector(selectRightAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //---------------------------------------------------------------------------------------------------
    
    UINib *nib = [UINib nibWithNibName:@"PhotoCollDetailCollectionViewCell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];
    
    UINib *headerNib = [UINib nibWithNibName:NSStringFromClass([RecipeCollectionHeaderView class])  bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:headerNib  forSupplementaryViewOfKind :UICollectionElementKindSectionHeader  withReuseIdentifier: kCollectionViewHeaderIdentifier ];  //注册加载头
    
    UINib *hheaderNib = [UINib nibWithNibName:NSStringFromClass([CollectionHeaderReusableView class])  bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:hheaderNib  forSupplementaryViewOfKind :UICollectionElementKindSectionHeader  withReuseIdentifier:CHeaderIdentifier ];  //注册加载头

    
    tagArray = [[NSMutableArray alloc] initWithObjects:@"添加照片",@"管理照片",@"编辑相册", nil];
    
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

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectRightAction:(id)sender{
    
    if (!isRightButtonClicked) {
        
        if (_alphaView.alpha == 0.0) {
            
            viewMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].bounds.size.height)];
            
        }else{
            
            viewMask = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, [UIScreen mainScreen].bounds.size.height)];

            
        }
        
        
        imageView_bgMask =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].bounds.size.height)];
        [imageView_bgMask setBackgroundColor:[[UIColor alloc] initWithRed:93/255.0f green:106/255.0f blue:122/255.0f alpha:0.4]];
        imageView_bgMask.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
        [imageView_bgMask addGestureRecognizer:singleTouch];
        
        if (_alphaView.alpha == 0.0){
            
            // 选项菜单
            imageView_rightMenu =[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].applicationFrame.size.width - 128 - 10,
                                                                              5+45,
                                                                              128,
                                                                              35.0*[tagArray count]+10)];
            
        }else{
           
            // 选项菜单
            imageView_rightMenu =[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].applicationFrame.size.width - 128 - 10,
                                                                              5,
                                                                              128,
                                                                              35.0*[tagArray count]+10)];
            
        }
       
        imageView_rightMenu.contentMode = UIViewContentModeScaleToFill;
        
        if ([tagArray count] < 2) {
            [imageView_rightMenu setImage:[UIImage imageNamed:@"ClassKin/bg_contacts_one.png"]];
        }else{
            [imageView_rightMenu setImage:[UIImage imageNamed:@"ClassKin/bg_contacts_more.png"]];
        }
        
        
        [imageView_bgMask addSubview:imageView_rightMenu];
        
        for (int i=0; i<[tagArray count]; i++) {
            
            //NSDictionary *tagDic = [tagArray objectAtIndex:i];
            //NSString *tagId = [NSString stringWithFormat:@"%@",[tagDic objectForKey:@"id"]];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 600+i;
            button.frame = CGRectMake(imageView_rightMenu.frame.origin.x,imageView_rightMenu.frame.origin.y+9+35.0*i, 128.0, 35.0);
            [button setTitle:[tagArray objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitle:[tagArray objectAtIndex:i] forState:UIControlStateHighlighted];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:174.0/255.0 green:221.0/255.0 blue:215.0/255.0 alpha:1] forState:UIControlStateHighlighted];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
            
            [button addTarget:self action:@selector(selectTag:) forControlEvents: UIControlEventTouchUpInside];
            
            UIImageView *lineV = [[UIImageView alloc] init];
            lineV.image = [UIImage imageNamed:@"ClassKin/bg_contacts_line.png"];
            lineV.frame = CGRectMake(10, button.frame.size.height-1, button.frame.size.width-20, 1);
            if (i<[tagArray count]-1) {
                [button addSubview:lineV];
            }
            
            [imageView_bgMask addSubview:button];
            
        }
        
        [viewMask addSubview:imageView_bgMask];
        
        [self.view addSubview:viewMask];
        
        isRightButtonClicked = true;
        
        
    }else{
        
        [viewMask removeFromSuperview];
        
        isRightButtonClicked = false;
        
    }
}

-(void)dismissKeyboard:(id)sender{
    
    [viewMask removeFromSuperview];
    isRightButtonClicked = false;
}

// 标签筛选
-(void)selectTag:(id)sender{
    
    UIButton *button = (UIButton*)sender;
    NSInteger i = button.tag - 600;
    
    [self dismissKeyboard:nil];
    
    NSString *name = [tagArray objectAtIndex:i];

    if ([@"添加照片" isEqualToString:name]) {
        
        PublishMomentsViewController *publish = [[PublishMomentsViewController alloc]init];
        publish.flag = 0;
        publish.cid = _cid;
        publish.fromName = @"classPhotoList";
        publish.isFromAlbum = YES;
        publish.photoAlbumID = _aid;
        publish.photoAlbumTitle = _photoAlbumTitle;
        [self.navigationController pushViewController:publish animated:YES];
        
    }else if ([@"管理照片" isEqualToString:name]){
        
        ManagePhotoViewController *mpvc = [ManagePhotoViewController alloc];
        mpvc.cid = _cid;
        mpvc.aid = _aid;
        [self.navigationController pushViewController:mpvc animated:YES];
        
    }else if ([@"编辑相册" isEqualToString:name]){
        
        NSString *urlStr = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[albumDic objectForKey:@"thumb"]]];
        
        PhotoCollectionEditViewController *pcevc = [[PhotoCollectionEditViewController alloc] init];
        pcevc.cid = _cid;
        pcevc.aid = _aid;
        pcevc.albumName = _photoAlbumTitle;
        pcevc.key = urlStr;
        [self.navigationController pushViewController:pcevc animated:YES];
        
        
    }

}

//上传照片
-(void)gotoUploadPhoto{
    
    PublishMomentsViewController *publish = [[PublishMomentsViewController alloc]init];
    publish.flag = 0;
    publish.cid = _cid;
    publish.fromName = @"classPhotoList";
    publish.isFromAlbum = YES;
    publish.photoAlbumID = _aid;
    publish.photoAlbumTitle = _photoAlbumTitle;
    [self.navigationController pushViewController:publish animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

-(void)refreshView
{
    //isReflashViewType = 1;
    //if (reflashFlag == 1) {
        NSLog(@"刷新完成");
        loading = 1;
        startNum = @"0";
        [self getData:startNum];
        reflashFlag = 0;
        
    //}
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
                          index,@"page",
                          @"40",@"size",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        
        if ([activityView isAnimating]) {
            
            loading = 0;
             [activityView stopAnimating];
        }
    
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            NSLog(@"班级相册详情返回:%@",respDic);
            _collectionView.hidden = NO;
            
            albumDic = [[respDic objectForKey:@"message"] objectForKey:@"album"];
            
            NSString *title = [albumDic objectForKey:@"title"];
            _photoAlbumTitle = title;
            
            
            NSString *urlStr = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[albumDic objectForKey:@"thumb"]]];
            
            if ([urlStr length] == 0) {
                //self.navigationController.navigationBarHidden = NO;
                _alphaView.alpha = 1.0;
                
            }else{
                
                _alphaView.alpha = 0.0;
                [noDataView removeFromSuperview];
                
            }
            
            titleLab.text = title;
            //[imagev sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            
            NSArray *array = [[[respDic objectForKey:@"message"] objectForKey:@"data"] objectForKey:@"list"];
            //hasNext = [[[[respDic objectForKey:@"message"] objectForKey:@"data"] objectForKey:@"hasNext"] boolValue];
            
            if ([array count] > 0) {
                
                [uploadImgBtn removeFromSuperview];
                [noDataView removeFromSuperview];
                imagev.hidden = NO;
                
                if ([startNum intValue] > 0) {
                    
                    for (int i=0; i<[array count]; i++) {
                        
                        [dataArray addObject:[array objectAtIndex:i]];
                    }
                    
                }else{
                    
                    dataArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                  
                }
                
                
            }else{

                if([startNum intValue] == 0){
                    
                    //imagev.hidden = YES;
                    
                    dataArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                    
                    [noDataView removeFromSuperview];
                    
                    if ([urlStr length] == 0){
                       
                        CGRect rect = CGRectMake(0, 64.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64.0);
                        
                        noDataView = [Utilities showNodataView:@"无图无真相 TOT" msg2:@"" andRect:rect imgName:@"noPhotoBg.png"];
                        
                    }else{
                        
//                        CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 250.0-64);
//                        noDataView = [Utilities showNodataView:@"无图无真相 TOT" msg2:@"" andRect:rect imgName:@"noPhotoBg.png" textColor:[UIColor grayColor] startY:250.0+64.0];
                        
                        //上传按钮
                        [uploadImgBtn removeFromSuperview];
                        uploadImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        uploadImgBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
                        uploadImgBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-([UIScreen mainScreen].bounds.size.width-30.0))/2.0, 250+50.0, [UIScreen mainScreen].bounds.size.width-30.0, 40.0);
                        [uploadImgBtn setTitle:@"添加照片" forState:UIControlStateNormal];
                        [uploadImgBtn setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal] ;
                        [uploadImgBtn setBackgroundImage:[UIImage imageNamed:@"btn_common_1_p.png"] forState:UIControlStateHighlighted] ;
                        [uploadImgBtn addTarget:self action:@selector(gotoUploadPhoto) forControlEvents:UIControlEventTouchUpInside];
                        [self.view addSubview:uploadImgBtn];
                        
                        
                    }
                    
                   
                    [self.view addSubview:noDataView];
                    
                }
                
            }
          
        }else{
            
            [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
            
        }
        
        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
        [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
    
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        
        _alphaView.alpha = 1.0;
            [Utilities dismissProcessingHud:self.view];
            [Utilities doHandleTSNetworkingErr:error descView:self.view];
            
    }];
    
    
}

-(void)reload{
    
    [_collectionView reloadData];
}


#pragma mark - Collection View Data Source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
       return [(NSArray*)[[dataArray objectAtIndex:section-1] objectForKey:@"list"] count];
    }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    NSString *urlStr = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[albumDic objectForKey:@"thumb"]]];
    
    if ([urlStr length] == 0) {//没有封面
    
        return 0;
        
    }else{
        
         return dataArray.count+1;
    }
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        
        return nil;
        
    }else{
        
        PhotoCollDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        
        //NSLog(@"section %d:row %d",indexPath.section,indexPath.row);
        
        NSArray *rowArray = [[dataArray objectAtIndex:indexPath.section-1] objectForKey:@"list"];
        
        //NSLog(@"rowArray:%@",rowArray);
        
        NSString *urlStr = [[rowArray objectAtIndex:indexPath.row] objectForKey:@"thumb"];
        
        [cell.imgV sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
        
        return cell;
        
    }
    
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        if (indexPath.section == 0) {
            
            hheaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HHeaderView" forIndexPath:indexPath];
            
            if (![hheaderView viewWithTag:111]) {
                [hheaderView addSubview:leftButton1];
                if ([Utilities getUserType]!= UserType_Student && [Utilities getUserType]!= UserType_Parent) {
                    [hheaderView addSubview:rightButton1];
                }
                
                [hheaderView addSubview:activityView];
            }
            
            NSString *title = [albumDic objectForKey:@"title"];
            NSString *urlStr = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[albumDic objectForKey:@"thumb"]]];
            
            hheaderView.titleLab.text = title;
            [hheaderView.imgV sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            
            reusableview = hheaderView;
            
            //reusableview = nil;
            
        }else{
            
            RecipeCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
            
            NSString *title = [[dataArray objectAtIndex:indexPath.section-1] objectForKey:@"dateline"];
            
            headerView.titleLabel.text = title;
            
            reusableview = headerView;
        }
        
    }else if (kind == UICollectionElementKindSectionFooter){
        
        reusableview = nil;
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, 250.0);
    }else{
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, 40.0);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSArray *rowArray = [[dataArray objectAtIndex:indexPath.section-1] objectForKey:@"list"];
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSMutableArray *idArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[dataArray count]; i++) {
        
        NSDictionary *dic = [dataArray objectAtIndex:i];
        NSMutableArray *pArray = [dic objectForKey:@"list"];
        for (int j = 0; j<[pArray count]; j++) {
          
            //pic是大图 thumb是缩略图
            NSString *url = [[pArray objectAtIndex:j] objectForKey:@"pic"];
            NSString *idStr = [NSString stringWithFormat:@"%@",[[pArray objectAtIndex:j] objectForKey:@"id"]];
            [photos addObject:url];
            [idArray addObject:idStr];
            
        }
      
    }
    
    NSString *cuId = [NSString stringWithFormat:@"%@",[[rowArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
    
    //NSLog(@"cuIndex:%lu",(unsigned long)[idArray indexOfObject:cuId]);
    
    NSUInteger currentIndex = [idArray indexOfObject:cuId];
    
     FullImageViewController *fullImgV = [[FullImageViewController alloc] init];
     fullImgV.delOrSave = 1;
     fullImgV.assetsArray = photos;
     fullImgV.currentIndex = currentIndex;
     [self.navigationController pushViewController:fullImgV animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //导航条显示与隐藏
    if (150 <= scrollView.contentOffset.y) {
        [UIView animateWithDuration:0.3 animations:^{
            _alphaView.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            _alphaView.alpha = 0.0;
        } completion:^(BOOL finished) {
            
        }];
    }
    
       
        if (_reloading == NO) {
            
            if (_refreshFooterView)
            {
                [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
            }
        }
   
    
    //下拉头部放大
    float ratio = 320.0/250.0;//宽高比
    CGFloat yOffset = scrollView.contentOffset.y;
    CGFloat xOffset = ratio*(-yOffset+250);
    //NSLog(@"yOffset:%f",yOffset);
    if(yOffset<0)
    {
        CGRect f = hheaderView.frame;
        f.origin.y = yOffset;
        f.size.height = -yOffset+250;
        f.size.width = xOffset;
        hheaderView.frame = f;
        
        CGRect ff = hheaderView.imgV.frame;
        ff.origin.y = 0;
        ff.size.height = -yOffset+250;
        ff.size.width = xOffset;
        hheaderView.imgV.frame = ff;
        hheaderView.imgV.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, ff.size.height/2.0);
        hheaderView.imgMaskV.frame = ff;
     
        
        
    }else{
       
        CGRect f = hheaderView.frame;
        f.origin.y = 0;
        //f.size.height = -yOffset+250;
        //f.size.width = -xOffset;
        hheaderView.frame = f;
        
    }
 
   
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    NSLog(@"scrollViewDidEndDragging");
    CGFloat yOffset = scrollView.contentOffset.y;
    //显示下拉刷新空间
    if (yOffset < -60) {
        
        if (loading == 0) {
            [activityView startAnimating];
            [self refreshView];
        }
        
    }

    if (_reloading == NO) {
           
        if (_refreshFooterView)
        {
            [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
        }
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
    
//    if (_refreshHeaderView) {
//        //[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_collectionView];
//    }
//
    if (loading == 0) {
        if (_refreshFooterView) {
            [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_collectionView];
            [self setFooterView];
        }
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


#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
    
    //  should be calling your tableviews data source model to reload
    _reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader)
    {
        // pull down to refresh data
        //[self refreshView];
        //[self performSelector:@selector(refreshView) withObject:nil afterDelay:0.1];
    }else if(aRefreshPos == EGORefreshFooter)
    {
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:0.005];
    }
    
    // overide, the actual loading data operation is done in the subclass
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