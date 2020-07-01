//
//  GroupChatSettingMemberList.m
//  MicroSchool
//
//  Created by jojo on 15/5/27.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "GroupChatSettingMemberList.h"

@implementation GroupChatSettingMemberList

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if (self != nil) {
        // sth. todo
        _removeIconArr = [[NSMutableArray alloc] init];
        _allMemberArr = [[NSMutableArray alloc] init];
        _allMemberNameArr = [[NSMutableArray alloc] init];
    }
    return self;
}

#if 9
- (void)setImgAndName:(NSArray *)arr
{
    if (0 != [arr count]) {
        int memberPosX = 1;
        int memberPosY = 1;

        for(NSInteger i=1; i<=[arr count]; i++) {
            if (i%4) {
                memberPosX = i%4;
            }else {
                memberPosX = 4;
            }
            
            int a = 16*memberPosX+60*(memberPosX-1);
            int b = 16*memberPosY+90*(memberPosY-1);

            NSDictionary *fileDic = [arr objectAtIndex:i-1];
            
            // 头像
            TSTouchImageView *_tsTouchImg =[[TSTouchImageView alloc]initWithFrame:CGRectMake(a, b, 60, 60)];
            _tsTouchImg.contentMode = UIViewContentModeScaleAspectFill;
            _tsTouchImg.clipsToBounds = YES;
            _tsTouchImg.userInteractionEnabled = YES;
            _tsTouchImg.layer.masksToBounds = YES;
            _tsTouchImg.layer.cornerRadius = 60/2;

            [self addSubview:_tsTouchImg];
            [_allMemberArr addObject:_tsTouchImg];

            // 设置点击事件
            TSTapGestureRecognizer *myTapGesture = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(memBerListClick:)];
            myTapGesture.infoStr = [NSString stringWithFormat:@"%ld", (long)i-1];
            [_tsTouchImg addGestureRecognizer:myTapGesture];

            // 按照不同的内容，设置不同的图片
            if (nil != [fileDic objectForKey:@"avatar"]) {
                [_tsTouchImg sd_setImageWithURL:[NSURL URLWithString:[fileDic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
                
                if (!_hiddenMomentsList) {
                    if (1 != i) {
                        // 头像左上角的删除成员按钮
                        TSTouchImageView *_tsTouchImgRemove =[[TSTouchImageView alloc]initWithFrame:CGRectMake(
                                                                                                               _tsTouchImg.frame.origin.x-7,
                                                                                                               _tsTouchImg.frame.origin.y-7, 15, 15)];
                        _tsTouchImgRemove.contentMode = UIViewContentModeScaleAspectFill;
                        _tsTouchImgRemove.clipsToBounds = YES;
                        _tsTouchImgRemove.userInteractionEnabled = YES;
                        
                        // 设置点击事件
                        TSTapGestureRecognizer *myTapGestureRemove = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMemBerListClick:)];
                        myTapGestureRemove.infoStr = [NSString stringWithFormat:@"%ld", (long)i-1];
                        [_tsTouchImgRemove addGestureRecognizer:myTapGestureRemove];
                        [_tsTouchImgRemove setImage:[UIImage imageNamed:@"icon_new"]];
                        
                        [_removeIconArr addObject:_tsTouchImgRemove];
                        
                        [self addSubview:_tsTouchImgRemove];
                    }
                }else {
                    // 头像左上角的删除成员按钮
                    TSTouchImageView *_tsTouchImgRemove =[[TSTouchImageView alloc]initWithFrame:CGRectMake(
                                                                                                           _tsTouchImg.frame.origin.x-7,
                                                                                                           _tsTouchImg.frame.origin.y-7, 15, 15)];
                    _tsTouchImgRemove.contentMode = UIViewContentModeScaleAspectFill;
                    _tsTouchImgRemove.clipsToBounds = YES;
                    _tsTouchImgRemove.userInteractionEnabled = YES;
                    
                    // 设置点击事件
                    TSTapGestureRecognizer *myTapGestureRemove = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMemBerListClick:)];
                    myTapGestureRemove.infoStr = [NSString stringWithFormat:@"%ld", (long)i-1];
                    [_tsTouchImgRemove addGestureRecognizer:myTapGestureRemove];
                    [_tsTouchImgRemove setImage:[UIImage imageNamed:@"icon_new"]];
                    
                    [_removeIconArr addObject:_tsTouchImgRemove];
                    
                    [self addSubview:_tsTouchImgRemove];
                }
            }else {
                [_tsTouchImg setImage:[UIImage imageNamed:[fileDic objectForKey:@"localPic"]]];
            }
            
            // 名字
            UILabel *_label_name = [[UILabel alloc] initWithFrame:CGRectMake(_tsTouchImg.frame.origin.x + 1,
                                                                             _tsTouchImg.frame.origin.y + 60 + 5, 58, 20)];
            _label_name.lineBreakMode = NSLineBreakByTruncatingTail;
            _label_name.textAlignment = NSTextAlignmentCenter;
            _label_name.font = [UIFont systemFontOfSize:13.0f];
            _label_name.textColor = [UIColor blackColor];
            _label_name.backgroundColor = [UIColor clearColor];
            _label_name.text = [fileDic objectForKey:@"name"];
            [self addSubview:_label_name];
            [_allMemberNameArr addObject:_label_name];

            if (i%4) {
            }else {
                memberPosY = memberPosY + 1;
            }
        }
    }
}
#endif

