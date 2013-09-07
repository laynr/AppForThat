//
//  Possession.h
//  RandomPossessions
//
//  Created by me on 2/1/10.
//  Copyright 2010 Scoutic LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Possession : NSObject {
	NSString *possessionName;
	NSString *serialNumber;
	int valueInDollars;
	NSDate *dateCreated;
	NSString *imageKey;
}
@property (nonatomic, copy) NSString *imageKey;

@property (nonatomic, copy) NSString *possessionName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (readonly) NSDate *dateCreated;

- (id)initWithPossessionName:(NSString *)pName valueInDollars:(int)value serialNumber:(NSString *)sNumber;
- (id) initWithPossessionName:(NSString *)pName;

+ (id) randomPossession;


@end
