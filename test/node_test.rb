require 'minitest/autorun'
require 'minitest/pride'
require './lib/node'
require 'pry'

class NodeTest < Minitest::Test
  def test_node_exists
    node = Node.new
    assert_instance_of Node, node
  end

  def test_it_has_instance_variable
    node = Node.new
    assert_instance_of Hash, node.children
  end
  
  def test_can_populate_hash_with_node
    node = Node.new
    node.children = Node.new
    assert_instance_of Hash, node.children.children
  end
  
  def test_can_add_symbols_to_node
    node = Node.new
    node.children[:a] = {}
    expected = {}
    assert_equal expected, node.children[:a]
  end

  def test_can_dynamically_add_symbols_and_nodes
    node = Node.new
    node.insert_letter("a")
    expected = [:a]
    assert_equal expected, node.children.keys
    # binding.pry
  end
  def test_can_go_to_node
    node = Node.new
    node.insert_letter("a")
    node.children[:a].insert_letter("b")
    actual = node.to_node('a').children.keys
    expected = [:b]
    assert_equal expected, actual
    
    binding.pry
  end
end