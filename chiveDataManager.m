//
//  chiveDataManager.m
//  fengzhuang
//
//  Created by 陈刚 on 16/12/16.
//  Copyright © 2016年 封装文件. All rights reserved.
//

#import "chiveDataManager.h"

@implementation chiveDataManager

+(instancetype)sharedChive
{
    static chiveDataManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[chiveDataManager alloc] init];
    });
    
    
    return _manager;
    
}
/**
 *  归档数据
 *  @param dataDic    归档的数据字典
 *  @param pathName   归档的文件名称
 */
-(void)chiveDataDic:(NSMutableDictionary *)dataDic withPathName:(NSString *)pathName
{
    //准备工作：文件路径+文件名(xx/Documents/archive)
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:pathName];
    //    NSArray *array = @[@"Bob", @19, @[@"Objective-C", @"Swift"]];
    NSDictionary *myDictionary = dataDic;
    //1.归档：写入数据
    //1.1 准备一个可变的数据类型
    NSMutableData *mutableData = [NSMutableData data];
    //1.2 创建NSKeyedArchiver对象
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mutableData];
    //1.3 对写入的数据进行编码
    [archiver encodeObject:myDictionary forKey:pathName];
    //1.4 完成编码
    [archiver finishEncoding];
    NSLog(@"编码后的数据长度:%lu", (unsigned long)mutableData.length);
    //1.5 写入文件中
    [mutableData writeToFile:filePath atomically:YES];

}
/**
 *  解档数据
 *  @param pathName   解档的文件名称
 */
- (NSDictionary *)unarchivewithPath:(NSString *)pathName
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:pathName];
    //2.1 从指定的文件读取归档的数据
    NSData *readData = [NSData dataWithContentsOfFile:filePath];
    //2.2 创建NSKeyedUnarchiver对象
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:readData];
    //2.3 解码对象
    NSDictionary *dic = [unarchiver decodeObjectForKey:pathName];
    //2.4 完成解码
    [unarchiver finishDecoding];
    //验证数据
    return dic;

    
}

/**
 *  删除归档数据
 *  @param pathName   归档的文件名称
 */
- (BOOL)RemoveFileWithPath:(NSString *)pathName
{

    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:pathName];
    
    return [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    
}

- (BOOL)removeItemAtDirectoryPath:(NSString *)directoryPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    //抛出异常
    //判断传入参数是否正确，不正确抛出异常
    BOOL isDirectory = NO;
    BOOL isExist = [manager fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    
    if (!isDirectory || !isExist) {
        NSException *exception = [NSException exceptionWithName:@"fileError" reason:@"your filePath is not a Directory file" userInfo:nil];
        
        //抛出
        [exception raise];
    }
    
    //获取子文件(只能获取下一级子文件)
    NSArray *subPaths = [manager subpathsAtPath:directoryPath];
    
    
    BOOL isRemove = NO;
    //遍历拼接全路径，移除
    for (NSString *subPath in subPaths) {
        NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
        //移除
      isRemove = [manager removeItemAtPath:filePath error:nil];
    }
    
    return isRemove;
}
// 清除缓存
- (void)clearFile
{
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
    NSArray * files = [[NSFileManager defaultManager ] subpathsAtPath :cachePath];
    for ( NSString * p in files) {
        NSError * error = nil ;
        //获取文件全路径
        NSString * fileAbsolutePath = [cachePath stringByAppendingPathComponent :p];
        if (![p isEqualToString:@"Jpush"]&![p isEqualToString:@"JpushDocument"]) {//极光相关不删除
            if ([[NSFileManager defaultManager ] fileExistsAtPath :fileAbsolutePath]) {
                [[NSFileManager defaultManager ] removeItemAtPath :fileAbsolutePath error :&error];
            }
        }
    }
}
- (NSInteger)getSizeOfDirectoryPath:(NSString *)directoryPath{
    //获取文件管理者
    NSFileManager *manager = [NSFileManager defaultManager];
    
    //判断传入参数是否正确，不正确抛出异常
    BOOL isDirectory = NO;
    BOOL isExist = [manager fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    
    if (!isDirectory || !isExist) {
        NSException *exception = [NSException exceptionWithName:@"fileError" reason:@"your filePath is not a Directory file" userInfo:nil];
        
        //抛出
        [exception raise];
    }
    
    NSInteger totalSize = 0;
    //获取文件夹的子路径
    NSArray *subPaths = [manager subpathsOfDirectoryAtPath:directoryPath error:nil];
    
    for (NSString *subPath in subPaths) {
        NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
        
        //去除隐藏文件和文件夹
        BOOL isDirectory = NO;
        BOOL isExist = [manager fileExistsAtPath:filePath isDirectory:&isDirectory];
        if ([filePath containsString:@".DS"]) continue;
        
        if (isDirectory || !isExist) continue;
        
        //获取文件属性，包含了尺寸属性
        NSInteger fileSize = [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        //累加
        totalSize += fileSize;
    }
    
    return totalSize;
}

@end
