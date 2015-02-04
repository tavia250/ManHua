//
//  IntroductionViewController.m
//  ManHua
//
//  Created by jason on 14-6-24.
//  Copyright (c) 2014年 jason. All rights reserved.
//

#import "IntroductionViewController.h"
#import "TFHpple.h"
#import "FristCustomCell.h"
#import "ThirdCustomCell.h"
@interface IntroductionViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation IntroductionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = [_xiaotuContent objectForKey:@"title"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.explainContent = [NSMutableDictionary dictionary];
    self.directorArray = [NSMutableArray array];
    NSString *contentUrl = [_content objectForKey:@"contentUrl"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:contentUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [NSURLConnection sendAsynchronousRequest:request queue:[Fileprocessing sharedOperationQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (!connectionError) {
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
            NSString *html=[[NSString alloc]initWithData:data encoding:enc];
            NSString *utf8HtmlStr = [html stringByReplacingOccurrencesOfString:@"gb2312"
                                                                    withString:@"utf-8"];
            
            NSData *htmlDataUTF8 = [utf8HtmlStr dataUsingEncoding:NSUTF8StringEncoding];
            
              [self ergodicHtml:htmlDataUTF8];
//            NSLog(@"%@",[NSThread currentThread]);
            
        }else
        {
            
            NSLog(@"%@",connectionError);
            
            
        }
        
        
    }];

    // Do any additional setup after loading the view.
}
- (void)ergodicHtml:(NSData *)htmlDataUTF8
{
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlDataUTF8];

    @try {
        NSArray *topelements = [xpathParser searchWithXPathQuery:@"//div[@class='w980 mt10 clearfix']/div[@class='intro_l'][@id='intro_l']/div[@class='info']/p"];
        for (TFHppleElement *element in topelements) {
            if ([[element children] count ] > 1) {
                NSString *title = [[[[element children] objectAtIndex:0] firstChild] content];
                NSString *content =[[[[element children] objectAtIndex:1] firstChild] content];
                if (!content) {
                    content =[[[element children] objectAtIndex:1] content];
                }
                if (content) {
                    [_explainContent setObject:content forKey:title];
                }
            }
        }
        
        NSArray *explainelements = [xpathParser searchWithXPathQuery:@"//div[@class='w980_b1px mt10']/div[@class='introduction'][@id='intro1']/p"];
        NSString *explain = [[[explainelements firstObject] firstChild] content];
        if (explain) {
            [_explainContent setObject:explain forKey:@"explain"];
        }
        NSString *foreshow = [[[explainelements objectAtIndex:1] firstChild] text];
        
        if(foreshow){
            [_explainContent setObject:foreshow forKey:@"foreshow"];
        }
        
        NSArray *titleelements = [xpathParser searchWithXPathQuery:@"//div[@class='w980_b1px mt10 pr clearfix']/div[@class='bar lh30']"];
        if (titleelements.count) {
            if ([[[titleelements firstObject] children] count] > 1) {
                NSString *title = [[[[titleelements firstObject] children] objectAtIndex:1] content];
                if (title) {
                    [_explainContent setObject:title forKey:@"title"];
                }
            }
            
        }
        
        NSArray *atlookelements = [xpathParser searchWithXPathQuery:@"//div[@class='w980_b1px mt10 pr clearfix']/div[@class='similarList'][@class='similarList']/ul"];
        NSArray *atlookArray = [self attributeArray:[atlookelements firstObject]];
        if (atlookArray.count) {
            [_explainContent setObject:atlookArray forKey:@"atlook"];
        }
        NSArray *directoryelements = [xpathParser searchWithXPathQuery:@"//div[@class='w980_b1px mt10 clearfix']/div[@class='plist pnormal'][@id='play_0']/ul"];
          [self directoryArray:[directoryelements firstObject]];
        if (_directorArray.count) {
            [_explainContent setObject:_directorArray forKey:@"director"];
        }
 
    }
    @catch (NSException *exception) {
#ifdef DEBUG
        NSLog(@"%s Caught %@: %@", __FUNCTION__, [exception name], [exception reason]);
#endif

        
    }
        dispatch_async(dispatch_get_main_queue(), ^{

    [self startLoadView];
    });
   // NSLog(@"%@",_explainContent );
    
}
- (NSMutableArray *)attributeArray:(TFHppleElement *)element
{
    NSURL *url  = [NSURL URLWithString:@"http://www.jide123.com"];
    NSMutableArray *contentArray = [NSMutableArray array];
    for (TFHppleElement *elementArray in [element children]) {
        NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
        if ([elementArray hasChildren]) {
            NSString *title = [[[[elementArray children] objectAtIndex:1] firstChild] content];
            [contentDic setObject:title forKey:@"title"];
            
            NSString *newest = [[[[[[[elementArray children] objectAtIndex:0] children] objectAtIndex:1] firstChild] firstChildWithTagName:@"text"] content];
            [contentDic setObject:newest forKey:@"newest"];
            
            NSString *xiaotuUrl = [[[[[[elementArray children] objectAtIndex:0] firstChild] firstChild] attributes] objectForKey:@"_src"];
            if (![xiaotuUrl hasPrefix:@"http://cartoon.jide123.cc"]) {
                xiaotuUrl = [[[[[[elementArray children] objectAtIndex:0] firstChild] firstChild] attributes] objectForKey:@"src"];
            }
            [contentDic setObject:xiaotuUrl forKey:@"xiaotuUrl"];
            
            NSString *contentUrl = [[[[[elementArray children] objectAtIndex:0] firstChild] attributes] objectForKey:@"href"];
            [contentDic setObject:[[NSURL URLWithString:contentUrl relativeToURL:url] absoluteString]
                           forKey:@"contentUrl"];
            
            NSString *newestUrl = [[[[[[[elementArray children] objectAtIndex:0] children] objectAtIndex:1] firstChild] attributes] objectForKey:@"href"];
            [contentDic setObject: [[NSURL URLWithString:newestUrl relativeToURL:url] absoluteString]
                           forKey:@"newestUrl"];
            
            [contentArray addObject:contentDic];
            
        }
    }
    return contentArray;
}

