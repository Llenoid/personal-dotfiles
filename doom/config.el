;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
(setq doom-font (font-spec :family "monospace" :size 20))

;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
;; Specify both a dark and light theme, like so and Doom will choose which one
;; to load based on your system light/dark setting:
;;
;;   (setq doom-theme '(doom-one   . doom-one-light))   ; (DARK . LIGHT)
;;
;; If you want more pro-active theme switching based on OS light/dark mode, look
;; up the `auto-dark' package.

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(use-package! dired-preview)

(map! :leader
      :map dired-mode-map
      "P" #'dired-preview-mode)

(use-package! evil-textobj-tree-sitter
  :after evil
  :config
  (define-key evil-inner-text-objects-map "F"
    (evil-textobj-tree-sitter-get-textobj "function.inner"))
  (define-key evil-outer-text-objects-map "F"
    (evil-textobj-tree-sitter-get-textobj "function.outer")))
  (define-key evil-inner-text-objects-map "C"
    (evil-textobj-tree-sitter-get-textobj "class.inner"))
  (define-key evil-outer-text-objects-map "C"
    (evil-textobj-tree-sitter-get-textobj "class.outer"))
  (define-key evil-inner-text-objects-map "P"
    (evil-textobj-tree-sitter-get-textobj "parameter.inner"))
  (define-key evil-outer-text-objects-map "P"
    (evil-textobj-tree-sitter-get-textobj "parameter.outer"))


(map! :n "g]p"
      (cmd! (evil-textobj-tree-sitter-goto-textobj "parameter.outer"))
      :n "g[p"
      (cmd! (evil-textobj-tree-sitter-goto-textobj "parameter.outer" t)))

;; Company
(after! company
  (define-key company-active-map (kbd "C-y") #'company-complete-selection))

;; Or Corfu
(after! corfu
  (define-key corfu-map (kbd "C-y") #'corfu-insert))

;; Map C-h/j/k/l to Evil window navigation in Normal mode
(map! :n "C-h" #'evil-window-left
      :n "C-j" #'evil-window-down
      :n "C-k" #'evil-window-up
      :n "C-l" #'evil-window-right)

(use-package! flash
  :init
  (with-eval-after-load 'evil
    (require 'flash-evil)
    (flash-evil-setup t))) ;; Configures gs / f / t motions

(after! avy
  ;; Search across all visible windows in the current frame
  (setq avy-all-windows t)

  ;; Alternatively, search across ALL frames/monitors:
  ;; (setq avy-all-windows 'all-frames)

  ;; Show labels on the first character rather than at the end of matches
  (setq avy-style 'at-full)

  ;; Enable background dimming when Avy activates for better contrast
  (setq avy-background t)

  ;; Customize the decision timeout for char-timer (in seconds, default 0.5)
  (setq avy-timeout-seconds 0.35))

;; Map `s` in Normal and Visual mode to avy timer jump (Flash style)
(map! :nv "s" #'avy-goto-char-timer)

; (after! markdown-mode
;   (map! :map markdown-mode-map
;         :localleader
;         :desc "GitHub markdown preview (Grip)" "g" #'grip-mode))
;
; (after! markdown-mode
;   (map! :map markdown-mode-map
;         :localleader
;         :desc "GitHub markdown preview (Grip)" "g" #'grip-mode))
;
; (defun brandon/markdown-preview-vsplit ()
;   "Start Grip preview server and open it in a vertical xwidget split."
;   (interactive)
;   (unless (bound-and-true-p grip-mode)
;     (grip-mode 1))
;   ;; Wait briefly for local grip server to bind (default http://localhost:6419)
;   (run-with-timer 1.5 nil
;                   (lambda ()
;                     (let ((url (grip-preview-url)))
;                       (select-window (split-window-right))
;                       (xwidget-webkit-browse-url url)))))
;
; (after! markdown-mode
;   (map! :map markdown-mode-map
;         :localleader
;         :desc "VS Code style preview" "v" #'brandon/markdown-preview-vsplit))

(after! org
  ;; Hide markup markers (*, /, _, ~) until cursor enters them
  (setq org-hide-emphasis-markers t)
  
  ;; Automatically render entities (like math symbols or sub/superscripts)
  (setq org-pretty-entities t))

;; Enable org-appear for dynamic inline visibility toggling
(use-package! org-appear
  :after org
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autolinks t))

;; --- Ported from neovim using gemini

;;; config.el -*- lexical-binding: t; -*-

;; ============================================================================
;; 1. GENERAL OPTIONS & APPEARANCE
;; ============================================================================
(setq doom-theme 'catppuccin)

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

;; ============================================================================
;; 2. AUTOCMDS & HOOKS
;; ============================================================================
;; Auto-create parent directories on save
(defun brandon/auto-create-non-existent-directory ()
  (let ((parent-dir (file-name-directory (buffer-file-name))))
    (when (and parent-dir (not (file-exists-p parent-dir)))
      (make-directory parent-dir t))))
(add-hook 'before-save-hook #'brandon/auto-create-non-existent-directory)

;; Docker Compose filetype detection
(add-to-list 'auto-mode-alist '("docker-compose.*\\.ya?ml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("compose.*\\.ya?ml\\'" . yaml-mode))

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
      :desc "Split window vertically"   "|" #'evil-window-vsplit
      :desc "Split window horizontally" "_" #'evil-window-split
      :desc "Delete window"             "d" #'evil-window-delete)

;; Window Resizing
(map! :n "<C-up>"    #'enlarge-window
      :n "<C-down>"  #'shrink-window
      :n "<C-left>"  #'shrink-window-horizontally
      :n "<C-right>" #'enlarge-window-horizontally)

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
      :n "SPC e" #'flycheck-explain-error
      :n "SPC q" #'flycheck-list-errors)

;; ============================================================================
;; 4. OIL.NVIM REPLACEMENT (DIRVISH)
;; ============================================================================
(after! dirvish
  (dirvish-override-dired-mode)
  (setq dirvish-hide-details nil
        dirvish-default-layout '(0 0.4 0.6))
  (map! :n "-" #'dirvish
        :map dirvish-mode-map
        "H"   #'dirvish-up-dir
        "L"   #'dired-find-file
        "q"   #'quit-window))

;; ============================================================================
;; 5. COMPLETION (CORFU + CAPE + YASNIPPET)
;; ============================================================================
(after! corfu
  (setq corfu-auto nil
        corfu-cycle t
        corfu-preselect 'prompt)
  (map! :map corfu-map
        "C-n" #'corfu-next
        "C-p" #'corfu-previous
        "<down>" #'corfu-next
        "<up>" #'corfu-previous
        "C-y" #'corfu-insert
        "C-e" #'corfu-quit
        "C-SPC" #'corfu-complete))

(use-package! cape
  :init
  (add-hook! 'completion-at-point-functions #'cape-file)
  (add-hook! 'completion-at-point-functions #'cape-buffer))

(after! yasnippet
  (yas-global-mode 1)
  (map! :map yas-keymap
        "C-M-l" #'yas-next-field
        "C-M-h" #'yas-prev-field))

;; ============================================================================
;; 6. FZF-LUA / CONSULT PROJECT & LSP PICKERS
;; ============================================================================
(map! :leader
      :desc "Find files"         "<space>" #'consult-find
      :desc "Buffers"            ","       #'consult-buffer
      :desc "Grep project"       "/"       #'consult-grep
      :desc "Find git files"     "fg"      #'projectile-find-file
      :desc "Recent files"       "fr"      #'consult-recent-file

      ;; Search prefix (`SPC s ...`)
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

      ;; Goto prefix (`SPC g ...`)
      (:prefix ("g" . "goto")
        :desc "Goto definition"     "d"      #'lsp-find-definition
        :desc "Goto declaration"    "D"      #'lsp-find-declaration
        :desc "Goto references"     "r"      #'lsp-find-references
        :desc "Goto implementation" "i"      #'lsp-find-implementation
        :desc "Document symbols"    "O"      #'lsp-document-symbol
        :desc "Workspace symbols"   "W"      #'lsp-workspace-symbol)

      ;; Code prefix (`SPC c ...`)
      (:prefix ("c" . "code")
        :desc "Code actions"        "a"      #'lsp-execute-code-action))
