//
//  CmdDefines.h
//  SmartWatch
//
//  Created by zhuzhi on 14/12/8.
//
//

#ifndef SmartWatch_CmdDefines_h
#define SmartWatch_CmdDefines_h

// 设置日期时间
#define BLE_CMD_SET_DATE_TIME_REQUEST 0x01
#define BLE_CMD_SET_DATE_TIME_RESPONSE 0x81

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

// 读写运动步数目标
#define BLE_CMD_SET_STEPTARGET_REQUEST 0x0B
#define BLE_CMD_SET_STEPTARGET_RESPONSE 0x8B

// 设置闹钟
#define BLE_CMD_SET_ALARM_REQUEST 0x03
#define BLE_CMD_SET_ALARM_RESPONSE 0x83

// 写身高体重性别
#define BLE_CMD_SET_BODY_REQUEST 0x0C
#define BLE_CMD_SET_BODY_RESPONSE 0x8C

// 获取电池电量
#define BLE_CMD_GET_BATTERY_REQUEST 0x0E
#define BLE_CMD_GET_BATTERY_RESPONSE 0x8E

// 获取紫外线等级
#define BLE_CMD_GET_INDEX_REQUEST 0x07
#define BLE_CMD_GET_INDEX_RESPONSE 0x87

// 设置女性生理参数
#define BLE_CMD_SET_WOMEN_REQUEST 0x1E
#define BLE_CMD_SET_WOMEN_RESPONSE 0x9E

// 开启／停止防丢
#define BLE_CMD_PREVENT_LOST_REQUEST 0x43
#define BLE_CMD_PREVENT_LOST_RESPONSE 0xC3

#endif
