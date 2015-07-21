//
//  DetailViewController.h
//  ParseStarterProject
//
//  Created by Hao Tang on 11/30/14.
//
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import "AddEventViewController.h"

@interface DetailViewController : UIViewController <MKMapViewDelegate, editEventDelegate>
{
    __weak IBOutlet UIButton *shareButton;
    
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UILabel *locationCoordinate;
    __weak IBOutlet MKMapView *myMap;
    __weak IBOutlet UIImageView *myImage;
}



@property (strong, nonatomic) PFObject* EVENT_OBJECT;





@end
