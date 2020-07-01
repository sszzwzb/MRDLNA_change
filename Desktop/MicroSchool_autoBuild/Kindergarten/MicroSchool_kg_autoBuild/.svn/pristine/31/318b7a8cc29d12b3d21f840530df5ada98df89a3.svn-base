//
//  SchoolHomeTableViewCell.m
//  MicroSchool
//
//  Created by CheungStephen on 3/15/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "SchoolHomeTableViewCell.h"

@implementation SchoolHomeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _touchedBgImageView = [TSTouchImageView new];
        _touchedBgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _touchedBgImageView.clipsToBounds = YES;
        _touchedBgImageView.userInteractionEnabled = YES;
        _touchedBgImageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_touchedBgImageView];

        _iconImageView = [UIImageView new];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_iconImageView];
        
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.left.equalTo(self.contentView.mas_left).with.offset(10);

            make.size.mas_equalTo(CGSizeMake(17, 17));
        }];

        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [[UIColor alloc] initWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0];
        [self.contentView addSubview:_titleLabel];

        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.left.equalTo(_iconImageView.mas_right).with.offset(10);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-10-10-20, 15));
        }];

        _uploadRecipesButton = [UIButton new];
        _uploadRecipesButton.hidden = YES;
        [_uploadRecipesButton setBackgroundImage:[UIImage imageNamed:@"SchoolHomePics/schoolHomeRecipesUpload_d"] forState:UIControlStateNormal] ;
        [_uploadRecipesButton setBackgroundImage:[UIImage imageNamed:@"SchoolHomePics/schoolHomeRecipesUpload_p"] forState:UIControlStateHighlighted] ;
        [_uploadRecipesButton addTarget:self action:@selector(uploadResipeButtonClick:) forControlEvents: UIControlEventTouchUpInside];

        [self.contentView addSubview:_uploadRecipesButton];
        
        [_uploadRecipesButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(5);
            make.left.equalTo(self.mas_right).with.offset(-60);
            
            make.size.mas_equalTo(CGSizeMake(50, 24));
        }];
        
        _thumbImageView = [UIImageView new];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_thumbImageView];
        
        [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(35);
            make.left.equalTo(self.mas_left).with.offset(10);

            make.size.mas_equalTo(CGSizeMake(90, 90));
        }];
        _thumbImageView.layer.cornerRadius = 5;

        _contentLabel = [UILabel new];
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [[UIColor alloc] initWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_thumbImageView.mas_top).with.offset(10);
            make.left.equalTo(_thumbImageView.mas_right).with.offset(10);
        }];

        _picsNumberLabel = [UILabel new];
        _picsNumberLabel.font = [UIFont systemFontOfSize:12.0f];
        _picsNumberLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _picsNumberLabel.textAlignment = NSTextAlignmentLeft;
        _picsNumberLabel.backgroundColor = [UIColor clearColor];
        _picsNumberLabel.textColor = [[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0];
        [self.contentView addSubview:_picsNumberLabel];
        
        [_picsNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).with.offset(-8);
            make.left.equalTo(_thumbImageView.mas_right).with.offset(10);
            
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-10-10-20, 12));
        }];

//        _thumbImageView = [UIImageView new];
//        _thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
//        [self.contentView addSubview:_thumbImageView];
//        
//        [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_iconImageView.mas_bottom).with.offset([Utilities convertPixs:12]);
//            make.left.equalTo(self.mas_left).with.offset([Utilities convertPixs:10]);
//            make.size.mas_equalTo(CGSizeMake([Utilities convertPixs:90], [Utilities convertPixs:90]));
//        }];

        _downLineImageView = [UIImageView new];
        [_downLineImageView setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
        [self.contentView addSubview:_downLineImageView];
        
        [_downLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).with.offset(0);
            make.left.equalTo(_thumbImageView.mas_right).with.offset(-2);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, 1));
        }];

        _upLineImageView = [UIImageView new];
        [_upLineImageView setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
        [self.contentView addSubview:_upLineImageView];
        
        [_upLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(35);
            make.left.equalTo(_thumbImageView.mas_right).with.offset(-2);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, 1));
        }];

        [_touchedBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_upLineImageView.mas_top).with.offset(-1);
            make.bottom.equalTo(_downLineImageView.mas_top).with.offset(1);
            make.left.equalTo(self.mas_left).with.offset([Utilities convertPixsW:0]);
            
            make.width.mas_equalTo([Utilities getScreenSizeWithoutBar].width);
        }];
        
        TSTapGestureRecognizer *myTapGesture = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(recipesPicDetail:)];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             _recipesInfo, @"recipesInfo",
                             nil];
        
        myTapGesture.infoDic = dic;
        [_touchedBgImageView addGestureRecognizer:myTapGesture];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)uploadResipeButtonClick:(id)sender
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         _cellIndex, @"cellIndex",
                         nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"schoolHomeUploadRecipeButtonClick" object:self userInfo:dic];
}

- (IBAction)recipesPicDetail:(id)sender {
    TSTapGestureRecognizer *tsTap = (TSTapGestureRecognizer *)sender;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"zhixiao_recipesPicDetail" object:self userInfo:_recipesInfo];
}

@end
