(require 'xah-fly-keys)

(xah-fly-keys-set-layout "qwerty")

(defun bindkey-insert-mode ()
  "Define keys for `xah-fly-insert-mode-activate-hook'."
  (interactive)
  (define-key xah-fly-key-map (kbd "<escape>") 'xah-fly-command-mode-activate))

(defun bindkey-command-mode ()
  "Define keys for `xah-fly-command-mode-activate-hook'."
  (interactive)
  (define-key xah-fly-key-map (kbd "q") 'keyboard-escape-quit))

(add-hook 'xah-fly-insert-mode-activate-hook 'bindkey-insert-mode)
(add-hook 'xah-fly-command-mode-activate-hook 'bindkey-command-mode)

(defun smart-quit (&optional flag)
  "Kill the buffer and window, if FLAG is t, save the current buffer."
  (interactive)
  (when flag
	(save-buffer))
  (if (one-window-p)
	  (save-buffers-kill-emacs)
	(delete-window)))

(xah-fly--define-keys
 (define-prefix-command 'projectile-keymap)
 '(("u" . helm-projectile-find-file) ; f
   ("l" . helm-projectile) ; p
   ("p" . helm-projectile-grep) ; r
   ))

(xah-fly--define-keys
 (define-prefix-command 'xah-fly-leader-key-map)
 '(("1" . nil)
   ("2" . nil)
   ("3" . nil)
   ("4" . nil)
   ("5" . nil)
   ("6" . nil)
   ("7" . nil)
   ("8" . nil)
   ("9" . nil)
   ("0" . nil)
   ("a" . nil) ; a
   ("x" . helm-mini) ; b
   ("j" . nil) ; c
   ("e" . nil) ; d
   ("." . nil) ; e
   ("u" . helm-find-files) ; f
   ("i" . magit) ; g
   ("d" . nil) ; h
   ("c" . nil) ; i
   ("h" . nil) ; j
   ("t" . nil) ; k
   ("n" . nil) ; l
   ("m" . nil) ; m
   ("b" . nil) ; n
   ("r" . nil) ; o
   ("l" . projectile-keymap) ; p
   ("'" . smart-quit) ; q
   ("p" . helm-grep) ; r
   ("o" . nil) ; s
   ("y" . nil) ; t
   ("g" . nil) ; u
   ("k" . nil) ; v
   ("," . save-buffer) ; w
   ("q" . (lambda () (interactive) (smart-quit t))) ; x
   ("f" . nil) ; y
   (";" . nil) ; z
   ("s" . nil) ; ;
   ("v" . nil) ; .
   ("w" . nil) ; ,
   ("-" . nil) ; '
   ("z" . nil) ; /
   ("]" . nil) ; =
   ("/" . nil) ; [
   ("=" . nil) ; ]
   ))

(xah-fly-keys 1)

(global-set-key (kbd "S-SPC") (lambda () (interactive) (when xah-fly-insert-state-q (company-complete))))
(global-set-key (kbd "<backtab>") 'tab-to-tab-stop)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Special map bindings
(require 'company)
(with-eval-after-load 'company
  (define-key company-active-map (kbd "S-SPC") 'company-abort)
  (define-key company-active-map (kbd "<tab>") 'company-select-next)
  (define-key company-active-map (kbd "<backtab>") 'company-select-previous))

(require 'helm)
(with-eval-after-load 'helm
  (define-key helm-map (kbd "<tab>") 'helm-next-line)
  (define-key helm-map (kbd "<backtab>") 'helm-previous-line))

(require 'magit)
(with-eval-after-load 'magit
  (define-key magit-mode-map (kbd "c") 'magit-commit)
  (define-key magit-mode-map (kbd "p") 'magit-push)
  (define-key magit-mode-map (kbd "j") 'backward-char)
  (define-key magit-mode-map (kbd "i") 'previous-line)
  (define-key magit-mode-map (kbd "k") 'next-line)
  (define-key magit-mode-map (kbd "l") 'forward-char))

(provide 'config-bindings)
