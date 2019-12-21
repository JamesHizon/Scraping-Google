# FRS DataScience 11/12

#install XLM package
#install.packages("XML")
library(rvest)
library(XML)
library(NLP)
library(tm)
library(hunspell)
library(zipfR)

ucdresearch <- read_html("https://www.google.com/search?q=uc+davis+research+centers&sxsrf=ACYBGNSNMPg61Ty268GhpxPgy48CZswvMQ:1571161842718&ei=8gamXe6tK5D--gTSpIzwBA&start=0&sa=N&filter=0&ved=0ahUKEwju7pP86Z7lAhUQv54KHVISA044ogIQ8tMDCNAF&biw=982&bih=722")
ucdresearch

# extract the nodes you need with css selectors

result <- html_nodes(ucdresearch, "a")
print(result)
length(result)

links <- grep("ucdavis.edu", result, value = TRUE)
links

alllinks <- c()

#collect information from each website
for (i in 1:length(links)){
  #idenifies individual URLs
  URL<- links[[i]]
  
  #URL <- gsub("&sa", "", URL)
  #print(URL)
  
  #turning Links list into nodes
  url_return <- read_html(URL)
  #   
  # #parse URLs from Links list farther
  a = html_nodes(url_return, "a")
  URL_two <- html_attr(a, "href")
  URL_two <- gsub("/url?q=", "", URL_two, fixed=TRUE)
  
  temp <- strsplit(URL_two, "&sa", fixed = TRUE)
  URL_two <- temp[[1]][1]
  
  #   "[/url?q=]"
  # #extract HTML body text
  
  tryCatch ({
    content <- read_html(URL_two)
    
    # use XPath to extract the body
    obj_page_text <- html_nodes(content, "body")
    
    pagelinks <- html_nodes(content, "a")
    pagelinks <- html_attr(pagelinks, "href") 
    
    alllinks <- c(alllinks, pagelinks)
    
    #convert body node to plain text
    var_text <- html_text(obj_page_text)
    
    #define a pattern
    pattern<- "<.*?>"
    
    #replace pattern with blank space
    var_plain_text <- gsub(pattern, " ", var_text)
    
    # convert multiple spaces to single space
    var_ballad_plain_text_trimming <- gsub("\\s+", " ", var_plain_text, TRUE)
    
    # define an output path
    outpath <- paste("/home/james/FRS_Cure/Rstudio_Research/", i, ".txt", collapse="", sep="")
    
    # open a write connection
    fileConn <- file(outpath)
    
    # write the file
    writeLines(var_ballad_plain_text_trimming,
               con = fileConn,
               sep = " ",
               useBytes = FALSE)
    
    # close the connection
    close(fileConn)
    
  },error=function(error) {
    print("in catch")
    #print(error)
    print(URL_two) 
    
  })
  
}

########OBSERVATION OF A SINGLE ".txt" file.

# NOW, identify files to analyze:
var_textFile_1 = "/home/james/FRS_Cure/Rstudio_Research/1.txt"
var_textFile_1
var_textLines_1 <- readLines(var_textFile_1)
var_textLines_1

# collapse the vector of lines into a single element
var_textBlob_1 <- paste(var_textLines_1, collapse = " ")
var_textBlob_1

# change to lowercase
var_textBlob_lowercase_1 <- tolower(var_textBlob_1)
var_textBlob_lowercase_1

#########Using a list of files called txt_files_list:

# Identify the text file to analyze
var_textFile = "/home/james/FRS_Cure/Rstudio_Research/" # File path

# Make list of text file
txt_files_list = list.files(path = var_textFile, pattern="*.txt") 
txt_files_list

###############################################################################
### WANT: 
# Create big blob of text.
### NEXT:
# From big blob of text, do word frequency analysis.
### AFTERWARDS:
# Prepare for presentation and answering research questions.
# Finish 'read_me.'
###############################################################################

file_path <- "/home/james/FRS_Cure/Rstudio_Research/"
# Add txt_files_list to for loop.

