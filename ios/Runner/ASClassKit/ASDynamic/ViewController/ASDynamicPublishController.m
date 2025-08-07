//
//  ASDynamicPublishController.m
//  AS
//
//  Created by SA on 2025/5/8.
//

#import "ASDynamicPublishController.h"
#import "ASBasePhotoCell.h"
#import "ASDynamicRequest.h"

@interface ASDynamicPublishController ()<UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *publishBtn;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic ,strong) UILabel *textCount;
@property (nonatomic, strong) UICollectionView *collectionView;
/**数据**/
@property (nonatomic, assign) NSInteger maxTextCount;
@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, assign) NSInteger maxImageCount;
@property (nonatomic, assign) BOOL isPublishing;
@end

@implementation ASDynamicPublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"发布动态";
    [self createUI];
    
    self.isPublishing = NO;
    self.maxTextCount = 100;
    self.maxImageCount = 9;
}

- (void)createUI {
    kWeakSelf(self);
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.publishBtn = ({
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCALES(64), SCALES(26))];
        button.adjustsImageWhenHighlighted = NO;
        [button setBackgroundImage:[UIImage imageNamed:@"publish1"] forState:UIControlStateNormal];
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [wself.view endEditing:YES];
            if (wself.isPublishing == YES) {
                return;
            }
            wself.isPublishing = YES;
            [[ASUploadImageManager shared] imagesUpdateWithAliOSSType:@"dynamic" imgaes:wself.selectedPhotos success:^(id  _Nonnull response) {
                NSArray *urls = response;
                NSString *urlsString = [urls componentsJoinedByString: @","];
                [wself requestPublishWithUrl:urlsString];
            } fail:^{
                wself.isPublishing = NO;
            }];
        }];
        button;
    });
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.publishBtn];
    
    UIView *textViewBg = [[UIView alloc] init];
    [self.scrollView addSubview:textViewBg];
    [textViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.width.mas_equalTo(SCREEN_WIDTH - SCALES(32));
        make.top.equalTo(self.scrollView.mas_top).offset(SCALES(14));
        make.height.mas_equalTo(SCALES(140));
    }];
    
    [textViewBg addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(textViewBg);
        make.bottom.equalTo(textViewBg).offset(SCALES(-20));
    }];
    
    [textViewBg addSubview:self.textCount];
    [self.textCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.textView);
        make.bottom.equalTo(textViewBg.mas_bottom);
        make.height.mas_equalTo(SCALES(20));
    }];
    
    CGFloat itemWH = floorf((SCREEN_WIDTH - SCALES(32) - SCALES(14)) / 3);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.minimumInteritemSpacing = SCALES(7);
    layout.minimumLineSpacing = SCALES(7);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = ({
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.backgroundColor = UIColor.whiteColor;
        [self.scrollView addSubview:collectionView];
        collectionView;
    });
    [self.collectionView registerClass:[ASBasePhotoCell class] forCellWithReuseIdentifier:@"basePhotoCell"];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.top.equalTo(textViewBg.mas_bottom).offset(SCALES(20));
        make.width.mas_equalTo(SCREEN_WIDTH - SCALES(32));
        make.height.mas_equalTo(itemWH*3 + SCALES(7*2));
    }];
    
    UIView *remindBgView = [[UIView alloc] init];
    remindBgView.backgroundColor = UIColorRGB(0xF5F5F5);
    remindBgView.layer.cornerRadius = SCALES(10);
    remindBgView.layer.masksToBounds = YES;
    [self.scrollView addSubview:remindBgView];
    [remindBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.top.equalTo(self.collectionView.mas_bottom).offset(SCALES(50));
        make.width.mas_equalTo(SCREEN_WIDTH - SCALES(32));
        make.bottom.equalTo(self.scrollView.mas_bottom).offset(SCALES(-20));
    }];
    
    UILabel *remind = [[UILabel alloc]init];
    remind.text = @"1、禁止发布色情，性暗示等低俗内容；\n2、禁止发布国家政治，暴恐暴乱等内容；\n3、不可涉及第三方平台信息；\n4、不可使用他人的图片或视频发布。";
    remind.textColor = TEXT_SIMPLE_COLOR;
    remind.font = TEXT_FONT_13;
    remind.numberOfLines = 0;
    [remindBgView addSubview:remind];
    [remind mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(12));
        make.top.mas_equalTo(SCALES(12));;
        make.width.mas_equalTo(SCREEN_WIDTH - SCALES(60));
        make.bottom.equalTo(remindBgView.mas_bottom).offset(SCALES(-12));
    }];
    
    NSString *isPopAlert = [ASUserDefaults valueForKey:[NSString stringWithFormat:@"%@_%@", STRING(USER_INFO.user_id), kIsPopDynamicConvention]];
    if (kStringIsEmpty(isPopAlert)) {
        [ASUserDefaults setValue:@"1" forKey:[NSString stringWithFormat:@"%@_%@", STRING(USER_INFO.user_id), kIsPopDynamicConvention]];
        NSMutableAttributedString *attributedString = [ASTextAttributedManager dynamicProtocolPopAExplainAction:^{
            ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
            vc.webUrl = USER_INFO.configModel.webUrl.approveRule;
            ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = UIModalPresentationPageSheet;
            [wself presentViewController:nav animated:YES completion:nil];
        } standardAction:^{
            ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
            vc.webUrl = USER_INFO.configModel.webUrl.operateRule;
            ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = UIModalPresentationPageSheet;
            [wself presentViewController:nav animated:YES completion:nil];
        }];
        [ASAlertViewManager protocolPopTitle:@"动态公约"
                                  cancelText:@"心聊想伴运营中心拥有最终解释权"
                                  cancelFont:TEXT_FONT_12
                        dismissOnMaskTouched:YES
                                  attributed:attributedString
                                affirmAction:^{
            [wself.textView becomeFirstResponder];
        } cancelAction:^{
            
        }];
    }
}

