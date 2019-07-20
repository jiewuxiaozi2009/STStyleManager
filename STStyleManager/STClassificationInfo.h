//
//  STClassificationInfo.h
//  STStyleManager
//
//  Created by Lorne Shi on 19/04/2017.
//  Copyright © 2017 Lorne Shi. All rights reserved.
//

#import <JSONModel/JSONModel.h>
// test fork
@protocol STStyleInfo;
@class STStyleInfo;

@interface STClassificationInfo : JSONModel

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, assign) NSInteger hotClassificationIndex;

- (instancetype)initWithClassificationName:(NSString *)classificationName;

- (NSArray *)allStyles;
- (STStyleInfo *)styleAtIndex:(NSUInteger)index;
- (void)addStyle:(STStyleInfo *)style;
- (void)addStyle:(STStyleInfo *)style atIndex:(NSUInteger)index;
- (void)deleteStyle:(STStyleInfo *)style;
- (void)deleteStyleAtIndex:(NSUInteger)index;
- (void)deleteAllStyles;

@end
