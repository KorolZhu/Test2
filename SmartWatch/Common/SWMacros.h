//
//  SWMacros.h
//  SmartWatch
//
//  Created by zhuzhi on 14/11/16.
//
//

#ifndef SmartWatch_SWMacros_h
#define SmartWatch_SWMacros_h

#define IOS8 [[UIDevice currentDevice] isIOS8]
#define IOS7 [[UIDevice currentDevice] isIOS7]

//动态获取设备高度
#define IPHONE_STATUSBAR_WIDTH          [[UIDevice currentDevice] statusbarWidth]
#define IPHONE_STATUSBAR_HEIGHT         [[UIDevice currentDevice] statusbarHeight]
#define IPHONE_WIDTH                    [[UIDevice currentDevice] screenWidth]
#define IPHONE_HEIGHT                   [[UIDevice currentDevice] screenHeight]
#define IPHONE_HEIGHT_WITHOUTSTATUSBAR  IPHONE_HEIGHT - IPHONE_STATUSBAR_HEIGHT
#define IPHONE_HEIGHT_WITHOUTTOPBAR     IPHONE_HEIGHT - 44 - IPHONE_STATUSBAR_HEIGHT


#define IPHONE_WIDTHDIFF                IPHONE_WIDTH - 320.0f
#define IPHONE_HEIGHTDIFF               IPHONE_HEIGHT - 480.0f
#define IPHONE_WIDTHDIFF_HALF           (IPHONE_WIDTH - 320.0f) / 2.0f
#define IPHONE_HEIGHTDIFF_HALF          (IPHONE_HEIGHT - 480.0f) / 2.0ftBand_WBMacros_h

#define ALARMHOUR @"alarmHour"
#define ALARMMINUTE @"alarmminute"
#define ALARMSTATE @"alarmstate"
#define ALARMREPEAT @"alarmrepeat"

#endif
