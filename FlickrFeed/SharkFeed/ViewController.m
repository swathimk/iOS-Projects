//
//  ViewController.m
//  SharkFeed
//
//  Created by Swathi Bhattiprolu on 1/3/19.
//  Copyright © 2019 Swathi Bhattiprolu. All rights reserved.
//

#import "ViewController.h"
#import "FlickrNetwork.h"
#import "FlickrImageCollectionViewCell.h"
#import "CoreDataStack.h"
#import "DetailViewController.h"

@interface ViewController (){
    CoreDataStack *stack;
    FlickrNetwork *flickrnetwork;
    NSUInteger fetchedDataCount;
    UIRefreshControl *refreshControl;
    BOOL prefetchFlag;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.sharkCollectionView.delegate = self;
    self.sharkArray = [[NSArray alloc] init];
    
    UIView *pullToRefreshView = [[[NSBundle mainBundle] loadNibNamed:@"PullToRefresh" owner:self options:nil] lastObject];
    refreshControl = [[UIRefreshControl alloc] init];
    CGRect frame = refreshControl.bounds;
    frame.size.height = 180;
    pullToRefreshView.frame = frame;
    [refreshControl addSubview:pullToRefreshView];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [self.sharkCollectionView addSubview:refreshControl];
    
    stack = [[CoreDataStack alloc] init];
    [stack setupManagedObjectContext];
    //[stack removeAllObjects];
    
    
    flickrnetwork = [[FlickrNetwork alloc] init];
    flickrnetwork.pageNumber = [stack getPageNumber];
    
    if (flickrnetwork.pageNumber > 0) {
        prefetchFlag = YES;
        self.sharkArray = [stack fetchResults];
        stack.sharkArray = self.sharkArray;
        fetchedDataCount = self.sharkArray.count;
        [self.sharkCollectionView reloadData];
    } else {
        [self fetchSharkData:1];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fetchSharkData : (int) pagenumber
{
    prefetchFlag = NO;
    [flickrnetwork getFlickrImages:pagenumber withCompletionBlock:^(NSDictionary *data){
        self.sharkData = data;
        NSUInteger imageCount = [(NSArray *)[[self.sharkData valueForKey:@"photos"] valueForKey:@"photo"] count];
        for(int i = 0; i < imageCount; i++){
            NSString *imageURL = [[[[self.sharkData valueForKey:@"photos"] valueForKey:@"photo"] objectAtIndex:i] valueForKey:@"url_t"];
            NSString *imageURLHQ = [[[[self.sharkData valueForKey:@"photos"] valueForKey:@"photo"] objectAtIndex:i] valueForKey:@"url_l"];
            NSString *imageURLO = [[[[self.sharkData valueForKey:@"photos"] valueForKey:@"photo"] objectAtIndex:i] valueForKey:@"url_o"];
            NSString *photoid = [[[[self.sharkData valueForKey:@"photos"] valueForKey:@"photo"] objectAtIndex:i] valueForKey:@"id"];
            NSUInteger indexValue = self->fetchedDataCount + i;
            [self->stack saveImageWithURL:imageURL andData:nil atIndex:[NSNumber numberWithInteger:indexValue] withPageNumber:[NSNumber numberWithInt:pagenumber] highQualityImageURL:imageURLHQ originalImageURL:imageURLO andID:photoid];
        }
        self->flickrnetwork.pageNumber = pagenumber;
        self.sharkArray = [self->stack fetchResults];
        self->stack.sharkArray = self.sharkArray;
        self->fetchedDataCount = self.sharkArray.count;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.sharkCollectionView reloadData];
            [self->refreshControl endRefreshing];
        });
    }];
}

- (void) refreshData {
   // self.sharkArray = nil;
   // [self.sharkCollectionView reloadData];
   // [refreshControl endRefreshing];
    [stack removeAllObjects];
    [self fetchSharkData:1];
}

#pragma UICollectionViewDataSource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(120, 120);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (screenSize.width == 414)
            size = CGSizeMake(120, 120);
        else
            size = CGSizeMake(105, 105);
    }
    return size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.sharkArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"sharkImage";
    FlickrImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(!prefetchFlag) {
        [cell.activityIndicator startAnimating];
    }
    
    if([self->stack.sharkArray[indexPath.item] valueForKey:@"imageData"]){
        cell.sharkImageView.image = [UIImage imageWithData:[self->stack.sharkArray[indexPath.item] valueForKey:@"imageData"]];
        [cell.activityIndicator stopAnimating];
    } else {
        NSUInteger indexValue = indexPath.item;
        [cell downloadImage:[self->stack.sharkArray[indexPath.item] valueForKey:@"imageURL"] atIndex:indexValue andStack:stack withCompletionBlock:^(NSData *imageData){
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.sharkImageView.image = [UIImage imageWithData:imageData];
            });
            
        }];
    }
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
        if(self.sharkArray.count > 0 && indexPath.item == fetchedDataCount-1){
            [self fetchSharkData:flickrnetwork.pageNumber+1];
        }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *selectedPhoto = [stack getPhotoIDAtIndex:indexPath.item];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *detailVC = [sb instantiateViewControllerWithIdentifier:@"DetailViewController"];
    detailVC.selectedPhoto = selectedPhoto;
    detailVC.isSavedImage = stack.isSavedImage;
    [self presentViewController:detailVC animated:YES completion:nil];
    
}



@end
