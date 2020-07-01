//
//  TeacherApplyTableViewCell.m
//  MicroSchool
//
//  Created by CheungStephen on 8/6/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "TeacherApplyTableViewCell.h"

#import "Masonry.h"
#import "Utilities.h"

@implementation TeacherApplyTableViewCell

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
        _nameLabel = [UILabel new];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _nameLabel.font = [UIFont systemFontOfSize:14.0f];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textColor = [[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0];
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset([Utilities transformationHeight:18]);
            make.left.equalTo(self.contentView.mas_left).with.offset([Utilities transformationWidth:10]);
            
            make.width.mas_equalTo([Utilities transformationWidth:70]);
            make.height.mas_equalTo([Utilities transformationHeight:16]);
        }];
        
        _commentLabel = [UILabel new];
        _commentLabel.backgroundColor = [UIColor clearColor];
        _commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _commentLabel.font = [UIFont systemFontOfSize:14.0f];
        _commentLabel.numberOfLines = 0;
        _commentLabel.textColor = [[UIColor alloc] initWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0];
        [self addSubview:_commentLabel];
        [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.mas_top).with.offset(0);
            make.left.equalTo(self.contentView.mas_left).with.offset([Utilities transformationWidth:90]);
            make.right.equalTo(self.mas_right).with.offset(-[Utilities transformationWidth:20]);
//            make.width.mas_equalTo([Utilities transformationWidth:70]);

//            make.height.mas_equalTo([Utilities transformationHeight:16]);
        }];
        
    }
    
    return self;
}


@end
