//
//  MapViewController.h
//  myMapTest
//
//  Created by Siyao Lu on 14/11/25.
//  Copyright (c) 2014年 CSE436. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "Parse/Parse.h"

@protocol myMapViewDelegate <NSObject>

- (void)doneWithMapView:(PFGeoPoint*) returnLocation;

@end


@interface MapViewController : UIViewController <MKMapViewDelegate, UISearchBarDelegate>
{
    UISearchBar *_searchBar;
    MKMapView *_myMap;
    UIButton *_doneButton;
    UIButton *_showCurr;
    
    CLLocationCoordinate2D _currCoordinate;
    CLLocationCoordinate2D _selectedCoordinate;
}

@property (weak, nonatomic) id<myMapViewDelegate> delegate;
@property (weak, nonatomic) PFGeoPoint* focusPointAtStart;


@end
