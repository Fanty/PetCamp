//
//  AccountManager.h
//  PetNews
//
//  Created by fanty on 13-8-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PetUser;
@class AsyncTask;
@interface AccountManager : NSObject
-(PetUser*)restoreAccount;

-(void)saveAccount:(PetUser*)petUser;

-(AsyncTask*)checkSocialAccount:(NSString*)account type:(NSString*)type;

-(AsyncTask*)signupSocial:(NSString*)account type:(NSString*)type nickname:(NSString*)nickname image:(NSString*)image;

-(AsyncTask*)loginSocial:(NSString*)account type:(NSString*)type latitude:(float)latitude longitude:(float)longitude;

-(AsyncTask*)signup:(PetUser*)petUser password:(NSString*)password;



-(AsyncTask*)login:(NSString*)phone password:(NSString*)password latitude:(float)latitude longitude:(float)longitude;


-(AsyncTask*)updatePassword:(NSString*)oldPassword  newPassword:(NSString*)newPassword;

-(AsyncTask*)updateProfile:(PetUser*)petUser;

@end
