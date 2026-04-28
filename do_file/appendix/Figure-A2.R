rm(list = ls())
library(tidyverse)
library(data.table)
library(rjson)
library(quanteda)
library(quanteda.textmodels)
library(quanteda.textstats)
library(quanteda.textplots)
library(readtext)
library(devtools)
library(newsmap)
library(seededlda)
library(tm)
library(topicmodels)
library(ggplot2)
library(dplyr)
library(tidytext)

#### directory ####
# Set root to the top-level folder of this replication package
root   <- "PATH/TO/final_package_JLEO"
tddir   <- file.path(root, "data", "oc_news")
figures <- file.path(root, "output", "figures")
setwd(tddir)



#### import and manage data ####
textdata <- read.csv("oc_news_text_analysis.csv") %>%
  rename(text=main_text)

# remove punctuations and all the blank spaces #
textdata$text = str_remove_all(textdata$text, "[[:punct:]]")
textdata$text = str_squish(textdata$text)

# set to lower case #
textdata$text = tolower(textdata$text)

# identify specific italian stopwords (specific for this context, newspapers?) #
mystopw <- c("anni", "giorni", "esser", "essere", "dopo", "aver", "avere", "qualche", "tempo",
                 "ore", "potrebbe", "fa", "cartoni", "animati", "poco", "poche", "molto", "molte",
                 "davvero", "subito", "negl", "negli", "degl", "degli", "piu", "neg", "deg", "ap", "ult", 
                 "v", "ieri", "oggi", "sera", "pomeriggio", "mattina", "t", "ir", "vuol", "dire", "fare", "dare", 
                 "altri", "altro", "altre", "altra", "ce", "anni", "via", "volta", "maggior", "leonardo sciascia",
                 "mila", "pubblico", "visione", "colori", "fra laltro", "quel momento", "prima visione", "prime visioni",
                 "prima vision", "tel orario")


# general stopwords from pre-existing dataset (trained stopwords) #
stopw_char <- c(stopwords("italian"), mystopw)
stopw <- data.frame(word = stopw_char)


## create a corpus of documents
#  a corpus is a structured collection of texts or documents that is used as 
#  the basis for linguistic or content analysis. 
mycorpus = corpus(textdata, docid_field = 'id')

# prepocess procedure. from each document of the corpus (basically from each text files) we remove:
# url, numbers, symbols, furhter punctuations, we apply the stemmatizaion (reduces words to their base or root form by stripping suffixes and prefixes),
# we remove the stopwords, and it transform the text in bigrams:converts a tokenized text into bigrams
mydfm <- tokens(mycorpus, remove_symbols = T, remove_url = T, remove_numbers = T) %>%
  tokens_wordstem(language = quanteda_options("language_stemmer")) %>%
  tokens_remove("\\p{P}", valuetype = "regex", padding = T) %>%
  tokens_remove(stopw_char, padding  = T) %>%
  tokens_remove("\\d+", valuetype = "regex", padding = T) %>%
  tokens_ngrams(n = 2)

# we remove the missing #
mydfm <- mydfm[lapply(mydfm,length)>0]
mydfm <- dfm(mydfm) 
  
# drop very rare words and very common words not able to identify with stopwords
# (there could another selection to follow depending on the number of bigrams)
myDfm_cleaned <- dfm_trim(mydfm, min_termfreq  = 100, min_docfreq = 10, 
                          docfreq_type = "count", verbose = TRUE)
final_dfm = convert(myDfm_cleaned, to = "topicmodels")


#### Topic modelling ####
# set the topic model, not need to explain this in detail I would say, just say that it assigns a weight to each topic for each document. 
myseed <- 1234
k     <- 20    # number of topics
# The alpha controls the mixture of topics for any given document. Turn it down, and the documents will likely have less of a mixture of topics. 
# Turn it up, and the documents will likely have more of a mixture of topics.
# Both alpha and beta depend on your symmetry assumption:
# -- Symmetric Distribution: alpha represents document-topic density - with a higher alpha, documents are made up of more topics, 
#                            and with lower alpha, documents contain fewer topics.
#
# -- Asymmetric Distribution: higher alpha results in a more specific topic distribution per document.
alpha <- 50/k       
# delta: this parameter specifies the parameter of the prior distribution of the term distribution over topics.
delta <- 0.1

# LDA ANALYSIS -----------------------------------------------
print(Sys.time())
# LDA 
# θ ∼ Dirichlet(α): where Dirichlet(α) denotes the Dirichlet distribution for parameter α 
# β ∼ Dirichlet(δ)
# The utmost goal of LDA is to estimate the θ and ϕ which is equivalent to estimate which words 
# are important for which topic and which topics are important for a particular document, respectively.
# The basic idea behind the parameters for the Dirichlet distribution ( here I’m referring to the symmetrical 
# version of the distribution, which is the general case for most LDA ) is: α The higher the value the more 
# likely each document is to contain a mixture of most of the topics instead of any single topic. The same goes 
# for η, where higher value denotes that each topic is likely to contain a mixture of most of the words and not 
# any word specifically.
model <- LDA(x = final_dfm, 
             k = 20, 
             method = "Gibbs", # per ottenere una sequenza di campioni casuali da una distribuzione di probabilità multivariata (cioè dalla distribuzione di probabilità congiunta di due o più variabili casuali) 
             control = list(seed   = 1234,
                            keep   = 100,     # keep max likelihood every 100 iterations.
                            iter   = 1000,    # iterations to run: Number of iterations to run gibbs sampling to train our model.
                            burnin = 1000,    # first 1000 iterations are burnt
                            #Since the starting point of gibbs sampling is chosen randomly, thus it makes sense to discard the first few iteration ( also known as burnin periods ). Due to the fact that they most likely do not correctly reflect the properties of distribution. 
                            alpha  = alpha,  
                            delta  = delta))


# extract the betas, the weights for each words and use these betas to understand the topics
# the words with a higher betas are the words more related to a specific topic
ap_topics <- tidy(model, matrix = "beta")

# from this file you can construct the word cloud (basically it is what is doing the next part of the code). Here you will have the 10 prefferred words, but you can add 20, 30....
ap_top_terms <- ap_topics %>%
  group_by(topic) %>%
  slice_max(beta, n = 10) %>% 
  ungroup() %>%
  arrange(topic, -beta)

# plot
plot <- ap_top_terms %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(beta, term, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  scale_y_reordered()

# common plot #
setwd(figures)
ggsave("Figure-A2.png", plot, dpi = 300, width = 10, height = 8, scale = 1.5)   # save it
