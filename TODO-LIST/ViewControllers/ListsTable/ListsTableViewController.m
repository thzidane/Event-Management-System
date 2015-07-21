//
//  ListsTableViewController.m
//  ParseStarterProject
//
//  Created by Siyao Lu on 14/11/29.
//
//

#import "ListsTableViewController.h"
#import "AddEventViewController.h"
#import "MapViewController.h"
#import "DetailViewController.h"
#import "AllUsersViewController.h"
#import "SubclassConfigViewController.h"

@interface ListsTableViewController ()

@end


BOOL SORT_MODE = 0;
NSMutableArray *sections;
NSMutableArray *rows;

@implementation ListsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    PFUser * user = [PFUser currentUser];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"Lists";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"Title";
        
        // The title for this table in the Navigation Controller.
        
        NSString *username = user.username;
        [self setTitle:username];
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Newwallpaper.png"]];
    backgroundImage.alpha = 0.80;
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    self.view.backgroundColor = [UIColor clearColor];
    
    NSArray *imageList = @[[UIImage imageNamed:@"menuChat.png"], [UIImage imageNamed:@"menuUsers.png"],
                           [UIImage imageNamed:@"menuClose.png"]];
    menuBar = [[menuBarController alloc] initWithImages:imageList];
    menuBar.delegate = self;
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [menuButton setImage:[UIImage imageNamed:@"menuIcon.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(toggleMenuBar) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuB = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = menuB;

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    
    
    //location manager
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    _locationManager.distanceFilter = 1000;
    
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        //in use
        [_locationManager requestWhenInUseAuthorization];
        //background
        [_locationManager requestAlwaysAuthorization];
    }
    
    [_locationManager startUpdatingLocation];
    [_locationManager startMonitoringSignificantLocationChanges];
    
    
    //notification center
    _notificationDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:_currCoordinate.longitude], @"CurrentCoordinate.Longitude", [NSNumber numberWithDouble:_currCoordinate.latitude], @"CurrentCoordinate.Latitude", nil];
    
    //initilaize section,rows;
    sections = [[NSMutableArray alloc] init];
//    rows = [[NSMutableArray alloc] init];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //menubar
    [menuBar installMenuBarOnView:self.view];
    
    //button
    _byDateButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 220, self.view.frame.size.height - 50, 100, 25)];
    [_byDateButton setTitle:@"By Date" forState:UIControlStateNormal];
    [_byDateButton addTarget:self action:@selector(sortByDate) forControlEvents:UIControlEventTouchUpInside];
    [_byDateButton setBackgroundColor:[UIColor blackColor]];
    
    _byLocationButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 110, self.view.frame.size.height - 50, 100, 25)];
    [_byLocationButton setTitle:@"By Location" forState:UIControlStateNormal];
    [_byLocationButton addTarget:self action:@selector(sortByLocation) forControlEvents:UIControlEventTouchUpInside];
    [_byLocationButton setBackgroundColor:[UIColor blackColor]];
    
    [self.view addSubview:_byDateButton];
    [self.view addSubview:_byLocationButton];
    
//    [self loadObjects];
    
}

-(void)sortByDate
{
    SORT_MODE = 0;
    [self loadObjects];
}

-(void)sortByLocation
{
    SORT_MODE = 1;
    [self loadObjects];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadObjects];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
    if (SORT_MODE == 0) {
        //date, objects already sorted in date, add in order
        //today, in 1 week, others
        
        [sections removeAllObjects];
        [sections addObject:[[NSMutableArray alloc] init]];
        [sections addObject:[[NSMutableArray alloc] init]];
        [sections addObject:[[NSMutableArray alloc] init]];

        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *today = [NSDate date];
        
        NSDateComponents *todaysDay = [gregorian components:NSCalendarUnitDay fromDate:today];
        long todaysWeek = [gregorian component:NSCalendarUnitWeekOfYear fromDate:today];
        
        for (PFObject* eventObject in self.objects) {
            NSDate* eventDate = eventObject[@"Date"];
            
            NSDateComponents *eventDay = [gregorian components:NSCalendarUnitDay fromDate:eventDate];
            long eventWeek = [gregorian component:NSCalendarUnitWeekOfYear fromDate:eventDate];
            
            if (eventDay.day == todaysDay.day){
                rows = sections[0];
                [rows addObject:eventObject];
            }
            else if (eventWeek == todaysWeek){
                rows = sections[1];
                [rows addObject:eventObject];
            }else{
                rows = sections[2];
                [rows addObject:eventObject];
            }
        }
    }
    else if (SORT_MODE == 1){
        //location, events sorted by date first
        //2 mile,  20mile, others
        [sections removeAllObjects];
        [sections addObject:[[NSMutableArray alloc] init]];
        [sections addObject:[[NSMutableArray alloc] init]];
        [sections addObject:[[NSMutableArray alloc] init]];
        
        //_currCoordinate available
        CLLocation *currLocation = [[CLLocation alloc] initWithLatitude:_currCoordinate.latitude longitude:_currCoordinate.longitude];
        
        for (PFObject* eventObject in self.objects) {
            PFGeoPoint* eventPoint = eventObject[@"Location"];
            CLLocation *eventLocation = [[CLLocation alloc] initWithLatitude:eventPoint.latitude longitude:eventPoint.longitude];
            CLLocationDistance distance = [currLocation distanceFromLocation:eventLocation] * 0.000621371;
//            NSLog(@"distance = %f", distance);
            if (distance <= 2){
                rows = sections[0];
                [rows addObject:eventObject];
            }
            else if (distance <= 20){
                rows = sections[1];
                [rows addObject:eventObject];
            }else{
                rows = sections[2];
                [rows addObject:eventObject];
            }
        }
        
        
    }

    
    
    [self.tableView reloadData];
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"Date"];
    
    return query;
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    rows = sections[section];
    return [rows count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (SORT_MODE == 0){
        if (section == 0)
            return @"Today";
        else if (section == 1)
            return @"This week";
        else
            return @"Others";
    }
    if (SORT_MODE == 1){
        if (section == 0)
            return @"Within 2 Miles";
        else if (section == 1)
            return @"Within 20 Miles";
        else
            return @"Far away";
    }
    
    
    return @"";
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:21];
    }
    
    // Configure the cell
    cell.textLabel.text = [object objectForKey:@"Title"];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"Priority: %@", [object objectForKey:@"priority"]];
    
    
    return cell;
}



 // Override if you need to change the ordering of objects in the table.
- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger sectionIndex = indexPath.section;
    NSInteger rowIndex = indexPath.row;
    
    rows = sections[sectionIndex];
    PFObject* toReturn = rows[rowIndex];
    
    return toReturn;
}

/*- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)]];
    if (section == integerRepresentingYourSectionOfInterest)
        [headerView setBackgroundColor:[UIColor redColor]];
    else
        [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}*/

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - Table view data source

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


 // Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self loadObjects];
        }];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [menuBar dismissMenu];
    
    if (indexPath.row < [self.objects count]){
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
//        AddEventViewController *editVC = [[AddEventViewController alloc] init];
//        editVC.EVENT_OBJECT = object;

        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.EVENT_OBJECT = object;
        
        [self.navigationController pushViewController:detailVC animated:true];
    }
}


#pragma mark - menuBar

- (void)menuButtonClicked:(int)index
{
    NSLog(@"button index: %d", index);
    
//    if (index==0) {
//        ListsTableViewController *listVC = [[ListsTableViewController alloc]init];
//        [self.navigationController dismissViewControllerAnimated:false completion:nil];
//        [self.navigationController pushViewController:listVC animated:false];
//    }
    if (index == 1){
        AllUsersViewController *userVC = [[AllUsersViewController alloc] init];
        [self.navigationController dismissViewControllerAnimated:false completion:nil];
        [self.navigationController pushViewController:userVC animated:false];
    }
//    if (index==2) {
//        CameraViewController *cameraVC = [[CameraViewController alloc]init];
//        [self.navigationController pushViewController:cameraVC animated:YES];
//    }
    if (index==2) {
        [PFUser logOut];
        
        SubclassConfigViewController *subVC = [[SubclassConfigViewController alloc]init];
        NSMutableArray *views = [[NSMutableArray alloc] initWithArray:[self.navigationController viewControllers]];
        [views replaceObjectAtIndex:0 withObject:subVC];
        [self.navigationController setViewControllers:views];
        
        [self.navigationController popToRootViewControllerAnimated:true];
        
    }
}

- (void)toggleMenuBar
{
    [menuBar toggleMenu];
}

#pragma mark - event handle
- (void) addEvent
{
    AddEventViewController *addEventVC = [[AddEventViewController alloc] init];
    
    [self.navigationController pushViewController:addEventVC animated:YES];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"location update");
    BOOL isInBackground = NO;
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        isInBackground = YES;
    }
    
    if (isInBackground)
    {
        PFQuery *query = [PFQuery queryWithClassName:@"Lists"];
        PFGeoPoint *point = [[PFGeoPoint alloc] init];
        point.latitude = newLocation.coordinate.latitude;
        point.longitude = newLocation.coordinate.longitude;
        [query whereKey:@"Location" nearGeoPoint:point withinMiles:2];
        query.limit = 10;
        //from nearest to fartherest
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if ((int)objects.count != 0)
            {
                //detected some events!!!!!!!!!!!
                NSLog(@"from background: todo lists available nearby!!!!");
                
            }
        }];
        
    }
    else
    {
        _currCoordinate = newLocation.coordinate;
        [_notificationDict setValue:[NSNumber numberWithDouble:_currCoordinate.longitude] forKey:@"CurrentCoordinate.Longitude"];
        [_notificationDict setValue:[NSNumber numberWithDouble:_currCoordinate.latitude] forKey:@"CurrentCoordinate.Latitude"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Location Update" object:self userInfo:_notificationDict];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Lists"];
        PFGeoPoint *point = [[PFGeoPoint alloc] init];
        point.latitude = newLocation.coordinate.latitude;
        point.longitude = newLocation.coordinate.longitude;
        [query whereKey:@"Location" nearGeoPoint:point withinMiles:2];
        query.limit = 10;
        //from nearest to fartherest
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if ((int)objects.count != 0)
            {
                //detected some events!!!!!!!!!!!
                NSLog(@"todo lists available nearby!!!!");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TODO nearby!!!" message:nil delegate:self cancelButtonTitle:@"Cool" otherButtonTitles:nil];
                [alert show];
                
            }
        }];
    }
    
}



@end
