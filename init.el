;; MELPA repository
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

;; Initialize use-package
(package-refresh-contents)
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq-default use-package-always-ensure t)

;; MacOS settings
(when (memq window-system '(mac ns x))
  (use-package exec-path-from-shell
    :config
	(exec-path-from-shell-initialize)))

;; Variables settings
(setq custom-file
      (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;; Appearance
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

;; Columns/Lines
(line-number-mode t)
(column-number-mode t)

;; Better scrolling
(setq scroll-margin 0)
(setq scroll-conservatively 10000)
(setq scroll-preserve-screen-position t)
(setq mouse-wheel-progressive-speed nil)

;; Better prompt
(defalias 'yes-or-no-p 'y-or-n-p)
(setq confirm-kill-emacs nil)

;; UTF-8 settings
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; Text appearance
(set-frame-font "Inconsolata-12" nil t)

;; Line numbers
(setq-default linum-format " %d ")
(add-hook 'prog-mode-hook (lambda ()
							(if (version<= "26.0.50" emacs-version)
								(global-display-line-numbers-mode)
							  (linum-mode))
							(set-face-underline 'linum nil)))

;; Miscellaneous settings
(setq auto-save-default nil)
(setq completion-ignore-case t)
(setq make-backup-files nil)
(setq read-file-name-completion-ignore-case t)
(setq require-final-newline t)
(setq ring-bell-function 'ignore)
(global-subword-mode 1)
(show-paren-mode t)
(blink-cursor-mode -1)
(delete-selection-mode t)

;; Xah-fly-keys settings
(use-package xah-fly-keys
  :init
  (setq xah-fly-use-control-key nil)
  (defun bindkey-insert-mode ()
	"Define keys for `xah-fly-insert-mode-activate-hook'."
	(interactive)
	(define-key xah-fly-key-map (kbd "<escape>") 'xah-fly-command-mode-activate))
  (defun bindkey-command-mode ()
	"Define keys for `xah-fly-command-mode-activate-hook'."
	(interactive)
	(define-key xah-fly-key-map (kbd ";") 'keyboard-escape-quit)
	(define-key xah-fly-key-map (kbd "'") 'xah-comment-dwim)
	(define-key xah-fly-key-map (kbd ",") 'xah-backward-kill-word)
	(define-key xah-fly-key-map (kbd ".") (lambda () "Kill word at point." (interactive)
											(let ((bounds (bounds-of-thing-at-point 'word)))
											  (if bounds
												  (kill-region (car bounds) (cdr bounds))
												nil))))
	(define-key xah-fly-key-map (kbd "e") 'delete-backward-char)
	(define-key xah-fly-key-map (kbd "x") 'xah-shrink-whitespaces)
	(define-key xah-fly-key-map (kbd "b") 'helm-occur))
  (add-hook 'xah-fly-insert-mode-activate-hook 'bindkey-insert-mode)
  (add-hook 'xah-fly-command-mode-activate-hook 'bindkey-command-mode)
  :config
  (xah-fly--define-keys
   (define-prefix-command 'xah-fly-leader-key-map)
   '(("SPC" . helm-mini)
	 ("'" . nil) ; q
	 ("," . nil) ; w
	 ("." . nil) ; e
	 ("p" . nil) ; r
	 ("y" . er/expand-region) ; t
	 ("f" . nil) ; y
	 ("g" . nil) ; u
	 ("c" . nil) ; i
	 ("r" . nil) ; o
	 ("l" . nil) ; p
	 ("a" . nil) ; a
	 ("o" . nil) ; s
	 ("e" . delete-char) ; d
	 ("u" . avy-goto-char-2) ; f
	 ("i" . nil) ; g
	 ("d" . nil) ; h
	 ("h" . nil) ; j
	 ("t" . nil) ; k
	 ("n" . nil) ; l
	 ("s" . nil) ; ;
	 (";" . nil) ; z
	 ("q" . (lambda () (interactive) (if (one-window-p) (kill-emacs) (delete-window)))) ; x
	 ("j" . (lambda () (interactive) (delete-trailing-whitespace) (save-buffer))) ; c
	 ("k" . helm-find-files) ; v
	 ("x" . nil) ; b
	 ("b" . (lambda () (interactive) (if (projectile-project-p) (helm-projectile-grep) (helm-for-files)))) ; n
	 ("m" . previous-buffer) ; m
	 ("w" . split-window-right) ; ,
	 ("v" . next-buffer) ; .
	 ("z" . nil) ; /
	 ))
  (xah-fly-keys 1))

(use-package zoom
  :config
  (zoom-mode)
  (setq zoom-size '(0.666 . 0.666)))

(use-package dashboard
  :config
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-items '((recents  . 5)
						  (bookmarks . 5)
						  (projects . 5)))
  (dashboard-setup-startup-hook))

(use-package elcord
  :config
  (elcord-mode))

(use-package aggressive-indent
  :config
  (global-aggressive-indent-mode 1))

(use-package expand-region)

(use-package smartparens
  :config
  (require 'smartparens-config)
  (smartparens-global-mode 1))

(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package avy
  :config
  (setq avy-background t)
  (setq avy-keys '(?a ?o ?e ?u ?h ?t ?n ?s)))

(use-package atom-one-dark-theme
  :config
  (load-theme 'atom-one-dark t)
  (custom-set-faces
   '(font-lock-variable-name-face ((t (:foreground "#D6BDDB"))))))

(use-package flycheck
  :config
  (define-fringe-bitmap 'flycheck-fringe-bitmap-ball
	(vector #b00000000
			#b00000000
			#b00000000
			#b00000000
			#b00000000
			#b00111000
			#b01111100
			#b11111110
			#b11111110
			#b11111110
			#b01111100
			#b00111000
			#b00000000
			#b00000000
			#b00000000
			#b00000000
			#b00000000))
  (flycheck-define-error-level 'info
	:severity 100
	:compilation-level 2
	:overlay-category 'flycheck-info-overlay
	:fringe-bitmap 'flycheck-fringe-bitmap-ball
	:fringe-face 'flycheck-fringe-info
	:info-list-face 'flycheck-error-list-info)
  (flycheck-define-error-level 'warning
	:severity 100
	:compilation-level 2
	:overlay-category 'flycheck-warning-overlay
	:fringe-bitmap 'flycheck-fringe-bitmap-ball
	:fringe-face 'flycheck-fringe-warning
	:warning-list-face 'flycheck-error-list-warning)
  (flycheck-define-error-level 'error
	:severity 100
	:compilation-level 2
	:overlay-category 'flycheck-error-overlay
	:fringe-bitmap 'flycheck-fringe-bitmap-ball
	:fringe-face 'flycheck-fringe-error
	:error-list-face 'flycheck-error-list-error)
  (custom-set-faces
   '(flycheck-info ((t (:underline (:style line :color "#80FF80")))))
   '(flycheck-warning ((t (:underline (:style line :color "#FF9933")))))
   '(flycheck-error ((t (:underline (:style line :color "#FF5C33"))))))
  (flycheck-define-checker python-mypy ""
						   :command ("mypy"
									 "--ignore-missing-imports" "--python-version" "3.7"
									 "--hide-error-context" "--no-strict-optional"
									 source-original)
						   :error-patterns
						   ((error line-start (file-name) ":" line ": error:" (message) line-end))
						   :modes python-mode)
  (add-to-list 'flycheck-checkers 'python-mypy t)
  (flycheck-add-next-checker 'python-pylint 'python-mypy t)
  (setq flycheck-check-syntax-automatically '(mode-enabled save))
  (global-flycheck-mode t))

(use-package helm
  :init
  (with-eval-after-load 'helm
	(define-key helm-map (kbd "<tab>") 'helm-next-line)
	(define-key helm-map (kbd "<backtab>") 'helm-previous-line))
  :config
  (setq helm-boring-file-regexp-list
		'("\\.$" "\\.git*." "\\.o" "\\.a$" "\\.pyc$" "\\.pyo$" "/Library/?" "/Applications/?"))
  (setq helm-display-header-line nil)
  (helm-mode t))

(use-package helm-projectile
  :config
  (projectile-mode t)
  (helm-projectile-on))

(use-package company-c-headers)
(use-package company-jedi)

(use-package company
  :init
  (with-eval-after-load 'company
	(define-key company-active-map (kbd "S-SPC") 'company-abort)
	(define-key company-active-map (kbd "<tab>") 'company-select-next)
	(define-key company-active-map (kbd "<backtab>") 'company-select-previous))
  :config
  (setq company-idle-delay 120)
  (add-to-list 'company-backends 'company-jedi)
  (add-to-list 'company-backends 'company-c-headers)
  (global-company-mode t)
  (custom-set-faces
   '(company-tooltip ((t (:foreground "#ABB2BF" :background "#30343C"))))
   '(company-tooltip-annotation ((t (:foreground "#ABB2BF" :background "#30343C"))))
   '(company-tooltip-selection ((t (:foreground "#ABB2BF" :background "#393F49"))))
   '(company-tooltip-mouse ((t (:background "#30343C"))))
   '(company-tooltip-common ((t (:foreground "#ABB2BF" :background "#30343C"))))
   '(company-tooltip-common-selection ((t (:foreground "#ABB2BF" :background "#393F49"))))
   '(company-preview ((t (:background "#30343C"))))
   '(company-preview-common ((t (:foreground "#ABB2BF" :background "#30343C"))))
   '(company-scrollbar-fg ((t (:background "#30343C"))))
   '(company-scrollbar-bg ((t (:background "#30343C"))))
   '(company-template-field ((t (:foreground "#282C34" :background "#C678DD"))))))

(use-package magit)

(use-package yasnippet-snippets)
(use-package yasnippet
  :config
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (define-key yas-minor-mode-map (kbd "TAB") nil)
  (define-key yas-minor-mode-map (kbd "<tab>") nil)
  (define-key yas-minor-mode-map (kbd "C-SPC") 'yas-expand))

;; Bindings
(global-set-key (kbd "S-SPC") (lambda () (interactive) (when xah-fly-insert-state-q (company-complete))))
(global-set-key (kbd "<backtab>") 'tab-to-tab-stop)

;; General programming settings
(add-hook 'prog-mode-hook (lambda() (setq tab-width 4)))

;; C settings
(setq-default c-default-style "linux")
(setq-default c-basic-offset 4)
(add-hook 'c-mode-hook (lambda()
						 (setq indent-tabs-mode t)
						 (global-aggressive-indent-mode -1)))

;; Python settings
(setq-default python-shell-interpreter "python3")
(setq-default python-indent 4)
(add-hook 'python-mode-hook (lambda()
							  (setq flycheck-python-pylint-executable "python3")
							  (setq flycheck-python-pycompile-executable "python3")))

;; Ocaml settings
(use-package merlin)
(use-package tuareg
  :init
  (add-hook 'tuareg-mode-hook 'merlin-mode)
  :config
  (setq tuareg-match-patterns-aligned t)
  (setq tuareg-indent-align-with-first-arg t))
