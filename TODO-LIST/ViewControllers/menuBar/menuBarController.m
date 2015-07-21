//
//  menuBarController.m
//  menuBarTest
//
//  Created by Siyao Lu on 14/11/24.
//  Copyright (c) 2014年 CSE436. All rights reserved.
//

#import "menuBarController.h"

#define MENU_BAR_WIDTH 90
#define BUTTON_SIZE 40
#define SWIPE_ACCEPTANCE 50



@implementation menuBarController

@synthesize _isOpen;

#pragma init
- (menuBarController*)initWithImages:(NSArray*)images
{
//    _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _menuButton.frame = CGRectMake(0, 0, BUTTON_SIZE, BUTTON_SIZE);
//    [_menuButton setImage:[UIImage imageNamed:@"menuIcon.png"] forState:UIControlStateNormal];
//    [_menuButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    
    _backgroundMenuView = [[UIView alloc] init];
    _buttonList = [[NSMutableArray alloc] initWithCapacity:images.count];
    
    int index = 0;
    for (UIImage *image in [images copy])
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal];
        button.frame = CGRectMake(20, 50 + (80 * index), BUTTON_SIZE, BUTTON_SIZE);
        button.tag = index;
        [button addTarget:self action:@selector(onMenuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonList addObject:button];
        ++index;
    }
    return self;
}


- (void)installMenuBarOnView:(UIView*)view{
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [view addGestureRecognizer:swipeGesture];
    
    for (UIButton *button in _buttonList)
    {
        [_backgroundMenuView addSubview:button];
    }
    
    _backgroundMenuView.frame = CGRectMake(-MENU_BAR_WIDTH, 0, MENU_BAR_WIDTH, view.frame.size.height);
 _backgroundMenuView.backgroundColor = [UIColor lightGrayColor];
    _backgroundMenuView.alpha = 0.75;
    [view addSubview:_backgroundMenuView];
}



#pragma action
- (void)dismissMenuWithSelection:(UIButton*)button
{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
         usingSpringWithDamping:.2f
          initialSpringVelocity:10.f
                        options:0 animations:^{
                            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                        }
                     completion:^(BOOL finished) {
                         [self dismissMenu];
                     }];
}

- (void)dismissMenu
{
    if (_isOpen)
    {
        _isOpen = false;
        [self performDismissAnimation];
    }
}

- (void) handleSwipe:(UISwipeGestureRecognizer *)swipe
{
    CGPoint location = [swipe locationInView:swipe.view];
    if (location.x <= SWIPE_ACCEPTANCE){
        [self toggleMenu];
    }
}


- (void)toggleMenu
{
    if (!_isOpen)
    {
        _isOpen = true;
        [self performSelectorInBackground:@selector(performOpenAnimation) withObject:nil];
    }else{
        _isOpen = false;
        [self performSelectorInBackground:@selector(performDismissAnimation) withObject:nil];
    }
}

- (void)onMenuButtonClick:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(menuButtonClicked:)])
        [self.delegate menuButtonClicked: (int)button.tag];
    [self dismissMenuWithSelection:button];
}


#pragma animation
- (void)performDismissAnimation
{
    [UIView animateWithDuration:0.2 animations:^{
//        _menuButton.alpha = 1.0f;
//        _menuButton.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
        _backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    }];
}

- (void)performOpenAnimation
{
    [UIView animateWithDuration:0.2 animations:^{
//        _menuButton.alpha = 0.0f;
//        _menuButton.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 90, 0);
        _backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 90, 0);
    }];
    
    for (UIButton *button in _buttonList)
    {
        [NSThread sleepForTimeInterval:0.02f];
        button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -20, 0);
        [UIView animateWithDuration:0.2f
                              delay:0.1f
             usingSpringWithDamping:.3f
              initialSpringVelocity:10.f
                            options:0 animations:^{
                                button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
                            }
                         completion:^(BOOL finished) {}];

    }
}






@end
