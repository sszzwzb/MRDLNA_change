//
//  TeacherApplyHeaderTableViewCell.m
//  MicroSchool
//
//  Created by CheungStephen on 8/8/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "TeacherApplyHeaderTableViewCell.h"

#import "Masonry.h"
#import "Utilities.h"

@implementation TeacherApplyHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        _headImageView = [UIImageView new];
        _headImageView.backgroundColor = [UIColor clearColor];
        _headImageView.contentMode = UIViewContentModeScaleToFill;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = [Utilities transformationWidth:45]/2;
        [_headImageView setImage:[UIImage imageNamed:@"loading_gray.png"]];
        [self addSubview:_headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset([Utilities transformationHeight:14]);
            make.left.equalTo(self.mas_left).with.offset([Utilities transformationWidth:10]);
            make.size.mas_equalTo(CGSizeMake([Utilities transformationWidth:45],[Utilities transformationHeight:45]));
        }];
        
        _nameLabel = [UILabel new];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:16.0f];
        _nameLabel.textColor = [[UIColor alloc] initWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset([Utilities transformationHeight:14]);
            make.left.equalTo(_headImageView.mas_right).with.offset([Utilities transformationWidth:10]);
            
            make.right.equalTo(self.mas_right).with.offset(-[Utilities transformationWidth:35]);
            make.height.mas_equalTo([Utilities transformationHeight:17]);
        }];
        
        _applyLabel = [UILabel new];
        _applyLabel.backgroundColor = [UIColor clearColor];
        _applyLabel.font = [UIFont systemFontOfSize:13.0f];
         _applyLabel.textColor = [[UIColor alloc] initWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0];
        [self addSubview:_applyLabel];
        [_applyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.mas_bottom).with.offset([Utilities transformationHeight:9]);
            make.left.equalTo(_nameLabel.mas_left).with.offset([Utilities transformationWidth:0]);
            make.right.equalTo(self.mas_right).with.offset(-[Utilities transformationWidth:35]);
            make.height.mas_equalTo([Utilities transformationHeight:14]);
        }];

        _datelineLabel = [UILabel new];
        _datelineLabel.backgroundColor = [UIColor clearColor];
        _datelineLabel.font = [UIFont systemFontOfSize:11.0f];
        _datelineLabel.textColor = [[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0];
        [self addSubview:_datelineLabel];
        [_datelineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_applyLabel.mas_bottom).with.offset([Utilities transformationHeight:9]);
            make.left.equalTo(_nameLabel.mas_left).with.offset([Utilities transformationWidth:0]);
            make.right.equalTo(self.mas_right).with.offset(-[Utilities transformationWidth:35]);
            make.height.mas_equalTo([Utilities transformationHeight:12]);
        }];
        
        _statusLabel = [UILabel new];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.font = [UIFont systemFontOfSize:12.0f];
        _statusLabel.textColor = [[UIColor alloc] initWithRed:0/255.0f green:153/255.0f blue:153/255.0f alpha:1.0];
        [self addSubview:_statusLabel];
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset([Utilities transformationHeight:14]);
//            make.left.equalTo(_nameLabel.mas_right).with.offset([Utilities transformationWidth:0]);
            make.right.equalTo(self.mas_right).with.offset(-[Utilities transformationWidth:10]);
            make.height.mas_equalTo([Utilities transformationHeight:14]);
        }];

    }
    
    return self;
}


@end
