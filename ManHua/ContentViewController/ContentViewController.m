//
//  ContentViewController.m
//  ManHua
//
//  Created by jason on 14-6-27.
//  Copyright (c) 2014年 jason. All rights reserved.
//

#import "ContentViewController.h"
#import "GTMBase64.h"
#import "FourthCustomCell.h"
@interface ContentViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    CGFloat tablecellHeight;

}
@end

@implementation ContentViewController

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
    NSLog(@"%@",[NSThread currentThread]);

    [super viewDidLoad];
//    NSLog(@"%@",_allcontentArray);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)];
    self.contentArray = [NSMutableArray array];
    self.heightArray = [NSMutableArray array];
    self.imageArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.scrollEnabled = NO;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];

    _loadprogressView = [[LoadprogressView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_loadprogressView];
    [_loadprogressView  startgif];
    
    
    
    
    _topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _topButton.frame = CGRectMake(0, -40.f, self.tableView.bounds.size.width, 40.f);
    [_topButton addTarget:self action:@selector(startLoadUp) forControlEvents:UIControlEventTouchUpInside];
    _topButton.backgroundColor = [UIColor blackColor];
    [_topButton setTitle:@"点击加载上一话" forState:UIControlStateNormal];
    [_tableView addSubview:_topButton];
    
    _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _bottomButton.frame = CGRectMake(0, _tableView.contentSize.height, _tableView.bounds.size.width, 40.f);
    [_bottomButton addTarget:self action:@selector(startLoadNext) forControlEvents:UIControlEventTouchUpInside];
    _bottomButton.backgroundColor = [UIColor blackColor];
    [_bottomButton setTitle:@"点击加载下一话" forState:UIControlStateNormal];
    [_tableView addSubview:_bottomButton];
    
    
//    [self addFooter];
    _operationQueue = [[NSOperationQueue alloc] init];

    // Do any additional setup after loading the view.
}

- (void)startLoadUp
{
 
    if ([_allcontentArray containsObject:_contentDic]) {
        NSUInteger count = [_allcontentArray indexOfObject:_contentDic];
        if (count < _allcontentArray.count -1 ) {
            _tableView.scrollEnabled = NO;
            _contentDic = [_allcontentArray objectAtIndex:count+1];
            NSString *title = [NSString stringWithFormat:@"正在加载%@...",[_contentDic objectForKey:@"title"]];
            [_topButton setTitle:title forState:UIControlStateSelected];
            _topButton.selected = YES;
            [_contentArray removeAllObjects];
            [self startLoadData];
        }
        else
            return;
    }
    
}

- (void)startLoadNext
{
    if ([_allcontentArray containsObject:_contentDic]) {
        NSUInteger count = [_allcontentArray indexOfObject:_contentDic];
        if (count) {
            _tableView.scrollEnabled = NO;
            _contentDic = [_allcontentArray objectAtIndex:count - 1];
            NSString *title = [NSString stringWithFormat:@"正在加载%@...",[_contentDic objectForKey:@"title"]];
            [_bottomButton setTitle:title forState:UIControlStateSelected];
            _bottomButton.selected = YES;
            [_contentArray removeAllObjects];

            [self startLoadData];
        }
        else
            return;
    }

    
}


- (void)viewDidAppear:(BOOL)animated
{
    [self startLoadData];
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    
    [_operationQueue cancelAllOperations];
    [super viewWillDisappear:animated];
}

- (void)startLoadData
{
    if (!_tableView.isScrollEnabled) {
        if (_contentArray.count > 0) {
            [self startLoadImage];
        }else
            
            [self startLoadHtml];
        

    }
  
}

- (void)refreshData
{
    [_operationQueue cancelAllOperations];
    [self startLoadData];

}

- (void)startLoadHtml
{

    [_contentArray removeAllObjects];
    
    NSString *url = [_contentDic objectForKey:@"contentUrl"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[Fileprocessing sharedOperationQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (!connectionError) {
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
            NSString *html=[[NSString alloc]initWithData:data encoding:enc];
            
            NSString *utf8HtmlStr = [html stringByReplacingOccurrencesOfString:@"gb2312"
                                                                    withString:@"utf-8"];
            
            NSData *htmlDataUTF8 = [utf8HtmlStr dataUsingEncoding:NSUTF8StringEncoding];
            
            
            [self ergodicHtml:htmlDataUTF8];
            
        }else
        {
            
            NSLog(@"%@",connectionError);
            
            
        }
        
        
    }];
  
}

- (void)ergodicHtml:(NSData *)htmlDataUTF8
{
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlDataUTF8];
    
    
    NSArray *topelements = [xpathParser searchWithXPathQuery:@"//script"];
    
    NSString *url = [[[topelements firstObject] firstChild] content];
    
    NSString *content = [self getParamValueFromUrl:url paramName:@"var qTcms_S_m_murl_e=\""];
    
    NSString *click_url = [GTMBase64 stringByBase64String:content];

   [_contentArray addObjectsFromArray: [click_url componentsSeparatedByString:@"$qingtiandy$"]];
    [self startLoadImage];
}

