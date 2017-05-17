//
//  STCommonFunction.h
//  TestStyleManager
//
//  Created by Lorne Shi on 25/04/2017.
//  Copyright © 2017 Lorne Shi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface STCommonFunction : NSObject

+ (NSString *)styleIconFileDir:(BOOL)isCustomStyle;
+ (NSString *)styleImageFileDir:(BOOL)isCustomStyle;
+ (NSString *)styleModelFileDir:(BOOL)isCustomStyle;

+ (NSString *)styleResourceDir:(BOOL)isCustomStyle;
+ (NSString *)customStyleManagerFileDir;

+ (BOOL)saveImage:(NSImage *)image toPath:(NSString *)path type:(NSBitmapImageFileType)type;

@end
