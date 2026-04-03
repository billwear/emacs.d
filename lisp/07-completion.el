(use-package ivy
  :init (ivy-mode 1)
  :config
  (setq ivy-use-virtual-buffers t
        ivy-count-format "(%d/%d) "
        ivy-wrap t
        ivy-re-builders-alist '((t . ivy--regex-plus))
        ivy-height 15
        ivy-fixed-height-minibuffer t
        ivy-initial-inputs-alist nil
        ivy-extra-directories nil
        ivy-format-function #'ivy-format-function-arrow)
  :bind (("C-c v"   . ivy-resume)
         ("C-x b"   . ivy-switch-buffer)))

(use-package counsel
  :after ivy
  :bind (("M-x"     . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("C-x C-r" . counsel-recentf)
         ("C-h f"   . counsel-describe-function)
         ("C-h v"   . counsel-describe-variable)
         ("C-h o"   . counsel-describe-symbol)
         ("C-c f"   . counsel-fzf)
         ("C-c g"   . counsel-git)
         ("C-c k"   . counsel-rg)
         ("C-c l"   . counsel-locate))
  :custom
  (counsel-preselect-current-file t)
  (counsel-find-file-ignore-regexp
   (regexp-opt '(".git/" ".DS_Store" "node_modules/")))
  :config (counsel-mode 1))

(use-package ivy-rich
  :after ivy
  :init (ivy-rich-mode 1)
  :config (setq ivy-rich-path-style 'abbrev))

(use-package prescient
  :config (prescient-persist-mode 1))

(use-package ivy-prescient
  :after (ivy prescient)
  :config (ivy-prescient-mode 1))

(use-package which-key
  :custom
  (which-key-popup-type 'side-window)
  (which-key-side-window-location 'bottom)
  (which-key-idle-delay 0.5)
  (which-key-max-display-columns 4)
  (which-key-sort-order 'which-key-key-order-alpha)
  :config (which-key-mode 1))
