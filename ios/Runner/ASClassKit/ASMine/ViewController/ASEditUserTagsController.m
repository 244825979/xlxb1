//
//  ASEditUserTagsController.m
//  AS
//
//  Created by SA on 2025/4/22.
//

#import "ASEditUserTagsController.h"
#import "ASEditTagsDataModel.h"
#import "ASMineRequest.h"

@interface ASEditUserTagsController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *selectTagsBgView;
@property (nonatomic, strong) UIView *tagsBgView;
@property (nonatomic, strong) UIButton *saveBtn;
/**数据**/
@property (nonatomic, strong) ASEditTagsDataModel *tagsModel;
@property (nonatomic, strong) NSMutableArray *selectTagsStrings;
@end

@implementation ASEditUserTagsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"我的标签";
    [self createUI];
    [self requestData];
}

- (void)createUI {
    kWeakSelf(self);
    self.saveBtn = ({
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCALES(48), SCALES(26))];
        [button setTitle:@"保存" forState:UIControlStateNormal];
        button.titleLabel.font = TEXT_FONT_14;
        button.layer.cornerRadius = SCALES(13);
        button.layer.masksToBounds = YES;
        if (self.selectTags.count > 0) {
            [button setBackgroundColor: GRDUAL_CHANGE_BG_COLOR(SCALES(48), SCALES(26))];
            button.userInteractionEnabled = YES;
        } else {
            [button setBackgroundColor: UIColorRGB(0xCCCCCC)];
            button.userInteractionEnabled = NO;
        }
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.selectTags.count == 0) {
                return;
            }
            if (wself.saveBlock) {
                wself.saveBlock(wself.selectTags);
                [wself.navigationController popViewControllerAnimated:YES];
            }
        }];
        button;
    });
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.saveBtn];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.view);
        make.left.mas_equalTo(SCALES(14));
        make.right.equalTo(self.view).offset(SCALES(-14));
    }];
    
    UILabel *subTitle = [[UILabel alloc]init];
    subTitle.text = @"已选择的标签";
    subTitle.font = TEXT_MEDIUM(22);
    subTitle.textColor = TITLE_COLOR;
    [self.scrollView addSubview:subTitle];
    [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(12));
        make.left.equalTo(self.scrollView);
        make.height.mas_equalTo(SCALES(24));
    }];
    
    self.selectTagsBgView = ({
        UIView *view = [[UIView alloc] init];
        [self.scrollView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(subTitle.mas_bottom).offset(SCALES(16));
            make.left.equalTo(self.scrollView);
            make.right.equalTo(self.view.mas_right).offset(SCALES(-14));
            make.height.mas_equalTo(SCALES(126));
        }];
        view;
    });
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = LINE_COLOR;
    [self.scrollView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subTitle.mas_bottom).offset(SCALES(146));
        make.left.right.equalTo(self.selectTagsBgView);
        make.height.mas_equalTo(SCALES(1));
    }];
    
    [self resetSelectTagsBgView];
    [self.scrollView addSubview:self.tagsBgView];
}