- (void)setImgAndName:(NSArray *)arr showRemoveIcon:(BOOL)isShow
{
    int lineHeadCnt = 4;
    float headWidthGap = 16;
    
    if (iPhone6p) {
        lineHeadCnt = 5;
        headWidthGap = 18.5;
    }else if (iPhone6) {
        lineHeadCnt = 5;
        headWidthGap = 11.5;
    }
    
    if (0 != [arr count]) {
        int memberPosX = 1;
        int memberPosY = 1;
        
        for(NSInteger i=1; i<=[arr count]; i++) {
            if (i%lineHeadCnt) {
                memberPosX = i%lineHeadCnt;
            }else {
                memberPosX = lineHeadCnt;
            }
            
            int a = headWidthGap*memberPosX+60*(memberPosX-1);
            int b = 16*memberPosY+90*(memberPosY-1);
            
            NSDictionary *fileDic = [arr objectAtIndex:i-1];
            
            // 头像
            TSTouchImageView *_tsTouchImg =[[TSTouchImageView alloc]initWithFrame:CGRectMake(a, b, 60, 60)];
            _tsTouchImg.contentMode = UIViewContentModeScaleAspectFill;
            _tsTouchImg.clipsToBounds = YES;
            _tsTouchImg.userInteractionEnabled = YES;
            _tsTouchImg.layer.masksToBounds = YES;
            _tsTouchImg.layer.cornerRadius = 60/2;

            [self addSubview:_tsTouchImg];
            [_allMemberArr addObject:_tsTouchImg];
            
            // 设置点击事件
            TSTapGestureRecognizer *myTapGesture = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(memBerListClick:)];
            myTapGesture.infoStr = [NSString stringWithFormat:@"%ld", (long)i-1];
            [_tsTouchImg addGestureRecognizer:myTapGesture];
            
            // 按照不同的内容，设置不同的图片
            if (nil != [fileDic objectForKey:@"avatar"]) {
                [_tsTouchImg sd_setImageWithURL:[NSURL URLWithString:[fileDic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
                
                if (!_hiddenMomentsList) {
                    if (1 != i) {
                        // 头像左上角的删除成员按钮
                        TSTouchImageView *_tsTouchImgRemove =[[TSTouchImageView alloc]initWithFrame:CGRectMake(
                                                                                                               _tsTouchImg.frame.origin.x + _tsTouchImg.frame.size.width -15,
                                                                                                               _tsTouchImg.frame.origin.y, 20, 20)];
                        _tsTouchImgRemove.contentMode = UIViewContentModeScaleAspectFill;
                        _tsTouchImgRemove.clipsToBounds = YES;
                        _tsTouchImgRemove.userInteractionEnabled = YES;
                        _tsTouchImgRemove.isShowBgImg = NO;
                        
                        // 设置点击事件
                        TSTapGestureRecognizer *myTapGestureRemove = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMemBerListClick:)];
                        myTapGestureRemove.infoStr = [NSString stringWithFormat:@"%ld", (long)i-1];
                        [_tsTouchImgRemove addGestureRecognizer:myTapGestureRemove];
                        
                        [_tsTouchImgRemove setImage:[UIImage imageNamed:@"sc"]];
                        
                        _tsTouchImgRemove.hidden = isShow;
                        [_removeIconArr addObject:_tsTouchImgRemove];
                        
                        [self addSubview:_tsTouchImgRemove];
                    }
                }else {
                    // 头像左上角的删除成员按钮
                    TSTouchImageView *_tsTouchImgRemove =[[TSTouchImageView alloc]initWithFrame:CGRectMake(
                                                                                                           _tsTouchImg.frame.origin.x + _tsTouchImg.frame.size.width -15,
                                                                                                           _tsTouchImg.frame.origin.y, 20, 20)];
                    _tsTouchImgRemove.contentMode = UIViewContentModeScaleAspectFill;
                    _tsTouchImgRemove.clipsToBounds = YES;
                    _tsTouchImgRemove.userInteractionEnabled = YES;
                    _tsTouchImgRemove.isShowBgImg = NO;
                    
                    // 设置点击事件
                    TSTapGestureRecognizer *myTapGestureRemove = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMemBerListClick:)];
                    myTapGestureRemove.infoStr = [NSString stringWithFormat:@"%ld", (long)i-1];
                    [_tsTouchImgRemove addGestureRecognizer:myTapGestureRemove];
                    
                    [_tsTouchImgRemove setImage:[UIImage imageNamed:@"sc"]];
                    
                    _tsTouchImgRemove.hidden = isShow;
                    [_removeIconArr addObject:_tsTouchImgRemove];
                    
                    [self addSubview:_tsTouchImgRemove];
                }
            }else {
                [_tsTouchImg setImage:[UIImage imageNamed:[fileDic objectForKey:@"localPic"]]];
            }
            
            // 名字
            UILabel *_label_name = [[UILabel alloc] initWithFrame:CGRectMake(_tsTouchImg.frame.origin.x + 1,
                                                                             _tsTouchImg.frame.origin.y + 60 + 5, 58, 20)];
            _label_name.lineBreakMode = NSLineBreakByTruncatingTail;
            _label_name.textAlignment = NSTextAlignmentCenter;
            _label_name.font = [UIFont systemFontOfSize:13.0f];
            _label_name.textColor = [UIColor blackColor];
            _label_name.backgroundColor = [UIColor clearColor];
            _label_name.text = [fileDic objectForKey:@"name"];
            
            if ([@"add"  isEqual: [fileDic objectForKey:@"type"]]) {
                _label_name.textColor = [[UIColor alloc] initWithRed:61/255.0f green:179/255.0f blue:240/255.0f alpha:1.0];
                _tsTouchImg.isShowBgImg = NO;
            }else if ([@"remove"  isEqual: [fileDic objectForKey:@"type"]]) {
                _label_name.textColor = [[UIColor alloc] initWithRed:229/255.0f green:51/255.0f blue:81/255.0f alpha:1.0];
                _tsTouchImg.isShowBgImg = NO;
            }
            
            [self addSubview:_label_name];
            [_allMemberNameArr addObject:_label_name];
            
            if (i%lineHeadCnt) {
            }else {
                memberPosY = memberPosY + 1;
            }
        }
    }
}

