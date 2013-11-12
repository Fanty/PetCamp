///
/// \file TencentOAuth.h
/// \brief QQ互联开放平台授权登录及相关开放接口实现类
///
/// Created by Tencent on 12-12-21.
/// Copyright (c) 2012年 Tencent. All rights reserved.
///

#import "sdkdef.h"
#import <UIKit/UIKit.h>

@protocol TencentSessionDelegate;
@protocol TencentLoginDelegate;

/**
 * \brief TencentOpenAPI授权登录及相关开放接口调用
 *
 * TencentOAuth实现授权登录逻辑以及相关开放接口的请求调用
 */
@interface TencentOAuth : NSObject
{
    NSMutableDictionary* _apiRequests;
	NSString* _accessToken;
	NSDate* _expirationDate;
	id<TencentSessionDelegate> _sessionDelegate;
	NSString* _localAppId;
	NSString* _openId;
	NSString* _redirectURI;
	NSArray* _permissions;
}

/** Access Token凭证，用于后续访问各开放接口 */
@property(nonatomic, copy) NSString* accessToken;

/** Access Token的失效期 */
@property(nonatomic, copy) NSDate* expirationDate;

/** 已实现的开放接口的回调委托对象 */
@property(nonatomic, assign) id<TencentSessionDelegate> sessionDelegate;

/** 第三方应用在开发过程中设置的URLSchema，用于浏览器登录后后跳到第三方应用 */
@property(nonatomic, copy) NSString* localAppId;

/** 用户授权登录后对该用户的唯一标识 */
@property(nonatomic, copy) NSString* openId;

/** 用户登录成功过后的跳转页面地址 */
@property(nonatomic, copy) NSString* redirectURI;

/** 第三方应用在互联开放平台申请的appID */
@property(nonatomic, retain) NSString* appId;

/**
 * 初始化TencentOAuth对象
 * \param appId 第三方应用在互联开放平台申请的唯一标识
 * \param delegate 第三方应用用于接收请求返回结果的委托对象
 * \return 初始化后的授权登录对象
 */
- (id)initWithAppId:(NSString *)appId
        andDelegate:(id<TencentSessionDelegate>)delegate;

/**
 * 登录授权
 * \param permissions 授权信息列表
 * \param bInSafari 是否使用safari进行登录.<b>IOS SDK 1.3版本开始此参数废除</b>
 */
- (BOOL)authorize:(NSArray *)permissions
		 inSafari:(BOOL)bInSafari;

/**
 * 登录授权
 * \param permissions 授权信息列表
 * \param localAppId 应用APPID
 * \param bInSafari 是否使用safari进行登录.<b>IOS SDK 1.3版本开始此参数废除</b>
 */
- (BOOL)authorize:(NSArray *)permissions
       localAppId:(NSString *)localAppId
		 inSafari:(BOOL)bInSafari;

/**
 * 增量授权，因用户没有授予相应接口调用的权限，需要用户确认是否授权
 * \param permissions 需增量授权的信息列表
 * \return 增量授权调用是否成功
 */
- (BOOL)incrAuthWithPermissions:(NSArray *)permissions;

/**
 * 重新授权，因token废除或失效导致接口调用失败，需用户重新授权
 * \param permissions 授权信息列表，同登录授权
 * \return 授权调用是否成功
 */
- (BOOL)reauthorizeWithPermissions:(NSArray *)permissions;

/**
 * 处理应用拉起协议
 * \param url 处理被其他应用呼起时的逻辑
 * \return 处理结果，YES表示成功，NO表示失败
 */
- (BOOL)handleOpenURL:(NSURL *)url;

/**
 * (静态方法)处理应用拉起协议
 * \param url 处理被其他应用呼起时的逻辑
 * \return 处理结果，YES表示成功，NO表示失败
 */
+ (BOOL)HandleOpenURL:(NSURL *)url;

/**
 * 退出登录
 * \param delegate 第三方应用用于接收请求返回结果的委托对象
 */
- (void)logout:(id<TencentSessionDelegate>)delegate;

