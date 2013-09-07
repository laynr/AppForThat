//  MainViewController.m
//  AppStructr
//
//  Created by me on 2/2/10.
//  Copyright 2010 Scoutic LLC. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"

@implementation MainViewController

@synthesize actionItems;

- (id) init
{
	//Call the superclass's designated initializer
	[super initWithNibName:nil bundle:nil];
	
	//Get the tab bar item
	UITabBarItem *tbi = [self tabBarItem];
	
	//Give it a label
	[tbi setTitle:@"AppIBuilt"];
	
	//Create a UIImage from a file
	UIImage *i = [UIImage imageNamed:@"App.png"];
	
	//Put the image on the bar
	[tbi setImage:i];
	
	//background
	//[[self view] setBackgroundColor:[UIColor orangeColor]];
	
	//Set the nav bar to have the pre=fabed Edit button when mainView is on the top of the stack
	//[[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
	
	//Right button
	UIBarButtonItem *rButton = [[UIBarButtonItem alloc] initWithTitle:@"App" style:UIBarButtonItemStylePlain target:self action:NULL];
	rButton.action = @selector(rightBarButtonAction);
	[self.navigationItem setRightBarButtonItem:rButton];
	[rButton release];
	
	//Left button
	UIBarButtonItem *lButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:NULL];
	lButton.action = @selector(leftBarButtonAction);
	[self.navigationItem setLeftBarButtonItem:lButton];
	[lButton release];
	
	//Set the title of the nav bar
	[[self navigationItem] setTitle:@"App For That"];
	
	return self;
}

- (id) initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
	//Disregard parameters - nib name is an implementation detail
	return [self init];
}

-(BOOL) fileCheck:(NSString *)file
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:file];
	if ([fileManager fileExistsAtPath:filePath]) 
	{
		return YES;
	}else {
		return NO;
	}
}

- (void)removeItemsInDocumentsDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileList = [fileManager directoryContentsAtPath:documentsDirectory];
	NSString *filePath;
    for (NSString *file in fileList){
		filePath = [documentsDirectory stringByAppendingPathComponent:file];
		[fileManager removeItemAtPath:filePath error:NULL];
    }
}

- (void)pushTouchDrawViewController
{
	if (touchDrawViewController == nil ) {
		touchDrawViewController = [[TouchDrawViewController alloc] init];
	}
	touchDrawViewController.imagePicked = NO;
	[[self navigationController] pushViewController:touchDrawViewController animated:YES];
}

- (void)pushItemsViewController
{
	
	if (itemsViewController == nil ) {
		itemsViewController = [[ItemsViewController alloc] init];
	}
	[[self navigationController] pushViewController:itemsViewController animated:YES];

 }


- (void) rightBarButtonAction //app
{
	UIActionSheet *popupQuery = [[UIActionSheet alloc]
								 initWithTitle:@"App Menu"
								 delegate:self
								 cancelButtonTitle:@"Cancel"
								 destructiveButtonTitle:nil
								 otherButtonTitles:@"New", @"Open", @"Save", nil]; //
	
	[popupQuery showInView:self.view];
	[popupQuery release];
}

- (void) leftBarButtonAction //about
{
	UIAlertView *actionAlert = [[UIAlertView alloc] initWithTitle:@"About" message:@"If you would like to learn more about Scoutic Apps or turn this into a real app please email." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Email", nil];
	[actionAlert setTag:2];
	[actionAlert show];
	[actionAlert release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
		case 0: //New
			if([self fileCheck:@"scoutic.a4t"])
			{
				UIAlertView *actionAlert = [[UIAlertView alloc] initWithTitle:@"New App?" message:@"If you continue and your app is not saved it will be deleted.  Do you want to continue?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
				[actionAlert setTag:1];
				[actionAlert show];
				[actionAlert release];
			} else {
				[self pushTouchDrawViewController];
			}
			break;
		case 1: //Open
			[self pushItemsViewController];
			break;
		case 2://Save
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Name the App"  message:@"this gets covered!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
			appNameText = [[UITextField alloc] initWithFrame:CGRectMake(12, 45, 260, 25)];
			CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0, 60);
			[alert setTransform:myTransform];
			[appNameText setBackgroundColor:[UIColor whiteColor]];
			[alert addSubview:appNameText];
			[alert setTag:3];
			[alert show];
			[alert release];
			break;
		}

	}
}

