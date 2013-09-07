//
//  MainViewController.h
//  AppStructr
//
//  Created by me on 2/2/10.
//  Copyright 2010 Scoutic LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppStructrAppDelegate.h"
#import "TouchDrawViewController.h"
#import "ItemsViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


#define CHARACTERS          @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define CHARACTERS_NUMBERS  [CHARACTERS stringByAppendingString:@"1234567890"]


@interface MainViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate> {
	NSMutableArray *actionItems;
	TouchDrawViewController *touchDrawViewController;
	ItemsViewController *itemsViewController;
	UITextField *appNameText;
}

@property(nonatomic,retain) NSMutableArray *actionItems;

@end
