require_relative "node"
require_relative "root_node"
require 'pry'

class Trie
  attr_accessor :root

  SYMBOLS = { a: 'a', b: 'b', c: 'c', d: 'd', e: 'e', 
            f: 'f', g: 'g', h: 'h', i: 'i', j: 'j', 
            k: 'k', l: 'l', m: 'm', n: 'n', o: 'n', 
            p: 'p', q: 'q', r: 'r', s: 's', t: 't', 
            u: 'u', v: 'v', w: 'w', x: 'x', y: 'y', 
            z: 'z'}
  def initialize
    @root = Node::RootNode.new
  end

  def input_word(string)
    chars = string.chars
    root.input(chars)
  end
end
