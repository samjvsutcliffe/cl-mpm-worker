(defpackage cl-mpm-worker/build
  (:use :cl
        :cl-mpm-worker))
(in-package :cl-mpm-worker/build)

(sb-ext:save-lisp-and-die
 "mpi-worker"
 :executable t
 :toplevel #'main)
