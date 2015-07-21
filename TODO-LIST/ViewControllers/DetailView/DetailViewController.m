//
//  DetailViewController.m
//  ParseStarterProject
//
//  Created by Hao Tang on 11/30/14.
//
//

#import "DetailViewController.h"
#import "AddEventViewController.h"
#import "AllUsersViewController.h"
@interface DetailViewController ()

@end

#define METERS_PER_MILE 1609.344

@implementation DetailViewController
@synthesize EVENT_OBJECT;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Newwallpaper.png"]];
    backgroundImage.alpha = 0.80;
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action: @selector(editEvent)];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action: @selector(cancel)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    //map
    myMap.delegate = self;
    [myMap setShowsUserLocation:YES];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self populateEventObject];
}


-(void)populateEventObject
{
    //title
    titleLabel.text = EVENT_OBJECT[@"Title"];
    
    //date
    NSDate *date = EVENT_OBJECT[@"Date"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-EEEE"];
    NSString *dateString = [dateFormat stringFromDate:date];
    dateLabel.text = dateString;
    
    //image
    [EVENT_OBJECT[@"imageFile"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if(!error){
            NSLog(@"check point");
            UIImage *image = [UIImage imageWithData:data];
            [myImage setImage:image];
        }
    }];

    //location
    PFGeoPoint* location = EVENT_OBJECT[@"Location"];
    if (location == nil)
    {
        [myMap setHidden:true];
    }
    else
    {
        [myMap setHidden:false];
        locationCoordinate.text = [NSString stringWithFormat:@"latitude:%f, longtitude:%f", location.latitude, location.longitude];
        
        
        PFQuery *query = [PFQuery queryWithClassName:@"Lists"];
        [query whereKey:@"Location" nearGeoPoint:location withinMiles:2.0];
        query.limit = 10;
        //from nearest to fartherest
        [query findObjectsInBackgroundWithBlock:^(NSArray *eventsNearby, NSError *error) {
            NSMutableArray *pointsFound = [[NSMutableArray alloc] init];
            for (PFObject* event in eventsNearby){
                MKPointAnnotation *anno = [[MKPointAnnotation alloc] init];
                anno.title = event[@"Title"];
                PFGeoPoint *point = event[@"Location"];
                anno.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude);
                [pointsFound addObject:anno];
            }
            [myMap removeAnnotations:[myMap annotations]];
            [myMap showAnnotations:pointsFound animated:YES];
            
            CLLocationCoordinate2D focusCoordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude);
            
            if ((int)[eventsNearby count] == 1){
                //only one event nearby
                MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(focusCoordinate, METERS_PER_MILE, METERS_PER_MILE);
                [myMap setRegion:viewRegion animated:YES];
            }else{
                //fartherest event
                PFObject* fartherestObject = [eventsNearby lastObject];
                PFGeoPoint *fartherestLocation = fartherestObject[@"Location"];
                
                MKCoordinateSpan span;
                span.latitudeDelta = (focusCoordinate.latitude > fartherestLocation.latitude)? (focusCoordinate.latitude -fartherestLocation.latitude) : (fartherestLocation.latitude - focusCoordinate.latitude);
                span.longitudeDelta = (focusCoordinate.longitude > fartherestLocation.longitude)? (focusCoordinate.longitude -fartherestLocation.longitude) : (fartherestLocation.longitude - focusCoordinate.longitude);
                span.longitudeDelta *= 2.5;
                span.latitudeDelta *= 2.5;
                
                MKCoordinateRegion viewRegion = MKCoordinateRegionMake(focusCoordinate, span);
                [myMap setRegion:viewRegion animated:YES];   
            }
        }];
        
    }

}

-(void)editEvent{
    AddEventViewController *editView = [[AddEventViewController alloc]init];
    editView.EVENT_OBJECT = EVENT_OBJECT;
    [self.navigationController pushViewController:editView animated:YES];
}

-(void)objectReturnedFromEdit:(PFObject *)objectReturned
{
    EVENT_OBJECT = objectReturned;
    [self populateEventObject];
}

-(void)cancel{
    [self.navigationController popViewControllerAnimated:true];
}


- (IBAction)shareEvent:(id)sender {
    AllUsersViewController *usersView = [[AllUsersViewController alloc]init];
    usersView.shareEvent = EVENT_OBJECT;
    usersView.comeFromShare = YES;
    [self.navigationController pushViewController:usersView animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
