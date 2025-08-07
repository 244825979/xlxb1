//
//  ASVideoShowPublishController.m
//  AS
//
//  Created by SA on 2025/5/12.
//

#import "ASVideoShowPublishController.h"
#import "TXUGCPublish.h"
#import "ASVideoShowPublishSetCoverView.h"
#import "ASVideoShowPublishBottomView.h"
#import "ASVideoShowMyListContrller.h"
#import "ASVideoShowRequest.h"

@interface ASVideoShowPublishController ()<UITextViewDelegate, TXVideoPublishListener>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *selectImage;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) ASVideoShowPublishSetCoverView *setCoverView;
@property (nonatomic, strong) ASVideoShowPublishBottomView *bottomView;
/**数据**/
@property (nonatomic, strong) TXPublishParam *txPublishParams;
@property (nonatomic, strong) TXUGCPublish *txPublish;
@property (nonatomic, strong) UIImage *coverImage;
@property (nonatomic, copy) NSString *videoURL;
@property (nonatomic, copy) NSString *coverURL;
@property (nonatomic, assign) BOOL isDefeated;
@property (nonatomic, assign) BOOL isOpen;
@end

@implementation ASVideoShowPublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"我的视频秀";
    self.isDefeated = NO;
    self.isOpen = YES;
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
}

- (void)popVC {
    [self.view endEditing:YES];
    BOOL isInclude = NO;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ASVideoShowMyListContrller class]]) {
            isInclude = YES;
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
    if (isInclude == NO) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)createUI {
    kWeakSelf(self);
    [self.view addSubview:self.bottomView];
    self.bottomView.indexBlock = ^(NSString *indexName) {
        if ([indexName isEqualToString:@"公开"]) {
            wself.isOpen = YES;
            return;
        }
        if ([indexName isEqualToString:@"私密"]) {
            wself.isOpen = NO;
            return;
        }
        if ([indexName isEqualToString:@"发布"]) {
            [wself.scrollView endEditing:YES];
            if (wself.isDefeated) {
                [wself publishVideo];
            } else {
                [wself updateVideo];
            }
            return;
        }
    };
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(SCALES(120) + TAB_BAR_MAGIN);
    }];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.scrollView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(SCALES(16));
        make.left.equalTo(self.scrollView).offset(SCALES(16));
        make.width.mas_equalTo(SCREEN_WIDTH - SCALES(32) - SCALES(132));
        make.height.mas_equalTo(SCALES(150));
    }];
    [self.scrollView addSubview:self.selectImage];
    if (self.images.count > 0) {
        self.selectImage.image = self.images[0];
        self.coverImage = self.images[0];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [self.selectImage addGestureRecognizer:tap];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [wself.scrollView endEditing:YES];
        [[ASAuthStateVerifyManager shared] isCertificationState:kRpAuthPopVideoShow succeed:^{
            [[ASUploadImageManager shared] selectVideoShowPickerWithViewController:wself didFinish:^(UIImage * _Nonnull coverImage, PHAsset * _Nonnull asset) {
                [ASVideoShowManager popPublishVideoShowWithAssets:asset];
            }];
        }];
    }];
    [self.selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(SCALES(16));
        make.left.equalTo(self.textView.mas_right).offset(SCALES(20));
        make.size.mas_equalTo(CGSizeMake(SCALES(112), SCALES(150)));
    }];
    UILabel *updateText = [[UILabel alloc] init];
    updateText.text = @"重新上传";
    updateText.textColor = UIColor.whiteColor;
    updateText.backgroundColor = UIColorRGBA(0x000000, 0.4);
    updateText.font = TEXT_FONT_12;
    updateText.textAlignment = NSTextAlignmentCenter;
    [self.selectImage addSubview:updateText];
    [updateText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(SCALES(26));
        make.left.right.bottom.equalTo(self.selectImage);
    }];
    
    [self.scrollView addSubview:self.setCoverView];
    self.setCoverView.images = self.images;
    self.setCoverView.backBlock = ^(UIImage * _Nonnull selectImage) {
        wself.coverImage = selectImage;
    };
    [self.setCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectImage.mas_bottom).offset(SCALES(16));
        make.left.equalTo(self.scrollView);
        make.height.mas_equalTo(SCALES(392));
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
}

#pragma mark - TXVideoPublishListener
- (void)onPublishProgress:(NSInteger)uploadBytes totalBytes: (NSInteger)totalBytes {
    long progress = (long)(8 * uploadBytes / totalBytes);
    ASLog(@"---------progress = %ld", progress);
}

- (void)onPublishComplete:(TXPublishResult*)result {
    [ASMsgTool hideMsg];
    if (!result.retCode) {
        self.videoURL = result.videoURL;
        self.coverURL = result.coverURL;
        [self publishVideo];
    } else {
        kShowToast(@"发布失败，请重试!");
    }
}

