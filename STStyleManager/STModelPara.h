//
//  STModelPara.h
//  STStyleManager
//
//  Created by Lorne Shi on 19/04/2017.
//  Copyright © 2017 Lorne Shi. All rights reserved.
//

//test update

#import <JSONModel/JSONModel.h>

@interface STModelPara : JSONModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) NSNumber *defaultValue;
@property (nonatomic, copy) NSString *valueType;

- (instancetype)initWithName:(NSString *)name
                       value:(NSNumber *)value
                defaultValue:(NSNumber *)defaultValue
                   valueType:(NSString *)valueType;

@end

