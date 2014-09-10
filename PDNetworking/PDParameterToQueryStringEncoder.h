#import <Foundation/Foundation.h>


@interface QueryStringPair : NSObject

@property (nonatomic, strong) id field;
@property (nonatomic, strong) id value;

- (id)initWithField:(id)field value:(id)value;
- (NSString *)URLEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding;

@end


@interface PDParameterToQueryStringEncoder : NSObject

- (id)initWithStringEncoding:(NSStringEncoding)stringEncoding;

- (NSString *)encodedQueryStringWithParams:(NSDictionary *)dictionary;
- (NSArray *)encodedKeyValuePairsWithParams:(NSDictionary *)dictionary;

@end