/**
 * 判断登录态是否有效
 * \return 处理结果，YES表示有效，NO表示无效，请用户重新登录授权
 */
- (BOOL)isSessionValid;

/**
 * 获取用户个人信息
 * \return 处理结果，YES表示API调用成功，NO表示API调用失败，登录态失败，重新登录
 */
- (BOOL)getUserInfo;

/**
 * 获取用户QZone相册列表
 * \attention 需\ref apply_perm
 * \return 处理结果，YES表示API调用成功，NO表示API调用失败，登录态失败，重新登录
 */
- (BOOL)getListAlbum;

/**
 * 获取用户QZone相片列表
 * \attention 需\ref apply_perm
 * \param params 参数字典,字典的关键字参见TencentOAuthObject.h中的\ref TCListPhotoDic
 * \return 处理结果，YES表示API调用成功，NO表示API调用失败，登录态失败，重新登录
 */
- (BOOL)getListPhotoWithParams:(NSMutableDictionary *)params;


/**
 * 分享到QZone
 * \param params 参数字典,字典的关键字参见TencentOAuthObject.h中的\ref TCAddShareDic 
 * \return 处理结果，YES表示API调用成功，NO表示API调用失败，登录态失败，重新登录
 */
- (BOOL)addShareWithParams:(NSMutableDictionary *)params;


/**
 * 上传照片到QZone指定相册
 * \attention 需\ref apply_perm
 * \param params 参数字典,字典的关键字参见TencentOAuthObject.h中的\ref TCUploadPicDic
 * \return 处理结果，YES表示API调用成功，NO表示API调用失败，登录态失败，重新登录
 */
- (BOOL)uploadPicWithParams:(NSMutableDictionary *)params;

/**
 * 在QZone相册中创建一个新的相册
 * \attention 需\ref apply_perm
 * \param params 参数字典,字典的关键字参见TencentOAuthObject.h中的\ref TCAddAlbumDic
 * \return 处理结果，YES表示API调用成功，NO表示API调用失败，登录态失败，重新登录
 */
- (BOOL)addAlbumWithParams:(NSMutableDictionary *)params;

/**
 * 检查是否是QZone某个用户的粉丝
 * \param params 参数字典,字典的关键字参见TencentOAuthObject.h中的\ref TCCheckPageFansDic
 * \return 处理结果，YES表示API调用成功，NO表示API调用失败，登录态失败，重新登录
 */
- (BOOL)checkPageFansWithParams:(NSMutableDictionary *)params;

/**
 * 在QZone中发表一篇日志
 * \attention 需\ref apply_perm
 * \param params 参数字典,字典的关键字参见TencentOAuthObject.h中的\ref TCAddOneBlogDic
 * \return 处理结果，YES表示API调用成功，NO表示API调用失败，登录态失败，重新登录
 */
- (BOOL)addOneBlogWithParams:(NSMutableDictionary *)params;

/**
 * 在QZone中发表一条说说
 * \attention 需\ref apply_perm
 * \param params 参数字典,字典的关键字参见TencentOAuthObject.h中的\ref TCAddTopicDic
 * \return 处理结果，YES表示API调用成功，NO表示API调用失败，登录态失败，重新登录
 */
- (BOOL)addTopicWithParams:(NSMutableDictionary *)params;

/**
 * 设置QQ头像 使用默认的效果处理设置头像的界面
 * \attention 需\ref apply_perm
 * \param params 参数字典,字典的关键字参见TencentOAuthObject.h中的\ref TCSetUserHeadpic
 * \return 处理结果，YES表示API调用成功，NO表示API调用失败，登录态失败，重新登录
 */
- (BOOL)setUserHeadpic:(NSMutableDictionary *)params;


/**
 * 设置QQ头像 会返回设置头像由第三方自己处理界面的弹出方式
 * \attention 需\ref apply_perm
 * \param params 参数字典,字典的关键字参见TencentOAuthObject.h中的\ref TCSetUserHeadpic
 * \param viewController 设置头像的界面
 * \return 处理结果，YES表示API调用成功，NO表示API调用失败，登录态失败，重新登录
 */
