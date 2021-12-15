;;;; The vanilla query in Postmodern <https://github.com/marijnh/Postmodern> is a macro,
;;;; thus the parameters will not be evaluated.
;;;; But sometimes I want that the parameters can be evaluated, so this was patched.


(in-package :postmodern)


(defun queryf (query &optional args (format :rows))
  "Query and simply return all row of `format'."
  (destructuring-bind (reader result-form) (reader-for-format format)
    (declare (ignore result-form))
    (multiple-value-bind (rows affected)
        (if args
            (progn
              (funcall (alexandria:curry #'prepare-query *database* "" (real-query query)) args)
              (exec-prepared *database* "" args (second reader)))
            (exec-query *database* (real-query query) (s-sql::dequote (second reader))))
      (values rows affected))))


(defun queryf* (query &optional args (format :rows))
  "Query and further process the rows according to `format'.
The result should be the same as revoking pomo:query."
  (destructuring-bind (reader result-form) (reader-for-format format)
    (multiple-value-bind (rows affected)
        (if args
            (progn
              (funcall (alexandria:curry #'prepare-query *database* "" (real-query query)) args)
              (exec-prepared *database* "" args (second reader)))
            (exec-query *database* (real-query query) (s-sql::dequote (second reader))))
      (funcall (compile nil `(lambda () (,result-form  (values ',rows ,affected))))))))
