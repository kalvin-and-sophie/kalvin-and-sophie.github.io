# encoding: utf-8

class Graph
  def nodes
    return @nodes
  end
  
  def flows
    return @flows
  end
  
  def initialize(hash_graph)
    @nodes = []
    @flows = []

    hash_graph[:nodes].each do |k|
      case k[:type]
      when 'S'
        node = StartNode.new
        node.type = 'StartNode'
      when 'T'
        node = TaskNode.new
        node.type = 'TaskNode'
      when 'G'
        node = GatewayNode.new
        node.type = 'GatewayNode'
        node.outgoings_id = k[:outgoings_id]
        node.avaliable_count = node.outgoings_id.length
      when 'E'
        node = EndNode.new
        node.type = 'EndNode'
      end
      node.id = k[:id]
      node.name = k[:label]
      node.weight = k[:weight]
      node.status = 0
      node.outgoings_id = k[:outgoings_id]
      node.incomings_id = k[:incomings_id]
      
      @nodes.push node
    end
    
    hash_graph[:links].each do |k|
      flow = Flow.new
      flow.id = k[:id]
      flow.name = k[:label]
      flow.source_node_id = k[:source_id]
      flow.target_node_id = k[:target_id]
      flow.status = 0
      flow.blocked = 0
        
      @flows.push flow  
    end
  end
end

=begin
class GraphOne < Graph
  def initialize
    #开始节点
    @start_node = StartNode.new
    @start_node.id = '0'
    @start_node.name = 'S'
    @start_node.type = 'StartNode'
    @start_node.weight = 1
    @start_node.status = 0
    @start_node.outgoings_id = ['0_1']
    @start_node.incomings_id = []
    
    #网关节点
    @gateway_node = GatewayNode.new
    @gateway_node.id = '1'
    @gateway_node.name = 'G1'
    @gateway_node.type = 'GatewayNode'
    @gateway_node.weight = 1
    @gateway_node.status = 0
    @gateway_node.outgoings_id = ['1_1','1_2']
    @gateway_node.incomings_id = ['0_1']
    @gateway_node.avaliable_count = @gateway_node.outgoings_id.length
    
    #任务节点1
    @task_node1 = TaskNode.new
    @task_node1.id = '2'
    @task_node1.name = 'T1'
    @task_node1.type = 'TaskNode'
    @task_node1.weight = 1
    @task_node1.status = 0
    @task_node1.outgoings_id = ['2_1']
    @task_node1.incomings_id = ['1_1']
    
    #任务节点2
    @task_node2 = TaskNode.new
    @task_node2.id = '3'
    @task_node2.name = 'T2'
    @task_node2.type = 'TaskNode'
    @task_node2.weight = 1
    @task_node2.status = 0
    @task_node2.outgoings_id = ['3_1']
    @task_node2.incomings_id = ['1_2']
    
    #结束节点
    @end_node = EndNode.new
    @end_node.id = '4'
    @end_node.name = 'E'
    @end_node.type = 'EndNode'
    @end_node.weight = 1
    @end_node.status = 0
    @end_node.outgoings_id = []
    @end_node.incomings_id = ['2_1','3_1']
    
    #流1
    @flow1 = Flow.new
    @flow1.id = '0_1'
    @flow1.name = 'f1'
    @flow1.source_node_id = '0'
    @flow1.target_node_id = '1'
    @flow1.status = 0
    @flow1.blocked = 0
    
    #流2
    @flow2 = Flow.new
    @flow2.id = '1_1'
    @flow2.name = 'f2'
    @flow2.source_node_id = '1'
    @flow2.target_node_id = '2'
    @flow2.status = 0
    @flow2.blocked = 0
    
    #流3
    @flow3 = Flow.new
    @flow3.id = '1_2'
    @flow3.name = 'f3'
    @flow3.source_node_id = '1'
    @flow3.target_node_id = '3'
    @flow3.status = 0
    @flow3.blocked = 0
    
    #流4
    @flow4 = Flow.new
    @flow4.id = '2_1'
    @flow4.name = 'f4'
    @flow4.source_node_id = '2'
    @flow4.target_node_id = '4'
    @flow4.status = 0
    @flow4.blocked = 0
    
    #流5
    @flow5 = Flow.new
    @flow5.id = '3_1'
    @flow5.name = 'f5'
    @flow5.source_node_id = '3'
    @flow5.target_node_id = '4'
    @flow5.status = 0
    @flow5.blocked = 0
    
    @flows = [@flow1,@flow2,@flow3,@flow4,@flow5]
    @nodes = [@start_node,@gateway_node,@task_node1,@task_node2,@end_node]
  end
