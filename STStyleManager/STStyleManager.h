//
//  STStyleManager.h
//  STStyleManager
//
//  Created by Lorne Shi on 19/04/2017.
//  Copyright © 2017 Lorne Shi. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "STClassificationInfo.h"
#import "STCommonFunction.h"
#import "STStyleInfo.h"
#import "STModelPara.h"

@interface STStyleManager : JSONModel

//创建并初始化风格管理器
- (instancetype)initWithJsonFilePath:(NSString *)jsonFilePath;

//获取风格管理器中的所有分类
- (NSArray *)allClassifications;

//获取风格管理器中的某个分类
- (STClassificationInfo *)classificationAtIndex:(NSUInteger)index;

//创建一个分类
- (STClassificationInfo *)createClassificationWithName:(NSString *)classificationName;

//添加分类到风格管理器
- (void)addClassification:(STClassificationInfo *)classification;
- (void)addClassification:(STClassificationInfo *)classification atIndex:(NSUInteger)index;

//删除风格管理器中的分类
- (void)deleteClassification:(STClassificationInfo *)classification;
- (void)deleteClassificationAtIndex:(NSUInteger)index;
- (void)deleteAllClassifications;

//获取风格管理器中的某一分类下所有风格
- (NSArray *)allStylesFromeClassificationIndex:(NSUInteger)classificationIndex;

//获取风格管理器中某个分类下的某一个风格
- (STStyleInfo *)styleAtIndex:(NSUInteger)styleIndex fromClassificationIndex:(NSUInteger)classificationIndex;

//创建一个风格
- (STStyleInfo *)createStyleWithName:(NSString *)styleName
                  styleImageFilePath:(NSString *)styleImageFilePath
                       algorithmType:(NSInteger)algorithmType;

//添加一个风格到风格管理器中的指定分类
- (void)addStyle:(STStyleInfo *)style toClassificationIndex:(NSUInteger)index;
- (void)addStyle:(STStyleInfo *)style atIndex:(NSUInteger)styleIndex toClassificationIndex:(NSUInteger)classificationIndex;

//从风格管理器中的指定分类下删除风格
- (void)deleteStyle:(STStyleInfo *)style fromClassificationIndex:(NSUInteger)classificationIndex;
- (void)deleteStyleAtIndex:(NSUInteger)styleIndex fromClassificationIndex:(NSUInteger)classificationIndex;
- (void)deleteAllStyleFromeClassificationIndex:(NSUInteger)classificationIndex;

//更新风格管理器json文件
- (void)updateStyleManagerFile;

@end
