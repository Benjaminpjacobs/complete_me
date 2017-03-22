require 'pry'
require_relative 'node'

class RootNode
  
  SYMBOLS = { a: 'a', b: 'b', c: 'c', d: 'd', e: 'e', 
              f: 'f', g: 'g', h: 'h', i: 'i', j: 'j', 
              k: 'k', l: 'l', m: 'm', n: 'n', o: 'n', 
              p: 'p', q: 'q', r: 'r', s: 's', t: 't', 
              u: 'u', v: 'v', w: 'w', x: 'x', y: 'y', 
              z: 'z'}


  def add(child)
    self.instance_variable_set("@#{child}", child)
    self.class.__send__(:attr_accessor, "#{child}")
  end
  def find(letter)
    instance_variable_get("@#{letter}")
  end
  def input(string)
    chars = split(string)
    return 1 if chars.empty?
    letter = chars.shift
    if self.find(letter)
      input(chars.join)
    else
      set_new_node(letter, letter)
      input(chars.join)
    end
  end
  def set_new_node(parent, child)
    self.instance_variable_set("@#{parent}", Node.new(child))
  end
  def split(string)
    chars = string.chars
  end
end