end

class GraphTwo < Graph
  def initialize
    #开始节点
    @start_node = StartNode.new
    @start_node.id = '0'
    @start_node.name = 'S'
    @start_node.type = 'StartNode'
    @start_node.weight = 1
    @start_node.status = 0
    @start_node.outgoings_id = ['0_1']
    @start_node.incomings_id = []
    
    #任务节点1
    @task_node1 = TaskNode.new
    @task_node1.id = '1'
    @task_node1.name = 'T1'
    @task_node1.type = 'TaskNode'
    @task_node1.weight = 1
    @task_node1.status = 0
    @task_node1.outgoings_id = ['1_1']
    @task_node1.incomings_id = ['0_1','4_2']
    
    #网关节点1
    @gateway_node1 = GatewayNode.new
    @gateway_node1.id = '2'
    @gateway_node1.name = 'G1'
    @gateway_node1.type = 'GatewayNode'
    @gateway_node1.weight = 1
    @gateway_node1.status = 0
    @gateway_node1.outgoings_id = ['2_1','2_2']
    @gateway_node1.incomings_id = ['1_1']
    @gateway_node1.avaliable_count = @gateway_node1.outgoings_id.length
    
    #任务节点2
    @task_node2 = TaskNode.new
    @task_node2.id = '3'
    @task_node2.name = 'T2'
    @task_node2.type = 'TaskNode'
    @task_node2.weight = 1
    @task_node2.status = 0
    @task_node2.outgoings_id = ['3_1']
    @task_node2.incomings_id = ['2_1']
    
    #网关节点2
    @gateway_node2 = GatewayNode.new
    @gateway_node2.id = '4'
    @gateway_node2.name = 'G2'
    @gateway_node2.type = 'GatewayNode'
    @gateway_node2.weight = 1
    @gateway_node2.status = 0
    @gateway_node2.outgoings_id = ['4_1','4_2']
    @gateway_node2.incomings_id = ['2_2']
    @gateway_node2.avaliable_count = @gateway_node2.outgoings_id.length
    
    #结束节点
    @end_node = EndNode.new
    @end_node.id = '5'
    @end_node.name = 'E'
    @end_node.type = 'EndNode'
    @end_node.weight = 1
    @end_node.status = 0
    @end_node.outgoings_id = []
    @end_node.incomings_id = ['3_1','4_1']
    
    #流1
    @flow1 = Flow.new
    @flow1.id = '0_1'
    @flow1.name = 'f1'
    @flow1.source_node_id = '0'
    @flow1.target_node_id = '1'
    @flow1.status = 0
    @flow1.blocked = 0
    
    #流2
    @flow2 = Flow.new
    @flow2.id = '1_1'
    @flow2.name = 'f2'
    @flow2.source_node_id = '1'
    @flow2.target_node_id = '2'
    @flow2.status = 0
    @flow2.blocked = 0
    
    #流3
    @flow3 = Flow.new
    @flow3.id = '2_1'
    @flow3.name = 'f3'
    @flow3.source_node_id = '2'
    @flow3.target_node_id = '3'
    @flow3.status = 0
    @flow3.blocked = 0
    
    #流4
    @flow4 = Flow.new
    @flow4.id = '2_2'
    @flow4.name = 'f4'
    @flow4.source_node_id = '2'
    @flow4.target_node_id = '4'
    @flow4.status = 0
    @flow4.blocked = 0
    
    #流5
    @flow5 = Flow.new
    @flow5.id = '4_2'
    @flow5.name = 'f5'
    @flow5.source_node_id = '4'
    @flow5.target_node_id = '1'
    @flow5.status = 0
    @flow5.blocked = 0
    
    #流6
    @flow6 = Flow.new
    @flow6.id = '3_1'
    @flow6.name = 'f6'
    @flow6.source_node_id = '3'
    @flow6.target_node_id = '5'
    @flow6.status = 0
    @flow6.blocked = 0
    
    #流7
    @flow7 = Flow.new
    @flow7.id = '4_1'
    @flow7.name = 'f7'
    @flow7.source_node_id = '4'
    @flow7.target_node_id = '5'
    @flow7.status = 0
    @flow7.blocked = 0
    
    @flows = [@flow1,@flow2,@flow3,@flow4,@flow5,@flow6,@flow7]
    @nodes = [@start_node,@gateway_node1,@gateway_node2,@task_node1,@task_node2,@end_node]
  end
