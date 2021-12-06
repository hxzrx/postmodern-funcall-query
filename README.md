# postmodern-funcall-query
Query function for the query macro of Postmodern

The vanilla query in Postmodern <https://github.com/marijnh/Postmodern> is a macro, thus the parameters will not be either evaluated or applied.
But sometimes I want that the parameters can be evaluated, so this was patched.                                                 


(let ((sql "select now()")                                                                                                           
      (fmt :plists))                                                                                                          
   (pomo::queryf sql nil fmt))                                                                                                       
                                                                                                                                     
(let ((sql "select $1, $2")                                                                                                          
      (fmt :plists))                                                                                                          
   (pomo::queryf* sql '(1 2) fmt))
   
