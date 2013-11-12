//
//  MarketManager.h
//  PetNews
//
//  Created by fanty on 13-8-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AsyncTask;

@interface MarketManager : NSObject

-(AsyncTask*)storeItemList:(int)offset;

-(AsyncTask*)addStoreItemPageview:(NSString*)mid;

@end
