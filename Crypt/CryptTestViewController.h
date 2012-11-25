//
//  CryptTestViewController.h
//  Crypt
//
//  Created by UlhasM on 24/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CryptTestViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *uiEncryptTextField;
@property (nonatomic, strong) IBOutlet UITextField *uiDecryptTextField;

- (IBAction)encryptButtonClicked:(UIButton *)sender;
- (IBAction)decryptButtonClicked:(UIButton *)sender;

@end