end

class GraphThree < Graph
  def initialize
    #开始节点
    @start_node = StartNode.new
    @start_node.id = '0'
    @start_node.name = 'S'
    @start_node.type = 'StartNode'
    @start_node.weight = 1
    @start_node.status = 0
    @start_node.outgoings_id = ['0_1']
    @start_node.incomings_id = []
    
    #任务节点1
    @task_node1 = TaskNode.new
    @task_node1.id = '1'
    @task_node1.name = 'T1'
    @task_node1.type = 'TaskNode'
    @task_node1.weight = 1
    @task_node1.status = 0
    @task_node1.outgoings_id = ['1_1']
    @task_node1.incomings_id = ['0_1','4_2']
    
    #网关节点1
    @gateway_node1 = GatewayNode.new
    @gateway_node1.id = '2'
    @gateway_node1.name = 'G1'
    @gateway_node1.type = 'GatewayNode'
    @gateway_node1.weight = 1
    @gateway_node1.status = 0
    @gateway_node1.outgoings_id = ['2_1','2_2']
    @gateway_node1.incomings_id = ['1_1']
    @gateway_node1.avaliable_count = @gateway_node1.outgoings_id.length
    
    #任务节点2
    @task_node2 = TaskNode.new
    @task_node2.id = '3'
    @task_node2.name = 'T2'
    @task_node2.type = 'TaskNode'
    @task_node2.weight = 1
    @task_node2.status = 0
    @task_node2.outgoings_id = ['3_1']
    @task_node2.incomings_id = ['2_1']
    
    #网关节点2
    @gateway_node2 = GatewayNode.new
    @gateway_node2.id = '4'
    @gateway_node2.name = 'G2'
    @gateway_node2.type = 'GatewayNode'
    @gateway_node2.weight = 1
    @gateway_node2.status = 0
    @gateway_node2.outgoings_id = ['4_1','4_2','4_3']
    @gateway_node2.incomings_id = ['2_2']
    @gateway_node2.avaliable_count = @gateway_node2.outgoings_id.length
 
    #任务节点3
    @task_node3 = TaskNode.new
    @task_node3.id = '5'
    @task_node3.name = 'T3'
    @task_node3.type = 'TaskNode'
    @task_node3.weight = 1
    @task_node3.status = 0
    @task_node3.outgoings_id = ['5_1']
    @task_node3.incomings_id = ['4_1','6_1']
    
    #任务节点4
    @task_node4 = TaskNode.new
    @task_node4.id = '6'
    @task_node4.name = 'T4'
    @task_node4.type = 'TaskNode'
    @task_node4.weight = 1
    @task_node4.status = 0
    @task_node4.outgoings_id = ['6_1']
    @task_node4.incomings_id = ['4_3']     
    
    #结束节点
    @end_node = EndNode.new
    @end_node.id = '7'
    @end_node.name = 'E'
    @end_node.type = 'EndNode'
    @end_node.weight = 1
    @end_node.status = 0
    @end_node.outgoings_id = []
    @end_node.incomings_id = ['5_1','3_1']
    
    #流1
    @flow1 = Flow.new
    @flow1.id = '0_1'
    @flow1.name = 'f1'
    @flow1.source_node_id = '0'
    @flow1.target_node_id = '1'
    @flow1.status = 0
    @flow1.blocked = 0
    
    #流2
    @flow2 = Flow.new
    @flow2.id = '1_1'
    @flow2.name = 'f2'
    @flow2.source_node_id = '1'
    @flow2.target_node_id = '2'
    @flow2.status = 0
    @flow2.blocked = 0
    
    #流3
    @flow3 = Flow.new
    @flow3.id = '2_1'
    @flow3.name = 'f3'
    @flow3.source_node_id = '2'
    @flow3.target_node_id = '3'
    @flow3.status = 0
    @flow3.blocked = 0
    
    #流4
    @flow4 = Flow.new
    @flow4.id = '2_2'
    @flow4.name = 'f4'
    @flow4.source_node_id = '2'
    @flow4.target_node_id = '4'
    @flow4.status = 0
    @flow4.blocked = 0
    
    #流5
    @flow5 = Flow.new
    @flow5.id = '4_2'
    @flow5.name = 'f5'
    @flow5.source_node_id = '4'
    @flow5.target_node_id = '1'
    @flow5.status = 0
    @flow5.blocked = 0
    
    #流6
    @flow6 = Flow.new
    @flow6.id = '3_1'
    @flow6.name = 'f6'
    @flow6.source_node_id = '3'
    @flow6.target_node_id = '7'
    @flow6.status = 0
    @flow6.blocked = 0
    
    #流7
    @flow7 = Flow.new
    @flow7.id = '4_1'
    @flow7.name = 'f7'
    @flow7.source_node_id = '4'
    @flow7.target_node_id = '5'
    @flow7.status = 0
    @flow7.blocked = 0

    #流8
    @flow8 = Flow.new
    @flow8.id = '4_3'
    @flow8.name = 'f8'
    @flow8.source_node_id = '4'
    @flow8.target_node_id = '6'
    @flow8.status = 0
    @flow8.blocked = 0
    
    #流9
    @flow9 = Flow.new
    @flow9.id = '6_1'
    @flow9.name = 'f9'
    @flow9.source_node_id = '6'
    @flow9.target_node_id = '5'
    @flow9.status = 0
    @flow9.blocked = 0
    
    #流10
    @flow10 = Flow.new
    @flow10.id = '5_1'
    @flow10.name = 'f10'
    @flow10.source_node_id = '5'
    @flow10.target_node_id = '7'
    @flow10.status = 0
    @flow10.blocked = 0        
    
    @flows = [@flow1,@flow2,@flow3,@flow4,@flow5,@flow6,@flow7,@flow8,@flow9,@flow10]
    @nodes = [@start_node,@gateway_node1,@gateway_node2,@task_node1,@task_node2,@task_node3,@task_node4,@end_node]
  end
