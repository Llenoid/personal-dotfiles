from kittens.tui.handler import result_handler

TERMINAL_PREFIX = "BOTTOM_TERMINAL::"

# Resize amounts may need tuning for your font/window size
HIDE_INCREMENT = -100
SHOW_INCREMENT = 100


def main(args):
    pass


def terminal_title(tab):
    return f"{TERMINAL_PREFIX}{tab.id}"


def find_bottom_terminal(tab):
    tab_id = str(tab.id)

    for window in tab.windows:
        user_vars = getattr(window, "user_vars", {})

        if user_vars.get("bottom_terminal") == tab_id:
            return window

    return None


def resize_window(boss, tab, window_id, increment):
    boss.call_remote_control(
        tab.id,
        [
            "resize_window",
            "--match",
            f"id:{window_id}",
            "--axis",
            "vertical",
            "--increment",
            str(increment),
        ],
    )


def create_bottom_terminal(boss, tab):
    return boss.launch(
 "--var",
    f"bottom_terminal={tab.id}",
    "--cwd=current",
    "--location=hsplit",
    "--bias",
    "30",
    )


def is_hidden(window):
    """
    We encode hidden state into the title.

    BOTTOM_TERMINAL::5
    BOTTOM_TERMINAL::5::HIDDEN
    """
    return window.title.endswith("::HIDDEN")


def mark_hidden(boss, window):
    boss.call_remote_control(
        window.tabref().id,
        [
            "set_window_title",
            "--match",
            f"id:{window.id}",
            window.title + "::HIDDEN",
        ],
    )


def mark_visible(boss, window):
    title = window.title.removesuffix("::HIDDEN")

    boss.call_remote_control(
        window.tabref().id,
        [
            "set_window_title",
            "--match",
            f"id:{window.id}",
            title,
        ],
    )


def toggle_term(boss):
    tab = boss.active_tab

    if tab is None:
        return

    terminal = find_bottom_terminal(tab)

    #
    # First invocation: create terminal
    #
    if terminal is None:
        create_bottom_terminal(boss, tab)
        return

    if is_hidden(terminal):
        resize_window(
            boss,
            tab,
            terminal.id,
            SHOW_INCREMENT,
        )

        mark_visible(boss, terminal)

        try:
            tab.set_active_window(terminal)
        except Exception:
            pass

    else:
        resize_window(
            boss,
            tab,
            terminal.id,
            HIDE_INCREMENT,
        )

        mark_hidden(boss, terminal)

        try:
            tab.neighboring_window("top")
        except Exception:
            pass


@result_handler(no_ui=True)
def handle_result(args, result, target_window_id, boss):
    if boss.window_id_map.get(target_window_id):
        toggle_term(boss)
