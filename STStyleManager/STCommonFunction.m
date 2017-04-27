//
//  STCommonFunction.m
//  TestStyleManager
//
//  Created by Lorne Shi on 25/04/2017.
//  Copyright © 2017 Lorne Shi. All rights reserved.
//

#import "STCommonFunction.h"

@implementation STCommonFunction

+ (NSString *)styleIconFileDir:(BOOL)isCustomStyle {
    NSString *styleResourceDir = [STCommonFunction styleResourceDir:isCustomStyle];
    NSString *styleIconFileDir = [NSString stringWithFormat:@"%@/StyleIcon", styleResourceDir];
    return styleIconFileDir;
}

+ (NSString *)styleImageFileDir:(BOOL)isCustomStyle {
    NSString *styleResourceDir = [STCommonFunction styleResourceDir:isCustomStyle];
    NSString *styleImageFileDir = [NSString stringWithFormat:@"%@/StyleImage", styleResourceDir];
    return styleImageFileDir;
}

+ (NSString *)styleModelFileDir:(BOOL)isCustomStyle {
    NSString *styleResourceDir = [STCommonFunction styleResourceDir:isCustomStyle];
    NSString *styleModelFileDir = [NSString stringWithFormat:@"%@/Models", styleResourceDir];
    return styleModelFileDir;
}

+ (NSString *)customStyleManagerFileDir {
    NSString *styleResourceDir = [STCommonFunction styleResourceDir:YES];
    NSString *customStyleManagerFileDir = [NSString stringWithFormat:@"%@/TemplateFile", styleResourceDir];
    return customStyleManagerFileDir;
}

+ (NSString *)styleResourceDir:(BOOL)isCustomStyle {
    NSString *rootDir = nil;
    if (isCustomStyle) {
        NSString *applcationSupport = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,
                                                                           NSUserDomainMask, YES) objectAtIndex:0];
        NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        rootDir = [NSString stringWithFormat:@"%@/%@", applcationSupport, bundleIdentifier];
    } else {
        rootDir = [[NSBundle mainBundle] resourcePath];
    }
    
    NSString *styleResourceDir = [NSString stringWithFormat:@"%@/StyleInfo", rootDir];
    return styleResourceDir;
}

+ (void)saveImage:(NSImage *)image toPath:(NSString *)path type:(NSBitmapImageFileType)type {
    if (image) {
        NSData *imageData = [image TIFFRepresentation];
        NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
        switch (type) {
            case NSBitmapImageFileTypePNG: {
                imageData = [imageRep representationUsingType:type properties:nil];
                break;
            }
            case NSBitmapImageFileTypeJPEG: {
                NSDictionary *imageProps = nil;
                NSNumber *quality = [NSNumber numberWithFloat:1.0];
                imageProps = [NSDictionary dictionaryWithObject:quality forKey:NSImageCompressionFactor];
                imageData = [imageRep representationUsingType:type properties:imageProps];
                break;
            }
            case NSBitmapImageFileTypeTIFF: {
                break;
            }
                
            default:
                break;
        }
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path]) {
            [fileManager removeItemAtPath:path error:nil];
        }
        [imageData writeToFile:path atomically:YES];
    }
}

@end
