//
//  AllUsersViewController.h
//  ParseStarterProject
//
//  Created by Hao Tang on 11/30/14.
//
//

#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
#import "menuBarController.h"

@interface AllUsersViewController : PFQueryTableViewController <menuBarDelegate,PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
{
    menuBarController *menuBar;
}
@property BOOL comeFromShare;
@property PFObject *shareEvent;
@end
