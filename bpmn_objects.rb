class BpmObject
  attr_accessor :id
  
end

class ElementObject < BpmObject
  attr_accessor :name
end

class Node < ElementObject
  attr_accessor :type, :weight, :status, :outgoings_id, :incomings_id
  
  def next_node(graph)
    return_nodes = graph.nodes.select do |n| 
      return_flows = graph.flows.select do |f|
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

  def next_nodes(graph)
    temp_flows = graph.flows.select do |f|
      self.outgoings_id.include?(f.id) and f.blocked != true
    end
    
    tm_string = []
    
    temp_flows.each do |tf|
      tm_string.push tf.target_node_id
    end

    return_nodes = graph.nodes.select do |n|
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
  attr_accessor :flow_seq
  
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

  def flow_seq(graph)
    return_flow_seq = []
    i = 0
   
    node_seq.each do |n|
      next_index = i + 1
      next_node = node_seq[next_index]
      if next_node != nil
        return_flow_seq.push get_flow_between_nodes(n,next_node,graph)[0]
      end
      i = i + 1
    end
    return return_flow_seq
  end
  
  def get_flow_between_nodes(node1,node2,graph)
    graph.flows.select do |f|
      f.source_node_id == node1.id and f.target_node_id == node2.id
    end
  end
end

class Line < ProcessObject

end

class Cycle < ProcessObject
  attr_accessor :key_node, :key_flow
  
  def init_key_flow(graph,node)
    temp_flow = graph.flows.select do |f|
      f.source_node_id == self.key_node.id and \
      f.target_node_id == node.id
    end
    self.key_flow = temp_flow.first
  end
end

class Path < ProcessObject
  attr_accessor :mark
  
end