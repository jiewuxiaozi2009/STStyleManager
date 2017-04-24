//
//  STStyleInfo.m
//  STStyleManager
//
//  Created by Lorne Shi on 19/04/2017.
//  Copyright © 2017 Lorne Shi. All rights reserved.
//

#import "STStyleInfo.h"

@interface STStyleInfo ()

@end

@implementation STStyleInfo

- (NSImage<Ignore> *)iconImage {
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *styleIconPath = [NSString stringWithFormat:@"%@/StyleInfo/StyleIcon/%@", resourcePath, _iconFileName];
    _iconImage = [[NSImage alloc] initWithContentsOfFile:styleIconPath];
    return _iconImage;
}

- (NSString<Ignore> *)modelPath {
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    _modelPath = [NSString stringWithFormat:@"%@/StyleInfo/Models/%@", resourcePath, _modelName];
    return _modelPath;
}

- (NSString<Ignore> *)styleImagePath {
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    _styleImagePath = [NSString stringWithFormat:@"%@/StyleInfo/StyleImage/%@", resourcePath, _styleImageName];
    return _styleImagePath;
}

#pragma mark - public functions
+ (STStyleInfo *)createStyleWithName:(NSString *)styleName styleImageFilePath:(NSString *)styleImageFilePath algorithmType:(NSInteger)algorithmType {
    STStyleInfo *style = [[STStyleInfo alloc] init];
    if (!style) {
        NSLog(@"create style field!");
        return nil;
    }
    
    NSString *styleNameAtNoSpace = [styleName stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *iconFileNameTmp = [NSString stringWithFormat:@"%@_icon.jpg", styleNameAtNoSpace];
    NSString *styleImageFileNameTmp = [NSString stringWithFormat:@"%@.jpg",styleNameAtNoSpace];
    [style setName:styleName];
    [style setIconFileName:iconFileNameTmp];
    [style setIsAddButton:false];
    [style setIsHideRemove:false];
    [style setIsHideFavorite:false];
    [style setIsFavorite:false];
    [style setModelName:@"decoder.t7"];
    [style setStyleImageName:styleImageFileNameTmp];
    [style setStyleId:0];
    
    //创建资源
    [style createStyleResourceFromSrcStyleImageFilePath:styleImageFilePath];
    
    return style;
}

- (void)createStyleResourceFromSrcStyleImageFilePath:(NSString *)srcStyleImageFilePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //创建风格图片文件
    [fileManager copyItemAtPath:srcStyleImageFilePath toPath:[self styleImagePath] error:nil];
    
    //创建风格icon文件
    //TODO:目前先用风格图片代替，后期需要缩放裁剪处理
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *styleIconPath = [NSString stringWithFormat:@"%@/StyleInfo/StyleIcon/%@", resourcePath, _iconFileName];
    [fileManager copyItemAtPath:srcStyleImageFilePath toPath:styleIconPath error:nil];
}

- (void)dealloc {
    //删除资源
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[self styleImagePath] error:nil];
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *styleIconPath = [NSString stringWithFormat:@"%@/StyleInfo/StyleIcon/%@", resourcePath, _iconFileName];
    [fileManager removeItemAtPath:styleIconPath error:nil];
}

@end
