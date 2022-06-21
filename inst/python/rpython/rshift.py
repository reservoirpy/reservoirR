from reservoirpy.nodes import Reservoir, Ridge, Input
from reservoirpy.model import Model


def operatorRShift(node1,node2):
  """
  Comput operator >> between node1 and node2
  """
  lstOfNodes = (Ridge, Reservoir,Input,Model)
  if isinstance(node1, lstOfNodes) and isinstance(node2,lstOfNodes):
    return node1 >> node2
  elif isinstance(node1,list) or isinstance(node2,list):
    lstNodesInput = []
    if(isinstance(node1,list)):
      for node in node1:
        lstNodesInput.append(node)
    else:
      lstNodesInput.append(node1)
    
    if(isinstance(node2,list)):
      for node in node2:
        lstNodesInput.append(node)
    else:
      lstNodesInput.append(node2)
      
    if all(isinstance(node, lstOfNodes) for node in lstNodesInput):
      return node1 >> node2
  else:
    raise ValueError('all arguments must be node')
