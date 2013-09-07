//
//  ItemsViewController.m
//  Homeowner
//
//  Created by me on 2/3/10.
//  Copyright 2010 Scoutic LLC. All rights reserved.
//

#import "ItemsViewController.h"
#import "ItemDetailViewController.h"
#import "Possession.h"


@implementation ItemsViewController

- (id) init
{
	//Call the superclass's designated initializer
	[super initWithStyle:UITableViewStyleGrouped];
	
	//Get the tab bar item
	UITabBarItem *tbi = [self tabBarItem];
	
	//Give it a label
	[tbi setTitle:@"List"];
	
	//Create a UIImage from a file
	UIImage *i = [UIImage imageNamed:@"List.png"];
	
	//Put the image on the bar
	[tbi setImage:i];
	
	//Set the nav bar to have the pre-fabed Edit button when
	// ItemsView Controller is on the top of the stack
	[[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
	
	//Set the title of the nev bar to homeowner when ItemsViewController
	// is on top of the stack
	[[self navigationItem] setTitle:@"App List"];
	
	return self;
}


- (id)initWithStyle:(UITableViewStyle)style {
    return [self init];
}

- (UIView *)headerView
{
	if (headerView) {
		return headerView;
	}

	//Create a UIButton object, simple rounded rect style
	UIButton *editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	//Set the title of this button to "Edit"
	[editButton setTitle:@"Edit" forState:UIControlStateNormal];
	
	//How wide is the screen?
	float w = [[UIScreen mainScreen] bounds].size.width;
	
	//Create a rectangle for the button
	CGRect editButtonFrame = CGRectMake(8,8, w-16,30);
	
	//Use rectangle from before to set its on screen size
	[editButton setFrame:editButtonFrame];
	
	//When this button is tapped, send the message
	//editingButtonPressed: to this instance of ItemsViewController
	[editButton addTarget:self
				   action:@selector(editingButtonPressed:)
		 forControlEvents:UIControlEventTouchUpInside];
	
	//Create a rectable for the headerview that will contain the button
	CGRect headerViewFrame = CGRectMake(0, 0, w, 48);
	headerView = [[UIView alloc] initWithFrame:headerViewFrame];
	
	//Add button to the headerView's view heirarhy
	[headerView addSubview:editButton];
	
	return headerView;
}
				   

- (void)setEditing:(BOOL)flag animated:(BOOL)animated
{
///Always call super implementation of this meathod, it needs to do work
	[super setEditing:flag animated:animated];
	
/*	//You need to insert/remove a new row in to table view
	if (flag) {
		//If entering edit mode, we add another row to our table view
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[possessions count] inSection:0];
		NSArray *paths = [NSArray arrayWithObject:indexPath];
		
		[[self tableView] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationLeft];
	} else {
		// If Leaving edit mode, we remove last row from table view
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[possessions count] inSection:0];
		NSArray *paths = [NSArray arrayWithObject:indexPath];
		
		[[self tableView] deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationLeft];
	}
 */
 
}


- (void)editingButtonPressed:(id) sender
{
	if ([self isEditing]) {
		//Change tect of button to infomr user of state
		[sender setTitle:@"Edit" forState:UIControlStateNormal];
		//Turn off editing mode
		[self setEditing:NO animated:YES];
	} else {
		//change text of button to inform user of state
		[sender setTitle:@"Done" forState:UIControlStateNormal];
		// Enter editing mode
		[self setEditing:YES animated:YES];
	}
}

///for add button
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView 
editingStyleForRowAtIndexPath:(NSIndexPath *) indexPath
{
	if([self isEditing] && [indexPath row] == [possessions count])
	{
		//The last row during ediiting will show an insert style button
		return UITableViewCellEditingStyleInsert;
	}
	// All other row remain deletable
	return UITableViewCellEditingStyleDelete;
}



- (void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
	//if the table view is asking to commit a delete command ...
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		//delete the app
		NSString *appName = [possessions objectAtIndex:[indexPath row]];
		NSArray *cachesPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
		NSString *cacheDirectory = [cachesPaths objectAtIndex:0]; 
		
		NSString *newAppDirectory = [cacheDirectory stringByAppendingPathComponent:appName];
		
		
		NSFileManager *fileManager = [NSFileManager defaultManager];
		[fileManager removeItemAtPath:newAppDirectory error:NULL];
		
		// We remove the row being deleted from the possessions array
		[possessions removeObjectAtIndex:[indexPath row]];
		
		//We also remove that row from the table view with an animation
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
						 withRowAnimation:UITableViewRowAnimationFade];
			
		
		
	} else if (editingStyle == UITableViewCellEditingStyleInsert) {
		//IF the editing sytel of the row was intesertion
		//we add a new pessssion object and and new row to the table view
		[possessions addObject:[Possession randomPossession]];
		[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
	}
}

-(BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	//Only allow rows showing possessions to move
/*	if ([indexPath row] < [possessions count])
	{
		return YES;
	}
 */
	return NO;
}

-(NSIndexPath *)tableView:(UITableView *)tableView
targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
	if([proposedDestinationIndexPath row] < [possessions count]) {
		//If we are moving to a row that currently is showing a possession
		//then returnthe row the user wanted to move to
		return proposedDestinationIndexPath;
	}
	// We  get here if we are trying to move a row to under the "add new Item.."
	//row, have the moging row go one fow aboit it instead.
	NSIndexPath *betterIndexPath = [NSIndexPath indexPathForRow:[possessions count]-1 inSection:0];
	return betterIndexPath;
}
	

