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
  (format t "Hello MPI rank 0~%")
  ;(cl-mpm/examples/slump::mpi-run (cl-mpi::mpi-comm-size))
  (load "test-file.lisp")
  )


(defun write-hostnames (filename host port)
  (loop for rank below (cl-mpi:mpi-comm-size) do
        (when (and  (= rank (cl-mpi:mpi-comm-rank))
                    ;; (not (= rank 0))
                    )
      (with-open-file (file filename
                            :direction :output
                            :if-exists :append)
        ;(apply #'format file format args)
        (format 
          file
          "(~S ~A)~%"
          host port)
        (force-output file)))
    (cl-mpi:mpi-barrier)))

(defun main-mpi ()
  (main))
(defun start-server (port)
  (let ((host (uiop/os:hostname))
        (filename "lfarm_connections"))
    (format t "Binding to port: ~D ~%" port)
    (format t "Binding to host ~A ~%" host)
    (lfarm-server:start-server host port)))
(defun main (&optional args)
  (cl-mpi:mpi-init)
  (format t "hello rank: ~D ~%" (cl-mpi:mpi-comm-rank))
  ;(opts:define-opts
  ;   (:name :help
  ;    :description "print this help text"
  ;    :short #\h
  ;    :long "help")
  ;   (:name :port
  ;    :description "Process binding port"
  ;    :short #\p
  ;    :long "port"
  ;    :arg-parser #'parse-integer)
  ; (:name :threads
  ;  :description "Per process thread count"
  ;  :short #\n
  ;  :long "threads"
  ;  :arg-parser #'parse-integer)
  ;  (:name :pseudo-rank
  ;   :description "Pretend we are running cl-mpi mode"
  ;   :short #\n
  ;   :long "pseudo-rank"
  ;   :arg-parser #'parse-integer)
  ; )
  (let* ((mpi-rank (cl-mpi:mpi-comm-rank))
        (port nil)
        (threads nil)
        (host (uiop/os:hostname))
        (filename "lfarm_connections")
        (host "127.0.0.1")
        )
    ;(defparameter *port* (getf (opts:get-opts) :port))
    ;(defparameter *threads* (getf (opts:get-opts) :threads))
    ;(defparameter *pseudo-rank* (getf (opts:get-opts) :pseudo-rank))

    (unless port
      (setf port 11110))
    (unless threads
      (setf threads 1))
    ;(unless mpi-rank 
    ;  (setf mpi-rank 1))
    ;(when *pseudo-rank*
    ;  (setf *mpi-rank* *pseudo-rank*))
    (format t "MPI rank: ~D~%" mpi-rank)
    (format t "Threads: ~D~%" threads)
    (format t "Base port port: ~D ~%" port)
    (incf port mpi-rank)
    ;; (setf lparallel:*kernel* (lparallel:make-kernel threads))

    (when (= mpi-rank 0)
      (with-open-file (file filename :direction :output :if-exists :supersede)
        (format file "(~%")
        (force-output file)))
    (write-hostnames filename host port)
    (when (= mpi-rank 0)
      (with-open-file (file filename :direction :output :if-exists :append)
        (format file ")~%")
        (force-output file)))

    ;;; (cl-mpm/examples/slump::mpi-run 1)
    (if (= mpi-rank 0)
        (progn
          (format t "Binding to port: ~D ~%" port)
          (format t "Binding to host ~A ~%" host)
          (lfarm-server:start-server host port :background t)
          (format t "Running primary main~%")
          (primary-main))
        (progn
          (format t "Binding to port: ~D ~%" port)
          (format t "Binding to host ~A ~%" host)
          (lfarm-server:start-server host port)
          ))
    )
  (cl-mpi:mpi-finalize)
  (uiop:quit)
  )

(defun build ()
  (sb-ext:save-lisp-and-die
   "mpi-worker"
   :executable t
   :toplevel #'main
   :save-runtime-options t
   
   ))
