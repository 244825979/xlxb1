//
//  ASSetCellModel.m
//  AS
//
//  Created by SA on 2025/4/21.
//

#import "ASSetCellModel.h"

@implementation ASSetCellModel

- (void)setCellType:(ASSetCellType)cellType {
    _cellType = cellType;
    switch (cellType) {
        case kSetEditCellUploadAvatar:
            self.cellIndentify = @"editAvatarCell";
            self.cellHeight = SCALES(70);
            break;
        case kSetEditCellVoiceSign:
            self.cellIndentify = @"editVoiceSignCell";
            self.cellHeight = SCALES(70);
            break;
        case kSetEditCellPhotoWall:
            self.cellIndentify = @"editPhotoWallCell";
            self.cellHeight = SCALES(175);
            break;
        case kSetEditCellMyTags:
            self.cellIndentify = @"editMyTagsCell";
            self.cellHeight = SCALES(59);
            break;
        case kSetStateCellText:
            self.cellIndentify = @"editStateCellText";
            self.cellHeight = SCALES(50);
            break;
        default:
            self.cellIndentify = @"baseCommonCell";
            self.cellHeight = SCALES(50);
            break;
    }
}
@end
