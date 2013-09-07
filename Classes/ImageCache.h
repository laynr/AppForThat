//
//  ImageCache.h
//  Homeowner
//
//  Created by me on 2/3/10.
//  Copyright 2010 Scoutic LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageCache : NSObject {
	NSMutableDictionary *dictionary;
}
+ (ImageCache *)sharedImageCache;
- (void) setImage:(UIImage *)i forKey:(NSString *)s;
- (UIImage *)imageForKey:(NSString *)s;
- (void) deleteImageForKey:(NSString *)s;

@end
