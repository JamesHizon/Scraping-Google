# Scraping Google

![picture](https://user-images.githubusercontent.com/52821013/111235798-a7be4380-85ae-11eb-9b03-c4220aa69efa.png)


General Info
---------------
This experiment was run October and November 2019

Researchers: Bailey Wallen, Vishwanath Prathikanti, James Hizon, Shivam Mistry

We analyzed the online data from the Google search “UC Davis Research Centers” to scrape and write a code for all pages with the url “.edu” and the sublinks for each of those pages.


Motivation
--------------
Our motivation is the research to be used to improve the discoverability and accessibility of UC Davis’s research center resources, and identify new opportunities for multidisciplinary research and engagement with STEM.


Technologies
----------------
This project was created with:

R and Rstudio to write and test our code. 
We also downloaded rvest package within R to help us build loops and clean our data. 


Features
------------
Our project is significant to figuring out the use of web scraping and text mining to scrape and follow a code that collects data from the Google search “UC Davis Research Centers”


History
---------
The general function of this code is simple. In layman’s terms, we go through Google, take the links given by Google, and get the text and links inside those links. Our method of achieving this was through nested for-loops and trycatches, with the outer loop and catch being for the links, and the inner loop and catch for the sublinks. 

The first thing our code receives is a URL to a google search. Websites organize their links as “a” nodes, so to find all of the links, our code searches for all the “a” nodes. It then filters out some of the nodes that are not directly affiliated with UC Davis. We only included links that contained “.ucdavis.edu” in them.

However, when the “a” nodes are extracted, they are not clean URLs; when RStudio extracts the node, it will extract the entire node, including all the characters that google uses to make that link interact with other nodes in google. For example, when we extracted our first sublink, the link was: 

<a href="https://www.ucdavis.edu/research/" ping="/url?sa=t&amp;source=web&amp;rct=j&amp;url=https://www.ucdavis.edu/research/&amp;ved=2ahUKEwiuqcagh5rmAhUEuZ4KHcbIAG4QFjAAegQIVRAC"><h3 class="LC20lb"><span class="S3Uucc">Research | UC Davis</span></h3><br><div class="TbwUpd"><cite class="iUh30 bc">https://www.ucdavis.edu › research</cite></div></a>.

The link was in there, but it was surrounded by other characters. Because it is the entire node from google, RStudio would not recognize this as a real link that could be run. Because of that, we could not get the text nor the sublinks from this website. The solution was to use the “gsub” and “strsplit” functions, which would cut the node to give us the actual link from the node.

After we were able to compile a list of working links, we could finally start our trycatch that would read the links and do two things with them. The first task was to take all the text from the links, and the second task was to compile a list of all the sublinks. We used a trycatch simply because some of the links could not be accessed by RStudio for some reason, and we needed a way to identify the error links but continue collecting the working links. The list of links that would not work is in a text file titled “404’s” included in our files.

All of that details the process of our first trycatch, and we realized we needed to do the same process for our sublinks. To accomplish this, we added a nested trycatch, which would start  going through the sublinks after the text from the original link was saved to a .txt file. This was done to make our code easily organized and visually appealing. 

We ran into a few problems with the sublinks, specifically when a sublink redirects to a section later on in the same link. For example, a link on a page could be in the “table of contents” that just sends the user to a specific section instead of a new link. To counter this problem, we wrote in another “grep” function that deletes the link if it contains specific symbols that we have identified.

The final part of the code is cleaning it and saving it. We received the cleaning code from our instructors that would change the text to lowercase, remove punctuation, remove stopwords (a, it, the, etc), remove all numbers, and remove non-words, which can be entered. The inner and outer trycatches will then save the text as .txt files and the code will end.


Project narrative
--------------------
The goals of this project are to build a computer code to help analyze how University of California, Davis is represented online. We want to see what parts of our community here at Davis are misrepresented, under represented, or over represented and give that analysis to our UC Davis Stem Portal to better adjust their platform. This project affects all members of the UC Davis community as well as anyone who has an interest in S.T.E.M. programs at the University of California, Davis. Knowing the face of UC Davis S.T.E.M. research is essential to creating a balanced community.
Our class was divided into five separate groups where each group was given a different platform to scrape for data. The groups were the Academic Departments and Schools page, the Campus Organization page, the UC-Davis Archive-it page, a Google search for ‘UC Davis Research Center’ and the STEM Portal. Throughout the class, each group worked to develop code to scrape their platform and then to create a frequency table of words from their collected data. The data from all five groups were then collected and processed together so that each student could use the collected data to develop their own unique research question. 
Our group, named Cheese and Crackers, worked with the Google platform and we found 1,173 links and sublinks combined that refer to UC Davis Stem Research Centers. Our data can be found as a zip file named ALL_Files.zip which is located in the shared Google Drive account. 


Organization, Relationships, and Provenance
------------------------------------------------------

The following shows our list of files that have been uploaded as a zip file. In addition, a sample is shown to represent what to expect within our “.txt” files.





List of files:




Sample of what is contained (1.txt, 1_sublinks_5.txt, respectively):



We had to run our code inside RStudio to obtain our primary links and secondary links. In terms of naming conventions, each primary link is labeled with a number followed by the type of file. An example would be “1.txt” as the file name for the first file generated. When we obtain our secondary link, it is then labeled with a number followed by “_sublinks_”, then the second number with the position for the secondary link. Another example would be “1_sublinks_5.txt” as the file name for the fifth sublink of the first URL. 
Note the difference here. We find “1.txt” and “1_sublinks_5.txt” contain different information from each other is because “1.txt” shows the primary link and “1_sublinks_5.txt” shows a secondary link. The relationship is that all secondary links are generated from the primary links. For example, “1_sublinks_5.txt” is generated from “1.txt”.

Steps for Web Scraping: relationship between file types

1. Code that is used to get primary links using the output from the R code
2. Primary links
3. Code of parsing, extracting text, and/or cleaning
4. Text in link
5. Secondary links
6. Code to scrape that



Naming Conventions
--------------------------
Generated from our code:
#(primary link).txt: This is the text files for the primary links
#(primary link)_sublinks_#(sub link in the primary link).txt: This is the text files for the sublinks

Explanation: As seen above, our .txt files are organized by having the text on our original page (a number denoting what link it was on the google search) first, followed by the sublinks from that page (that number with “_sublink_” and another number, denoting the sublink on that page). This could only have been done with a nested for-loop; we use the incremented value from the outer for-loop to name the sublink. For example, say the outer for-loop is on the 3rd link in the list of links, meaning the incremented value in the outer for-loop is on 3. The nested for-loop will take the incremented value when it names the .txt file for a sublink in the 3rd link. If the loops were not nested, there would be a list of links followed by a list of sublinks, which would, in our eyes, be less visually appealing when sorting through the code.

History of codes:
Date_what was accomplish: The name given for every file, before a new edit to the code is made

Clean text: Text that is formatted without text from other files. This is the text alone from a specific link or sublink

Blob: This is all of the primary and sub links combined into one text 

Clean blobbed text: This is the blob, but simplified with no capital letters, no punctuation, and no word that make no sense: S%ad&er.

Scrape: Data such as text that is stripped from the website onto a text file


Contacts
-----------
Bailey Wallen (bswallen@ucdavis.edu)
Vishwanath Prathikanti (vprathikanti@ucdavis.edu)
James Hizon (jrhizon@ucdavis.edu)
Shivam Mistry (smistry@ucdavis.edu)
Best person to contact: Vishwanath Prathikanti

Last Updated: 9 December 2019

