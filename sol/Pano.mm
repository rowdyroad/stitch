//
//  ViewController.m
//  sol
//
//  Created by Борис Стрельчик on 15.02.14.
//  Copyright (c) 2014 Борис Стрельчик. All rights reserved.
//

#import "image.h"
#import "stitcher.h"
#import "Pano.h"
@interface Pano ()

@end

@implementation Pano

Image* convert(NSString* str) {
    UIImage* img = [UIImage imageNamed:str];
    uint8_t *data_ = ( uint8_t *)malloc(img.size.width * img.size.height * 4);
    
    CGImageRef image = [img CGImage];
    NSUInteger width = CGImageGetWidth(image);
    NSUInteger height = CGImageGetHeight(image);
    
    NSUInteger bytesPerRow = sizeof(::Pixel) * width;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(data_, width, height, 8, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
    CGContextRelease(context);
    
    return new Image(data_, img.size.width, img.size.height);
}

UIImage* unconvert(Image* img)
{
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL,img->data(),img->Width()*img->Height()*sizeof(::Pixel),NULL);
    
    int bitsPerComponent = 8;
    int bitsPerPixel = sizeof(::Pixel) * bitsPerComponent;
    int bytesPerRow = sizeof(::Pixel)*img->Width();
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    CGImageRef imageRef =
    CGImageCreate(img->Width(),img->Height(),bitsPerComponent,bitsPerPixel, bytesPerRow,colorSpaceRef,bitmapInfo,provider,NULL,NO,renderingIntent);
    return [UIImage imageWithCGImage:imageRef];
}

+ (void)PixelPositionAndColorTest
{
    Image * a = convert(@"test.png");
    assert(a->Pixel(0,0) == Pixel(0,0,0));
    assert(a->Pixel(1,0) == Pixel(UINT8_MAX,0,0));
    assert(a->Pixel(2,0) == Pixel(0,UINT8_MAX,0));
    assert(a->Pixel(3,0) == Pixel(0,0,UINT8_MAX));
    assert(a->Pixel(4,0) == Pixel(0,UINT8_MAX,UINT8_MAX));
    assert(a->Pixel(5,0) == Pixel(UINT8_MAX,UINT8_MAX,0));
    assert(a->Pixel(6,0) == Pixel(UINT8_MAX,0,UINT8_MAX));
    delete a;
    Image * aa = convert(@"2.png");
    Image * bb = convert(@"1.png");
    Stitcher s;
    CIntPt* ap, *bp;
    int apc, bpc;
    s.HarrisCornerDetector(aa, 2, 50, &ap, apc);
    s.HarrisCornerDetector(bb, 2, 50, &bp, bpc);
    
    CMatches * matches;
    int matches_count;
    s.MatchInterestPoints(aa, ap, apc, bb, bp, bpc, &matches, matches_count);
    
    NSLog(@"apc: %d bpc: %d mpc: %d", apc, bpc, matches_count);
    double m_Hom[3][3];
    double m_HomInv[3][3];
    s.RANSAC(matches, matches_count, 200, 5,  m_Hom, m_HomInv);
    QImage stitched;
    NSLog(@"stitching");
    s.Stitch(aa,bb, m_Hom, m_HomInv, stitched);
    [UIImagePNGRepresentation(unconvert(stitched)) writeToFile:@"/tmp/result.png" atomically:YES];
    NSLog(@"sttiched");
}


@end
