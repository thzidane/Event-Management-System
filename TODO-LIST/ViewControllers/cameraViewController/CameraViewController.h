//
//  CameraViewController.h
//  ParseStarterProject
//
//  Created by Hao Tang on 11/30/14.
//
//

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol myCameraViewDelegate <NSObject>

- (void)doneWithCameraView:(PFFile*) returnImage;

@end


@interface CameraViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    UIImagePickerController *picker;
    UIImagePickerController *picker2;
    UIImage *image;
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UIButton *doneButton;
}
@property (strong, atomic) ALAssetsLibrary* library;
@property (weak, nonatomic) id<myCameraViewDelegate> delegate;

@end
