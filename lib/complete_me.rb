require './lib/node'

class CompleteMe
  attr_accessor :root, :substring_hash

  def initialize
    @root = Node.new
    @substring_hash ={}
  end

  def insert(string, node=@root)
    chars = string.chars
    if end_of_word_with_children?(chars, node)
      return
    elsif end_of_word?(chars, node)
      return
    elsif letter_is_not_a_child(node, chars)
      insert_new_child(node, chars)
    else
     move_to_next_node(node, chars)
    end
  end

  def end_of_word_with_children?(chars, node)
    node.flag = true if chars.empty? && !node.children.empty?
  end

  def end_of_word?(chars, node)
    node.flag = true  if chars.empty?
  end

  def insert_new_child(node, chars)
    node.insert_letter(chars[0])
    node = node.next_node(chars.shift)
    insert(chars.join,node)
  end
  
  def letter_is_not_a_child(node, chars)
    !node.children.include?(chars[0].to_sym)
  end

  def move_to_next_node(node,chars)
    node = node.next_node(chars.shift)
    insert(chars.join,node)
  end

  def count
    if root.children.empty?
      0
    else
      stack_count
    end
  end

  def stack_count(node=root)
    stack = []
    node.children.each_key do |key|
        stack.push(node.children[key])
    end
    counter(stack)
  end

  def counter(stack)
    nodes = 0
    while !stack.empty? do
      node = stack.pop
      nodes += 1 if node.flag
      stack_push(node, stack)
    end
    nodes
  end

  def stack_push(object,array)
    object.children.each_key do |key|
      array.push(object.children[key])
    end
  end

  def populate(dictionary)
    dictionary = dictionary.split("\n")
    dictionary.each{ |word| insert(word) }
  end

  def suggest(substring)
    start = down_to_node(substring)
    suggestions = traverse_trie(start, substring).sort
    check_weighting(substring, suggestions)
  end

  def down_to_node(substring, node=root)
    return node if substring.empty?
    node_path = substring.split('')
    node = node.next_node(node_path.shift)
    substring = node_path.join
    down_to_node(substring, node)
  end

  def traverse_trie(node, prefix, suggestions=[])
    if node.flag && node.children.empty?
      return prefix
    elsif node.flag
      suggestions << prefix
    end
    check_each_child(prefix, suggestions, node)
    clean_up_suggestions(suggestions)
  end
  
  def check_each_child(prefix, suggestions, node)
    node.children.each_key do |k|
        prefix = prefix + k.to_s
        push_suggestion(suggestions, node, k, prefix)
        prefix = prefix[0..(prefix.length-2)]
    end
  end

  def push_suggestion(suggestions, node, key, prefix)
    suggestions.push(traverse_trie(node.children[key],prefix, suggestions))
  end

  def check_weighting(substring, suggestions)
    if substring_hash.keys.include?(substring)
      move_up_weighted_suggestion(substring, suggestions)
    else
      suggestions
    end
  end

  def move_up_weighted_suggestion(substring, suggestions)
    top_hit = find_top_hit(substring)
    suggestions.delete(top_hit)
    suggestions.unshift(top_hit)
  end

  def find_top_hit(substring)
     key =substring_hash[substring].values.max
     substring_hash[substring].key(key)
  end

  def clean_up_suggestions(suggestions)
    suggestions.map!{|sug| sug if sug.is_a?(String)}.compact!
  end

  def select(substring, selection)
    if substring_tracked_but_has_value?(substring, selection)
       substring_hash[substring][selection] = 1
    elsif substring_hash.keys.include?(substring)
      substring_hash[substring][selection] += 1
    else
      create_selection_hash(selection, substring)
    end
  end

  def substring_tracked_but_has_value?(substring, selection)
    substring_hash.keys.include?(substring) && !substring_hash[substring].keys.include?(selection)
  end

  def create_selection_hash(selection, substring)
    selection_hash = {}
    selection_hash[selection] = 1
    substring_hash[substring] = selection_hash
  end

  def delete_word(string)
    node = down_to_node(string)
    if !node.children.empty?
      node.flag = false
    else
      prune_tree(string, node)
    end
  end

  def prune_tree(string, node)
    return if string.empty?
    key = string[-1].to_sym
    string.chop!
    node = down_to_node(string)

    if node.children.keys.count == 1
      node.children = {}
      prune_tree(string, down_to_node(string))
    else
      node.children.delete(key)
      return
    end
  end
end
