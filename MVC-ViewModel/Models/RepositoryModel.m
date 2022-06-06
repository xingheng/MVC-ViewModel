//
//  RepositoryModel.m
//  MVC-ViewModel
//
//  Created by WeiHan on 2022/6/6.
//

#import <AFHTTPSessionManager.h>
#import "RepositoryModel.h"

@implementation RepositoryModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
        @"ID": @"id",
        @"descriptions": @"description",
        @"isPrivate": @"private",
    }];
}

@end

@implementation RepositoryModel (Networking)

+ (void)fetchStarredRepository:(NSString *)user
                          page:(NSUInteger)pageIndex
                         count:(NSUInteger)pageCount
                    completion:(void (^)(NSArray<RepositoryModel *> *repositories, NSError *error))completion
{
    NSURL *baseURL = [NSURL URLWithString:@"https://api.github.com"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    NSDictionary *params = @{
        @"page": @(pageIndex),
        @"per_page": @(pageCount),
    };

    [manager GET:[NSString stringWithFormat:@"/users/%@/starred", user]
      parameters:params
         headers:nil
        progress:nil
         success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        NSError *err = nil;
        NSArray<RepositoryModel *> *items = [RepositoryModel arrayOfModelsFromDictionaries:responseObject error:&err];
        !completion ? : completion(items, task.error ? : err);
    }
         failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        !completion ? : completion(nil, error);
    }];
}

@end
