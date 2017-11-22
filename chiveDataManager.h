//
//  chiveDataManager.h
//  fengzhuang
//
//  Created by 陈刚 on 16/12/16.
//  Copyright © 2016年 封装文件. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface chiveDataManager : NSObject
/*
 方法描述:
 单例模式创建对象
 返回结果:
 CommonUtils
 */
+ (instancetype)sharedChive;

/**
 *  归档数据
 *  @param dataDic    归档的数据字典
 *  @param pathName   归档的文件名称
 */
-(void)chiveDataDic:(NSDictionary *)dataDic
       withPathName:(NSString *)pathName;
/**
 *  解档数据
 *  @param pathName   解档的文件名称
 */
-(NSDictionary *)unarchivewithPath:(NSString *)pathName;

/**
 *  删除归档数据
 *  @param pathName   归档的文件名称
 */
- (BOOL)RemoveFileWithPath:(NSString *)pathName;

/**
 *  传入文件夹路径，删除子文件
 *
 *  @param directoryPath 文件夹路径
 */
- (BOOL)removeItemAtDirectoryPath:(NSString *)directoryPath;
/**
 *  传入文件夹路径，获取文件夹大小
 *
 *  @param directoryPath 文件夹路径
 *
 *  @return 文件夹尺寸
 */
- (NSInteger)getSizeOfDirectoryPath:(NSString *)directoryPath;
// 清除缓存
- (void)clearFile;
@end
