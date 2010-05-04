(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (local-set-key "\M-q" 'execute-extended-command)
            (local-set-key "\M-x" 'reindent-lisp)))
