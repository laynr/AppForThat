//
//  AppStructrAppDelegate.m
//  AppStructr
//
//  Created by me on 2/2/10.
//  Copyright Scoutic LLC 2010. All rights reserved.
//

#import "AppStructrAppDelegate.h"
#import "MainViewController.h"
#import "TouchDrawViewController.h"
#import "ItemsViewController.h"


@implementation AppStructrAppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {  
	
	MainViewController *mainViewController = [[MainViewController alloc] init];
	
	//Create an instance of a UIVavigationController its stack contains only mainViewController
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
	
	//mainViewController is retained by navController
	[mainViewController release];
	
	//Place navigation controller's view in the window hierarchy
	[window addSubview:[navController view]];
	
	//Show the window
    [window makeKeyAndVisible];
	
	return YES;
	
	
	/*

    // Create the tabBarController
	tabBarController = [[UITabBarController alloc] init];
	
	//Create view controllers
	UIViewController *vc1 = [[MainViewController alloc] init];
	UIViewController *vc2 = [[TouchDrawViewController alloc] init];
//	UIViewController *vc3 = [[ItemsViewController alloc] init];
//	UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc3];
	
	//Make an array containing the view controllers
//	NSArray *viewControllers = [NSArray arrayWithObjects:vc1, vc2, nvc, nil];
	NSArray *viewControllers = [NSArray arrayWithObjects:vc1, vc2, nil];
	
	//Attach them to the tab bar controller
	[tabBarController setViewControllers:viewControllers];
	
	//Memory Managment
	[vc1 release];
	[vc2 release];
//	[vc3 release];
//	[nvc release];
	
	//Put the tabBarController's view on the window
	[window addSubview:[tabBarController view]];
	
	//Show the window
    [window makeKeyAndVisible];
	
	return YES;
	 */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
