require 'pp'

Node = Struct::new(:text, :level, :children) do
  def to_s
  	to_hash.to_s
  end

  def to_hash
  	{ text: text, level: level, children: children.map(&:to_hash) }
  end
end

module NodesProvider
  module_function

  KEYBOARD_INPUT = 1
  RANDOM_INIT = 2
  ONLY_LEVEL_INPUT = 3

  def get_nodes(method)
	puts "Enter number of nodes"
	max_count = gets.to_i

	if method == KEYBOARD_INPUT
	  get_nodes_using_block(max_count) {
	    Node::new( get_text_from_input, get_level_from_input, [] )
	  }
	elsif method == RANDOM_INIT
	  get_nodes_using_block(max_count) {
	    Node::new( get_random_text, 1 + rand(5), [] )
	  }
	elsif method == ONLY_LEVEL_INPUT
	  get_nodes_using_block(max_count) {
	    Node::new( get_random_text, get_level_from_input, [] )
	  }
	else
	  raise "Method is not supported"
	end
  end

  def get_nodes_using_block(max_count)
    nodes = []
    (1..max_count).each do
      node = yield
      nodes.push(node)
    end
    nodes
  end

  def get_level_from_input
  	puts "enter level:"
  	gets.to_i
  end

  def get_text_from_input
  	puts "enter text:"
  	gets.chomp
  end

  def get_random_text
  	(0...8).map { (65 + rand(26)).chr }.join
  end

end

module TreeBuilder
  module_function

  def get_tree(nodes)
  	root = Node::new("Root", 0, [])
    parents = [root]
  	while nodes.any?
  	  node = nodes.shift
  	  parent = parents.at(node.level - 1)
  	  if parent
  	    parent.children.push(node)
  	    parents[node.level] = node
  	  else
  	  	puts "You have incorrect structure of your input data, no parent for #{node}"
  	  end
  	end
  	root
  end

end

puts "Enter type of nodes providing choosing from (1 = Keyboard input, 2 = Random inititialization, 3 = Enter only level(random text))"

nodes = NodesProvider.get_nodes(gets.to_i)
pp nodes

puts "Tree is : "
root = TreeBuilder.get_tree(nodes)
pp root.to_hash