- (BOOL)setUserHeadpic:(NSMutableDictionary *)params andViewController:(UIViewController **)viewController;

/**
 * 获取QQ会员信息(仅包括是否为QQ会员,是否为年费QQ会员)
 * \attention 需\ref apply_perm
 * \return 处理结果，YES表示API调用成功，NO表示API调用失败，登录态失败，重新登录
 */
- (BOOL)getVipInfo;

/**
 * 获取QQ会员详细信息
 * \attention 需\ref apply_perm
 * \return 处理结果，YES表示API调用成功，NO表示API调用失败，登录态失败，重新登录
 */
- (BOOL)getVipRichInfo;

/**
 * 获取微博好友名称输入提示,即通过字符串查找匹配的微博好友
 * \param params 参数字典,字典的关键字参见TencentOAuthObject.h中的\ref TCMatchNickTipsDic
 * \return 处理结果，YES表示API调用成功，NO表示API调用失败，登录态失败，重新登录
 */
- (BOOL)matchNickTips:(NSMutableDictionary *)params;

/**
 * 获取最近的微博好友
 * \param params 参数字典,字典的关键字参见TencentOAuthObject.h中的\ref TCGetIntimateFriendsDic
 * \return 处理结果，YES表示API调用成功，NO表示API调用失败，登录态失败，重新登录
 */
- (BOOL)getIntimateFriends:(NSMutableDictionary *)params;

/**
 * QZone定向分享，可以@到具体好友
 * \param params 参数字典
 * \param fopenIdArray 第三方应用预传人好友列表，好友以openid标识
 * \return 处理结果，YES表示API调用成功，NO表示API调用失败，登录态失败，重新登录
 */
- (BOOL)sendStory:(NSMutableDictionary *)params friendList:(NSArray *)fopenIdArray;

/**
 * 退出指定API调用
 * \param userData 用户调用某条API的时候传入的保留参数
 * \return 处理结果，YES表示成功 NO表示失败
 */
- (BOOL)cancel:(id)userData;
@end

/**
 * \brief TencentLoginDelegate iOS Open SDK 1.3 API回调协议
 *
 * 第三方应用实现登录的回调协议
 */
@protocol TencentLoginDelegate <NSObject>

@required

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin;

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled;

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork;

@optional
/**
 * 登录时权限信息的获得
 */
- (NSArray *)getAuthorizedPermissions:(NSArray *)permissions withExtraParams:(NSDictionary *)extraParams;

@end

/**
 * \brief TencentSessionDelegate iOS Open SDK 1.3 API回调协议
 *
 * 第三方应用需要实现每条需要调用的API的回调协议
 */
@protocol TencentSessionDelegate<NSObject, TencentLoginDelegate>

@optional

/**
 * 退出登录的回调
 */
- (void)tencentDidLogout;

/**
 * 因用户未授予相应权限而需要执行增量授权。在用户调用某个api接口时，如果服务器返回操作未被授权，则触发该回调协议接口，由第三方决定是否跳转到增量授权页面，让用户重新授权。
 * \param tencentOAuth 登录授权对象。
 * \param permissions 需增量授权的权限列表。
 * \return 是否仍然回调返回原始的api请求结果。
 * \note 不实现该协议接口则默认为不开启增量授权流程。若需要增量授权请调用\ref TencentOAuth#incrAuthWithPermissions: \n注意：增量授权时用户可能会修改登录的帐号
 */
- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth withPermissions:(NSArray *)permissions;

/**
 * [该逻辑未实现]因token失效而需要执行重新登录授权。在用户调用某个api接口时，如果服务器返回token失效，则触发该回调协议接口，由第三方决定是否跳转到登录授权页面，让用户重新授权。
 * \param tencentOAuth 登录授权对象。
 * \return 是否仍然回调返回原始的api请求结果。
 * \note 不实现该协议接口则默认为不开启重新登录授权流程。若需要重新登录授权请调用\ref TencentOAuth#reauthorizeWithPermissions: \n注意：重新登录授权时用户可能会修改登录的帐号
 */
- (BOOL)tencentNeedPerformReAuth:(TencentOAuth *)tencentOAuth;

