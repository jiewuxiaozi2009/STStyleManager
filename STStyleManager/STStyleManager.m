//
//  STStyleManager.m
//  STStyleManager
//
//  Created by Lorne Shi on 19/04/2017.
//  Copyright © 2017 Lorne Shi. All rights reserved.
//

#import "STStyleManager.h"

@protocol STClassificationInfo;

@interface STStyleManager ()

@property (nonatomic, copy) NSString<Ignore> *styleManagerFilePath;
@property (nonatomic, copy) NSMutableArray<STClassificationInfo> *classifications;

@end

@implementation STStyleManager

#pragma mark -
#pragma mark Initialization

- (instancetype)initWithJsonFilePath:(NSString *)jsonFilePath {
    NSError *error = nil;
    NSString *jsonContents = [NSString stringWithContentsOfFile:jsonFilePath
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
    self = [super initWithString:jsonContents error:&error];
    if (error) {
        NSLog(@"STStyleManager Initialization field!\n %@", error);
    }
    if (self) {
        //add code
        [self setStyleManagerFilePath:jsonFilePath];
    }
    
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //
        [self setStyleManagerFilePath:nil];
        [self setClassifications:[(NSMutableArray<STClassificationInfo> *)[NSMutableArray alloc] init]];
    }
    
    return self;
}

- (void)dealloc {
    
}

#pragma mark - public functions
- (NSArray *)allClassifications {
    return _classifications;
}

- (STClassificationInfo *)classificationAtIndex:(NSUInteger)index {
    return [_classifications objectAtIndex:index];
}

- (STClassificationInfo *)createClassificationWithName:(NSString *)classificationName {
    STClassificationInfo *classification = [[STClassificationInfo alloc] initWithClassificationName:classificationName];
    if (!classification) {
        NSLog(@"create classification %@ field!", classificationName);
        return classification;
    }
    
    return classification;
}

- (void)addClassification:(STClassificationInfo *)classification {
    NSMutableArray *tempClassifications = [[NSMutableArray alloc] initWithArray:_classifications];
    [tempClassifications addObject:classification];
    [self setClassifications:(NSMutableArray<STClassificationInfo> *)tempClassifications];
}

- (void)addClassification:(STClassificationInfo *)classification atIndex:(NSUInteger)index {
    NSMutableArray *tempClassifications = [[NSMutableArray alloc] initWithArray:_classifications];
    [tempClassifications insertObject:classification atIndex:index];
    [self setClassifications:(NSMutableArray<STClassificationInfo> *)tempClassifications];
}

- (void)deleteClassification:(STClassificationInfo *)classification {
    NSMutableArray *tempClassifications = [[NSMutableArray alloc] initWithArray:_classifications];
    [tempClassifications removeObject:classification];
    [self setClassifications:(NSMutableArray<STClassificationInfo> *)tempClassifications];
}

- (void)deleteClassificationAtIndex:(NSUInteger)index {
    NSMutableArray *tempClassifications = [[NSMutableArray alloc] initWithArray:_classifications];
    [tempClassifications removeObjectAtIndex:index];
    [self setClassifications:(NSMutableArray<STClassificationInfo> *)tempClassifications];
}

- (void)deleteAllClassifications {
    NSMutableArray *tempClassifications = [[NSMutableArray alloc] initWithArray:_classifications];
    [tempClassifications removeAllObjects];
    [self setClassifications:(NSMutableArray<STClassificationInfo> *)tempClassifications];
}

- (NSArray *)allStylesFromeClassificationIndex:(NSUInteger)classificationIndex {
    return [[_classifications objectAtIndex:classificationIndex] allStyles];
}

- (STStyleInfo *)styleAtIndex:(NSUInteger)styleIndex fromClassificationIndex:(NSUInteger)classificationIndex {
    return [[_classifications objectAtIndex:classificationIndex] styleAtIndex:styleIndex];
}

- (STStyleInfo *)createStyleWithName:(NSString *)styleName
                  styleImageFilePath:(NSString *)styleImageFilePath
                       algorithmType:(NSInteger)algorithmType {
    STStyleInfo *style = [[STStyleInfo alloc] initWithName:styleName
                                        styleImageFilePath:styleImageFilePath
                                             algorithmType:algorithmType];
    if (!style) {
        NSLog(@"create style field!");
        return style;
    }
    
    return style;
}

- (void)addStyle:(STStyleInfo *)style toClassificationIndex:(NSUInteger)index {
    [[_classifications objectAtIndex:index] addStyle:style];
}

- (void)addStyle:(STStyleInfo *)style atIndex:(NSUInteger)styleIndex toClassificationIndex:(NSUInteger)classificationIndex {
    [[_classifications objectAtIndex:classificationIndex] addStyle:style atIndex:styleIndex];
}

- (void)deleteStyle:(STStyleInfo *)style fromClassificationIndex:(NSUInteger)classificationIndex {
    [[_classifications objectAtIndex:classificationIndex] deleteStyle:style];
}

- (void)deleteStyleAtIndex:(NSUInteger)styleIndex fromClassificationIndex:(NSUInteger)classificationIndex {
    [[_classifications objectAtIndex:classificationIndex] deleteStyleAtIndex:styleIndex];
}

- (void)deleteAllStyleFromeClassificationIndex:(NSUInteger)classificationIndex {
    [[_classifications objectAtIndex:classificationIndex] deleteAllStyles];
}

- (void)updateStyleManagerFile {
    NSData *jsonData = [self toJSONData];
    [jsonData writeToFile:_styleManagerFilePath atomically:YES];
}

@end
