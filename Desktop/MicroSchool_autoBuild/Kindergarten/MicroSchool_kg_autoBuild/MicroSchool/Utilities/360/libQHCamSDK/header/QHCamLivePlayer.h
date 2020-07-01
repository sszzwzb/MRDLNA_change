//
//  QHCamLivePlayer.h
//  QHCamSDK
//
//  Created by chengbao on 16/3/3.
//  Copyright © 2016年 qihoo. All rights reserved.
//

#import "QHCamPlayer.h"

typedef void(^VideoTalkStatusCallBack) (VideoTalkState talkState);

@interface QHCamLivePlayer : QHCamPlayer

/**
 * 开启对讲模式
 *
 * @param takeType 对讲模式设置，包括对讲模式和通话模式, 具体@see TalkType
 * @param callBack 对讲状态的回调
 */
- (void)pushTalkStartType:(TalkType)talkType callBack:(VideoTalkStatusCallBack)callBack;


/**
 * 停止对讲模式
 *
 * @param callBack 对讲状态的回调
 */
- (void)pushTalkStop:(VideoTalkStatusCallBack)callBack;

@end
