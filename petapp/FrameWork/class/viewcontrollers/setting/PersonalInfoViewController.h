//
//  PersonalInfoViewController.h
//  PetNews
//
//  Created by fanty on 13-9-2.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "BaseViewController.h"
@class TextInputView;
@class AsyncTask;
@class MBProgressHUD;
@interface PersonalInfoViewController : BaseViewController{

    TextInputView* nicknameField;
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