- (void)popVC {
    [self.view endEditing:YES];
    if (self.selectedPhotos.count > 0 || self.textView.text.length > 0) {
        kWeakSelf(self);
        [ASAlertViewManager defaultPopTitle:@"是否放弃发布内容" content:@"" left:@"确定" right:@"取消" affirmAction:^{
            [wself.navigationController popViewControllerAnimated:YES];
        } cancelAction:^{
            
        }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)requestPublishWithUrl:(NSString *)url {
    kWeakSelf(self);
    [ASDynamicRequest requestPublishDynamicWithContent:self.textView.text success:^(id  _Nullable data) {
        NSString *dynamicID = data;
        [ASDynamicRequest requestPublishWithURL:url dynamicID:dynamicID success:^(id  _Nullable data) {
            if (wself.refreshBlock) {
                wself.refreshBlock();
            }
            [wself.navigationController popViewControllerAnimated:YES];
            wself.isPublishing = NO;
        } errorBack:^(NSInteger code, NSString *msg) {
            wself.isPublishing = NO;
        }];
    } errorBack:^(NSInteger code, NSString *msg) {
        wself.isPublishing = NO;
    }];
}

- (void)verifyButton {
    if (self.selectedPhotos.count > 0 && self.textView.text.length > 0) {
        self.publishBtn.userInteractionEnabled = YES;
        [self.publishBtn setBackgroundImage:[UIImage imageNamed:@"publish"] forState:UIControlStateNormal];
    } else {
        self.publishBtn.userInteractionEnabled = NO;
        [self.publishBtn setBackgroundImage:[UIImage imageNamed:@"publish1"] forState:UIControlStateNormal];
    }
}

#pragma mark - TextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    [self verifyButton];
    NSInteger length = 0;
    NSInteger textLength;
    NSString *toBeString = textView.text;
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        if (toBeString.length > self.maxTextCount && textView.markedTextRange == nil) {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.maxTextCount];
            if (rangeIndex.length == 1) {
                textView.text = [toBeString substringToIndex:self.maxTextCount];
                textLength = textView.text.length;
            } else {
                textView.text = [toBeString substringWithRange:NSMakeRange(0, length)];
            }
            self.textCount.text = [NSString stringWithFormat:@"%@/%@",@(textView.text.length),@(self.maxTextCount)];
        } else {
            length = toBeString.length;
            self.textCount.text = [NSString stringWithFormat:@"%@/%@",@(textView.text.length),@(self.maxTextCount)];
        }
    }
}

#pragma mark UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.selectedPhotos.count >= self.maxImageCount) {
        return self.selectedPhotos.count;
    }
    return self.selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ASBasePhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"basePhotoCell" forIndexPath:indexPath];
    if (indexPath.row == self.selectedPhotos.count) {
        cell.image = [UIImage imageNamed:@"add_photo"];
        cell.isHidenDel = YES;
    } else {
        cell.image = self.selectedPhotos[indexPath.row];
        cell.isHidenDel = NO;
    }
    kWeakSelf(self);
    cell.delBlock = ^{
        [wself.selectedPhotos removeObjectAtIndex:indexPath.row];
        [wself.collectionView reloadData];
        [wself verifyButton];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    kWeakSelf(self);
    if (indexPath.row == self.selectedPhotos.count) {
        [[ASUploadImageManager shared] selectImagePickerWithMaxCount:self.maxImageCount - self.selectedPhotos.count isSelfieCamera:NO viewController:wself didFinish:^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets, BOOL isSelectOriginalPhoto) {
            if (wself.selectedPhotos.count == 0) {
                wself.selectedPhotos = [NSMutableArray arrayWithArray:photos];
            } else {
                [wself.selectedPhotos addObjectsFromArray:photos];
            }
            [wself.collectionView reloadData];
            [wself verifyButton];
        }];
    } else {
        NSMutableArray *photos = [NSMutableArray array];
        [self.selectedPhotos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GKPhoto *photo = [[GKPhoto alloc] init];
            photo.image = obj;
            [photos addObject:photo];
        }];
        [[ASUploadImageManager shared] showMediaWithPhotos:photos index:indexPath.row viewController:self];
    }
}

- (NSMutableArray *)selectedPhotos {
    if (!_selectedPhotos) {
        _selectedPhotos = [[NSMutableArray alloc]init];
    }
    return _selectedPhotos;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _scrollView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.backgroundColor = UIColor.whiteColor;
        _textView.ug_placeholderStr = @"分享生活，让有缘人看见你...";
        _textView.font = TEXT_FONT_16;
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeyDefault;
        _textView.ug_maximumLimit = self.maxTextCount;
    }
    return _textView;
}

- (UILabel *)textCount {
    if (!_textCount) {
        _textCount = [[UILabel alloc]init];
        _textCount.text = [NSString stringWithFormat:@"0/%zd",self.maxTextCount];
        _textCount.textColor = TEXT_SIMPLE_COLOR;
        _textCount.font = TEXT_FONT_12;
        _textCount.textAlignment = NSTextAlignmentRight;
    }
    return _textCount;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
