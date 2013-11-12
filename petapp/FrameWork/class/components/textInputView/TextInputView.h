//
//  TextInputView.h
//  PetNews
//
//  Created by fanty on 13-9-1.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextInputView : UIButton{
    UILabel* titleLabel;
    UITextField* textField;
    UILabel* valueLabel;
    UIImageView* arrowView;
    
    
}


-(id)initWithTitle:(NSString*)title field:(NSString*)field;

-(id)initWithTitle:(NSString*)title value:(NSString*)value;

-(NSString*)content;
-(void)content:(NSString*)value;

-(void)keyboardType:(UIKeyboardType)keyboardType;

-(void)returnKeyType:(UIReturnKeyType)returnKeyType;

-(void)delegate:(id<UITextFieldDelegate>)delegate;

-(void)secureTextEntry:(BOOL)secureText;

-(void)updateTitleColor:(NSString*)value;

@end
