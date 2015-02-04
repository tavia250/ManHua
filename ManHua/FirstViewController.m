//
//  FirstViewController.m
//  ManHua
//
//  Created by jason on 14-3-5.
//  Copyright (c) 2014年 jason. All rights reserved.
//

#import "FirstViewController.h"
#import "FristCustomCell.h"
#import "Fileprocessing.h"
#define TOPSCROLL_HEIGHT 120.0f
@interface FirstViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UIScrollView *topScrollView;
@property (nonatomic, strong)NSMutableArray *topArray;
@property (nonatomic, strong)NSMutableArray *tabArray;
@property (nonatomic, assign)CGFloat topContentx;
@property (nonatomic, strong)NSMutableArray *scrollArray;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];

    self.title = @"精品推荐";
    self.scrollArray = [NSMutableArray array];
    self.topArray = [NSMutableArray array];
    self.tabArray = [NSMutableArray array];
    [self startLoad];
	   
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)viewDidDisappear:(BOOL)animated{
    self.hidesBottomBarWhenPushed = NO;
    [super viewDidDisappear:animated];
}
- (void)startLoad
{
    
         static NSString *url  = @"http://www.jide123.com";
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
            [NSURLConnection sendAsynchronousRequest:request queue:[Fileprocessing sharedOperationQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                
                if (!connectionError) {
                    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
                    NSString *html=[[NSString alloc]initWithData:data encoding:enc];
                    NSString *utf8HtmlStr = [html stringByReplacingOccurrencesOfString:@"gb2312"
                                                                            withString:@"utf-8"];
                    
                    NSData *htmlDataUTF8 = [utf8HtmlStr dataUsingEncoding:NSUTF8StringEncoding];
                    
                    
                    [self ergodicHtml:htmlDataUTF8];
                    NSLog(@"%@",[NSThread currentThread]);
  
                }else
                {
                    
                    NSLog(@"%@",connectionError);
 
                    
                }

                
            }];
}


- (void)ergodicHtml:(NSData *)htmlDataUTF8
{
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlDataUTF8];

    
    NSArray *topelements = [xpathParser searchWithXPathQuery:@"//div[@class='icmd']/div[@id='icmd_tab'][@class='bar cmd_tab icmd_tab']/ul/li/span/strong"];
    for (TFHppleElement *element in topelements) {
        [_topArray addObject:[element text]];
    }
    NSArray *contentelements = [xpathParser searchWithXPathQuery:@"//div[@class='icmd']/div[@id='icmd_list'][@class='cmd_list']/ul"];
    
    
    for (TFHppleElement *element in contentelements) {

       [_tabArray addObject: [self attributeArray:element]];
    }
    
     dispatch_async(dispatch_get_main_queue(), ^{
    [_activityIndicatorView stopAnimating];
    [self startLoadView];
//         NSLog(@"%@",_tabArray);
          }) ;
    
}

- (NSMutableArray *)attributeArray:(TFHppleElement *)element
{
    NSURL *url  = [NSURL URLWithString:@"http://www.jide123.com"];
       NSMutableArray *contentArray = [NSMutableArray array];
        for (TFHppleElement *elementArray in [element children]) {
            NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
            if ([elementArray hasChildren]) {
                NSString *title = [[[[elementArray children] objectAtIndex:3] firstChild] content];
                [contentDic setObject:title forKey:@"title"];
                
                NSString *newest = [[[[[[[elementArray children] objectAtIndex:1] children] objectAtIndex:1] firstChild] firstChildWithTagName:@"text"] content];
                [contentDic setObject:newest forKey:@"newest"];
                
                NSString *xiaotuUrl = [[[[[[elementArray children] objectAtIndex:1] firstChild] firstChild] attributes] objectForKey:@"_src"];
                if (![xiaotuUrl hasPrefix:@"http://cartoon.jide123.cc"]) {
                    xiaotuUrl = [[[[[[elementArray children] objectAtIndex:1] firstChild] firstChild] attributes] objectForKey:@"src"];
                }
                [contentDic setObject:xiaotuUrl forKey:@"xiaotuUrl"];
                
                NSString *contentUrl = [[[[[elementArray children] objectAtIndex:1] firstChild] attributes] objectForKey:@"href"];
                [contentDic setObject:[[NSURL URLWithString:contentUrl relativeToURL:url] absoluteString]
 forKey:@"contentUrl"];
                
                NSString *newestUrl = [[[[[[[elementArray children] objectAtIndex:1] children] objectAtIndex:1] firstChild] attributes] objectForKey:@"href"];
                [contentDic setObject: [[NSURL URLWithString:newestUrl relativeToURL:url] absoluteString]
 forKey:@"newestUrl"];
                
                [contentArray addObject:contentDic];

            }
        }
    return contentArray;
}

