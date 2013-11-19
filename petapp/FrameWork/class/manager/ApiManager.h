//
//  ApiManager.h
//  PetNews
//
//  Created by fanty on 13-8-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiManager : NSObject

+(NSURL*)checkSocialAccount:(NSString*)account type:(NSString*)type;

+(NSURL*)signupSocial;

+(NSURL*)loginSocial;

+(NSURL*)signup;

+(NSURL*)login;

+(NSURL*)fileUpload;

+(NSURL*)petNewsList:(int)offset;

+(NSURL*)petNewsDetail:(NSString*)pid;

+(NSURL*)createPetNews;

+(NSURL*)myPetNewsList:(NSString*)token;

+(NSURL*)petNewsCommentList:(NSString*)pid offset:(int)offset;

+(NSURL*)createPetNewsComment;

+(NSURL*)likePost;

+(NSURL*)updatePassword;

+(NSURL*)createActivity;

+(NSURL*)joinActivity;

+(NSURL*)createActivityComment;

+(NSURL*)activityList:(int)offset;

+(NSURL*)activtyDetail:(NSString*)aid;

+(NSURL*)activtyCommentList:(NSString*)aid offset:(int)offset;

+(NSURL*)myBoardList:(int)offset token:(NSString*)token;

+(NSURL*)createBoard;

+(NSURL*)friendList:(NSString*)token groupId:(NSString*)groupId;

+(NSURL*)makeFriend;

+(NSURL*)userDetail:(NSString*)uid token:(NSString*)token;

+(NSURL*)nearUser:(float)longitude latitude:(float)latitude offset:(int)offset token:(NSString*)token;

+(NSURL*)groupList:(NSString*)token;

+(NSURL*)fansList:(NSString*)token;



+(NSURL*)createGroup;

+(NSURL*)addGroupUser;

+(NSURL*)addGroupUsers;

+(NSURL*)myJoinActivaty:(NSString*)token;

+(NSURL*)updateProfile;

+(NSURL*)adBannerList:(NSString*)type;

+(NSURL*)storeItemList:(NSString*)type_id offset:(int)offset;

+(NSURL*)searchGroup:(NSString*)keyword offset:(int)offset;

+(NSURL*)searchUser:(NSString*)keyword offset:(int)offset;

+(NSURL*)petNewsListByUser:(NSString*)uid token:(NSString*)token offset:(int)offset;

+(NSURL*)deletePost;

+(NSURL*)deleteActivity;

+(NSURL*)serviceApi;

+(NSURL*)privacyApi;

+(NSURL*)addStoreItemPageview:(NSString*)mid;

+(NSURL*)storeTypeListApi;

+(NSURL*)forgetPasswordApi;


@end
