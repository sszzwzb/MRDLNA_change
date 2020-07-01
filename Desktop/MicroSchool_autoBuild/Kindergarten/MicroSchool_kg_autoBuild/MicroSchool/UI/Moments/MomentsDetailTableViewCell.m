//
//  MomentsDetailTableViewCell.m
//  MicroSchool
//
//  Created by jojo on 14/12/29.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "MomentsDetailTableViewCell.h"

@implementation MomentsDetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Initialization code
        _ohAttributeLabel = [[TSAttributedLabel alloc] initWithFrame:CGRectMake(
                                                                                1,
                                                                                4,
                                                                                3,
                                                                                3)];
        _ohAttributeLabel.backgroundColor = [UIColor clearColor];
        _ohAttributeLabel.dataDetectorTypes = MLDataDetectorTypeNone;
        _ohAttributeLabel.userInteractionEnabled = YES;
        
      
        _longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu:)];
        _longPressRecognizer.delegate = self;
        [_longPressRecognizer setMinimumPressDuration:1.0];
        [_ohAttributeLabel addGestureRecognizer:_longPressRecognizer];

        [self.contentView addSubview:_ohAttributeLabel];
        
        _textParser = [[MarkupParser alloc] init];
        
        _imgView_bottomLime =[[UIImageView alloc]initWithFrame:CGRectZero];
        _imgView_bottomLime.image=[UIImage imageNamed:@"knowledge/tm.png"];
        [self.contentView addSubview:_imgView_bottomLime];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setFlag:(NSInteger)flag{
    
    
    _flag =  flag;
    
    if (flag == 1) {
        _ohAttributeLabel.delegate_TS = self;//2015.12.14
        self.backgroundColor = [UIColor whiteColor];
    }
    
}

- (void)disableLongTouchAction {
    [_ohAttributeLabel removeGestureRecognizer:_longPressRecognizer];
}

- (void)disableTouchAction {
    _ohAttributeLabel.userInteractionEnabled = NO;
}

//---添加复制功能菜单---------------------------------------------------
-(void)showMenu:(UIGestureRecognizer*)gestureRecognizer{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        //NSLog(@"UIGestureRecognizerStateBegan");
        
        [self becomeFirstResponder];
        
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [menuController setMenuVisible:NO];
        
        if ([self.ohAttributeLabel.msgUid isEqual: [Utilities getUniqueUid]]) {
            UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuCopy:)];
//            UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(menuDelete:)];
            
//            [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1, menuItem2, nil]];
            [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1, nil]];

        }else {
            UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuCopy:)];
            [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1, nil]];
        }

//        UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuCopy:)];
//        [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1,nil]];
        [menuController setTargetRect:gestureRecognizer.view.frame inView:self];
        [menuController setMenuVisible:YES animated:YES];
    }
}

-(void)menuDelete:(UIMenuController *)menuController{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         _ohAttributeLabel.msgPid, @"pid",
                         _ohAttributeLabel.msgUid, @"uid",
                         _ohAttributeLabel.msgPos, @"msgPos",
                         _ohAttributeLabel.cellNum, @"cellNum",
                         _ohAttributeLabel.msgTid, @"tid",
                         nil];
    
    if (_flag == 1) {//删除一条评论
        [_delegate deleteComment:dic];//2015.12.14
    }else{
        
//        [menuController setMenuVisible:NO animated:YES];

       [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_momentsClickRemoveComment" object:self userInfo:dic];
    }
    
}


// 复制
-(void)menuCopy:(UIMenuController *)menuController{
    NSString *content = _ohAttributeLabel.msgComment;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:content];
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(menuCopy:) ||
        action == @selector(menuDelete:))
    {
        return YES;
    }else{
        return NO;
    }
}

// 点击名字进入个人详情
-(void)clickName:(NSDictionary *)dic{
    
    [_delegate clickUserName:dic];
}

// 点击整条评论
-(void)clickLabel:(NSDictionary *)dic{
    
    [_delegate clickComment:dic];
}

@end
