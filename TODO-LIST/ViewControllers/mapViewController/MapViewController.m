//
//  MapViewController.m
//  myMapTest
//
//  Created by Siyao Lu on 14/11/25.
//  Copyright (c) 2014年 CSE436. All rights reserved.
//

#import "MapViewController.h"


#define METERS_PER_MILE 1609.344


@interface MapViewController ()

@end

@implementation MapViewController
@synthesize focusPointAtStart;



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Newwallpaper.png"]];
    backgroundImage.alpha = 0.80;
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    self.view.backgroundColor = [UIColor clearColor];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
 
    //searchBar
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    _searchBar.delegate = self;
    
    //map
    _myMap = [[MKMapView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 40)];
    _myMap.delegate = self;
    [_myMap setShowsUserLocation:YES];
    
    //button
    _doneButton = [[UIButton alloc] initWithFrame:
                   CGRectMake(self.view.frame.size.width - 50, self.view.frame.size.height - 50, 50, 50)];
    [_doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [_doneButton addTarget:self action:@selector(quitMapView) forControlEvents:UIControlEventTouchUpInside];
    [_doneButton setBackgroundColor:[UIColor blackColor]];
    
    _showCurr = [[UIButton alloc] initWithFrame:
                 CGRectMake(0, self.view.frame.size.height - 50, 50, 50)];
    [_showCurr setTitle:@"Show" forState:UIControlStateNormal];
    [_showCurr addTarget:self action:@selector(showCurrentLocation) forControlEvents:UIControlEventTouchUpInside];
    [_showCurr setBackgroundColor:[UIColor blackColor]];
    
    
    [self.view addSubview:_searchBar];
    [self.view addSubview:_myMap];
    [self.view addSubview:_doneButton];
    [self.view addSubview:_showCurr];
    
    
    if (focusPointAtStart == nil){
        //search mode
        
    }
    else{
        //show event location
        [self showEventLocation];
    }

}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
    
    //local search
    MKLocalSearchRequest *predict = [[MKLocalSearchRequest alloc] init];
    predict.naturalLanguageQuery = _searchBar.text;
    predict.region = _myMap.region;
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:predict];
    NSMutableArray *pointsFound = [[NSMutableArray alloc] init];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        for (MKMapItem *item in response.mapItems){
            MKPointAnnotation *anno = [[MKPointAnnotation alloc] init];
            anno.title = item.placemark.name;
            anno.subtitle = item.placemark.title;
            anno.coordinate = item.placemark.coordinate;
            [pointsFound addObject:anno];
            
        }
        [_myMap removeAnnotations:[_myMap annotations]];
        [_myMap showAnnotations:pointsFound animated:YES];
        
    }];
    
}


- (void)showEventLocation
{
    PFQuery *query = [PFQuery queryWithClassName:@"Lists"];
    
    [query whereKey:@"Location" nearGeoPoint:focusPointAtStart withinMiles:10.0];
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
        [_myMap removeAnnotations:[_myMap annotations]];
        [_myMap showAnnotations:pointsFound animated:YES];
        
        CLLocationCoordinate2D focusCoordinate = CLLocationCoordinate2DMake(focusPointAtStart.latitude, focusPointAtStart.longitude);
        
        if ((int)[eventsNearby count] == 1){
            //only one event nearby
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(focusCoordinate, METERS_PER_MILE, METERS_PER_MILE);
            [_myMap setRegion:viewRegion animated:YES];
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
            [_myMap setRegion:viewRegion animated:YES];
            
        }
    }];
    
}



//#pragma mark - Notification center
//-(void)receiveLocationUpdate:(NSNotification*)notification
//{
//    NSLog(@"received");
//    NSDictionary *info = notification.userInfo;
//    
//    _currCoordinate.longitude = [info[@"CurrentCoordinate.Longitude"] doubleValue];
//    _currCoordinate.latitude = [info[@"CurrentCoordinate.Latitude"] doubleValue];
//
//}

#pragma mark - MapView delegate
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    _currCoordinate = userLocation.coordinate;
 
    if (focusPointAtStart == nil)
    {
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(_currCoordinate, METERS_PER_MILE, METERS_PER_MILE);
        [_myMap setRegion:viewRegion animated:YES];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    NSString* identifier = @"myAnnoView";
    MKPinAnnotationView* annoView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (annoView == nil){
        annoView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annoView.enabled = true;
        annoView.canShowCallout = true;
        annoView.animatesDrop = true;
        
        if (focusPointAtStart != nil)
        {
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            annoView.rightCalloutAccessoryView = rightButton;
        }
    }
    
    return annoView;
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    MKPointAnnotation *anno = _myMap.selectedAnnotations[0];
    _selectedCoordinate = anno.coordinate;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"callout tapped");
    //TODO: jump to detail view
}


#pragma mark - quit
- (void)quitMapView
{
    PFGeoPoint* locationToRetrun;
    if (_selectedCoordinate.latitude != 0 && _selectedCoordinate.longitude != 0)
    {
        locationToRetrun = [[PFGeoPoint alloc] init];
        locationToRetrun = [PFGeoPoint geoPointWithLatitude:_selectedCoordinate.latitude longitude:_selectedCoordinate.longitude];
        
        if ([self.delegate respondsToSelector:@selector(doneWithMapView:)])
            [self.delegate doneWithMapView:locationToRetrun];
        
        [self.navigationController popViewControllerAnimated:YES];
    }    
}

- (void)showCurrentLocation
{
    [_myMap setCenterCoordinate:_currCoordinate animated:true];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
