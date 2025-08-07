//
//  ASDefineRequest.h
//  AS
//
//  Created by SA on 2025/4/9.
//

#ifndef ASDefineRequest_h
#define ASDefineRequest_h

#pragma mark - 服务器地址
#define SERVER_URL              [ASConfigConst shared].server_url
#define SERVER_IMAGE_URL        [ASConfigConst shared].server_image_url
#define SERVER_AGREEMENT_URL    [ASConfigConst shared].server_h5_url
#define SERVER_IM_ENV           [ASConfigConst shared].server_im_env
#define NEIM_APNS               [ASConfigConst shared].NEIM_apns
#define kAppBundleID            [ASConfigConst shared].bundleID

#pragma mark - 请求配置常量
#define REQUEST_PAGE_NUMBER 16                                            //数据列表一页请求数量
#define REQUEST_TIME_OUT 30.f                                             //连接超时时间
#define NO_NETWORK @"暂无网络，请重试！"                                     //无网络
#define NET_ERROR @"网络异常，请重试！"                                      //请求失败

#pragma mark - 苹果支付场景
#define Pay_Scene_SayHello              @"1" //打招呼
#define Pay_Scene_Chat                  @"2" //普通聊天
#define Pay_Scene_ChatGift              @"3" //聊天送礼
#define Pay_Scene_VideoCalling          @"4" //视频通话
#define Pay_Scene_VoiceCalling          @"5" //语音通话
#define Pay_Scene_VideoGift             @"6" //视频通话送礼物
#define Pay_Scene_VoiceGift             @"7" //视频通话送礼物
#define Pay_Scene_Vip                   @"8" //开通vip
#define Pay_Scene_PayCenter             @"11" //充值中心
#define Pay_Scene_FirstPay              @"12" //首充弹窗
#define Pay_Scene_DaySayHello           @"13" //今日缘分
#define Pay_Scene_CallList              @"14" //消息-通话列表
#define Pay_Scene_ServerPush            @"15" //后台下发推送充值场景
#define Pay_Scene_VideoShowAward        @"16" //视频秀打赏

#pragma mark - 拨打视频场景
#define Call_Scene_Recommend            @"recommend"        //首页推荐
#define Call_Scene_VideoShow            @"video_show"       //视频秀
#define Call_Scene_VideoMatch           @"video_match"      //视频速配
#define Call_Scene_PersonInfo           @"person_info"      //个人主页
#define Call_Scene_QuickCall            @"quickCall"        //首页视频速聊列表
#define Call_Scene_Online               @"online"           //首页在线列表（新人）
#define Call_Scene_Guide                @"guide"            //视频引导弹窗
#define Call_Scene_CallList             @"callList"         //通话列表
#define Call_Scene_CallRecommend        @"callRecommend"    //通话列表-推荐
#define Call_Scene_Chat                 @"chat"             //普通聊天

#pragma mark - 点击统计事件模块
#define Behavior_home_like_dashan       1001 //猜你喜欢模块 搭讪按钮
#define Behavior_home_like_sixin        1002 //猜你喜欢模块 私信按钮
#define Behavior_home_like_head         1003 //猜你喜欢模块 头像点击
#define Behavior_home_like_change       1004 //猜你喜欢模块 换一批按钮
#define Behavior_home_first_pay         2001 //首页模块 首充特惠按钮
#define Behavior_dynamic_like_head      3001 //动态 用户点击

#pragma mark - H5URL
#define Web_URL_UserProtocol  @"app/protocol/user"                          //用户协议
#define Web_URL_Privacy @"app/protocol/privacy"                             //隐私协议
#define Web_URL_Customer @"app/customer"                                    //客服
#define Web_URL_AuthRule @"app/protocol/auth-rule"                          //权限说明
#define Web_URL_ChatConvention @"app/banner/chat-rule"                      //权限说明
#define Web_URL_Partnership @"app/protocol/partnership"                     //合作服务协议
#define Web_URL_Fraud @"app/banner/fraud"                                   //防诈骗提醒
#define Web_URL_Invite @"app/ios/invite"                                    //邀请好友

