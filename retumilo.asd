(defsystem "retumilo"
  :version "0.0.1"
  :author "Lukas Zumvorde"
  :license "BSD 2"
  :depends-on ("cl-cffi-gtk" "cl-webkit2" "uiop")
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description "Simple webkit based web browser."
  :in-order-to ((test-op (test-op "retumilo/tests"))))

(defsystem "retumilo/tests"
  :author "Lukas Zumvorde"
  :license "BSD 2"
  :depends-on ("retumilo"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for retumilo"
  :perform (test-op (op c) (symbol-call :rove :run c)))
