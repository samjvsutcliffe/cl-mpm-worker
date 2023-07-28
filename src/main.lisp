(defpackage cl-mpm-worker
  (:use :cl)
  (:export
   #:main))
(in-package :cl-mpm-worker)

(defun main (&optional args)
  (cl-mpi:mpi-init)
  (opts:define-opts
     (:name :help
      :description "print this help text"
      :short #\h
      :long "help")
     (:name :port
      :description "Process binding port"
      :short #\p
      :long "port"
      :arg-parser #'parse-integer)
   (:name :threads
    :description "Per process thread count"
    :short #\n
    :long "threads"
    :arg-parser #'parse-integer)
   )
  (defparameter *mpi-rank* (cl-mpi:mpi-comm-rank))
  (defparameter *port* (getf (opts:get-opts) :port))
  (defparameter *threads* (getf (opts:get-opts) :threads))
  (unless *port*
   (setf *port* 11110))
  (unless *threads*
    (setf *threads* 1))
  (format t "MPI rank: ~D~%" (cl-mpi:mpi-comm-rank))
  (format t "Threads: ~D~%" *threads*)
  (format t "Base port port: ~D ~%" *port*)
  (format t "Binding to port: ~D ~%" (+ *port* *mpi-rank*))
  (setf lparallel:*kernel* (lparallel:make-kernel *threads*))
  (if (= *mpi-rank* 0)
      (cl-mpm/examples/slump::mpi-run 1)
      (lfarm-server:start-server "127.0.0.1" (+ *port* *mpi-rank*)
                                        ;:background t
                                 ))
  (cl-mpi:mpi-finalize)
  (uiop:quit)
  )
