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

+ (BOOL)saveImage:(NSImage *)image toPath:(NSString *)path type:(NSBitmapImageFileType)type {
    BOOL result = NO;
    if (image) {
        NSData *imageData = [image TIFFRepresentation];
        NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
        switch (type) {
            case NSPNGFileType: {
                imageData = [imageRep representationUsingType:type properties:(NSDictionary<NSBitmapImageRepPropertyKey,id> * _Nonnull)nil];
                break;
            }
            case NSJPEGFileType: {
                NSDictionary *imageProps = nil;
                NSNumber *quality = [NSNumber numberWithFloat:1.0];
                imageProps = [NSDictionary dictionaryWithObject:quality forKey:NSImageCompressionFactor];
                imageData = [imageRep representationUsingType:type properties:imageProps];
                break;
            }
            case NSTIFFFileType: {
                break;
            }
                
            default:
                break;
        }
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path]) {
            [fileManager removeItemAtPath:path error:nil];
        }
        result = [imageData writeToFile:path atomically:YES];
    }
    
    return result;
}

+ (CGContextRef)newBitmapContextFromImageRef:(CGImageRef)imageRef
                                   scaleSize:(NSSize)size
                                     isScale:(BOOL)isScale {
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace = NULL;
    uint32_t *bitmapData = NULL;
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel = 4 * bitsPerComponent;
    size_t bytesPerPixel = bitsPerPixel / bitsPerComponent;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    if (isScale) {
        width = size.width;
        height = size.height;
    }
    size_t bytesperRow = width * bytesPerPixel;
    size_t bufferLength = bytesperRow * height;
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if(!colorSpace) {
        NSLog(@"Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data
    bitmapData = (uint32_t *)malloc(bufferLength);
    
    if(!bitmapData) {
        NSLog(@"Error allocating memory for bitmap\n");
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    
    //Create bitmap context
    context = CGBitmapContextCreate(bitmapData,
                                    width,
                                    height,
                                    bitsPerComponent,
                                    bytesperRow,
                                    colorSpace,
                                    kCGImageAlphaPremultipliedLast| kCGBitmapByteOrder32Big);
    if(!context) {
        free(bitmapData);
        NSLog(@"Bitmap context not created");
    }
    
    CGColorSpaceRelease(colorSpace);
    
    return context;
}

+ (NSImage *)scaleImage:(NSImage *)image toSize:(NSSize)size {
    CGImageRef imageRef = [image CGImageForProposedRect:NULL context:NULL hints:NULL];
    CGFloat srcWidth = CGImageGetWidth(imageRef);
    CGFloat srcHeight = CGImageGetHeight(imageRef);
    
    float verticalRadio = size.height * 1.0 / srcHeight;
    float horizontalRadio = size.width * 1.0 / srcWidth;
    
    float radio = 1;
    if(verticalRadio > 1 && horizontalRadio > 1) {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    } else {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    NSUInteger destWidth = srcWidth * radio;
    NSUInteger destHeight = srcHeight * radio;
    
    CGContextRef context = [self newBitmapContextFromImageRef:imageRef
                                                    scaleSize:CGSizeMake(destWidth, destHeight)
                                                      isScale:YES];
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, destWidth, destHeight), imageRef);
    //获取CGContextRef中的rawdata的指针
    unsigned char *bitmapData = (unsigned char *)CGBitmapContextGetData(context);
    size_t bufferLength = destWidth * destHeight * 4;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bitmapData, bufferLength, NULL);
    size_t bitsPerComponent = 8;
    size_t bitsPerPixel = 32;
    size_t bytesPerRow = 4 * destWidth;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast| kCGBitmapByteOrder32Big;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    CGImageRef iref = CGImageCreate(destWidth,
                                    destHeight,
                                    bitsPerComponent,
                                    bitsPerPixel,
                                    bytesPerRow,
                                    colorSpaceRef,
                                    bitmapInfo,
                                    provider,   // data provider
                                    NULL,       // decode
                                    YES,        // should interpolate
                                    renderingIntent);
    
    NSImage *outimage = [[NSImage alloc] initWithCGImage:iref size:NSMakeSize(destWidth, destHeight)];
    
    return outimage;
}

@end
