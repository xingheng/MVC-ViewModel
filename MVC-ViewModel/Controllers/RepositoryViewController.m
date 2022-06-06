//
//  RepositoryViewController.m
//  MVC-ViewModel
//
//  Created by WeiHan on 2022/6/6.
//

#import <SafariServices/SafariServices.h>
#import "RepositoryViewController.h"
#import "RepositoryCollectionView.h"
#import "RepositoryModel.h"
#import "RepositoryViewModel.h"

@interface RepositoryViewController ()

@property (nonatomic, strong) RepositoryCollectionView *collectionView;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) NSMutableArray<RepositoryModel *> *allRepos;

@property (nonatomic, assign) NSUInteger pageIndex;

@end

@implementation RepositoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    RepositoryCollectionView *collectionView = [RepositoryCollectionView new];
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    UIActivityIndicatorView *indicatorView = [UIActivityIndicatorView new];
    typeof(self) __weak weakSelf = self;

    collectionView.didScrollToEnd = ^{
        typeof(self) __strong self = weakSelf;
        [self fetchRepositories:NO];
    };
    collectionView.refreshControl = refreshControl;

    [refreshControl addTarget:self action:@selector(didRefreshControlChanged:) forControlEvents:UIControlEventValueChanged];

    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleLarge;

    self.collectionView = collectionView;
    self.indicatorView = indicatorView;
    self.allRepos = [NSMutableArray new];

    [self.view addSubview:collectionView];
    [self.view addSubview:indicatorView];

    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (self.allRepos.count <= 0) {
        [self fetchRepositories:YES];
    }
}

- (void)fetchRepositories:(BOOL)initial
{
    NSString *strUser = [NSUserDefaults.standardUserDefaults objectForKey:@"GithubUser"];

    if (strUser.length <= 0) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"A github user is required" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.tabBarController.selectedIndex = 1;
        }];

        [alertVC addAction:action];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }

    if (initial) {
        self.pageIndex = 1;
    } else {
        self.pageIndex += 1;
    }

    NSLog(@"Fetching page %ld", self.pageIndex);
    [self.indicatorView startAnimating];

    [RepositoryModel fetchStarredRepository:strUser
                                       page:0
                                      count:30
                                 completion:^(NSArray<RepositoryModel *> *_Nonnull repositories, NSError *_Nonnull error) {
        if (initial) {
            [self.collectionView.refreshControl endRefreshing];
            [self.allRepos removeAllObjects];
        }

        NSLog(@"Fetched %ld repositories in page %ld", repositories.count, self.pageIndex);
        [self.indicatorView stopAnimating];
        [self.allRepos addObjectsFromArray:repositories];

        self.collectionView.dataItems = [RepositoryViewModel dataItemsWithRepositoryModels:self.allRepos block:^(RepositoryModel * _Nonnull source, RepositoryViewModel * _Nonnull data) {
            data.onRepositoryTapped = ^{
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://github.com/%@", source.full_name]];
                SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
                [self presentViewController:safariVC animated:YES completion:nil];
            };
        }];
    }];
}

- (void)didRefreshControlChanged:(id)sender
{
    [self fetchRepositories:YES];
}

@end
