#import <Foundation/Foundation.h>


@class PDDomainObjectClient;
@protocol PDNetworkResource;


@interface PDNetworkClientProvider : NSObject

- (id)networkClientWithNetworkResource:(id<PDNetworkResource>)networkResource
                    domainObjectClient:(PDDomainObjectClient *)domainObjectClient;

@end
