//
//  ASReportController.m
//  AS
//
//  Created by SA on 2025/5/9.
//

#import "ASReportController.h"
#import "ASBaseNavigationView.h"
#import "ASReportPhotoCell.h"
#import "ASReportTypeItemCell.h"
#import "ASSetRequest.h"

@interface ASReportController ()<UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ASBaseTableView *tableView;
@property (nonatomic, strong) UIView *itemBg;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *selectItem;
@property (nonatomic ,strong) UILabel *textCountLabel;
@property (nonatomic, strong) ASBaseNavigationView *navigationView;
/**数据**/
@property (nonatomic, assign) NSInteger maxTextCount;
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, copy) NSString *cateID;
@property (nonatomic, assign) BOOL isReloadData;
@property (nonatomic, strong) UIButton *selectItemBtn;
@end

@implementation ASReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldNavigationBarHidden = YES;
    self.maxTextCount = 100;
    self.isReloadData = YES;
    self.sectionTitles = @[@"请选择举报的原因", @"图片证据", @"文字描述"];
    [self createUI];
    [self requestReport];
}

- (void)createUI {
    kWeakSelf(self);
    self.navigationView.frame = CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_NAVBAR);
    [self.view addSubview:self.navigationView];
    self.navigationView.clikedBlock = ^(UIButton * _Nonnull button, NSString * _Nonnull type) {
        if ([type isEqualToString:@"返回"]) {
            [wself dismissViewControllerAnimated:YES completion:^{ }];
            return;
        }
    };
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-TAB_BAR_MAGIN - SCALES(66));
    }];
    [self.tableView registerClass:[ASReportTypeItemCell class] forCellReuseIdentifier:@"reportTypeItemCell"];
    [self.tableView registerClass:[ASReportPhotoCell class] forCellReuseIdentifier:@"reportPhotoCell"];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCALES(170))];
    [self.tableView setTableFooterView:footerView];
    UIView *textBgView = [[UIView alloc] init];
    textBgView.backgroundColor = UIColorRGB(0xf5f5f5);
    textBgView.layer.cornerRadius = SCALES(8);
    [footerView addSubview:textBgView];
    [textBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.top.equalTo(footerView);
        make.height.mas_equalTo(SCALES(144));
        make.width.mas_equalTo(SCREEN_WIDTH - SCALES(32));
    }];
    [textBgView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(8));
        make.left.mas_equalTo(SCALES(12));
        make.right.offset(SCALES(-12));
        make.bottom.offset(SCALES(-30));
    }];
    [textBgView addSubview:self.textCountLabel];
    [self.textCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(textBgView).offset(SCALES(-8));
        make.height.mas_equalTo(SCALES(16));
    }];
    self.submitBtn = ({
        UIButton *bottom = [[UIButton alloc]init];
        [bottom setTitle:@"提交" forState:UIControlStateNormal];
        bottom.titleLabel.font = TEXT_FONT_18;
        [bottom setBackgroundImage:[UIImage imageNamed:@"button_bg1"] forState:UIControlStateNormal];
        [bottom setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        bottom.userInteractionEnabled = NO;
        bottom.layer.cornerRadius = SCALES(25);
        bottom.layer.masksToBounds = YES;
        bottom.adjustsImageWhenHighlighted = NO;
        [[bottom rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [[ASUploadImageManager shared] imagesUpdateWithAliOSSType:@"album" imgaes:self.images success:^(id  _Nonnull response) {
                NSArray *urls = response;
                NSString *urlsString = [urls componentsJoinedByString: @","];
                [wself saveRequestWithUrls:urlsString];
            } fail:^{
                
            }];
        }];
        [self.view addSubview:bottom];
        [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(SCALES(319), SCALES(50)));
            make.bottom.mas_equalTo(-TAB_BAR_MAGIN - SCALES(8));
        }];
        bottom;
    });
}

