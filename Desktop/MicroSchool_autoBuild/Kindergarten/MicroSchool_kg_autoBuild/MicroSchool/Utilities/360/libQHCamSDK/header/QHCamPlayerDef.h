//
//  QHCamPlayerDef.h
//  QHCamSDK
//
//  Created by chengbao on 16/3/3.
//  Copyright © 2016年 qihoo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TalkType){
    TalkTypeNotSupport = 0, // 错误 - 不支持
    TalkTypeDuijiang = 1, // 对讲模式
    TalkTypePhone = 2, // 电话模式
};

typedef enum {
    VMP_GET_RELAYINFO_FAILURE,               //获取relay info失败
    VMP_GET_RELAYINFO_SUCCESS,               //获取relay info成功
    VPM_OPEN_PLAYER_FAILURE,                 //播放器打开失败
    VPM_OPEN_PLAYER_SUCCESS,                 //播放器打开成功
    VPM_CLOSE_PLAYER_FAILURE,
    VPM_CLOSE_PLAYER_SUCCESS,
    VPM_PLAYER_EVENT_IGNORE,
}VideoPlayEvent;

typedef enum {
    VPM_RESOLUTION_SUPPORT,                 //可以切换清晰度
    VPM_RESOLUTION_IPCLOWVERTION,           //固件版本低
    VPM_RESOLUTION_FAILURE,                 //切换失败
}VideoResolutionEvent;


typedef enum {
    vrGaoQing = 3,  //高清
    vrLiuChang = 1, //流畅
    vrPicture,      //照片模式
    vrChaoQing = 0, //超清
    vrNone =4
}VedioResolution;


typedef enum {
    VPM_SNAP_NONE,
    VPM_SNAP_NOT_OPEN_PLAYER,
}VideoSnapEvent;


typedef enum {
    VPM_AUDIO_STATE_NONE = 0,
    VPM_AUDIO_STATE_MAX = 10,
}VideoAudioState;

typedef enum {
    VPM_TALK_STATE_OPEN,                    //开启对讲
    VPM_TALK_STATE_CLOSE,
    VPM_TALK_STATE_FAILURE,
}VideoTalkState;


typedef enum {
    VPM_PLAYER_STATE_WAITE_OPENED = 0,
    VPM_PLAYER_STATE_OPENED ,                // player已经打开
    VPM_PLAYER_STATE_BUFFERING,              // player缓冲中
    VPM_PLAYER_STATE_BUFFERING_TIMEOUT,      //缓冲2分钟超时
    VPM_PLAYER_STATE_BUFFERED,               // player缓冲完成
    VPM_PLAYER_ERROR,                        //播放时遇到错误
    VPM_PLAYER_STATE_PLAYEND,
    VPM_PLAYER_STATE_WAITE_CLOSED,           // 等待关闭 -  延迟关闭时使用
    VPM_PLAYER_STATE_CLOSED,                 // player已经关闭
}VideoPlayerState;

typedef enum {
    VPM_RECORD_STATE_NONE=0,
    VPM_RECORD_STATE_WAITE_START,           //注意：此值放第一个，用start和end之间判断是否在录像。
    VPM_RECORD_STATE_START,                 //录像开始 / 中
    VPM_RECORD_STATE_STARTFAILURE,
    VPM_RECORD_STATE_SAVED,                 //录像已保存
    VPM_RECORD_STATE_SAVEFAILURE,           //录像保存失败
    VPM_RECORD_STATE_SAVEFAILURE_TIME,      //录像时间短
    VPM_RECORD_STATE_FAILURE,               //录像过程中失败
    VPM_RECORD_STATE_WAITE_END,             //等待录像结束，防止stop重复调用
    VPM_RECORD_STATE_END,                   //录像结束         注意：此值放在最后一个
}VideoRecordState;




