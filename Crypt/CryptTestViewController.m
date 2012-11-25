//
//  CryptTestViewController.m
//  Crypt
//
//  Created by UlhasM on 24/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CryptTestViewController.h"
#import "CryptManager.h"
#import "Crypt.h"
#import "DatabaseManager.h"

@implementation CryptTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IBAction Methods

- (IBAction)encryptButtonClicked:(UIButton *)sender
{
    if ([self.uiEncryptTextField.text isEqualToString:@""])
        return;
    
    if ([self.uiEncryptTextField isFirstResponder])
        [self.uiEncryptTextField resignFirstResponder];
    
    NSLog(@"Plain Text : %@", self.uiEncryptTextField.text);
    
    NSError *error;
    NSData *iv;
    NSData *salt;
    
    NSData *_plainData = [self.uiEncryptTextField.text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *_encryptedData = [CryptManager encryptedDataForData:_plainData
                                                initializationVector:&iv
                                                                salt:&salt
                                                            andError:&error];
    
    NSLog(@"Encrypted Data : %@\nIV : %@\nSalt : %@\nError : %@", _encryptedData, iv, salt, error);
    
    [[DatabaseManager sharedManager] addCryptToDatabaseWithEncryptedData:_encryptedData
                                                    initializationVector:iv
                                                                    salt:salt];
    self.uiEncryptTextField.text = @"";
}

- (IBAction)decryptButtonClicked:(UIButton *)sender;
{
    if ([self.uiDecryptTextField isFirstResponder])
        [self.uiDecryptTextField resignFirstResponder];
    
    NSError *error;
    
    Crypt *_crypt = [[DatabaseManager sharedManager] cryptFromDatabase];
    
    if (!_crypt) {
        UIAlertView *_alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Nothing to decrypt" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [_alertView show];
        return;
    }
    
    NSData *_decryptedData = [CryptManager decryptedDataForData:_crypt.encryptedData
                                           initializationVector:_crypt.initializationVector
                                                           salt:_crypt.salt
                                                       andError:&error];
    
    NSLog(@"Decrypted Data : %@\nIV : %@\nSalt : %@\nError : %@", _decryptedData, _crypt.initializationVector, _crypt.salt, error);
    
    [[DatabaseManager sharedManager] deleteCryptFromDatabase:_crypt];
    
    NSString *_string = [[NSString alloc] initWithData:_decryptedData encoding:NSUTF8StringEncoding];
    NSLog(@"Plain String : %@", _string);
    
    self.uiDecryptTextField.text = _string;
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.uiDecryptTextField isFirstResponder])
        [self.uiDecryptTextField resignFirstResponder];
    else if ([self.uiEncryptTextField isFirstResponder])
        [self.uiEncryptTextField resignFirstResponder];
    
    return YES;
}

@end
