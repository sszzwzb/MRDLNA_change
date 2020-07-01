//
//  KnowledgeCommentTableViewCell.m
//  MicroSchool
//
//  Created by zhanghaotian on 14-3-12.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "KnowledgeCommentTableViewCell.h"
// 屏幕高度
#define HEIGHT [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation KnowledgeCommentTableViewCell

@synthesize name;
@synthesize school;
@synthesize time;
@synthesize comment;
@synthesize pid;
@synthesize label_comment;
@synthesize label_time;

@synthesize imgView_head;

@synthesize button_cancelSubscribe;
@synthesize btn_thumb;

@synthesize subuid;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _textParser = [[MarkupParser alloc] init];

        // 头像
        btn_thumb = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_thumb.frame = CGRectMake(
                                     20,
                                     (80 - 50)/2,
                                     50,
                                     50);
        [btn_thumb addTarget:self action:@selector(thumb_btnclick:) forControlEvents:UIControlEventTouchDown];
        btn_thumb.layer.masksToBounds = YES;
        btn_thumb.layer.cornerRadius = 50/2;
        btn_thumb.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:btn_thumb];

//        imgView_head = [[UIImageView alloc]initWithFrame:CGRectMake(
//                                                                    20,
//                                                                    (80 - 50)/2,
//                                                                    50,
//                                                                    50)];
//        imgView_head.contentMode = UIViewContentModeScaleToFill;
//        imgView_head.layer.masksToBounds = YES;
//        imgView_head.layer.cornerRadius = 50/2;
//        [self.contentView addSubview:imgView_head];
        
        // 姓名
        label_name = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               btn_thumb.frame.origin.x + btn_thumb.frame.size.width + 15,
                                                               btn_thumb.frame.origin.y,
                                                               WIDTH - 75 - 30,
                                                               15)];
        
        //设置title自适应对齐
        //label_name.lineBreakMode = NSLineBreakByWordWrapping;
        label_name.font = [UIFont systemFontOfSize:13.0f];
        //label_name.numberOfLines = 0;
        label_name.textColor = [UIColor blackColor];
        label_name.backgroundColor = [UIColor clearColor];
        label_name.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_name];
        
        // 时间
        label_time = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                 label_name.frame.origin.x,
                                                                 label_name.frame.origin.y + label_name.frame.size.height,
                                                                 170,
                                                                 15)];
        
        //设置title自适应对齐
        //label_school.lineBreakMode = NSLineBreakByWordWrapping;
        label_time.font = [UIFont systemFontOfSize:11.0f];
        label_time.textColor = [UIColor grayColor];
        label_time.backgroundColor = [UIColor clearColor];
        label_time.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_time];
        
#if 0
        // 内容
        label_comment = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                  label_time.frame.origin.x,
                                                                  label_time.frame.origin.y + label_time.frame.size.height,
                                                                  WIDTH - 75 - 35 - 15,
                                                                  30)];
        
        //设置title自适应对齐
        //label_content.lineBreakMode = NSLineBreakByWordWrapping;
        label_comment.font = [UIFont systemFontOfSize:13.0f];
        label_comment.numberOfLines = 0;
        label_comment.textColor = [UIColor blackColor];
        label_comment.backgroundColor = [UIColor clearColor];
        label_comment.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:label_comment];
#endif

        /*_label = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(
         label_time.frame.origin.x,
         label_time.frame.origin.y + label_time.frame.size.height,
         320 - 75 - 35 - 15,
         30)];
         _label.backgroundColor = [UIColor clearColor];
         [self.contentView addSubview:_label];*/
        
        _label = [[MLLinkLabel alloc] initWithFrame:CGRectMake(1, 4, 3, 3)];
        _label.textColor = [UIColor blackColor];
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont systemFontOfSize:13.0];
        _label.numberOfLines = 0;
        _label.textInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        _label.dataDetectorTypes = MLDataDetectorTypeURL;// 链接 电话 邮箱等显示 可自定义
        
        _label.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor]};
        _label.activeLinkTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor],NSBackgroundColorAttributeName:kDefaultActiveLinkBackgroundColorForMLLinkLabel};
        [self.contentView addSubview:_label];
        //-------------------------------------------------------------------------------------
        // 每条cell最下方的线
        _imgView_line1 =[[UIImageView alloc]initWithFrame:CGRectZero];
        [_imgView_line1 setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
        [self.contentView addSubview:_imgView_line1];
    }
    return self;
}

- (IBAction)thumb_btnclick:(id)sender
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         subuid, @"uid",
                         name, @"name",nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_fromKnowledgeComment2ProfileView" object:self userInfo:dic];

//    if ([_viewName  isEqual: @"friendView"]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_fromFriendView2ProfileView" object:self userInfo:dic];
//    }else if (([_viewName  isEqual: @"friendCommonView"])) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"Weixiao_fromFriendCommonView2ProfileView" object:self userInfo:dic];
//    }
}

- (void)setSchool:(NSString *)n {
    if(![n isEqualToString:school]) {
        school = [n copy];
        label_school.text = school;
    }
}

- (void)setName:(NSString *)n {
    if(![n isEqualToString:name]) {
        name = [n copy];
        label_name.text = name;
    }
}

- (void)setTime:(NSString *)n {
    if(![n isEqualToString:time]) {
        time = [n copy];
        label_time.text = time;
    }
}

- (void)setComment:(NSString *)n {
    if(![n isEqualToString:comment]) {
        comment = [n copy];
        label_comment.text = comment;
    }
}


// 2015.09.18
-(void)setMLLabelText:(NSString*)attributedStr{
    
    MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"/faceImages/expression/emotionImage.plist" bundleName:@"Expression"];//plistName bundleName 需要修改
    
    self.label.attributedText = [attributedStr expressionAttributedStringWithExpression:exp];
    
}
// 2015.09.18
+(CGSize)heightForEmojiText:(NSString*)emojiText
{
    MLExpression *exp = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"/faceImages/expression/emotionImage.plist" bundleName:@"Expression"];//plistName bundleName 需要修改
    
    NSAttributedString *expressionText = [emojiText expressionAttributedStringWithExpression:exp];
    
    MLLinkLabel *label = kProtypeLabel();
    label.attributedText = expressionText;
    
    CGSize size = [label preferredSizeWithMaxWidth:WIDTH - 75 - 35 - 15];//update 2015.08.12
    
    return size;
}
// 2015.09.18
#pragma mark - height
static MLLinkLabel * kProtypeLabel() {
    
    static MLLinkLabel *_protypeLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _protypeLabel = [MLLinkLabel new];
        _protypeLabel.font = [UIFont systemFontOfSize:13.0];
        _protypeLabel.numberOfLines = 0;
        _protypeLabel.textInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        
        
    });
    return _protypeLabel;
}

@end