- (void)startLoadImage
{
    [_operationQueue cancelAllOperations];
    [_heightArray removeAllObjects];
    [_imageArray removeAllObjects];
    _loadprogressView.progressView.progress = 0.f;
    NSMutableArray *countArray = [NSMutableArray array];
    NSLog(@"%@",_contentArray);
    for (int i = 0; i < _contentArray.count; i++) {
        [_heightArray addObject:[NSNumber numberWithFloat:200]];
        [_imageArray addObject:UIImagePNGRepresentation([UIImage imageNamed:@"back"])];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[_contentArray objectAtIndex:i]]];
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [countArray addObject:[NSNumber numberWithInt:i]];
            UIImage *image = [UIImage imageWithData:responseObject];
            CGFloat width = CGImageGetWidth(image.CGImage);
            CGFloat height = CGImageGetHeight(image.CGImage);
            CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(20, 20, width-40.f, height-40.f));
            UIImage *newImage = [UIImage imageWithCGImage:imageRef];
            CGSize imagesize = CGSizeMake(CGImageGetWidth(image.CGImage), CGImageGetHeight(image.CGImage));
            imagesize.height = self.tableView.bounds.size.width / imagesize.width * imagesize.height * 2.f;
            imagesize.width =self.tableView.bounds.size.width * 2.f;
            newImage = [self imageWithImage:newImage scaledToSize:imagesize];
            NSData *imageData = UIImageJPEGRepresentation(newImage, 0.0001);
            CGImageRelease(imageRef);
            NSLog(@"%d",i);
            if (imageData) {
                [_imageArray replaceObjectAtIndex:i withObject:imageData];
                [_heightArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:imagesize.height/2.f]];
            }
            
            if (_operationQueue.operationCount == 0 && countArray.count == _contentArray.count) {
                _topButton.selected = NO;
                _bottomButton.selected = NO;
                if (!_loadprogressView.isHidden) {
                _loadprogressView.hidden = YES;
                }
                self.title = [_contentDic objectForKey:@"title"];

                [_tableView reloadData];
                CGFloat height = -0.f ;
                CGFloat top = 40.f;
                CGFloat bottom = 40.f;
                CGRect navBarRect = self.navigationController.navigationBar.bounds;
                if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) // iOS 7+
                {
                    height = - (navBarRect.size.height + 20.f);
                    top = 40.f + navBarRect.size.height + 20.f;
                }

                if ([_allcontentArray containsObject:_contentDic]) {
                    NSUInteger count = [_allcontentArray indexOfObject:_contentDic];
                    if (count == 0) {
                        _bottomButton.hidden = YES;
                        bottom = 0.f;
                    }else
                    {
                        _bottomButton.frame = CGRectMake(0, _tableView.contentSize.height, _tableView.bounds.size.width, 40.f);
                        _bottomButton.hidden = NO;
                    }
                    if (count == _allcontentArray.count -1)
                    {
                        _topButton.hidden = YES;
                        top -= 40.f;
                    }else
                        _topButton.hidden = NO;
                   
                    self.tableView.contentInset = UIEdgeInsetsMake(top,0,bottom,0);

                }

                [self.tableView setContentOffset:CGPointMake(0,height) animated:NO];
                _tableView.scrollEnabled = YES;
                
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"%@",error);
        }];
        if (!_loadprogressView.isHidden) {
            [_loadprogressView.progressView setProgressWithDownloadProgressOfOperationQueue:operation count:_contentArray.count animated:YES];
        }

        [_operationQueue addOperation:operation];

    }
  
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
- (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName
{
    
    NSString * str = nil;
    NSRange start = [url rangeOfString:paramName];
    if (start.location != NSNotFound)
    {
        // confirm that the parameter is not a partial name match
        unichar c = '?';
        if (start.location != 0)
        {
            c = [url characterAtIndex:start.location - 1];
        }
        if (c == '?' || c == '&' || c == '#' || c == ';')
        {
            NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"\""];
            NSUInteger offset = start.location+start.length;
            str = end.location == NSNotFound ?
            [url substringFromIndex:offset] :
            [url substringWithRange:NSMakeRange(offset, end.location)];
            str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return str;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return [[_heightArray objectAtIndex:indexPath.row] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *CellIdentifier = @"fourthCell";
    FourthCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FourthCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    CGFloat height = [[_heightArray objectAtIndex:indexPath.row] floatValue];

    [cell setContentImageFrame:CGRectMake(0, 0, self.view.bounds.size.width, height)];
  cell.contentImage.image = [UIImage imageWithData:[_imageArray objectAtIndex:indexPath.row]];
   // cell.contentImage.image = [_imageArray objectAtIndex:indexPath.row];

    return cell;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return [_imageArray count];
}




//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    self.navigationController.navigationBar.hidden = self.navigationController.navigationBar.isHidden ? NO : YES;
//}



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
