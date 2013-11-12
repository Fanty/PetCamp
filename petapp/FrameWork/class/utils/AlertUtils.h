//
//  AlertUtils.h
//  PetNews
//
//  Created by fanty on 13-8-27.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MBProgressHUD;
@interface AlertUtils : NSObject

+(MBProgressHUD*)showAlert:(NSString*)message view:(UIView*)view;
+(MBProgressHUD*)showLoading:(NSString*)message view:(UIView*)view;
@end
