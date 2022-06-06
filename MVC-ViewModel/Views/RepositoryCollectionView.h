//
//  RepositoryCollectionView.h
//  MVC-ViewModel
//
//  Created by WeiHan on 2022/6/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RepositoryViewProtocol <NSObject>

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *subtitle;
@property (nonatomic, assign) BOOL visited;
@property (nonatomic, copy, readonly) void (^ onRepositoryTapped)(void);

@end

@interface RepositoryCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray<id<RepositoryViewProtocol> > *dataItems;

@property (nonatomic, copy) void (^ didScrollToEnd)(void);

@end

NS_ASSUME_NONNULL_END
