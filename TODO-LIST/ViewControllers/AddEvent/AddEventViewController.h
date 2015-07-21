//
//  AddEventViewController.h
//  ParseStarterProject
//
//  Created by Siyao Lu on 14/11/29.
//
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "MapViewController.h"
#import "CameraViewController.h"

@protocol editEventDelegate <NSObject>

- (void)objectReturnedFromEdit:(PFObject*)objectReturned;

@end


@interface AddEventViewController : UIViewController <UITextFieldDelegate, myMapViewDelegate, myCameraViewDelegate>
{
    IBOutlet UIDatePicker *eventDate;
    IBOutlet UITextField *eventTitle;
    IBOutlet UIButton *mapButton;
    IBOutlet UIButton *imageButton;
    IBOutlet UILabel *mapIndicator;
    IBOutlet UILabel *imageIndicator;
    
    PFGeoPoint* selectedLocation;
}

@property (weak, nonatomic) id<editEventDelegate> delegate;
@property (strong, nonatomic) PFObject* EVENT_OBJECT;

@end
