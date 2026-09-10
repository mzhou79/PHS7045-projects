# PHS7045 Lab 03
# Warm-up: loops, functions, and beepr

# Install beepr once if it is not already installed.
if (!requireNamespace("beepr", quietly = TRUE)) {
  install.packages("beepr")
}

# ------------------------------------------------------------
# A1. Play each sound in turn, waiting 2 seconds between beeps
# ------------------------------------------------------------
for (sound in 1:11) {
  beepr::beep(sound)
  if (sound < 11) {
    Sys.sleep(2)
  }
}

# ------------------------------------------------------------
# A2. Play each sound with a random pause between beeps
# Here, the pause is randomly chosen between 0.5 and 2.5 seconds.
# ------------------------------------------------------------
for (sound in 1:11) {
  beepr::beep(sound)
  if (sound < 11) {
    pause <- runif(1, min = 0.5, max = 2.5)
    Sys.sleep(pause)
  }
}

# ------------------------------------------------------------
# B. How can beepr::beep() be useful?
# ------------------------------------------------------------
# beepr::beep() can provide an audible signal when a long-running
# script finishes. This is useful when code takes a long time to run,
# because you do not have to keep watching the R console.
#
# This illustrates that R is a scripting language: a script can
# automatically carry out a sequence of tasks and then notify the
# user when the work is complete.

# ------------------------------------------------------------
# C. Why use beepr::beep() after library(beepr)?
# ------------------------------------------------------------
# After library(beepr), beep() can be called directly. Writing
# beepr::beep() is still useful because it makes the source package
# explicit, avoids ambiguity if another package has a function named
# beep(), and works without attaching the whole package.

# ------------------------------------------------------------
# D. Function: cumulative sum with a loop, then beep
# ------------------------------------------------------------
cumulative_beep <- function(x, sound) {
  cumulative <- numeric(length(x))
  running_total <- 0
  
  for (i in seq_along(x)) {
    running_total <- running_total + x[i]
    cumulative[i] <- running_total
  }
  
  result <- cbind(
    original = x,
    cumulative_sum = cumulative
  )
  
  beepr::beep(sound)
  return(result)
}

# Example and check against cumsum()
x <- c(3, 5, 2, 7, 4)
example_result <- cumulative_beep(x, sound = 1)
print(example_result)

# The cumulative-sum column should match cumsum(x).
stopifnot(all(example_result[, "cumulative_sum"] == cumsum(x)))

# I finished the task