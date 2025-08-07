//
//  ASBaseTableView.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <UIKit/UIKit.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  通用无数据显示类型
 */
typedef NS_ENUM(NSInteger, TableViewEmptyType) {
    kTableViewEmptyDefault = 0,                                                  //默认不显示
    kTableViewEmptyNoData = 1,                                                   //默认无数据样式
    kTableViewEmptyLoadFail = 2,                                                 //加载失败
    kTableViewEmptySearch = 3,                                                   //搜索
    kTableViewEmptyDynamic = 4,                                                  //暂无动态
    kTableViewEmptyDynamicDel = 13,                                              //动态删除提示
    kTableViewEmptyCallList = 5,                                                 //通话列表
    kTableViewEmptyFangke = 6,                                                   //访客列表
    kTableViewEmptyFansList = 7,                                                 //粉丝列表
    kTableViewEmptyGuanzhu = 8,                                                  //关注列表
    kTableViewEmptyBlackList = 9,                                                //黑名单
    kTableViewEmptyLookMe = 10,                                                  //看过我
    kTableViewEmptyBianJieYu = 11,                                               //便捷用语
    kTableViewEmptyVideoShow = 12,                                               //视频秀
};

@interface ASBaseTableView : UITableView<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
//是否显示加载中
@property (nonatomic, getter=isLoading) BOOL loading;
//显示样式类型
@property (nonatomic, assign) TableViewEmptyType emptyType;
//没有更多数据时，底部文字描述
@property (nonatomic, copy) NSString *noDataDescribe;
//是否隐藏顶部刷新控件
@property (nonatomic, assign) BOOL isHiddenRefreshHeader;
//是否隐藏底部刷新控件
@property (nonatomic, assign) BOOL isHiddenRefreshFooter;
//背景颜色
@property (nonatomic, strong) UIColor *bgColor;
//提示标题内容
@property (nonatomic, copy) NSString *titleText;
//提示标题字体
@property (nonatomic, strong) UIFont *titleFont;
//提示标题字体颜色
@property (nonatomic, strong) UIColor *titleColor;
//提示内容
@property (nonatomic, copy) NSString *textTitle;
//提示字体
@property (nonatomic, strong) UIFont *textFont;
//提示字体颜色
@property (nonatomic, strong) UIColor *textColor;
//与title间距
@property (nonatomic, assign) CGFloat lineSpacing;
//占位图
@property (nonatomic, copy) NSString *imageURL;
//按钮内容
@property (nonatomic, copy) NSString *buttonText;
//按钮字体
@property (nonatomic, strong) UIFont *buttonFont;
//按钮字体颜色
@property (nonatomic, strong) UIColor *buttonColor;
//按钮背景
@property (nonatomic, copy) UIColor *buttonBgColor;
//垂直偏移量
@property (nonatomic, assign) CGFloat verticalOffset;
//图片 文字间距
@property (nonatomic, assign) CGFloat spaceHeight;
//点击按钮block事件
@property (nonatomic, copy) void (^clickedBlock)(void);
//点击空白block事件
@property (nonatomic, copy) void (^reloadBlock)(void);
@end

NS_ASSUME_NONNULL_END
