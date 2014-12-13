//
//  UITableViewCell+SWTableViewCell.m
//  SmartWatch
//
//  Created by zhuzhi on 14/12/13.
//
//

#import "UITableViewCell+SW.h"

@implementation UITableViewCell (SW)

- (UITableView *)tableView {
    return IOS7 ? (UITableView *)[[self superview] superview]: (UITableView *)[self superview];
}

@end
