#include <iostream>
#include "binom.hpp"


int main() {
    Binom b(10, 0.5);

    std::cout << "Exercise 1: Factorial" << std::endl;
    for (int i = 0; i <= 10; i++) {
        std::cout << i << "! = " << b.factorial(i) << std::endl;
    }

    std::cout << "Exercise 2: Choose" << std::endl;
    for (int i = 0; i <= 10; i++) {
        std::cout << "C(10, " << i << ") = " << b.choose(10, i) << std::endl;
    }

    std::cout << "Exercise 3: dbinom" << std::endl;
    for (int i = 0; i < 10; i++) {
    std::cout << b.dbinom(i) << std::endl;
   }
    return 0;
}
