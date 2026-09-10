urn_prob <- function(nreps = 100000,
                     b1 = 10, y1 = 8,
                     b2 = 6, y2 = 6) {
  
  blue_second <- logical(nreps)
  
  for (i in 1:nreps) {
    
    # Draw one marble from urn 1
    first_draw <- sample(c("blue", "yellow"),
                         size = 1,
                         prob = c(b1, y1))
    
    # Transfer it to urn 2
    if (first_draw == "blue") {
      blue_urn2 <- b2 + 1
      yellow_urn2 <- y2
    } else {
      blue_urn2 <- b2
      yellow_urn2 <- y2 + 1
    }
    
    # Draw one marble from urn 2
    second_draw <- sample(c("blue", "yellow"),
                          size = 1,
                          prob = c(blue_urn2, yellow_urn2))
    
    blue_second[i] <- (second_draw == "blue")
  }
  
  # Estimated probability
  mean(blue_second)
}

urn_prob()