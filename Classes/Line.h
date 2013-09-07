//
//  Line.h
//  TouchTracker
//
//  Created by me on 2/4/10.
//  Copyright 2010 Scoutic LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Line : NSObject {
	CGPoint begin;
	CGPoint end;
}
@property (nonatomic) CGPoint begin;
@property (nonatomic) CGPoint end;

@end
