//
//  RepositoryCollectionView.m
//  MVC-ViewModel
//
//  Created by WeiHan on 2022/6/6.
//

#import "RepositoryCollectionView.h"

#pragma mark - RepositoryCollectionViewCell

#define CellID @"RepositoryCollectionViewCell"

@interface RepositoryCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblSubtitle;

@property (nonatomic, strong) id<RepositoryViewProtocol> data;

@end

@implementation RepositoryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView *containerView = [UIView new];
        UILabel *lblTitle = [UILabel new];
        UILabel *lblSubtitle = [UILabel new];

        containerView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.1];

        lblTitle.numberOfLines = 0;
        lblTitle.font = [UIFont boldSystemFontOfSize:20];
        lblTitle.textColor = UIColor.blackColor;

        lblSubtitle.numberOfLines = 0;
        lblSubtitle.font = [UIFont systemFontOfSize:14];
        lblSubtitle.textColor = UIColor.grayColor;

        self.lblTitle = lblTitle;
        self.lblSubtitle = lblSubtitle;

        [self.contentView addSubview:containerView];
        [containerView addSubview:lblTitle];
        [containerView addSubview:lblSubtitle];

        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).priorityHigh();
            make.top.equalTo(lblTitle).offset(-10);
            make.bottom.equalTo(lblSubtitle).offset(10);
            make.width.equalTo(@(CGRectGetWidth(UIScreen.mainScreen.bounds)));
        }];

        [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.width.equalTo(containerView).offset(-20);
            make.centerX.equalTo(containerView);
            make.height.greaterThanOrEqualTo(@30);
        }];

        [lblSubtitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lblTitle.bottom).offset(10);
            make.width.centerX.equalTo(lblTitle);
            make.bottom.equalTo(containerView).offset(-10);
        }];
    }

    return self;
}

#pragma mark - Property

- (void)setData:(id<RepositoryViewProtocol>)data
{
    _data = data;

    self.lblTitle.text = data.title;
    self.lblSubtitle.text = data.subtitle;
    self.lblTitle.textColor = data.visited ? [UIColor.blackColor colorWithAlphaComponent:0.5] : UIColor.blackColor;
}

@end

#pragma mark - RepositoryCollectionView

@implementation RepositoryCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];

    flowLayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;

    if (self = [super initWithFrame:frame collectionViewLayout:flowLayout]) {
        self.dataSource = self;
        self.delegate = self;

        [self registerClass:RepositoryCollectionViewCell.class forCellWithReuseIdentifier:CellID];
    }

    return self;
}

#pragma mark - Property

- (void)setDataItems:(NSArray<id<RepositoryViewProtocol> > *)dataItems
{
    _dataItems = dataItems;
    [self reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataItems.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RepositoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];

    cell.data = self.dataItems[indexPath.row];

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RepositoryCollectionViewCell *cell = (RepositoryCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    id<RepositoryViewProtocol> data = self.dataItems[indexPath.row];

    data.visited = YES;
    cell.data = data;

    !data.onRepositoryTapped ? : data.onRepositoryTapped();
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat offsetY = (*targetContentOffset).y;

    if (offsetY > scrollView.contentSize.height - CGRectGetHeight(scrollView.bounds) - 100) {
        !self.didScrollToEnd ? : self.didScrollToEnd();
    }
}

@end
