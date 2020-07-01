//
//  DiscussListData.h
//  MicroSchool
//
//  Created by jojo on 14-1-30.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscussListData : NSObject
{
    NSMutableArray *discussArray;
    
    NSString *mythreads;
    NSString *myposts;
}

+(DiscussListData*)sharedDiscussListDataSingleton;

-(BOOL)setDiscussArray:(NSMutableArray*)dic;
-(NSMutableArray*)getDiscussArray;

@end
