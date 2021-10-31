#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "MK22F51212.h"

#define PI 3.14159265

float map(float x, float in_min, float in_max, float out_min, float out_max);

void map_vec_to_dac(float* dom, uint16_t* range, size_t N);

double * zeros(double x[], size_t n);

void zeros_int16(int16_t x[], size_t n);

void zeros_int64(int64_t x[], size_t n);

void zeros_int(uint16_t x[], size_t n);

void zeros2d(size_t row, size_t col, float x[][col]);

void add_vecs(float* vec1, float* vec2, float* sum, size_t N);

void add_const_vec(float k, float* vec, size_t N);

