//
//  STModelPara.m
//  STStyleManager
//
//  Created by Lorne Shi on 19/04/2017.
//  Copyright © 2017 Lorne Shi. All rights reserved.
//

#import "STModelPara.h"

@implementation STModelPara

- (instancetype)initWithName:(NSString *)name
                       value:(NSNumber *)value
                defaultValue:(NSNumber *)defaultValue
                   valueType:(NSString *)valueType {
    self = [super init];
    if (self) {
        //
        [self setName:name];
        [self setValue:value];
        [self setDefaultValue:defaultValue];
        [self setValueType:valueType];
    }
    
    return self;
}

- (void)dealloc {
    
}

@end
