//
//  FristCustomCell.m
//  ManHua
//
//  Created by jason on 14-5-21.
//  Copyright (c) 2014年 jason. All rights reserved.
//

#import "FristCustomCell.h"
#import "SecondCustomCell.h"
#import "IntroductionViewController.h"
#import "FirstViewController.h"
@implementation FristCustomCell
@synthesize titleLable = _titleLable;
@synthesize parameterArray = _parameterArray;
@synthesize tableView = _tableView;
@synthesize firstViewController = _firstViewController;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width, 40)];
        _titleLable.textAlignment = NSTextAlignmentLeft;
        _titleLable.backgroundColor = [UIColor clearColor];
        [_titleLable setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13.f]];
        [self.contentView addSubview:_titleLable];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(-60.f, 0.f, 120.f, 320.f) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        [self.tableView.layer setAnchorPoint:CGPointMake(0, 0)];
        self.tableView.transform = CGAffineTransformMakeRotation(M_PI/-2);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.showsVerticalScrollIndicator = NO;
        [self.contentView addSubview:_tableView];
                
        // Initialization code
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_parameterArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"secondCell";
    SecondCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SecondCustomCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    }
    NSString *xiaotuUrl = [[_parameterArray objectAtIndex:indexPath.row] objectForKey:@"xiaotuUrl"];
    [cell.xiaotuCustom.xiaotuImage setImageWithURL:[NSURL URLWithString:xiaotuUrl] placeholderImage:[Fileprocessing imageWithColor:[UIColor grayColor] andSize:cell.xiaotuCustom.xiaotuImage.bounds.size]];
    cell.titleLabel.text = [[_parameterArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    [cell.xiaotuCustom.newestBtn setTitle: [[_parameterArray objectAtIndex:indexPath.row]objectForKey:@"newest"] forState:UIControlStateNormal];  ;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    IntroductionViewController *introduction = [[IntroductionViewController alloc] init];
    introduction.xiaotuContent = [_parameterArray objectAtIndex:indexPath.row];
//    introduction.contentUrl = [[_parameterArray objectAtIndex:indexPath.row] objectForKey:@"contentUrl"];
    introduction.content = [_parameterArray objectAtIndex:indexPath.row];
    _firstViewController.hidesBottomBarWhenPushed = YES;
   [_firstViewController.navigationController pushViewController:introduction animated:YES];    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)createScroll:(NSArray *)parameterArray
{
    
}

@end