end

class GraphFour < Graph
  def initialize
    #开始节点
    @start_node = StartNode.new
    @start_node.id = '0'
    @start_node.name = 'S'
    @start_node.type = 'StartNode'
    @start_node.weight = 1
    @start_node.status = 0
    @start_node.outgoings_id = ['0_1']
    @start_node.incomings_id = []
    
    #任务节点1
    @task_node1 = TaskNode.new
    @task_node1.id = '1'
    @task_node1.name = 'T1'
    @task_node1.type = 'TaskNode'
    @task_node1.weight = 1
    @task_node1.status = 0
    @task_node1.outgoings_id = ['1_1']
    @task_node1.incomings_id = ['0_1','4_2','2_3']
    
    #网关节点1
    @gateway_node1 = GatewayNode.new
    @gateway_node1.id = '2'
    @gateway_node1.name = 'G1'
    @gateway_node1.type = 'GatewayNode'
    @gateway_node1.weight = 1
    @gateway_node1.status = 0
    @gateway_node1.outgoings_id = ['2_1','2_2','2_3']
    @gateway_node1.incomings_id = ['1_1']
    @gateway_node1.avaliable_count = @gateway_node1.outgoings_id.length
    
    #任务节点2
    @task_node2 = TaskNode.new
    @task_node2.id = '3'
    @task_node2.name = 'T2'
    @task_node2.type = 'TaskNode'
    @task_node2.weight = 1
    @task_node2.status = 0
    @task_node2.outgoings_id = ['3_1']
    @task_node2.incomings_id = ['2_1']
    
    #网关节点2
    @gateway_node2 = GatewayNode.new
    @gateway_node2.id = '4'
    @gateway_node2.name = 'G2'
    @gateway_node2.type = 'GatewayNode'
    @gateway_node2.weight = 1
    @gateway_node2.status = 0
    @gateway_node2.outgoings_id = ['4_1','4_2','4_3']
    @gateway_node2.incomings_id = ['2_2']
    @gateway_node2.avaliable_count = @gateway_node2.outgoings_id.length
 
    #任务节点3
    @task_node3 = TaskNode.new
    @task_node3.id = '5'
    @task_node3.name = 'T3'
    @task_node3.type = 'TaskNode'
    @task_node3.weight = 1
    @task_node3.status = 0
    @task_node3.outgoings_id = ['5_1']
    @task_node3.incomings_id = ['4_1','6_1']
    
    #任务节点4
    @task_node4 = TaskNode.new
    @task_node4.id = '6'
    @task_node4.name = 'T4'
    @task_node4.type = 'TaskNode'
    @task_node4.weight = 1
    @task_node4.status = 0
    @task_node4.outgoings_id = ['6_1']
    @task_node4.incomings_id = ['4_3']     
    
    #结束节点
    @end_node = EndNode.new
    @end_node.id = '7'
    @end_node.name = 'E'
    @end_node.type = 'EndNode'
    @end_node.weight = 1
    @end_node.status = 0
    @end_node.outgoings_id = []
    @end_node.incomings_id = ['5_1','3_1']
    
    #流1
    @flow1 = Flow.new
    @flow1.id = '0_1'
    @flow1.name = 'f1'
    @flow1.source_node_id = '0'
    @flow1.target_node_id = '1'
    @flow1.status = 0
    @flow1.blocked = 0
    
    #流2
    @flow2 = Flow.new
    @flow2.id = '1_1'
    @flow2.name = 'f2'
    @flow2.source_node_id = '1'
    @flow2.target_node_id = '2'
    @flow2.status = 0
    @flow2.blocked = 0
    
    #流3
    @flow3 = Flow.new
    @flow3.id = '2_1'
    @flow3.name = 'f3'
    @flow3.source_node_id = '2'
    @flow3.target_node_id = '3'
    @flow3.status = 0
    @flow3.blocked = 0
    
    #流4
    @flow4 = Flow.new
    @flow4.id = '2_2'
    @flow4.name = 'f4'
    @flow4.source_node_id = '2'
    @flow4.target_node_id = '4'
    @flow4.status = 0
    @flow4.blocked = 0
    
    #流5
    @flow5 = Flow.new
    @flow5.id = '4_2'
    @flow5.name = 'f5'
    @flow5.source_node_id = '4'
    @flow5.target_node_id = '1'
    @flow5.status = 0
    @flow5.blocked = 0
    
    #流6
    @flow6 = Flow.new
    @flow6.id = '3_1'
    @flow6.name = 'f6'
    @flow6.source_node_id = '3'
    @flow6.target_node_id = '7'
    @flow6.status = 0
    @flow6.blocked = 0
    
    #流7
    @flow7 = Flow.new
    @flow7.id = '4_1'
    @flow7.name = 'f7'
    @flow7.source_node_id = '4'
    @flow7.target_node_id = '5'
    @flow7.status = 0
    @flow7.blocked = 0

    #流8
    @flow8 = Flow.new
    @flow8.id = '4_3'
    @flow8.name = 'f8'
    @flow8.source_node_id = '4'
    @flow8.target_node_id = '6'
    @flow8.status = 0
    @flow8.blocked = 0
    
    #流9
    @flow9 = Flow.new
    @flow9.id = '6_1'
    @flow9.name = 'f9'
    @flow9.source_node_id = '6'
    @flow9.target_node_id = '5'
    @flow9.status = 0
    @flow9.blocked = 0
    
    #流10
    @flow10 = Flow.new
    @flow10.id = '5_1'
    @flow10.name = 'f10'
    @flow10.source_node_id = '5'
    @flow10.target_node_id = '7'
    @flow10.status = 0
    @flow10.blocked = 0        
 
    #流11
    @flow11 = Flow.new
    @flow11.id = '2_3'
    @flow11.name = 'f11'
    @flow11.source_node_id = '2'
    @flow11.target_node_id = '1'
    @flow11.status = 0
    @flow11.blocked = 0  
    
    @flows = [@flow1,@flow2,@flow3,@flow4,@flow5,@flow6,@flow7,@flow8,@flow9,@flow10,@flow11]
    @nodes = [@start_node,@gateway_node1,@gateway_node2,@task_node1,@task_node2,@task_node3,@task_node4,@end_node]
  end
