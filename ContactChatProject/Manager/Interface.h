//
//  Interface.h
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#ifndef Interface_h
#define Interface_h

#ifdef DEBUG
#define ServerIP         @"http://www.ichatonea.com"  //测试
//#define ServerIP         @"http://204.48.24.106"  //测试
#else
#define ServerIP         @"http://www.ichatonea.com"  //线上
#endif

#define POST_CONGIG @"/api/v3/config/socialchat_ios" //获取云配config信息
#define GETUserInfo @"/api/v3/socialchat/v20/getuserinfo/socialchat_ios" //获取用户信息
#define SocicalchatFiltrate @"/api/v3/socialchat/v20/filtrate/socialchat_ios" //推荐筛选
#define ActivePeople @"/api/v3/socialchat/v20/active/socialchat_ios" //活跃的人
#define filtratevideo @"/api/v3/socialchat/v20/filtratevideo/socialchat_ios" //视频机器人
#define Sayhi @"/api/v3/socialchat/v20/sayhitobot/socialchat_ios" //say_hi
#define socialchat @"/api/v3/socialchat/v20/talktobot/socialchat_ios" //机器人聊天
#define Shake @"/api/v3/socialchat/v20/friendshake/socialchat_ios" //摇一摇
#define throwbottle @"/api/v3/socialchat/v20/throwbottle/socialchat_ios" //扔漂流瓶
#define findbottle @"/api/v3/socialchat/v20/findbottle/socialchat_ios" //捡漂流瓶
#define getbotinfo  @"/api/v3/socialchat/v20/getbotinfo/socialchat_ios" //获取机器人基本信息
#define pushlikeme @"/api/v3/socialchat/v20/pushlikeme/socialchat_ios" //喜欢推送拉取
#define pushnewmsg @"/api/v3/socialchat/v20/pushnewmsg/socialchat_ios" //机器人发消息拉取

#define pushnewonemsg @"/api/v3/socialchat/v20/pushnewonemsg/socialchat_ios"

#define RefreshToken @"/api/v3/socialchat/v20/refreshtoken/socialchat_ios"//刷新token
#define LOGIN @"/api/v3/socialchat/v20/login/socialchat_ios" //登录
#define LOGUP @"/api/v3/socialchat/v20/register/socialchat_ios" //注册
#define ThirdLogin @"/api/v3/socialchat/v20/thirdpartylogin/socialchat_ios" //第三方登录
#define UPloadsex @"/api/v3/socialchat/v20/uploadsex/socialchat_ios" //选择性别
#define INPutedituserinfo @"/api/v3/socialchat/v20/edituserinfo/socialchat_ios" //
#define UPLoadphoto @"/api/v3/socialchat/v20/uploadphoto/socialchat_ios" //上传照片
#define Deletephoto @"/api/v3/socialchat/v20/deletephoto/socialchat_ios" //删除照片
#define likeme @"/api/v3/socialchat/v20/likeme/socialchat_ios" //喜欢我的人
#define uploadDeviceToken @"/api/v3/device_token/socialchat_ios"

//打点
#define statistics_log_url    @"/api/v3/statistics_log/socialchat_ios"
#define crash_log_url         @"/api/v3/crash_log/socialchat_ios"

//APPSTOREid
//1444383242
#define kAppStoreID @"1440701057"

#define kAppStoreRateUrl        [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review", kAppStoreID]
#define kAppStoreUrl            [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", kAppStoreID]

// 订阅秘钥
//#define kIAP_SECRECT @"b54270fa26e447f4993b2f5fd9e1c53f"


#define BuglyAppID @"9e501663f3"
#define BuglyAppKey @"8edce314-306a-4eb6-b4b4-9e83cd435b0f"


// 配置偏好设置存储Key
#define kConfigInfoName  @"kConfigInfoName"

#endif /* Interface_h */