/**
 * 用户通过增量授权流程重新授权登录，token及有效期限等信息已被更新。
 * \param tencentOAuth token及有效期限等信息更新后的授权实例对象
 * \note 第三方应用需更新已保存的token及有效期限等信息。
 */
- (void)tencentDidUpdate:(TencentOAuth *)tencentOAuth;

/**
 * 用户增量授权过程中因取消或网络问题导致授权失败
 * \param reason 授权失败原因，具体失败原因参见sdkdef.h文件中\ref UpdateFailType
 */
- (void)tencentFailedUpdate:(UpdateFailType)reason;

/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(APIResponse*) response;

/**
 * 获取用户QZone相册列表回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getListAlbumResponse.exp success
 *          错误返回示例: \snippet example/getListAlbumResponse.exp fail
 */
- (void)getListAlbumResponse:(APIResponse*) response;

/**
 * 获取用户QZone相片列表
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getListPhotoResponse.exp success
 *          错误返回示例: \snippet example/getListPhotoResponse.exp fail
 */
- (void)getListPhotoResponse:(APIResponse*) response;

/**
 * 检查是否是QZone某个用户的粉丝回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/checkPageFansResponse.exp success
 *          错误返回示例: \snippet example/checkPageFansResponse.exp fail
 */
- (void)checkPageFansResponse:(APIResponse*) response;
 
/**
 * 分享到QZone回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/addShareResponse.exp success
 *          错误返回示例: \snippet example/addShareResponse.exp fail
 */
- (void)addShareResponse:(APIResponse*) response;

/**
 * 在QZone相册中创建一个新的相册回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/addAlbumResponse.exp success
 *          错误返回示例: \snippet example/addAlbumResponse.exp fail
 */
- (void)addAlbumResponse:(APIResponse*) response;

/**
 * 上传照片到QZone指定相册回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/uploadPicResponse.exp success
 *          错误返回示例: \snippet example/uploadPicResponse.exp fail
 */
- (void)uploadPicResponse:(APIResponse*) response;


/**
 * 在QZone中发表一篇日志回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/addOneBlogResponse.exp success
 *          错误返回示例: \snippet example/addOneBlogResponse.exp fail
 */
- (void)addOneBlogResponse:(APIResponse*) response;

/**
 * 在QZone中发表一条说说回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/addTopicResponse.exp success
 *          错误返回示例: \snippet example/addTopicResponse.exp fail
 */
- (void)addTopicResponse:(APIResponse*) response;

/**
 * 设置QQ头像回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/setUserHeadpicResponse.exp success
 *          错误返回示例: \snippet example/setUserHeadpicResponse.exp fail
 */
- (void)setUserHeadpicResponse:(APIResponse*) response;

/**
 * 获取QQ会员信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getVipInfoResponse.exp success
 *          错误返回示例: \snippet example/getVipInfoResponse.exp fail
 */
- (void)getVipInfoResponse:(APIResponse*) response;

/**
 * 获取QQ会员详细信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 */
- (void)getVipRichInfoResponse:(APIResponse*) response;

/**
 * 获取微博好友名称输入提示回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/matchNickTipsResponse.exp success
 *          错误返回示例: \snippet example/matchNickTipsResponse.exp fail
 */
- (void)matchNickTipsResponse:(APIResponse*) response;

/**
 * 获取最近的微博好友回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getIntimateFriendsResponse.exp success
 *          错误返回示例: \snippet example/getIntimateFriendsResponse.exp fail
 */
- (void)getIntimateFriendsResponse:(APIResponse*) response;

/**
 * sendStory分享的回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/sendStoryResponse.exp success
 *          错误返回示例: \snippet example/sendStoryResponse.exp fail
 */
- (void)sendStoryResponse:(APIResponse*) response;

/**
 * post请求的上传进度
 */
- (void)tencentOAuth:(TencentOAuth *)tencentOAuth didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite userData:(id)userData;


/**
 * 通知第三方界面需要被关闭
 */
- (void)tencentOAuth:(TencentOAuth *)tencentOAuth doCloseViewController:(UIViewController *)viewController;

@end
