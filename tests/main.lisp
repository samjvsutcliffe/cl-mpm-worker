(defpackage cl-mpm-worker/tests/main
  (:use :cl
        :cl-mpm-worker
        :rove))
(in-package :cl-mpm-worker/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :cl-mpm-worker)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
