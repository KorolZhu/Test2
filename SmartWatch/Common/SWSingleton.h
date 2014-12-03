//
//  SWSingleton.h
//  SmartWatch
//
//  Created by zhuzhi on 14/11/16.
//
//

#ifndef SmartWatch_SWSingleton_h
#define SmartWatch_SWSingleton_h

#define SW_AS_SINGLETON( __class , __method) \
+ (__class *)__method;


#define SW_DEF_SINGLETON( __class , __method ) \
+ (__class *)__method {\
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

#endif
