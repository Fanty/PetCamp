//
//  Constants.h
//  iOS_SVW_Accessories
//
//  Created by Henry.Yu on 31/3/13.
//  Copyright (c) 2013年 Henry.Yu. All rights reserved.
//

#ifndef APP_STORE

#define   DEBUG       1
#define  DEV_VERSION    1

#endif

#define lang(key)            NSLocalizedStringFromTable(key, @"zh-cn", @"")


#define HTTP_ERROR_CODE @"connect_error"

#define VERSION_NUMBER      @"1.0.0"


#define  HTTP_PAGE_SIZE    20

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#define UpdatePetNewsListNotification      @"upnNotification"
#define UpdateActivatyListNotification     @"ualNotification"
#define BannerUpdateNotification           @"buNotification"
#define FriendUpdateNotification           @"fuNotification"
#define GroupUpdateNotification            @"guNotification"
#define FaviorUpdateNotificaton            @"favNotification"

#import "UIView+theme.h"
#import "UILabel+theme.h"
#import "UIButton+theme.h"
#import "UITextView+theme.h"

