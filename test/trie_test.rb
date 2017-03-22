require 'minitest/autorun'
require 'minitest/pride'
require './lib/trie'
require 'pry'
# require './lib/node'

class TrieTest < Minitest::Test
  def test_it_exists
    trie = Trie.new
    assert_instance_of Trie, trie
  end
  
  def test_it_initializes_with_node
    trie = Trie.new
    assert_instance_of Node, trie.root
  end

  def test_it_can_add_symbols_with_nodes
    trie = Trie.new
    trie.root.children[:a] = Node.new
    assert_instance_of Node, trie.root.children[:a]
  end
  def test_it_can_insert_letter
    trie = Trie.new
    trie.insert("p")
    expected = [:p]
    assert_equal expected, trie.root.children.keys
  end
  def test_it_can_insert_word
    trie = Trie.new
    trie.insert("pit")
    expected = [:p]
    assert_equal expected, trie.root.children.keys
    expected = [:i]  
    assert_equal expected, trie.root.children[:p].children.keys
    expected = [:t]  
    assert_equal expected, trie.root.children[:p].children[:i].children.keys
  end

  def test_it_can_count
    # skip
    trie = Trie.new
    trie.insert("aa")
    trie.insert("a")
    trie.insert("A")
    trie.insert("aal")
    trie.insert("aalii")
    trie.insert("aam")
    trie.insert("Aani")
    trie.insert("aardvark")
    trie.insert("aardwolf")
    assert_equal 9, trie.count
  end
  def test_it_can_count_bigger
    skip
    trie = Trie.new
    dictionary = File.read("/usr/share/dict/words")
    trie.populate(dictionary)
    assert_equal 235886, trie.count
  end
  def test_it_can_suggest_big
    trie = Trie.new
    dictionary = File.read("/usr/share/dict/words")
    trie.populate(dictionary)
    expected = 991
    assert_equal expected, trie.suggest("do").count
  end
  def test_down_to_node
    trie = Trie.new
    trie.insert("pizza")
    expected = [:z]
    assert_equal expected, trie.down_to_node("piz").children.keys
  end
  def test_suggestion
    trie = Trie.new
    trie.insert("pizza")
    trie.insert("pizzeria")
    trie.insert("pize")
    expected = ["pize", "pizza", "pizzeria"]
    assert_equal expected, trie.suggest("piz") 
  end
  def test_suggestion
    trie = Trie.new
    trie.insert("do")
    trie.insert("dood")
    trie.insert("dont")
    trie.insert("dog")
    expected = ["do", "dog", "dont", "dood"]
    assert_equal expected, trie.suggest("do") 
  end
  def test_select
    trie = Trie.new
    trie.insert("pizza")
    trie.insert("pizzeria")
    trie.insert("pize")
    trie.suggest("piz")
    trie.select("piz", "pizza")
    trie.select("piz", "pizza")
    trie.select("piz", "pizza")
    assert_equal 3, trie.substring_hash["piz"]["pizza"]
  end
  def test_weighting
    trie = Trie.new
    trie.insert("pizza")
    trie.insert("piza")
    trie.insert("pizo")
    trie.suggest("piz")
    trie.select("piz", "pizza")
    result = trie.suggest("piz")
    expected = ["pizza", "piza", "pizo"]
    assert_equal expected, result
  end
end