#import "TRPConstants.h"
#include <stdint.h>
#include <stdlib.h>
#import <Foundation/Foundation.h>


const uint8_t SPOTIFY_APP_KEY[] = {
	0x01, 0x90, 0x55, 0x29, 0x73, 0x3C, 0xE0, 0xFF, 0x44, 0x61, 0x44, 0x9C, 0xD3, 0xC8, 0x4D, 0x2B,
	0x07, 0xC5, 0x0E, 0xE7, 0xD7, 0xC2, 0x51, 0x7B, 0x8D, 0x77, 0xB7, 0x17, 0x35, 0x34, 0x43, 0xB0,
	0xA8, 0xC5, 0x10, 0x00, 0xEF, 0x30, 0x78, 0xCC, 0x49, 0x25, 0xA3, 0x8E, 0x86, 0x68, 0xD2, 0x1B,
	0xD1, 0x29, 0xE2, 0xF7, 0x61, 0xD8, 0xE1, 0xDA, 0x61, 0x64, 0xEC, 0xA7, 0x0B, 0xBD, 0xB5, 0xCE,
	0xDF, 0x91, 0xC0, 0x24, 0x08, 0x7D, 0x3F, 0x38, 0x92, 0x5C, 0x62, 0x72, 0x90, 0x51, 0x70, 0x26,
	0x30, 0xE3, 0x8C, 0xF0, 0xFE, 0xF7, 0xA4, 0x0D, 0x84, 0x4F, 0x36, 0x93, 0xB8, 0xF2, 0x63, 0x55,
	0xB3, 0x47, 0xBF, 0x78, 0xE0, 0x77, 0x8C, 0x81, 0x2F, 0x1D, 0x97, 0x22, 0x4B, 0x07, 0xA3, 0xEE,
	0x60, 0x21, 0xCF, 0xA1, 0x24, 0x82, 0xEA, 0x29, 0x72, 0x86, 0x88, 0x86, 0xD9, 0x91, 0xB2, 0x43,
	0xE6, 0x2E, 0x3E, 0xC8, 0xBE, 0x7D, 0x5D, 0x34, 0x6A, 0xF2, 0xCC, 0xBF, 0xB1, 0xD9, 0xD9, 0x3C,
	0xF5, 0xA3, 0x36, 0x77, 0x8A, 0xE2, 0xFB, 0x8C, 0x48, 0x3B, 0x49, 0xCB, 0xD9, 0x40, 0x73, 0xED,
	0xCC, 0x0D, 0x56, 0xEE, 0x9F, 0xD3, 0x8B, 0x03, 0xD8, 0xB6, 0xEA, 0x47, 0x62, 0x3D, 0x69, 0xEC,
	0xD8, 0xE7, 0x50, 0x03, 0x2D, 0x28, 0xD0, 0x07, 0x39, 0x5B, 0x54, 0x6C, 0x21, 0x4C, 0x54, 0x9F,
	0x29, 0x27, 0x35, 0xB6, 0xDC, 0x84, 0xC3, 0x7E, 0x44, 0x23, 0x45, 0x85, 0x46, 0x14, 0xFC, 0x15,
	0xE1, 0xE2, 0x8A, 0x45, 0x14, 0x70, 0xF3, 0x3C, 0x15, 0xED, 0x18, 0xBB, 0xFF, 0xC1, 0x40, 0x3D,
	0x30, 0x65, 0x1D, 0xF2, 0x02, 0xB6, 0x9F, 0x76, 0x6A, 0xD2, 0x6E, 0x98, 0xA8, 0xC3, 0x3E, 0xF8,
	0xC3, 0xD3, 0xBC, 0xCA, 0x41, 0x70, 0x08, 0xAD, 0x07, 0xCA, 0x3A, 0xDC, 0x3E, 0xEE, 0x0A, 0x12,
	0xB7, 0x05, 0x64, 0xB6, 0xDC, 0xBB, 0x6A, 0x85, 0x73, 0x83, 0x31, 0x34, 0xE9, 0xA7, 0x6F, 0x1B,
	0x80, 0x3D, 0x3C, 0x5A, 0xF2, 0x1B, 0x3B, 0x21, 0xAE, 0x20, 0x69, 0xCF, 0x84, 0x3D, 0xEE, 0x4F,
	0xB9, 0x79, 0x13, 0x15, 0xF7, 0xBB, 0xAF, 0x37, 0xDC, 0x99, 0x0A, 0xD3, 0xCD, 0x79, 0x6C, 0x34,
	0x38, 0x1E, 0x8F, 0xB7, 0xA5, 0x93, 0x5E, 0xEA, 0x5E, 0x4D, 0xEE, 0x3A, 0x94, 0xD0, 0xEE, 0xA4,
	0x8A,
};

const size_t SPOTIFY_APP_KEY_SIZE = sizeof(SPOTIFY_APP_KEY);

NSString* kEchoNestAPIKey = @"QMT6WYFTWSGPSOQFV";
NSString* kEchoNestConsumerKey = @"be329eab49668456821db2f2b55821f1";
NSString* kEchoNestSharedSecret = @"GoSk4Az1Sva8qbP+TpnGFA";
NSString* kEchoNestQueryHeading = @"http://developer.echonest.com/api/v4/artist/search?api_key=QMT6WYFTWSGPSOQFV&format=json";
