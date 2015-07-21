//
//  CameraViewController.m
//  ParseStarterProject
//
//  Created by Hao Tang on 11/30/14.
//
//

#import "CameraViewController.h"
#import "AddEventViewController.h"
@interface CameraViewController ()
@property NSData *imageData;
@property BOOL haveChosen;
@end

@implementation CameraViewController
@synthesize library;

PFFile *imageToSave;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Newwallpaper.png"]];
    backgroundImage.alpha = 0.80;
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    self.view.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePhoto)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action: @selector(cancel)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    self.library = [[ALAssetsLibrary alloc] init];
}

-(void)cancel{
    [self.navigationController popViewControllerAnimated:true];
}


-(void)takePhoto{
    picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)chooseExisting:(id)sender {
    self.haveChosen = YES;
    picker2 = [[UIImagePickerController alloc]init];
    picker2.delegate = self;
    [picker2 setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker2 animated:YES completion:NULL];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageData = UIImageJPEGRepresentation(image, 0.0);
    if (self.haveChosen) {
        [self saveImageData];
    }else{
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    [imageView setImage:image];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
    // Unable to save the image
    if (error){
        alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                           message:@"Unable to save image."
                                          delegate:self cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
        [alert show];
    }else{
        [self saveImageData];
        
        // alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Image saved to Photo Album." delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil];
    }// All is well
    
    
}
-(void)saveImageData{
    imageToSave = [PFFile fileWithData:self.imageData];
}
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
//{
//    [self.library saveImage:image toAlbum:@"Touch Code Magazine" withCompletionBlock:^(NSError *error) {
//        if (error!=nil) {
//            NSLog(@"Big error: %@", [error description]);
//        }
//    }];
//
//    [picker dismissModalViewControllerAnimated:NO];
//}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)donePressed:(id)sender {
    if (imageToSave != nil)
    {
        if ([self.delegate respondsToSelector:@selector(doneWithCameraView:)])
            [self.delegate doneWithCameraView:imageToSave];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
