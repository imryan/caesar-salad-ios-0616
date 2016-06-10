//
//  FISCaesarCipher.m
//  CaesarCipher
//
//  Created by Chris Gonzales on 5/29/14.
//  Copyright (c) 2014 FIS. All rights reserved.
//

#import "FISCaesarCipher.h"

#define ASCII_TOTAL 26

#define LOWERCASE_MIN 97
#define LOWERCASE_MAX 123

#define UPPERCASE_MIN 65
#define UPPERCASE_MAX 91

@implementation FISCaesarCipher

- (BOOL)isPunctuation:(unichar)character {
    BOOL isPunctuation = NO;
    NSString *characterString = [NSString stringWithFormat:@"%c", character];
    
    if ([characterString rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet] options:NSCaseInsensitiveSearch].location == NSNotFound) {
        isPunctuation = YES;
    }
    
    return isPunctuation;
}

- (NSString *)encodeMessage:(NSString *)message withOffset:(NSInteger)key {
    NSMutableString *mutableEncodedString = [NSMutableString string];
    
    for (NSUInteger i = 0; i < [message length]; i++) {
        unichar character = [message characterAtIndex:i];
        
        if (key % ASCII_TOTAL == 0) {
            [mutableEncodedString appendString:[NSString stringWithFormat:@"%c", character]];
            break;
        }
        
        if (key > ASCII_TOTAL) {
            key %= ASCII_TOTAL;
        }
        
        if (character == 'z') {
            character = 'a' + (key - 1);
        } else if (character == 'Z') {
            character = 'A' + (key - 1);
        } else {
            if (![self isPunctuation:character]) {
                character += key;
                
                if (character > 122) {
                    character -= ASCII_TOTAL;
                }
            }
        }
        
        [mutableEncodedString appendString:[NSString stringWithFormat:@"%c", character]];
    }
    
    NSString *encodedString = [mutableEncodedString stringByReplacingOccurrencesOfString:@"#" withString:@" "];
    
    return encodedString;
}

- (NSString *)decodeMessage:(NSString *)encodedMessage withOffset:(NSInteger)key {
    NSMutableString *mutableDecodedString = [NSMutableString string];
    
    for (NSUInteger i = 0; i < [encodedMessage length]; i++) {
        unichar character = [encodedMessage characterAtIndex:i];
        
        if (key % ASCII_TOTAL == 0) {
            [mutableDecodedString appendString:[NSString stringWithFormat:@"%c", character]];
            break;
        }
        
        if (key > ASCII_TOTAL) {
            key %= ASCII_TOTAL;
        }
        
        if (![self isPunctuation:character]) {
            NSString *characterString = [NSString stringWithFormat:@"%c", character];
            unichar charKeyDiff = character - key;
            
            if ([characterString isEqualToString:characterString.uppercaseString]) {
                if (charKeyDiff >= UPPERCASE_MIN) {
                    character -= key;
                } else {
                    int difference = (character - UPPERCASE_MIN);
                    character = UPPERCASE_MAX - (key - difference);
                }
            } else {
                if (charKeyDiff >= LOWERCASE_MIN) {
                    character -= key;
                } else {
                    int difference = (character - LOWERCASE_MIN);
                    character = LOWERCASE_MAX - (key - difference);
                }
            }
        }
        
        [mutableDecodedString appendString:[NSString stringWithFormat:@"%c", character]];
    }
    
    NSString *decodedString = [NSString stringWithString:mutableDecodedString];
    
    return decodedString;
}

@end
