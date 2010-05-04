;;; -*- emacs-lisp -*-

(require 'gud)

(global-set-key [f5] 'gud-cont)

(global-set-key [C-f8] 'gud-break)
(global-set-key [S-f11] 'gud-finish)
(global-set-key [f10] 'gud-next)
(global-set-key [f11] 'gud-step)

(defun show-exp (arg) (interactive "M Enter expression:")
  (gud-call (concat "p " arg)))

(global-set-key [C-f7] 'show-exp)

(defun gdb-buffer-name ()
  (concat "*gud-" compilefile "*"))

(defun source-file-name ()
  (concat compilefile ".cpp"))

(defun gud-stop () (interactive)
  (gud-call "quit")
  (kill-buffer (gdb-buffer-name))
  (delete-other-windows))

(global-set-key [S-f5] 'gud-stop)

(defvar startdebugger nil)
(defvar compilefile nil)

(setq compilation-finish-function
      (lambda (buffer msg)
        (if (and (equal msg "finished\n") startdebugger)
            (gud-start-debug))))

(defun buildfile () (interactive)
  (setq compilefile (substring (buffer-name) 0 -4))
  (compile (concat "g++ -o " compilefile " -g " (source-file-name))))

(global-set-key [f7] 'buildfile)

(defun gud-start () (interactive)
  (setq startdebugger t)
  (buildfile))

(defun gud-start-debug ()
  (setq startdebugger nil)
  (gdb (concat "gdb " compilefile))
  (gud-call (concat "set args < " compilefile ".in"))
  (gud-call "set confirm off")
  (gud-call "tbreak main")
  (gud-call "run")

  (let ((main-wnd (selected-window))
        (gdb-wnd nil)
        (compiler-wnd nil))
    (delete-other-windows)
    (setq gdb-wnd (split-window-vertically -10))
    (select-window gdb-wnd)
    (setq compiler-wnd (split-window-horizontally))

    (set-window-buffer main-wnd (source-file-name))
    (set-window-buffer gdb-wnd (gdb-buffer-name))
    (set-window-buffer compiler-wnd "*compilation*")
    (select-window main-wnd)))

    
(global-set-key [C-f9] 'gud-start)

(defun gud-runto () (interactive)
  (gud-call "tbreak %f:%l")
  (gud-call "cont"))

(global-set-key [C-f10] 'gud-runto)

