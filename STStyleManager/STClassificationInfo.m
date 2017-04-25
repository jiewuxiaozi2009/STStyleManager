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
@property (nonatomic, copy) NSMutableArray<STStyleInfo> *styles;

@end

@implementation STClassificationInfo

- (instancetype)initWithClassificationName:(NSString *)classificationName {
    self = [super init];
    if (self) {
        [self setStyles:(NSMutableArray<STStyleInfo> *)[[NSMutableArray alloc] init]];
        [self setName:classificationName];
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
    NSMutableArray *tempStyles = [[NSMutableArray alloc] initWithArray:_styles];
    [tempStyles addObject:style];
    [self setStyles:(NSMutableArray<STStyleInfo> *)tempStyles];
}

- (void)addStyle:(STStyleInfo *)style atIndex:(NSUInteger)index {
    NSMutableArray *tempStyles = [[NSMutableArray alloc] initWithArray:_styles];
    [tempStyles insertObject:style atIndex:index];
    [self setStyles:(NSMutableArray<STStyleInfo> *)tempStyles];
}

- (void)deleteStyle:(STStyleInfo *)style {
    NSMutableArray *tempStyles = [[NSMutableArray alloc] initWithArray:_styles];
    [tempStyles removeObject:style];
    [self setStyles:(NSMutableArray<STStyleInfo> *)tempStyles];
}

- (void)deleteStyleAtIndex:(NSUInteger)index {
    NSMutableArray *tempStyles = [[NSMutableArray alloc] initWithArray:_styles];
    [tempStyles removeObjectAtIndex:index];
    [self setStyles:(NSMutableArray<STStyleInfo> *)tempStyles];
}

- (void)deleteAllStyles {
    NSMutableArray *tempStyles = [[NSMutableArray alloc] initWithArray:_styles];
    [tempStyles removeAllObjects];
    [self setStyles:(NSMutableArray<STStyleInfo> *)tempStyles];
}

@end
