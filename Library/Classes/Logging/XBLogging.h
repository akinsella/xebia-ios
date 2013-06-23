//
// Created by akinsella on 07/04/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

#ifdef DEBUG
    #define XBLogDebug(fmt, ...)   XBLog(fmt, ##__VA_ARGS__)
#else
    #define XBLogDebug(fmt, ...)
#endif

#define XBLogInfo(fmt, ...)    XBLog(fmt, ##__VA_ARGS__)
#define XBLogWarn(fmt, ...)    XBLog(fmt, ##__VA_ARGS__)
#define XBLogError(fmt, ...)   XBLog(fmt, ##__VA_ARGS__)

