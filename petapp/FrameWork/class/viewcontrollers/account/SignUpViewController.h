//
//  SignUpViewController.h
//  PetNews
//
//  Created by fanty on 13-8-2.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "BaseViewController.h"
@class TextInputView;
@class AsyncTask;
@class MBProgressHUD;
@interface SignUpViewController : BaseViewController{

    TextInputView* nicknameField;
    TextInputView* phoneField;
    TextInputView* passwordField;
    TextInputView* emailField;
    UIButton* headerImageView;
    TextInputView* sexField;
    TextInputView* personDescField;

    TextInputView* provinceField;
    TextInputView* cityField;
    TextInputView* areaField;
    TextInputView* petTypeField;
    TextInputView* petSexField;
    
    UIButton* confirmButton;
    
    UIImageView* logoView;
    UIWebView* logoLabel;

    NSArray* areaArray;
    
    int selectedSex;
    int selectedProvince;
    int selectedCity;
    int selectedArea;
    int selectedPetType;
    int selectedPetSex;
    
    BOOL isSelectedImage;

    UIView* pickerBgView;
    UIPickerView* picker;
    
    AsyncTask* task;
    MBProgressHUD* hud;
    
    UIPopoverController *popover;
}


@end
