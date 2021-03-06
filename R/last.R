
# data.table defined last(x) with no arguments, just for last. If you need the last 10 then use tail(x,10).
# This last is implemented this way for compatibility with xts::last which is S3 generic taking 'n' and 'keep' arguments
# We'd like last() on vectors to be fast, so that's a direct x[NROW(x)] as it was in data.table, otherwise use xts's.
# If xts is loaded higher than data.table, xts::last will work but slower.
last <- function(x, ...) {
    if (nargs()==1L) {
        if (is.vector(x)) {
        	if (!length(x)) return(x) else return(x[[length(x)]])  # for vectors, [[ works like [
        } else if (is.data.frame(x)) return(x[NROW(x),])
    }
    if(!requireNamespace("xts", quietly = TRUE)) {
        tail(x, n = 1L, ...)
    } else {
        # fix with suggestion from Joshua, #1347
        if (!"package:xts" %in% search()) {
            tail(x, n = 1L, ...)
        } else xts::last(x, ...) # UseMethod("last") doesn't find xts's methods, not sure what I did wrong.
    }
}

# first(), similar to last(), not sure why this wasn't exported in the first place...
first <- function(x, ...) {
    if (nargs()==1L) {
        if (is.vector(x)) {
            if (!length(x)) return(x) else return(x[[1L]])
        } else if (is.data.frame(x)) return(x[1L,])
    }
    if(!requireNamespace("xts", quietly = TRUE)) {
        head(x, n = 1L, ...)
    } else {
        # fix with suggestion from Joshua, #1347
        if (!"package:xts" %in% search()) {
            head(x, n = 1L, ...)
        } else xts::first(x, ...)
    }
}
