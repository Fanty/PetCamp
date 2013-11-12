//
//  AccountManager.m
//  PetNews
//
//  Created by fanty on 13-8-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "AccountManager.h"
#import "PetUser.h"
#import "SqliteLib.h"
#import "PathUtils.h"
#import "AsyncTask.h"
#import "HTTPRequest.h"
#import "ApiManager.h"
#import "SignUpParser.h"
#import "Utils.h"
#import "MessageParser.h"
#import "AppDelegate.h"

#define   MD5_KEY  @"gtcity3a"

@implementation AccountManager

-(PetUser*)restoreAccount{
    SqliteLib* sqlite=[[SqliteLib alloc] init];
    [sqlite open:[PathUtils localDBSqlite]];
    if([sqlite query:@"select uid,account,accountType,nickname,imageHeadUrl,password,age,bind_phone,bind_email,bind_weibo,online,province,city,area,person_desc,sex,petType,pet_sex,token from tbl_user"] && [sqlite next]){
        PetUser* user=[[[PetUser alloc] init] autorelease];
        user.uid=[sqlite stringValue:0];
        user.account=[sqlite stringValue:1];
        user.accountType=[sqlite stringValue:2];
        user.nickname=[sqlite stringValue:3];
        user.imageHeadUrl=[sqlite stringValue:4];
        user.password=[sqlite stringValue:5];
        user.age=[sqlite longLongValue:6];
        user.bind_phone=[sqlite stringValue:7];
        user.bind_email=[sqlite stringValue:8];
        user.bind_weibo=[sqlite stringValue:9];
        user.online=[sqlite longLongValue:10];
        user.province=[sqlite stringValue:11];
        user.city=[sqlite stringValue:12];
        user.area=[sqlite stringValue:13];
        user.person_desc=[sqlite stringValue:14];
        user.sex=[sqlite longLongValue:15];
        user.petType=[sqlite longLongValue:16];
        user.pet_sex=[sqlite longLongValue:17];
        user.token=[sqlite stringValue:18];

        
        [sqlite release];
        return user;
    }
    [sqlite release];
    
    return nil;
}

-(void)saveAccount:(PetUser*)user{
    SqliteLib* sqlite=[[SqliteLib alloc] init];
    [sqlite open:[PathUtils localDBSqlite]];
    [sqlite execute:@"delete from tbl_user"];
    if(user!=nil){
        [sqlite prepare:@"insert into tbl_user (uid,account,accountType,nickname,imageHeadUrl,password,age,bind_phone,bind_email,bind_weibo,online,province,city,area,person_desc,sex,petType,pet_sex,token) values(:uid,:account,:accountType,:nickname,:imageHeadUrl,:password,:age,:bind_phone,:bind_email,:bind_weibo,:online,:province,:city,:area,:person_desc,:sex,:petType,:pet_sex,:token)" ];
        [sqlite bind:user.uid index:0];
        [sqlite bind:user.account index:1];
        [sqlite bind:user.accountType index:2];
        [sqlite bind:user.nickname index:3];
        [sqlite bind:user.imageHeadUrl index:4];
        [sqlite bind:user.password index:5];
        [sqlite bindInt:user.age index:6];
        [sqlite bind:user.bind_phone index:7];
        [sqlite bind:user.bind_email index:8];
        [sqlite bind:user.bind_weibo index:9];
        [sqlite bindInt:(user.online?1:0) index:10];
        [sqlite bind:user.province index:11];
        [sqlite bind:user.city index:12];
        [sqlite bind:user.area index:13];
        [sqlite bind:user.person_desc index:14];
        [sqlite bindInt:(user.sex?1:0) index:15];
        [sqlite bindInt:user.petType index:16];
        [sqlite bindInt:(user.pet_sex?1:0) index:17];
        [sqlite bind:user.token index:18];

        [sqlite finalize];

        
    }

    [sqlite release];
}

-(AsyncTask*)checkSocialAccount:(NSString*)account type:(NSString*)type{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.request=[HTTPRequest requestWithURL:[ApiManager checkSocialAccount:account type:type]];
    
    SignUpParser* parser=[[SignUpParser alloc] init];
    parser.checkUserExists=YES;
    
    task.parser=parser;
    
    [parser release];
    [task start];

    return task;
}

-(AsyncTask*)signupSocial:(NSString*)account type:(NSString*)type nickname:(NSString*)nickname image:(NSString*)image{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.parser=[[[SignUpParser alloc] init] autorelease];

    FormDataRequest* request=[FormDataRequest requestWithURL:[ApiManager signupSocial]];
    [request setPostValue:account forKey:@"account"];
    [request setPostValue:type forKey:@"type"];
    [request setPostValue:nickname forKey:@"nickname"];
    [request setPostValue:image forKey:@"image"];

    task.request=request;
    [task start];
    return task;

}