- (void)requestReport {
    kWeakSelf(self);
    [ASSetRequest requestReportDataSuccess:^(id  _Nullable data) {
        wself.items = data;
        [wself.tableView reloadData];
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

- (void)saveRequestWithUrls:(NSString *)urls {
    kWeakSelf(self);
    [ASSetRequest requestReportWithType:self.type
                                    images:urls
                                   content:self.textView.text
                                 reportUid:self.uid
                                    cateID:self.cateID
                                   success:^(id  _Nullable data) {
        [ASAlertViewManager defaultPopTitle:@"举报成功"
                                    content:@"我们已接收到您的举报内容，非常重视您的举报。每一条举报都会被认真核实，并依据国家法律法规及本平台条款积极处理，感谢您的配合。"
                                       left:@"确定"
                                      right:@"需紧急处理"
                               affirmAction:^{
            [wself dismissViewControllerAnimated:YES completion:^{ }];
        } cancelAction:^{
            [wself dismissViewControllerAnimated:YES completion:^{
                ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
                vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_Customer];
                [[ASCommonFunc currentVc].navigationController pushViewController:vc animated:YES];
            }];
        }];
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

- (void)verifyButton {
    if (self.images.count > 0 && self.textView.text.length >= 10 && !kStringIsEmpty(self.cateID)) {
        self.submitBtn.userInteractionEnabled = YES;
        [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        [self.submitBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    } else {
        self.submitBtn.userInteractionEnabled = NO;
        [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"button_bg1"] forState:UIControlStateNormal];
        [self.submitBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.sectionTitles[indexPath.section];
    if ([title isEqualToString:@"请选择举报的原因"]) {
        return SCALES(128);
    }
    if ([title isEqualToString:@"图片证据"]) {
        CGFloat itemWH = floorf((SCREEN_WIDTH - SCALES(32) - SCALES(10)) / 3);
        if (self.items.count == 0) {
            return SCALES(itemWH);
        }
        NSInteger cols = (self.images.count+1)%3;
        CGFloat height = cols > 0 ? (self.images.count+1)/3 * (itemWH + SCALES(8)) + SCALES(itemWH) : (self.images.count+1)/3 * (itemWH + SCALES(8));
        return height > (itemWH*3 + SCALES(10)) ? (itemWH*3 + SCALES(10)) : height;
    }
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.sectionTitles[indexPath.section];
    kWeakSelf(self);
    if ([title isEqualToString:@"请选择举报的原因"]) {
        ASReportTypeItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reportTypeItemCell" forIndexPath:indexPath];
        if (self.isReloadData == YES) {
            cell.items = self.items;
        }
        cell.backBlock = ^(NSString * _Nonnull cateID) {
            wself.cateID = cateID;
            [wself verifyButton];
        };
        return cell;
    }
    if ([title isEqualToString:@"图片证据"]) {
        ASReportPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reportPhotoCell" forIndexPath:indexPath];
        cell.backBlock = ^(id  _Nonnull data) {
            wself.isReloadData = NO;
            wself.images = data;
            [wself.tableView reloadData];
            [wself verifyButton];
        };
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SCALES(60);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    NSString *title = self.sectionTitles[section];
    UILabel *text = [[UILabel alloc] init];
    text.font = TEXT_FONT_20;
    text.text = STRING(title);
    text.textColor = TITLE_COLOR;
    [view addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(16));
        make.height.centerY.equalTo(view);
    }];
    if ([title isEqualToString:@"图片证据"] || ([title isEqualToString:@"文字描述"])) {
        UILabel *little = [[UILabel alloc] init];
        little.font = TEXT_FONT_20;
        little.text = STRING(title);
        little.textColor = TEXT_SIMPLE_COLOR;
        little.text = @"（必填）";
        [view addSubview:little];
        [little mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(text.mas_right);
            make.centerY.equalTo(view);
        }];
    }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
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
            self.textCountLabel.text = [NSString stringWithFormat:@"%@/%@",@(textView.text.length),@(self.maxTextCount)];
        } else {
            length = toBeString.length;
            self.textCountLabel.text = [NSString stringWithFormat:@"%@/%@",@(textView.text.length),@(self.maxTextCount)];
        }
    }
}

- (ASBaseNavigationView *)navigationView {
    if (!_navigationView) {
        _navigationView = [[ASBaseNavigationView alloc]init];
        [_navigationView.backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        _navigationView.moreBtn.hidden = YES;
        _navigationView.title.hidden = NO;
        _navigationView.title.textColor = TITLE_COLOR;
        _navigationView.title.text = @"举报中心";
    }
    return _navigationView;
}

- (UILabel *)textCountLabel {
    if (!_textCountLabel) {
        _textCountLabel = [[UILabel alloc]init];
        _textCountLabel.text = [NSString stringWithFormat:@"0/%zd",self.maxTextCount];
        _textCountLabel.textColor = TEXT_SIMPLE_COLOR;
        _textCountLabel.font = TEXT_FONT_12;
        _textCountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _textCountLabel;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.font = TEXT_FONT_16;
        _textView.textColor = TITLE_COLOR;
        _textView.backgroundColor = UIColor.clearColor;
        _textView.delegate = self;
        _textView.ug_placeholderStr = @"请用至少10个文字详细描述举报原因，并在图片证据处提供违规截图，以便能更准确的核实问题。";
        _textView.ug_maximumLimit = self.maxTextCount;
    }
    return _textView;
}

- (ASBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ASBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self.tableView endEditing:YES];
    [self.textView resignFirstResponder];
}
@end
