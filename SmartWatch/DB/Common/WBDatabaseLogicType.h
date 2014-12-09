//
//  HTDatabaseType.h
//  WristBand
//
//  Created by zhuzhi on 13-6-20.
//  Copyright (c) 2013年 WB. All rights reserved.
//

#define DATABASE_VERSION  1

typedef enum{
    HTDatabaseOperationTypeInsert,
    HTDatabaseOperationTypeDelete,
	HTDatabaseOperationTypeUpdate,
    HTDatabaseOperationTypeQuery,
    HTDatabaseOperationTypeBatchQuery,    //批量查询
}HTDatabaseOperationType;

typedef enum {
    HTDatabaseLogicTypeDefault = 0,
} HTDatabaseLogicType;