//
//  ScrolledBanner.m
//  MicroSchool
//
//  Created by CheungStephen on 3/14/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "ScrolledBanner.h"

@implementation ScrolledBanner

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initImages:(NSArray *)imgArrar content:(NSString *)content rect:(CGRect)rect {
    _widthStr = [NSString stringWithFormat:@"%f", rect.size.width];
    NSUInteger imgCnt = [imgArrar count];
//    NSUInteger imgCnt = 2; 

    _scrollView = [UIScrollView new];
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(rect.size.width*imgCnt, rect.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.contentSize = CGSizeMake(rect.size.width*imgCnt, rect.size.height);

    [self addSubview:_scrollView];

    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(rect.size.width, rect.size.height));
    }];

    if (0 == imgCnt) {
        // 如果没有传入image的话，显示默认的图片
        UIImageView *bgImageView = [[UIImageView alloc] init];
        bgImageView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        
        [bgImageView setImage:[UIImage imageNamed:@"SchoolHomePics/schoolHomeRecipeNoBanner"]];
        [_scrollView addSubview:bgImageView];
    }else {
        if (imgCnt > 1) {
            _pageControl = [UIPageControl new];
            _pageControl.numberOfPages = imgCnt;
            _pageControl.currentPage = 0;
            [self addSubview:_pageControl];
            
            [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.mas_bottom).with.offset(-[Utilities convertPixsH:17]);
                make.right.equalTo(self.mas_right).with.offset([Utilities convertPixsW:10]);
                make.size.mas_equalTo(CGSizeMake(100, 20));
            }];
        }
        
        for (int i=0; i<imgCnt; i++) {
            NSDictionary *dic = [imgArrar objectAtIndex:i];
            
            UIImageView *bgImageView = [[UIImageView alloc] init];
            bgImageView.frame = CGRectMake(i*rect.size.width, 0, rect.size.width, rect.size.height);
            bgImageView.contentMode = UIViewContentModeScaleAspectFill;
            bgImageView.layer.masksToBounds = YES;
            
            [bgImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            [_scrollView addSubview:bgImageView];
            
            TSTouchImageView *tsTouchImg =[TSTouchImageView new];
            tsTouchImg.contentMode = UIViewContentModeScaleAspectFill;
            tsTouchImg.clipsToBounds = YES;
            tsTouchImg.userInteractionEnabled = YES;
            tsTouchImg.isShowBgImg = NO;
            tsTouchImg.frame = CGRectMake(i*rect.size.width, 0, rect.size.width, rect.size.height);
            [tsTouchImg setImage:[UIImage imageNamed:@"SchoolHomePics/schoolHomeBannerBg"]];
            
            [_scrollView addSubview:tsTouchImg];
            
            TSTapGestureRecognizer *myTapGesture = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(picClicked:)];
            
            NSDictionary *tapDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    [dic objectForKey:@"id"], @"picIndex",
                                    nil];
            
            myTapGesture.infoStr = [NSString stringWithFormat:@"%ld", (long)i-1];
            myTapGesture.infoDic = tapDic;
            [tsTouchImg addGestureRecognizer:myTapGesture];
            
            UILabel *contentLabel = [UILabel new];
            contentLabel.textColor = [[UIColor alloc] initWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0];
            contentLabel.text = [dic objectForKey:@"title"];
            contentLabel.font = [UIFont systemFontOfSize:15.0f];
            [tsTouchImg addSubview:contentLabel];
            
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(tsTouchImg.mas_bottom).with.offset(-[Utilities convertPixsH:20]);
                make.left.equalTo(tsTouchImg.mas_left).with.offset(10);
                make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-80, 16));
            }];
        }
    }
}

- (IBAction)picClicked:(id)sender {
    TSTapGestureRecognizer *tsTap = (TSTapGestureRecognizer *)sender;
    NSDictionary *positionDic = tsTap.infoDic;
    NSString *moduleIndexa = [positionDic objectForKey:@"picIndex"];
    
    [self.delegate ScrolledBannerSelectedImage:self index:moduleIndexa.intValue];
}

#pragma mark UIScrollViewDelegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
        float x = scrollView.contentOffset.x;
        int indexPage = x /_widthStr.floatValue;
        _pageControl.currentPage = indexPage;
}

@end