- (NSMutableArray *)directoryArray:(TFHppleElement *)element
{
    NSURL *url  = [NSURL URLWithString:@"http://www.jide123.com"];

    for (TFHppleElement *elementArray in [element children]) {
        
        NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
        if ([elementArray hasChildren]) {

        NSString *title = [[[[elementArray children] objectAtIndex:0] firstChild] content];
        [contentDic setObject:title forKey:@"title"];
            NSString *contentUrl = [[[elementArray firstChild] attributes] objectForKey:@"href"] ;
            [contentDic setObject:[[NSURL URLWithString:contentUrl relativeToURL:url] absoluteString]
                           forKey:@"contentUrl"];

        }
        
        [_directorArray addObject:contentDic];

    }
    return _directorArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)startLoadView
{
    CGRect tableViewRect = self.view.bounds;
    CGRect navBarRect = self.navigationController.navigationBar.bounds;
    CGRect tabBarRect = self.tabBarController.tabBar.bounds;
    
    _tableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CGFloat height = 0.0;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) // iOS 7+
    {
        if ([self prefersStatusBarHidden] == NO) // Visible status bar
            
            height = 44+20.f;
        self.tableView.contentInset = UIEdgeInsetsMake(168.f+navBarRect.size.height + 20.f,0,tabBarRect.size.height,0);

    }
    else
    {
        height = 0;
        self.tableView.contentInset = UIEdgeInsetsMake(168.f,0,0,0);

    }
    
    
    NSString *xiaotuUrl = [_xiaotuContent objectForKey:@"xiaotuUrl"];
    _xiaotuCustom = [[XiaotuCustom alloc] initWithFrame:CGRectMake(10, height+10, 80, 100)];
    [self.view addSubview:_xiaotuCustom];
    [_xiaotuCustom.xiaotuImage setImageWithURL:[NSURL URLWithString:xiaotuUrl] placeholderImage:[Fileprocessing imageWithColor:[UIColor grayColor] andSize:_xiaotuCustom.xiaotuImage.bounds.size]];
    [_xiaotuCustom.newestBtn setTitle: [_xiaotuContent objectForKey:@"newest"] forState:UIControlStateNormal];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, height+5, 200, 30)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13];
    titleLabel.text = [_xiaotuContent objectForKey:@"title"];
    [self.view addSubview:titleLabel];
    UILabel *updateLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, height + 35, 60, 20)];
    updateLabel.font = [UIFont fontWithName:@"Arial" size:11.f];
    updateLabel.textColor = [UIColor grayColor];
    updateLabel.textAlignment = NSTextAlignmentLeft;
    updateLabel.text = @"更新时间：";
    [self.view addSubview:updateLabel];
    UILabel *updateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, height + 35, 80, 20)];
    updateTimeLabel.font = [UIFont fontWithName:@"Arial" size:11.f];
    updateTimeLabel.textAlignment = NSTextAlignmentLeft;
    updateTimeLabel.text = [_explainContent objectForKey:@"更新时间："];
    [self.view addSubview:updateTimeLabel];
    UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, height + 55, 60, 20)];
    authorLabel.font = [UIFont fontWithName:@"Arial" size:11.f];
    authorLabel.textColor = [UIColor grayColor];
    authorLabel.textAlignment = NSTextAlignmentLeft;
    authorLabel.text = @"原著作者：";
    [self.view addSubview:authorLabel];
    UILabel *authorNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, height + 55, 100, 20)];
    authorNameLabel.font = [UIFont fontWithName:@"Arial" size:11.f];
    authorNameLabel.textAlignment = NSTextAlignmentLeft;
    authorNameLabel.text = [_explainContent objectForKey:@"原著作者："];
    [self.view addSubview:authorNameLabel];
    UILabel *moodsLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, height + 75, 60, 20)];
    moodsLabel.font = [UIFont fontWithName:@"Arial" size:11.f];
    moodsLabel.textAlignment = NSTextAlignmentLeft;
    moodsLabel.textColor = [UIColor grayColor];
    moodsLabel.text = @"人　　气：";
    [self.view addSubview:moodsLabel];
    UILabel *moodsNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, height+ 75, 80, 20)];
    moodsNumberLabel.font = [UIFont fontWithName:@"Arial" size:11.f];
    moodsNumberLabel.textAlignment = NSTextAlignmentLeft;
    moodsNumberLabel.text = [_explainContent objectForKey:@"人　　气："];
    [self.view addSubview:moodsNumberLabel];
    UILabel *joinLabel = [[UILabel alloc ] initWithFrame:CGRectMake(100, height + 95, 60, 20)];
    joinLabel.font = [UIFont fontWithName:@"Arial" size:11.f];
    joinLabel.textAlignment = NSTextAlignmentLeft;
    joinLabel.textColor = [ UIColor grayColor];
    joinLabel.text = @"加入时间：";
    [self.view addSubview:joinLabel];
    UILabel *joinTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, height + 95, 80, 20)];
    joinTimeLabel.font = [UIFont fontWithName:@"Arial" size:11.f];
    joinTimeLabel.textAlignment = NSTextAlignmentLeft;
    joinTimeLabel.text = [_explainContent objectForKey:@"加入时间："];
    [self.view addSubview:joinTimeLabel];
    UILabel *explainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, height + 115, 60, 20)];
    explainLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:11.f];
    explainLabel.textAlignment = NSTextAlignmentLeft;
    explainLabel.text = @"简介：";
    [self.view addSubview:explainLabel];
    UITextView *explainText = [[UITextView alloc] initWithFrame:CGRectMake(10, height+135, 300, 300)];
    explainText.editable = NO;
    explainText.font = [UIFont fontWithName:@"Arial" size:11.f];
    explainText.text = [_explainContent objectForKey:@"explain"];
    [self.view addSubview:explainText];
    [self.view addSubview:_tableView];
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
    static NSString *CellIdentifier = @"firstCell";
    FristCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FristCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.firstViewController = self;
        cell.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        cell.contentView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    }
        cell.titleLable.text = [_explainContent objectForKey:@"title"];
        cell.parameterArray = [_explainContent objectForKey:@"atlook"];

        return cell;
    
    }
    else if (indexPath.row == 1)
    {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
            cell.contentView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];

            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 40)];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.backgroundColor = [UIColor clearColor];
            [titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13.f]];
            titleLabel.text = @"章节显示";
            [cell.contentView addSubview:titleLabel];
            
            UILabel *foreshowLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 260, 40)];
            foreshowLabel.textAlignment = NSTextAlignmentRight;
            foreshowLabel.backgroundColor = [UIColor clearColor];
            [foreshowLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:11.f]];
            foreshowLabel.text = [_explainContent objectForKey:@"foreshow"];
            [cell.contentView addSubview:foreshowLabel];
        }
        return cell;
    }
    else
    {
        NSInteger indexRow = indexPath.row-2;
        static NSString *CellIdentifier = @"thirdCell";
        ThirdCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ThirdCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.firstViewController = self;
            cell.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
            cell.contentView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        }
        if (indexRow*4 + 1  >= _directorArray.count) {
            NSString *btn1 = [[_directorArray objectAtIndex:indexRow*4] objectForKey:@"title"];
            cell.btn1Dic = [_directorArray objectAtIndex:indexRow*4];
            [cell.btn1 setTitle:btn1 forState:UIControlStateNormal];
            cell.btn2.hidden = YES;
            cell.btn3.hidden = YES;
            cell.btn4.hidden = YES;
            cell.btn2Dic = nil;
            cell.btn3Dic = nil;
            cell.btn4Dic = nil;
        }else if (indexRow*4 + 2 >= _directorArray.count)
        {
            NSString *btn1 = [[_directorArray objectAtIndex:indexRow*4] objectForKey:@"title"];
            NSString *btn2 = [[_directorArray objectAtIndex:indexRow*4+1] objectForKey:@"title"];
            cell.btn1Dic = [_directorArray objectAtIndex:indexRow*4];
            cell.btn2Dic = [_directorArray objectAtIndex:indexRow*4+1];
            [cell.btn1 setTitle:btn1 forState:UIControlStateNormal];
            [cell.btn2 setTitle:btn2 forState:UIControlStateNormal];

            cell.btn3.hidden = YES;
            cell.btn4.hidden = YES;
            cell.btn3Dic = nil;
            cell.btn4Dic = nil;
        }
        else if (indexRow*4 + 3 >= _directorArray.count)
        {
            NSString *btn1 = [[_directorArray objectAtIndex:indexRow*4] objectForKey:@"title"];
            NSString *btn2 = [[_directorArray objectAtIndex:indexRow*4+1] objectForKey:@"title"];
            NSString *btn3 = [[_directorArray objectAtIndex:indexRow*4+2] objectForKey:@"title"];
            cell.btn1Dic = [_directorArray objectAtIndex:indexRow*4];
            cell.btn2Dic = [_directorArray objectAtIndex:indexRow*4+1];
            cell.btn3Dic = [_directorArray objectAtIndex:indexRow*4+2];
            [cell.btn1 setTitle:btn1 forState:UIControlStateNormal];
            [cell.btn2 setTitle:btn2 forState:UIControlStateNormal];
            [cell.btn3 setTitle:btn3 forState:UIControlStateNormal];

            cell.btn4.hidden = YES;
            cell.btn4Dic = nil;
        }
        else
        {
        NSString *btn1 = [[_directorArray objectAtIndex:indexRow*4] objectForKey:@"title"];
        NSString *btn2 = [[_directorArray objectAtIndex:indexRow*4+1] objectForKey:@"title"];
        NSString *btn3 = [[_directorArray objectAtIndex:indexRow*4+2] objectForKey:@"title"];
        NSString *btn4 = [[_directorArray objectAtIndex:indexRow*4+3] objectForKey:@"title"];
            cell.btn1Dic = [_directorArray objectAtIndex:indexRow*4];
            cell.btn2Dic = [_directorArray objectAtIndex:indexRow*4+1];
            cell.btn3Dic = [_directorArray objectAtIndex:indexRow*4+2];
            cell.btn4Dic =[_directorArray objectAtIndex:indexRow*4+3];
        [cell.btn1 setTitle:btn1 forState:UIControlStateNormal];
        [cell.btn2 setTitle:btn2 forState:UIControlStateNormal];
        [cell.btn3 setTitle:btn3 forState:UIControlStateNormal];
        [cell.btn4 setTitle:btn4 forState:UIControlStateNormal];
            cell.btn1.hidden = NO;
            cell.btn2.hidden = NO;
            cell.btn3.hidden = NO;
            cell.btn4.hidden = NO;

        }

        return cell;
    }
        
//    cell.contentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_directorArray.count%4) {
        return 2+_directorArray.count/4+1;
    }else
    return 2+_directorArray.count/4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 160.f;
    }
    else if (indexPath.row == 1)
    {
        return 40.f;
    }
    else
        return 50.f;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
