//
//  image.h
//  sol
//
//  Created by Борис Стрельчик on 15.02.14.
//  Copyright (c) 2014 Борис Стрельчик. All rights reserved.
//

#ifndef sol_image_h
#define sol_image_h

#include <stdint.h>
#include <stddef.h>
#include <string.h>

class Pixel {
    public :
        uint8_t r;
        uint8_t g;
        uint8_t b;
        uint8_t a;
        Pixel()
            : r(0),g(0),b(0),a(UINT8_MAX) {}
    
        Pixel(uint8_t r, uint8_t g, uint8_t b, uint8_t a = UINT8_MAX)
            :r(r), g(g), b(b),a(a) {}

        Pixel(uint8_t* data)
            :r(data[0]), g(data[1]), b(data[2]),a(data[3]) {}
    
        bool operator!=(const Pixel& pixel) {
            return r != pixel.r || g != pixel.g || b != pixel.b;
        }
        bool operator==(const Pixel& pixel) {
            return r == pixel.r && g == pixel.g && b == pixel.b;
        }
};

class Image {
    uint8_t* data_ = nullptr;
    size_t width_;
    size_t height_;
    public:
        Image(uint8_t* data, size_t width, size_t height)
            :data_(data), width_(width), height_(height)
        { }
        Image(size_t width, size_t height)
            :width_(width),height_(height)
        {
            data_ = new uint8_t[width * height * sizeof(::Pixel)];
            ::memset(data_, 0, width * height * sizeof(::Pixel));
        }
    
    ~Image() {
        delete[] data_;
    }
    
    const uint8_t * data() const
    {
        return data_;
    }
    
        void SetPixel(size_t x, size_t y, const Pixel& pixel)
        {
            size_t pos = (y * width_ + x) * sizeof(::Pixel);
            data_[pos] = pixel.r;
            data_[pos + 1] = pixel.g;
            data_[pos + 2] = pixel.b;
        }
        size_t Width() const { return width_; }
        size_t Height() const { return height_; }
    Pixel Pixel(size_t x, size_t y) const { return ::Pixel(&data_[ (y * width_ + x) * sizeof(::Pixel) ]); }
};


#endif