#pragma mark - 接口api
/* ----------通用----------- */
#define API_AppStatus @"api/app/appStatus"                                  //前后台上报
#define API_AliOSSData @"api/sts/index"                                     //阿里云OSS查询
#define API_AppConfig @"api/app/config"                                     //查询配置信息，如：版本，weburl
#define API_AppSystemIndex @"api/system/index"                              //查询配置信息，如：清除无效消息时间
#define API_ActivateIndex @"api/activate/index"                             //参数上报
#define API_CallRiskLabel @"api/chat/riskLabel"                             //视频接通获取提醒数据
#define API_UserIsAuth @"api/user/isAuth"                                   //认证状态
#define API_AppIndexConfig @"api/index/config"                              //启动请求
#define API_ProvinceCitys @"api/app/provinceCitys"                          //获取所在地数据
#define API_CityOptions @"api/app/cityOptions"                              //获取家乡数据
#define API_SelectData @"api/user/getSelectData"                            //获取选择器数据
#define API_BeckonSend @"api/beckon/send"                                   //打招呼
#define API_Follow @"api/user/follow"                                       //关注or取消关注
#define API_GiftTitle @"api/gift/getGiftCate"                               //获取礼物title
#define API_GiftList @"api/gift/getGift"                                    //获取礼物列表
#define API_SendGift @"api/chat/send_gift_new"                              //赠送礼物
#define API_PayGoodsList @"api/wallet/goods_list"                           //苹果支付商品列表
#define API_AppleRecharge @"api/wallet/apple_recharge"                      //拉起支付请求接口
#define API_SendVipGoods @"api/vip/vipGoods"                                //赠送vip数据获取
#define API_MyConsumeInfo @"api/wallet/my_consume_info"                     //理性消费页面
#define API_SetConsume @"api/wallet/consume_set"                            //消费设置
#define API_VerifyApplePay @"api/callback/apple_pay"                        //苹果支付校验
#define API_AppSystem @"api/app/system"                                     //获取当前版本升级
#define API_GoodAnchorIndex @"api/goodAnchor/index"                         //优质女用户弹框
#define API_GoodAnchorClick @"api/goodAnchor/click"                         //优质女用户弹框点击聊天按钮
#define API_UserVideoPopPush @"api/user/getUserVideo"                       //视频提醒
#define API_BehaviorStats @"api/recommend/behaviorStats"                    //点击统计事件
#define API_ReportAppOpen @"api/activity.popup/reportAppOpen"               //启动次数上报
#define API_PopupTracking @"api/activity.popup/tracking"                    //活动弹窗行为上报
#define API_ActivityPopup @"api/activity.popup/getActivityPopup"            //活动弹窗

/* ----------登录----------- */
#define API_SendCode @"api/passport/send_code"                              //发生验证码
#define API_CodeLogin @"api/passport/codeLogin"                             //验证码注册登录
#define API_TXLogin @"api/passport/oneKeyLogin"                             //腾讯一键登录
#define API_ManNameList @"api/user/nickname"                                //注册男用户默认昵称列表
#define API_ProfileRegNew @"api/user/profile_reg_new"                       //资料补充
#define API_LoginOut @"api/user/loginOut"                                   //退出登录
#define API_CloseAccount @"api/passport/close_account"                      //注销
#define API_NewUserGiftBag @"api/activity.giftBag/index"                    //新人礼包
#define API_WXLogin @"api/passport/third"                                   //微信登录
#define API_OneKeyBindMobile @"api/user/oneKeyBindMobile"                   //一键登录方式绑定手机号
#define API_PhoneBindMobile @"api/user/bind_mobile"                         //手机号绑定手机号

