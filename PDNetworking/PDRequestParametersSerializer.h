#import <Foundation/Foundation.h>


@protocol PDRequestParametersSerializer <NSObject>

- (id)serialize:(id)requestParameters error:(NSError * __autoreleasing *)error;

@end
