//
//  FullImageViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/6/15.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "FullImageViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>


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
@property (strong, nonatomic) IBOutlet UIView *bottomBar;
@property (strong, nonatomic) IBOutlet UILabel *bottomLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bottomBgImgV;

@end

@implementation FullImageViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [self setCustomizeLeftButton];
    
    if (_delOrSave == 1) {
        
        [self setCustomizeRightButtonWithName:@"保存"];
        
    }else{
        
        [self setCustomizeRightButton:@"moments/icon_sc.png"];
        //[self setCustomizeTitle:@"预览"];
        
    }
    
    _isShowNavigationBar = YES;
    
    maxHeight = [[UIScreen mainScreen] bounds].size.height;
    maxWidth = [[UIScreen mainScreen] bounds].size.width;
    self.automaticallyAdjustsScrollViewInsets = NO;
    UINib *nib = [UINib nibWithNibName:@"FullImageCell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.delegate = self;
    
    
    if(_isShowBottomBar == 1){
        
        _bottomBar.frame = CGRectMake(0, self.view.frame.size.height - 44.0, [UIScreen mainScreen].bounds.size.width, 44.0);
        _bottomLabel.text = _bottomStr;
        _bottomLabel.font = [UIFont systemFontOfSize:14.0];
        _bottomLabel.frame = CGRectMake(5, 0, [UIScreen mainScreen].bounds.size.width-10, 44.0);
        
        CGSize bottomLabSize = [Utilities getLabelHeight:_bottomLabel size:CGSizeMake(_bottomLabel.frame.size.width, MAXFLOAT)];
        float height = bottomLabSize.height+7;
        if (height < 44) {
            height = 44.0;
        }
        _bottomLabel.frame = CGRectMake(5, 0, _bottomLabel.frame.size.width, height);
        [_bottomBgImgV setImage:[UIImage imageNamed:@"ClassKin/bottomBarStrBg.png"]];
        _bottomBgImgV.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, _bottomLabel.frame.size.height);
        _bottomBar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - _bottomLabel.frame.size.height, [UIScreen mainScreen].bounds.size.width, _bottomLabel.frame.size.height);
        [[UIApplication sharedApplication].keyWindow addSubview:_bottomBar];
        
    }else{
        
        [_bottomBar removeFromSuperview];
    }
    
    
    if (iPhone4) {
        _isFromIphone4s = @"1";
    }
    
    if ([@"health"  isEqual: _viewType]) {
        _collectionView.contentOffset = CGPointMake(_currentIndex * _collectionView.frame.size.width, 0);
        
        _numberBar.text = [NSString stringWithFormat:@"%ld/%lu",_currentIndex+1,[_imageArray count]];

    }else {
        
        self.collectionView.frame = CGRectMake(-20.0, 0, maxWidth+20.0, maxHeight);
        self.collectionView.contentOffset = CGPointMake(_currentIndex * self.collectionView.frame.size.width, 0);
        
        _numberBar.text = [NSString stringWithFormat:@"%ld/%lu",_currentIndex+1,[_assetsArray count]];
        self.collectionView.contentOffset = CGPointMake(_currentIndex * self.collectionView.frame.size.width, 0);
        
    }
    
   
    if (_titleName) {
        
        NSString *titleStr = [NSString stringWithFormat:@"%@\n%@",_titleName,_numberBar.text];
        
        [self setCustomizeTitle:titleStr font:[UIFont systemFontOfSize:14.0]];
        
    }else{
        
        [self setCustomizeTitle:_numberBar.text];
        
    }
    
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNavigationBar)];
    singleTouch.delegate = self;
    [self.view addGestureRecognizer:singleTouch];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [_bottomBar removeFromSuperview];
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navigationController.navigationBarHidden = NO;
    
}

// 右上角删除
-(void)selectRightAction:(id)sender{
    
    if (_delOrSave == 1){
        //保存至相册
        UIImage *saveImage;
        if ([_assetsArray[_currentIndex] isKindOfClass:ALAsset.class]) {
            
            ALAsset *asset = _assetsArray[_currentIndex];
            
            UIImage *tempImage = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage
                                                     scale:asset.defaultRepresentation.scale
                                               orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
            saveImage = [Utilities fixOrientation:tempImage];
            
            
        }else if ([_assetsArray[_currentIndex] isKindOfClass:NSString.class]){
            
            NSString *key = _assetsArray[_currentIndex];
            NSLog(@"key:%@",key);
           
            if ([[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:key]) {
                saveImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:key];
            }
        }else{
            
            saveImage = _assetsArray[_currentIndex];
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(imageSave:didFinishSavingWithError:contextInfo:), nil);
        });
        
        
    }else{
        //删除
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除",nil];
        sheet.actionSheetStyle = UIActionSheetStyleDefault;
        [sheet showInView:self.view];
 
    }
  
}