- (void)requestData {
    kWeakSelf(self);
    [ASMineRequest requestTagsListSuccess:^(id  _Nullable data) {
        wself.tagsModel = data;
        [wself resetTagsBgView];
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

- (void)resetSelectTagsBgView {
    [self.selectTagsBgView removeAllSubviews];
    [self.selectTagsStrings removeAllObjects];
    if (self.selectTags.count > 0) {
        kWeakSelf(self);
        NSInteger currentRight = 0; //记录当前Btn的right（右边）
        NSInteger currentBotton = 0; //记录当前btn的bottom（底部）
        for (int i = 0; i < self.selectTags.count; i++) {
            ASTagsModel *nameModel = self.selectTags[i];
            [self.selectTagsStrings addObject:STRING(nameModel.name)];
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(currentRight, currentBotton + SCALES(4), SCALES(50), SCALES(28));
            CGSize size = [nameModel.name boundingRectWithSize:CGSizeMake(self.selectTagsBgView.width, 30000)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:TEXT_FONT_15}
                                                       context:nil].size;
            
            currentRight = currentRight + size.width + SCALES(50);
            if (i < self.selectTags.count -1){
                ASTagsModel *nameStr = self.selectTags[i + 1];
                CGSize size = [nameStr.name boundingRectWithSize:CGSizeMake(self.selectTagsBgView.width,30000)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName:TEXT_FONT_15}
                                                         context:nil].size;
                
                if (currentRight + size.width > SCREEN_WIDTH - SCALES(70)) {
                    currentRight = 0;
                    currentBotton = currentBotton + SCALES(40);
                }
            }
            CGRect frame = CGRectMake(label.frame.origin.x,
                                      label.frame.origin.y + SCALES(6),
                                      size.width + SCALES(36),
                                      SCALES(28));
            label.frame = frame;
            label.text = STRING(nameModel.name);
            label.font = TEXT_FONT_15;
            label.textColor = UIColor.whiteColor;
            label.backgroundColor = UIColorRGB(0xFD6E6A);
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.cornerRadius = SCALES(4);//4是圆角的弧度，根据需求自己更改
            label.layer.masksToBounds = YES;
            [self.selectTagsBgView addSubview:label];
            
            UIButton *close = [[UIButton alloc] init];
            [close setImage:[UIImage imageNamed:@"del_image1"] forState:UIControlStateNormal];
            [[close rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                [wself.selectTags removeObject:nameModel];
                [wself resetSelectTagsBgView];
                [wself resetTagsBgView];
                if (wself.selectTags.count == 0) {
                    [wself.saveBtn setBackgroundColor: UIColorRGB(0xCCCCCC)];
                    wself.saveBtn.userInteractionEnabled = NO;
                } else {
                    [wself.saveBtn setBackgroundColor: GRDUAL_CHANGE_BG_COLOR(SCALES(48), SCALES(26))];
                    wself.saveBtn.userInteractionEnabled = YES;
                }
            }];
            [self.selectTagsBgView addSubview:close];
            close.frame = CGRectMake(label.x + label.width - SCALES(15),
                                     label.y - SCALES(6),
                                     SCALES(18),
                                     SCALES(18));
        }
    }
}

- (void)resetTagsBgView {
    [self.tagsBgView removeAllSubviews];
    NSInteger currentRight = 0; //记录当前Btn的right（右边）
    NSInteger currentBotton = 0; //记录当前btn的bottom（底部）
    if (self.tagsModel.tag_list.count > 0) {
        kWeakSelf(self);
        for (int i = 0; i < self.tagsModel.tag_list.count; i++) {
            ASTagsModel *tagModel = self.tagsModel.tag_list[i];
            if ([self.selectTagsStrings containsObject:tagModel.name]) {
                //如果没有包含选中就不添加，跳出当前循环
                continue;
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(currentRight, currentBotton + SCALES(4), SCALES(50), SCALES(28));
            CGSize size = [tagModel.name boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - SCALES(32), 30000)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName: TEXT_FONT_15}
                                                      context:nil].size;
            currentRight = currentRight + size.width + SCALES(50);
            if (i < self.tagsModel.tag_list.count - 1){
                ASTagsModel *tagModel1 = self.tagsModel.tag_list[i + 1];
                CGSize size = [tagModel1.name boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - SCALES(32), 30000)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName:TEXT_FONT_15}
                                                           context:nil].size;
                
                if (currentRight + size.width > SCREEN_WIDTH - SCALES(70)) {
                    currentRight = 0;
                    currentBotton = currentBotton + SCALES(40);
                }
            }
            CGRect frame = CGRectMake(button.frame.origin.x,
                                      button.frame.origin.y,
                                      size.width + SCALES(36),
                                      SCALES(28));
            button.frame = frame;
            [button setTitle:STRING(tagModel.name) forState:UIControlStateNormal];
            button.titleLabel.font = TEXT_FONT_15;
            [button setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
            button.layer.cornerRadius = SCALES(4);//4是圆角的弧度，根据需求自己更改
            button.layer.masksToBounds = YES;
            button.layer.borderColor = UIColorRGB(0xe4e4e4).CGColor;
            button.layer.borderWidth = SCALES(0.5);
            button.adjustsImageWhenHighlighted = NO;
            [self.tagsBgView addSubview:button];
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                if (wself.selectTags.count >= 8) {
                    kShowToast(@"最多选择8个标签");
                    return;
                }
                if ([wself.selectTags containsObject:tagModel]) {//如果没有包含，就不添加
                    kShowToast(@"已经选择了该标签");
                    return;
                }
                [wself.selectTags addObject:tagModel];
                [wself resetSelectTagsBgView];
                [wself resetTagsBgView];
                if (wself.selectTags.count == 0) {
                    [wself.saveBtn setBackgroundColor: UIColorRGB(0xCCCCCC)];
                    wself.saveBtn.userInteractionEnabled = NO;
                } else {
                    [wself.saveBtn setBackgroundColor: GRDUAL_CHANGE_BG_COLOR(SCALES(48), SCALES(26))];
                    wself.saveBtn.userInteractionEnabled = YES;
                }
            }];
            if (i == self.tagsModel.tag_list.count -1) {
                self.tagsBgView.frame = CGRectMake(0, SCALES(196), SCREEN_WIDTH - SCALES(28), currentBotton + SCALES(260));
                self.scrollView.contentSize = CGSizeMake(0, currentBotton + SCALES(260));
            }
        }
    }
}

#pragma mark - 点击事件
- (void)selectButtonClcik:(UIButton *)button {
    if (self.selectTags.count >= 8) {
        kShowToast(@"最多选择8个标签");
        return;
    }
    NSInteger index = button.tag - 1000;
    ASTagsModel *tagModel = self.tagsModel.tag_list[index];
    [self.selectTags addObject:tagModel];
    
    if (self.selectTags.count == 0) {
        [self.saveBtn setBackgroundColor: UIColorRGB(0xCCCCCC)];
        self.saveBtn.userInteractionEnabled = NO;
    } else {
        [self.saveBtn setBackgroundColor: GRDUAL_CHANGE_BG_COLOR(SCALES(48), SCALES(26))];
        self.saveBtn.userInteractionEnabled = YES;
    }
    button.highlighted = NO;
    if (button.selected == NO) {
        [self.selectTags addObject:tagModel];
        button.selected = YES;
    } else {
        for (ASTagsModel *selectTag in self.selectTags) {
            if ([tagModel.ID isEqualToString:selectTag.ID]) {
                [self.selectTags removeObject:selectTag];
                button.selected = NO;
                break;
            }
        }
    }
}

- (NSMutableArray *)selectTags {
    if (!_selectTags) {
        _selectTags = [[NSMutableArray alloc]init];
    }
    return _selectTags;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)tagsBgView {
    if (!_tagsBgView) {
        _tagsBgView = [[UIView alloc]init];
    }
    return _tagsBgView;
}

- (NSMutableArray *)selectTagsStrings {
    if (!_selectTagsStrings) {
        _selectTagsStrings = [[NSMutableArray alloc]init];
    }
    return _selectTagsStrings;
}
@end
