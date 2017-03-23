require './test/test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/complete_me'

class CompleteMeTest < Minitest::Test
  def test_it_exists
    cm = CompleteMe.new
    assert_instance_of CompleteMe, cm
  end
  
  def test_it_initializes_with_node
    cm = CompleteMe.new
    assert_instance_of Node, cm.root
  end

  def test_it_can_add_symbols_with_nodes
    cm = CompleteMe.new
    cm.root.children[:a] = Node.new
    assert_instance_of Node, cm.root.children[:a]
  end

  def test_it_can_insert_letter
    cm = CompleteMe.new
    cm.insert("p")
    cm.insert("n")
    cm.insert("g")
    expected = [:p, :n, :g]
    assert_equal expected, cm.root.children.keys
  end

  def test_it_can_insert_word
    cm = CompleteMe.new
    cm.insert("pit")
    expected = [:p]
    assert_equal expected, cm.root.children.keys
    expected = [:i]  
    assert_equal expected, cm.root.children[:p].children.keys
    expected = [:t]  
    assert_equal expected, cm.root.children[:p].children[:i].children.keys
  end

  def test_end_of_word_with_children
    cm = CompleteMe.new
    cm.insert("pi")
    cm.end_of_word_with_children?('',cm.root.children[:p])
    assert cm.root.children[:p].flag
  end

  def test_end_of_word
    cm = CompleteMe.new
    cm.insert('p')
    cm.root.children[:p].flag = false
    cm.end_of_word?('', cm.root.children[:p])
    assert cm.root.children[:p].flag
  end

  def test_insert_new_child
    cm = CompleteMe.new
    cm.insert_new_child(cm.root, ["c", "a", "t"])
    assert cm.root.children[:c].children[:a].children[:t].flag
  end

  def test_it_can_count_zero
    cm = CompleteMe.new
    assert_equal 0, cm.count
  end

  def test_it_can_count
    cm = CompleteMe.new
    cm.insert("aa")
    cm.insert("a")
    cm.insert("A")
    cm.insert("aal")
    cm.insert("aalii")
    cm.insert("aam")
    cm.insert("Aani")
    cm.insert("aardvark")
    cm.insert("aardwolf")
    assert_equal 9, cm.count
  end

  def test_it_can_count_bigger
    cm = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    cm.populate(dictionary)
    assert_equal 235886, cm.count
  end

  def test_it_can_suggest_big
    cm = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    cm.populate(dictionary)
    expected = 991
    assert_equal expected, cm.suggest("do").count
end

  def test_down_to_node
    cm = CompleteMe.new
    cm.insert("pizza")
    expected = [:z]
    assert_equal expected, cm.down_to_node("piz").children.keys
  end

  def test_suggestion
    cm = CompleteMe.new
    cm.insert("pizza")
    cm.insert("pizzeria")
    cm.insert("pize")
    expected = ["pize", "pizza", "pizzeria"]
    assert_equal expected, cm.suggest("piz") 
  end

  def test_suggestion
    cm = CompleteMe.new
    cm.insert("do")
    cm.insert("dood")
    cm.insert("dont")
    cm.insert("dog")
    expected = ["do", "dog", "dont", "dood"]
    assert_equal expected, cm.suggest("do") 
  end

  def test_select
    cm = CompleteMe.new
    cm.insert("pizza")
    cm.insert("pizzeria")
    cm.insert("pize")
    cm.suggest("piz")
    cm.select("piz", "pizza")
    cm.select("piz", "pizza")
    cm.select("piz", "pizza")
    assert_equal 3, cm.substring_hash["piz"]["pizza"]
  end
  def test_weighting
    cm = CompleteMe.new
    cm.insert("pizza")
    cm.insert("piza")
    cm.insert("pizo")
    cm.suggest("piz")
    cm.select("piz", "pizza")
    result = cm.suggest("piz")
    expected = ["pizza", "piza", "pizo"]
    assert_equal expected, result
  end

  def test_substring_specific_tracking
    cm = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    cm.populate(dictionary)
    cm.select("piz", "pizzeria")
    cm.select("piz", "pizzeria")
    cm.select("piz", "pizzeria")
    cm.select("pi", "pizza")
    cm.select("pi", "pizza")
    cm.select("pi", "pizzicato")
    cm.select("pi", "pizzicato")
    cm.select("pi", "pizzicato")
    assert_equal "pizzeria", cm.suggest("piz")[0]
    assert_equal "pizzicato", cm.suggest("pi")[0]
  end

  def test_delete_intermediate_node
    cm = CompleteMe.new
    cm.insert("do")
    cm.insert("dog")
    assert_equal "dog",  cm.suggest("d")[1]
    cm.delete_word("do")
    assert_equal 1, cm.suggest("d").count
  end

  def test_delete_leaf_node
    cm = CompleteMe.new
    cm.insert("ab")
    cm.insert("abc")
    cm.insert("abcoop")
    cm.insert("abcaad")
    assert_equal "abcaad", cm.suggest("ab")[2]
    cm.delete_word("abcaad")
    expected = cm.suggest("ab")
    refute expected.include?("abcaad")
  end
end