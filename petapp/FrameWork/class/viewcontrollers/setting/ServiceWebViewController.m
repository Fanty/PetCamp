//
//  ServiceWebViewController.m
//  PetNews
//
//  Created by 肖昶 on 13-9-16.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ServiceWebViewController.h"
#import "ApiManager.h"
@interface ServiceWebViewController ()<UIWebViewDelegate>
@end

@implementation ServiceWebViewController
@synthesize isPrivacy;
- (id)init{
    self = [super init];
    if (self) {
        self.title=lang(@"serviceandsecure");
        // Custom initialization
        [self backNavBar];
        self.navigationItem.rightBarButtonItem=nil;
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor clearColor];
    webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    webView.backgroundColor=[UIColor clearColor];
    webView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
    | UIViewAutoresizingFlexibleTopMargin
    | UIViewAutoresizingFlexibleRightMargin
    | UIViewAutoresizingFlexibleBottomMargin
    | UIViewAutoresizingFlexibleWidth
    | UIViewAutoresizingFlexibleHeight;
    webView.delegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:(self.isPrivacy?[ApiManager privacyApi]:[ApiManager serviceApi])]];
    [self.view addSubview:webView];
    [webView release];
    
    
    loadingView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingView.frame=CGRectMake(0.5f*(self.view.frame.size.width-32.0f), 0.5f*(self.view.frame.size.height-32.0f), 32.0f, 32.0f);
    
    [self.view addSubview:loadingView];
    [loadingView release];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [super dealloc];
}


#pragma mark method


#pragma mark webview delegate
- (void)webViewDidStartLoad:(UIWebView *)aWebView{
    [loadingView startAnimating];
}


- (void)webViewDidFinishLoad:(UIWebView *)aWebView{
    [loadingView stopAnimating];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error{
    [loadingView stopAnimating];
}


@end
