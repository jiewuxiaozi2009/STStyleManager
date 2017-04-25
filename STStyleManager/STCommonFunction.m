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

@end
