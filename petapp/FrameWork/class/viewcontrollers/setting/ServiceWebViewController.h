//
//  ServiceWebViewController.h
//  PetNews
//
//  Created by 肖昶 on 13-9-16.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "NavContentViewController.h"

@interface ServiceWebViewController : NavContentViewController{
    UIWebView* webView;
    UIActivityIndicatorView* loadingView;

}

@property(nonatomic,assign) BOOL isPrivacy;

@end
