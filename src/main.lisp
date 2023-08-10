(defpackage cl-mpm-worker
  (:use :cl)
  (:export
   #:main
   #:main-mpi
   #:build
   ))
(in-package :cl-mpm-worker)

(declaim (notinline primary-main))
(defun primary-main ()
  (format t "Hello MPI rank 0~%"))

(defun main-mpi ()
  (main))
(defun main (&optional args)
  (cl-mpi:mpi-init)
  ;; (format t "hello rank: ~D ~%" (cl-mpi:mpi-comm-rank))
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
    (:name :pseudo-rank
     :description "Pretend we are running cl-mpi mode"
     :short #\n
     :long "pseudo-rank"
     :arg-parser #'parse-integer)
   )
  (defparameter *mpi-rank* (cl-mpi:mpi-comm-rank))
  (defparameter *port* (getf (opts:get-opts) :port))
  (defparameter *threads* (getf (opts:get-opts) :threads))
  (defparameter *pseudo-rank* (getf (opts:get-opts) :pseudo-rank))
  (unless *port*
   (setf *port* 11110))
  (unless *threads*
    (setf *threads* 1))
  (when *pseudo-rank*
    (setf *mpi-rank* *pseudo-rank*))
  (format t "MPI rank: ~D~%" *mpi-rank*)
  (format t "Threads: ~D~%" *threads*)
  (format t "Base port port: ~D ~%" *port*)
  (format t "Binding to port: ~D ~%" (+ *port* *mpi-rank*))
  (setf lparallel:*kernel* (lparallel:make-kernel *threads*))
  ;; (cl-mpm/examples/slump::mpi-run 1)
  (if (= *mpi-rank* 0)
      (progn
        (format t "Running primary main~%")
        (primary-main))
      (lfarm-server:start-server "127.0.0.1" (+ *port* *mpi-rank*)))
  ;; (lfarm-server:start-server "127.0.0.1" (+ *port* *mpi-rank* 1))
  (cl-mpi:mpi-finalize)
  (uiop:quit)
  )

(defun build ()
  (sb-ext:save-lisp-and-die
   "mpi-worker"
   :executable t
   :toplevel #'main))
