//
//  ASConvenienceLanAddController.m
//  AS
//
//  Created by SA on 2025/5/21.
//

#import "ASConvenienceLanAddController.h"
#import "ASConvenienceLanAddModel.h"
#import "ASBaseTranscribeAudioView.h"
#import "ASMineRequest.h"

@interface ASConvenienceLanAddController ()<UITextViewDelegate>
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *lengthLabel;
@property (nonatomic, strong) UIImageView *photoImage;
@property (nonatomic, strong) UIButton *delPhoto;
@property (nonatomic, strong) ASBaseTranscribeAudioView *recordView;
/**数据**/
@property (nonatomic, strong) NSArray *selectPhotos;
@property (nonatomic, strong) ASConvenienceLanAddModel *dataModel;
@end

@implementation ASConvenienceLanAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"新建便捷用语";
    [self createUI];
}

- (void)createUI {
    self.saveBtn = ({
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        [button setTitle:@"保存" forState:UIControlStateNormal];
        [button setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        button.titleLabel.font = TEXT_FONT_15;
        button.userInteractionEnabled = NO;
        kWeakSelf(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [wself.view endEditing:YES];
            [wself updatePhoto];
        }];
        button;
    });
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.saveBtn];
    UIView *textBgView = [[UIView alloc] init];
    textBgView.backgroundColor = UIColorRGB(0xF5F5F5);
    textBgView.layer.cornerRadius = SCALES(8);
    [self.view addSubview:textBgView];
    [textBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(14));
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view).offset(SCALES(-28));
        make.height.mas_equalTo(SCALES(156));
    }];
    [textBgView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(10));
        make.left.mas_equalTo(SCALES(12));
        make.width.equalTo(textBgView).offset(SCALES(-24));
        make.height.mas_equalTo(SCALES(110));
    }];
    [textBgView addSubview:self.lengthLabel];
    [self.lengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(textBgView).offset(SCALES(-8));
        make.height.mas_equalTo(SCALES(20));
    }];
    UILabel *photoTitle = [[UILabel alloc]init];
    photoTitle.textColor = TEXT_SIMPLE_COLOR;
    photoTitle.font = TEXT_FONT_14;
    NSMutableAttributedString *photoAttributed = [[NSMutableAttributedString alloc] initWithString:@"添加图片（仅可添加一张）"];
    [photoAttributed addAttribute:NSForegroundColorAttributeName
                            value:TITLE_COLOR
                            range:NSMakeRange(0, 4)];
    [photoTitle setAttributedText:photoAttributed];
    [self.view addSubview:photoTitle];
    [photoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(14));
        make.top.equalTo(textBgView.mas_bottom).offset(SCALES(14));
        make.height.mas_equalTo(SCALES(24));
    }];
    [self.view addSubview:self.photoImage];
    [self.photoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(14));
        make.top.equalTo(photoTitle.mas_bottom).offset(SCALES(14));
        make.height.width.mas_equalTo(SCALES(111));
    }];
    [self.view addSubview:self.delPhoto];
    [self.delPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.photoImage).offset(SCALES(-8));
        make.right.equalTo(self.photoImage).offset(SCALES(3));
        make.height.width.mas_equalTo(SCALES(19));
    }];
    UILabel *voiceTitle = [[UILabel alloc]init];
    voiceTitle.textColor = TEXT_SIMPLE_COLOR;
    voiceTitle.font = TEXT_FONT_14;
    NSMutableAttributedString *voiceAttributed = [[NSMutableAttributedString alloc] initWithString:@"添加语音（限制5~15秒，非必填）"];
    [voiceAttributed addAttribute:NSForegroundColorAttributeName
                            value:TITLE_COLOR
                            range:NSMakeRange(0, 4)];
    [voiceTitle setAttributedText:voiceAttributed];
    [self.view addSubview:voiceTitle];
    [voiceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(14));
        make.top.equalTo(self.photoImage.mas_bottom).offset(SCALES(14));
        make.height.mas_equalTo(SCALES(24));
    }];
    [self.view addSubview:self.recordView];
    [self.recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset((SCALES(-34) - TAB_BAR_MAGIN));
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(SCALES(170));
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
}

- (void)updatePhoto {
    kWeakSelf(self);
    if (self.recordView.isTranscribe == YES) {
        kShowToast(@"正在录制语音~");
        return;
    }
    if (self.selectPhotos.count > 0) {
        [[ASUploadImageManager shared] oneImageUpdateWithAliOSSType:@"greet/img" imgae:self.selectPhotos[0] success:^(id _Nonnull response) {
            NSString *url = response;
            wself.dataModel.file = url;
            [wself saveRequest];
        } fail:^{
            
        }];
    } else {
        [wself saveRequest];
    }
}

