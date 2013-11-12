//
//  User.m
//  PetNews
//
//  Created by fanty on 13-8-7.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "PetUser.h"
#import "pinyin.h"

@implementation PetUser

@synthesize uid;
@synthesize account;
@synthesize accountType;
@synthesize nickname;
@synthesize imageHeadUrl;
@synthesize address;
@synthesize person_desc;
@synthesize sex;
@synthesize petType;
@synthesize pet_sex;

@synthesize password;
@synthesize age;
@synthesize bind_phone;
@synthesize bind_email;
@synthesize bind_weibo;
@synthesize online;
@synthesize province;
@synthesize city;
@synthesize area;
@synthesize street;
@synthesize property;
@synthesize whetherInContact;
@synthesize dictance;
@synthesize token;
@synthesize key;
-(id)init{
    self=[super init];
    
    if(self){
        self.online=YES;
        self.sex=YES;
        self.key=@"";
    }
    
    return self;
}

-(void)dealloc{
    self.uid=nil;
    self.account=nil;
    self.accountType=nil;
    self.nickname=nil;
    self.imageHeadUrl=nil;
    self.address=nil;
    self.person_desc=nil;
    self.address=nil;
    self.password=nil;
    self.bind_phone=nil;
    self.bind_email=nil;
    self.bind_weibo=nil;
    self.province=nil;
    self.city=nil;
    self.area=nil;
    self.street=nil;
    self.property=nil;
    self.dictance=nil;
    self.token=nil;
    self.key=nil;
        
    [super dealloc];
}

-(void)setNickname:(NSString *)value{
    [nickname release];
    nickname=[value retain];
    if([nickname length]>0){
        int __key=[[nickname uppercaseString] characterAtIndex:0];
        if(__key>128){
            __key=[PinYin pinyinFirstLetter:__key];
            self.key=[NSString stringWithFormat:@"%c",[PinYin pinyinFirstLetter:[nickname characterAtIndex:0]] ];
        }
        else{
            self.key=[NSString stringWithFormat:@"%c",__key];
        }
    }
    else{
        self.key=@" ";
    }
}

-(void)copyPet:(PetUser*)petUser{
    self.uid=petUser.uid;
    self.account=petUser.account;
    self.accountType=petUser.accountType;
    self.nickname=petUser.nickname;
    self.imageHeadUrl=petUser.imageHeadUrl;
    self.password=petUser.password;
    self.age=petUser.age;
    self.bind_phone=petUser.bind_phone;
    self.bind_email=petUser.bind_email;
    self.bind_weibo=petUser.bind_weibo;
    self.online=petUser.online;
    self.province=petUser.province;
    self.city=petUser.city;
    self.area=petUser.area;
    self.street=petUser.street;
    self.property=petUser.property;
    self.address=petUser.address;
    self.person_desc=petUser.person_desc;
    self.sex=petUser.sex;
    self.petType=petUser.petType;
    self.pet_sex=petUser.pet_sex;
    self.dictance=petUser.dictance;
    self.whetherInContact=petUser.whetherInContact;
}

@end
