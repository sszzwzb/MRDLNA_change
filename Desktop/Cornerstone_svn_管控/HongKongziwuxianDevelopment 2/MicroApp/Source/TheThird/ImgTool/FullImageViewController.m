//
//  FullImageViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/6/15.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "FullImageViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "AddImageUtilities.h"


#import "TSProgressHUD.h"
#import "TSPopupItem.h"


static NSString *cellIdentifier = @"FullImageCell";


@interface FullImageViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>{
    
    NSMutableArray *imageModelArray;   //固定三个图片
    BOOL  isFirst;
    BOOL  isRightMove;      //是否向右移动
    BOOL  isLeftMove;       //是否向左移动
    int oldOffsetX;
    
}

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UILabel *numberBar;

@end

@implementation FullImageViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setCustomizeTitle:@"预览"];
    [self setCustomizeLeftButton];
    [self setCustomizeRightButtonChoiceImage:@"icon_sc_k12"];
    
    
//    self.title = @"预览";
    
//    UIButton *fanhuibu=[UIButton buttonWithType:UIButtonTypeCustom];
//
//    fanhuibu.frame=CGRectMake(0, 0, 30, 30);
//
//    [fanhuibu setImage:[UIImage imageNamed:@"TabBack_normal"] forState:UIControlStateNormal];
//    fanhuibu.backgroundColor = [UIColor clearColor];
//    [fanhuibu addTarget:self action:@selector(selectLeftAction:) forControlEvents:UIControlEventTouchUpInside];
//
//    UIBarButtonItem *fanhui=[[UIBarButtonItem alloc]initWithCustomView:fanhuibu];
//
//    self.navigationItem.leftBarButtonItem =fanhui;
//
//
//    UIButton *fanhuibu2=[UIButton buttonWithType:UIButtonTypeCustom];
//
//    fanhuibu2.frame=CGRectMake(0, 0, 30, 30);
//
//    [fanhuibu2 setImage:[UIImage imageNamed:@"icon_sc_k12.png"] forState:UIControlStateNormal];
//    fanhuibu2.backgroundColor = [UIColor clearColor];
//    [fanhuibu2 addTarget:self action:@selector(selectRightAction:) forControlEvents:UIControlEventTouchUpInside];
//
//    UIBarButtonItem *fanhui2=[[UIBarButtonItem alloc]initWithCustomView:fanhuibu2];
//
//    self.navigationItem.rightBarButtonItem =fanhui2;
    
    
    
    
    
    
    _isShowNavigationBar = YES;
    
    maxHeight = [[UIScreen mainScreen] bounds].size.height;
    maxWidth = [[UIScreen mainScreen] bounds].size.width;
    self.automaticallyAdjustsScrollViewInsets = NO;
    UINib *nib = [UINib nibWithNibName:@"FullImageCell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];
    
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.delegate = self;
    
    
    
    
    self.collectionView.frame = CGRectMake(-20.0, 0, maxWidth+20.0, maxHeight);
    self.collectionView.contentOffset = CGPointMake(_currentIndex * self.collectionView.frame.size.width, 0);
    
    _numberBar.text = [NSString stringWithFormat:@"%ld/%lu",_currentIndex+1,(unsigned long)[_assetsArray count]];
    self.collectionView.contentOffset = CGPointMake(_currentIndex * self.collectionView.frame.size.width, 0);
    
    
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNavigationBar)];
    singleTouch.delegate = self;
    [self.view addGestureRecognizer:singleTouch];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

// 右上角删除
-(void)selectRightAction:(id)sender{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                              {
                                  [self deleteCurrentPhoto];
                              }];
    
    [alertController addAction:action1];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
}

- (void)imageSave:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        
        [AddImageUtilities showSuccessedHud:@"保存失败" descView:nil];// 2015.05.12
    } else {
        
        [AddImageUtilities showSuccessedHud:@"图片已保存" descView:nil];//2015.05.12
        
    }
}

-(void)deleteCurrentPhoto{
    
    if (0 == [_assetsArray count]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        
        if ([@"AddImagesTool" isEqualToString:_viewType]) {
            
            NSString *currentIndex = [NSString stringWithFormat:@"%ld",(unsigned long)_currentIndex];
            
            [self.delegate getDeleteIndex:currentIndex];
            
        }else{
            
            NSString *currentIndex = [NSString stringWithFormat:@"%ld",(unsigned long)_currentIndex];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deletePhoto" object:currentIndex];
        }
        
        if (0 == [_assetsArray count]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [_collectionView reloadData];
        }
        
        _numberBar.text = [NSString stringWithFormat:@"%ld/%lu",_currentIndex+1,(unsigned long)[_assetsArray count]];
        
    }
    
    
    
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (0 == buttonIndex) {
        
        if (0 == [_assetsArray count]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            
            if ([@"AddImagesTool" isEqualToString:_viewType]) {
                
                NSString *currentIndex = [NSString stringWithFormat:@"%ld",(unsigned long)_currentIndex];
                
                [self.delegate getDeleteIndex:currentIndex];
                
            }else{
                
                NSString *currentIndex = [NSString stringWithFormat:@"%ld",(unsigned long)_currentIndex];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"deletePhoto" object:currentIndex];
            }
            
            if (0 == [_assetsArray count]) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [_collectionView reloadData];
            }
            
            _numberBar.text = [NSString stringWithFormat:@"%ld/%lu",_currentIndex+1,(unsigned long)[_assetsArray count]];
            
        }
    }
    
    
}

