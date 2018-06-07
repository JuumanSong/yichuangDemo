//
//  DYCacheKeys.h
//  RobotResearchReport
//
//  Created by SongXiaojun on 2017/4/11.
//  Copyright © 2017年 datayes. All rights reserved.
//  定义各个缓存的文件目录（统一管理）

#import <Foundation/Foundation.h>

//--------------------可主动删除-------------------
//用户相关
#define CK_UserCache                    @"UserCache"

////已读相关
#define CK_HasRead                      @"UserCache/HasRead"
//记录已读过的新闻Id，key = 文件夹名 + / + nid
#define CK_NewsIDs                      @"UserCache/HasRead/NewsIDs"
//记录已读过的公告id，key = 文件夹名 + / + nid
#define CK_AnnounceIDs                  @"UserCache/HasRead/AnnounceIDs"
//记录已读过的研报id，key = 文件夹名 + / + nid
#define CK_ReportIDs                    @"UserCache/HasRead/ReportIDs"

// 财报相关
// 记录是否隐藏财报空值数据的Key
#define CK_HideFinancialEmptyData       @"UserCache/Financial/HideFinancialEmptyData"

//历史记录相关
//智能盯盘搜索历史记录
#define CK_StareSearch                    @"UserCache/History/StareSearch"
//股票搜索历史记录
#define CK_StockSearch                    @"UserCache/History/StockSearch"


//公告研报pdf
#define CK_ResearchPDFDetail            @"UserCache/HasDownload/ResearchPDF"
//公告研报pdf是否已经下完整
#define CK_HasResearchPDFFinished       @"UserCache/HasDownload/HasResearchPDFFinished"



//存放接口缓存
#define CK_NetCache                     @"UserCache/NetCache"

//存放缓存的图片
#define CK_NetImage                     @"UserCache/NetImage"

//--------------------不可主动删除-------------------

//系统相关（不可主动删除）
#define CK_SystemFile                   @"SystemFile"

//本地-服务器的时间戳差
#define CK_ServerTimeGap                @"SystemFile/ServerTimeGap"

//是否第一次打开
#define CK_IsFirstTime                  @"SystemFile/IsFirstTime"

//新功能介绍版本
#define CK_GuideVersion                 @"SystemFile/GuideVersion"

//上次账号密码登录成功的账号
#define CK_LoginSuccessAccount          @"SystemFile/LoginSuccessAccount"

//用户token信息
#define CK_UserToken                    @"SystemFile/UserToken"

//用户信息
#define CK_UserInfo                     @"SystemFile/UserInfo"


////--------------------下面的不用了--------------------
//
//// 图片缓存相关
//#define CK_IMG_Cache                    @"imgCache"
//// 一图看懂缓存图片文件夹
//#define CK_ONE_PIC_Cache                @"imgCache/onePicCache"
//// 一图看懂裁切图片文件夹
//#define CK_ONE_PIC_CAT_Cache            @"imgCache/onePicCache/cat"
//// 艾瑞易观缓存图片文件夹
//#define CK_ARYG_PIC_Cache               @"imgCache/arygImgs"


