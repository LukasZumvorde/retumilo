(use-modules (guix packages)
             (guix licenses)
             (guix git-download)
             (guix build-system asdf)
			 (gnu packages lisp-xyz)
			 (gnu packages lisp-check)
			 )

(define-public retumilo
  (package
    (name "retumilo")
    (version "0.1.0")
    (home-page "https://github.com/LukasZumvorde/retumilo")
    (synopsis "bare bones web browser")
    (description "A simple webkit based web browser.")
    (license bsd-2)
    (source
     (origin
       (method git-fetch)
	   (uri (git-reference
			 (url "https://github.com/LukasZumvorde/retumilo")
			 (commit version)))
       (sha256
        (base32 "05kr7rd2hxj5dyy0b5syh7371w2hkyk31cp8dc8vsaxyyqap1pl6"))))
    (build-system asdf-build-system/sbcl)
	(inputs (list
			 sbcl-cl-cffi-gtk
			 sbcl-cl-webkit
			 sbcl-rove))
	(outputs '("out" "lib"))
	(arguments '(#:phases
				 (modify-phases
				  %standard-phases
				  (delete 'check)
				  (add-after 'create-asdf-configuration 'build-program
							 (lambda* (#:key outputs #:allow-other-keys)
									  (build-program
									   (string-append (assoc-ref outputs "out") "/bin/retumilo")
									   outputs
									   #:entry-program '((retumilo:main-retumilo) 0)))))))))

retumilo
