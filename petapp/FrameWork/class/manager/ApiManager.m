//
//  ApiManager.m
//  PetNews
//
//  Created by fanty on 13-8-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ApiManager.h"

#ifdef APP_STORE
#define PREFIX   @"http://112.124.56.146"

#else
#define PREFIX   @"http://petcamp.sinaapp.com"
//#define PREFIX   @"http://112.124.56.146"

#endif

@implementation ApiManager


+(NSURL*)checkSocialAccount:(NSString*)account type:(NSString*)type{
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/user/checkSocialAccount?account=%@&type=%@",PREFIX,account,type]];
}

+(NSURL*)signupSocial{
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/user/registerSocialAccount",PREFIX]];
}

+(NSURL*)loginSocial{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/user/loginSocialAccount",PREFIX]];

}

+(NSURL*)signup{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/user/register",PREFIX]];
}

+(NSURL*)login{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/user/login",PREFIX]];

}

+(NSURL*)fileUpload{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/file/upload",PREFIX]];
    
}

+(NSURL*)petNewsList:(int)offset{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/post/list?offset=%d&offsetcount=%d",PREFIX,offset*HTTP_PAGE_SIZE,HTTP_PAGE_SIZE]];
    
}

+(NSURL*)petNewsDetail:(NSString*)pid{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/post/detail?id=%@",PREFIX,pid]];
}

+(NSURL*)createPetNews{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/post/create",PREFIX]];
    
}

+(NSURL*)myPetNewsList:(NSString*)token{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/post/mylist?token=%@",PREFIX,token]];
    
}

+(NSURL*)petNewsCommentList:(NSString*)pid offset:(int)offset{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/post/commentList?id=%@&offset=%d&offsetcount=%d",PREFIX,pid,offset*HTTP_PAGE_SIZE,HTTP_PAGE_SIZE]];
}

+(NSURL*)createPetNewsComment{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/post/createPostComment",PREFIX]];
}

+(NSURL*)likePost{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/post/likePost",PREFIX]];

}

+(NSURL*)updatePassword{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/user/updatePassword",PREFIX]];

}

+(NSURL*)createActivity{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/activity/createActivity",PREFIX]];
}

+(NSURL*)joinActivity{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/activity/joinActivity",PREFIX]];

}

+(NSURL*)createActivityComment{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/activity/createComment",PREFIX]];

}

+(NSURL*)activityList:(int)offset{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/activity/activtyList?offset=%d&offsetcount=%d",PREFIX,offset*HTTP_PAGE_SIZE,HTTP_PAGE_SIZE]];
    
}

+(NSURL*)activtyDetail:(NSString*)aid{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/activity/activtyDetail?id=%@",PREFIX,aid]];

}

+(NSURL*)activtyCommentList:(NSString*)aid offset:(int)offset{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/activity/commentList?id=%@&offset=%d&offsetcount=%d",PREFIX,aid,offset*HTTP_PAGE_SIZE,HTTP_PAGE_SIZE]];
    
}

+(NSURL*)myBoardList:(int)offset token:(NSString*)token{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/user/myBoardList?token=%@&offset=%d&offsetcount=%d",PREFIX,token,offset*HTTP_PAGE_SIZE,HTTP_PAGE_SIZE]];
    
}

+(NSURL*)createBoard{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/user/createBoard",PREFIX]];
}


+(NSURL*)friendList:(NSString*)token groupId:(NSString*)groupId{
    if([groupId length]<1){
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/user/friendList?token=%@",PREFIX,token]];
    }
    else{
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/petgroup/groupUserList?id=%@&token=%@",PREFIX,groupId,token]];
    }
}

+(NSURL*)makeFriend{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/user/makeFriend",PREFIX]];

}

+(NSURL*)userDetail:(NSString*)uid  token:(NSString*)token{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/user/userDetail?friend_id=%@&token=%@",PREFIX,uid,token]];

}

+(NSURL*)nearUser:(float)longitude latitude:(float)latitude offset:(int)offset token:(NSString*)token{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/user/nearUser?token=%@&longitude=%f&latitude=%f&offset=%d&offsetcount=%d",PREFIX,token,longitude,latitude,offset*HTTP_PAGE_SIZE,HTTP_PAGE_SIZE]];

}

+(NSURL*)groupList:(NSString*)token{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/petgroup/groupList?token=%@",PREFIX,token]];
}

+(NSURL*)fansList:(NSString*)token{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/user/fansList?token=%@",PREFIX,token]];
    
}


+(NSURL*)createGroup{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/petgroup/createGroup",PREFIX]];
}

+(NSURL*)addGroupUser{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/petgroup/addGroupUser",PREFIX]];

}

+(NSURL*)addGroupUsers{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/petgroup/addGroupUsers",PREFIX]];
}

+(NSURL*)myJoinActivaty:(NSString*)token{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/activity/myJoinActiviyList?token=%@",PREFIX,token]];
}

+(NSURL*)updateProfile{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/user/updateProfile",PREFIX]];
}

+(NSURL*)adBannerList:(NSString*)type{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/ad/adBannerList?type=%@",PREFIX,type]];

}

+(NSURL*)storeItemList:(NSString*)type_id offset:(int)offset{
    if([type_id length]>0)
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/store/storeItemList?type_id=%@&offset=%d&offsetcount=%d",PREFIX,type_id,offset*HTTP_PAGE_SIZE,HTTP_PAGE_SIZE]];
    else
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/store/storeItemList?offset=%d&offsetcount=%d",PREFIX,offset*HTTP_PAGE_SIZE,HTTP_PAGE_SIZE]];

}

+(NSURL*)searchGroup:(NSString*)keyword offset:(int)offset {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/petgroup/searchGroup?keyword=%@&offset=%d&offsetcount=%d",PREFIX,keyword,offset*HTTP_PAGE_SIZE,HTTP_PAGE_SIZE]];
    
}

+(NSURL*)searchUser:(NSString*)keyword offset:(int)offset {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/user/searchUser?keyword=%@&offset=%d&offsetcount=%d",PREFIX,keyword,offset*HTTP_PAGE_SIZE,HTTP_PAGE_SIZE]];
    
}

+(NSURL*)petNewsListByUser:(NSString*)uid token:(NSString*)token offset:(int)offset{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/post/list?uid=%@&token=%@&offset=%d&offsetcount=%d",PREFIX,uid,token,offset*HTTP_PAGE_SIZE,HTTP_PAGE_SIZE]];

}

+(NSURL*)deletePost{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/post/deletePost",PREFIX]];
    
}
+(NSURL*)deleteActivity{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/activity/deleteActivity",PREFIX]];
    
}

+(NSURL*)serviceApi{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/web/tnc",PREFIX]];

}

+(NSURL*)privacyApi{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/web/tnc/privacy",PREFIX]];
}

+(NSURL*)addStoreItemPageview:(NSString*)mid{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/store/addStoreItemPageview?id=%@",PREFIX,mid]];

}


+(NSURL*)storeTypeListApi{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/store/typeList",PREFIX]];
}

+(NSURL*)forgetPasswordApi{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@//api/user/sendForgotPasswordMail",PREFIX]];

}


@end
