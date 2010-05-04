;; -*- emacs-lisp -*-

(defun add-to-mode-alist-ext (mode &rest extensions)
  "Registers association of given file EXTENSIONS with the given MODE"
  (dolist (extension extensions)
    (add-to-list 'auto-mode-alist (cons (concat "\\." extension "$") mode))))

(defun load-init (&rest modules)
  "Loads given modules from ~/.emacs.d"
  (dolist (module modules)
    (load (format "~/.emacs.d/%s" module))))

(defun show-trailing-whitespace ()
  (setq show-trailing-whitespace t))

(defun show-trailing-whitespace-in (hook)
  "Enables trailing whitespace in current buffer when passed hook is called"
  (add-hook hook 'show-trailing-whitespace))