- (BOOL)textField:(UITextField *)textField 
shouldChangeCharactersInRange:(NSRange)range 
replacementString:(NSString *)string
{
	// These are the characters that are ~not~ acceptable
	NSCharacterSet *unacceptedInput =
    [[NSCharacterSet characterSetWithCharactersInString:CHARACTERS] invertedSet];
	
	// Create array of strings from incoming string using the unacceptable
	// characters as the trigger of where to split the string.
	// If array has more than one entry, there was at least one unacceptable character
	if ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] > 1)
	{
		NSLog(@"NOT GOOD");
		return NO;
	}
	else
	{
		NSLog(@"GOOD");
		return YES;
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch ([alertView tag]) {
		case 1: //erase app?
			if (buttonIndex == 0) //no
			{
				return;
			} else { //yes
				[self removeItemsInDocumentsDirectory];
				[self pushTouchDrawViewController];
				return;
			}
			break;
		case 2:
			if (buttonIndex == 0)
			{
				return;
			} else {
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:info@scoutic.com?subject=AppForThat"]];
			}
			break;
		case 3: //Save app
		{
			if (buttonIndex == 0) {
				NSCharacterSet *unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:CHARACTERS_NUMBERS] invertedSet];
				appNameText.text = [[appNameText.text componentsSeparatedByCharactersInSet:unacceptedInput] componentsJoinedByString: @""];
				
				if (appNameText.text && ![appNameText.text isEqualToString:@""]) {
					
					NSFileManager *fileManager = [NSFileManager defaultManager];
					NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
					NSString *documentsDirectory = [documentsPaths objectAtIndex:0];
					
					NSArray *cachesPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
					NSString *cacheDirectory = [cachesPaths objectAtIndex:0]; 
					
					NSString *newAppDirectory = [cacheDirectory stringByAppendingPathComponent:appNameText.text];
					
					[fileManager createDirectoryAtPath:newAppDirectory attributes:nil];  

					NSArray *fileList = [fileManager directoryContentsAtPath:documentsDirectory];
					NSString *srcFilePath;
					NSString *dstFilePath;
					for (NSString *file in fileList){
						srcFilePath = [documentsDirectory stringByAppendingPathComponent:file];
						dstFilePath = [newAppDirectory stringByAppendingPathComponent:file];
						BOOL isDir = NO;
						[fileManager fileExistsAtPath:srcFilePath isDirectory:(&isDir)];
						if(!isDir) {
							[fileManager copyItemAtPath:srcFilePath toPath:dstFilePath error:nil];
						}
					}
					
				} else {
					UIAlertView *actionAlert = [[UIAlertView alloc] initWithTitle:@"Name Required" message:@"You must name the app with only numbers or letters.  Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
					[actionAlert setTag:4];
					[actionAlert show];
					[actionAlert release];
				}
			}
			break;
		}
		case 4:
			break;
	}
}