end

class GraphFive < Graph
  def initialize
    #开始节点
    @start_node = StartNode.new
    @start_node.id = '0'
    @start_node.name = 'S'
    @start_node.type = 'StartNode'
    @start_node.weight = 1
    @start_node.status = 0
    @start_node.outgoings_id = ['0_1']
    @start_node.incomings_id = []
    
    #网关节点1
    @gateway_node1 = GatewayNode.new
    @gateway_node1.id = '2'
    @gateway_node1.name = 'G1'
    @gateway_node1.type = 'GatewayNode'
    @gateway_node1.weight = 1
    @gateway_node1.status = 0
    @gateway_node1.outgoings_id = ['2_1','2_2','2_3','2_4']
    @gateway_node1.incomings_id = ['1_1']
    @gateway_node1.avaliable_count = @gateway_node1.outgoings_id.length
    
    #网关节点2
    @gateway_node2 = GatewayNode.new
    @gateway_node2.id = '4'
    @gateway_node2.name = 'G2'
    @gateway_node2.type = 'GatewayNode'
    @gateway_node2.weight = 1
    @gateway_node2.status = 0
    @gateway_node2.outgoings_id = ['4_1','4_2','4_3']
    @gateway_node2.incomings_id = ['2_2']
    @gateway_node2.avaliable_count = @gateway_node2.outgoings_id.length
    
    #任务节点1
    @task_node1 = TaskNode.new
    @task_node1.id = '1'
    @task_node1.name = 'T1'
    @task_node1.type = 'TaskNode'
    @task_node1.weight = 1
    @task_node1.status = 0
    @task_node1.outgoings_id = ['1_1']
    @task_node1.incomings_id = ['0_1','4_2','2_3']
    
    #任务节点2
    @task_node2 = TaskNode.new
    @task_node2.id = '3'
    @task_node2.name = 'T2'
    @task_node2.type = 'TaskNode'
    @task_node2.weight = 1
    @task_node2.status = 0
    @task_node2.outgoings_id = ['3_1']
    @task_node2.incomings_id = ['2_1']
    
    #任务节点3
    @task_node3 = TaskNode.new
    @task_node3.id = '5'
    @task_node3.name = 'T3'
    @task_node3.type = 'TaskNode'
    @task_node3.weight = 1
    @task_node3.status = 0
    @task_node3.outgoings_id = ['5_1']
    @task_node3.incomings_id = ['4_1','6_1']
    
    #任务节点4
    @task_node4 = TaskNode.new
    @task_node4.id = '6'
    @task_node4.name = 'T4'
    @task_node4.type = 'TaskNode'
    @task_node4.weight = 1
    @task_node4.status = 0
    @task_node4.outgoings_id = ['6_1']
    @task_node4.incomings_id = ['4_3'] 

    #任务节点5
    @task_node5 = TaskNode.new
    @task_node5.id = '8'
    @task_node5.name = 'T5'
    @task_node5.type = 'TaskNode'
    @task_node5.weight = 1
    @task_node5.status = 0
    @task_node5.outgoings_id = ['8_1']
    @task_node5.incomings_id = ['2_4']
    
    #结束节点1
    @end_node1 = EndNode.new
    @end_node1.id = '7'
    @end_node1.name = 'E1'
    @end_node1.type = 'EndNode'
    @end_node1.weight = 1
    @end_node1.status = 0
    @end_node1.outgoings_id = []
    @end_node1.incomings_id = ['5_1']

    #结束节点2
    @end_node2 = EndNode.new
    @end_node2.id = '9'
    @end_node2.name = 'E2'
    @end_node2.type = 'EndNode'
    @end_node2.weight = 1
    @end_node2.status = 0
    @end_node2.outgoings_id = []
    @end_node2.incomings_id = ['3_1']
    
    #结束节点3
    @end_node3 = EndNode.new
    @end_node3.id = '10'
    @end_node3.name = 'E3'
    @end_node3.type = 'EndNode'
    @end_node3.weight = 1
    @end_node3.status = 0
    @end_node3.outgoings_id = []
    @end_node3.incomings_id = ['8_1']    
    
    #流1
    @flow1 = Flow.new
    @flow1.id = '0_1'
    @flow1.name = 'f1'
    @flow1.source_node_id = '0'
    @flow1.target_node_id = '1'
    @flow1.status = 0
    @flow1.blocked = 0
    
    #流2
    @flow2 = Flow.new
    @flow2.id = '1_1'
    @flow2.name = 'f2'
    @flow2.source_node_id = '1'
    @flow2.target_node_id = '2'
    @flow2.status = 0
    @flow2.blocked = 0
    
    #流3
    @flow3 = Flow.new
    @flow3.id = '2_1'
    @flow3.name = 'f3'
    @flow3.source_node_id = '2'
    @flow3.target_node_id = '3'
    @flow3.status = 0
    @flow3.blocked = 0
    
    #流4
    @flow4 = Flow.new
    @flow4.id = '2_2'
    @flow4.name = 'f4'
    @flow4.source_node_id = '2'
    @flow4.target_node_id = '4'
    @flow4.status = 0
    @flow4.blocked = 0
    
    #流5
    @flow5 = Flow.new
    @flow5.id = '4_2'
    @flow5.name = 'f5'
    @flow5.source_node_id = '4'
    @flow5.target_node_id = '1'
    @flow5.status = 0
    @flow5.blocked = 0
    
    #流6
    @flow6 = Flow.new
    @flow6.id = '3_1'
    @flow6.name = 'f6'
    @flow6.source_node_id = '3'
    @flow6.target_node_id = '9'
    @flow6.status = 0
    @flow6.blocked = 0
    
    #流7
    @flow7 = Flow.new
    @flow7.id = '4_1'
    @flow7.name = 'f7'
    @flow7.source_node_id = '4'
    @flow7.target_node_id = '5'
    @flow7.status = 0
    @flow7.blocked = 0

    #流8
    @flow8 = Flow.new
    @flow8.id = '4_3'
    @flow8.name = 'f8'
    @flow8.source_node_id = '4'
    @flow8.target_node_id = '6'
    @flow8.status = 0
    @flow8.blocked = 0
    
    #流9
    @flow9 = Flow.new
    @flow9.id = '6_1'
    @flow9.name = 'f9'
    @flow9.source_node_id = '6'
    @flow9.target_node_id = '5'
    @flow9.status = 0
    @flow9.blocked = 0
    
    #流10
    @flow10 = Flow.new
    @flow10.id = '5_1'
    @flow10.name = 'f10'
    @flow10.source_node_id = '5'
    @flow10.target_node_id = '7'
    @flow10.status = 0
    @flow10.blocked = 0        
 
    #流11
    @flow11 = Flow.new
    @flow11.id = '2_3'
    @flow11.name = 'f11'
    @flow11.source_node_id = '2'
    @flow11.target_node_id = '1'
    @flow11.status = 0
    @flow11.blocked = 0  

    #流12
    @flow12 = Flow.new
    @flow12.id = '8_1'
    @flow12.name = 'f12'
    @flow12.source_node_id = '8'
    @flow12.target_node_id = '10'
    @flow12.status = 0
    @flow12.blocked = 0
    
    #流13
    @flow13 = Flow.new
    @flow13.id = '2_4'
    @flow13.name = 'f13'
    @flow13.source_node_id = '2'
    @flow13.target_node_id = '8'
    @flow13.status = 0
    @flow13.blocked = 0
    
    @flows = [@flow1,@flow2,@flow3,@flow4,@flow5,@flow6,@flow7,@flow8,@flow9,@flow10,@flow11,@flow12,@flow13]
    @nodes = [@start_node,@gateway_node1,@gateway_node2,@task_node1,@task_node2,@task_node3,@task_node4,@task_node5,@end_node1,@end_node2,@end_node3]
  end
end
=end