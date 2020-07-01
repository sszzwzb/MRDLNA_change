//
//  TSPopupItem.h
//  MicroSchool
//
//  Created by CheungStephen on 7/15/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import <Foundation/Foundation.h>

// popup点击之后的block回调
typedef void(^TSPopupItemHandler)(NSInteger index, NSString *btnTitle);

// popup的显示的类型
typedef NS_ENUM(NSUInteger, TSItemType) {
    TSItemTypeNormal,
    TSItemTypeHighlight,
    TSItemTypeDisabled
};
@interface TSPopupItem : NSObject

@property (nonatomic, assign) BOOL     highlight;
@property (nonatomic, assign) BOOL     disabled;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) TSItemType type;

//@property (nonatomic, strong) UIColor  *color;

@property (nonatomic, copy)   TSPopupItemHandler handler;

@end

NS_INLINE TSPopupItem* TSItemMake(NSString* title, TSItemType type, TSPopupItemHandler handler)
{
    TSPopupItem *item = [TSPopupItem new];
    
    item.title = title;
    item.type = type;
    
    item.handler = handler;
    
    switch (type)
    {
        case TSItemTypeNormal:
        {
            break;
        }
        case TSItemTypeHighlight:
        {
            item.highlight = YES;
            break;
        }
        case TSItemTypeDisabled:
        {
            item.disabled = YES;
            break;
        }
        default:
            break;
    }
    
    return item;
}

