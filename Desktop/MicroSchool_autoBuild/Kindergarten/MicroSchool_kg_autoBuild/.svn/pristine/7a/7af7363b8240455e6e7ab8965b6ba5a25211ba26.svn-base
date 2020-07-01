
//The MIT License (MIT)
//
//Copyright (c) 2014 Rafał Augustyniak
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of
//this software and associated documentation files (the "Software"), to deal in
//the Software without restriction, including without limitation the rights to
//use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//the Software, and to permit persons to whom the Software is furnished to do so,
//subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "RATableViewCell.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface RATableViewCell ()


@end

@implementation RATableViewCell

- (void)awakeFromNib
{
  [super awakeFromNib];
  
  self.selectedBackgroundView = [UIView new];
  self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
  
    
    [self.additionButton setImage:[UIImage imageNamed:@"notSelect.png"] forState:UIControlStateNormal];

    _customTitleLabel.frame = CGRectMake(10, (44-21)/2, 250, 21);
    
    _label_number = [[UILabel alloc] initWithFrame:CGRectZero];
    _label_number.lineBreakMode = NSLineBreakByWordWrapping;
    _label_number.font = [UIFont systemFontOfSize:15.0f];
    _label_number.textColor = [UIColor grayColor];
    _label_number.backgroundColor = [UIColor clearColor];
    _label_number.textAlignment = NSTextAlignmentRight;
    _label_number.hidden = YES;
    [self.contentView addSubview:_label_number];

    _imageView_arrow =[[UIImageView alloc]initWithFrame:CGRectMake(10, (44-10)/2, 10, 10)];
    _imageView_arrow.contentMode = UIViewContentModeScaleToFill;
    _imageView_arrow.hidden = YES;
    [self.contentView addSubview:_imageView_arrow];

    _imageView_head =[[UIImageView alloc]initWithFrame:CGRectMake(10, (44-30)/2, 30, 30)];
    _imageView_head.contentMode = UIViewContentModeScaleToFill;
//    _imageView_head.hidden = YES;
    _imageView_head.layer.masksToBounds = YES;
    _imageView_head.layer.cornerRadius = 30/2;
    [self.contentView addSubview:_imageView_head];

}

- (void)prepareForReuse
{
  [super prepareForReuse];
  
  self.additionButtonHidden = NO;
}


- (void)setupWithTitle:(NSString *)title detailText:(NSString *)detailText level:(NSInteger)level additionButtonHidden:(BOOL)additionButtonHidden hasChildren:(BOOL)hasChildren isPerson:(NSString *)isPerson
{
  self.customTitleLabel.text = title;
  self.detailedLabel.text = detailText;
  self.additionButtonHidden = additionButtonHidden;
  
  if (level == 0) {
    self.detailTextLabel.textColor = [UIColor blackColor];
  }
  
//  if (level == 0) {
//    self.backgroundColor = UIColorFromRGB(0xF7F7F7);
//  } else if (level == 1) {
//    self.backgroundColor = UIColorFromRGB(0xD1EEFC);
//  } else if (level >= 2) {
//    self.backgroundColor = UIColorFromRGB(0xE0F8D8);
//  }
  
  CGFloat left = 11 + 20 * level;
    if ((![@"person"  isEqual: isPerson]) && (![@"group"  isEqual: isPerson])) {
        CGRect arrowFrame = self.imageView_arrow.frame;
        arrowFrame.origin.x = left;
        self.imageView_arrow.frame = arrowFrame;
        
        CGRect titleFrame = self.customTitleLabel.frame;
        titleFrame.origin.x = arrowFrame.origin.x + arrowFrame.size.width+8;
        self.customTitleLabel.frame = titleFrame;
    }else {
        CGRect headFrame = self.imageView_head.frame;
        headFrame.origin.x = left;
        self.imageView_head.frame = headFrame;

        CGRect titleFrame = self.customTitleLabel.frame;
        titleFrame.origin.x = headFrame.origin.x + headFrame.size.width+8;
        self.customTitleLabel.frame = titleFrame;
    }
    
    
    
  
//  CGRect detailsFrame = self.detailedLabel.frame;
//  detailsFrame.origin.x = left;
//  self.detailedLabel.frame = detailsFrame;
}


#pragma mark - Properties

- (void)setAdditionButtonHidden:(BOOL)additionButtonHidden
{
  [self setAdditionButtonHidden:additionButtonHidden animated:NO];
}

- (void)setAdditionButtonHidden:(BOOL)additionButtonHidden animated:(BOOL)animated
{
  _additionButtonHidden = additionButtonHidden;
  [UIView animateWithDuration:animated ? 0.2 : 0 animations:^{
    self.additionButton.hidden = additionButtonHidden;
  }];
}


#pragma mark - Actions

- (IBAction)additionButtonTapped:(id)sender
{
  if (self.additionButtonTapAction) {
    self.additionButtonTapAction(sender);
  }
//    if (!self.isSelected) {
//        [self.additionButton setImage:[UIImage imageNamed:@"checkImg_press.png"] forState:UIControlStateNormal];
//        self.isSelected = YES;
//    }else {
//        [self.additionButton setImage:[UIImage imageNamed:@"checkImg_normal.png"] forState:UIControlStateNormal];
//        self.isSelected = NO;
//    }
}

@end
