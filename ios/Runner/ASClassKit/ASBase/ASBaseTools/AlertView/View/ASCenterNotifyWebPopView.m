//
//  ASCenterNotifyWebPopView.m
//  AS
//
//  Created by SA on 2025/6/19.
//

#import "ASCenterNotifyWebPopView.h"
#import <WebKit/WebKit.h>
#import "ASMineRequest.h"

@interface ASCenterNotifyWebPopView ()
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UILabel *title;
@end

@implementation ASCenterNotifyWebPopView

//构造方法
- (instancetype)initCenterNotifyWebWithModel:(ASCenterNotifyModel *)model {
    if (self = [super init]) {
        kWeakSelf(self);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = SCALES(12);
        self.clipsToBounds = YES;
        self.title = ({
            UILabel *title = [[UILabel alloc] init];
            title.font = TEXT_MEDIUM(18);
            title.textAlignment = NSTextAlignmentCenter;
            title.frame = CGRectMake(0, 0, SCALES(310), SCALES(60));
            [self addSubview:title];
            title;
        });
        UIButton *close = [[UIButton alloc]initWithFrame:CGRectMake(SCALES(260), SCALES(15), SCALES(30), SCALES(30))];
        [close setImage:[UIImage imageNamed:@"close1"] forState:UIControlStateNormal];
        [[close rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.closeBlock) {
                wself.closeBlock();
                [wself removeView];
            }
        }];
        [self addSubview:close];
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.allowsInlineMediaPlayback = YES;
        configuration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeAll;
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        //cookies参数
        NSMutableDictionary* dicts = [NSMutableDictionary dictionary];
        [dicts setValue:STRING(USER_INFO.token) forKey:@"accessToken"];
        [dicts setValue:STRING(kAppVersion) forKey:@"appVersion"];
        [dicts setValue:kAppBundleID forKey:@"packageName"];
        [dicts setValue:@(kAppType) forKey:@"mtype"];//环境
        
        NSMutableString *cookie = [NSMutableString stringWithFormat:@""];
        for (NSString * key in dicts) {
            [cookie appendFormat:@"document.cookie = '%@=%@';\n",key, dicts[key]];
        }
        WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookie injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [userContentController addUserScript:cookieScript];
        configuration.userContentController = userContentController;
        
        self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        [self addSubview:self.webView];
        self.webView.frame = CGRectMake(0, SCALES(40), SCALES(310), SCALES(315));
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.url]]];
        [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        
        UIButton *affirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:affirmBtn];
        affirmBtn.titleLabel.font = TEXT_MEDIUM(18);
        [affirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        affirmBtn.adjustsImageWhenHighlighted = NO;
        [affirmBtn setBackgroundImage:[UIImage imageNamed:@"button_bg1"] forState:UIControlStateNormal];
        [affirmBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateSelected];
        [affirmBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        [affirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        affirmBtn.layer.masksToBounds = YES;
        affirmBtn.selected = NO;
        affirmBtn.layer.cornerRadius = SCALES(24.5);
        
        UIButton *agreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [agreementButton setImage:[UIImage imageNamed:@"potocol1"] forState:UIControlStateNormal];
        [agreementButton setImage:[UIImage imageNamed:@"potocol"] forState:UIControlStateSelected];
        agreementButton.adjustsImageWhenHighlighted = NO;
        agreementButton.selected = NO;
        [[agreementButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            agreementButton.selected = !agreementButton.selected;
            affirmBtn.selected = !affirmBtn.selected;
        }];
        [self addSubview:agreementButton];
        
        UILabel *agreementView = [[UILabel alloc] init];
        agreementView.text = @"已阅读并同意以上内容";
        agreementView.numberOfLines = 0;
        agreementView.font = TEXT_FONT_13;
        agreementView.textColor = TEXT_SIMPLE_COLOR;
        [self addSubview:agreementView];
        [agreementView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(SCALES(-14));
            make.centerX.equalTo(self).offset(SCALES(10));
        }];
        [agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(agreementView.mas_left).offset(SCALES(2));
            make.size.mas_equalTo(CGSizeMake(SCALES(36), SCALES(36)));
            make.centerY.equalTo(agreementView);
        }];
        
        [[affirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (!agreementButton.isSelected) {
                kShowToast(@"请勾选协议");
                return;
            }
            if (wself.closeBlock) {
                [ASMineRequest requestNoticeAgreeWithID:model.noticeLogId success:^(id  _Nonnull response) {
                    [wself removeView];
                    wself.closeBlock();
                } errorBack:^(NSInteger code, NSString * _Nonnull message) {
                    
                }];
            }
        }];
        [affirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(agreementView.mas_top).offset(SCALES(-14));
            make.size.mas_equalTo(CGSizeMake(SCALES(235), SCALES(45)));
        }];
        self.size = CGSizeMake(SCALES(310), SCALES(474));
    }
    return self;
}

#pragma mark - event response
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"title"]) {//部分页面进行自定义title处理
        self.title.text = STRING(self.webView.title);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)removeView {
    [self removeFromSuperview];
}

@end
