# 1) Compute the probability of an observation from a Chi-square distribution with 10 degrees of freedom of being larger than 15.
1-pchisq(q=15,df=10)

# 2) Run the code line that produces the `ts.sim` time series object at the end of the help file for the arima.sim() function. 
ts.sim <- arima.sim(list(order = c(1,1,0), ar = 0.7), n = 200)

# 3) Remove the first observation from the `ts.sim` object you generated in Question 2 and re-assign this shortened time series to an object of the same name (i.e. `ts.sim`).
ts.sim <- ts.sim[-1]

# 4) Run the following lines of code to obtain the object `dates` and convert this object into a date format recognizable for R:
  year <- round(runif(200, 1900, 2020))
  day <- round(runif(200, 1, 28))
  month <- round(runif(200, 1, 12))
  dates <- apply(cbind(month, day, year), 1, paste, collapse = "_")
  
  new_dates <- as.Date(dates, format = "%m_%d_%Y")

# 5) Create a plot of the object `ts.sim` generated in Question 3 where the y-axis represents the 200 values of `ts.sim` over time and the x-axis represents the `dates` object formatted correctly to represent the date for each observation in the time series `ts.sim`. Use the plot() function with the argument `type = "l"`.
  new_dates_ordered <- sort(new_dates)
  
  plot(new_dates_ordered, ts.sim, type = 'l')
  
# 6) Generate the following 3 x 3 matrix using the vector `c(10, 2, 6, 3, 8, 2, 4, 2, 12)`
  #      [,1] [,2] [,3]
  #[1,]   10    2    6
  #[2,]    3    8    2
  #[3,]    4    2   12
# Call this matrix `Sigma`.
  
  Sigma <- matrix(c(10, 2, 6,
                     3, 8, 2,
                     4, 2, 12), nrow = 3, byrow = TRUE)

# 7) Give the following names to the rows and columns of `Sigma`: "Red", "Green", "Blue".
  rownames(Sigma) <- c("Red", "Green", "Blue")
  colnames(Sigma) <- c("Red", "Green", "Blue")

# 8) Generate a 200x3 matrix called `X` using the function mvrnorm() from the MASS package. The mean (mu) is `c(2, 1, 3)` while the covariance (Sigma) is given by the matrix `Sigma` generated in Question 6.
library(MASS)
set.seed(54321)
X <- mvrnorm(n=200, mu = c(2,1,3), Sigma = Sigma)
  
# 9) Generate a vector `z`  through a linear combination of the columns of the matrix `X` created from Question 8, where the weights for each column are given respectively by 2, 4, 3.
z <- (X[,1]*2) + (X[,2]*4) + (X[,3]*3)

# 10) Generate 200 values from a Student distribution with 15 degrees of freedom and add them to the vector `z` generated in Question 9. Call this new vector `y`
y <- rt(n=200, df=15) + z

# 11) Using the function ginv() from the MASS package, run the following code `ginv(t(X)%*%X)%*%t(X)%*%y`. Using comment in your response, compare and discuss these values with the weights given in Question 9.
ginv(t(X)%*%X)%*%t(X)%*%y
  # The weights in Q9 were 2, 4, 3. The values calculated by running the code given are almost identical to the respective weights. These values are off by a few decimals places.

# 12) Fetch data regarding Apple (AAPL) and Netflix (NFLX) in the period between today and 2 years ago using the package quantmod.  Create a weighted portfolio (made of these two stocks) with weights 0.85 for Apple and 0.15 for Netlfix. Compute the variance of the returns of this portfolio and, using comment in your response, compare to the variances of the returns of the individual stocks.

install.packages('quantmod')
library(quantmod)

today = Sys.Date()
two_years_ago = seq(today, length = 2, by = "-2 years")[2]

getSymbols("AAPL", from = two_years_ago, to = today)
getSymbols("NFLX", from = two_years_ago, to = today)

#there are no missing values, so na.omit() is not necessary

weighted_portfolio = (0.85*AAPL) + (0.15*NFLX)

(weighted_portfolio_return_var = var(dailyReturn(weighted_portfolio)))
(AAPL_return_var = var(dailyReturn(AAPL)))
(NFLX_return_var = var(dailyReturn(NFLX)))

# the variance of returns using `dailyReturn()` was found to be
#
#           weighted = 0.0003787
#               AAPL = 0.0003573
#               NFLX = 0.0010577
#
# the variance of the returns for the weighted portfolio is almost identical to the variance of returns for AAPL. The variance of the returns for NFLX was the largest being one order of magnitude larger than the others. All of these variances appear very small which would indicate the spread on the data is small. The return values for each of the companies is very consistent. 