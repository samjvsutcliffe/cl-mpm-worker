(defsystem "cl-mpm-worker"
  :version "0.1.0"
  :author "Sam Sutcliffe"
  :license ""
  :depends-on ("magicl"
               "cl-mpm"
               "lfarm-server")
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
