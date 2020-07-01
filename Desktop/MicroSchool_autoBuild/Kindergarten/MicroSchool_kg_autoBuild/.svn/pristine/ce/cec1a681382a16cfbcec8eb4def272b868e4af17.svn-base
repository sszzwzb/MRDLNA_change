
//The MIT License (MIT)
//
//Copyright (c) 2013 Rafał Augustyniak
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

#import <Foundation/Foundation.h>

@interface RADataObject : NSObject

@property (strong, nonatomic) NSMutableArray *children;
@property (assign, nonatomic) BOOL isSelected;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *idNumber;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *node;
//Chenth 2.28
@property (strong, nonatomic) NSString *sid;

// 是否是可编辑，1为可编辑，0为不可编辑
@property (assign, nonatomic) BOOL editable;

// 群成员数量
@property (strong, nonatomic) NSString *member;

- (id)initWithName:(NSString *)name children:(NSArray *)array;
+ (id)dataObjectWithName:(NSString *)name children:(NSMutableArray *)children;

- (id)initWithDic:(NSDictionary *)dic children:(NSMutableArray *)children;
+ (id)dataObjectWithDic:(NSDictionary *)dic children:(NSMutableArray *)children;

- (void)addChild:(id)child;
- (void)removeChild:(id)child;

@end
