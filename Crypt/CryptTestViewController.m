//
//  CryptTestViewController.m
//  Crypt
//
//  Created by UlhasM on 24/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CryptTestViewController.h"
#import "CryptManager.h"

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
    
    NSLog(@"Text : %@", self.uiEncryptTextField.text);
    
    NSError *error;
    NSData *iv;
    NSData *salt;
    
    NSData *_encryptedData = [CryptManager encryptedDataForString:self.uiEncryptTextField.text initializationVector:&iv salt:&salt andError:&error];
    
    NSLog(@"Encrypted Data : %@/n/n/nIV : %@/n/n/nSalt : %@/n/n/n Error : %@", _encryptedData, iv, salt, error);
}

- (IBAction)decryptButtonClicked:(UIButton *)sender;
{
    
}

@end
