#### Description

# Option

#### Operations 
# <table>
#   <tr>
#     <td>Name</td>
#     <td>Complexity</td>
#   </tr>
# </table>

#### Implementation
class Option
  
  this.__value
  
  constructor: ()            -> throw new Error("Not implemented in Option")
  isEmpty:     ()            -> throw new Error("Not implemented in Option")
  get:         ()            -> throw new Error("Not implemented in Option")
  getOrElse:   (alternative) -> 
    if (this.isEmpty()) 
       alternative 
    else 
      this.get()
  
class Some extends Option

  isEmpty:     ()       -> false 
  get:         ()       -> this.__value
  constructor: (value)  -> 
    if (value == undefined) 
      return new None()
    else 
      this.__value  = value
  
class None  extends Option
  
  constructor: () -> 
  isEmpty:     () -> true
  
exports.Some = Some 
exports.None = None 