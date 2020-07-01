//
//  DiscussListData.m
//  MicroSchool
//
//  Created by jojo on 14-1-30.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "DiscussListData.h"

@implementation DiscussListData

-(id)init{
    self = [super init];
    if(self){
        discussArray = [NSMutableArray alloc];
        mythreads = @"0";
        myposts = @"0";
    }
    return self;
}

+(DiscussListData*)sharedDiscussListDataSingleton
{
    static DiscussListData *sharedDiscussListDataSingleton;
    @synchronized(self)
    {
        if (!sharedDiscussListDataSingleton)
            sharedDiscussListDataSingleton = [[DiscussListData alloc] init];
        return sharedDiscussListDataSingleton;
    }
}

-(BOOL)setDiscussArray:(NSMutableArray*)dic
{
    discussArray = dic;
    return true;
}

-(NSMutableArray*)getDiscussArray
{
    return discussArray;
}

@end

