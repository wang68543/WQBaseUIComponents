//
//  WQCommonBaseCell.h
//  SomeUIKit
//
//  Created by WangQiang on 2017/3/13.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQCommonCellProtocol.h"

@class WQCommonBaseCell;

@interface WQCommonBaseCell : UITableViewCell<WQCommonCellProtocol>

@property (strong ,nonatomic) WQCommonBaseItem *baseItem;

@end