- (void)imageSave:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        //[self.view makeToast:@"保存图片失败" duration:1.5 position:@"center" image:nil];
        //[MBProgressHUD showSuccess:@"保存失败" toView:nil];
        [Utilities showSuccessedHud:@"保存失败" descView:nil];// 2015.05.12
    } else {
        //[self.view makeToast:@"图片已保存到相册" duration:1.5 position:@"center" image:nil];
        //[MBProgressHUD showSuccess:@"图片已保存" toView:nil];
        [Utilities showSuccessedHud:@"图片已保存" descView:nil];//2015.05.12
        
    }
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (0 == buttonIndex) {
        
        //[_assetsArray removeObjectAtIndex:_currentIndex];
        //        NSLog(@"self.assetsArray:%d",[_assetsArray count]);
        //        NSLog(@"currentIndex:%d",_currentIndex);
        
        if ([@"health"  isEqual: _viewType]) {
            if (0 == [_imageArray count]) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                NSString *currentIndex = [NSString stringWithFormat:@"%ld",(unsigned long)_currentIndex];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"deletePhoto" object:currentIndex];
                
                if (0 == [_imageArray count]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    
//                    [_imageArray removeObjectAtIndex:_currentIndex];
                    
                    [_collectionView reloadData];
                }
                
                _numberBar.text = [NSString stringWithFormat:@"%d/%d",_currentIndex+1,[_imageArray count]];
                
            }
        }else {
            if (0 == [_assetsArray count]) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                
                if ([@"AddImagesTool" isEqualToString:_viewType]) {
                    
                    NSString *currentIndex = [NSString stringWithFormat:@"%ld",(unsigned long)_currentIndex];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"deletePhoto_Tool" object:currentIndex];
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
                
                _numberBar.text = [NSString stringWithFormat:@"%d/%d",_currentIndex+1,[_assetsArray count]];
                
            }
        }
        
        if (_titleName) {
            
            NSString *titleStr = [NSString stringWithFormat:@"%@\n%@",_titleName,_numberBar.text];
            
            [self setCustomizeTitle:titleStr font:[UIFont systemFontOfSize:14.0]];
            
        }else{
            
            [self setCustomizeTitle:_numberBar.text];
            
        }

    }
}

#pragma mark - <UICollectionViewDataSource>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [UIScreen mainScreen].bounds.size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if ([@"health"  isEqual: _viewType]) {
        return [_imageArray count];
    }else {
        return [_assetsArray count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FullImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [[cell contentView] setFrame:[cell bounds]];
    [[cell contentView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
   
   __block UIImage *picImage = nil;
    
    if ([@"health"  isEqual: _viewType]) {
        [cell.scrollViewForPic setContentSize:[Utilities getScreenSize]];

        NSDictionary *dic = [_imageArray objectAtIndex:[indexPath row]];
        
        // update by kate 2015.12.10
        if ([@"selectImageLocal"  isEqual: [dic objectForKey:@"imageType"]]) {
          
            picImage = [dic objectForKey:@"image"];
        }else {
           
            NSString *key = [dic objectForKey:@"image"];
            picImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:key];
        }
        
        picImage = [Utilities fixOrientation:picImage];
        
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
        
        [self updateScrollView:picImage fcell:cell];

    }else {
        if ([_assetsArray[indexPath.row] isKindOfClass:ALAsset.class]) {
            
            ALAsset *asset = _assetsArray[indexPath.row];
            
            UIImage *tempImage = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage
                                                     scale:asset.defaultRepresentation.scale
                                               orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
            picImage = [Utilities fixOrientation:tempImage];
            
            [self updateScrollView:picImage fcell:cell];
            
            
        }else if ([_assetsArray[indexPath.row] isKindOfClass:NSString.class]){
            
            NSString *key = _assetsArray[indexPath.row];
           
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:key]];
            if ([[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:key]) {
                 picImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:key];
                 [self updateScrollView:picImage fcell:cell];
            }else{
                [Utilities showProcessingHud:cell.scrollViewForPic];
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:key] completed:^(UIImage *image,NSError *error,SDImageCacheType cacheType,NSURL *imageURL) {
                    
                    picImage = image;
                    
                    [self updateScrollView:picImage fcell:cell];
                    
                    [Utilities dismissProcessingHud:cell.scrollViewForPic];
                    
                }];
                
            }
         
        }else{
            
            picImage = _assetsArray[indexPath.row];
            
            [self updateScrollView:picImage fcell:cell];
            
        }
        
    }

    /*CGFloat redius;
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
                                        cell.scrollViewForPic.contentSize.height * 0.5 + offsetY);*/

    
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
    
