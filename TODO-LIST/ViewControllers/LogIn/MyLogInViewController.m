//
//  MyLogInViewController.m
//  LogInAndSignUpDemo
//
//  Created by Mattieu Gamache-Asselin on 6/15/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "MyLogInViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MyLogInViewController ()
@property (nonatomic, strong) UIImageView *fieldsBackground;
@end

@implementation MyLogInViewController

@synthesize fieldsBackground;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Newwallpaper.png"]]];
    
    //[self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo.png"]]];
    
    // Set buttons appearance
    //[self.logInView.dismissButton setImage:[UIImage imageNamed:@"Exit.png"] forState:UIControlStateNormal];
    //[self.logInView.dismissButton setImage:[UIImage imageNamed:@"ExitDown.png"] forState:UIControlStateHighlighted];
    //[self.logInView.logInButton setBackgroundImage:[UIImage imageNamed:@"signupbutton.png"] forState:UIControlStateNormal];
    //[self.logInView.logInButton setBackgroundImage:[UIImage imageNamed:@"signupbutton.png"] forState:UIControlStateHighlighted];
    
    //[self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"SignUp.png"] forState:UIControlStateNormal];
    [self.logInView.signUpButton setBackgroundColor:[UIColor clearColor]];
    [self.logInView.signUpButton setTintColor:[UIColor clearColor]];
    //[self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"signupbutton.png"] forState:UIControlStateHighlighted];
    //[self.logInView.signUpButton setTitle:@"" forState:UIControlStateNormal];
    //[self.logInView.signUpButton setTitle:@"" forState:UIControlStateHighlighted];
    
    
    // Add login field background
    //fieldsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoginFieldBG.png"]];
    [self.logInView addSubview:self.fieldsBackground];
    [self.logInView sendSubviewToBack:self.fieldsBackground];
    
    // Remove text shadow
    CALayer *layer = self.logInView.usernameField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.logInView.passwordField.layer;
    layer.shadowOpacity = 0.0f;
    
    // Set field text color
    //[self.logInView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    //[self.logInView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.logInView.usernameField setBackgroundColor:[UIColor clearColor]];
    [self.logInView.passwordField setBackgroundColor:[UIColor clearColor]];
    self.logInView.usernameField.font = [UIFont fontWithName:@"GillSans-Bold" size:24];
    self.logInView.passwordField.font = [UIFont fontWithName:@"GillSans-Bold" size:24];
    self.logInView.usernameField.textColor = [UIColor blackColor];
    self.logInView.passwordField.textColor = [UIColor blackColor];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Set frame for elements
    //[self.logInView.dismissButton setFrame:CGRectMake(10.0f, 10.0f, 87.5f, 45.5f)];
    [self.logInView.logo setHidden:true];
    [self.logInView.signUpButton setFrame:CGRectMake(108.0f, 356.0f, 100.0f, 40.0f)];
    [self.logInView.usernameField setFrame:CGRectMake(37.0f, 195.0f, 250.0f, 50.0f)];
    [self.logInView.passwordField setFrame:CGRectMake(37.0f, 245.0f, 250.0f, 50.0f)];
    [self.fieldsBackground setFrame:CGRectMake(35.0f, 145.0f, 250.0f, 100.0f)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