- (void)startLoadView
{
    NSArray *urlArray = [NSArray arrayWithObjects:@"http://ugc.qpic.cn/manhua_cover/0/23_12_06_b11bb59c85a44626b52e82527d6701cb.jpg/0",@"http://ugc.qpic.cn/manhua_cover/0/23_12_07_207cacd8020fe40a40c29b5b40ddbba8.jpg/0",@"http://ugc.qpic.cn/manhua_cover/0/23_12_06_a59631a77aed15699215e271153ba011.jpg/0", nil];
    CGRect tableViewRect = self.view.bounds;
    CGRect navBarRect = self.navigationController.navigationBar.bounds;
    CGRect tabBarRect = self.tabBarController.tabBar.bounds;
    _tableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) // iOS 7+
	{
		if ([self prefersStatusBarHidden] == NO) // Visible status bar
		{
            self.tableView.contentInset = UIEdgeInsetsMake(TOPSCROLL_HEIGHT+navBarRect.size.height + 20.f,0,tabBarRect.size.height,0);
            self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(navBarRect.size.height + 20.f,0,tabBarRect.size.height,0);
        }
    }
    else
    {
        self.tableView.contentInset = UIEdgeInsetsMake(TOPSCROLL_HEIGHT,0,0,0);
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0 ,0,navBarRect.size.height + tabBarRect.size.height,0);
    }
    [self.view addSubview:_tableView];
    
    self.topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,-TOPSCROLL_HEIGHT, tableViewRect.size.width, TOPSCROLL_HEIGHT)];
    _topScrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.topScrollView.backgroundColor = [UIColor whiteColor];
    self.topScrollView.contentSize = CGSizeMake(tabBarRect.size.width*3, TOPSCROLL_HEIGHT);
    self.topScrollView.pagingEnabled = YES;
    self.topScrollView.showsVerticalScrollIndicator = NO;
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    self.topScrollView.bounces = NO;
    self.topScrollView.delegate = self;
    for (int i = 0; i< 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(tabBarRect.size.width * i, 0, tabBarRect.size.width, TOPSCROLL_HEIGHT)];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
        [_scrollArray addObject:imageView];
        
        [imageView setImageWithURL:[NSURL URLWithString:[urlArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"back"]];
        [self.topScrollView addSubview:imageView];
    }
    
    self.topScrollView.contentOffset = CGPointMake(navBarRect.size.width, 0);
    [self.tableView addSubview:_topScrollView];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
   static NSString *CellIdentifier = @"firstCell";
    FristCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FristCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.firstViewController = self;

    }
    cell.titleLable.text = [_topArray objectAtIndex:indexPath.row];
    cell.parameterArray = [_tabArray objectAtIndex:indexPath.row];
    return cell;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [_topArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

#pragma mark scrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _topScrollView) {
        _topContentx = scrollView.contentOffset.x;

        if (_topContentx == 0 || _topContentx == 2 * scrollView.frame.size.width) {
            
            if (_topContentx == 0) {
                
                [_scrollArray exchangeObjectAtIndex:0 withObjectAtIndex:1];
            }else
            {
                [_scrollArray exchangeObjectAtIndex:2 withObjectAtIndex:1];
            }
            [_scrollArray exchangeObjectAtIndex:0 withObjectAtIndex:2];
            
            CGRect tabBarRect = self.tabBarController.tabBar.bounds;
            int i =0;
            for (UIImageView *imageView in _scrollArray) {
                
                imageView.frame = CGRectMake(tabBarRect.size.width * i, 0, tabBarRect.size.width, TOPSCROLL_HEIGHT);
                i++;
            }
            
            [scrollView  scrollRectToVisible:CGRectMake(scrollView.bounds.size.width, 0,scrollView.bounds.size.width , scrollView.bounds.size.height) animated:NO];
            
        }
    }
    
    if (scrollView == _tableView) {
        
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        if (scrollView.contentOffset.y < -(TOPSCROLL_HEIGHT + 64.f)) {
        self.topScrollView.frame = CGRectMake(0.f, scrollView.contentOffset.y+64.f, self.view.bounds.size.width, TOPSCROLL_HEIGHT);
   
        }
    }
    else
        
    if (scrollView.contentOffset.y < -TOPSCROLL_HEIGHT) {
        self.topScrollView.frame = CGRectMake(0.f, scrollView.contentOffset.y, self.view.bounds.size.width, TOPSCROLL_HEIGHT);
    }
    }

}

@end
