# postmodern-funcall-query  
Query function for the query macro of Postmodern  
  
The vanilla query in Postmodern <https://github.com/marijnh/Postmodern> is a macro, thus the parameters will not be either evaluated or applied.  
But sometimes I want that the parameters can be evaluated, so this was patched.  

I load this file in .asd file as a patch to Postmodern.
  
```  
(let ((sql "select now()")  
             (fmt :plists))  
   (pomo::queryf sql nil fmt))

  
(let ((sql "select $1, $2")  
             (fmt :plists))  
   (pomo::queryf* sql '(1 2) fmt))  
  
;; -----------  
  
(let ((sql "select now()")  
             (fmt :plists))  
   (pomo::queryf sql nil fmt))  
  
(let ((sql "select $1, $2")  
             (fmt :plists))  
   (pomo::queryf* sql '(1 2) fmt))  

;; ------------  
;;  
;; CREATE TABLE IF NOT EXISTS public.test_record  
;; (  
;;   id INTEGER,  
;;   name VARCHAR  
;; );  
  
(let ((sql "INSERT INTO public.test_record (id, name)  VALUES (1, E'路人乙') RETURNING id, name"))  
   (pomo::query sql :alist))  
  
(let ((sql "INSERT INTO public.test_record (id, name)  VALUES (1, E'路人乙') RETURNING id, name")  
      (fmt :alist))  
   (pomo::queryf sql nil fmt))  
  
(let ((sql "INSERT INTO public.test_record (id, name)  VALUES (1, E'路人乙') RETURNING id, name")  
      (fmt :alist))  
   (pomo::queryf* sql nil fmt))  
  
;; ------------  
  
(let ((sql "SELECT id, name FROM public.test_record"))  
          (pomo::query sql :alist))  
  
(let ((sql "SELECT id, name FROM public.test_record")  
             (fmt :alist))  
          (pomo::queryf sql nil fmt))  
  
(let ((sql "SELECT id, name FROM public.test_record")  
             (fmt :alist))  
          (pomo::queryf* sql nil fmt))  
  
;; -------------  
  
(time (let ((sql "INSERT INTO public.test_record (id, name)  VALUES (1, E'路人乙') RETURNING id, name"))  
               (dotimes (i 10000) (pomo::query sql :alist))))  
Evaluation took:  
  15.436 seconds of real time  
  1.527980 seconds of total run time (0.076650 user, 1.451330 system)  
  9.90% CPU  
  40,018,329,801 processor cycles  
  20,959,440 bytes consed  
  
(time (let ((sql "INSERT INTO public.test_record (id, name)  VALUES (1, E'路人乙') RETURNING id, name")  
                   (fmt :alist))  
               (dotimes (i 10000 )(pomo::queryf sql nil fmt))))  
Evaluation took:  
  12.832 seconds of real time  
  1.547782 seconds of total run time (0.095763 user, 1.452019 system)  
  12.06% CPU  
  33,261,737,628 processor cycles  
  21,443,408 bytes consed  
  
(time (let ((sql "INSERT INTO public.test_record (id, name)  VALUES (1, E'路人乙') RETURNING id, name")  
                   (fmt :alist))  
               (dotimes (i 10000 )(pomo::queryf* sql nil fmt))))  
Evaluation took:  
  11.236 seconds of real time  
  1.700625 seconds of total run time (0.068899 user, 1.631726 system)  
  15.14% CPU  
  29,124,088,506 processor cycles  
  21,443,904 bytes consed  
  
;; -----------------  
  
(time (let ((sql "select $1, $2"))  
               (dotimes (i 100000) (pomo::query sql 1 2 :plist))))  
Evaluation took:  
  24.696 seconds of real time  
  14.941247 seconds of total run time (1.462194 user, 13.479053 system)  
  [ Run times consist of 0.062 seconds GC time, and 14.880 seconds non-GC time. ]  
  60.50% CPU  
  64,009,163,491 processor cycles  
  278,394,992 bytes consed  
  
(time (let ((sql "select $1, $2")  
                   (fmt :plist))  
               (dotimes (i 100000) (pomo::queryf sql '(1 2) fmt))))  
Evaluation took:  
  20.044 seconds of real time  
  11.871336 seconds of total run time (1.767913 user, 10.103423 system)  
  [ Run times consist of 0.008 seconds GC time, and 11.864 seconds non-GC time. ]  
  59.22% CPU  
  51,951,587,416 processor cycles  
  284,589,568 bytes consed  
  
(time (let ((sql "select $1, $2")  
                   (fmt :plist))  
               (dotimes (i 100000) (pomo::queryf* sql '(1 2) fmt))))  
Evaluation took:  
  29.020 seconds of real time  
  17.802845 seconds of total run time (0.900289 user, 16.902556 system)  
  61.35% CPU  
  75,224,558,061 processor cycles  
  284,794,080 bytes consed  
  
;; ------------------  
  
;; the table public.test_record has 53119 rows.  
  
(time (let ((sql "SELECT id, name FROM public.test_record"))  
          (dotimes (i 1000) (pomo::query sql :alists))))  
Evaluation took:  
  35.704 seconds of real time  
  35.216459 seconds of total run time (32.156660 user, 3.059799 system)  
  [ Run times consist of 1.056 seconds GC time, and 34.161 seconds non-GC time. ]  
  98.63% CPU  
  26 lambdas converted  
  92,543,959,937 processor cycles  
  23,799,828,208 bytes consed  
  
(time (let ((sql "SELECT id, name FROM public.test_record")  
             (fmt :alists))  
          (dotimes (i 1000) (pomo::queryf sql nil fmt))))  
Evaluation took:  
  36.164 seconds of real time  
  35.618420 seconds of total run time (32.515002 user, 3.103418 system)  
  [ Run times consist of 0.944 seconds GC time, and 34.675 seconds non-GC time. ]  
  98.49% CPU  
  93,729,552,676 processor cycles  
  23,798,987,824 bytes consed  
  
(time (let ((sql "SELECT id, name FROM public.test_record")  
             (fmt :alists))  
          (dotimes (i 1000) (pomo::queryf* sql nil fmt))))  
Evaluation took:  
  37.716 seconds of real time  
  37.202088 seconds of total run time (33.701189 user, 3.500899 system)  
  [ Run times consist of 1.015 seconds GC time, and 36.188 seconds non-GC time. ]  
  98.64% CPU  
  97,763,281,885 processor cycles  
  23,799,000,592 bytes consed  
```
