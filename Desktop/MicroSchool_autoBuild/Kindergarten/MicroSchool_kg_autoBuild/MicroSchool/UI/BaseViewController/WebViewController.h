//
//  WebViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/9/6.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate>{
    
    UIWebView *web;
    UILabel *label;
    
}
@property (nonatomic, retain) UIWebView *web;
@property (nonatomic, retain) UILabel *label;
- (void)click;

@end
