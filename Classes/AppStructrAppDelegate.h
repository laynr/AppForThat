//
//  AppStructrAppDelegate.h
//  AppStructr
//
//  Created by me on 2/2/10.
//  Copyright Scoutic LLC 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	kCancel,
	kSafari,
	kSMS,
	kCall,
	kMaps,
	kContacts,
	kSound,
	kStore,
	kPicture,
	kYouTube,
	kCount
} ButtonType;


@interface AppStructrAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

