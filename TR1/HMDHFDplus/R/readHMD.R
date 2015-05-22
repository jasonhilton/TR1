#'
#' @title \code{readHMD()} reads a standard HMD .txt table as a \code{data.frame}
#' 
#' @description This calls \code{read.table()} with all the necessary defaults to avoid annoying surprises. The Age column is also stripped of \code{"+"} and converted to integer, and a logical indicator column called \code{OpenInterval} is added to show where these were located. If the file contains population counts, values are split into two columns for Jan 1 and Dec 31 of the year. Output is invisibly returned, so you must assign it to take a look. This is to avoid lengthy console printouts. 
#' 
#' @param filepath path or connection to the HMD text file, including .txt suffix.
#' @param ... other arguments passed to \code{read.table}, not likely needed.
#' @param fixup logical. Should columns be made more user-friendly, e.g., forcing Age to be integer?
#' 
#' @return data.frame of standard HMD output, except the Age column has been cleaned, and a new open age indicator column has been added. If the file is Population.txt or Population5.txt, there will be two columns each for males and females.
#' 
#' @details Population counts in the HMD typically refer to Jan 1st. One exception are years in which a territorial adjustment has been accounted for in estimates. For such years, `YYYY-` refers to Dec 31 of the year before the adjustment, and `YYYY+` refers to Jan 1 directly after the adjustment (adjustments are always made Jan 1st). In the data, it will just look like two different estimates for the same year, but in fact it is a definitional change or similar. In order to remove headaches from potential territorial adjustments in the data, we simply create two columns, one for January 1st (e.g.,\code{"Female1"}) and another for Dec 31st (e.g.,\code{"Female2"}) . One can recover the adjustment coefficient for each year by taking the ratio $$Vx = P1(t+1) / P2(t)$$. In most years this will be 1, but in adjustment years there is a difference. This must always be accounted for when calculating rates and exposures. Argument \code{fixup} is outsourced to \code{HMDparse()}.
#' 
#' @note Function submitted by Tim Riffe, with RCurl stricks lifted from Carl Boe's script.
#' 
#' @export
#' 
#' @note function written by Tim Riffe.
#' 
readHMD <- function(filepath, fixup = TRUE, ...){
  DF              <- read.table(file = filepath, header = TRUE, skip = 2, na.strings = ".", as.is = TRUE, ...)
  if (fixup){
    DF        <- HMDparse(DF, filepath)
  }
  invisible(DF)
}


