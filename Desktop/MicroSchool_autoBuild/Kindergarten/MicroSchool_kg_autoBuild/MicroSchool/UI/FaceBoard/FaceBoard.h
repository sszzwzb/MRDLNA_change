//
//  FaceBoard.h
//
//  Created by kateShi on 09-04-14.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//  http://github.com/bluemood
//

#import <UIKit/UIKit.h>

#import "FaceButton.h"
#import "BaseViewController.h"
#import "GrayPageControl.h"


#define FACE_NAME_HEAD  @"["
#define FACE_NAME_END  @"]"
#define FACE_NAME_LEN 5

@protocol FaceBoardDelegate <NSObject>

@optional

- (void)textViewDidChange:(UITextView *)textView;

@end


@interface FaceBoard : UIView<UIScrollViewDelegate>{

    UIScrollView *faceView;

    GrayPageControl *facePageControl;

    NSDictionary *_faceMap;
}


@property (nonatomic, assign) id<FaceBoardDelegate> delegate;

@property (nonatomic, retain) UITextField *inputTextField;

@property (nonatomic, retain) UITextView *inputTextView;

@property (nonatomic, assign) NSInteger maxLength;//最大字数限制


- (void)backFace;


@end
