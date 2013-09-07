//
//  Possession.m
//  RandomPossessions
//
//  Created by me on 2/1/10.
//  Copyright 2010 Scoutic LLC. All rights reserved.
//

#import "Possession.h"


@implementation Possession
@synthesize possessionName, serialNumber, valueInDollars, dateCreated, imageKey;

- (NSString *)description
{
	NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, Recorded on %@", possessionName, serialNumber, valueInDollars, dateCreated];
	
	return [descriptionString autorelease];
}

- (id) initWithPossessionName:(NSString *)pName valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
	[super init];
	
	[self setPossessionName:pName];
	[self setSerialNumber:sNumber];
	[self setValueInDollars:value];
	dateCreated = [[NSDate alloc] init];
	
	return self;
}

- (id) initWithPossessionName:(NSString *)pName;
{
	return [self initWithPossessionName:@"Possession" valueInDollars:0 serialNumber:@""];
}

+ (id) randomPossession
{
	static NSString *randomAdjectiveList[3] = {@"Fluffy", @"Rusty", @"Shiny" };
	static NSString *randomNounList[3] = {@"Bear", @"Spork", @"Mac"};
	
	NSString *randomName = [NSString stringWithFormat:@"%@ %@", randomAdjectiveList[random() %3], randomNounList[random() %3]];
	
	int randomValue = random() %100;
	
	NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c", 
									'0' + random() %10,
									'A' + random() %26,
									'0' + random() %10,
									'A' + random() %26,
									'0' + random() %10];
	
	Possession *newPossession = [[self alloc] initWithPossessionName:randomName 
													  valueInDollars:randomValue
														serialNumber:randomSerialNumber];
	return [newPossession autorelease];
}

- (void)dealloc
{
	[possessionName release];
	[serialNumber release];
	[dateCreated release];
	[imageKey release];
	[super dealloc];
}

@end
