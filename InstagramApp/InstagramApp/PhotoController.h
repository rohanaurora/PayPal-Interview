//
//  PhotoController.h
//  InstagramApp
//
//  Created by Rohan Aurora on 6/14/14.
//  Copyright (c) 2014 Rohan Aurora. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoController : NSObject

+ (void) imageForPhoto:(NSDictionary*) photo size:(NSString*) size completion:(void(^)(UIImage *image))completion;

@end
