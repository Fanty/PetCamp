//
//  ThreadTask.m
//  SVW_STAR
//
//  Created by fanty on 13-5-29.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ThreadTask.h"

@interface ThreadTask(private)
-(void)clear;
-(void)runBackgroundThread;
-(void)end;
@end

@implementation ThreadTask


-(id)init{
    self=[super init];
    return self;
}

+(ThreadTask*)asyncStart:(ThredTaskBlock)start end:(ThredTaskBlock)finish{
    ThreadTask* task=[[[ThreadTask alloc] init] autorelease];
    [task start:start end:finish];
    return task;
}

-(void)dealloc{
    self.result=nil;
    [self clear];
    [super dealloc];
}

-(void)clear{
    [thread release];
    [startBlock release];
    [finishBlock release];

    thread=nil;
    startBlock=nil;
    finishBlock=nil;
    self.result=nil;
}

-(void)start:(ThredTaskBlock)start end:(ThredTaskBlock)finish{
    [self clear];
    
    startBlock=[start copy];
    finishBlock=[finish copy];
    thread = [[NSThread alloc] initWithTarget:self selector:@selector(runBackgroundThread) object:nil];
    
    [thread start];
}


-(void)cancel{
    skipFinish=YES;
    [finishBlock release];
    finishBlock=nil;
}

-(BOOL)isCancel{
    return skipFinish;
}

-(void)end{
    NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
    
    if(!skipFinish && finishBlock!=nil)
        finishBlock();
    [self clear];
    [pool release];
    
}


-(void)runBackgroundThread{
    NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
    startBlock();
    
    [pool release];
    [self performSelectorOnMainThread:@selector(end) withObject:nil waitUntilDone:NO];
    
}


@end
