//
//  ThreadTask.h
//  SVW_STAR
//
//  Created by fanty on 13-5-29.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^ThredTaskBlock)(void);

@interface ThreadTask : NSObject{
    ThredTaskBlock startBlock;
    ThredTaskBlock finishBlock;
    BOOL skipFinish;
    NSThread* thread;

}
@property(nonatomic,retain) id result;
-(void)cancel;
-(BOOL)isCancel;
+(ThreadTask*)asyncStart:(ThredTaskBlock)start end:(ThredTaskBlock)finish;

-(void)start:(ThredTaskBlock)start end:(ThredTaskBlock)finish;

@end
