//
//  KnowledgeHotWikiModel.h
//  MicroSchool
//
//  Created by jojo on 15/2/9.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Mantle/Mantle.h"

@interface KnowledgeHotWikiModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *protocol;
@property (nonatomic, strong) NSNumber *result;

@property (nonatomic, retain) NSDictionary *message;

@property (nonatomic, retain) NSArray *list;

@property (nonatomic, retain) NSArray *categories;
@property (nonatomic, retain) NSArray *courses;
@property (nonatomic, retain) NSArray *grades;

@end
