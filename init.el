;; -*- lexical-binding: t -*-

(setq package--init-file-ensured t)

(defconst igneous-required-version "26.1")
(when (version< emacs-version igneous-required-version)
  (error "Requires GNU Emacs %s or newer, but current version is %s" igneous-required-version emacs-version))

(setq gc-cons-threshold most-positive-fixnum)
(setq gc-cons-percentage 0.6)
(defvar igneous--file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(defun igneous--startup ()
  (setq gc-cons-threshold (* 32 1000000)
        gc-cons-percentage 0.1)
  (dolist (handler igneous--file-name-handler-alist)
    (add-to-list 'file-name-handler-alist handler))
  (makunbound 'igneous--file-name-handler-alist))

(add-hook 'after-init-hook #'igneous--startup)

(defvar igneous-dir user-emacs-directory)
(defvar igneous-core-dir (expand-file-name "core" igneous-dir))
(defvar igneous-modules-dir (expand-file-name  "modules" igneous-dir))

(add-to-list 'load-path igneous-core-dir)

(setq custom-file (if (memq system-type '(gnu/linux darwin)) "/dev/null" "NUL"))

(require 'core)

(load (expand-file-name "modules" igneous-dir))
(load (expand-file-name "config" igneous-dir))

(verify-dependencies!)
