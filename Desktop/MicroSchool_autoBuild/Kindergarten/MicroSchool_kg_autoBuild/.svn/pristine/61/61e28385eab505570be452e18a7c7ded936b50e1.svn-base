//
//  MyClassTableViewCell.m
//  MicroSchool
//
//  Created by jojo on 14-1-14.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "MyClassTableViewCell.h"

@implementation MyClassTableViewCell

@synthesize className;
@synthesize imgView_thumb,isJoined,index,classID,delegate,flag;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // 名字
        label_className = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   15,
                                                                   10,
                                                                   200,
                                                                   30)];
        label_className.lineBreakMode = NSLineBreakByWordWrapping;
        label_className.font = [UIFont systemFontOfSize:17.0f];
        label_className.numberOfLines = 0;
        label_className.textColor = [UIColor blackColor];
        label_className.backgroundColor = [UIColor clearColor];
        label_className.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label_className];

        
        if (isOSVersionLowwerThan(@"7.0")){
            imgView_thumb =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                        260,
                                                                        17,
                                                                        20,
                                                                        20)];
        }else{
            imgView_thumb =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                        280,
                                                                        17,
                                                                        20,
                                                                        20)];
        }
        
        
        imgView_thumb.contentMode = UIViewContentModeScaleToFill;
//        imgView_thumb.layer.masksToBounds = YES;
//        imgView_thumb.layer.cornerRadius = 22.5f;
        [self.contentView addSubview:imgView_thumb];
//        operateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        operateBtn.frame = CGRectMake(250.0,0.0,63.0,50.0);
//        operateBtn.backgroundColor = [UIColor clearColor];
//        [operateBtn addTarget:self action:@selector(operateClass) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:operateBtn];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//- (void)operateClass {
//    
//     NSMutableArray *infoArray = [[NSMutableArray alloc]init];
//    if (flag == 1) {
//        [infoArray addObject:classID];
//        [infoArray addObject:[NSString stringWithFormat:@"%d",index]];
//        [infoArray addObject:[NSString stringWithFormat:@"%d",isJoined]];
//    }
//    [delegate operateClassCallback:infoArray];
//}

- (void)setClassName:(NSString *)n {
    if(![n isEqualToString:className]) {
        className = [n copy];
        label_className.text = className;
    }
}

@end
