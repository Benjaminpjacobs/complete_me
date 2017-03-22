require './lib/node'
require 'pry'

class Trie
  attr_accessor :root

  LOOKUP = { a: 'a', b: 'b', c: 'c', d: 'd', e: 'e', 
            f: 'f', g: 'g', h: 'h', i: 'i', j: 'j', 
            k: 'k', l: 'l', m: 'm', n: 'n', o: 'o', 
            p: 'p', q: 'q', r: 'r', s: 's', t: 't', 
            u: 'u', v: 'v', w: 'w', x: 'x', y: 'y', 
            z: 'z', 
            
            A: 'A', B: 'B', C: 'D', D: 'D', E: 'E', 
            F: 'F', G: 'G', H: 'H', I: 'I', J: 'J', 
            K: 'K', L: 'L', M: 'M', N: 'N', O: 'O', 
            P: 'P', Q: 'Q', R: 'R', S: 'S', T: 'T', 
            U: 'U', V: 'V', W: 'W', X: 'X', Y: 'Y', 
            Z: 'Z'}
          
  def initialize
    @root = Node.new
  end

  def insert(string, node=@root)
    chars = string.chars
    if chars.empty?
      node.flag = true 
      return
    elsif !node.children.include?(LOOKUP.key(chars[0]))
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
    # binding.pry
    return node if substring.empty?
    node_path = substring.split('')
    node = node.next_node(node_path.shift)
    substring = node_path.join
    down_to_node(substring, node)
  end

  # def word_collect(node=root, suggestions=[], array=[], in_line_find=[])
  #   # binding.pry
  #   if node.children.empty?
  #     in_line_find << array.join
  #     return in_line_find
  #   elsif node.children.keys.count > 1
  #     iterate_down(node, suggestions)
  #   elsif node.flag
  #     in_line_find.push(array.join)
  #     symbol = node.children.keys.last
  #     array << LOOKUP[node.children.keys.last]
  #     word_collect(node.children[symbol], suggestions, array, in_line_find)
  #   else
  #     array << LOOKUP[node.children.keys.last]
  #     symbol = node.children.keys.last
  #     word_collect(node.children[symbol], suggestions, array, in_line_find)
  #   end
  # end

  # def iterate_down(node, suggestions=[])
  #     node.children.keys.each do |key|
  #       array = word_collect(node.children[key], suggestions)
  #       binding.pry
  #       array.map!{|word| key.to_s + word}
  #       suggestions << array
  #     end
  #     suggestions.flatten
  # end

  def suggest(substring)
    start = down_to_node(substring)
    traverse_trie(start, substring)
  end

  def traverse_trie(node, prefix, suggestions=[])
    # binding.pry
      if node.flag && node.children.empty?
        return prefix
      elsif node.flag
        suggestions << prefix
    end
      node.children.each_key do |k|
          prefix = prefix + k.to_s
          suggestions.push(traverse_trie(node.children[k],prefix, suggestions))
          prefix = prefix[0..(prefix.length-2)]
      # binding.pry
    end
    suggestions.map!{|sug| sug if sug.is_a?(String)}.compact!
  end

  def navigate_to_substring(node=root, letter)
      node = node.children[LOOKUP.key(letter)]
  end

end


''