-(AsyncTask*)loginSocial:(NSString*)account type:(NSString*)type latitude:(float)latitude longitude:(float)longitude{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.parser=[[[SignUpParser alloc] init] autorelease];
    
    FormDataRequest* request=[FormDataRequest requestWithURL:[ApiManager loginSocial]];
    [request setPostValue:account forKey:@"account"];
    [request setPostValue:type forKey:@"type"];
    [request setPostValue:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
    [request setPostValue:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
    
    NSString* verifier=[account stringByAppendingString:MD5_KEY];
    verifier=[Utils md5:verifier];
    [request setPostValue:verifier forKey:@"verifier"];

    task.request=request;
    [task start];

    return task;

}

-(AsyncTask*)signup:(PetUser*)petUser password:(NSString*)password{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.parser=[[[SignUpParser alloc] init] autorelease];
    
    FormDataRequest* request=[FormDataRequest requestWithURL:[ApiManager signup]];
    
    [request setPostValue:petUser.bind_phone forKey:@"phone"];
    [request setPostValue:petUser.nickname forKey:@"nickname"];
    [request setPostValue:petUser.bind_email forKey:@"email"];
    [request setPostValue:[NSString stringWithFormat:@"%d",petUser.age] forKey:@"age"];
    [request setPostValue:petUser.sex?@"f":@"m" forKey:@"sex"];
    [request setPostValue:petUser.province forKey:@"province"];
    [request setPostValue:petUser.city forKey:@"city"];
    [request setPostValue:petUser.area forKey:@"area"];
    [request setPostValue:petUser.street forKey:@"street"];
    [request setPostValue:petUser.property forKey:@"property"];
    [request setPostValue:petUser.person_desc forKey:@"description"];
    [request setPostValue:petUser.imageHeadUrl forKey:@"image"];
    [request setPostValue:petUser.pet_sex?@"f":@"m" forKey:@"pet_sex"];
    
    [request setPostValue:(petUser.petType==PetUserPetTypeDog)?@"1":@"0" forKey:@"pet_dog"];
    [request setPostValue:(petUser.petType==PetUserPetTypeCat)?@"1":@"0" forKey:@"pet_cat"];
    [request setPostValue:(petUser.petType==PetUserPetTypeOther)?@"1":@"0" forKey:@"pet_other"];

    [request setPostValue:password forKey:@"password"];

    task.request=request;
    [task start];
    
    return task;

}

-(AsyncTask*)login:(NSString*)phone password:(NSString*)password latitude:(float)latitude longitude:(float)longitude{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.parser=[[[SignUpParser alloc] init] autorelease];
    
    FormDataRequest* request=[FormDataRequest requestWithURL:[ApiManager login]];
    [request setPostValue:phone forKey:@"phone"];
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
    [request setPostValue:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
    task.request=request;
    [task start];
    
    return task;
}

-(AsyncTask*)updatePassword:(NSString*)oldPassword  newPassword:(NSString*)newPassword{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.parser=[[[XmlParser alloc] init] autorelease];
    
    FormDataRequest* request=[FormDataRequest requestWithURL:[ApiManager updatePassword]];
    [request setPostValue:oldPassword forKey:@"oldPassword"];
    [request setPostValue:newPassword forKey:@"newPassword"];
    task.request=request;
    [task start];
    
    return task;

}


-(AsyncTask*)updateProfile:(PetUser*)petUser{

    AsyncTask* task = [[[AsyncTask alloc] init] autorelease];
    task.parser=[[[XmlParser alloc] init] autorelease];
    
    FormDataRequest* request=[FormDataRequest requestWithURL:[ApiManager updateProfile]];

    [request setPostValue:petUser.nickname forKey:@"nickname"];
    [request setPostValue:petUser.bind_email forKey:@"email"];
    [request setPostValue:petUser.sex?@"f":@"m" forKey:@"sex"];
    [request setPostValue:petUser.province forKey:@"province"];
    [request setPostValue:petUser.city forKey:@"city"];
    [request setPostValue:petUser.area forKey:@"area"];
    [request setPostValue:petUser.street forKey:@"street"];
    [request setPostValue:petUser.property forKey:@"property"];
    if([petUser.address length]>0)
        [request setPostValue:petUser.address forKey:@"address"];
    if([petUser.person_desc length]>0)
        [request setPostValue:petUser.person_desc forKey:@"user_description"];
    [request setPostValue:petUser.imageHeadUrl forKey:@"image"];
    [request setPostValue:petUser.pet_sex?@"f":@"m" forKey:@"pet_gender"];
    [request setPostValue:petUser.bind_weibo forKey:@"bind_weibo"];
    [request setPostValue:(petUser.petType==PetUserPetTypeDog)?@"1":@"0" forKey:@"pet_dog"];
    [request setPostValue:(petUser.petType==PetUserPetTypeCat)?@"1":@"0" forKey:@"pet_cat"];
    [request setPostValue:(petUser.petType==PetUserPetTypeOther)?@"1":@"0" forKey:@"pet_other"];
    [request setPostValue:petUser.online?@"1":@"0" forKey:@"online"];

    task.request=request;
    [task start];

    return task;
}

@end
