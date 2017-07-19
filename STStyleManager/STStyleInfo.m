//
//  STStyleInfo.m
//  STStyleManager
//
//  Created by Lorne Shi on 19/04/2017.
//  Copyright © 2017 Lorne Shi. All rights reserved.
//

#import "STStyleInfo.h"
#import "STModelPara.h"
#import "STCommonFunction.h"

@interface STStyleInfo ()

@end

@implementation STStyleInfo

- (instancetype)initWithName:(NSString *)styleName
          styleImageFilePath:(NSString *)styleImageFilePath
               algorithmType:(NSInteger)algorithmType {
    if (styleName == nil ||
        styleImageFilePath == nil) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        //
        NSString *styleNameAtNoSpace = [styleName stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *iconFileNameTmp = [NSString stringWithFormat:@"st_%@_icon.png", styleNameAtNoSpace];
        NSString *styleImageFileNameTmp = [NSString stringWithFormat:@"st_%@.png",styleNameAtNoSpace];
        NSString *styleFeatureDesNameTmp = [NSString stringWithFormat:@"st_%@.t7",styleNameAtNoSpace];
        [self setName:styleName];
        [self setIconFileName:iconFileNameTmp];
        [self setIsCustomStyle:true];
        [self setIsAddStyleButton:false];
        [self setIsFavoriteStyle:false];
        [self setIsRecommendStyle:false];
        [self setStyleImageName:styleImageFileNameTmp];
        [self setStyleFeatureDesName:styleFeatureDesNameTmp];
        [self setStyleId:0];
        [self setAlgorithmType:algorithmType];
        [self setBeforeFilterIndex:-1];
        [self setAfterFilterIndex:-1];
        
        //TODO:需要根据风格转换模块动态获取参数信息
        NSMutableArray *modelParas = [[NSMutableArray alloc] init];
        NSString *modelName = @"adain_decoder.t7";
        switch (algorithmType) {
            case 0: {//快速任意风格迁移模型，有两个参数
                modelName = @"adain_decoder.t7";
                STModelPara *paraAlpha = [[STModelPara alloc] initWithName:@"alpha"
                                                                     value:[[NSNumber alloc] initWithFloat:1.0]
                                                              defaultValue:[[NSNumber alloc] initWithFloat:1.0]
                                                                 valueType:@"AV_FLOAT"];
                [modelParas addObject:paraAlpha];
                STModelPara *paraDensity = [[STModelPara alloc] initWithName:@"density"
                                                                             value:[[NSNumber alloc] initWithFloat:0.7]
                                                                      defaultValue:[[NSNumber alloc] initWithFloat:0.7]
                                                                         valueType:@"AV_FLOAT"];
                STModelPara *paraPreserveColor = [[STModelPara alloc] initWithName:@"preserveColor"
                                                                             value:[[NSNumber alloc] initWithInt:0]
                                                                      defaultValue:[[NSNumber alloc] initWithInt:0]
                                                                         valueType:@"AV_INT"];
                [modelParas addObject:paraPreserveColor];
                [modelParas addObject:paraDensity];
                break;
            }
            case 1: {//慢速任意风格迁移模型，有两个参数
                modelName = @"patch_based_decoder.t7";
                STModelPara *paraPatchSize = [[STModelPara alloc] initWithName:@"patchSize"
                                                                     value:[[NSNumber alloc] initWithFloat:3]
                                                              defaultValue:[[NSNumber alloc] initWithFloat:3]
                                                                 valueType:@"AV_INT"];
                [modelParas addObject:paraPatchSize];
                STModelPara *paraPatchStride = [[STModelPara alloc] initWithName:@"patchStride"
                                                                             value:[[NSNumber alloc] initWithInt:1]
                                                                      defaultValue:[[NSNumber alloc] initWithInt:1]
                                                                         valueType:@"AV_INT"];
                [modelParas addObject:paraPatchStride];
                break;
            }
            case 3: {//颜色迁移算法，无参数
                break;
            }
                
            default:
                break;
        }
        
        [self setModelName:modelName];
        [self setModelParas:(NSMutableArray<STModelPara> *)modelParas];
        
        //创建资源
        BOOL result = FALSE;
        result = [self createStyleResourceFromSrcStyleImageFilePath:styleImageFilePath];
        if (!result) {
            NSLog(@"资源创建失败！");
            return nil;
        }
    }
    
    return self;
}