content = ""
for (file in txt_files_list){
  full_filepath <- paste(file_path, file, collapse = "", sep ="")
  lines = readLines(full_filepath)
  #print(lines)
  combined = paste(lines, sep = "", collapse = " ")
  content[file] = combined
}
print(content)

#### USE "content" as main blob.

# change to lowercase
var_textBlob_lowercase <- tolower(content)
var_textBlob_lowercase

var_word_blacklist = c("of", 
                       "the",
                       "a",
                       "an")

# remove stopwords
var_textBlob_unStopped <- removeWords(var_textBlob_lowercase, stopwords('english'))

# use the below line to remove any other tokens based on blacklist
var_textBlob_blacklisted <- removeWords(var_textBlob_unStopped, var_word_blacklist)

# protect hyphens
var_textBlob_nonNumeric <- gsub("-", " - ", var_textBlob_blacklisted)

# remove punctuation
var_textBlob_noPunctuation <- removePunctuation(var_textBlob_nonNumeric)

# remove numeric elements
var_textBlob_nonNumeric <- gsub("\\d+", " ", var_textBlob_noPunctuation)

# collapse multiple spaces
var_textBlob_collapseWhitespace <- gsub("\\s+", " ", var_textBlob_nonNumeric)

# trim leading and trailing spaces
var_textBlob_trimmed <- trimws(var_textBlob_collapseWhitespace)

# convert blob to list of words
var_wordlist = unlist(strsplit(var_textBlob_trimmed, split = ' '))
var_wordlist

# calculate total word count
var_totalWords <- length(var_wordlist)
var_totalWords

# setup a frequency table
obj_frequencies <- table(var_wordlist)
obj_frequencies

# sort the frequency table
obj_sortedFrequencies <- sort(obj_frequencies , decreasing=T)
obj_sortedFrequencies

# convert to relative frequencies
obj_sortedRelativeFrequencies <- 100*(obj_sortedFrequencies/var_totalWords)
obj_sortedRelativeFrequencies

# run the command below in your console to find the 
# relative frequency of any word
obj_sortedRelativeFrequencies["uc"]

# plot the actual word frequencies
var_numToPlot_integer <- 50
var_numToPlot_integer
axis(1, 1:var_numToPlot_integer, labels=names(obj_sortedFrequencies [1:var_numToPlot_integer]))
plot(obj_sortedFrequencies[1:var_numToPlot_integer], main="Word Frequency", type="b", xlab="Top Words", ylab="Frequency", xaxt ="n") 
axis(1, 1:var_numToPlot_integer, labels=names(obj_sortedFrequencies [1:var_numToPlot_integer]))



#################################################################

# get a list of all non-word tokens in the blob.  This can taka a long
# time, so the code below includes two lines of code.  To run in production
# uncomment the line that uses the hunspell library.  To run during testing
# and learning comment out the hunspell line and uncomment the line that
# assigns a random list of non-words to the var_nonWord vector. 

#var_nonWords <- hunspell(var_textBlob_trimmed, dict = dictionary("en_US"))
#var_nonWords <- c("xidsafd", "lirreke", "anweaother", "ixion")

# get a list of all elements in the list of words that
# aren't a real word
# var_nonwordList <- match(var_wordlist, var_nonWords)

# subset the original list of words to include only those
# words that don't match the non-word list
# var_wordList_cleaned <- var_wordlist[is.na(var_nonwordList)]

# collapse the vector back into a text blob
# var_texBlob_cleaned <- paste(var_wordList_cleaned, collapse=" ")



#############################################################################

# collapse multiple spaces
# var_textBlob_collapseWhitespace <- gsub("\\s+", " ", var_textBlob_lowercase)
# var_textBlob_collapseWhitespace

##############################################################################

# 1) Access urls from own browser.
# 2) If something within URL doesn't work, (&sa), get rid of anything after.
# Use strsplit().
# 3) Using list, get rid of any duplicates. 

##############################################################################




