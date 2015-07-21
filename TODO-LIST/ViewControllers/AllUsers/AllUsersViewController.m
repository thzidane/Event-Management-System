//
//  AllUsersViewController.m
//  ParseStarterProject
//
//  Created by Hao Tang on 11/30/14.
//
//

#import "AllUsersViewController.h"
#import "ListsTableViewController.h"
#import "AddEventViewController.h"
#import "CameraViewController.h"
#import "SubclassConfigViewController.h"
@interface AllUsersViewController ()
@property (nonatomic) NSString *myFriendName;
@property BOOL haveShared;
@property NSString *enterUsername;
@end

@implementation AllUsersViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"Friends";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"friends";
        
        // The title for this table in the Navigation Controller.
        self.title = @"Friends";
        
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
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Newwallpaper.png"]];
    backgroundImage.alpha = 0.80;
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    self.view.backgroundColor = [UIColor clearColor];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSArray *imageList = @[[UIImage imageNamed:@"menuChat.png"], [UIImage imageNamed:@"menuUsers.png"],
                           [UIImage imageNamed:@"menuClose.png"]];
    menuBar = [[menuBarController alloc] initWithImages:imageList];
    menuBar.delegate = self;
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [menuButton setImage:[UIImage imageNamed:@"menuIcon.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(toggleMenuBar) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuB = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = menuB;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriend)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [menuBar installMenuBarOnView:self.view];
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
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"username" equalTo:[[PFUser currentUser] username]];
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"createdAt"];
    return query;
}



// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
   
    // Configure the cell
    cell.textLabel.text = [object objectForKey:@"friend"];
    return cell;
}


/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [objects objectAtIndex:indexPath.row];
 }
 */

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
    
    self.haveShared = YES;
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    self.myFriendName = [object objectForKey:@"username"];
    NSString *title = [NSString stringWithFormat:@"You wanted to add %@ with friend.", [object objectForKey:@"friend"]];
    if (self.comeFromShare) {
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:[object objectForKey:@"friend"]];
        PFUser *user = (PFUser *)[query getFirstObject];
    
        NSMutableArray *userList = [[NSMutableArray alloc]init];
        if (self.shareEvent[@"shareUsers"]!=nil) {
            userList=self.shareEvent[@"shareUsers"];
        }
        [userList addObject:user];
        self.shareEvent[@"shareUsers"]=userList;
        [userList addObject:[PFUser currentUser]];
        PFACL *groupACL = [PFACL ACL];
        // userList is an NSArray with the users we are sending this message to.
        for (PFUser *user in userList) {
            [groupACL setReadAccess:YES forUser:user];
            [groupACL setWriteAccess:YES forUser:user];
        }
        self.shareEvent.ACL = groupACL;
        [self.shareEvent saveInBackground];
        
        title = [NSString stringWithFormat:@"You have shared an event with %@.", [object objectForKey:@"friend"]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@""  delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil, nil];
            [alert show];
    }else{
        title = [NSString stringWithFormat:@"You have been a friend with %@.", [object objectForKey:@"friend"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@""  delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil, nil];
        [alert show];
    }
    
}


-(void)addFriend {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add New Friend"
                                                    message:@"Username"
                                                   delegate:self
                                          cancelButtonTitle:@"Done"
                                          otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}
-(BOOL)checkUserExists{
    NSLog(@"check use exists");
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:self.enterUsername];
    PFUser *user = (PFUser *)[query getFirstObject];
    NSLog(@"%@",user.username);
    if (user==nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"User does not exist!" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        NSLog(@"input null");
        return NO;
        
    }else if ([user.username isEqualToString:[PFUser currentUser].username]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You can't add yourself as a friend!" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        NSLog(@"input current user");
        return NO;
        
    }else{
        return YES;
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.haveShared) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        [self loadObjects];
    }else{
        if ([[alertView textFieldAtIndex:0].text length]!= 0){
            //okay. save
            self.enterUsername =[alertView textFieldAtIndex:0].text;
            NSLog(@"%@",self.enterUsername);
            if ([self checkUserExists]) {
                PFObject *toAdd = [PFObject objectWithClassName:@"Friends"];
                toAdd[@"friend"]=[alertView textFieldAtIndex:0].text;
                toAdd[@"username"]=[[PFUser currentUser]username];
                [toAdd saveInBackground];
                PFQuery *query = [PFUser query];
                [query whereKey:@"username" equalTo:[alertView textFieldAtIndex:0].text];
                PFUser *user = (PFUser *)[query getFirstObject];
                PFObject *addAnother = [PFObject objectWithClassName:@"Friends"];
                addAnother[@"username"]=[alertView textFieldAtIndex:0].text;
                addAnother[@"friend"]=[[PFUser currentUser]username];
                addAnother.ACL = [PFACL ACLWithUser:user];
                [addAnother saveInBackground];
               
            }
        }else{
            NSLog(@"Event Add Error");
            //alert maybe?
        }
        [self loadObjects];
    }
    
}


#pragma mark - menuBar
- (void)menuButtonClicked:(int)index
{
    NSLog(@"button index: %d", index);
    if (index==0) {
        ListsTableViewController *listVC = [[ListsTableViewController alloc]init];
        [self.navigationController dismissViewControllerAnimated:false completion:nil];
        [self.navigationController pushViewController:listVC animated:false];
    }
//    if (index == 1){
//        AllUsersViewController *userVC = [[AllUsersViewController alloc] init];
//        [self.navigationController dismissViewControllerAnimated:false completion:nil];
//        [self.navigationController pushViewController:userVC animated:false];
//    }
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

@end
