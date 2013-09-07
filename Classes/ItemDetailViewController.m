//
//  ItemDetailViewController.m
//  Homeowner
//
//  Created by me on 2/3/10.
//  Copyright 2010 Scoutic LLC. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "ImageCache.h"


@implementation ItemDetailViewController

- (id) init
{
	[super initWithNibName:@"ItemDetailViewController" bundle:nil];
	
	//Create a UIBarButtonItem with a camera icon, will send
	//takePicture: to out ItemDetailViewController when tapped
	UIBarButtonItem *cameraBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
																					target:self
																					   action:@selector(takePicture:)];
	
	//Place this image on our navigation bar when this viewcontroller is on top of the navigation stack
	[[self navigationItem] setRightBarButtonItem:cameraBarButtonItem];
	
	//cameraBarButton is retained by the navigation item
	[cameraBarButtonItem release];
	return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	return [self init];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	
	NSString *oldKey = [editingPossession imageKey];
	
	//Did the possession already have an image"
	if (oldKey)
	{
		//Delete the old key
		[[ImageCache sharedImageCache] deleteImageForKey:oldKey];
	}
	
	//Get picked image from info dictionary
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
	
	//Create a CFUUID object - it knows how to crate unique identifiers
	CFUUIDRef newUniqueID = CFUUIDCreate (kCFAllocatorDefault);
	
	//Create a string from the unique ID
	CFStringRef  newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
	
	//use that unique ID to set our possessions imageKey
	[editingPossession setImageKey:(NSString *)newUniqueIDString];
	
	//We used "Create" in the functions to make objects, weneed to release them
	CFRelease(newUniqueIDString);
	CFRelease(newUniqueID);
	
	//store image in the image chace with this key
	[[ImageCache sharedImageCache] setImage:image forKey:[editingPossession imageKey]];
	
	//Put that image onto the screen in our image view
	[imageView setImage:image];
	
	//Take image picker off the screeno
	//if you impement this method, you must call this dismiss method
	[self dismissModalViewControllerAnimated:YES];
}

//take phoot
- (void)takePicture:(id)sender
{
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
	
	//The image picker will be retained by ItemDeailViewController unit dismissed
	[imagePicker release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[nameField setText:[editingPossession possessionName]];
	[serialNumberField setText:[editingPossession serialNumber]];
	[valueField setText:[NSString stringWithFormat:@"%d",[editingPossession valueInDollars]]];
	
	//Create a NSDateFormatter that will turn a date into a simple data string'
	NSDateFormatter *dataFormatter = [[[NSDateFormatter alloc] init] autorelease];
	
	[dataFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dataFormatter setTimeStyle:NSDateFormatterNoStyle];
	
	//Use filtered NSDate object to set dateLabel contents
	[dataLabel setText:[dataFormatter stringFromDate:[editingPossession dateCreated]]];
	
	//Change the navigation item to display name of possession
	[[self navigationItem] setTitle:[editingPossession possessionName]];
	
	NSString *imageKey = [editingPossession imageKey];
	
	if (imageKey) {
		//get image for image key from image cache
		UIImage *imageToDisplay = [[ImageCache sharedImageCache] imageForKey:imageKey];
		
		//Use that image to put on the screen in image view
		[imageView setImage:imageToDisplay];
	}else {
		//Clear the imageView
		[imageView setImage:nil];
		
	}

}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void) viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	//Clear first responder
	[nameField resignFirstResponder];
	[serialNumberField resignFirstResponder];
	[valueField resignFirstResponder];
	
	//"Save" changes to editing Possession
	[editingPossession setPossessionName:[nameField text]];
	[editingPossession setSerialNumber:[serialNumberField text]];
	[editingPossession setValueInDollars:[[valueField text] intValue]];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [nameField release];
	[serialNumberField release];
	[valueField release];
	[dataLabel release];
	[imageView release];
	nameField = nil;
	serialNumberField = nil;
	valueField = nil;
	dataLabel = nil;
	imageView = nil;
    
}


- (void)setEditingPossession:(Possession *)possession
{
	//Keep a pointer to the incoming possession
	editingPossession = possession;
}


- (void)dealloc {
    [super dealloc];
}


@end
