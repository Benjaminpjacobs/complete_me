# Complete Me

Everyone in today’s smartphone-saturated world has had their share of interactions with textual “autocomplete.” 
You may have sometimes even wondered if autocomplete is worth the trouble, given the ridiculous completions it sometimes attempts.

This is an attempt at creating one from scratch in pure ruby.

## Data Structure

This solution utilizes a data structure called a Trie. The name comes from the idea of a Re-trie-val tree, 
and it’s useful for storing and then fetching paths through arbitrary (often textual) data.

A Trie is somewhat similar to the binary trees you may have seen before, 
but whereas each node in a binary tree points to up to 2 subtrees, 
nodes within our retrieval tries will point to N subtrees, 
where N is the size of the alphabet we want to complete within.

Thus for a simple latin-alphabet text trie, each node will potentially have 26 children, 
one for each character that could potentially follow the text entered thus far. 
(In graph theory terms, we could classify this as a Directed, Acyclic graph of order 26, but hey, who’s counting?)

What we end up with is a broadly-branched tree where paths 
from the root to the leaves represent “words” within the dictionary.

Of course, a Trie wouldn't be very useful without a good dataset to populate it. 
Fortunately, most computers ship with a special file containing a list of standard dictionary words. 
It lives at /usr/share/dict/words

Using the unix utility wc (word count), we can see that the file contains 235886 words:

```
$ cat /usr/share/dict/words | wc -l
235886
```

Should be enough for us!

## Features

Inserts a single word to the autocomplete dictionary
Counts the number of words in the dictionary
Populates a newline-separated list of words into the dictionary
Suggests completions for a substring
Marks a selection for a substring
Weights subsequent suggestions based on previous selections
Basic Interaction Model

### Interaction Pattern

```
# open pry from root project directory
require "./lib/complete_me"

completion = CompleteMe.new

completion.insert("pizza")

completion.count
=> 1

completion.suggest("piz")
=> ["pizza"]

dictionary = File.read("/usr/share/dict/words")

completion.populate(dictionary)

completion.count
=> 235886

completion.suggest("piz")
=> ["pize", "pizza", "pizzeria", "pizzicato", "pizzle"]
```

### Usage Weighting

The common gripe about autocomplete systems is that they give us suggestions that are technically valid 
but not at all what we wanted.

A solution to this problem is to “train” the completion dictionary over time based on the user’s actual selections. 
So, if a user consistently selects “pizza” in response to completions for “pizz”, 
it probably makes sense to recommend that as their first suggestion.

To facilitate this, this library supports a select method which takes a substring and the selected suggestion. 
This selection is recorded and used to influence future selections to make.

```
require "./lib/complete_me"

completion = CompleteMe.new

dictionary = File.read("/usr/share/dict/words")

completion.populate(dictionary)

completion.suggest("piz")
=> ["pize", "pizza", "pizzeria", "pizzicato", "pizzle", ...]

completion.select("piz", "pizzeria")

completion.suggest("piz")
=> ["pizzeria", "pize", "pizza", "pizzicato", "pizzle", ...]
```

### Substring-Specific Selection Tracking
```
require "./lib/complete_me"

completion = CompleteMe.new

dictionary = File.read("/usr/share/dict/words")

completion.populate(dictionary)

completion.select("piz", "pizzeria")
completion.select("piz", "pizzeria")
completion.select("piz", "pizzeria")

completion.select("pi", "pizza")
completion.select("pi", "pizza")
completion.select("pi", "pizzicato")

completion.suggest("piz")
=> ["pizzeria", "pize", "pizza", "pizzicato", "pizzle", ...]

completion.suggest("pi")
=> ["pizza", "pizzicato", "pize", "pizzeria", "pizzle", ...]
```
