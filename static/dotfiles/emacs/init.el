;; -*- emacs-lisp -*-

;
; Global conventions:
; - everything version-controlled goes to ~/.emacs.d/
; - external code to be version-controlled goes to ~/.emacs.d/code/ (in load-path)
; - external code to be checked out manually goes to ~/.lib-emacs/ (not in
;   load-path), and have to be conditional in ~/.emacs.d/*.el
; - various files (caches, temporary files etc) go to ~/.var-emacs/
; - customizations are avoided at all costs
;

(load "~/.emacs.d/functions.el")
(add-to-list 'load-path "~/.emacs.d/code")

(load-init
 "dvorak-adjustments"

 "auto-save"
 "backup"
 "bbdb"
 "c"
 "debian"
 "dict"
 "dired"
 "django"
 "e"
 "editing"
 "fb2"
 "gnuserv"
 "gnus-pre"
 "i18n"
 "indent"
 "look"
 "misc"
 "org-mode"
 "perl"
 "programming"
 "python"
 "rpm"
 "tramp-init"
 "woman"
 "x"
 "xml")

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:stipple nil :background "#eee" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 78 :width normal :foundry "unknown" :family "Liberation Mono"))))
 '(font-lock-builtin-face ((((class color) (min-colors 88) (background light)) (:foreground "NavyBlue"))))
 '(font-lock-comment-face ((((class color) (min-colors 88) (background light)) (:foreground "SeaGreen"))))
 '(font-lock-keyword-face ((((class color) (min-colors 88) (background light)) (:foreground "blue4"))))
 '(font-lock-string-face ((((class color) (min-colors 88) (background light)) (:foreground "LightSteelBlue4"))))
 '(font-lock-variable-name-face ((((class color) (min-colors 88) (background light)) (:foreground "blue1"))))
 '(region ((((class color) (min-colors 88) (background light)) (:background "navy" :foreground "white")))))
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(browse-url-browser-function (quote browse-url-generic)))
