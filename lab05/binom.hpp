#include <cmath>
#include <cstdio>

class Binom {
private:
  int n;
  double p;
  
public:
  // Binom(int n_, double p_) : n(n_), p(p_) {};
  Binom(int n_, double p_) {
    n = n_;
    p = p_;
  };
  int factorial(int k) const;
  double choose(int a, int b) const;
  double dbinom(int k) const;
  void print(int k) const;
};

// Exercise 1
inline int Binom::factorial(int k) const {
  if (k <=1) return 1;
  return k * factorial(k - 1);
}

// Exercise 2
inline double Binom::choose(int a, int b) const {
  if (b == 0 || b == a) return 1;
  return choose(a - 1, b - 1) + choose(a - 1, b);

} 

  // Expercise 3
inline double Binom::dbinom(int k) const {
  return choose(n, k) * pow(p, k) * pow(1 - p, n - k);
}