- (void) tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
 toIndexPath:(NSIndexPath *)toIndexPath
{
	// Get pointer to object being moved
	Possession *p = [possessions objectAtIndex:[fromIndexPath row]];
	
	//Retain p so that it is not deallacoted whe it is remvoed from the array
	[p retain];
	// Retain count of p is now 2
	
	//Remove p from our array, it is automatically sent relase
	[possessions removeObjectAtIndex:[fromIndexPath row]];
	 // Retain count of p is now 1
	 
	 //Re-insert p into array at new location, it is automatically retained
	 [possessions insertObject:p atIndex:[toIndexPath row]];
	 // Retain count of p is now 2
	 
	 //Release p
	 [p release];
	 // Retain count of p is now 1
}
					 
					 
	   
/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/


/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	[headerView release];
	headerView = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
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
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int numberOfRows = [possessions count];
	//If we are editing we will have ome more row than we have pessions
/*	if ([self isEditing])
	{
		numberOfRows++;
	}
 */
	return numberOfRows;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//Check for a reusable cell first, use that if it exists
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
	
	if (!cell){
		// if not Create an instance of UITableViewCell , with default appearance
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
													reuseIdentifier:@"UITableViewCell"] autorelease];
	}
	
	//If the table view is filling a row with a possession in it do as normal
	if ([indexPath row]<[possessions count]) {
		[[cell textLabel] setText:[[possessions objectAtIndex:[indexPath row]] description]];
	} else { //otherwise if we are editing we have one extra row...
		[[cell textLabel] setText:@"Add New Item.."];
	}
	
	
	return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
	//Create an array of possession objects
	possessions = [[NSMutableArray alloc] init];
	NSArray *cachesPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
	NSString *cacheDirectory = [cachesPaths objectAtIndex:0]; 
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSArray *fileList = [fileManager directoryContentsAtPath:cacheDirectory];
	NSString *srcFilePath;
	for (NSString *file in fileList){
		srcFilePath = [cacheDirectory stringByAppendingPathComponent:file];
		BOOL isDir = NO;
		[fileManager fileExistsAtPath:srcFilePath isDirectory:(&isDir)];
		if(isDir) {
			[possessions addObject:file];
		}
	}
	
	[super viewWillAppear:animated];
	[[self	tableView] reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
/*    // Do I need to create the instance of Itme DetailViewController"
	if (detailViewController == nil) {
		detailViewController = [[ItemDetailViewController alloc] init];
	}
	
	//Give detail view controller a pointer to the possession object in row
	[detailViewController setEditingPossession:[possessions objectAtIndex:[indexPath row]]];
	
	//push it onto the top of the navigation controllers's stack
	[[self navigationController] pushViewController:detailViewController animated:YES];
 */
	NSString *appName = [possessions objectAtIndex:[indexPath row]];
	NSLog(@"selected %@", appName);
	
	[self removeItemsInDocumentsDirectory];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [documentsPaths objectAtIndex:0];
	
	NSArray *cachesPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
	NSString *cacheDirectory = [cachesPaths objectAtIndex:0]; 
	
	NSString *newAppDirectory = [cacheDirectory stringByAppendingPathComponent:appName];
	
	
	NSArray *fileList = [fileManager directoryContentsAtPath:newAppDirectory];
	NSString *srcFilePath;
	NSString *dstFilePath;
	for (NSString *file in fileList){
		srcFilePath = [newAppDirectory stringByAppendingPathComponent:file];
		dstFilePath = [documentsDirectory stringByAppendingPathComponent:file];
		BOOL isDir = NO;
		[fileManager fileExistsAtPath:srcFilePath isDirectory:(&isDir)];
		if(!isDir) {
			[fileManager copyItemAtPath:srcFilePath toPath:dstFilePath error:nil];
		}
	}
	[self.navigationController popToRootViewControllerAnimated: NO];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
    [super dealloc];
}


@end

