require './lib/node'
require 'pry'

class CompleteMe
  attr_accessor :root, :substring_hash


  def initialize
    @root = Node.new
    @substring_hash ={}
  end

  def insert(string, node=@root)
    chars = string.chars
    if chars.empty? && !node.children.empty?
      node.flag = true
      return
    elsif chars.empty?
      node.flag = true 
      return
    elsif !node.children.include?(chars[0].to_sym)
      node.insert_letter(chars[0])
      node = node.next_node(chars.shift)
      insert(chars.join,node)
    elsif
      node = node.next_node(chars.shift)
      insert(chars.join,node)
    end
  end

  def populate(dictionary)
    dictionary = dictionary.split("\n")
    dictionary.each do |word|
      insert(word)
    end
  end

  def count(node=root, stack = [])
    return 0 if node.children.empty?
    array = []
    stack = []
    node.children.each_key do |key|
        stack.push(node.children[key])
    end
    
    while !stack.empty? do
      node = stack.pop
      array << node.count
      node.children.each_key do |key|
        stack.push(node.children[key])
      end
    end
    p array.inject(&:+)
  end

  def down_to_node(substring, node=root)
    return node if substring.empty?
    node_path = substring.split('')
    node = node.next_node(node_path.shift)
    substring = node_path.join
    down_to_node(substring, node)
  end

  def suggest(substring)
    start = down_to_node(substring)
    suggestions = traverse_trie(start, substring).sort
    if substring_hash.keys.include?(substring)
      top_hit = substring_hash[substring].keys.first
      suggestions.delete(top_hit)
      suggestions.unshift(top_hit)
    else
      suggestions
    end
    
  end

  def traverse_trie(node, prefix, suggestions=[])
      if node.flag && node.children.empty?
        return prefix
      elsif node.flag
        suggestions << prefix
      end
      node.children.each_key do |k|
          prefix = prefix + k.to_s
          suggestions.push(traverse_trie(node.children[k],prefix, suggestions))
          prefix = prefix[0..(prefix.length-2)]
      end
    suggestions.map!{|sug| sug if sug.is_a?(String)}.compact!
  end

  def select(substring, selection)
    if substring_hash.keys.include?(substring)
      substring_hash[substring][selection] += 1
    else
      selection_hash = {}
      selection_hash[selection] = 1
      substring_hash[substring] = selection_hash
    end
  end
end
