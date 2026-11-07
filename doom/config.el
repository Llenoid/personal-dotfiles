;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; ============================================================================
;; 1. GENERAL OPTIONS & APPEARANCE
;; ============================================================================
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 20))
;; Use Doom's native Nord variant (included with doom-themes):
(setq doom-theme 'doom-nord)

;; ============================================================================
;; GITSIGNS PARITY CONFIGURATION (MAGIT PREVIEW INTEGRATION)
;; ============================================================================
(set-fringe-mode '(8 . 8))

(after! diff-hl
  (diff-hl-margin-mode +1)
  (diff-hl-flydiff-mode +1)

  ;; 1. Gutter signs matching gitsigns.nvim
  (setq diff-hl-margin-symbols-alist
        '((insert . "┃")
          (delete . "_")
          (change . "┃")
          (unknown . "┆")
          (ignored . "┆")))

  ;; 2. Color overrides for Nord theme parity
  (custom-set-faces!
    '(diff-hl-insert :foreground "#A3BE8C" :background unspecified)
    '(diff-hl-change :foreground "#EBCB8B" :background unspecified)
    '(diff-hl-delete :foreground "#BF616A" :background unspecified)))

(add-hook 'prog-mode-hook #'diff-hl-margin-local-mode)
(add-hook 'text-mode-hook #'diff-hl-margin-local-mode)

;; 3. Keybindings with Magit file/hunk inspection
(map! :leader
      (:prefix-map ("h" . "git hunk")
        :desc "Stage hunk"                  "s" #'diff-hl-stage-current-hunk
        :desc "Reset/Revert hunk"           "r" #'diff-hl-revert-hunk
        :desc "Stage buffer"                "S" #'magit-stage-buffer
        :desc "Undo stage/revert buffer"    "R" #'magit-unstage-buffer
        :desc "Preview hunk via Magit"      "p" #'magit-diff-buffer-file
        :desc "Preview hunk"                "i" #'diff-hl-show-hunk
        :desc "Diff against index"          "d" #'magit-diff-unstaged
        :desc "Diff against last commit"    "D" #'magit-diff-staged
        :desc "Toggle current line blame"   "b" #'magit-blame-addition
        :desc "Set Quickfix list"           "q" #'diff-hl-show-hunk-posframe)

      (:prefix-map ("t" . "toggle")
        :desc "Git blame line"              "b" #'magit-blame-addition
        :desc "Toggle show deleted"         "d" #'diff-hl-inline-popup-toggle
        :desc "Toggle word diff"            "w" #'magit-diff-toggle-refine-hunks))

;; 4. Text Object ('ih' to select git hunk in Visual/Operator state)
(map! :om "ih" #'diff-hl-mark-hunk)

(setq display-line-numbers-type t)
(setq-default tab-width 2
              indent-tabs-mode nil)

(setq scroll-margin 8
      hscroll-margin 8)

(setq select-enable-clipboard t)
(setq undo-limit 80000000)

;; Window splitting behavior
(setq evil-vsplit-window-right t
      evil-split-window-below t)

(setq org-directory "~/dev/org/")

;; Optimize garbage collection and process buffer maximum limits for smoothness
(setq gc-cons-threshold (* 50 1024 1024)  ; Raise GC threshold to 50MB during active use
      read-process-output-max (* 1024 1024)) ; 1MB max output chunk size

;; Throttle redisplay overhead during continuous scrolling
(setq redisplay-dont-pause t
      fast-but-imprecise-scrolling t)

;; Prevent line number width re-calculations from lagging scrolls
(setq display-line-numbers-grow-only t)

;; Filetype Associations (Must run globally on load)
(add-to-list 'auto-mode-alist '("docker-compose.*\\.ya?ml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("compose.*\\.ya?ml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.html\\.tmpl\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.gotmpl\\'"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.j2\\'"         . web-mode))
(add-to-list 'auto-mode-alist '("\\.njk\\'"        . web-mode))
(add-to-list 'auto-mode-alist '("\\.vue\\'"        . web-mode))

;; ============================================================================
;; 2. AUTOCMDS & HOOKS
;; ============================================================================
;; Auto-create parent directories on save
(defun brandon/auto-create-non-existent-directory ()
  (let ((parent-dir (file-name-directory (buffer-file-name))))
    (when (and parent-dir (not (file-exists-p parent-dir)))
      (make-directory parent-dir t))))
(add-hook 'before-save-hook #'brandon/auto-create-non-existent-directory)

;; Prose wrapping and spelling
(add-hook! '(markdown-mode-hook text-mode-hook git-commit-mode-hook)
  #'auto-fill-mode
  #'flyspell-mode)

;; Auto-balance windows on resize
(add-hook 'window-size-change-functions (lambda (_) (balance-windows)))

;; ============================================================================
;; 3. KEYMAPS & EDITOR BEHAVIORS
;; ============================================================================
;; Clear search highlights on ESC
(map! :n "<escape>" #'evil-ex-nohighlight)

;; Wrapped line movement
(map! :nv "j" #'evil-next-visual-line
      :nv "k" #'evil-previous-visual-line)

;; Window Splitting & Management
(map! :leader
      :prefix ("w" . "window")
      :desc "Split window vertically"    "|" #'evil-window-vsplit
      :desc "Split window horizontally" "_" #'evil-window-split
      :desc "Delete window"               "d" #'evil-window-delete)

;; Window Resizing
(map! :n "<C-up>"    #'enlarge-window
      :n "<C-down>"  #'shrink-window
      :n "<C-left>"  #'shrink-window-horizontally
      :n "<C-right>" #'enlarge-window-horizontally)

;; nvim-parity pane navigation (Normal state)
(map! :n
      "C-h" #'evil-window-left
      "C-j" #'evil-window-down
      "C-k" #'evil-window-up
      "C-l" #'evil-window-right)

;; Centered scrolling & search navigation
(map! :n "C-d" (cmd! (evil-scroll-down nil) (recenter-top-bottom))
      :n "C-u" (cmd! (evil-scroll-up nil) (recenter-top-bottom))
      :n "n"   (cmd! (evil-ex-search-next) (recenter-top-bottom))
      :n "N"   (cmd! (evil-ex-search-previous) (recenter-top-bottom)))

;; Visual mode line shifting
(map! :v "J" #'drag-stuff-down
      :v "K" #'drag-stuff-up)

;; Clipboard yanks & registers
(map! :nv "SPC y" '"+y"
      :n  "SPC Y" '"+Y"
      :v  "SPC p" [?\d ?P]
      :nv "SPC d" '"_d")

;; Buffer & Diagnostic Navigation
(map! :n "[b" #'previous-buffer
      :n "]b" #'next-buffer
      :n "SPC b d" #'kill-current-buffer
      :n "[d" #'flycheck-previous-error
      :n "]d" #'flycheck-next-error
      :n "SPC e" #'flycheck-explain-error-at-point
      :n "SPC q" #'flycheck-list-errors)

;; Smart quit buffer (quits special windows with 'q', leaves file buffers intact)
(defun brandon/smart-quit-buffer ()
  "Quit the current window/buffer with 'q' unless it is a file-visiting buffer."
  (interactive)
  (if (buffer-file-name)
      (message "File buffer active — use 'SPC b d' or ':q' to close.")
    (quit-window)))

(map! :n "q" #'brandon/smart-quit-buffer)

;; ============================================================================
;; 4. PLUGINS (DIRED-PREVIEW, TREE-SITTER, FLASH, ORG-APPEAR, EMMET)
;; ============================================================================
(use-package! dired-preview)

(map! :leader
      :map dired-mode-map
      "P" #'dired-preview-mode)

(use-package! evil-textobj-tree-sitter
  :after evil
  :config
  (define-key evil-inner-text-objects-map "F" (evil-textobj-tree-sitter-get-textobj "function.inner"))
  (define-key evil-outer-text-objects-map "F" (evil-textobj-tree-sitter-get-textobj "function.outer"))
  (define-key evil-inner-text-objects-map "C" (evil-textobj-tree-sitter-get-textobj "class.inner"))
  (define-key evil-outer-text-objects-map "C" (evil-textobj-tree-sitter-get-textobj "class.outer"))
  (define-key evil-inner-text-objects-map "P" (evil-textobj-tree-sitter-get-textobj "parameter.inner"))
  (define-key evil-outer-text-objects-map "P" (evil-textobj-tree-sitter-get-textobj "parameter.outer"))
  (define-key evil-inner-text-objects-map "a" (evil-textobj-tree-sitter-get-textobj "parameter.inner"))
  (define-key evil-outer-text-objects-map "a" (evil-textobj-tree-sitter-get-textobj "parameter.outer"))
  (define-key evil-inner-text-objects-map "f" (evil-textobj-tree-sitter-get-textobj "function.inner"))
  (define-key evil-outer-text-objects-map "f" (evil-textobj-tree-sitter-get-textobj "function.outer"))
  (define-key evil-inner-text-objects-map "c" (evil-textobj-tree-sitter-get-textobj "class.inner"))
  (define-key evil-outer-text-objects-map "c" (evil-textobj-tree-sitter-get-textobj "class.outer"))
  (define-key evil-inner-text-objects-map "o" (evil-textobj-tree-sitter-get-textobj ("conditional.inner" "loop.inner")))
  (define-key evil-outer-text-objects-map "o" (evil-textobj-tree-sitter-get-textobj ("conditional.outer" "loop.outer"))))

;; Explicitly constrain parameter motions to Normal state
(map! :n "g]p" (cmd! (evil-textobj-tree-sitter-goto-textobj "parameter.outer"))
      :n "g[p" (cmd! (evil-textobj-tree-sitter-goto-textobj "parameter.outer" t)))

;; Use :nv (Normal + Visual) instead of :nvo or :m to keep Insert mode clean
(map! :nv "]m" (cmd! (evil-textobj-tree-sitter-goto-textobj "function.outer"))
      :nv "[m" (cmd! (evil-textobj-tree-sitter-goto-textobj "function.outer" t))
      :nv "]M" (cmd! (evil-textobj-tree-sitter-goto-textobj "function.outer" nil t))
      :nv "[M" (cmd! (evil-textobj-tree-sitter-goto-textobj "function.outer" t t))
      :nv "]]" (cmd! (evil-textobj-tree-sitter-goto-textobj "class.outer"))
      :nv "[[" (cmd! (evil-textobj-tree-sitter-goto-textobj "class.outer" t))
      :nv "][" (cmd! (evil-textobj-tree-sitter-goto-textobj "class.outer" nil t))
      :nv "[]" (cmd! (evil-textobj-tree-sitter-goto-textobj "class.outer" t t)))

(use-package! evil-little-word
  :after evil
  :config
  (map! :nv "w"  #'evil-forward-little-word-begin
        :nv "b"  #'evil-backward-little-word-begin
        :nv "ge" #'evil-backward-little-word-end
        :nv "e"  #'evil-forward-little-word-end))

;; Use :nv instead of :m for flycheck navigation
(map! :nv "]q" #'flycheck-next-error
      :nv "[q" #'flycheck-previous-error)

(map! :leader
      :n "1" #'harpoon-go-to-1
      :n "2" #'harpoon-go-to-2
      :n "3" #'harpoon-go-to-3
      :n "4" #'harpoon-go-to-4
      :n "5" #'harpoon-go-to-5
      :n "6" #'harpoon-go-to-6
      :n "7" #'harpoon-go-to-7
      :n "8" #'harpoon-go-to-8
      :n "9" #'harpoon-go-to-9
      (:prefix-map ("H" . "harpoon")
       :desc "Quick menu"     "H" #'harpoon-quick-menu-hydra
       :desc "Add file"        "a" #'harpoon-add-file
       :desc "Next file"       "n" #'harpoon-go-to-next
       :desc "Previous file"   "p" #'harpoon-go-to-prev
       :desc "Clear"           "c" #'harpoon-clear))

(defface +yank-pulse-face
  '((t :background "#ffc4a8" :foreground "#1a1a1a" :weight bold))
  "Face for pulsing yanked text (nvim CustomYank parity).")

(defadvice! +yank-pulse-a (beg end type &rest _)
  :after #'evil-yank
  (when (and (numberp beg) (numberp end) (< beg end))
    (pulse-momentary-highlight-region beg end '+yank-pulse-face)))

(add-hook 'restclient-mode-hook
          (defun +rest--spc-i-toggle-h ()
            (evil-local-set-key 'normal (kbd "SPC i") #'+popup/toggle)))

(use-package! evil-nerd-commenter
  :after evil
  :config
  (setq evil-nerd-commenter-show-description t
        evil-nerd-commenter-jump-after-toggling-comment nil))

(after! apheleia
  (setf (alist-get 'go-ts-mode apheleia-mode-alist) '(goimports gofumpt)
        (alist-get 'go-mode apheleia-mode-alist) '(goimports gofumpt)
        (alist-get 'python-ts-mode apheleia-mode-alist) '(isort black)
        (alist-get 'python-mode apheleia-mode-alist) '(isort black)
        (alist-get 'markdown-mode apheleia-mode-alist) 'prettier-markdown
        (alist-get 'gfm-mode apheleia-mode-alist) 'prettier-markdown))

;; ============================================================================
;; FLASH JUMP & CUSTOM MATCH LABEL FACES (CATPPUCCIN PARITY)
;; ============================================================================
(use-package! flash
  :init
  (with-eval-after-load 'evil
    (require 'flash-evil)
    (flash-evil-setup t))
  :config
  (map! :nv "s" #'flash-jump))

;; 1. Disable evil-snipe's 1-character overrides completely
(setq evil-snipe-override-2-char-subst nil)

(after! evil-snipe
  ;; Turn off override mode globally
  (evil-snipe-override-mode -1)

  ;; Unbind s and S from all evil-snipe internal maps
  (define-key evil-snipe-mode-map (kbd "s") nil)
  (define-key evil-snipe-mode-map (kbd "S") nil)
  (define-key evil-snipe-override-mode-map (kbd "s") nil)
  (define-key evil-snipe-override-mode-map (kbd "S") nil))

;; 2. Force flash-jump over normal and visual states using evil-snipe's map explicitly
(map! (:map evil-snipe-local-mode-map
        :n "s" #'flash-jump
        :v "s" #'flash-jump)
      (:nv
        "s" #'flash-jump))

;; Customize Flash label appearance to match Catppuccin accents
(custom-set-faces!
 '(flash-match :background "#f38ba8" :foreground "#11111b" :weight bold)
 '(flash-label :background "#fab387" :foreground "#11111b" :weight bold))

;; Remap evil-surround to 'gz' and 'S' to free up 's' for flash-jump
(after! evil-surround
  (define-key evil-normal-state-map (kbd "gz") #'evil-surround-edit)
  (define-key evil-visual-state-map (kbd "S")  #'evil-surround-region))

(after! org
  (setq org-hide-emphasis-markers t
        org-pretty-entities t))

(use-package! org-appear
  :after org
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autolinks t))

(use-package! emmet-mode
  :hook ((html-mode
          web-mode
          css-mode
          scss-mode
          js-jsx-mode
          typescript-tsx-mode) . emmet-mode)
  :config
  (setq emmet-expand-jsx-className? t)
  (add-to-list 'emmet-jsx-major-modes 'js-jsx-mode)
  (add-to-list 'emmet-jsx-major-modes 'typescript-tsx-mode)
  (map! :map emmet-mode-keymap
        :i "<tab>" #'emmet-expand-line
        :i "C-j" #'emmet-expand-line))

;; ============================================================================
;; 5. COMPLETION & SNIPPETS (CORFU + CAPE + YASNIPPET)
;; ============================================================================
(after! yasnippet
  (yas-global-mode 1)
  (map! :map yas-keymap
        "C-M-l" #'yas-next-field
        "C-M-h" #'yas-prev-field))

(use-package! yasnippet-snippets
  :after yasnippet
  :config (yasnippet-snippets-initialize))

(after! yasnippet-capf
  (setq yasnippet-capf-lookup-by 'name))

(after! corfu
  (setq corfu-auto nil
        corfu-cycle t
        corfu-preselect 'first)

  (defun brandon/corfu-accept-and-expand ()
    "Accept current Corfu selection with C-y and expand if it's a YASnippet."
    (interactive)
    (when (corfu-insert)
      (when (bound-and-true-p yas-minor-mode)
        (yas-expand))))

  (map! :map corfu-map
        "C-n"    #'corfu-next
        "C-p"    #'corfu-previous
        "<down>" #'corfu-next
        "<up>"   #'corfu-previous
        "C-y"    #'brandon/corfu-accept-and-expand
        "C-e"    #'corfu-quit
        "C-SPC"  #'corfu-complete))

(use-package! cape
  :after (corfu yasnippet-capf)
  :init
  (defun brandon/setup-merged-completion-sources ()
    "Aggregate Eglot, YASnippet, Buffer words, and File paths into Corfu."
    (setq-local completion-at-point-functions
                (list
                 (cape-super-capf
                  #'yasnippet-capf
                  #'cape-dabbrev
                  #'cape-file)
                 #'cape-keyword)))

  (add-hook 'prog-mode-hook #'brandon/setup-merged-completion-sources)
  (add-hook 'text-mode-hook #'brandon/setup-merged-completion-sources))

(after! eglot
  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              (add-to-list 'completion-at-point-functions
                           (cape-super-capf
                            #'eglot-completion-at-point
                            #'yasnippet-capf
                            #'cape-dabbrev)))))

;; ============================================================================
;; 6. DIRVISH (OIL.NVIM EQUIVALENT) & CONSULT PICKERS
;; ============================================================================
(use-package! dired-x)

(after! dirvish
  (dirvish-override-dired-mode)

  (setq dirvish-hide-details nil
        dirvish-default-layout '(0 0.4 0.6)
        dirvish-attributes '(nerd-icons file-time file-size collapse subtree-state)
        delete-by-moving-to-trash t
        dired-omit-files "^\\.[^.]")

  (add-hook 'dired-mode-hook #'dired-omit-mode)

  (map! :n "-" #'dirvish
        :map dirvish-mode-map
        "g?"  #'dirvish-dispatch
        "RET" #'dired-find-file
        "L"   #'dired-find-file
        "-"   #'dirvish-up-dir
        "E"   #'revert-buffer
        "g."  #'dired-omit-mode
        "gx"  #'browse-url-of-file
        "C-v" #'dired-find-file-other-window
        "C-x" #'dired-do-async-shell-command
        "q"   #'quit-window))

(map! :n "-" #'dirvish)

(after! evil
  (evil-set-initial-state 'compilation-mode 'normal)
  (evil-set-initial-state 'comint-mode 'normal))

(map! :leader
      :desc "Find files"          "<space>" #'consult-find
      :desc "Buffers"             ","       #'consult-buffer
      :desc "Grep project"        "/"       #'consult-grep
      :desc "Find git files"      "fg"      #'projectile-find-file
      :desc "Recent files"        "fr"      #'consult-recent-file

      (:prefix ("s" . "search")
       :desc "Buffer lines"       "b"       #'consult-line
       :desc "Grep open buffers"  "B"       #'consult-keep-lines
       :desc "Grep"               "g"       #'consult-ripgrep
       :desc "Command history"    "c"       #'consult-complex-command
       :desc "Help pages"         "h"       #'consult-help
       :desc "Jumps"              "j"       #'consult-mark
       :desc "Keymaps"            "k"       #'describe-keymap
       :desc "Quickfix list"      "q"       #'consult-compile-error
       :desc "Diagnostics"        "d"       #'consult-flycheck)

      (:prefix ("g" . "goto")
       :desc "Goto definition"     "d"      #'xref-find-definitions
       :desc "Goto references"     "r"      #'xref-find-references
       :desc "Goto implementation" "i"      #'xref-find-apropos
       :desc "Document symbols"    "O"      #'consult-imenu)

      (:prefix ("c" . "code")
       :desc "Code actions"        "a"      #'eglot-code-actions))

;; ============================================================================
;; 7. FZF-LUA PARITY KEYMAPS (MAPPED TO CONSULT / PROJECTILE / EGLOT)
;; ============================================================================
(map! :leader
      ;; Core pickers & file history
      :desc "Buffers"             ","      #'consult-buffer
      :desc "Grep project"        "/"      #'consult-grep
      :desc "Command History"     ":"      #'consult-complex-command
      :desc "Find files"          " <space>" #'consult-find
      :desc "Buffers"             "b b"    #'consult-buffer
      :desc "Find Config File"    "f c"    (cmd! (find-file (expand-file-name "config.el" doom-user-dir)))
      :desc "Find Files"          "s f"    #'consult-find
      :desc "Find Git Files"      "f g"    #'projectile-find-file
      :desc "Recent Files"        "f r"    #'consult-recent-file

      ;; Git Actions (using Magit / Projectile equivalents)
      (:prefix ("g" . "git")
       :desc "Git status"         "s"      #'magit-status
       :desc "Git log/commits"    "c"      #'magit-log-current)

      ;; Search Prefix Group
      (:prefix ("s" . "search")
       :desc "Buffer lines"       "b"      #'consult-line
       :desc "Grep open buffers"  "B"      #'consult-keep-lines
       :desc "Grep project"       "g"      #'consult-ripgrep
       :desc "Command history"    "c"      #'consult-complex-command
       :desc "Help pages"         "h"      #'consult-help
       :desc "Jumps"              "j"      #'consult-mark
       :desc "Keymaps"            "k"      #'describe-keymap
       :desc "Quickfix list"      "q"      #'consult-compile-error
       :desc "Diagnostics"        "d"      #'consult-flycheck
       :desc "Document Symbols"   "s"      #'consult-imenu)

      ;; Code & LSP Prefix Group
      (:prefix ("c" . "code")
       :desc "Code actions"       "a"      #'eglot-code-actions
       :desc "Incoming calls"     "i"      #'eglot-find-implementation
       :desc "Outgoing calls"     "o"      #'eglot-find-implementation))

;; Global Normal-mode LSP / Navigation Parity
(map! :n "gd" #'xref-find-definitions
      :n "gD" #'xref-find-declarations
      :n "gr" #'xref-find-references
      :n "gi" #'xref-find-apropos
      :n "gO" #'consult-imenu)

;; ============================================================================
;; 8. GIT GUTTER / GITSIGNS (DIFF-HL)
;; ============================================================================
(use-package! diff-hl
  :hook ((prog-mode . turn-on-diff-hl-mode)
         (text-mode . turn-on-diff-hl-mode)
         (dired-mode . diff-hl-dired-mode))
  :config
  (global-diff-hl-mode +1)
  (diff-hl-flydiff-mode +1)
  (add-hook 'magit-pre-refresh-hook #'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh))

(map! :n "]c" #'diff-hl-next-hunk
      :n "[c" #'diff-hl-previous-hunk
      :leader
      (:prefix ("g" . "git")
       :desc "Next hunk"       "n" #'diff-hl-next-hunk
       :desc "Prev hunk"       "p" #'diff-hl-previous-hunk
       :desc "Stage hunk"      "s" #'diff-hl-stage-current-hunk
       :desc "Revert hunk"     "r" #'diff-hl-revert-hunk
       :desc "Preview hunk"    "v" #'diff-hl-show-hunk))

;; ============================================================================
;; 9. CUSTOM XWIDGET USER COMMANDS & MAPPINGS
;; ============================================================================
(defun brandon/open-browser (url)
  "Open URL in the current window using xwidget-webkit."
  (interactive "sURL: ")
  (let ((full-url (if (string-match-p "^https?://" url)
                      url
                    (concat "https://" url))))
    (xwidget-webkit-browse-url full-url)))

(defun brandon/open-browser-split (url)
  "Open URL in a new vertical split using xwidget-webkit."
  (interactive "sURL: ")
  (let ((full-url (if (string-match-p "^https?://" url)
                      url
                    (concat "https://" url))))
    (select-window (split-window-sensibly))
    (xwidget-webkit-browse-url full-url)))

(after! evil
  (evil-ex-define-cmd "web"  #'brandon/open-browser)
  (evil-ex-define-cmd "vweb" #'brandon/open-browser-split))

(after! xwidget-internal
  (evil-set-initial-state 'xwidget-webkit-mode 'emacs)

  (map! :map xwidget-webkit-mode-map
        :e "C-z"   #'evil-normal-state
        :n "SPC e" #'xwidget-webkit-edit-mode
        :n "q"     #'kill-current-buffer
        :n "C-h"   #'evil-window-left
        :n "C-j"   #'evil-window-down
        :n "C-k"   #'evil-window-up
        :n "C-l"   #'evil-window-right))

(defun brandon/open-pdf-xwidget (file-path)
  "Open a local PDF file using xwidget-webkit."
  (interactive "fPDF File: ")
  (let* ((absolute-path (expand-file-name file-path))
         (file-uri (concat "file://" absolute-path)))
    (xwidget-webkit-browse-url file-uri)))

(after! evil
  (evil-ex-define-cmd "pdf" #'brandon/open-pdf-xwidget))

;; ============================================================================
;; RELIABLE PDF-TO-XWIDGET INTERCEPTOR
;; ============================================================================
(defun brandon/open-pdf-in-xwidget-a (filename &rest _)
  "Intercept PDF file openings and render them natively via xwidget-webkit."
  (when (and filename (string-match-p "\\.pdf\\'" filename))
    ;; Cancel normal file loading by throwing out of find-file
    (let ((file-uri (concat "file://" (expand-file-name filename))))
      (run-at-time 0.0 nil #'xwidget-webkit-browse-url file-uri)
      (signal 'quit nil))))

(advice-add #'find-file :before #'brandon/open-pdf-in-xwidget-a)

;; ============================================================================
;; GIT GUTTER / GITSIGNS FRINGE FIX
;; ============================================================================
(after! diff-hl
  ;; Enable diff-hl fringe mode globally
  (global-diff-hl-mode +1)
  (diff-hl-flydiff-mode +1)
  
  ;; Refresh diff indicators on Magit actions
  (add-hook 'magit-pre-refresh-hook #'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh))

;; Auto-enable diff-hl in code & text buffers
(add-hook 'prog-mode-hook #'turn-on-diff-hl-mode)
(add-hook 'text-mode-hook #'turn-on-diff-hl-mode)

;; ============================================================================
;; MASON.EL & EGLOT INTEGRATION
;; ============================================================================
(use-package! mason
  :config
  (mason-setup)
  ;; Automatically add Mason's bin directory to Emacs' execution PATH
  ; (add-to-list 'exec-path (expand-file-name "~/.config/emacs/.local/etc/mason/bin")))
  (add-to-list 'exec-path (expand-file-name "~/.local/share/nvim/mason/bin")))

(after! eglot
  (add-to-list 'eglot-server-programs '(python-mode . ("basedpyright-langserver" "--stdio")))
  (add-to-list 'eglot-server-programs '(python-ts-mode . ("basedpyright-langserver" "--stdio"))))

;; ============================================================================
;; EGLOT UI STABILIZATION
;; ============================================================================
(after! eglot
  ;; Increase idle delay so eldoc doesn't thrash on every keystroke
  (setq eldoc-idle-delay 0.5
        ;; Prevent eldoc from expanding the echo area into multi-line jumps
        eldoc-echo-area-use-multiline-p nil
        ;; Disable heavy event logging to improve performance
        eglot-events-buffer-size 0)

  ;; Optional: disable automatic signature help popups if they still cause jitter
  (setq eglot-send-changes-idle-delay 0.5))

(after! evil
  ;; Free up [ and ] in insert mode so they never hang waiting for chords
  (define-key evil-insert-state-map (kbd "[") nil)
  (define-key evil-insert-state-map (kbd "]") nil))

(after! project
  (setq project-vc-extra-root-markers '(".project" "pyproject.toml" "Cargo.toml" "package.json")))

(add-hook 'python-mode-hook #'turn-on-font-lock)
