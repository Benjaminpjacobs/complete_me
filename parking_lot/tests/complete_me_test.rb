# gem "minitest"
require "minitest/autorun"
require "minitest/pride"
require "./lib/trie"
require 'pry'

class TrieTest < Minitest::Test

  def test_it_has_root_when_initialized
    cm = Trie.new
    assert cm.root
  end

  def test_can_add_instance_variable_to_root
    cm = Trie.new
    cm.root.add('a')
    assert "a", cm.root.a
  end

  def test_can_add_node
    cm = Trie.new
    cm.root.add('a')
    cm.root.a = Node.new('b')
    assert_instance_of Node, cm.root.a
  end

  def test_it_can_add_instance_variable_to_node
    # skip
    cm = Trie.new
    cm.root.add('a')
    cm.root.a = Node.new('b')
    cm.root.a.add('c')
    assert "c", cm.root.a.c
  end
  def test_it_can_add_node_past_root_level
    cm = Trie.new
    cm.root.add('a')
    cm.root.a = Node.new('b')
    cm.root.a.add('c')
    cm.root.a.b = Node.new('c')
    assert_instance_of Node, cm.root.a.b
  end

  def test_split_root_node
    cm = Trie.new
    chars = cm.root.split("abc")
    assert_equal ['a', 'b', 'c'], chars
  end

  def test_input_unique_at_root_node
    cm = Trie.new
    # cm.root.input("p")
    # assert cm.root.a
    # assert cm.root.b
    # assert cm.root.c
    # refute cm.root.d
    binding.pry
  end

  def method_name
    
  end
end
