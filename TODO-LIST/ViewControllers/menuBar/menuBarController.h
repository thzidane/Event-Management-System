//
//  menuBarController.h
//  menuBarTest
//
//  Created by Siyao Lu on 14/11/24.
//  Copyright (c) 2014年 CSE436. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol menuBarDelegate <NSObject>

- (void)menuButtonClicked:(int)index;

@end


@interface menuBarController : NSObject
{
    UIView              *_backgroundMenuView;
    //UIButton            *_menuButton;
    NSMutableArray      *_buttonList;
}


@property (nonatomic) BOOL _isOpen;
@property (nonatomic, retain) id<menuBarDelegate> delegate;

- (menuBarController*)initWithImages:(NSArray*)buttonList;
//- (void)insertMenuButtonOnView:(UIView*)view atPosition:(CGPoint)position;
- (void)installMenuBarOnView:(UIView*)view;
- (void)toggleMenu;
- (void)dismissMenu;

@end
