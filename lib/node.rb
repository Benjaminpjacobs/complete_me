require 'pry'
class Node
  attr_accessor :children, :flag
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
    @children = {}
    @flag = false
  end
  def insert_letter(letter)
    self.children[LOOKUP.key(letter)] = Node.new
  end
  def next_node(letter)
    self.children[LOOKUP.key(letter)]
  end
  def next_node_symbol(symbol)
    self.children[symbol]
  end
  def count
    if self.flag
      1
    else
      0
    end
  end
end