- (IBAction)memBerListClick:(id)sender
{
    TSTapGestureRecognizer *tsTap = (TSTapGestureRecognizer *)sender;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         tsTap.infoStr, @"tag",
                         nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_GROUPCHAT_MEMBERLISTCLICK object:self userInfo:dic];
}

- (IBAction)removeMemBerListClick:(id)sender
{
    TSTapGestureRecognizer *tsTap = (TSTapGestureRecognizer *)sender;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         tsTap.infoStr, @"tag",
                         nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_GROUPCHAT_REMOVEMEMBERLIST object:self userInfo:dic];
}

- (void)setRemoveIconHidden:(BOOL)isHidden;
{
    for(id obj in _removeIconArr) {
        TSTouchImageView *tsTouchImg = (TSTouchImageView *)obj;
        tsTouchImg.hidden = isHidden;
    }
}

- (void)removeAllMember
{
    for(id obj in _allMemberArr) {
        TSTouchImageView *tsTouchImg = (TSTouchImageView *)obj;
        [tsTouchImg removeFromSuperview];
    }
    [_allMemberArr removeAllObjects];

    for(id obj in _removeIconArr) {
        TSTouchImageView *tsTouchImg = (TSTouchImageView *)obj;
        [tsTouchImg removeFromSuperview];
    }
    [_removeIconArr removeAllObjects];
    
    for(id obj in _allMemberNameArr) {
        UILabel *_label_name = (UILabel *)obj;
        [_label_name removeFromSuperview];
    }
    [_allMemberNameArr removeAllObjects];

}

- (void)removeMemberAtIndex:(NSInteger)pos
{
    TSTouchImageView *_tsTouchImg = (TSTouchImageView *)[_allMemberArr objectAtIndex:pos];
    [_tsTouchImg removeFromSuperview];
}


@end