/* ----------首页----------- */
#define API_HomeUserList @"api/v2/index/index/recommend"                    //首页推荐列表
#define API_HomeNewUserList @"api/v2/index/index/online"                    //首页在线列表
#define API_HomeNewerList @"api/v2/index/newer"                             //首页新人列表
#define API_HomeFirstData @"api/wallet/goods_list_first"                    //首充数据获取
#define API_HomeIndexInfo @"api/index/info"                                 //首页配置字段数据
#define API_HomeGrabChatList @"api/grabChat/list"                           //首页视频列表
#define API_HomeSearch @"api/index/getUserInfoByUserCode"                   //搜索用户
#define API_RecommendUserPop @"api/recommend/index"                         //今日缘分弹窗
#define API_RecommendReckon @"api/recommend/beckon"                         //今日缘分点击打招呼
#define API_RecommendRandCommonWord @"api/recommend/randCommonWord"         //首页今日缘分招呼语
#define API_RecommendStatus @"api/recommend/status"                         //是否缘分弹窗
#define API_RecommendLike @"api/recommend/youLike"                          //猜你喜欢

/* ----------动态----------- */
#define API_DynamicList @"api/dynamic/lists"                                //动态列表
#define API_DynamicDisLike @"api/dynamic/disLike"                           //减少该动态推荐
#define API_DynamicLike @"api/dynamic/like"                                 //动态点赞
#define API_DynamicDetail @"api/dynamic/detail"                             //动态详情
#define API_DynamicComment @"api/dynamicComment/comment"                    //动态评论
#define API_DynamicCommentList @"api/dynamicComment/lists"                  //动态评论列表
#define API_DeleteDynamic @"api/dynamic/delete"                             //删除动态
#define API_PublishDynamic @"api/dynamic/publish"                           //发布动态内容
#define API_PublishImage @"api/dynamic/publish_image"                       //发布动态图片绑定
#define API_DynamicNotify @"api/dynamic/record"                             //我的动态消息通知列表
#define API_UserDynamicList @"api/user/dynamic_list"                        //个人动态列表
#define API_DynamicNotifyCount @"api/dynamic/user_like_count"               //我的动态通知未读数量

/* ----------消息----------- */
#define API_IntimateList @"api/chat_intimate/getIntimateList"               //获取亲密度数据
#define API_UsersHiddenMe @"api/vip/user_hidden_me"                         //获取所有隐身数据
#define API_ChatCardData @"api/user/getChatData"                            //私聊页卡片信息
#define API_OpenHidingState @"api/vip/is_hidden"                            //获取对ta开启隐身状态
#define API_SetHidingState @"api/vip/hidden_set"                            //设置对ta开启隐身
#define API_IMHomeVideoShow @"api/videoShow/get_cover"                      //查看IM主页视频秀
#define API_CommonWordList @"api/user/getCommonWord"                        //常用语列表
#define API_AddCommonWord @"api/user/addCommonWord"                         //添加常用语
#define API_DelCommonWord @"api/user/delCommonWord"                         //删除常用语
#define API_UserIntimate @"api/chat_intimate/getIntimateV2"                 //获取亲密度详细数据
#define API_VerifySendIM @"api/v2/chat/index/sendIm"                        //校验发送IM消息
#define API_ChatSetting @"api/chat/chat_setting"                            //用户数据
#define API_SetHideVisit @"api/vip/setHideVisit"                            //设置隐身访问
#define API_CallList @"api/user/call_list"                                  //通话列表
#define API_CallRecommend @"api/recommend/callRecommend"                    //通话列表的视频推荐
#define API_MatchHelperState @"api/matchHelper/index"                       //小助手状态
#define API_MatchHelperList @"api/fate/helperList"                          //小助手列表数据
#define API_SendImBatch @"api/v2/chat/index/sendImBatch"                    //一键回复
#define API_GreetTplList @"api/matchHelper/greetTplList"                    //判断是否有快捷用语
#define API_ActiveConfig @"api/system/activeConfig"                         //私聊的活动悬浮窗
#define API_ChatMsgPrice @"api/anchor/getMsgConfig"                         //聊天私信价格

