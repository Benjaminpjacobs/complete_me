require_relative 'root_node'
require 'pry'

class Node

SYMBOLS = { a: 'a', b: 'b', c: 'c', d: 'd', e: 'e', 
            f: 'f', g: 'g', h: 'h', i: 'i', j: 'j', 
            k: 'k', l: 'l', m: 'm', n: 'n', o: 'n', 
            p: 'p', q: 'q', r: 'r', s: 's', t: 't', 
            u: 'u', v: 'v', w: 'w', x: 'x', y: 'y', 
            z: 'z'}

  attr_reader
  def initialize(child)
    self.instance_variable_set("@#{child}", child)
    self.class.__send__(:attr_accessor, "#{child}")
  end

  def add(child)
    self.instance_variable_set("@#{child}", child)
    self.class.__send__(:attr_accessor, "#{child}")
  end

  def find(letter)
    instance_variable_get("@#{letter}")
  end

  def input(array)
    array.each do |letter|
      if find(letter)
        #input on that instance variable 
      else
        add(letter)
      end
    end
  end
end