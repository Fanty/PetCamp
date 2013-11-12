//
//  ChangePasswordViewController.h
//  PetNews
//
//  Created by Grace Lai on 21/8/13.
//  Copyright (c) 2013 fanty. All rights reserved.
//

#import "BaseViewController.h"
@class AsyncTask;
@interface ChangePasswordViewController : BaseViewController{

    UITextField* passwordField;
    UITextField* newPasswordField;
    UITextField* rePassworddField;
    
    UITextField* currentTextField;
    
    AsyncTask* task;
}

@end