/* ----------我的----------- */
#define API_TodaySign @"api/talk.Activity/todayActivityIndex"               //获取签到数据
#define API_MinUserHome @"api/user/home"                                    //个人中心页
#define API_WalletIndex @"api/wallet/index"                                 //获取账户金额数据
#define API_TodayActivity @"api/talk.Activity/todayActivity"                //进行签到
#define API_IndexBanner @"api/index/banner"                                 //获取bannaer
#define API_UpdateAvatar @"api/user/compareFacesAvatar"                     //头像更新
#define API_SaveImporveData @"api/user/improve_data"                        //保存用户资料
#define API_EditUserInfo @"api/user/getUserInfo"                            //获取我的编辑数据
#define API_SetVoiceList @"api/voice/list"                                  //设置语音签名
#define API_UserTags @"api/user/getUserTag"                                 //标签列表
#define API_FollowList @"api/user/follow_list"                              //关注列表
#define API_FansList @"api/user/fans_list"                                  //粉丝列表
#define API_ViewerList @"api/user/viewer_list"                              //看过列表
#define API_VisitorList @"api/user/visitor_list"                            //我的访客列表
#define API_GreetListsNew @"api/greet/lists_new"                            //快捷用语列表
#define API_GreetAdd @"api/greet/add"                                       //添加快捷用语
#define API_GreetSetName @"api/greet/set_name"                              //快捷用语昵称修改
#define API_GreetDel @"api/greet/delete_new"                                //删除快捷用语
#define API_GreetSetDefault @"api/greet/set_default"                        //设置默认快捷用语
#define API_SecurityCenter @"api/user/noticeCenter"                         //安全中心
#define API_NoticeAgree @"api/user/noticeAgree"                             //用户通知弹窗-同意接口
#define API_IsPopCenterNotice @"api/user/notice"                            //是否弹出须知通知
#define API_IsPopBindAlert @"api/user/systemSetPopWindow"                   //是否弹出绑定弹窗


/* ----------视频----------- */
#define API_VideoShowCall @"api/videoShow/addCallNumber"                    //视频秀拨打
#define API_VideoShowLike @"api/videoShow/like"                             //视频秀点赞
#define API_VideoShowDashan @"api/videoShow/sendAccost"                     //视频秀搭讪
#define API_VideoShowHome @"api/videoShow/home"                             //首页请求获取通知信息
#define API_VideoShowList @"api/videoShow/publish_play"                     //视频秀列表
#define API_VideoShowIndex @"api/videoShow/index"                           //视频秀列表tabbar
#define API_AddPlayNum @"api/videoShow/addPlayNum"                          //视屏秀增加播放量
#define API_VideoShowCheck @"api/videoShow/checkDayNumber"                  //检查每日上传视频秀限制
#define API_VideoShowSetStatus @"api/videoShow/setStatus"                   //视频秀是否开启关闭私密
#define API_VideoShowSetCover @"api/videoShow/setCover"                     //视频秀设置封面
#define API_VideoShowDel @"api/videoShow/delete"                            //视频秀删除
#define API_VideoShowSign @"api/videoShow/signature"                        //视频秀上传签名
#define API_VideoShowPublish @"api/videoShow/publish"                       //上传发布视频秀
#define API_MyVideoShowList @"api/videoShow/list"                           //我的视频秀列表
#define API_VideoShowGiftList @"api/gift/videoShowList"                     //视频秀礼物列表
#define API_VideoShowRecord @"api/videoShow/record"                         //视频秀通知列表
#define API_VideoShowRemind @"api/videoShow/remind"                         //视频秀提醒

