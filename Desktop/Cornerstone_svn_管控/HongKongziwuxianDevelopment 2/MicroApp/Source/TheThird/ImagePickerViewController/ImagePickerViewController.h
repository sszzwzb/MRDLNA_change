//
//  ImagePickerViewController.h
//  myImagePickerController
//
//  Created by kaiyi on 2017/12/26.
//  Copyright © 2017年 kaiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

typedef enum{
    CIRCULARCLIP   = 0,   //圆形裁剪
    SQUARECLIP,           //方形裁剪
    SQUARECLIP16_9,       //16比9的尺寸
    originalImage,        //原图，不做别的处理，不需要代理，只是a看的那种       临时写法，bug有的
}ClipType;

@class ImagePickerViewController;

@protocol ImagePickerViewControllerDelegate <NSObject>

-(void)ClipViewController:(ImagePickerViewController *)clipViewController FinishClipImage:(UIImage *)editImage;

@end


@interface ImagePickerViewController : BaseViewController

@property (nonatomic, strong)id<ImagePickerViewControllerDelegate>delegate;

@property (nonatomic,assign) ClipType clipType;

@property (nonatomic, assign)CGFloat scaleRation;       //图片缩放的最大倍数
@property (nonatomic, assign)CGFloat radius;            //圆形裁剪框的半径

-(instancetype)initWithImage:(UIImage *)image;

@end