- (void) loadView
{

}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	//clears out old subviews
	for (UIView *view in [[self view] subviews]) {
		[view removeFromSuperview];
	}
	
	// Get document path.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *documentFilePath = [documentsDirectory stringByAppendingPathComponent:@"Background.png"];
	
	// Get app bundle path.
	NSString *appBundleFilePath = [[NSBundle mainBundle] pathForResource:@"Background" ofType:@"png"];
	
	if(![self fileCheck:@"Background.png"])
	{
		
		// Get pointer to file manager.
		NSFileManager *fileManager = [NSFileManager defaultManager];
		
		// Copy the app bundle file to the document directory.
		[fileManager copyItemAtPath:appBundleFilePath toPath:documentFilePath error:nil];
	}
	
	
	MainView *mv = [[MainView alloc] initWithFrame:CGRectZero];
	//[mv setBackgroundColor:[UIColor whiteColor]];
	[mv setBackgroundImage:[UIImage imageWithContentsOfFile:documentFilePath]];
	[self setView:mv];
	[mv release];
	
	//reload
	NSLog(@"reload via viewWillAppear");

	
	NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"scoutic.a4t"];	
	NSDictionary *dictionary = [[[NSDictionary alloc] initWithContentsOfFile:plistPath] autorelease];
	

	////declare variables
	NSDictionary *dictionary2;
	NSString *labelString;
	NSInteger x;
	NSInteger y;
	NSInteger w;
	NSInteger h;
	NSNumber *action;
	NSString *target;
	actionItems = [[NSMutableArray alloc] init];

	////get data from plist
	for (id key in dictionary) {
		
		if ([key isEqualToString:@"buttons"]){
			NSLog(@"object=%@",key);
			for (id myArrayElement in [dictionary objectForKey:key]) {
				dictionary2 = myArrayElement;
				
				action = [dictionary2 objectForKey:@"action"];
				target = [dictionary2 objectForKey:@"target"];
				NSMutableDictionary *tuple = [[NSMutableDictionary alloc] init];
				[tuple setObject:target forKey:@"target"];
				[tuple setObject:action forKey:@"action"];
				[actionItems addObject: tuple];
				[tuple release];
				
				labelString = [dictionary2 objectForKey:@"label"];
				x = [[dictionary2 objectForKey:@"x"] intValue];
				y = [[dictionary2 objectForKey:@"y"] intValue];
				w = [[dictionary2 objectForKey:@"width"] intValue];
				h = [[dictionary2 objectForKey:@"height"] intValue];
				CGRect buttonRect = CGRectMake(x, y, w, h); 
				NSValue *buttonValue = [NSValue valueWithCGRect:buttonRect];
				NSLog(@"%@ ",buttonValue);
				
				if ([labelString isEqualToString:@"scoutic.a4t"])
				{
					UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
					[button setFrame:buttonRect];	
					[button setTag:[actionItems count]];
					[button addTarget:self action:@selector(buttonTargetAction:) forControlEvents:UIControlEventTouchUpInside];
					[[self view] addSubview:button];
				}else {
					UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
					[button setTitle:labelString forState:UIControlStateNormal];
					[button setFrame:buttonRect];	
					[button setTag:[actionItems count]];
					[button addTarget:self action:@selector(buttonTargetAction:) forControlEvents:UIControlEventTouchUpInside];
					[[self view] addSubview:button];
				}

			}
		}
		
		if ([key isEqualToString:@"labels"]){
			NSLog(@"object=%@",key);
			for (id myArrayElement in [dictionary objectForKey:key]) {
				dictionary2 = myArrayElement;
				
				labelString = [dictionary2 objectForKey:@"label"];
				action = [dictionary2 objectForKey:@"action"];
				target = [dictionary2 objectForKey:@"target"];
				x = [[dictionary2 objectForKey:@"x"] intValue];
				y = [[dictionary2 objectForKey:@"y"] intValue];
				w = [[dictionary2 objectForKey:@"width"] intValue];
				h = [[dictionary2 objectForKey:@"height"] intValue];
				CGRect labelRect = CGRectMake(x, y, w, h); 
				NSValue *labelValue = [NSValue valueWithCGRect:labelRect];
				NSLog(@"%@ ",labelValue);
				
				UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
				label.text = labelString;
				//label.font = [UIFont fontWithName:@"Zapfino" size: 14.0];
				//label.shadowColor = [UIColor grayColor];
				//label.shadowOffset = CGSizeMake(1,1);
				//label.textColor = [UIColor blueColor]; 
				//label.backgroundColor = [UIColor clearColor]; // [UIColor brownColor];
				//label.textAlignment = UITextAlignmentRight; // UITextAlignmentCenter, UITextAlignmentLeft
				//label.lineBreakMode = UILineBreakModeWordWrap;
				//label.numberOfLines = 2; // 2 lines ; 0 - dynamical number of lines
				//label.text = @"Lorem ipsum dolor sit\namet...";
				
				[[self view] addSubview:label];
			}
		}
	}
}


