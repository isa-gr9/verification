#include "flexfloat.hpp"
#include <cstdio>
#include <iostream>
#include <fstream>
#include <cstdlib>
#include <ctime>

#define FP16_EXP_BITS 5
#define FP16_MAN_BITS 10

#define RET_OK 0
#define RET_KO_USE 1

int operandGen(int argc, char **argv)
{
  if (argc != 2)
  {
    printf("Usage: %s <numOperands>\n", argv[0]);
    printf("Example: %s 5\n", argv[0]);
    return RET_KO_USE;
  }

  int numOperands = atoi(argv[1]);
  if (numOperands < 1)
  {
    printf("Number of operands must be at least 1.\n");
    return RET_KO_USE;
  }

  // Define 'range' and assign it the value of RAND_MAX
  int range = RAND_MAX;

  // Seed the random number generator
  std::srand(std::time(nullptr));

  for (int cycle = 0; cycle < numOperands; ++cycle)
  {
    float fa = static_cast<float>(std::rand() - range / 2) / (range / 2) * 100.0; // Adjust range as needed
    float fb = static_cast<float>(std::rand() - range / 2) / (range / 2) * 100.0; // Adjust range as needed

    flexfloat<FP16_EXP_BITS, FP16_MAN_BITS> ff16_a = fa;
    flexfloat<FP16_EXP_BITS, FP16_MAN_BITS> ff16_b = fb;
    flexfloat<FP16_EXP_BITS, FP16_MAN_BITS> ff16_c = ff16_a * ff16_b;

    std::ofstream operandsFile("operands.txt", std::ios_base::app);
    operandsFile << "ff16_a = " << flexfloat_as_double << ff16_a << flexfloat_as_bits << " (" << ff16_a << ")" << std::endl;
    operandsFile << "ff16_b = " << flexfloat_as_double << ff16_b << flexfloat_as_bits << " (" << ff16_b << ")" << std::endl;
    operandsFile.close();

    std::ofstream resultsFile("results.txt", std::ios_base::app);
    resultsFile << "ff16_c = " << flexfloat_as_double << ff16_c << flexfloat_as_bits << " (" << ff16_c << ")" << std::endl;
    resultsFile.close();
  }

  return RET_OK;
}