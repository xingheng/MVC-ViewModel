//
//  RepositoryModel.h
//  MVC-ViewModel
//
//  Created by WeiHan on 2022/6/6.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface RepositoryModel : JSONModel

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *full_name;
@property (nonatomic, strong) NSString *default_branch;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *updated_at;
@property (nonatomic, strong) NSString<Optional> *descriptions;
@property (nonatomic, strong) NSString<Optional> *homepage;
@property (nonatomic, strong) NSString<Optional> *language;
@property (nonatomic, strong) NSArray<NSString *> *topics;
@property (nonatomic, assign) NSUInteger forks_count;
@property (nonatomic, assign) NSUInteger stargazers_count;
@property (nonatomic, assign) NSUInteger watchers_count;
@property (nonatomic, assign) BOOL isPrivate;

@end


@interface RepositoryModel (Networking)

+ (void)fetchStarredRepository:(NSString *)user
                          page:(NSUInteger)pageIndex
                         count:(NSUInteger)pageCount
                    completion:(void (^)(NSArray<RepositoryModel *> *repositories, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
