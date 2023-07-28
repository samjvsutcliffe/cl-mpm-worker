(cl:in-package #:asdf-user)
(defsystem :cl-mpm-worker
  :version "0.1.0"
  :author "Sam Sutcliffe"
  :license ""
  :depends-on (:cl-mpi
               "magicl"
               "cl-mpm"
               "unix-opts"
               "lfarm-server"
               "lparallel"
               "cl-mpm/examples/slump"
               )
  :defsystem-depends-on (:cl-mpi-asdf-integration)
  :class :mpi-program
  :build-operation :static-program-op
  :build-pathname "my-mpi-app"
  :entry-point "cl-mpm-worker:main"
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description ""
  :in-order-to ((test-op (test-op "cl-mpm-worker/tests"))))

(defsystem "cl-mpm-worker/tests"
  :author "Sam Sutcliffe"
  :license ""
  :depends-on ("cl-mpm-worker"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for cl-mpm-worker"
  :perform (test-op (op c) (symbol-call :rove :run c)))

(defsystem :cl-mpm-worker/build
  :version "0.1.0"
  :author "Sam Sutcliffe"
  :license ""
  :depends-on (:cl-mpi
               :cl-mpm-worker
               )
  :defsystem-depends-on (:cl-mpi-asdf-integration)
  :class :mpi-program
  :build-operation :static-program-op
  :build-pathname "my-mpi-app"
  :entry-point "cl-mpm-worker:main"
  :components ((:module "src"
                :components
                ((:file "build"))))
  :description "")
