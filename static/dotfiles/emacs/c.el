;; -*- emacs-lisp -*-

(require 'cc-mode)
;(require 'guess-offset)
(require 'column-marker)

(setq c-default-style "stroustrup"
      c-basic-offset 4
      c-hanging-braces-alist nil
      c-indent-comments-syntactically-p t
      c-style-variables-are-local-p nil
      c-cleanup-list '(defun-close-semi
                        compact-empty-funcall
                        list-close-comma
                        scope-operator
                        compact-empty-funcall))

(add-to-mode-alist-ext 'c-mode "h")

(define-key c-mode-base-map "\C-m" 'newline-and-indent)

(defun c-mode-setup ()
  (c-toggle-auto-hungry-state 1)
  (column-marker-1 80))

(add-hook 'c-mode-common-hook 'c-mode-setup)

(show-trailing-whitespace-in 'c-mode-common-hook)

;; -- kernel coding style --

(defvar c-kernel-coding-style-dirs)

(defun c-lineup-arglist-tabs-only (ignored)
  "Line up argument lists by tabs, not spaces"
  (let* ((anchor (c-langelem-pos c-syntactic-element))
         (column (c-langelem-2nd-pos c-syntactic-element))
         (offset (- (1+ column) anchor))
         (steps (floor offset c-basic-offset)))
    (* (max steps 1)
       c-basic-offset)))

(defun is-filename-in-dirs (filename dirs)
  (if (consp dirs)
      (let ((abs-file-name (expand-file-name filename))
            (abs-dir-name (expand-file-name (car dirs))))
        (or (string-match abs-dir-name abs-file-name)
            (is-filename-in-dirs filename (cdr dirs))))))

(defun c-kernel-mode-hook ()
  (let ((filename (buffer-file-name)))
    ;; Enable kernel mode for the appropriate files
    (when (and filename
               (is-filename-in-dirs filename c-kernel-coding-style-dirs))
      (setq indent-tabs-mode t)
      (c-set-style "linux")
      (setq tab-width 8)
      (c-set-offset 'arglist-cont-nonempty
                    '(c-lineup-gcc-asm-reg
                      c-lineup-arglist-tabs-only)))))

(add-hook 'c-mode-hook #'c-kernel-mode-hook)
