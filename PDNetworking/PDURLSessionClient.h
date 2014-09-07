#import <Foundation/Foundation.h>
#import "PDRequester.h"


@protocol PDURLSessionClientDelegate;


@interface PDURLSessionClient : NSObject <PDRequester>

@property (weak, nonatomic) id <PDURLSessionClientDelegate> delegate;

- (instancetype)init __attribute__((unavailable("Please use initWithURLSession: when initializing PDURLSessionClient")));

- (instancetype)initWithURLSession:(NSURLSession *)URLSession;

@end
