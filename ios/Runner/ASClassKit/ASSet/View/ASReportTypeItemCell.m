//
//  ASReportTypeItemCell.m
//  AS
//
//  Created by SA on 2025/5/9.
//

#import "ASReportTypeItemCell.h"
#import "ASReportModel.h"

@interface ASReportTypeItemCell ()
@property (nonatomic, strong) UIButton *selectItem;
@end

@implementation ASReportTypeItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)clikedButton:(UIButton *)button {
    if (!button.selected) {
        self.selectItem.selected = NO;
        self.selectItem.layer.borderColor = UIColorRGB(0xCCCCCC).CGColor;
        [self.selectItem setBackgroundColor:UIColorRGB(0xF5F5F5)];
        button.selected = !button.selected;
        self.selectItem = button;
        self.selectItem.layer.borderColor = MAIN_COLOR.CGColor;
        [self.selectItem setBackgroundColor:MAIN_COLOR];
        ASReportModel *model = self.items[button.tag];
        if (self.backBlock) {
            self.backBlock(model.ID);
        }
    }
}

- (void)setItems:(NSArray *)items {
    _items = items;
    if (self.items.count > 0) {
        NSInteger corlmax = 3;
        CGFloat btnW = (SCREEN_WIDTH - SCALES(32) - SCALES(16))/corlmax;
        CGFloat btnH = SCALES(36);
        for (int i = 0; i < self.items.count; i++) {
            ASReportModel *model = self.items[i];
            int row = i/corlmax;
            int col = i%corlmax;
            CGFloat x = SCALES(16) + (btnW + SCALES(8)) * col;
            CGFloat y = (btnH + SCALES(8)) * row;
            UIButton *btn = [[UIButton alloc] init];
            btn.frame = CGRectMake(x, y, btnW, btnH);
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = SCALES(6);
            btn.layer.borderColor = UIColorRGB(0xCCCCCC).CGColor;
            btn.layer.borderWidth = SCALES(1);
            [btn setBackgroundColor:UIColorRGB(0xF5F5F5)];
            btn.tag = i;
            [btn setTitle:model.name forState:UIControlStateNormal];
            [btn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
            [btn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
            btn.titleLabel.font = TEXT_FONT_14;
            btn.titleLabel.minimumScaleFactor = 0.5;
            [btn addTarget:self action:@selector(clikedButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
        }
    }
}
@end
