//
//  STClassificationInfo.m
//  STStyleManager
//
//  Created by Lorne Shi on 19/04/2017.
//  Copyright © 2017 Lorne Shi. All rights reserved.
//

#import "STClassificationInfo.h"

@interface STClassificationInfo ()

@property (nonatomic, copy) NSString *name;

@end

@implementation STClassificationInfo

+ (STClassificationInfo *)createClassificationWithName:(NSString *)classificationName {
    STClassificationInfo *classification = [[STClassificationInfo alloc] init];
    [classification setName:classificationName];
    NSMutableArray *stylesArr = [[NSMutableArray alloc] init];
    [classification setStyles:(NSMutableArray<STStyleInfo> *)stylesArr];
    
    return classification;
}

- (instancetype)initWithClassificationName:(NSString *)classificationName {
    self = [super init];
    if (self) {
        _styles = (NSMutableArray<STStyleInfo> *)[[NSMutableArray alloc] init];
        _name = classificationName;
    }
    
    return self;
}

- (NSArray *)allStyles {
    return _styles;
}

- (STStyleInfo *)styleAtIndex:(NSUInteger)index {
    return [_styles objectAtIndex:index];
}

- (void)addStyle:(STStyleInfo *)style {
    [_styles addObject:style];
}

- (void)addStyle:(STStyleInfo *)style atIndex:(NSUInteger)index {
    [_styles insertObject:style atIndex:index];
}

- (void)deleteStyle:(STStyleInfo *)style {
    [_styles removeObject:style];
}

- (void)deleteStyleAtIndex:(NSUInteger)index {
    [_styles removeObjectAtIndex:index];
}

- (void)deleteAllStyles {
    [_styles removeAllObjects];
}

@end
