
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

#import "RADataObject.h"

@implementation RADataObject


- (id)initWithName:(NSString *)name children:(NSMutableArray *)children
{
  self = [super init];
  if (self) {
    self.children = [NSMutableArray arrayWithArray:children];
    self.name = name;
    self.isSelected = NO;
  }
  return self;
}

+ (id)dataObjectWithName:(NSString *)name children:(NSMutableArray *)children
{
  return [[self alloc] initWithName:name children:children];
}

- (id)initWithDic:(NSDictionary *)dic children:(NSMutableArray *)children
{
    self = [super init];
    if (self) {
        self.children = [NSMutableArray arrayWithArray:children];
        
        self.name = [dic objectForKey:@"name"];
        self.avatar = [dic objectForKey:@"avatar"];
        self.idNumber = [dic objectForKey:@"id"];
        self.node = [dic objectForKey:@"node"];
        self.sid = [dic objectForKey:@"sid"];

        if (nil != [dic objectForKey:@"isSelected"]) {
            self.isSelected = ((NSString *)[dic objectForKey:@"isSelected"]).intValue;
        }else {
            self.isSelected = NO;
        }
        
        if (nil != [dic objectForKey:@"editable"]) {
            self.editable = ((NSString *)[dic objectForKey:@"editable"]).intValue;
        }else {
            self.editable = YES;
        }
        
        self.member = [dic objectForKey:@"member"];
    }
    return self;
}

+ (id)dataObjectWithDic:(NSDictionary *)dic children:(NSMutableArray *)children
{
    return [[self alloc] initWithDic:dic children:children];
}

- (void)addChild:(id)child
{
  NSMutableArray *children = [self.children mutableCopy];
  [children insertObject:child atIndex:0];
  self.children = [children copy];
}

- (void)removeChild:(id)child
{
  NSMutableArray *children = [self.children mutableCopy];
  [children removeObject:child];
  self.children = [children copy];
}

@end
