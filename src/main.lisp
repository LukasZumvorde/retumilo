;; (in-package :cl-user)
;; (require :asdf)
;; (asdf:load-systems :cl-cffi-gtk
;; 				   :cl-webkit2
;; 				   :uiop)

(defpackage retumilo
  (:use :cl)
  (:export :main-retumilo))
(in-package :retumilo)


(defstruct key
  "A combination of key and modifiers. Usefull to represent key presses and key chords"
  keysym shift control meta alt hyper super altgr)

(defvar *custom-css* nil)
;; (defvar *custom-css* "body {color: #F00 !important; background-color: #000 !important; };")

(defun add-custom-css (content-manager)
	(webkit2:webkit-user-content-manager-add-style-sheet
	 content-manager
	 (webkit2:webkit-user-style-sheet-new
	  *custom-css* ; the syle sheet
	  :webkit-user-content-inject-all-frames
	  :webkit-user-style-level-author
	  (cffi:null-pointer)
	  (cffi:null-pointer))))

(defun read-key-press-event (event)
  "Reads a gdk key_press_event and returns a struct representing the key or keychord being pressed"
  (let ((keycode (gdk:gdk-keyval-to-lower (slot-value event 'gdk::keyval)))
		(mods (slot-value event 'gdk::state)))
	(unless (find :release-mask mods)
	  (make-key
	   :keysym  (gdk:gdk-keyval-to-unicode keycode)
	   :shift   (when (find :shift-mask mods) t)
	   :control (when (find :control-mask mods) t)
	   :meta    (when (find :meta-mask mods) t)
	   :alt     (when (find :mod1-mask mods) t)
	   :hyper   (when (find :hyper-mask mods) t)
	   :super   (when (find :super-mask mods) t)
	   :altgr   (when (find :mod5-mask mods) t)))))

(in-package #:webkit2)
;; TODO remove these bindings as soon as they are in available from upstream.
;; see https://github.com/joachifm/cl-webkit/blob/master/webkit2/webkit2.user-content-filter-store.lisp
(defctype webkit-user-content-filter-store :pointer) ;; GBoxed struct WebKitUserContentFilterStore

(defcfun "webkit_user_content_filter_store_new" webkit-user-content-filter-store
  (storage-path :string))
(export 'webkit-user-content-filter-store-new)

(defcfun "webkit_user_content_filter_store_fetch_identifiers" :void
  (store (g-object webkit-user-content-filter-store))
  (cancellable :pointer)                ; GCancellable
  (callback g-async-ready-callback)
  (user-data :pointer))
(export 'webkit-user-content-filter-store-fetch-identifiers)

(defcfun "webkit_user_content_filter_store_fetch_identifiers_finish" (:pointer :string)
  (store (g-object webkit-user-content-filter-store))
  (result g-async-result))
(export 'webkit-user-content-filter-store-fetch-identifiers-finish)

(defcfun "webkit_user_content_filter_store_get_path" :string
  (store (g-object webkit-user-content-filter-store)))
(export 'webkit-user-content-filter-store-get-path)

(defcfun "webkit_user_content_filter_store_load" :void
  (store (g-object webkit-user-content-filter-store))
  (identifier :string)
  (cancellable :pointer)                ; GCancellable
  (callback g-async-ready-callback)
  (user-data :pointer))
(export 'webkit-user-content-filter-store-load)

(defcfun ("webkit_user_content_filter_store_load_finish" %webkit-user-content-filter-store-load-finish)
    (g-object webkit-user-content-filter)
  (store (g-object webkit-user-content-filter-store))
  (result g-async-result)
  (g-error :pointer))

(defun webkit-user-content-filter-store-load-finish (store result)
  (glib:with-g-error (err)
    (%webkit-user-content-filter-store-load-finish store result err)))
(export 'webkit-user-content-filter-store-load-finish)

(defcfun "webkit_user_content_filter_store_remove" :void
  (store (g-object webkit-user-content-filter-store))
  (identifier :string)
  (cancellable :pointer)                ; GCancellable
  (callback g-async-ready-callback)
  (user-data :pointer))
(export 'webkit-user-content-filter-store-remove)

(defcfun ("webkit_user_content_filter_store_remove_finish" %webkit-user-content-filter-store-remove-finish) :bool
  (store (g-object webkit-user-content-filter-store))
  (result g-async-result)
  (g-error :pointer))

(defun webkit-user-content-filter-store-remove-finish (store result)
  (glib:with-g-error (err)
    (%webkit-user-content-filter-store-remove-finish store result err)))
(export 'webkit-user-content-filter-store-remove-finish)

(defcfun "webkit_user_content_filter_store_save" :void
  (store (g-object webkit-user-content-filter-store))
  (identifier :string)
  (source :pointer) ; GBytes
  (cancellable :pointer)                ; GCancellable
  (callback g-async-ready-callback)
  (user-data :pointer))
(export 'webkit-user-content-filter-store-save)

(defcfun ("webkit_user_content_filter_store_save_finish" %webkit-user-content-filter-store-save-finish)
    (g-object webkit-user-content-filter)
  (store (g-object webkit-user-content-filter-store))
  (result g-async-result)
  (g-error :pointer))

(defun webkit-user-content-filter-store-save-finish (store result)
  (glib:with-g-error (err)
    (%webkit-user-content-filter-store-save-finish store result err)))
(export 'webkit-user-content-filter-store-save-finish)

(defcfun "webkit_user_content_filter_store_save_from_file" :void
  (store (g-object webkit-user-content-filter-store))
  (identifier :string)
  (file (g-object gio:g-file))
  (cancellable :pointer)                ; GCancellable
  (callback g-async-ready-callback)
  (user-data :pointer))
(export 'webkit-user-content-filter-store-save-from-file)

(defcfun ("webkit_user_content_filter_store_save_from_file_finish" %webkit-user-content-filter-store-save-from-file-finish)
    (g-object webkit-user-content-filter)
  (store (g-object webkit-user-content-filter-store))
  (result g-async-result)
  (g-error :pointer))

(defun webkit-user-content-filter-store-save-from-file-finish (store result)
  (glib:with-g-error (err)
    (%webkit-user-content-filter-store-save-from-file-finish store result err)))
(export 'webkit-user-content-filter-store-save-from-file-finish)

(in-package #:cl-user)


(defun main-retumilo ()
  "A single-window browser with no keyboard or mouse input.
Loads and renders a single web page."
  (gtk:within-main-loop							 ;main loop
   (let* ((win (make-instance 'gtk:gtk-window)) ;create gtk-window object
           (manager (make-instance 'webkit:webkit-website-data-manager
                                   :base-data-directory "testing-data-manager")) ;data-manager TODO what is it? See auto generated folder with the given name
           (context (make-instance 'webkit:webkit-web-context
                                   :website-data-manager manager)) ;web-context is like a usage profile
           (view (make-instance 'webkit2:webkit-web-view
                                :web-context context)) ;a webview
		   (content-manager (webkit:webkit-web-view-get-user-content-manager view))) ;alter website styling with css
	  ;; Apply the style sheet (CSS)
	  (when *custom-css*
		(add-custom-css content-manager))
	  ;; on window destuction leave gtk-main loop
	  (gobject:g-signal-connect win "destroy"
                                #'(lambda (widget)
                                    (declare (ignore widget))
                                    (gtk:leave-gtk-main)))
	  ;; bind key binding
	  (gobject:g-signal-connect win "key_press_event"
								(lambda (widget event)
								  (declare (ignorable widget event))
								  (let ((key (read-key-press-event event)))
									(format t "Key Event: ~A~%" key) ; Debug output to stdout
									;; C-g -> go to URL google.com
									(when (equalp key (make-key :keysym #\g :control t))
									  (webkit2:webkit-web-view-load-uri view "http://www.google.com"))
									;; C-d -> go to URL duckduckgo.com
									(when (equalp key (make-key :keysym #\d :control t))
									  (webkit2:webkit-web-view-load-uri view "http://www.duckduckgo.com"))
									;; C-t -> go to URL selected with dmenu
									(when (equalp key (make-key :keysym #\t :control t))
									  (let* ((oldurl (webkit2:webkit-web-view-uri view))
											 (newurl (uiop:run-program (list "dmenu" "-p" "URL: ")
																	   :input (list oldurl)
																	   :output :string)))
										(webkit2:webkit-web-view-load-uri view newurl)))))
								:after t)
	  ;; Add content-filter for AD-Blocking
	  ;;(webkit2:webkit-user-content-manager-add-filter content-manager filter)
	  ;; (let ((user-content-filter-store (webkit2:webkit-user-content-filter-store-new "user-content-filter-store")))
	  ;; 	(webkit2:webkit-user-content-filter-store-save-from-file
	  ;; 	 user-content-filter-store
	  ;; 	 "default"
	  ;; 	 (gio:g-file-new-for-path "ucf.json")
	  ;; 	 nil
	  ;; 	 nil
	  ;; 	 nil))
	  ;; add the web view to the gtk window to display
      (gtk:gtk-container-add win view)
	  ;; load a URL
      (webkit2:webkit-web-view-load-uri view "http://www.duckduckgo.com")
	  ;; TODO what does this do?
	  (gtk:gtk-widget-show-all win))))

(main-retumilo)