- (void)publishVideo {
    kWeakSelf(self);
    [ASMsgTool showLoading: @"发布中..."];
    [ASVideoShowRequest requestPublishVideoShowWithImageUrl:self.coverURL
                                                 showStatus:self.isOpen
                                                      title:self.textView.text
                                                   videoUrl:self.videoURL
                                                    success:^(id  _Nullable data) {
        [ASMsgTool hideMsg];
        kShowToast(@"发布成功!");
        wself.isDefeated = NO;
        BOOL isInclude = NO;
        for (UIViewController *vc in wself.navigationController.viewControllers) {
            if ([vc isKindOfClass:[ASVideoShowMyListContrller class]]) {
                isInclude = YES;
                [wself.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
        if (isInclude == NO) {
            [wself.navigationController popToRootViewControllerAnimated:YES];
            ASVideoShowMyListContrller *vc = [[ASVideoShowMyListContrller alloc] init];
            [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
        }
    } errorBack:^(NSInteger code, NSString *msg) {
        [ASMsgTool hideMsg];
        kShowToast(@"发布失败!");
        wself.isDefeated = YES;
    }];
}

- (void)updateVideo {
    kWeakSelf(self);
    [ASMsgTool showLoading: @"上传中..."];
    [ASVideoShowRequest requestVideoShowSignSuccess:^(id _Nullable data) {
        wself.txPublishParams.signature = data;
        wself.txPublishParams.coverPath = [wself getCoverPath:wself.coverImage];
        wself.txPublishParams.videoPath = wself.media.videoPath;
        
        NSInteger errorCode = [wself.txPublish publishVideo:wself.txPublishParams];
        if (errorCode != 0 && kStringIsEmpty(wself.media.videoPath)) {
            kShowToast(@"视频上传失败");
            [ASMsgTool hideMsg];
        }
    } errorBack:^(NSInteger code, NSString *msg) {
        [ASMsgTool hideMsg];
    }];
}

- (NSString *)getCoverPath:(UIImage *)coverImage {
    UIImage *image = coverImage;
    if (image == nil) {
        return nil;
    }
    NSString *coverPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"TXUGC"];
    coverPath = [coverPath stringByAppendingPathComponent:[self getFileNameByTimeNow:@"TXUGC" fileType:@"jpg"]];
    if (coverPath) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[coverPath stringByDeletingLastPathComponent]
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:coverPath atomically:YES];
    }
    return coverPath;
}

- (NSString *)getFileNameByTimeNow:(NSString *)type fileType:(NSString *)fileType {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd_HHmmss"];
    NSDate * NowDate = [NSDate dateWithTimeIntervalSince1970:now];
    NSString * timeStr = [formatter stringFromDate:NowDate];
    NSString *fileName = ((fileType == nil) ||
                          (fileType.length == 0)
                          ) ? [NSString stringWithFormat:@"%@_%@",type,timeStr] : [NSString stringWithFormat:@"%@_%@.%@",type,timeStr,fileType];
    return fileName;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.backgroundColor = UIColor.whiteColor;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _scrollView;
}
- (UIImageView *)selectImage {
    if (!_selectImage) {
        _selectImage = [[UIImageView alloc]init];
        _selectImage.layer.cornerRadius = SCALES(8);
        _selectImage.layer.masksToBounds = YES;
        _selectImage.contentMode = UIViewContentModeScaleAspectFill;
        _selectImage.userInteractionEnabled = YES;
    }
    return _selectImage;
}
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.font = TEXT_FONT_15;
        _textView.textColor = TITLE_COLOR;
        _textView.backgroundColor = UIColor.whiteColor;
        _textView.delegate = self;
        _textView.ug_placeholderStr = @"添加视频秀描述，最多可输入36个字...";
        _textView.ug_maximumLimit = 36;
    }
    return _textView;
}
- (TXUGCPublish *)txPublish {
    if (!_txPublish) {
        _txPublish = [[TXUGCPublish alloc]initWithUserID:USER_INFO.user_id];
        _txPublish.delegate = self;
    }
    return _txPublish;
}
- (TXPublishParam *)txPublishParams {
    if (!_txPublishParams) {
        _txPublishParams = [[TXPublishParam alloc]init];
    }
    return _txPublishParams;
}
- (ASVideoShowPublishSetCoverView *)setCoverView {
    if (!_setCoverView) {
        _setCoverView = [[ASVideoShowPublishSetCoverView alloc]init];
    }
    return _setCoverView;
}
- (ASVideoShowPublishBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[ASVideoShowPublishBottomView alloc]init];
    }
    return _bottomView;
}
@end
