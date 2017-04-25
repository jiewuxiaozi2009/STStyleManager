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
    self = [super init];
    if (self) {
        //
        NSString *styleNameAtNoSpace = [styleName stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *iconFileNameTmp = [NSString stringWithFormat:@"%@_icon.jpg", styleNameAtNoSpace];
        NSString *styleImageFileNameTmp = [NSString stringWithFormat:@"%@.jpg",styleNameAtNoSpace];
        [self setName:styleName];
        [self setIconFileName:iconFileNameTmp];
        [self setIsCustomStyle:true];
        [self setIsAddStyleButton:false];
        [self setIsFavoriteStyle:false];
        [self setModelName:@"decoder.t7"];
        [self setStyleImageName:styleImageFileNameTmp];
        [self setStyleId:0];
        
        //TODO:需要根据风格转换模块动态获取参数信息
        NSMutableArray *modelParas = [[NSMutableArray alloc] init];
        switch (algorithmType) {
            case 0: {//任意模型，有两个参数
                STModelPara *paraPreserveColor = [[STModelPara alloc] initWithName:@"preserveColor"
                                                                             value:[[NSNumber alloc] initWithInt:0]
                                                                      defaultValue:[[NSNumber alloc] initWithInt:0]
                                                                         valueType:@"AV_INT"];
                [modelParas addObject:paraPreserveColor];
                STModelPara *paraAlpha = [[STModelPara alloc] initWithName:@"alpha"
                                                                     value:[[NSNumber alloc] initWithFloat:0.5]
                                                              defaultValue:[[NSNumber alloc] initWithFloat:1.0]
                                                                 valueType:@"AV_FLOAT"];
                [modelParas addObject:paraAlpha];
                
                break;
            }
                
            default:
                break;
        }
        [self setModelParas:(NSMutableArray<STModelPara> *)modelParas];
        
        //创建资源
        [self createStyleResourceFromSrcStyleImageFilePath:styleImageFilePath];
    }
    
    return self;
}

- (NSImage<Ignore> *)iconImage {
    NSString *styleIconFileDir = [STCommonFunction styleIconFileDir:[self isCustomStyle]];
    NSString *styleIconFilePath = [NSString stringWithFormat:@"%@/%@", styleIconFileDir, _iconFileName];
    _iconImage = [[NSImage alloc] initWithContentsOfFile:styleIconFilePath];
    return _iconImage;
}

- (NSString<Ignore> *)modelPath {
    NSString *styleModelFileDir = [STCommonFunction styleModelFileDir:NO];
    _modelPath = [NSString stringWithFormat:@"%@/%@", styleModelFileDir, _modelName];
    return _modelPath;
}

- (NSString<Ignore> *)styleImagePath {
    NSString *styleImageFileDir = [STCommonFunction styleImageFileDir:[self isCustomStyle]];
    _styleImagePath = [NSString stringWithFormat:@"%@/%@", styleImageFileDir, _styleImageName];
    return _styleImagePath;
}

- (void)createStyleResourceFromSrcStyleImageFilePath:(NSString *)srcStyleImageFilePath {
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
    [fileManager copyItemAtPath:srcStyleImageFilePath toPath:[self styleImagePath] error:nil];
    
    //创建风格icon文件
    //TODO:目前先用风格图片代替，后期需要缩放裁剪处理
    NSString *styleIconFileDir = [STCommonFunction styleIconFileDir:[self isCustomStyle]];
    NSString *styleIconFilePath = [NSString stringWithFormat:@"%@/%@", styleIconFileDir, _iconFileName];
    [fileManager copyItemAtPath:[self styleImagePath] toPath:styleIconFilePath error:nil];
}

- (void)dealloc {
    //删除资源
    if ([self isCustomStyle]) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:[self styleImagePath] error:nil];
        NSString *styleIconFileDir = [STCommonFunction styleIconFileDir:[self isCustomStyle]];
        NSString *styleIconFilePath = [NSString stringWithFormat:@"%@/%@", styleIconFileDir, _iconFileName];
        [fileManager removeItemAtPath:styleIconFilePath error:nil];
    }
}

@end
