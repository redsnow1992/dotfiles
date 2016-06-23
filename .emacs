;;;;;;;;;;;;;;;;;;;;;;
;; install package
;;;;;;;;;;;;;;;;;;;;;;

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;; use eim to support chinese input method
(add-to-list 'load-path "/usr/share/emacs/site-lisp/eim")
(autoload 'eim-use-package "eim" "Another emacs input method")
;; Tooltip not very good 
(setq eim-use-tooltip nil)

;; (register-input-method
;;  "eim-wb" "euc-cn" 'eim-use-package
;;  "五笔" "汉字五笔输入法" "wb.txt")
(register-input-method
 "eim-py" "euc-cn" 'eim-use-package
 "拼音" "汉字拼音输入法" "py.txt")
;; use ';' to input english for a short 
(require 'eim-extra)
(global-set-key ";" 'eim-insert-ascii) 

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(default-input-method "eim-py")
 '(display-time-mode t)
 '(ecb-options-version "2.40")
 '(horizontal-scroll-bar-mode nil)
 '(package-selected-packages (quote (queue jdee flycheck ensime clojure-mode)))
 '(quack-fontify-style nil)
 '(scroll-bar-mode nil)
 '(send-mail-function (quote mailclient-send-it))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "WenQuanYi Micro Hei Mono" :foundry "unknown" :slant normal :weight normal :height 143 :width normal)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;  display time
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(display-time-mode 1)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; global key setting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (global-set-key "\M-\\" 'auto-complete-mode)
(global-set-key [C-tab] 'other-window)
(windmove-default-keybindings)
(setq windmove-wrap-around t)

;;========================================
;;      SLIME setting
(add-to-list 'load-path "/usr/share/emacs/site-lisp/slime/")
(setq inferior-lisp-program "/usr/bin/sbcl")
(require 'slime-autoloads)
(slime-setup '(slime-fancy))
;(slime-setup)

;;===============================================
;;    auto-complete parenthese
(defun my-auto-pair ()
  (interactive)
  (make-local-variable 'skeleton-pair-alist)
  (setq skeleton-pair-alist  '(
                               (?` ?` _ "''")
                               (?\( _ ")")
                               (?\[ _ "]")
                               (?{ _ "}")
			       (?\" _ "\"")))
  ;; (?{ \n > _ \n ?} >)
  
  (setq skeleton-pair t)
  (local-set-key (kbd "(") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "{") 'skeleton-pair-insert-maybe)
  ;; (local-set-key (kbd "`") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "[") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "\"") 'skeleton-pair-insert-maybe))

(add-hook 'c-mode-hook 'my-auto-pair)
(add-hook 'c++-mode-hook 'my-auto-pair)
(add-hook 'java-mode-hook 'my-auto-pair)
(add-hook 'php-mode-hook 'my-auto-pair)
(add-hook 'lisp-mode-hook 'my-auto-pair)
(add-hook 'enh-ruby-mode-hook 'my-auto-pair)
(add-hook 'web-mode-hook 'my-auto-pair)
(add-hook 'haskell-mode-hook 'my-auto-pair)
(add-hook 'org-mode 'my-auto-pair)
(add-hook 'scala-mode 'my-auto-pair)

;;==========================================
;;   region shifting
;;==========================================
;; activate CUA mode
;; go to the beginning of line
;; C-RET, now if you move the cursor you should see a rectangular red region
;; Move the cursor down the lines and type space until you've obtained the cor;; rect shifting.
(defun shift-text(distance)
  (if (use-region-p)
      (let ((mark (mark)))
	(save-excursion
	  (indent-rigidly (region-beginning)
			  (region-end)
			  distance)
	  (push-mark mark t t)
	  (setq deactivate-mark nil)))
    (indent-rigidly (line-beginning-position)
		    (line-end-position)
		    distance)))

(defun shift-right (count)
  (interactive "p")
  (shift-text count))
(defun shift-left (count)
  (interactive "p")
  (shift-text (- count)))
;;  use C-u 3 M-x function or C-u 3 M-e (has bound) 

;;; let the mouse move a distance when the curser against it
(mouse-avoidance-mode `animate)

;;;;;;;;;;;;;;;;;;;;;
;;; Code folder (hide show)
;;;;;;;;;;;;;;;;;;;;
(load-library "hideshow")
(add-hook 'c-mode-hook 'hs-minor-mode)
(add-hook 'c++-mode-hook 'hs-minor-mode)
(add-hook 'java-mode-hook 'hs-minor-mode)
(add-hook 'php-mode-hook 'hs-minor-mode)
(add-hook 'lisp-mode-hook 'hs-minor-mode)
(add-hook 'emacs-lock-mode 'hs-minor-mode)
(add-hook 'web-mode 'hs-minor-mode)
(add-hook 'haskell-mode 'hs-minor-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; redirect the backup files
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq backup-directory-alist (quote (("." . "~/.backups-emacs"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  color-theme
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list  'load-path "/usr/share/emacs/site-lisp/color-theme/")
(require 'color-theme)
(color-theme-initialize)
(color-theme-calm-forest)
;; (color-theme-euphoria)
;; (color-theme-hober)
;; (color-theme-lawrence)
;; (color-theme-lethe)
;; (color-theme-oswald)
;; (color-theme-renegade)
;; (color-theme-robin-hood)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  emacs org-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
;; (org-babel-do-load-languages
;;  'org-babel-load-languages
;;  '((C t)
;;    (js t)
;;    (latex t)
;;    (lisp t)
;;    (matlab t)
;;    (org t)
;;    (ruby t)))
 

;; org todo setting
(setq org-todo-keywords
      '((sequence "TODO(t!)" "NEXT(n)" "WAITTING(w)" "SOMEDAY(s)" "|" "DONE(d@/)" "CANCEL(a@/)")
	))
(setq org-todo-keyword-faces
      '(("Working" . (:background "red" :foreground "white" :weight bold))
	("Learning" . (:background "white" :foreground "red" :weight bold))
	("Relaxing" . (:background "MediumBlue" :weight bold))
	("PENDING" . (:background "LightGreen" :foreground "gray" :weight bold))
	("TODO" . (:background "DarkOrange" :foreground "black" :weight bold))
	("DONE" . (:background "azure" :foreground "Darkgreen" :weight bold))
	("CANCEL" . (:background "gray" :foreground " black" :weight bold))
	))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Web editing setting
;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; slim mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'slim-mode)
(add-to-list 'auto-mode-alist '("\\.slim\\'" . slim-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; other setting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(desktop-save-mode 1)
;; (ido-mode t)
(auto-fill-mode t)
(setq inhibit-startup-message t)
(setq scroll-margin 3 scroll-conservatively 10000)
;; (set-frame-position (selected-frame) 400 10)
;; (set-frame-width (selected-frame) 70)
;; (set-frame-height (selected-frame) 100)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; auto reload modified buffers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-auto-revert-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Haskell mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "/usr/share/emacs/site-lisp/haskell-mode/")
(load "haskell-mode-autoloads.el")
(require 'haskell-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-to-list 'auto-mode-alist '("\\.hs\\'" . haskell-mode))
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

;;;;;;;;;;;;;;;;;;;;
;; Scheme
;;;;;;;;;;;;;;;;;;;;
(autoload 'paredit-mode "paredit"
  "Minor mode for pseudo-structurally editing Lisp code."
  t)

(require 'cmuscheme)
(setq scheme-program-name "petite")         ;; 如果用 Petite 就改成 "petite"

;; bypass the interactive question and start the default interpreter
(defun scheme-proc ()
  "Return the current Scheme process, starting one if necessary."
  (unless (and scheme-buffer
               (get-buffer scheme-buffer)
               (comint-check-proc scheme-buffer))
    (save-window-excursion
      (run-scheme scheme-program-name)))
  (or (scheme-get-process)
      (error "No current process. See variable `scheme-buffer'")))

(defun scheme-split-window ()
  (cond
   ((= 1 (count-windows))
    (delete-other-windows)
    (split-window-vertically (floor (* 0.68 (window-height))))
    (other-window 1)
    (switch-to-buffer "*scheme*")
    (other-window 1))
   ((not (find "*scheme*"
               (mapcar (lambda (w) (buffer-name (window-buffer w)))
                       (window-list))
               :test 'equal))
    (other-window 1)
    (switch-to-buffer "*scheme*")
    (other-window -1))))

(defun scheme-send-last-sexp-split-window ()
  (interactive)
  (scheme-split-window)
  (scheme-send-last-sexp))


(defun scheme-send-definition-split-window ()
  (interactive)
  (scheme-split-window)
  (scheme-send-definition))

(add-hook 'scheme-mode-hook
	  (lambda ()
    (paredit-mode 1)
    (define-key scheme-mode-map (kbd "<f5>") 'scheme-send-last-sexp-split-window)
    (define-key scheme-mode-map (kbd "<f6>") 'scheme-send-definition-split-window)))

;; (add-to-list 'load-path "/usr/share/emacs/site-lisp/scala-mode2")
;; (require 'scala-mode2)
;; (add-to-list 'auto-mode-alist '("\\.scala\\'" . scala-mode))

;;;;;;;;;;;
; flychec
(add-hook 'after-init-hook #'global-flycheck-mode)

;;;;;;;;;;;;;;;;
;; show paren_mode

(show-paren-mode 1)
(require 'paren)
(set-face-attribute 'show-paren-match nil :weight 'extra-bold)
(defadvice show-paren-function
      (after show-matching-paren-offscreen activate)
      "If the matching paren is offscreen, show the matching line in the
        echo area. Has no effect if the character before point is not of
        the syntax class ')'."
      (interactive)
      (let* ((cb (char-before (point)))
             (matching-text (and cb
                                 (char-equal (char-syntax cb) ?\) )
                                 (blink-matching-open))))
        (when matching-text (message matching-text))))

;;;;;;;;;;;;;;;;;;
;;;;
(add-to-list 'auto-mode-alist '("\\.lisp\\'" . paredit-mode))
(add-to-list 'auto-mode-alist '("\\.lisp\\'" . lisp-mode))

;;;;;;;;;;;;;;;;;;;;
;; nxml mode
(add-to-list 'load-path "/usr/share/emacs/site-lisp/nxml-mode-20041004/")
(load "rng-auto.el")
(add-to-list 'auto-mode-alist
	     (cons (concat "\\." (regexp-opt '("xml" "xsd" "sch" "rng" "xslt" "svg" "rss") t) "\\'")
		   'nxml-mode))
;; (unify-8859-on-decoding-mode)
;; (setq magic-mode-alist
;;       (cons '("<＼＼?xml " . nxml-mode)
;; 	    magic-mode-alist))
;; (fset 'xml-mode 'nxml-mode)
(put 'upcase-region 'disabled nil)
;;;;;;;;;;;;;;;;;;;;
;; metafont-mode
(autoload 'metafont-mode "meta-mode" t)
(autoload 'metapost-mode "meta-mode" t)
(setq auto-mode-alist
      (append '(("\\.mf\\'" . metafont-mode)
		("\\.mp\\'" . metapost-mode))
	      auto-mode-alist))

(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
;; ;; load quicklisp
;; (load (expand-file-name "~/quicklisp/slime-helper.el"))

(add-to-list 'load-path "/usr/share/emacs/site-lisp/company-mode/")
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)

;;; cider
;; (add-to-list 'load-path "/usr/share/emacs/site-lisp/cider/")
;; (require 'cider)
;; (add-to-list 'package-pinned-packages '(cider . "melpa-stable") t)
;; (add-hook 'cider-mode-hook #'eldoc-mode)
;; (setq nrepl-log-messages t)
;; (add-hook 'cider-repl-mode-hook #'company-mode)
;; (add-hook 'cider-mode-hook #'company-mode)
;; (add-hook 'cider-repl-mode-hook #'paredit-mode)
;; (add-hook 'clojure-mode-hook #'paredit-mode)
 
;; enhanced-ruby-mode 
(add-to-list 'load-path "/usr/share/emacs/site-lisp/enhanced-ruby-mode/")
(autoload 'enh-ruby-mode "enh-ruby-mode" "Major mode for ruby files" t)
(add-to-list 'auto-mode-alist '("\\.rb$" . enh-ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . enh-ruby-mode))

;; ensime mode
(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)