- (NSImage<Ignore> *)iconImage {
    if (!_iconImage) {
        NSString *styleIconFileDir = [STCommonFunction styleIconFileDir:[self isCustomStyle]];
        NSString *styleIconFilePath = [NSString stringWithFormat:@"%@/%@", styleIconFileDir, _iconFileName];
        _iconImage = [[NSImage alloc] initWithContentsOfFile:styleIconFilePath];
    }

    return _iconImage;
}

- (NSString<Ignore> *)modelPath {
    if (!_modelPath) {
        NSString *styleModelFileDir = [STCommonFunction styleModelFileDir:NO];
        _modelPath = [NSString stringWithFormat:@"%@/%@", styleModelFileDir, _modelName];
    }

    return _modelPath;
}

- (NSString<Ignore> *)styleImagePath {
    if (!_styleImagePath) {
        NSString *styleImageFileDir = [STCommonFunction styleImageFileDir:[self isCustomStyle]];
        _styleImagePath = [NSString stringWithFormat:@"%@/%@", styleImageFileDir, _styleImageName];
    }

    return _styleImagePath;
}

- (NSString<Ignore> *)styleFeatureDesFilePath {
    if (!_styleFeatureDesFilePath) {
        NSString *styleImageFileDir = [STCommonFunction styleImageFileDir:[self isCustomStyle]];
        _styleFeatureDesFilePath = [NSString stringWithFormat:@"%@/%@", styleImageFileDir, _styleFeatureDesName];
    }
    
    return _styleFeatureDesFilePath;
}

- (BOOL)createStyleResourceFromSrcStyleImageFilePath:(NSString *)srcStyleImageFilePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //创建自定义风格的资源文件目录
    NSError *error = nil;
    BOOL resulet = FALSE;
    resulet = [fileManager createDirectoryAtPath:[STCommonFunction styleImageFileDir:YES]
                     withIntermediateDirectories:YES attributes:nil
                                           error:&error];
    resulet = [fileManager createDirectoryAtPath:[STCommonFunction styleIconFileDir:YES]
                     withIntermediateDirectories:YES attributes:nil
                                           error:&error];
    resulet = [fileManager createDirectoryAtPath:[STCommonFunction styleModelFileDir:YES]
                     withIntermediateDirectories:YES attributes:nil
                                           error:&error];
    
    //创建风格图片文件
    NSImage *originalStyleImage = [[NSImage alloc] initWithContentsOfFile:srcStyleImageFilePath];
    NSImage *zoomStyleImage512 = originalStyleImage;
    if (MAX(originalStyleImage.size.width, originalStyleImage.size.height) > 512.0) {
        zoomStyleImage512 = [STCommonFunction scaleImage:originalStyleImage toSize:NSMakeSize(512.0, 512.0)];
    }
    resulet = [STCommonFunction saveImage:zoomStyleImage512 toPath:[self styleImagePath] type:NSPNGFileType];
    
    //创建风格icon文件
    //TODO:目前先用风格图片代替，后期需要缩放裁剪处理
    NSString *styleIconFileDir = [STCommonFunction styleIconFileDir:[self isCustomStyle]];
    NSString *styleIconFilePath = [NSString stringWithFormat:@"%@/%@", styleIconFileDir, _iconFileName];
    [fileManager copyItemAtPath:[self styleImagePath] toPath:styleIconFilePath error:nil];
    
    if (resulet && error == nil) {
        resulet = TRUE;
    }
    
    return resulet;
}

- (void)dealloc {
    
}

- (void)deleteStyleResource {
    if ([self isCustomStyle]) {
        NSError *error = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL result = [fileManager removeItemAtPath:[self styleImagePath] error:&error];
        if (!result && error != nil) {
            NSLog(@"删除风格图片文件失败！---path = %@", [self styleImagePath]);
        }
        result = [fileManager removeItemAtPath:[self styleFeatureDesFilePath] error:&error];
        if (!result && error != nil) {
            NSLog(@"删除风格图片特征信息文件失败！---path = %@", [self styleFeatureDesFilePath]);
        }
        NSString *styleIconFileDir = [STCommonFunction styleIconFileDir:[self isCustomStyle]];
        NSString *styleIconFilePath = [NSString stringWithFormat:@"%@/%@", styleIconFileDir, [self iconFileName]];
        result = [fileManager removeItemAtPath:styleIconFilePath error:&error];
        if (!result && error != nil) {
            NSLog(@"删除风格图片特征信息文件失败！---path = %@", styleIconFilePath);
        }
    }
}

@end
