# Tai Sakuma <sakuma@fnal.gov>

library('reshape', warn.conflicts = FALSE, quietly = TRUE)
library('ggplot2', warn.conflicts = FALSE, quietly = TRUE)
library('grid', warn.conflicts = FALSE, quietly = TRUE)
library('RColorBrewer', warn.conflicts = FALSE, quietly = TRUE)
library('methods', warn.conflicts = FALSE, quietly = TRUE)
library('vcd', warn.conflicts = FALSE, quietly = TRUE)

source('quartz_save.R')
## source('drawThemes.R')

##____________________________________________________________________________||
readArgs <- parse('drawReadArgsG.R')

##____________________________________________________________________________||
call.quartz.save <- function(file)
    {
      if(arg.png)
        {
          png <- paste(file, '.png', sep = '')
          print(png)
          quartz.save(png)
        }

      if(arg.pdf)
        {
          pdf <- paste(file, '.pdf', sep = '')
          print(pdf)
          quartz.save(pdf, type = 'pdf')
        }
    }

##____________________________________________________________________________||
mk.fig.id <- function(fig.id)
  {
    if( ! is.null(arg.id) ) fig.id <- paste(fig.id, '_', arg.id, sep = '')
    fig.id
  }

##____________________________________________________________________________||
print.figure <- function(p, fig.id)
  {
    print(p)
    call.quartz.save(paste(arg.outdir, '/', fig.id, sep = ''))
  }
##____________________________________________________________________________||
log10.y.labels <- function(y.at)
  {
    # y.labels.cha <- ifelse(abs(y.at) >= 2, paste('10^{', y.at, '}', sep = ''), 10^y.at)
    y.labels.cha <- ifelse(y.at %% 1 == 0, ifelse(abs(y.at) >= 2, paste('10^{', y.at, '}', sep = ''), 10^y.at), '')
    sapply(y.labels.cha, function(x) if(nchar(x) == 0) x else parse(text = x))
  }

##____________________________________________________________________________||
log10.y.grid.at <- function(y.at)
  {
    y <- sort(as.vector(sapply(1:9*10, function(x) log10(x*10^{(min(y.at) - 1):(max(y.at) - 1)}))))
    y[y <= max(y.at)]
  }

##____________________________________________________________________________||
