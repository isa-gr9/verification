#include <stdio.h>
#include "svdpi.h"

#include <stdio.h>



#define MANTISSA_SIZE               (10U)
#define EXP_SIZE                    (5U)
#define HALF_PRECISION_CONSTANT     (15U)

typedef enum {
    ADD = 0,
    SUB = 1,
    MUL = 2,
    DIV = 3
} op_t;

void fpOp2ieee754 (float f1, float f2, op_t op, int ieee754[16]);
void dec2bin(int num, int binary_array[], int *index);
void fp2ieee754(float f, int ieee754[16]);
void fpMul2Ieee754 (float f1, float f2, int ieee754[16]);
void fpSub2Ieee754 (float f1, float f2, int ieee754[16]);
void fpAdd2Ieee754 (float f1, float f2, int ieee754[16]);
void fpDiv2Ieee754 (float f1, float f2, int ieee754[16]);


int main() {
    float in1, in2;
    printf("Enter a float number: ");
    scanf("%f", &in1);

    printf("Enter a float number: ");
    scanf("%f", &in2);

    int ieee754[16];

    fpOp2ieee754(in1, in2, 2, ieee754);

    printf("%d-", ieee754[15]);
    printf("%d%d%d%d%d-", ieee754[14], ieee754[13], ieee754[12], ieee754[11], ieee754[10]);
    for (int i = 9; i >= 0; i--) {
        printf("%d", ieee754[i]);
    }

    printf("\n");
    return 0;

}

/**********************************************************************
 * Function: fpOp2ieee754
 * 
 * Receives an operation and then it computes the result. Then, 
 * convert the result float number into the IEEE 754 standard 
 **********************************************************************/

void fpOp2ieee754 (float f1, float f2, op_t op, int ieee754[16]) {

    switch (op)
    {
        case ADD:
            fpAdd2Ieee754(f1,f2,ieee754);
            break;
        case SUB:
            fpSub2Ieee754(f1,f2,ieee754);
            break;
        case MUL:
            fpMul2Ieee754(f1,f2,ieee754);
            break;
        case DIV:
            fpMul2Ieee754(f1,f2,ieee754);
            break;
        default:
            break;
    }
}


/**********************************************************************
 * Function: fpMul2Ieee754
 * 
 * Mul operation and then
 * convert the result float number into the IEEE 754 standard 
 **********************************************************************/
void fpMul2Ieee754 (float f1, float f2, int ieee754[16]) {

    float result;

    result = f1 * f2;

    fp2ieee754(result, ieee754);
}

/**********************************************************************
 * Function: fpAdd2Ieee754
 * 
 * Add operation and then
 * convert the result float number into the IEEE 754 standard 
 **********************************************************************/

void fpAdd2Ieee754 (float f1, float f2, int ieee754[16]) {

    float result;

    result = f1 + f2;

    fp2ieee754(result, ieee754);
}

/**********************************************************************
 * Function: fpSub2Ieee754
 * 
 * Sub operation and then
 * convert the result float number into the IEEE 754 standard 
 **********************************************************************/

void fpSub2Ieee754 (float f1, float f2, int ieee754[16]) {

    float result;

    result = f1 - f2;

    fp2ieee754(result, ieee754);
}

/**********************************************************************
 * Function: fpDiv2Ieee754
 * 
 * Div operation and then
 * convert the result float number into the IEEE 754 standard 
 **********************************************************************/

void fpDiv2Ieee754 (float f1, float f2, int ieee754[16]) {

    float result;

    result = f1 / f2;

    fp2ieee754(result, ieee754);
}

/**********************************************************************
 * Function: fp2ieee754
 * 
 * Convert a float number into the IEEE 754 standard Half precision 16 bit
 **********************************************************************/

void fp2ieee754(float f, int ieee754[16]) {

    int sign                        = {0};
    int tmp_mantissa[16];
    int mantissa[MANTISSA_SIZE]     = {0};
    int exp_bin[EXP_SIZE]           = {0};
    int actualExpSize               = 0;
    int exp_bias                    = 0;   
    int exp_int                     = 0;
    int i                           = 0;
    int j;
    int integer_part;
    float fractional_part;
    int tmp_int;

    // Separating float into integer and fractional parts
    integer_part    = (int)f;
    fractional_part = f - (float)integer_part;

    sign = (integer_part >> 31) & 0x1;

    if (sign) {
        integer_part    = -integer_part;
        fractional_part = -fractional_part;
    }


    dec2bin(integer_part, tmp_mantissa, &i);

    exp_bias = i - 1;
    exp_int  = HALF_PRECISION_CONSTANT + exp_bias;

    for(j = 0; j < exp_bias; j++) {
        mantissa[j] = tmp_mantissa[exp_bias - 1 -j];
        // printf("%d", mantissa[j]);
    }

    
/**********************************************************************
 * Function:  fractional 2 binary 
 **********************************************************************/
    while (fractional_part != 0.0 && j < MANTISSA_SIZE) {
        fractional_part *= 2;

        if (fractional_part > 0.99 && fractional_part < 1) fractional_part = 1;
        // printf("index: %d, fractional part: %f ", j, fractional_part);
        if (fractional_part >= 1) mantissa[j] = 1;
        else                      mantissa[j] = 0;

        j++;

        tmp_int = (int)fractional_part;
        fractional_part = fractional_part - (float)tmp_int;
    }


    i = 0;

    dec2bin(exp_int, exp_bin, &i);

    actualExpSize = i;

    ieee754[15] = sign;

    for (i = 0; i < EXP_SIZE; i++) {
        ieee754[14 - i] = exp_bin[EXP_SIZE - 1 - i];
        // printf("%d , %d\n", i, exp_bin[EXP_SIZE - 1 - i]);
    }

    for (i = 0; i < MANTISSA_SIZE; i++) {
        ieee754[14 - EXP_SIZE - i] = mantissa[i];
    }

}


/**********************************************************************
 * Function: dec2bin
 * 
 * Decimal to binary conversion
 **********************************************************************/
void dec2bin(int num, int binary_array[], int *index) {
    while(num > 0) {
        binary_array[*index] = num & 1;
        num >>= 1; 
        *index += 1;
    }
}


