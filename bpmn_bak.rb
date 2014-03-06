# encoding: utf-8
$:.push File.expand_path('..',__FILE__)
require 'graph'

$NODES = []
$FLOWS = []
$LINES = []
$CYCLES = []

$PATHS = []

$STACK = []

class BpmObject
  attr_accessor :id

end

class ElementObject < BpmObject
  attr_accessor :name
end

class Node < ElementObject
  attr_accessor :type, :weight, :status, :outgoings_id, :incomings_id
  
  def next_node
    return_nodes = $NODES.select do |n| 
      return_flows = $FLOWS.select do |f|
        f.id == self.outgoings_id.first
      end
      n.id == return_flows.first.target_node_id
    end
    
    return return_nodes.first
  end

end

class StartNode < Node
  
end

class EndNode < Node
  
end

class TaskNode < Node
end

class GatewayNode < Node
  attr_accessor :avaliable_count

  def next_nodes
    temp_flows = $FLOWS.select do |f|
      self.outgoings_id.include?(f.id) and f.blocked != true
    end
    
    tm_string = []
    
    temp_flows.each do |tf|
      tm_string.push tf.target_node_id
    end

    return_nodes = $NODES.select do |n|
      tm_string.include?(n.id)
    end
    
    return return_nodes
  end
end

class Flow < ElementObject
  attr_accessor :source_node_id, :target_node_id, :status, :blocked

end

class Swimlane < ElementObject
end

class Group < ElementObject
end

class ProcessObject < BpmObject
  attr_accessor :node_seq
  
  def node_string
    temp = ""
    
    self.node_seq.each do |ns|
      if temp != ""
        temp = temp + '>' + ns.name
      else
        temp = ns.name
      end
    end
    return temp
  end
end

class Line < ProcessObject

end

class Cycle < ProcessObject
  attr_accessor :key_node, :key_flow
  
  def init_key_flow(node)
    temp_flow = $FLOWS.select do |f|
      f.source_node_id == self.key_node.id and \
      f.target_node_id == node.id
    end
    self.key_flow = temp_flow.first
  end
end

class Path < ProcessObject
  attr_accessor :mark

end

#public function
def nodes_to_string(node_seq)
  temp = ""
  
  node_seq.each do |ns|
    if temp != ""
      temp = temp + '>' + ns.name
    else
      temp = ns.name
    end
  end
  return temp
end

class Analitic
  #@graph = GraphTwo.new
  
  def go(start_node)
    get_cycles(start_node)
    $STACK.clear
    get_lines(start_node)
    get_paths
  end

  def get_cycles(node)
    if $STACK.include?(node)
      temp_stack = []
      temp_cycle = []
      temp_stack = $STACK.clone

      #取环
      loop do
        temp_cycle.push temp_stack.last
        temp_stack.pop
        if  temp_stack.last == node
          temp_cycle.push node
          break
        end
      end
      @cycle = Cycle.new
      @cycle.node_seq = temp_cycle.reverse
          
      #取成环节点
      loop do
        if $STACK.last.type == 'GatewayNode'
          @cycle.key_node = $STACK.last
          @cycle.init_key_flow(node)
          @cycle.key_flow.blocked = true
          $STACK.last.avaliable_count = $STACK.last.avaliable_count - 1
          break
        else
          $STACK.pop
        end
      end
      $CYCLES.push @cycle
    else
      $STACK.push node
      #puts 'stack is [' + $STACK.length.to_s + ']'
      case $STACK.last.type
      when 'StartNode'
        node.status = 1 
        node = node.next_node
        self.get_cycles(node)      
      when 'TaskNode'
        node.status = 1 
        node = node.next_node
        self.get_cycles(node)
      when 'GatewayNode'
        node.status = 1 
        nodes = node.next_nodes
        nodes.each do |n|
          self.get_cycles(n)
          while $STACK.last != node do
            $STACK.pop
          end
        end
      when 'EndNode'
        while $STACK.last.type != 'GatewayNode' do
          $STACK.pop
        end
      else
        puts 'error type' + $STACK.last.type
      end
    end
  end  

  def get_lines(node)
    $STACK.push node

    case $STACK.last.type
    when 'StartNode'
      node.status = 1 
      node = node.next_node
      self.get_lines(node)      
    when 'TaskNode'
      node.status = 1 
      node = node.next_node
      self.get_lines(node)
    when 'GatewayNode'
      node.status = 1 
      nodes = node.next_nodes

      nodes.each do |n|
        node.avaliable_count = node.avaliable_count - 1
        self.get_lines(n)
      end
    when 'EndNode'
      @line = Line.new
      @line.node_seq = $STACK.reverse.reverse
      $LINES.push @line
#      p '完成一条line添加' + @line.node_string
      
      loop do        
        if $STACK.length > 0 

          if $STACK.last.type == 'GatewayNode'  and $STACK.last.avaliable_count > 0 
#            p '当前gateway的出口数为' + $STACK.last.name + '[' + $STACK.last.avaliable_count.to_s + ']'
            break
          else
            $STACK.pop
          end
        else
          break
        end
      end
      
#      p '当前栈为' + $STACK.to_s
    else
      p 'error type' + $STACK.last.type
    end   
  end
  
  def get_paths
    
    $LINES.each do |line|

      $PATHS.push line
      $CYCLES.each do |cycle|
        head = []
        tail = []
        
        if line.node_seq.include?(cycle.key_node)
          line.node_seq.each do |node|
            if node != cycle.key_node 
              head.push node
            else
              head.push cycle.key_node 
              break
            end
          end
          tail = line.node_seq - head

          @path = Path.new
          @path.node_seq = head + cycle.node_seq + tail
          $PATHS.push @path
        end
      end
    end
  end
  
end

def get_start_node
  x = $NODES.select do |n|
    n.type == 'StartNode'
  end
    
  return x.first
end

def ppp(type)
  case type
  when 'line'
    p '***** There is [' + $LINES.length.to_s + '] lines *****'
    $LINES.each do |path|
      p path.node_string
    end
  when 'cycle'
    p '***** There is [' + $CYCLES.length.to_s + '] cycles *****'
    $CYCLES.each do |path|
      p path.node_string
    end
  when 'path'
    p '***** There is [' + $PATHS.length.to_s + '] paths *****'
    $PATHS.each do |path|
      p path.node_string
    end
  end
  p '------------------------------'
end

@graph = GraphFive.new

node = get_start_node
s = Analitic.new
s.go(node)

#ppp('cycle')
#ppp('line')
ppp('path')