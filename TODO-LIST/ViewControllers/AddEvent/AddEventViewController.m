//
//  AddEventViewController.m
//  ParseStarterProject
//
//  Created by Siyao Lu on 14/11/29.
//
//

#import "AddEventViewController.h"


@interface AddEventViewController ()


@end

@implementation AddEventViewController

@synthesize EVENT_OBJECT;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Newwallpaper.png"]];
    backgroundImage.alpha = 0.82;
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    self.view.backgroundColor = [UIColor clearColor];
    
    if (EVENT_OBJECT != nil){
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action: @selector(haveDone)];
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action: @selector(cancel)];
        [self.navigationItem setRightBarButtonItem:rightButton];
        [self.navigationItem setLeftBarButtonItem:leftButton];
        [self.navigationItem setTitle:@"Edit event"];
        
        
    }else{
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action: @selector(haveDone)];
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action: @selector(cancel)];
        [self.navigationItem setRightBarButtonItem:rightButton];
        [self.navigationItem setLeftBarButtonItem:leftButton];
        [self.navigationItem setTitle:@"Add event"];
        //initialize
        EVENT_OBJECT = [PFObject objectWithClassName:@"Lists"];
    }
    
    //text field
    eventTitle.delegate = self;
    //populate event object
    [self populateEventObject];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if ([eventTitle isFirstResponder] && [touch view] != eventTitle) {
        [eventTitle resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
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

-(void) haveDone
{
    NSLog(@"object is nil? %@", (EVENT_OBJECT == nil)? @"true": @"false");
    
    if ([self checkEventIsOkay]){
        //okay. save
        [EVENT_OBJECT setObject:eventTitle.text forKey:@"Title"];
        [EVENT_OBJECT setObject:eventDate.date forKey:@"Date"];
        
        //location, image already handled
        
        [EVENT_OBJECT saveInBackground];
    }else{
        NSLog(@"Event Add Error");
        //alert maybe?
    }
    
    if ([self.delegate respondsToSelector:@selector(objectReturnedFromEdit:)])
        [self.delegate objectReturnedFromEdit:EVENT_OBJECT];
    
    [self.navigationController popViewControllerAnimated:true];
    
}

-(void) cancel
{
    if ([self.delegate respondsToSelector:@selector(objectReturnedFromEdit:)])
        [self.delegate objectReturnedFromEdit:EVENT_OBJECT];
    
    [self.navigationController popViewControllerAnimated:true];
}

-(BOOL) checkEventIsOkay
{
    //检查event是否合格，比如是否identical，必填的是不是null
    //check title
    if ([eventTitle.text length] == 0){
        //nil or empty
        return false;
    }
    
    
    return true;
}


- (void) populateEventObject
{
    //Outlets:      eventTitle.text, eventDate
    //Attributes:   @"Title", @"Date"
    
    if (EVENT_OBJECT[@"Title"] != nil)
        eventTitle.text = EVENT_OBJECT[@"Title"];
    if (EVENT_OBJECT[@"Date"] != nil)
        eventDate.date = EVENT_OBJECT[@"Date"];
    
    mapIndicator.text = (EVENT_OBJECT[@"Location"] != nil)? @"true": @"false";
    imageIndicator.text = (EVENT_OBJECT[@"imageFile"] != nil)? @"true": @"false";
    
}


- (IBAction)mapPressed:(id)sender {
    MapViewController *mapVC = [[MapViewController alloc] init];
    mapVC.delegate = self;
    
    if (EVENT_OBJECT != nil && EVENT_OBJECT[@"Location"] != nil){
        PFGeoPoint* location = EVENT_OBJECT[@"Location"];
        mapVC.focusPointAtStart = location;
    }
    
    [self.navigationController pushViewController:mapVC animated:true];
}

- (IBAction)imagePressed:(id)sender {
    CameraViewController *cameraVC = [[CameraViewController alloc] init];
    cameraVC.delegate = self;
    
    
    [self.navigationController pushViewController:cameraVC animated:true];
}

- (void)doneWithMapView:(PFGeoPoint *)returnLocation
{
    if (returnLocation != nil)
    {
        [EVENT_OBJECT setObject:returnLocation forKey:@"Location"];
        [self populateEventObject];
    }
}

- (void)doneWithCameraView:(PFFile *)returnImage
{
    if (returnImage != nil)
    {
        [EVENT_OBJECT setObject:returnImage forKey:@"imageFile"];
        [self populateEventObject];
    }
}


@end
