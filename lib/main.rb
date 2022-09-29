class Node
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree

  def initialize(array)
    @array = array.sort.uniq
    @root = build_tree(@array)
  end

  def build_tree(array)
    return if (0 == array.length)

    mid = array.length / 2
    root = Node.new(array[mid])

    root.left = build_tree(array[0...mid])
    root.right = build_tree(array[mid+1..-1])

    return root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(key, root = @root)
    return Node.new(key) if root == nil
    return root if root == key

    if key > root.data
      root.right = insert(key, root.right)
    else
      root.left = insert(key, root.left)
    end
    root
  end

  def min_value(root)
    current = root

    while(current.left != nil)
      current = current.left
    end
    return current
  end

  def delete(key, root = @root)
    return root if root == nil

    if key < root.data
      root.left = delete(key, root.left)
    elsif key > root.data
      root.right = delete(key, root.left)
    else 
      if root.left == nil
        temp = root.right
        root.right = nil
        root = nil
        return temp
      elsif root.right == nil
        temp = root.left
        root.left = nil
        root = nil
        return temp
      end
      temp = min_value(root.right)
      root.data = temp.data
      root.right = delete(temp.data, root.right)
    end
    return root
  end

  def find(key, root = @root)
    return nil if root == nil
    return root if root.data == key

    if key > root.data
      find(key, root.right)
    else
      find(key, root.left)
    end
  end

  def level_order
    queue = [@root]
    result = []
    until queue.empty?
      root = queue.shift
      block_given? ? yield(root) : result << root.data
      queue << root.left unless root.left.nil?
      queue << root.right unless root.right.nil?
    end

    result unless block_given?
  end

  def pre_order(root = @root, result = [], &block)
    return if root == nil

    result.push(block_given? ? block.call(root) : root.data)
    pre_order(root.left, result, &block)
    pre_order(root.right, result, &block)

    result
  end

  def in_order(root = @root, result = [], &block)
    return if root == nil

    in_order(root.left, result, &block)
    result.push(block_given? ? block.call(root) : root.data)
    in_order(root.right, result, &block)

    result
  end 

  def post_order(root = @root, result = [], &block)
    return if root == nil

    post_order(root.right, result, &block)
    post_order(root.left, result, &block)
    result.push(block_given? ? block.call(root) : root.data)

    result
  end

  def height(node = @root, count = -1)
    return count if node.nil?

    count += 1
    [height(node.left, count), height(node.right, count)].max
  end

  def depth(node)
    return nil if node.nil?

    current_node = @root
    count = 0
    until node.data == current_node.data
      count += 1
      current_node = current_node.left if node.data < current_node.data
      current_node = current_node.right if node.data > current_node.data
    end

    count
  end

  def balanced?
    left = height(@root.left, 0)
    right = height(@root.right, 0)
    (left - right).between?(-1, 1)
  end

  def rebalance!
    values = in_order
    p values
    @root = build_tree(values)
  end
end

test = Tree.new([1, 2, 3, 4, 6, 7, 8])

test.insert(5)
test.pretty_print
puts
puts
puts
test.delete(2)
test.pretty_print
p test.find(5)
p test.level_order
test.pre_order
puts
p test.in_order
puts
test.post_order
puts
puts test.height
puts 
puts test.depth(test.find(1))

test.insert(9)
test.insert(10)
test.insert(11)
test.pretty_print
puts test.balanced?
test.rebalance!
test.pretty_print

