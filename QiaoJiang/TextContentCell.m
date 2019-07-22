//
//  TextContentCell.m
//  QiaoJiang
//
//  Created by Gray on 2019/7/20.
//  Copyright © 2019年 GL. All rights reserved.
//

#import "TextContentCell.h"

@implementation TextContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = [UIColor grayColor];
        self.textLabel.numberOfLines = 0;
    }
    return self;
}

-(void)refreshCellUI:(NSArray *)modules {
    self.textLabel.attributedText = [self extractTexts:modules];
}

-(NSAttributedString *)extractTexts:(NSArray *)modules {
    NSMutableString *strM = [[NSMutableString alloc] init];
    for (RecommentContentModel *cModel in modules) {
        if([cModel.type isEqualToString:@"TEXT"] && cModel.text){
            [strM appendString:cModel.text];
            [strM appendString:@"\n"];
        }
    }
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:strM];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.paragraphSpacing = 10;
    [attStr addAttributes:@{NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, strM.length)];
    return attStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