- (void)saveRequest {
    kWeakSelf(self);
    [ASMineRequest requestAddConvenienceLanWithModel:wself.dataModel success:^(id _Nullable data) {
        if (wself.refreshBolck) {
            wself.refreshBolck();
        }
        [wself.navigationController popViewControllerAnimated:YES];
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

- (void)updateAudioWithFilePath:(NSString *)path {
    kWeakSelf(self);
    [[ASUploadImageManager shared] audioUpdateWithType:@"voice" filePath:path success:^(id  _Nonnull response) {
        kShowToast(@"语音录制成功");
        NSString *url = response;
        wself.dataModel.voice_file = STRING(url);
    } fail:^{
        
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0 || !kStringIsEmpty(self.dataModel.voice_file)) {
        [self.saveBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        self.saveBtn.userInteractionEnabled = YES;
    } else {
        [self.saveBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        self.saveBtn.userInteractionEnabled = NO;
    }
    NSInteger length = 0;
    NSInteger textLength;
    NSString *toBeString = textView.text;
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        if (toBeString.length > 50 && textView.markedTextRange == nil) {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:50];
            if (rangeIndex.length == 1) {
                textView.text = [toBeString substringToIndex:50];
                textLength = textView.text.length;
            } else {
                textView.text = [toBeString substringWithRange:NSMakeRange(0, length)];
            }
            self.lengthLabel.text = [NSString stringWithFormat:@"%@/%@",@(textView.text.length),@(50)];
        } else {
            length = toBeString.length;
            self.lengthLabel.text = [NSString stringWithFormat:@"%@/%@",@(textView.text.length),@(50)];
        }
    }
    self.dataModel.title = textView.text;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.font = TEXT_FONT_14;
        _textView.textColor = TITLE_COLOR;
        _textView.backgroundColor = UIColor.clearColor;
        _textView.delegate = self;
        _textView.ug_placeholderStr = @"添加搭讪语，获得更多关注~";
    }
    return _textView;
}

- (UILabel *)lengthLabel {
    if (!_lengthLabel) {
        _lengthLabel = [[UILabel alloc]init];
        _lengthLabel.text = @"0/50";
        _lengthLabel.font = TEXT_FONT_14;
        _lengthLabel.textColor = UIColorRGB(0xBEBEBE);
        _lengthLabel.textAlignment = NSTextAlignmentRight;
    }
    return _lengthLabel;
}

- (UIImageView *)photoImage {
    if (!_photoImage) {
        _photoImage = [[UIImageView alloc]init];
        _photoImage.layer.masksToBounds = YES;
        _photoImage.layer.cornerRadius = SCALES(5);
        _photoImage.userInteractionEnabled = YES;
        _photoImage.image = [UIImage imageNamed:@"add_photo"];
        _photoImage.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [_photoImage addGestureRecognizer:tap];
        kWeakSelf(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.selectPhotos.count == 0) {
                [[ASUploadImageManager shared] selectImagePickerWithMaxCount:1 isSelfieCamera:NO viewController:wself didFinish:^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets, BOOL isSelectOriginalPhoto) {
                    wself.delPhoto.hidden = NO;
                    wself.selectPhotos = photos;
                    wself.photoImage.image = photos[0];
                }];
            } else {
                NSMutableArray *photos = [NSMutableArray array];
                [self.selectPhotos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    GKPhoto *photo = [[GKPhoto alloc] init];
                    photo.image = obj;
                    [photos addObject:photo];
                }];
                [[ASUploadImageManager shared] showMediaWithPhotos:photos index:0 viewController:[ASCommonFunc currentVc]];
            }
        }];
    }
    return _photoImage;
}

- (ASBaseTranscribeAudioView *)recordView {
    if (!_recordView) {
        _recordView = [[ASBaseTranscribeAudioView alloc]init];
        _recordView.type = 0;
        kWeakSelf(self);
        _recordView.saveBlock = ^(NSString * _Nonnull filePath, NSInteger voiceTime) {
            wself.dataModel.length = voiceTime;
            [wself updateAudioWithFilePath:filePath];
            [wself.saveBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
            wself.saveBtn.userInteractionEnabled = YES;
        };
        _recordView.closeBlock = ^{
            wself.dataModel.voice_file = @"";
            wself.dataModel.length = 0;
            if (wself.textView.text.length > 0) {
                [wself.saveBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
                wself.saveBtn.userInteractionEnabled = YES;
            } else {
                [wself.saveBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
                wself.saveBtn.userInteractionEnabled = NO;
            }
        };
    }
    return _recordView;
}

- (UIButton *)delPhoto {
    if (!_delPhoto) {
        _delPhoto = [[UIButton alloc]init];
        _delPhoto.hidden = YES;
        [_delPhoto setBackgroundImage:[UIImage imageNamed:@"del_image"] forState:UIControlStateNormal];
        kWeakSelf(self);
        [[_delPhoto rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            wself.selectPhotos = @[];
            wself.delPhoto.hidden = YES;
            wself.photoImage.image = [UIImage imageNamed:@"add_photo"];
        }];
    }
    return _delPhoto;
}

- (ASConvenienceLanAddModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[ASConvenienceLanAddModel alloc]init];
    }
    return _dataModel;
}
@end