- (void)buttonTargetAction:(id)sender {
	NSString *target = [[actionItems objectAtIndex:([sender tag]-1)] objectForKey:@"target"];
	NSNumber *action = [[actionItems objectAtIndex:([sender tag]-1)] objectForKey:@"action"];
	NSString *urlString;
	NSURL *url;
	
	switch([action integerValue])
	{
		case kSafari:
			NSLog(@"kSafari");
			urlString = [NSString stringWithFormat:@"http://%@", target];
			url = [NSURL URLWithString:urlString];
			[[UIApplication sharedApplication] openURL:url];
		/* webView
			UIWebView *webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; 
			NSURLRequest *requestObj = [NSURLRequest requestWithURL:url]; 
			[webView loadRequest:requestObj]; 
			[[self view] addSubview:webView];
			[webView release]; 
		 */
			break;
		case kSMS: 
			NSLog(@"kSMS");
			urlString = [NSString stringWithFormat:@"sms:%@", target];
			url = [NSURL URLWithString:urlString];
			[[UIApplication sharedApplication] openURL:url];
			break;
		case kCall: 
			NSLog(@"kCall");
			urlString = [NSString stringWithFormat:@"tel:%@", target];
			url = [NSURL URLWithString:urlString];
			[[UIApplication sharedApplication] openURL:url];
			break;
		case kMaps: 
			NSLog(@"kMaps");
			NSString* searchQuery =  [target stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
			urlString = [NSString stringWithFormat:@"maps:q=%@", searchQuery];
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
			break;
		case kContacts: 
			NSLog(@"kContacts");
			ABPeoplePickerNavigationController *picker =
			[[ABPeoplePickerNavigationController alloc] init];
			picker.peoplePickerDelegate = self;
			[self presentModalViewController:picker animated:YES];
			[picker release];
			break;
		case kSound:
			NSLog(@"play Sound");
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			NSString *documentFilePath = [documentsDirectory stringByAppendingPathComponent:target];
			url = [NSURL URLWithString:documentFilePath];
			NSLog(@"path = %@",[[NSURL fileURLWithPath:documentFilePath] absoluteString]);
			AVAudioPlayer * avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:documentFilePath]  error:nil];
			[avPlayer prepareToPlay];
			[avPlayer play];
			break;
		case kStore: 
			NSLog(@"kStore");
			urlString = [NSString stringWithFormat:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&amp;mt=8",target];
			url = [NSURL URLWithString:urlString];
			[[UIApplication sharedApplication] openURL:url];
			break;
		case kPicture: 
			NSLog(@"kPicture");
			//take phoot
			UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
			
			//if camer use it else pick a photo
			if ([UIImagePickerController
				 isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
				[imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
			} else {
				[imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
			}
			// image picker need a delegate so we can respond to its messages
			[imagePicker setDelegate:self];
			
			//Place image picker on the screen
			[self presentModalViewController:imagePicker animated:YES];
			
			//The image picker will be retained by ItemDeailViewController until dismissed
			[imagePicker release];
			break;
		case kYouTube: 
			NSLog(@"kYouTube");
			urlString = [NSString stringWithFormat:@"http://www.youtube.com/watch?v=5@",target];
			url = [NSURL URLWithString:urlString];
			[[UIApplication sharedApplication] openURL:url];
			break;
	}
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
	return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
	return YES;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
	[self dismissModalViewControllerAnimated:YES];
	
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	//Get picked image from info dictionary
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
	
	//Put that image onto the screen in our image view
	//[imageView setImage:image];	
	UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
	

	
	//Take image picker off the screen
	//if you impement this method, you must call this dismiss method
	[self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