//    if (iPhone4) {
//        _isFromIphone4s = @"1";
//    }

//    if ([@"1"  isEqual: _isFromIphone4s]) {
        if (self.navigationController.navigationBarHidden == NO) {
            [UIApplication sharedApplication].statusBarHidden = YES;
            self.navigationController.navigationBarHidden = YES;
        }
    
        self.collectionView.frame = CGRectMake(-20.0, 0, maxWidth+20.0, maxHeight);
        NSLog(@"%f", self.collectionView.contentOffset.x);
    
        
        NSInteger currentIndex = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
        
        _currentIndex = currentIndex;
        
        if ([@"health"  isEqual: _viewType]) {
            _numberBar.text = [NSString stringWithFormat:@"%ld/%lu",_currentIndex+1,[_imageArray count]];
            
        }else {
            _numberBar.text = [NSString stringWithFormat:@"%ld/%lu",_currentIndex+1,[_assetsArray count]];
            
        }
    
    if (_titleName) {
        
        NSString *titleStr = [NSString stringWithFormat:@"%@\n%@",_titleName,_numberBar.text];
        
        [self setCustomizeTitle:titleStr font:[UIFont systemFontOfSize:14.0]];
        
    }else{
        
        [self setCustomizeTitle:_numberBar.text];
        
    }
        
//        _isFromIphone4s = @"0";
//    }
}

-(void)showNavigationBar{
    
//    //animated这种方式的动画没有白色，可是屏幕还是会闪一下。。。
//    if (self.navigationController.navigationBarHidden) {
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
//        [self.navigationController setNavigationBarHidden:NO animated:NO];
//    }
//    else {
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
//        [self.navigationController setNavigationBarHidden:YES animated:NO];
//    }
//    
//    [self.navigationController.navigationBar setTranslucent:NO];
    
    /*我想在隐藏导航条的时候加一个动画，可是，隐藏过程中不造为嘛导航条那块有白色。。。,并且屏幕闪一下
     
     [UIView beginAnimations:nil context:NULL];
     [UIView setAnimationBeginsFromCurrentState:YES];
     [UIView setAnimationDuration:0.35];
     [UIView setAnimationCurve:UIViewAnimationCurveLinear];
     //[UIView setAnimationTransition: UIViewAnimationTransitionCurlUp forView:self.view cache:YES]; //给视图添加过渡效果
     [self.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight];//UIViewAutoresizingFlexibleTopMargin
     if (self.navigationController.navigationBarHidden == NO) {
     
     [UIApplication sharedApplication].statusBarHidden = YES;
     
     self.navigationController.navigationBarHidden = YES;
     }else{
     
     [UIApplication sharedApplication].statusBarHidden = NO;
     
     self.navigationController.navigationBarHidden = NO;
     }
     
     // commit animations
     [UIView commitAnimations];*/
    

    if (self.navigationController.navigationBarHidden){//显示导航条加入动画导航底部会有个白条不造是啥
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
       [self.navigationController setNavigationBarHidden:NO animated:NO];
        
//         _bottomBar.frame = CGRectMake(0,_bottomBar.frame.origin.y - 66.0, [UIScreen mainScreen].bounds.size.width, _bottomLabel.frame.size.height);
        
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
        
//         _bottomBar.frame = CGRectMake(0,_bottomBar.frame.origin.y+66.0, [UIScreen mainScreen].bounds.size.width, _bottomLabel.frame.size.height);
    
    }
    
}


@end
