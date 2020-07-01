//
//  FaceBoard.m
//
//  Created by kateShi on 09-04-14.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//  http://github.com/bluemood

#import "FaceBoard.h"


//#define FACE_COUNT_ALL  85
#define FACE_COUNT_ALL  83

#define FACE_COUNT_ROW  4

#define FACE_COUNT_CLU  7

#define FACE_COUNT_PAGE ( FACE_COUNT_ROW * FACE_COUNT_CLU )

#define FACE_ICON_SIZE  44

#define FACE_NAME_LEN  5


@implementation FaceBoard

@synthesize delegate;

@synthesize inputTextField = _inputTextField;
@synthesize inputTextView = _inputTextView;

- (id)init {

    self = [super initWithFrame:CGRectMake(0, 0, WIDTH, 216)];
    if (self) {

        self.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1];

//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
//        if ([[languages objectAtIndex:0] hasPrefix:@"zh"]) {

            _faceMap = [[NSDictionary dictionaryWithContentsOfFile:
                         [[NSBundle mainBundle] pathForResource:@"faceImages/expression/_expression_cn"
                                                         ofType:@"plist"]] retain];
//        }
//        else {

//            _faceMap = [NSDictionary dictionaryWithContentsOfFile:
//                         [[NSBundle mainBundle] pathForResource:@"_expression_en"
//                                                         ofType:@"plist"]] ;
            //NSLog([_faceMap description]);
//        }
       
        [[NSUserDefaults standardUserDefaults] setObject:_faceMap forKey:@"FaceMap"];

        //表情盘
        faceView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 190)];
        faceView.pagingEnabled = YES;
        faceView.contentSize = CGSizeMake((FACE_COUNT_ALL / FACE_COUNT_PAGE + 1) * WIDTH, 190);
        faceView.showsHorizontalScrollIndicator = NO;
        faceView.showsVerticalScrollIndicator = NO;
        faceView.delegate = self;
        
        for (int i = 1; i <= FACE_COUNT_ALL; i++) {

            FaceButton *faceButton = [FaceButton buttonWithType:UIButtonTypeCustom];
            faceButton.buttonIndex = i;
            
            [faceButton addTarget:self
                           action:@selector(faceButton:)
                 forControlEvents:UIControlEventTouchUpInside];
            
            //计算每一个表情按钮的坐标和在哪一屏
            CGFloat x = (((i - 1) % FACE_COUNT_PAGE) % FACE_COUNT_CLU) * FACE_ICON_SIZE + 6 + ((i - 1) / FACE_COUNT_PAGE * WIDTH);
            CGFloat y = (((i - 1) % FACE_COUNT_PAGE) / FACE_COUNT_CLU) * FACE_ICON_SIZE + 8;
            faceButton.frame = CGRectMake( x, y, FACE_ICON_SIZE, FACE_ICON_SIZE);
            
            [faceButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"faceImages/expression/%03d.png", i]]
                        forState:UIControlStateNormal];

            [faceView addSubview:faceButton];
        }
        
        //添加PageControl
        facePageControl = [[GrayPageControl alloc]initWithFrame:CGRectMake(110, 190, 100, 20)];
        
        [facePageControl addTarget:self
                            action:@selector(pageChange:)
                  forControlEvents:UIControlEventValueChanged];
        
        facePageControl.numberOfPages = FACE_COUNT_ALL / FACE_COUNT_PAGE + 1;
        facePageControl.currentPage = 0;
        [self addSubview:facePageControl];
        
        //添加键盘View
        [self addSubview:faceView];
        
        //删除键
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        [back setTitle:@"删除" forState:UIControlStateNormal];
        [back setImage:[UIImage imageNamed:@"faceImages/faceBoard/del_emoji_normal.png"] forState:UIControlStateNormal];
        [back setImage:[UIImage imageNamed:@"faceImages/faceBoard/del_emoji_select.png"] forState:UIControlStateSelected];
        [back addTarget:self action:@selector(backFace) forControlEvents:UIControlEventTouchUpInside];
        back.frame = CGRectMake(272, 182, 38, 28);
        [self addSubview:back];
    }

    return self;
}

//停止滚动的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    [facePageControl setCurrentPage:faceView.contentOffset.x / WIDTH];
    [facePageControl updateCurrentPageDisplay];
}

- (void)pageChange:(id)sender {

    [faceView setContentOffset:CGPointMake(facePageControl.currentPage * WIDTH, 0) animated:YES];
    [facePageControl setCurrentPage:facePageControl.currentPage];
}

- (void)faceButton:(id)sender {

    int i = ((FaceButton*)sender).buttonIndex;
    if (self.inputTextField) {

        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextField.text];
        [faceString appendString:[_faceMap objectForKey:[NSString stringWithFormat:@"%03d", i]]];
                self.inputTextField.text = faceString;
        [faceString release];
    }

    if (self.inputTextView) {

        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextView.text];
        
        if (_maxLength >0 && [faceString length] >= _maxLength) {
            return;
        }
        
        [faceString appendString:[_faceMap objectForKey:[NSString stringWithFormat:@"%03d", i]]];
//        NSLog([NSString stringWithFormat:@"%03d", i]);
//        NSLog([_faceMap objectForKey:[NSString stringWithFormat:@"%03d", i]]);
//        NSLog([_faceMap description]);
        self.inputTextView.text = faceString;
        [faceString release];

        [delegate textViewDidChange:self.inputTextView];
    }
}

- (void)backFace{
    
    NSString *inputString;
    inputString = self.inputTextField.text;
    if (self.inputTextView) {
        inputString = self.inputTextView.text;
    }
    
    NSString *string = nil;
    NSInteger stringLength = inputString.length;
    if (stringLength > 0) {
        if ([@"]" isEqualToString:[inputString substringFromIndex:stringLength-1]]) {
            if ([inputString rangeOfString:@"["].location == NSNotFound){
                string = [inputString substringToIndex:stringLength - 1];
            } else {
                string = [inputString substringToIndex:[inputString rangeOfString:@"[" options:NSBackwardsSearch].location];
            }
        } else {
            string = [inputString substringToIndex:stringLength - 1];
        }
    }
    self.inputTextField.text = string;
    self.inputTextView.text = string;
}

/*- (void)backFace{

    NSString *inputString;
    inputString = self.inputTextField.text;
    if ( self.inputTextView ) {

        inputString = self.inputTextView.text;
    }

    if ( inputString.length ) {
        
        NSString *string = nil;
        NSInteger stringLength = inputString.length;
        if ( stringLength >= FACE_NAME_LEN ) {
            
            string = [inputString substringFromIndex:stringLength - FACE_NAME_LEN];
            NSRange range = [string rangeOfString:FACE_NAME_HEAD];
            if ( range.location == 0 ) {
                
                string = [inputString substringToIndex:
                          [inputString rangeOfString:FACE_NAME_HEAD
                                             options:NSBackwardsSearch].location];
            }
            else {
                
                string = [inputString substringToIndex:stringLength - 1];
            }
        }
        else {
            
            string = [inputString substringToIndex:stringLength - 1];
        }
        
        if ( self.inputTextField ) {
            
            self.inputTextField.text = string;
        }
        
        if ( self.inputTextView ) {
            
            self.inputTextView.text = string;
            
            [delegate textViewDidChange:self.inputTextView];
        }
    }
}*/

- (void)dealloc {
    
    [_faceMap release];
    [_inputTextField release];
    [_inputTextView release];
    [faceView release];
    [facePageControl release];
    
    [super dealloc];
}

@end
