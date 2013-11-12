//
//  SettingManager.h
//  PetNews
//
//  Created by fanty on 13-8-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AsyncTask;

@interface SettingManager : NSObject

-(void)checkSqliteVersion;

-(AsyncTask*)fileUpload:(NSData*)data type:(NSString*)type;

-(NSArray*)countryList;

@end
