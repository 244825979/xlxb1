//
//  ASBaseTableView.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "ASBaseTableView.h"

@implementation ASBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.emptyDataSetDelegate = self;
        self.emptyDataSetSource = self;
        self.allowsMultipleSelection = YES;
        self.allowsSelectionDuringEditing = YES;
        self.allowsMultipleSelectionDuringEditing = YES;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableFooterView = [[UIView alloc] init];
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        self.showsVerticalScrollIndicator = NO;
        if (@available(iOS 15.0, *)) {
            self.sectionHeaderTopPadding = 0;
        }
        //默认类型，暂无数据样式
        self.emptyType = kTableViewEmptyDefault;
    }
    return self;
}

- (void)setEmptyType:(TableViewEmptyType)emptyType {
    _emptyType = emptyType;
    self.spaceHeight = SCALES(12);
    self.verticalOffset = -SCALES(100);
    self.textFont = TEXT_FONT_14;
    self.textColor = TEXT_SIMPLE_COLOR;
    self.buttonText = @"";
    
    switch (emptyType) {
        case kTableViewEmptyDefault: {
            self.imageURL = @"";
        }
            break;
        case kTableViewEmptyNoData:
        {
            self.imageURL = @"empty_common";
            self.textTitle = @"暂无数据";
        }
            break;
        case kTableViewEmptyLoadFail:
        {
            self.imageURL = @"empty_fial";
            self.textTitle = @"加载失败";
        }
            break;
        case kTableViewEmptySearch:
        {
            self.imageURL = @"empty_shousuo";
            self.textTitle = @"暂无搜索";
        }
            break;
        case kTableViewEmptyDynamic:
        {
            self.imageURL = @"empty_dongtai";
            self.textTitle = @"暂无动态";
        }
            break;
        case kTableViewEmptyDynamicDel:
        {
            self.imageURL = @"empty_dongtai";
            self.textTitle = @"该动态已被删除~";
        }
            break;
        case kTableViewEmptyCallList:
        {
            self.imageURL = @"empty_tonghua";
            self.textTitle = @"暂无通话记录";
        }
            break;
        case kTableViewEmptyFangke:
        {
            self.imageURL = @"empty_fangke";
            self.textTitle = @"暂无访客记录";
        }
            break;
        case kTableViewEmptyFansList:
        {
            self.imageURL = @"empty_fans";
            self.textTitle = @"暂无粉丝";
        }
            break;
        case kTableViewEmptyGuanzhu:
        {
            self.imageURL = @"empty_guanzhu";
            self.textTitle = @"暂无关注";
        }
            break;
        case kTableViewEmptyBlackList:
        {
            self.imageURL = @"empty_heimingdan";
            self.textTitle = @"暂无拉黑名单";
        }
            break;
        case kTableViewEmptyLookMe:
        {
            self.imageURL = @"empty_look";
            self.textTitle = @"暂无看过记录";
        }
            break;
        case kTableViewEmptyBianJieYu:
        {
            self.imageURL = @"empty_kuaijie";
            self.textTitle = @"暂无快捷用语";
        }
            break;
        case kTableViewEmptyVideoShow:
        {
            self.imageURL = @"empty_video";
            self.textTitle = @"暂无视频秀通知~";
        }
            break;
        default:
            break;
    }
}

- (void)setLoading:(BOOL)loading {
    if (self.isLoading == loading) {
        return;
    }
    _loading = loading;
}

#pragma mark - DZNEmptyDataSetSource Methods
// 设置标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.isLoading) {
        return nil;
    } else {
        NSString *text = self.titleText;
        UIFont *font = self.titleFont;
        UIColor *textColor = self.titleColor;
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
        
        if (!text) {
            return nil;
        }
        if (font) [attributes setObject:font forKey:NSFontAttributeName];
        if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
        return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    }
}

//内容
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.isLoading) {
        return nil;
    } else {
        NSString *text = self.textTitle;
        UIFont *font = self.textFont;
        UIColor *textColor = self.textColor;
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
        
        NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        paragraph.alignment = NSTextAlignmentCenter;
        paragraph.lineSpacing = self.lineSpacing;
        if (!text) {
            return nil;
        }
        
        if (font) [attributes setObject:font forKey:NSFontAttributeName];
        if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
        if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];

        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
        return attributedString;
    }
}

//设置占位图
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    UIImage *image = [UIImage imageNamed:self.imageURL];
    return image;
}

// 给图片添加加载动画
- (CAAnimation *) imageAnimationForEmptyDataSet:(UIScrollView *)scrollView{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.fromValue = [NSNumber numberWithFloat: M_PI*2];
    animation.toValue = [NSNumber numberWithFloat:4];
    animation.duration = 0.35;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    return animation;
}

//按钮字体
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (self.isLoading) {
        return nil;
    } else {
        NSString *text = self.buttonText;
        UIFont *font = self.buttonFont;
        UIColor *textColor = self.buttonColor;
        
        if (!text) {
            return nil;
        }
        
        NSMutableDictionary *attributes = [NSMutableDictionary new];
        if (font) [attributes setObject:font forKey:NSFontAttributeName];
        if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
        
        return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    }
}

//按钮背景
- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (self.isLoading) {
        return nil;
    } else {
        UIImage *image = [UIImage imageNamed:@"button_bg"];
        CGSize size = [self.buttonText sizeWithAttributes:@{NSFontAttributeName:TEXT_MEDIUM(14)}];
        CGFloat buttonWidth = (SCREEN_WIDTH - size.width - 100)/2;
        UIEdgeInsets capInsets = UIEdgeInsetsMake(22.0, 22.0, 22.0, 22.0);
        UIEdgeInsets rectInsets = UIEdgeInsetsMake(12.0, -buttonWidth, 12.0, -buttonWidth);
        return [[image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
    }
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return self.bgColor;
}

//垂直偏移
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return self.verticalOffset;
}

//设置字体及图片的间距
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return self.spaceHeight;
}

#pragma mark - DZNEmptyDataSetDelegate Methods
//点击空白处是否触发点击
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}

//是否允许点击响应 默认YES
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

//是否允许滚动 默认NO
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

//是否允许显示动画 默认NO
- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    return self.isLoading;
}

//点击空白处改变显示状态
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    //刷新页面
    if (self.reloadBlock) {
        self.reloadBlock();
    }
}

//点击按钮改变显示状态
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    //刷新页面
    if (self.clickedBlock) {
        self.clickedBlock();
    }
}

@end
