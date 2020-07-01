//
//  SetHeadImgViewController.h
//  MicroSchool
//
//  Created by zhanghaotian on 14-1-10.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "MicroSchoolMainMenuViewController.h"

@interface SetHeadImgViewController : BaseViewController<HttpReqCallbackDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate>
{
    UIImageView *_imgView_HeadImg;
    
    NSString *imagePath1;
}

@end