/* ----------设置----------- */
#define API_UserBlackList @"api/user/black_list"                            //黑名单列表
#define API_SetUserBlack @"api/user/black"                                  //设置黑名单
#define API_ReportList @"api/vgo/report/list"                               //举报列表
#define API_ReportWithdraw @"api/vgo/report/reportWithdraw"                 //举报撤销
#define API_ReportDetail @"api/vgo/report/detail"                           //举报详情
#define API_FateMatch @"api/user/getFateMatch"                              //获取牵线状态
#define API_SetFateMatch @"api/user/setFateMatch"                           //设置牵线开关
#define API_LikeNotiStatus @"api/user/getUserLikeStatus"                    //获取点赞通知状态
#define API_SetLikeNotiStatus @"api/user/setUserLikeStatus"                 //设置点赞通知状态
#define API_GiftWindowsSetting @"api/userV2/giftWindowsSetting"             //获取送礼飘屏匿名状态
#define API_UserSetting @"api/userV2/userSetting"                           //设置送礼飘屏匿名状态
#define API_AnchorSetting @"api/anchor/get_anchor_setting"                  //获取价格选择数据
#define API_SetPrice @"api/anchor/set_price"                                //设置价格
#define API_GetMyPrice @"api/anchor/getPrice"                               //获取我的价格
#define API_OpenTeenager @"api/user/set_adolescent"                         //设置未成年模式
#define API_CloseTeenager @"api/user/switch_adolescent"                     //关闭未成年模式
#define API_TeenagerStatus @"api/user/get_adolescent_status"                //获取未成年模式
#define API_VerifyMobileCode @"api/user/verify_mobile_code"                 //忘记密码关闭未成年模式
#define API_ReportCate @"api/user/report_cate"                              //举报选项
#define API_UserReport @"api/user/report"                                   //进行举报
#define API_UserRemark @"api/user/user_remark"                              //修改备注名
#define API_ReportMore @"api/vgo/report/more"                               //举报补充
#define API_BindState @"api/user/account_binds"                             //绑定状态获取
#define API_SetRedState @"api/user/showRedStatus"                           //绑定状态获取
#define API_BindWX @"api/user/bind_platform"                                //绑定微信

/* ----------用户主页----------- */
#define API_UserIndex @"api/user/getUserIndex"                              //获取用户主页数据

/* ----------支付----------- */
#define API_WalletIsAgree @"api/wallet/isAgree"                             //修改备注名
#define API_WalletAgreeUnderage @"api/wallet/agreeUnderage"                 //同意未成年弹窗
#define API_WalletRechargeBefore @"api/wallet/rechargeBefore"               //充值5次成功提示
#define API_WalletRecord @"api/wallet/record"                               //收支记录
#define API_GiftRefundDetail @"api/wallet/giftRefundDetail"                 //退还退回详情
#define API_WalletRecordDel @"api/wallet/record_del"                        //删除收支记录
#define API_ChangeCoin @"api/wallet/changeCoin"                             //兑换金币
#define API_WalletWithdraw @"api/wallet/withdraw"                           //提现数据
#define API_WalletIsNotice @"api/wallet/isNotice"                           //提现是否弹窗
#define API_WithdrawPriceData @"api/wallet/get_withdraw_price"              //提现数据
#define API_WithdrawNew @"api/wallet/user_withdraw_new"                     //提现
#define API_AccountSave @"api/wallet/account_save"                          //绑定获取信息保存
#define API_AccountInfo @"api/wallet/account_info"                          //绑定获取信息
#define API_AccountBindList @"api/wallet/account_list"                      //绑定账户列表
#define API_WalletCashoutRecord @"api/wallet/cashout_record"                //提现记录
#define API_VipNobleRecharge @"api/vip/nobleRecharge"                       //vip详情
#define API_VipAward @"api/vip/award"                                       //领取礼物

/* ----------用户主页----------- */
#define API_RTCAnchorPrice @"api/anchor/getPrice"                           //获取语音视频通话折扣
#define API_CallNew @"api/chat/call_new"                                    //获取拨打信息
#define API_RoomCall @"api/chat/get_room"                                   //接听
#define API_CheckCallMoney @"api/chat/checkCallMoney"                       //接听校验余额

#endif /* ASDefineRequest_h */