#pragma mark - <UICollectionViewDataSource>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [UIScreen mainScreen].bounds.size;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return [_assetsArray count];
    
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FullImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [[cell contentView] setFrame:[cell bounds]];
    [[cell contentView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    
    __block UIImage *picImage = nil;
    
    
    if ([_assetsArray[indexPath.row] isKindOfClass:ALAsset.class]) {
        NSLog(@"row:%ld",(long)indexPath.row);
        ALAsset *asset = _assetsArray[indexPath.row];
        
        UIImage *tempImage = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage
                                                 scale:asset.defaultRepresentation.scale
                                           orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
        picImage = [AddImageUtilities fixOrientation:tempImage];
        
        [self updateScrollView:picImage fcell:cell];
        
    }else if ([_assetsArray[indexPath.row] isKindOfClass:NSString.class]){
        
        NSString *key = _assetsArray[indexPath.row];
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:key]];
        if ([[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:key]) {
            picImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:key];
            [self updateScrollView:picImage fcell:cell];
        }else{
            [AddImageUtilities showSystemProcessingHud:cell.scrollViewForPic];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:key] completed:^(UIImage *image,NSError *error,SDImageCacheType cacheType,NSURL *imageURL) {
                
                picImage = image;
                
                [self updateScrollView:picImage fcell:cell];
                
                [AddImageUtilities dismissProcessingHud:cell.scrollViewForPic];
                
            }];
            
        }
        
    }else{
        
        picImage = _assetsArray[indexPath.row];
        
        [self updateScrollView:picImage fcell:cell];
        
    }
    
    
    return cell;
}

-(void)updateScrollView:(UIImage*)picImage fcell:(FullImageCell*)cell{
    
    CGFloat redius;
    if (picImage.size.height > maxHeight || picImage.size.width > maxWidth) {
        if ((picImage.size.width / maxWidth) < (picImage.size.height / maxHeight)) {
            redius = maxHeight / picImage.size.height;
            
        } else {
            redius = maxWidth / picImage.size.width;
            
        }
    } else {
        redius = 1.0;
        
    }
    
    [cell.scrollViewForPic setContentSize:picImage.size];
    [cell.scrollViewForPic setMinimumZoomScale:redius];
    [cell.scrollViewForPic setZoomScale:[cell.scrollViewForPic minimumZoomScale]];
    [cell.imageView setImage:picImage];
    if (redius == 1.0) {
        [cell.imageView setFrame:CGRectMake(0, 0, picImage.size.width, picImage.size.height)];
    }else{
        [cell.imageView setFrame:CGRectMake(0, 0, maxWidth, picImage.size.height*redius)];
    }
    
    CGFloat offsetX = (cell.scrollViewForPic.bounds.size.width > cell.scrollViewForPic.contentSize.width)?
    (cell.scrollViewForPic.bounds.size.width - cell.scrollViewForPic.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (cell.scrollViewForPic.bounds.size.height > cell.scrollViewForPic.contentSize.height)?
    (cell.scrollViewForPic.bounds.size.height - cell.scrollViewForPic.contentSize.height) * 0.5 : 0.0;
    cell.imageView.center = CGPointMake(cell.scrollViewForPic.contentSize.width * 0.5 + offsetX,
                                        cell.scrollViewForPic.contentSize.height * 0.5 + offsetY);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    //被cell内的scrollview截获了，所以不走此方法
    if (self.navigationController.navigationBarHidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        self.navigationController.navigationBarHidden = NO;
    }
    else {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSLog(@"row:%ld",(long)indexPath.row);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    if (self.navigationController.navigationBarHidden == NO) {
        [UIApplication sharedApplication].statusBarHidden = YES;
        self.navigationController.navigationBarHidden = YES;
    }
    
    self.collectionView.frame = CGRectMake(-20.0, 0, maxWidth+20.0, maxHeight);
    NSLog(@"%f", self.collectionView.contentOffset.x);
    
    
    NSInteger currentIndex = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
    
    _currentIndex = currentIndex;
    
    _numberBar.text = [NSString stringWithFormat:@"%ld/%lu",_currentIndex+1,(unsigned long)[_assetsArray count]];
}

-(void)showNavigationBar{
    
    if (self.navigationController.navigationBarHidden){//显示导航条加入动画导航底部会有个白条不造是啥
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }else{//隐藏导航条加入动画
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        if (self.navigationController.navigationBarHidden){
            transition.subtype = kCATransitionFromBottom;
        }else{
            transition.subtype = kCATransitionFromTop;
        }
        
        transition.fillMode = kCAFillModeBackwards;
        transition.speed = 0.5f ;
        transition.removedOnCompletion = YES;
        [self.navigationController.navigationBar.layer removeAllAnimations];
        [self.navigationController.navigationBar.layer addAnimation:transition forKey:nil];
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        
    }
    
}

@end
