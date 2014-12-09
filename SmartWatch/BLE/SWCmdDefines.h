//
//  CmdDefines.h
//  SmartWatch
//
//  Created by zhuzhi on 14/12/8.
//
//

#ifndef SmartWatch_CmdDefines_h
#define SmartWatch_CmdDefines_h

// 获取活动数量
#define BLE_CMD_ACTIVITY_COUNT_REQUEST 0x10
#define BLE_CMD_ACTIVITY_COUNT_RESPONSE 0x90

// 获取活动
#define BLE_CMD_ACTIVITY_GETBYSN_REQUEST 0x13
#define BLE_CMD_ACTIVITY_GETBYSN_RESPONSE 0x93

// 设置白天模式
#define BLE_CMD_SET_DAYMODE_REQUEST 0x02
#define BLE_CMD_SET_DAYMODE_RESPONSE 0x82

// 获取白天模式
#define BLE_CMD_GET_DAYMODE_REQUEST 0x06
#define BLE_CMD_GET_DAYMODE_RESPONSE 0x86

// 设置闹钟
#define BLE_CMD_SET_ALARM_REQUEST 0x03
#define BLE_CMD_SET_ALARM_RESPONSE 0x83

// 写身高体重性别
#define BLE_CMD_SET_BODY_REQUEST 0x0C
#define BLE_CMD_SET_BODY_RESPONSE 0x8C

#endif
