//
//  ListsTableViewController.h
//  ParseStarterProject
//
//  Created by Siyao Lu on 14/11/29.
//
//

#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
#import "menuBarController.h"


@interface ListsTableViewController : PFQueryTableViewController <menuBarDelegate,CLLocationManagerDelegate>
{
    menuBarController *menuBar;
    CLLocationManager *_locationManager;
    CLLocationCoordinate2D _currCoordinate;
    NSMutableDictionary *_notificationDict;
    
    
    IBOutlet UIButton* _byDateButton;
    IBOutlet UIButton* _byLocationButton;
}

@end
